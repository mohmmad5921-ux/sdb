<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\LoginHistory;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SecurityController extends Controller
{
    public function index()
    {
        $user = auth()->user();

        $loginHistory = LoginHistory::where('user_id', $user->id)
            ->orderByDesc('created_at')
            ->limit(20)
            ->get();

        $activeSessions = $user->tokens()->orderByDesc('last_used_at')->get()->map(fn($t) => [
            'id' => $t->id,
            'name' => $t->name,
            'last_used' => $t->last_used_at?->diffForHumans(),
            'created' => $t->created_at->diffForHumans(),
        ]);

        return Inertia::render('Banking/Security', [
            'loginHistory' => $loginHistory,
            'activeSessions' => $activeSessions,
            'user' => [
                'email' => $user->email,
                'last_login_at' => $user->last_login_at,
            ],
        ]);
    }

    public function revokeSession(Request $request, $tokenId)
    {
        auth()->user()->tokens()->where('id', $tokenId)->delete();
        return back()->with('success', 'تم إلغاء الجلسة');
    }

    public function revokeAllSessions()
    {
        auth()->user()->tokens()->delete();
        return back()->with('success', 'تم إلغاء جميع الجلسات');
    }
}