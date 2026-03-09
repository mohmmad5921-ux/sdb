<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class LiveKpiController extends Controller
{
    public function index()
    {
        $now = now();
        $kpis = [
            'total_users' => DB::table('users')->where('role', '!=', 'admin')->count(),
            'today_registrations' => DB::table('users')->where('role', '!=', 'admin')->whereDate('created_at', today())->count(),
            'active_today' => DB::table('users')->where('role', '!=', 'admin')->whereDate('last_login_at', today())->count(),
            'total_accounts' => DB::table('accounts')->count(),
            'total_transactions' => DB::table('transactions')->count(),
            'today_transactions' => DB::table('transactions')->whereDate('created_at', today())->count(),
            'today_volume' => round(DB::table('transactions')->whereDate('created_at', today())->where('status', 'completed')->sum('amount'), 2),
            'pending_kyc' => DB::table('kyc_documents')->where('status', 'pending')->count(),
            'open_tickets' => DB::table('support_tickets')->whereIn('status', ['open', 'in_progress'])->count(),
            'frozen_accounts' => DB::table('users')->where('status', 'frozen')->count(),
        ];
        // Optional tables that may not exist
        try {
            $kpis['pending_approvals'] = DB::table('pending_approvals')->where('status', 'pending')->count();
        } catch (\Throwable $e) {
            $kpis['pending_approvals'] = 0;
        }
        try {
            $kpis['unread_alerts'] = DB::table('smart_alerts')->where('read', false)->count();
        } catch (\Throwable $e) {
            $kpis['unread_alerts'] = 0;
        }
        try {
            $kpis['preregistrations'] = DB::table('preregistrations')->count();
        } catch (\Throwable $e) {
            $kpis['preregistrations'] = 0;
        }
        try {
            $kpis['waitlist'] = DB::table('waitlist_entries')->count();
        } catch (\Throwable $e) {
            $kpis['waitlist'] = 0;
        }
        return Inertia::render('Admin/LiveKpi', ['kpis' => $kpis]);
    }
}
