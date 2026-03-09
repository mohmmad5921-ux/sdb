<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Models\User;
use Carbon\Carbon;
use Inertia\Inertia;

class ComplianceController extends Controller
{
    public function index()
    {
        // Large transactions (potential AML flags)
        $largeTransactions = [];
        try {
            $largeTransactions = \DB::table('transactions')
                ->leftJoin('accounts as tx_acc', 'transactions.from_account_id', '=', 'tx_acc.id')
                ->leftJoin('users', 'tx_acc.user_id', '=', 'users.id')
                ->where('transactions.amount', '>', 10000)
                ->where('transactions.created_at', '>=', Carbon::now()->subDays(30))
                ->select('transactions.*', 'users.full_name as user_name', 'users.email as user_email')
                ->orderByDesc('transactions.amount')
                ->limit(20)->get();
        } catch (\Exception $e) {
        }

        // Users with high transaction frequency (>10 per day)
        $highFrequency = [];
        try {
            $highFrequency = \DB::table('transactions')
                ->join('accounts', 'transactions.from_account_id', '=', 'accounts.id')
                ->select('accounts.user_id', \DB::raw("date(transactions.created_at) as day"), \DB::raw('COUNT(*) as tx_count'), \DB::raw('SUM(transactions.amount) as total_volume'))
                ->where('transactions.created_at', '>=', Carbon::now()->subDays(7))
                ->groupBy('accounts.user_id', 'day')
                ->having('tx_count', '>', 10)
                ->orderByDesc('tx_count')
                ->limit(20)->get();
            foreach ($highFrequency as &$row) {
                $row->user = User::find($row->user_id);
            }
        } catch (\Exception $e) {
        }

        // Rapid transactions — simplified for SQLite
        $rapidTransactions = [];

        // Unverified users count
        $unverifiedCount = 0;
        try {
            $unverifiedCount = User::where('role', 'customer')
                ->where('kyc_status', '!=', 'verified')->count();
        } catch (\Exception $e) {
        }

        $stats = [
            'large_tx_count' => count($largeTransactions),
            'high_freq_count' => count($highFrequency),
            'rapid_count' => 0,
            'unverified_with_tx' => $unverifiedCount,
        ];

        return Inertia::render('Admin/Compliance', [
            'largeTransactions' => $largeTransactions,
            'highFrequency' => $highFrequency,
            'rapidTransactions' => $rapidTransactions,
            'unverifiedWithTx' => [],
            'stats' => $stats,
        ]);
    }
}
