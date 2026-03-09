<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Carbon\Carbon;

class ReportCenterController extends Controller
{
    public function index()
    {
        $thisMonth = Carbon::now()->startOfMonth();
        return Inertia::render('Admin/ReportCenter', [
            'reports' => [
                'profit' => [
                    'total_fees' => round(DB::table('transactions')->where('status', 'completed')->sum('fee_amount'), 2),
                    'monthly_fees' => round(DB::table('transactions')->where('status', 'completed')->where('created_at', '>=', $thisMonth)->sum('fee_amount'), 2),
                ],
                'transactions' => [
                    'total' => DB::table('transactions')->count(),
                    'completed' => DB::table('transactions')->where('status', 'completed')->count(),
                    'volume' => round(DB::table('transactions')->where('status', 'completed')->sum('amount'), 2),
                ],
                'users' => [
                    'total' => DB::table('users')->where('role', '!=', 'admin')->count(),
                    'verified' => DB::table('users')->where('kyc_status', 'verified')->count(),
                    'new_month' => DB::table('users')->where('created_at', '>=', $thisMonth)->count(),
                ],
                'cards' => [
                    'total' => DB::table('cards')->count(),
                    'active' => DB::table('cards')->where('status', 'active')->count(),
                ],
                'fraud' => [
                    'total_incidents' => DB::table('fraud_incidents')->count(),
                    'open' => DB::table('fraud_incidents')->where('status', 'open')->count(),
                ],
                'aml' => [
                    'total_reports' => DB::table('aml_reports')->count(),
                    'pending' => DB::table('aml_reports')->where('status', 'pending')->count(),
                ],
                'support' => [
                    'total_tickets' => DB::table('support_tickets')->count(),
                    'open' => DB::table('support_tickets')->whereIn('status', ['open', 'in_progress'])->count(),
                ],
                'fees_by_type' => DB::table('transactions')->where('status', 'completed')
                    ->selectRaw("type, COUNT(*) as count, SUM(fee_amount) as fees")
                    ->groupBy('type')->get(),
            ]
        ]);
    }
}
