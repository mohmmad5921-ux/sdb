<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class RevenueController extends Controller
{
    public function index()
    {
        // Revenue by type
        $feeTypes = DB::table('fee_structures')->where('active', true)->get();

        // Monthly transaction volume
        $monthlyVolume = DB::table('transactions')
            ->selectRaw("strftime('%Y-%m', created_at) as month, type, COUNT(*) as count, SUM(amount) as volume")
            ->where('status', 'completed')
            ->groupByRaw("strftime('%Y-%m', created_at), type")
            ->orderBy('month', 'desc')
            ->limit(60)
            ->get()
            ->groupBy('month');

        // Top revenue users
        $topUsers = DB::table('transactions')
            ->join('accounts', 'transactions.from_account_id', '=', 'accounts.id')->join('users', 'accounts.user_id', '=', 'users.id')
            ->where('transactions.status', 'completed')
            ->selectRaw("users.full_name, users.email, COUNT(*) as tx_count, SUM(transactions.amount) as total_volume")
            ->groupBy('users.id', 'users.full_name', 'users.email')
            ->orderBy('total_volume', 'desc')
            ->limit(10)
            ->get();

        // Daily volume last 30 days
        $dailyVolume = DB::table('transactions')
            ->where('status', 'completed')
            ->where('created_at', '>=', now()->subDays(30))
            ->selectRaw("DATE(created_at) as day, COUNT(*) as count, SUM(amount) as volume")
            ->groupByRaw("DATE(created_at)")
            ->orderBy('day')
            ->get();

        return Inertia::render('Admin/Revenue', [
            'feeTypes' => $feeTypes,
            'monthlyVolume' => $monthlyVolume,
            'topUsers' => $topUsers,
            'dailyVolume' => $dailyVolume,
        ]);
    }
}
