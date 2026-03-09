<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Carbon\Carbon;

class UserAnalyticsController extends Controller
{
    public function index()
    {
        $stats = [
            'total' => DB::table('users')->where('role', '!=', 'admin')->count(),
            'active_30d' => DB::table('users')->where('role', '!=', 'admin')->where('last_login_at', '>=', Carbon::now()->subDays(30))->count(),
            'active_7d' => DB::table('users')->where('role', '!=', 'admin')->where('last_login_at', '>=', Carbon::now()->subDays(7))->count(),
            'dormant' => DB::table('users')->where('role', '!=', 'admin')->where(function ($q) {
                $q->whereNull('last_login_at')->orWhere('last_login_at', '<', Carbon::now()->subDays(90)); })->count(),
            'new_this_month' => DB::table('users')->where('role', '!=', 'admin')->where('created_at', '>=', Carbon::now()->startOfMonth())->count(),
            'verified' => DB::table('users')->where('role', '!=', 'admin')->where('kyc_status', 'verified')->count(),
        ];
        // Top users by transaction count
        $topByTx = DB::table('transactions')
            ->join('users', 'transactions.user_id', '=', 'users.id')
            ->selectRaw("users.id,users.full_name,users.email,COUNT(*) as tx_count,SUM(transactions.amount) as volume")
            ->groupBy('users.id', 'users.full_name', 'users.email')->orderBy('tx_count', 'desc')->limit(15)->get();
        // Countries
        $countries = DB::table('users')->where('role', '!=', 'admin')
            ->selectRaw("COALESCE(country,'Unknown') as country, COUNT(*) as count")
            ->groupBy('country')->orderBy('count', 'desc')->limit(15)->get();
        // Monthly registration trend (12 months)
        $monthlyReg = DB::table('users')->where('role', '!=', 'admin')
            ->selectRaw("DATE_FORMAT(created_at,'%Y-%m') as month, COUNT(*) as count")
            ->where('created_at', '>=', Carbon::now()->subMonths(12))
            ->groupByRaw("DATE_FORMAT(created_at,'%Y-%m')")->orderBy('month')->get();
        // Spending patterns
        $spendingByType = DB::table('transactions')
            ->selectRaw("type, COUNT(*) as count, SUM(amount) as volume")
            ->where('status', 'completed')
            ->groupBy('type')->orderBy('volume', 'desc')->get();
        return Inertia::render('Admin/UserAnalytics', compact('stats', 'topByTx', 'countries', 'monthlyReg', 'spendingByType'));
    }
}
