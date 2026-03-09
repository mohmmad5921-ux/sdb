<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class RiskDashboardController extends Controller
{
    public function index()
    {
        $riskDistribution = DB::table('users')->where('role', '!=', 'admin')
            ->selectRaw("risk_level, COUNT(*) as count")->groupBy('risk_level')->get();
        $highRiskUsers = DB::table('users')->where('role', '!=', 'admin')
            ->whereIn('risk_level', ['high', 'critical'])
            ->select('id', 'name', 'email', 'risk_score', 'risk_level', 'status', 'created_at')
            ->orderBy('risk_score', 'desc')->limit(20)->get();
        $recentIncidents = DB::table('fraud_incidents')
            ->leftJoin('users', 'fraud_incidents.user_id', '=', 'users.id')
            ->select('fraud_incidents.*', 'users.full_name as user_name')
            ->where('fraud_incidents.status', 'open')
            ->orderBy('fraud_incidents.created_at', 'desc')->limit(10)->get();
        $stats = [
            'total_high_risk' => DB::table('users')->whereIn('risk_level', ['high', 'critical'])->count(),
            'open_incidents' => DB::table('fraud_incidents')->where('status', 'open')->count(),
            'aml_pending' => DB::table('aml_reports')->where('status', 'pending')->count(),
            'frozen_accounts' => DB::table('users')->where('status', 'frozen')->count(),
        ];
        return Inertia::render('Admin/RiskDashboard', compact('riskDistribution', 'highRiskUsers', 'recentIncidents', 'stats'));
    }

    public function updateRisk(Request $request, $userId)
    {
        $score = (int) $request->risk_score;
        $level = $score >= 80 ? 'critical' : ($score >= 60 ? 'high' : ($score >= 40 ? 'medium' : 'low'));
        DB::table('users')->where('id', $userId)->update(['risk_score' => $score, 'risk_level' => $level, 'updated_at' => now()]);
        DB::table('system_changelog')->insert(['admin_id' => auth()->id(), 'category' => 'risk', 'action' => 'update_risk', 'target' => "User #{$userId}", 'old_value' => null, 'new_value' => json_encode(['score' => $score, 'level' => $level]), 'ip_address' => request()->ip(), 'created_at' => now(), 'updated_at' => now()]);
        return back()->with('success', 'تم التحديث');
    }
}
