<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class IpWhitelistController extends Controller
{
    public function index()
    {
        $ips = DB::table('admin_ip_whitelist')
            ->join('users', 'admin_ip_whitelist.added_by', '=', 'users.id')
            ->select('admin_ip_whitelist.*', 'users.full_name as admin_name')
            ->orderBy('admin_ip_whitelist.created_at', 'desc')->get();
        return Inertia::render('Admin/IpWhitelist', ['ips' => $ips, 'currentIp' => request()->ip()]);
    }

    public function store(Request $request)
    {
        $request->validate(['ip_address' => 'required']);
        DB::table('admin_ip_whitelist')->insert(['ip_address' => $request->ip_address, 'label' => $request->label, 'added_by' => auth()->id(), 'active' => true, 'created_at' => now(), 'updated_at' => now()]);
        return back()->with('success', 'تم الإضافة');
    }

    public function destroy($id)
    {
        DB::table('admin_ip_whitelist')->where('id', $id)->delete();
        return back();
    }
}
