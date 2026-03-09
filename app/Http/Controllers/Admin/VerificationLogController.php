<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class VerificationLogController extends Controller
{
    public function index()
    {
        $logs = DB::table('verification_logs')
            ->join('users', 'verification_logs.user_id', '=', 'users.id')
            ->select('verification_logs.*', 'users.name as user_name', 'users.email as user_email')
            ->orderBy('verification_logs.created_at', 'desc')->limit(100)->get();
        $stats = [
            'total' => DB::table('verification_logs')->count(),
            'success' => DB::table('verification_logs')->where('status', 'success')->count(),
            'failed' => DB::table('verification_logs')->where('status', 'failed')->count(),
            'biometric' => DB::table('verification_logs')->where('type', 'biometric')->count(),
            'otp' => DB::table('verification_logs')->where('type', 'otp')->count(),
            'device' => DB::table('verification_logs')->where('type', 'device')->count(),
        ];
        return Inertia::render('Admin/VerificationLogs', compact('logs', 'stats'));
    }
}
