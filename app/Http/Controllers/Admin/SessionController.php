<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class SessionController extends Controller
{
    public function index()
    {
        $sessions = DB::table('sessions')
            ->leftJoin('users', 'sessions.user_id', '=', 'users.id')
            ->select('sessions.*', 'users.name as user_name', 'users.email as user_email', 'users.role')
            ->whereNotNull('sessions.user_id')
            ->orderBy('sessions.last_activity', 'desc')
            ->limit(100)->get()->map(function ($s) {
                $s->last_active = date('Y-m-d H:i:s', $s->last_activity);
                return $s;
            });
        return Inertia::render('Admin/Sessions', ['sessions' => $sessions]);
    }

    public function destroy($id)
    {
        DB::table('sessions')->where('id', $id)->delete();
        return back()->with('success', 'تم إنهاء الجلسة');
    }
}
