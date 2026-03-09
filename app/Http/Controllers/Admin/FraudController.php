<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class FraudController extends Controller
{
    public function index()
    {
        $rules = DB::table('fraud_rules')->orderBy('severity', 'desc')->get();
        $incidents = DB::table('fraud_incidents')
            ->leftJoin('users', 'fraud_incidents.user_id', '=', 'users.id')
            ->select('fraud_incidents.*', 'users.name as user_name', 'users.email as user_email')
            ->orderBy('fraud_incidents.created_at', 'desc')->limit(50)->get();
        $stats = [
            'total_incidents' => DB::table('fraud_incidents')->count(),
            'open' => DB::table('fraud_incidents')->where('status', 'open')->count(),
            'investigating' => DB::table('fraud_incidents')->where('status', 'investigating')->count(),
            'resolved' => DB::table('fraud_incidents')->where('status', 'resolved')->count(),
            'critical' => DB::table('fraud_incidents')->where('severity', 'critical')->where('status', 'open')->count(),
            'blocked_today' => DB::table('fraud_incidents')->where('status', 'open')->whereDate('created_at', today())->count(),
            'rules_active' => DB::table('fraud_rules')->where('active', true)->count(),
        ];
        $highRiskUsers = DB::table('users')->where('role', '!=', 'admin')->where('risk_score', '>=', 70)
            ->select('id', 'name', 'email', 'risk_score', 'risk_level')->orderBy('risk_score', 'desc')->limit(10)->get();
        return Inertia::render('Admin/FraudDashboard', compact('rules', 'incidents', 'stats', 'highRiskUsers'));
    }

    public function updateIncident(Request $request, $id)
    {
        DB::table('fraud_incidents')->where('id', $id)->update([
            'status' => $request->status,
            'handled_by' => auth()->id(),
            'resolved_at' => in_array($request->status, ['resolved', 'false_positive']) ? now() : null,
            'updated_at' => now(),
        ]);
        return back()->with('success', 'تم التحديث');
    }

    public function toggleRule($id)
    {
        $rule = DB::table('fraud_rules')->where('id', $id)->first();
        DB::table('fraud_rules')->where('id', $id)->update(['active' => !$rule->active, 'updated_at' => now()]);
        return back();
    }

    public function storeRule(Request $request)
    {
        $request->validate(['name' => 'required', 'rule_type' => 'required']);
        DB::table('fraud_rules')->insert([
            'name' => $request->name,
            'description' => $request->description,
            'rule_type' => $request->rule_type,
            'conditions' => json_encode($request->conditions ?? []),
            'action' => $request->action ?? 'alert',
            'severity' => $request->severity ?? 'medium',
            'active' => true,
            'triggers_count' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        return back()->with('success', 'تم إضافة القاعدة');
    }
}
