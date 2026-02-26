<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Account;
use App\Models\Card;
use App\Models\Currency;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        $today = Carbon::today();
        $thisWeek = Carbon::now()->startOfWeek();
        $thisMonth = Carbon::now()->startOfMonth();
        $lastMonth = Carbon::now()->subMonth()->startOfMonth();
        $lastMonthEnd = Carbon::now()->subMonth()->endOfMonth();

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

        // System alerts
        $alerts = [];
        if ($stats['pending_kyc'] > 0)
            $alerts[] = ['type' => 'warning', 'msg' => $stats['pending_kyc'] . ' طلب KYC بانتظار المراجعة'];
        if ($stats['pending_transactions'] > 0)
            $alerts[] = ['type' => 'info', 'msg' => $stats['pending_transactions'] . ' معاملة معلّقة'];
        if ($stats['failed_transactions'] > 0)
            $alerts[] = ['type' => 'error', 'msg' => $stats['failed_transactions'] . ' معاملة فاشلة'];
        if ($stats['frozen_accounts'] > 0)
            $alerts[] = ['type' => 'warning', 'msg' => $stats['frozen_accounts'] . ' حساب مجمّد'];
        if ($stats['suspended_users'] > 0)
            $alerts[] = ['type' => 'error', 'msg' => $stats['suspended_users'] . ' مستخدم موقوف'];

        return Inertia::render('Admin/Dashboard', [
            'stats' => $stats,
            'dailyTransactions' => $dailyTransactions,
            'dailyUsers' => $dailyUsers,
            'recentTransactions' => $recentTransactions,
            'recentUsers' => $recentUsers,
            'currencies' => $currencies,
            'alerts' => $alerts,
        ]);
    }
}