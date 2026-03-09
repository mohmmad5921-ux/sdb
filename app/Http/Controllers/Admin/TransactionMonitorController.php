<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Carbon\Carbon;

class TransactionMonitorController extends Controller
{
    public function index()
    {
        $today = today();
        $stats = [
            'today_count' => DB::table('transactions')->whereDate('created_at', $today)->count(),
            'today_volume' => round(DB::table('transactions')->whereDate('created_at', $today)->where('status', 'completed')->sum('amount'), 2),
            'pending' => DB::table('transactions')->where('status', 'pending')->count(),
            'large_today' => DB::table('transactions')->whereDate('created_at', $today)->where('amount', '>=', 5000)->count(),
            'international' => DB::table('transactions')->whereDate('created_at', $today)->where('type', 'international')->count(),
            'failed_today' => DB::table('transactions')->whereDate('created_at', $today)->where('status', 'failed')->count(),
        ];
        // Hourly volume chart (last 24 hours)
        $hourly = DB::table('transactions')
            ->selectRaw("cast(strftime('%H', created_at) as integer) as hour, COUNT(*) as count, COALESCE(SUM(amount),0) as volume")
            ->where('created_at', '>=', Carbon::now()->subHours(24))
            ->groupByRaw("cast(strftime('%H', created_at) as integer)")->orderBy('hour')->get();
        // By country
        $byCountry = DB::table('transactions')
            ->leftJoin('accounts as tx_acc', 'transactions.from_account_id', '=', 'tx_acc.id')->leftJoin('users', 'tx_acc.user_id', '=', 'users.id')
            ->selectRaw("COALESCE(users.country,'Unknown') as country, COUNT(*) as count, SUM(transactions.amount) as volume")
            ->whereDate('transactions.created_at', '>=', Carbon::now()->subDays(30))
            ->groupBy('country')->orderBy('volume', 'desc')->limit(10)->get();
        // Anomalies: unusually large transactions
        $anomalies = DB::table('transactions')
            ->leftJoin('accounts as tx_acc', 'transactions.from_account_id', '=', 'tx_acc.id')->leftJoin('users', 'tx_acc.user_id', '=', 'users.id')
            ->where('transactions.amount', '>=', 10000)
            ->where('transactions.created_at', '>=', Carbon::now()->subDays(7))
            ->select('transactions.*', 'users.full_name as user_name')
            ->orderBy('transactions.amount', 'desc')->limit(20)->get();
        return Inertia::render('Admin/TransactionMonitor', compact('stats', 'hourly', 'byCountry', 'anomalies'));
    }
}
