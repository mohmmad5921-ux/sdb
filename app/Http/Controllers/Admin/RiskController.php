<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Models\User;
use App\Models\Account;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Inertia\Inertia;

class RiskController extends Controller
{
    public function index(Request $request)
    {
        // Suspicious transactions: large amounts, unusual patterns
        $threshold = 10000; // transactions above this considered high-risk

        $largeTransactions = Transaction::with(['fromAccount.user', 'toAccount.user', 'currency'])
            ->where('amount', '>=', $threshold)
            ->orderByDesc('created_at')
            ->limit(50)
            ->get()
            ->map(function ($t) use ($threshold) {
                $riskScore = 0;
                $flags = [];

                // Large amount
                if ($t->amount >= $threshold * 5) { $riskScore += 40; $flags[] = 'مبلغ كبير جداً'; }
                elseif ($t->amount >= $threshold) { $riskScore += 20; $flags[] = 'مبلغ كبير'; }

                // Failed then succeeded
                if ($t->status === 'completed') {
                    $failedCount = Transaction::where('from_account_id', $t->from_account_id)
                        ->where('status', 'failed')
                        ->where('created_at', '>=', Carbon::now()->subHours(24))
                        ->count();
                    if ($failedCount > 2) { $riskScore += 30; $flags[] = $failedCount . ' محاولات فاشلة سابقة'; }
                }

                // Multiple transactions same day
                $sameDay = Transaction::where('from_account_id', $t->from_account_id)
                    ->whereDate('created_at', $t->created_at)
                    ->count();
                if ($sameDay > 5) { $riskScore += 20; $flags[] = $sameDay . ' معاملة في نفس اليوم'; }

                // New account (less than 7 days)
                $user = $t->fromAccount?->user;
                if ($user && Carbon::parse($user->created_at)->diffInDays(Carbon::now()) < 7) {
                    $riskScore += 15; $flags[] = 'حساب جديد (أقل من 7 أيام)';
                }

                $t->risk_score = min($riskScore, 100);
                $t->risk_flags = $flags;
                $t->risk_level = $riskScore >= 60 ? 'high' : ($riskScore >= 30 ? 'medium' : 'low');
                return $t;
            })
            ->sortByDesc('risk_score')
            ->values();

        // Users with suspicious activity
        $suspiciousUsers = User::where('role', 'customer')
            ->where(function ($q) {
                $q->where('status', 'suspended')
                    ->orWhere('status', 'blocked');
            })
            ->limit(20)
            ->get();

        // Frozen accounts
        $frozenAccounts = Account::with(['user', 'currency'])
            ->where('status', 'frozen')
            ->limit(20)
            ->get();

        // Summary stats
        $stats = [
            'high_risk_tx' => $largeTransactions->where('risk_level', 'high')->count(),
            'medium_risk_tx' => $largeTransactions->where('risk_level', 'medium')->count(),
            'suspended_users' => User::where('role', 'customer')->where('status', 'suspended')->count(),
            'blocked_users' => User::where('role', 'customer')->where('status', 'blocked')->count(),
            'frozen_accounts' => Account::where('status', 'frozen')->count(),
            'failed_tx_today' => Transaction::where('status', 'failed')->whereDate('created_at', today())->count(),
            'large_tx_today' => Transaction::where('amount', '>=', $threshold)->whereDate('created_at', today())->count(),
            'pending_kyc' => User::where('kyc_status', 'submitted')->count(),
        ];

        return Inertia::render('Admin/RiskCompliance', [
            'largeTransactions' => $largeTransactions,
            'suspiciousUsers' => $suspiciousUsers,
            'frozenAccounts' => $frozenAccounts,
            'stats' => $stats,
            'threshold' => $threshold,
        ]);
    }
}