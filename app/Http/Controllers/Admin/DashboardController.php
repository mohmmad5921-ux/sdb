<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Account;
use App\Models\Card;
use App\Models\Currency;
use App\Models\Transaction;
use App\Models\User;
use App\Models\WaitlistEmail;
use App\Models\Preregistration;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        $today = Carbon::today();
        $thisWeek = Carbon::now()->startOfWeek();
        $lastWeekStart = Carbon::now()->subWeek()->startOfWeek();
        $lastWeekEnd = Carbon::now()->subWeek()->endOfWeek();
        $thisMonth = Carbon::now()->startOfMonth();

        // Core stats
        $stats = [
            'total_users' => User::where('role', 'customer')->count(),
            'active_users' => User::where('role', 'customer')->where('status', 'active')->count(),
            'suspended_users' => User::where('role', 'customer')->where('status', 'suspended')->count(),
            'pending_kyc' => User::where('kyc_status', 'submitted')->count(),
            'total_accounts' => Account::count(),
            'active_accounts' => Account::where('status', 'active')->count(),
            'frozen_accounts' => Account::where('status', 'frozen')->count(),
            'total_cards' => Card::count(),
            'active_cards' => Card::where('status', 'active')->count(),
            'frozen_cards' => Card::where('status', 'frozen')->count(),
            'total_transactions' => Transaction::count(),
            'today_transactions' => Transaction::whereDate('created_at', $today)->count(),
            'week_transactions' => Transaction::where('created_at', '>=', $thisWeek)->count(),
            'month_transactions' => Transaction::where('created_at', '>=', $thisMonth)->count(),
            'total_volume' => Transaction::where('status', 'completed')->sum('amount'),
            'today_volume' => Transaction::where('status', 'completed')->whereDate('created_at', $today)->sum('amount'),
            'week_volume' => Transaction::where('status', 'completed')->where('created_at', '>=', $thisWeek)->sum('amount'),
            'month_volume' => Transaction::where('status', 'completed')->where('created_at', '>=', $thisMonth)->sum('amount'),
            'pending_transactions' => Transaction::where('status', 'pending')->count(),
            'failed_transactions' => Transaction::where('status', 'failed')->count(),
            'new_users_today' => User::where('role', 'customer')->whereDate('created_at', $today)->count(),
            'new_users_week' => User::where('role', 'customer')->where('created_at', '>=', $thisWeek)->count(),
            'new_users_month' => User::where('role', 'customer')->where('created_at', '>=', $thisMonth)->count(),
            'total_waitlist' => WaitlistEmail::count(),
            'waitlist_today' => WaitlistEmail::whereDate('created_at', $today)->count(),
            'waitlist_week' => WaitlistEmail::where('created_at', '>=', $thisWeek)->count(),
            'total_preregistrations' => Preregistration::count(),
            'prereg_today' => Preregistration::whereDate('created_at', $today)->count(),
            'prereg_week' => Preregistration::where('created_at', '>=', $thisWeek)->count(),
        ];

        // Weekly growth comparisons
        $lastWeekUsers = User::where('role', 'customer')
            ->whereBetween('created_at', [$lastWeekStart, $lastWeekEnd])->count();
        $lastWeekTxCount = Transaction::whereBetween('created_at', [$lastWeekStart, $lastWeekEnd])->count();
        $lastWeekVolume = Transaction::where('status', 'completed')
            ->whereBetween('created_at', [$lastWeekStart, $lastWeekEnd])->sum('amount');

        $growth = [
            'users' => $this->calcGrowth($stats['new_users_week'], $lastWeekUsers),
            'transactions' => $this->calcGrowth($stats['week_transactions'], $lastWeekTxCount),
            'volume' => $this->calcGrowth($stats['week_volume'], $lastWeekVolume),
        ];

        // Last 7 days transaction growth
        $dailyTransactions = [];
        for ($i = 6; $i >= 0; $i--) {
            $date = Carbon::today()->subDays($i);
            $dailyTransactions[] = [
                'date' => $date->format('m/d'),
                'day' => $date->locale('ar')->dayName,
                'count' => Transaction::whereDate('created_at', $date)->count(),
                'volume' => round(Transaction::where('status', 'completed')->whereDate('created_at', $date)->sum('amount'), 2),
            ];
        }

        // Last 7 days user growth
        $dailyUsers = [];
        for ($i = 6; $i >= 0; $i--) {
            $date = Carbon::today()->subDays($i);
            $dailyUsers[] = [
                'date' => $date->format('m/d'),
                'count' => User::where('role', 'customer')->whereDate('created_at', $date)->count(),
            ];
        }

        $recentTransactions = Transaction::with(['fromAccount.user', 'toAccount.user', 'currency'])
            ->orderByDesc('created_at')
            ->limit(10)
            ->get();

        $recentUsers = User::where('role', 'customer')
            ->orderByDesc('created_at')
            ->limit(5)
            ->get();

        $currencies = Currency::where('is_active', true)->get();

        $recentWaitlist = WaitlistEmail::orderByDesc('created_at')->limit(5)->get();
        $recentPrereg = Preregistration::orderByDesc('created_at')->limit(5)->get();

        // Top clients by balance
        $topClients = User::where('role', 'customer')
            ->where('status', 'active')
            ->withCount('accounts')
            ->with('accounts.currency')
            ->get()
            ->map(function ($user) {
                $totalEur = $user->accounts->sum(fn($a) => $a->balance * ($a->currency->exchange_rate_to_eur ?? 1));
                return ['id' => $user->id, 'name' => $user->full_name, 'balance' => round($totalEur, 2), 'accounts_count' => $user->accounts_count];
            })
            ->sortByDesc('balance')
            ->take(5)
            ->values();

        // Country breakdown for preregistrations
        $countryBreakdown = Preregistration::selectRaw('country, COUNT(*) as total')
            ->groupBy('country')
            ->orderByDesc('total')
            ->limit(8)
            ->get();

        // System alerts (smart)
        $alerts = [];
        $kyc48h = User::where('kyc_status', 'submitted')
            ->where('updated_at', '<', Carbon::now()->subHours(48))->count();
        if ($kyc48h > 0)
            $alerts[] = ['type' => 'error', 'msg' => "🚨 {$kyc48h} طلب KYC معلّق منذ أكثر من 48 ساعة!", 'link' => 'admin.kyc'];
        elseif ($stats['pending_kyc'] > 0)
            $alerts[] = ['type' => 'warning', 'msg' => $stats['pending_kyc'] . ' طلب KYC بانتظار المراجعة', 'link' => 'admin.kyc'];

        $largeTx = Transaction::where('status', 'completed')
            ->whereDate('created_at', $today)
            ->where('amount', '>', 1000)->count();
        if ($largeTx > 0)
            $alerts[] = ['type' => 'info', 'msg' => "💰 {$largeTx} معاملة كبيرة (> €1,000) اليوم", 'link' => 'admin.transactions'];

        if ($stats['pending_transactions'] > 0)
            $alerts[] = ['type' => 'info', 'msg' => $stats['pending_transactions'] . ' معاملة معلّقة', 'link' => 'admin.transactions'];
        if ($stats['failed_transactions'] > 0)
            $alerts[] = ['type' => 'error', 'msg' => $stats['failed_transactions'] . ' معاملة فاشلة', 'link' => 'admin.transactions'];
        if ($stats['frozen_accounts'] > 0)
            $alerts[] = ['type' => 'warning', 'msg' => $stats['frozen_accounts'] . ' حساب مجمّد', 'link' => 'admin.accounts'];
        if ($stats['suspended_users'] > 0)
            $alerts[] = ['type' => 'error', 'msg' => $stats['suspended_users'] . ' مستخدم موقوف', 'link' => 'admin.users'];
        if ($stats['waitlist_today'] > 0)
            $alerts[] = ['type' => 'info', 'msg' => $stats['waitlist_today'] . ' تسجيل جديد بقائمة الانتظار اليوم', 'link' => 'admin.waitlist'];

        return Inertia::render('Admin/Dashboard', [
            'stats' => $stats,
            'growth' => $growth,
            'dailyTransactions' => $dailyTransactions,
            'dailyUsers' => $dailyUsers,
            'recentTransactions' => $recentTransactions,
            'recentUsers' => $recentUsers,
            'currencies' => $currencies,
            'alerts' => $alerts,
            'recentWaitlist' => $recentWaitlist,
            'recentPrereg' => $recentPrereg,
            'topClients' => $topClients,
            'countryBreakdown' => $countryBreakdown,
        ]);
    }

    private function calcGrowth($current, $previous): array
    {
        if ($previous == 0) {
            return ['pct' => $current > 0 ? 100 : 0, 'direction' => $current > 0 ? 'up' : 'flat'];
        }
        $pct = round((($current - $previous) / $previous) * 100, 1);
        return ['pct' => abs($pct), 'direction' => $pct > 0 ? 'up' : ($pct < 0 ? 'down' : 'flat')];
    }
}