<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Inertia\Response;

class AuthenticatedSessionController extends Controller
{
    /**
     * Display the customer login view.
     */
    public function create(): Response
    {
        return Inertia::render('Auth/Login', [
            'canResetPassword' => Route::has('password.request'),
            'status' => session('status'),
        ]);
    }

    /**
     * Display the admin login view.
     */
    public function adminLogin(): Response
    {
        return Inertia::render('Auth/AdminLogin', [
            'status' => session('status'),
        ]);
    }

    /**
     * Handle an incoming authentication request.
     */
    public function store(LoginRequest $request): RedirectResponse
    {
        $request->authenticate();
        $request->session()->regenerate();

        $user = Auth::user();
        $portal = $request->input('portal', 'customer');

        // Block admin login from customer page
        if ($user->role === 'admin' && $portal !== 'admin') {
            Auth::guard('web')->logout();
            $request->session()->invalidate();
            $request->session()->regenerateToken();
            return back()->withErrors(['email' => 'Admin accounts must use the admin portal.']);
        }

        // Block customer login from admin page
        if ($user->role !== 'admin' && $portal === 'admin') {
            Auth::guard('web')->logout();
            $request->session()->invalidate();
            $request->session()->regenerateToken();
            return back()->withErrors(['email' => 'هذه البوابة مخصصة للإدارة فقط.']);
        }

        // Log admin login
        if ($user->role === 'admin') {
            try {
                DB::table('admin_login_history')->insert([
                    'user_id' => $user->id,
                    'ip_address' => $request->ip(),
                    'user_agent' => $request->userAgent(),
                    'device' => $this->parseDevice($request->userAgent()),
                    'status' => 'success',
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            } catch (\Exception $e) {
            }
        }

        // Redirect based on role
        if ($user->role === 'admin') {
            return redirect()->intended('/sdb-admin/dashboard');
        }

        return redirect()->intended(route('dashboard', absolute: false));
    }

    /**
     * Destroy an authenticated session.
     */
    public function destroy(Request $request): RedirectResponse
    {
        $role = Auth::user()?->role;
        Auth::guard('web')->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        if ($role === 'admin') {
            return redirect('/gate/sdb-m5921');
        }

        return redirect('/');
    }

    private function parseDevice(?string $ua): string
    {
        if (!$ua)
            return 'Unknown';
        if (str_contains($ua, 'iPhone'))
            return 'iPhone';
        if (str_contains($ua, 'iPad'))
            return 'iPad';
        if (str_contains($ua, 'Android'))
            return 'Android';
        if (str_contains($ua, 'Mac'))
            return 'Mac';
        if (str_contains($ua, 'Windows'))
            return 'Windows';
        if (str_contains($ua, 'Linux'))
            return 'Linux';
        return 'Unknown';
    }
}
