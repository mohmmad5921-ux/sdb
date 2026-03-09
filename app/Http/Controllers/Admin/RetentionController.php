<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class RetentionController extends Controller
{
    public function index()
    {
        $totalUsers = DB::table('users')->where('role', '!=', 'admin')->count();

        // Active users (logged in last 30 days)
        $active30 = DB::table('users')->where('role', '!=', 'admin')
            ->where('last_login_at', '>=', now()->subDays(30))->count();

        // Active 7 days
        $active7 = DB::table('users')->where('role', '!=', 'admin')
            ->where('last_login_at', '>=', now()->subDays(7))->count();

        // Dormant (no login in 90+ days)
        $dormant = DB::table('users')->where('role', '!=', 'admin')
            ->where(function ($q) {
                $q->where('last_login_at', '<', now()->subDays(90))
                    ->orWhereNull('last_login_at');
            })->count();

        // Users with transactions vs without
        $withTx = DB::table('users')
            ->where('role', '!=', 'admin')
            ->whereExists(function ($q) {
                $q->select(DB::raw(1))->from('transactions')->join('accounts', 'transactions.from_account_id', '=', 'accounts.id')->whereColumn('accounts.user_id', 'users.id');
            })
            ->count();

        // Monthly new registrations
        $monthlyReg = DB::table('users')
            ->where('role', '!=', 'admin')
            ->selectRaw("strftime('%Y-%m', created_at) as month, COUNT(*) as count")
            ->groupByRaw("strftime('%Y-%m', created_at)")
            ->orderBy('month', 'desc')
            ->limit(12)
            ->get();

        // Churn: registered > 30 days ago, never transacted
        $churned = DB::table('users')
            ->where('role', '!=', 'admin')
            ->where('created_at', '<', now()->subDays(30))
            ->whereNotExists(function ($q) {
                $q->select(DB::raw(1))->from('transactions')->join('accounts', 'transactions.from_account_id', '=', 'accounts.id')->whereColumn('accounts.user_id', 'users.id');
            })
            ->count();

        return Inertia::render('Admin/Retention', [
            'totalUsers' => $totalUsers,
            'active30' => $active30,
            'active7' => $active7,
            'dormant' => $dormant,
            'withTx' => $withTx,
            'withoutTx' => $totalUsers - $withTx,
            'churned' => $churned,
            'monthlyReg' => $monthlyReg,
            'activityRate' => $totalUsers > 0 ? round($active30 / $totalUsers * 100, 1) : 0,
            'churnRate' => $totalUsers > 0 ? round($churned / $totalUsers * 100, 1) : 0,
        ]);
    }
}
