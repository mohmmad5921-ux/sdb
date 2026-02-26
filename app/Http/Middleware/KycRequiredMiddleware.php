<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class KycRequiredMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        $user = $request->user();

        if ($user && !$user->isAdmin() && !$user->isKycVerified()) {
            // Allow access to KYC page, profile, logout, and notifications
            $allowed = ['banking.kyc', 'banking.kyc.upload', 'banking.kyc.delete',
                        'banking.notifications', 'banking.notifications.read', 'banking.notifications.read-all',
                        'profile.edit', 'profile.update', 'profile.destroy', 'logout'];

            if (!in_array($request->route()?->getName(), $allowed)) {
                if ($request->expectsJson()) {
                    return response()->json([
                        'message' => 'KYC verification required. Please complete identity verification first.',
                        'kyc_status' => $user->kyc_status,
                    ], 403);
                }
                return redirect()->route('banking.kyc')
                    ->with('warning', 'يرجى إكمال التحقق من هويتك أولاً للوصول إلى خدماتك المصرفية');
            }
        }

        return $next($request);
    }
}