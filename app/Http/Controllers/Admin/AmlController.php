<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class AmlController extends Controller
{
    public function index()
    {
        $reports = DB::table('aml_reports')
            ->join('users', 'aml_reports.user_id', '=', 'users.id')
            ->select('aml_reports.*', 'users.name as user_name', 'users.email as user_email')
            ->orderBy('aml_reports.created_at', 'desc')->limit(50)->get();
        $stats = [
            'total' => DB::table('aml_reports')->count(),
            'pending' => DB::table('aml_reports')->where('status', 'pending')->count(),
            'under_review' => DB::table('aml_reports')->where('status', 'under_review')->count(),
            'escalated' => DB::table('aml_reports')->where('status', 'escalated')->count(),
            'cleared' => DB::table('aml_reports')->where('status', 'cleared')->count(),
            'reported' => DB::table('aml_reports')->where('status', 'reported')->count(),
            'large_transfers_today' => DB::table('transactions')->whereDate('created_at', today())->where('amount', '>=', 10000)->count(),
            'high_risk_users' => DB::table('users')->where('risk_level', 'high')->orWhere('risk_level', 'critical')->count(),
        ];
        $largeTransfers = DB::table('transactions')
            ->leftJoin('users', 'transactions.user_id', '=', 'users.id')
            ->where('transactions.amount', '>=', 5000)
            ->select('transactions.*', 'users.name as user_name')
            ->orderBy('transactions.created_at', 'desc')->limit(20)->get();
        return Inertia::render('Admin/AmlDashboard', compact('reports', 'stats', 'largeTransfers'));
    }

    public function review(Request $request, $id)
    {
        DB::table('aml_reports')->where('id', $id)->update([
            'status' => $request->status,
            'admin_notes' => $request->admin_notes,
            'reviewed_by' => auth()->id(),
            'reviewed_at' => now(),
            'updated_at' => now(),
        ]);
        return back()->with('success', 'تم المراجعة');
    }

    public function createReport(Request $request)
    {
        $request->validate(['user_id' => 'required', 'type' => 'required', 'description' => 'required']);
        DB::table('aml_reports')->insert([
            ...$request->only('user_id', 'type', 'description', 'amount', 'risk_level'),
            'status' => 'pending',
            'created_at' => now(),
            'updated_at' => now()
        ]);
        return back()->with('success', 'تم إنشاء التقرير');
    }
}
