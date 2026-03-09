<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class DataManagementController extends Controller
{
    public function index()
    {
        $dbStats = [
            'users' => DB::table('users')->count(),
            'accounts' => DB::table('accounts')->count(),
            'transactions' => DB::table('transactions')->count(),
            'cards' => DB::table('cards')->count(),
            'kyc_documents' => DB::table('kyc_documents')->count(),
            'support_tickets' => DB::table('support_tickets')->count(),
            'audit_logs' => DB::table('audit_logs')->count(),
            'sessions' => DB::table('sessions')->count(),
        ];
        $scheduledReports = DB::table('scheduled_reports')->orderBy('name')->get();
        return Inertia::render('Admin/DataManagement', compact('dbStats', 'scheduledReports'));
    }

    public function storeReport(Request $request)
    {
        $request->validate(['name' => 'required', 'type' => 'required']);
        DB::table('scheduled_reports')->insert([...$request->only('name', 'type', 'frequency', 'format', 'email_to'), 'active' => true, 'created_at' => now(), 'updated_at' => now()]);
        return back()->with('success', 'تم الإنشاء');
    }

    public function toggleReport($id)
    {
        $r = DB::table('scheduled_reports')->find($id);
        DB::table('scheduled_reports')->where('id', $id)->update(['active' => !$r->active]);
        return back();
    }
}
