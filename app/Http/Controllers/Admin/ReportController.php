<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class ReportController extends Controller
{
    public function index()
    {
        $totalUsers = DB::table('users')->where('role', '!=', 'admin')->count();
        $totalAccounts = DB::table('accounts')->count();
        $totalTransactions = DB::table('transactions')->count();
        $totalVolume = DB::table('transactions')->where('status', 'completed')->sum('amount');

        // Monthly breakdown
        $monthly = DB::table('transactions')
            ->selectRaw("DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as count, SUM(amount) as volume")
            ->where('status', 'completed')
            ->groupByRaw("DATE_FORMAT(created_at, '%Y-%m')")
            ->orderBy('month', 'desc')
            ->limit(12)
            ->get();

        // User growth
        $userGrowth = DB::table('users')
            ->selectRaw("DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as count")
            ->where('role', '!=', 'admin')
            ->groupByRaw("DATE_FORMAT(created_at, '%Y-%m')")
            ->orderBy('month', 'desc')
            ->limit(12)
            ->get();

        // Revenue by fee type
        $feeRevenue = DB::table('fee_structures')
            ->select('name', 'fee_type', 'percentage', 'fixed_amount')
            ->where('active', true)
            ->get();

        return Inertia::render('Admin/Reports', [
            'stats' => [
                'users' => $totalUsers,
                'accounts' => $totalAccounts,
                'transactions' => $totalTransactions,
                'volume' => round($totalVolume, 2),
            ],
            'monthly' => $monthly,
            'userGrowth' => $userGrowth,
            'feeRevenue' => $feeRevenue,
        ]);
    }
}
