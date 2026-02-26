<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Account;
use App\Models\Card;
use App\Models\Transaction;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ReportsController extends Controller
{
    public function index(Request $request)
    {
        $period = $request->period ?? '30'; // days
        $startDate = Carbon::now()->subDays((int)$period);

        // Transaction stats by type
        $txByType = Transaction::where('created_at', '>=', $startDate)
            ->selectRaw('type, count(*) as count, sum(amount) as total_amount')
            ->groupBy('type')
            ->get()
            ->keyBy('type');

        // Transaction stats by status
        $txByStatus = Transaction::where('created_at', '>=', $startDate)
            ->selectRaw('status, count(*) as count, sum(amount) as total_amount')
            ->groupBy('status')
            ->get()
            ->keyBy('status');

        // Daily transaction volume for chart (last N days)
        $dailyVolume = [];
        for ($i = min((int)$period, 30) - 1; $i >= 0; $i--) {
            $date = Carbon::today()->subDays($i);
            $dayTx = Transaction::whereDate('created_at', $date);
            $dailyVolume[] = [
                'date' => $date->format('m/d'),
                'count' => (clone $dayTx)->count(),
                'volume' => round((clone $dayTx)->where('status', 'completed')->sum('amount'), 2),
                'fees' => round((clone $dayTx)->sum('fee_amount'), 2),
            ];
        }

        // User growth
        $dailyUsers = [];
        for ($i = min((int)$period, 30) - 1; $i >= 0; $i--) {
            $date = Carbon::today()->subDays($i);
            $dailyUsers[] = [
                'date' => $date->format('m/d'),
                'count' => User::where('role', 'customer')->whereDate('created_at', $date)->count(),
                'cumulative' => User::where('role', 'customer')->where('created_at', '<=', $date->endOfDay())->count(),
            ];
        }

        // Revenue from fees
        $totalFees = Transaction::where('created_at', '>=', $startDate)->sum('fee_amount');
        $totalVolume = Transaction::where('created_at', '>=', $startDate)->where('status', 'completed')->sum('amount');

        // Top users by transaction volume
        $topUsers = User::where('role', 'customer')
            ->withCount(['accounts'])
            ->get()
            ->map(function ($u) use ($startDate) {
            $accountIds = $u->accounts()->pluck('id');
            $u->tx_volume = Transaction::where('created_at', '>=', $startDate)
                ->where(function ($q) use ($accountIds) {
                $q->whereIn('from_account_id', $accountIds)
                    ->orWhereIn('to_account_id', $accountIds);
            }
            )->sum('amount');
            $u->tx_count = Transaction::where('created_at', '>=', $startDate)
                ->where(function ($q) use ($accountIds) {
                $q->whereIn('from_account_id', $accountIds)
                    ->orWhereIn('to_account_id', $accountIds);
            }
            )->count();
            return $u;
        })
            ->sortByDesc('tx_volume')
            ->take(10)
            ->values();

        // Currency distribution
        $currencyDist = Account::with('currency')
            ->selectRaw('currency_id, count(*) as account_count, sum(balance) as total_balance')
            ->groupBy('currency_id')
            ->get()
            ->map(fn($a) => [
        'currency' => $a->currency->code ?? '?',
        'symbol' => $a->currency->symbol ?? '?',
        'accounts' => $a->account_count,
        'balance' => round($a->total_balance, 2),
        ]);

        return Inertia::render('Admin/Reports', [
            'period' => $period,
            'txByType' => $txByType,
            'txByStatus' => $txByStatus,
            'dailyVolume' => $dailyVolume,
            'dailyUsers' => $dailyUsers,
            'totalFees' => round($totalFees, 2),
            'totalVolume' => round($totalVolume, 2),
            'topUsers' => $topUsers,
            'currencyDist' => $currencyDist,
        ]);
    }
}