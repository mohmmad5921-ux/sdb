<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class IntegrationController extends Controller
{
    public function index()
    {
        $integrations = DB::table('integrations')->orderBy('type')->get();
        $stats = ['active' => DB::table('integrations')->where('status', 'active')->count(), 'inactive' => DB::table('integrations')->where('status', 'inactive')->count(), 'error' => DB::table('integrations')->where('status', 'error')->count()];
        return Inertia::render('Admin/Integrations', compact('integrations', 'stats'));
    }

    public function update(Request $request, $id)
    {
        DB::table('integrations')->where('id', $id)->update(['status' => $request->status, 'last_checked_at' => now(), 'updated_at' => now()]);
        return back()->with('success', 'تم التحديث');
    }
}
