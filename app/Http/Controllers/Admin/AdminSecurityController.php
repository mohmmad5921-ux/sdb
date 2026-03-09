<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class AdminSecurityController extends Controller
{
    public function index()
    {
        $loginHistory = DB::table('admin_login_history')
            ->leftJoin('users', 'admin_login_history.user_id', '=', 'users.id')
            ->select('admin_login_history.*', 'users.full_name', 'users.email')
            ->orderByDesc('admin_login_history.created_at')
            ->limit(50)
            ->get();

        $failedLogins = DB::table('admin_login_history')
            ->where('status', 'failed')
            ->where('created_at', '>=', now()->subDays(7))
            ->count();

        $uniqueIps = DB::table('admin_login_history')
            ->where('created_at', '>=', now()->subDays(30))
            ->distinct('ip_address')
            ->count('ip_address');

        return Inertia::render('Admin/Security', [
            'loginHistory' => $loginHistory,
            'failedLogins' => $failedLogins,
            'uniqueIps' => $uniqueIps,
        ]);
    }
}
