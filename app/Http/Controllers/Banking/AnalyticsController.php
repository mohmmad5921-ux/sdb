<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Inertia\Inertia;

class AnalyticsController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        $accountIds = $user->accounts()->pluck('id');

        // Monthly totals (last 6 months)
        $monthlyData = [];
        for ($i = 5; $i >= 0; $i--) {
            $month = now()->subMonths($i);
            $monthKey = $month->format('Y-m');
            $monthLabel = $month->translatedFormat('M Y');

            $income = Transaction::whereIn('to_account_id', $accountIds)
                ->where('status', 'completed')
                ->whereYear('created_at', $month->year)
                ->whereMonth('created_at', $month->month)
                ->sum('amount');

            $expenses = Transaction::whereIn('from_account_id', $accountIds)
                ->where('status', 'completed')
                ->whereYear('created_at', $month->year)
                ->whereMonth('created_at', $month->month)
                ->sum('amount');

            $monthlyData[] = [
                'month' => $monthLabel,
                'key' => $monthKey,
                'income' => round($income, 2),
                'expenses' => round($expenses, 2),
            ];
        }

        // Spending by type
        $spendingByType = Transaction::whereIn('from_account_id', $accountIds)
            ->where('status', 'completed')
            ->where('created_at', '>=', now()->subDays(30))
            ->selectRaw('type, SUM(amount) as total, COUNT(*) as count')
            ->groupBy('type')
            ->get()
            ->map(fn($t) => ['type' => $t->type, 'total' => round($t->total, 2), 'count' => $t->count]);

        // Top recipients
        $topRecipients = Transaction::whereIn('from_account_id', $accountIds)
            ->where('status', 'completed')
            ->whereNotNull('to_account_id')
            ->where('created_at', '>=', now()->subDays(90))
            ->with('toAccount.user')
            ->selectRaw('to_account_id, SUM(amount) as total, COUNT(*) as count')
            ->groupBy('to_account_id')
            ->orderByDesc('total')
            ->limit(5)
            ->get()
            ->map(fn($t) => [
                'name' => $t->toAccount?->user?->full_name ?? 'Unknown',
                'total' => round($t->total, 2),
                'count' => $t->count,
            ]);

        // Balance history (daily, last 30 days)
        $accounts = $user->accounts()->with('currency')->get();
        $currentBalance = $accounts->sum('balance');

        return Inertia::render('Banking/Analytics', [
            'monthlyData' => $monthlyData,
            'spendingByType' => $spendingByType,
            'topRecipients' => $topRecipients,
            'currentBalance' => round($currentBalance, 2),
            'accounts' => $accounts,
        ]);
    }
}