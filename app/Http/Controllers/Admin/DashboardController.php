<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        $today = Carbon::today();
        $thisMonth = Carbon::now()->startOfMonth();
        $thisYear = Carbon::now()->startOfYear();
        $lastMonth = Carbon::now()->subMonth()->startOfMonth();

        // ══════════════════════════════════════
        // 1. USER METRICS
        // ══════════════════════════════════════
        $totalUsers = DB::table('users')->where('role', '!=', 'admin')->count();
        $newToday = DB::table('users')->where('role', '!=', 'admin')->whereDate('created_at', $today)->count();
        $activeUsers = DB::table('users')->where('role', '!=', 'admin')
            ->where('last_login_at', '>=', Carbon::now()->subDays(30))->count();

        // Users by country
        $usersByCountry = DB::table('users')->where('role', '!=', 'admin')
            ->selectRaw("COALESCE(country, 'Unknown') as country, COUNT(*) as count")
            ->groupBy('country')->orderBy('count', 'desc')->limit(10)->get();

        // Most active users
        $topActiveUsers = DB::table('transactions')
            ->join('accounts', 'transactions.from_account_id', '=', 'accounts.id')->join('users', 'accounts.user_id', '=', 'users.id')
            ->selectRaw("users.id, users.full_name, users.email, COUNT(*) as tx_count, SUM(transactions.amount) as total_volume")
            ->groupBy('users.id', 'users.full_name', 'users.email')
            ->orderBy('tx_count', 'desc')->limit(10)->get();

        // ══════════════════════════════════════
        // 2. ACCOUNT METRICS
        // ══════════════════════════════════════
        $activeAccounts = DB::table('accounts')->where('status', 'active')->count();
        $frozenAccounts = DB::table('accounts')->where('status', 'frozen')->count();
        $totalBalance = DB::table('accounts')->where('status', 'active')->sum('balance');

        // ══════════════════════════════════════
        // 3. TRANSACTION METRICS
        // ══════════════════════════════════════
        $dailyVolume = DB::table('transactions')->whereDate('created_at', $today)->where('status', 'completed')->sum('amount');
        $monthlyVolume = DB::table('transactions')->where('created_at', '>=', $thisMonth)->where('status', 'completed')->sum('amount');
        $yearlyVolume = DB::table('transactions')->where('created_at', '>=', $thisYear)->where('status', 'completed')->sum('amount');

        $successTx = DB::table('transactions')->where('status', 'completed')->count();
        $failedTx = DB::table('transactions')->where('status', 'failed')->count();
        $pendingTx = DB::table('transactions')->where('status', 'pending')->count();

        $internationalTx = DB::table('transactions')->where('type', 'international')->count();
        $localTx = DB::table('transactions')->whereIn('type', ['internal', 'transfer', 'local'])->count();

        // Last 10 transactions
        $recentTransactions = DB::table('transactions')
            ->leftJoin('accounts as tx_acc', 'transactions.from_account_id', '=', 'tx_acc.id')->leftJoin('users', 'tx_acc.user_id', '=', 'users.id')
            ->select('transactions.*', 'users.full_name as user_name', 'users.email as user_email')
            ->orderBy('transactions.created_at', 'desc')->limit(10)->get();

        // ══════════════════════════════════════
        // 4. REVENUE METRICS
        // ══════════════════════════════════════
        $systemProfit = DB::table('transactions')
            ->where('status', 'completed')
            ->whereNotNull('fee')
            ->sum('fee');
        $feesCollected = DB::table('transactions')
            ->whereDate('created_at', '>=', $thisMonth)
            ->where('status', 'completed')
            ->sum('fee');

        // ══════════════════════════════════════
        // 5. CARD METRICS
        // ══════════════════════════════════════
        $totalCards = DB::table('cards')->count();
        $activeCards = DB::table('cards')->where('status', 'active')->count();
        $frozenCards = DB::table('cards')->where('status', 'frozen')->count();

        // ══════════════════════════════════════
        // 6. SECURITY METRICS
        // ══════════════════════════════════════
        $securityAlerts = DB::table('smart_alerts')->where('read', false)->count();
        $suspiciousTx = DB::table('smart_alerts')
            ->where('type', 'suspicious')->where('read', false)->count();

        // ══════════════════════════════════════
        // 7. PENDING ITEMS
        // ══════════════════════════════════════
        $pendingKyc = DB::table('kyc_documents')->where('status', 'pending')->count();
        $pendingApprovals = DB::table('pending_approvals')->where('status', 'pending')->count();
        $openTickets = DB::table('support_tickets')->whereIn('status', ['open', 'in_progress'])->count();

        // ══════════════════════════════════════
        // 8. CHARTS — Monthly Trend (12 months)
        // ══════════════════════════════════════
        $monthlyTrend = DB::table('transactions')
            ->selectRaw("strftime('%Y-%m', created_at) as month, COUNT(*) as count, COALESCE(SUM(amount),0) as volume")
            ->where('status', 'completed')
            ->where('created_at', '>=', Carbon::now()->subMonths(12))
            ->groupByRaw("strftime('%Y-%m', created_at)")
            ->orderBy('month')->get();

        $userGrowth = DB::table('users')->where('role', '!=', 'admin')
            ->selectRaw("strftime('%Y-%m', created_at) as month, COUNT(*) as count")
            ->where('created_at', '>=', Carbon::now()->subMonths(12))
            ->groupByRaw("strftime('%Y-%m', created_at)")
            ->orderBy('month')->get();

        return Inertia::render('Admin/Dashboard', [
            'stats' => [
                // Users
                'totalUsers' => $totalUsers,
                'newToday' => $newToday,
                'activeUsers' => $activeUsers,
                // Accounts
                'activeAccounts' => $activeAccounts,
                'frozenAccounts' => $frozenAccounts,
                'totalBalance' => round($totalBalance, 2),
                // Transactions
                'dailyVolume' => round($dailyVolume, 2),
                'monthlyVolume' => round($monthlyVolume, 2),
                'yearlyVolume' => round($yearlyVolume, 2),
                'successTx' => $successTx,
                'failedTx' => $failedTx,
                'pendingTx' => $pendingTx,
                'internationalTx' => $internationalTx,
                'localTx' => $localTx,
                // Revenue
                'systemProfit' => round($systemProfit, 2),
                'feesCollected' => round($feesCollected, 2),
                // Cards
                'totalCards' => $totalCards,
                'activeCards' => $activeCards,
                'frozenCards' => $frozenCards,
                // Security
                'securityAlerts' => $securityAlerts,
                'suspiciousTx' => $suspiciousTx,
                // Pending
                'pendingKyc' => $pendingKyc,
                'pendingApprovals' => $pendingApprovals,
                'openTickets' => $openTickets,
            ],
            'usersByCountry' => $usersByCountry,
            'topActiveUsers' => $topActiveUsers,
            'recentTransactions' => $recentTransactions,
            'monthlyTrend' => $monthlyTrend,
            'userGrowth' => $userGrowth,
        ]);
    }

    private function calcGrowth($current, $previous)
    {
        if ($previous == 0)
            return $current > 0 ? 100 : 0;
        return round(($current - $previous) / $previous * 100, 1);
    }

    public function subscriptions()
    {
        // Count preregistrations by plan
        $preregByPlan = DB::table('preregistrations')
            ->selectRaw("COALESCE(plan, 'free') as plan, COUNT(*) as count")
            ->groupBy('plan')->orderBy('count', 'desc')->get();

        $planCounts = [];
        foreach ($preregByPlan as $pr) {
            $planCounts[$pr->plan] = $pr->count;
        }

        // Get all users with their plan info
        $users = DB::table('users')->where('role', '!=', 'admin')
            ->select('id', 'full_name', 'email', 'country', 'created_at')
            ->orderBy('created_at', 'desc')->limit(100)->get()
            ->map(function ($u) {
                $u->plan = 'personal'; // default plan
                return $u;
            });

        return Inertia::render('Admin/Subscriptions', [
            'planCounts' => $planCounts,
            'users' => $users,
            'preregByPlan' => $preregByPlan,
        ]);
    }

    public function countries()
    {
        $usersByCountry = DB::table('users')->where('role', '!=', 'admin')
            ->selectRaw("COALESCE(country, 'Unknown') as country, COUNT(*) as count")
            ->groupBy('country')->orderBy('count', 'desc')->get();

        return Inertia::render('Admin/Countries', [
            'usersByCountry' => $usersByCountry,
        ]);
    }
}