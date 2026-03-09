<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class SpecialRequestController extends Controller
{
    public function index()
    {
        $requests = DB::table('special_requests')
            ->join('users', 'special_requests.user_id', '=', 'users.id')
            ->select('special_requests.*', 'users.name as user_name', 'users.email as user_email')
            ->orderBy('special_requests.created_at', 'desc')->limit(100)->get();
        return Inertia::render('Admin/SpecialRequests', ['requests' => $requests]);
    }

    public function handle(Request $request, $id)
    {
        DB::table('special_requests')->where('id', $id)->update([
            'status' => $request->status,
            'admin_notes' => $request->admin_notes,
            'handled_by' => auth()->id(),
            'handled_at' => now(),
            'updated_at' => now(),
        ]);
        return back()->with('success', 'تم المعالجة');
    }
}
