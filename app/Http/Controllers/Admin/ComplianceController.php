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
        $largeTransactions = Transaction::with('user')
            ->where('amount_in_eur', '>', 10000)
            ->where('created_at', '>=', Carbon::now()->subDays(30))
            ->orderByDesc('amount_in_eur')
            ->limit(20)
            ->get();

        // Users with high transaction frequency (>10 per day)
        $highFrequency = [];
        try {
            $highFrequency = \DB::table('transactions')
                ->select('user_id', \DB::raw('DATE(created_at) as day'), \DB::raw('COUNT(*) as tx_count'), \DB::raw('SUM(amount_in_eur) as total_volume'))
                ->where('created_at', '>=', Carbon::now()->subDays(7))
                ->groupBy('user_id', 'day')
                ->having('tx_count', '>', 10)
                ->orderByDesc('tx_count')
                ->limit(20)
                ->get();

            foreach ($highFrequency as &$row) {
                $row->user = User::find($row->user_id);
            }
        } catch (\Exception $e) {
        }

        // Rapid succession transactions (same user, <1 min apart)
        $rapidTransactions = [];
        try {
            $rapidTransactions = \DB::select("
                SELECT t1.id, t1.user_id, t1.amount_in_eur, t1.type, t1.created_at,
                       TIMESTAMPDIFF(SECOND, t2.created_at, t1.created_at) as seconds_apart
                FROM transactions t1
                INNER JOIN transactions t2 ON t1.user_id = t2.user_id AND t1.id != t2.id
                    AND ABS(TIMESTAMPDIFF(SECOND, t1.created_at, t2.created_at)) < 60
                    AND t1.id > t2.id
                WHERE t1.created_at >= ?
                ORDER BY t1.created_at DESC LIMIT 20
            ", [Carbon::now()->subDays(7)]);

            foreach ($rapidTransactions as &$row) {
                $row->user = User::find($row->user_id);
            }
        } catch (\Exception $e) {
        }

        // Unverified users with transactions
        $unverifiedWithTx = User::where('role', 'customer')
            ->where('kyc_status', '!=', 'verified')
            ->whereHas('transactions')
            ->with(['transactions' => fn($q) => $q->latest()->limit(1)])
            ->limit(15)
            ->get();

        $stats = [
            'large_tx_count' => count($largeTransactions),
            'high_freq_count' => count($highFrequency),
            'rapid_count' => count($rapidTransactions),
            'unverified_with_tx' => count($unverifiedWithTx),
        ];

        return Inertia::render('Admin/Compliance', [
            'largeTransactions' => $largeTransactions,
            'highFrequency' => $highFrequency,
            'rapidTransactions' => $rapidTransactions,
            'unverifiedWithTx' => $unverifiedWithTx,
            'stats' => $stats,
        ]);
    }
}
