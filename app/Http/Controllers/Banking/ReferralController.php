<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\Referral;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ReferralController extends Controller
{
    public function index()
    {
        $user = auth()->user();

        // Generate referral code if not exists
        if (!$user->referral_code) {
            $user->update(['referral_code' => strtoupper(substr(md5($user->id . $user->email), 0, 8))]);
        }

        $referrals = Referral::where('referrer_id', $user->id)
            ->with('referred')
            ->orderByDesc('created_at')
            ->get();

        $stats = [
            'total_referrals' => $referrals->count(),
            'completed' => $referrals->where('status', 'completed')->count(),
            'total_earned' => $referrals->where('status', 'rewarded')->sum('reward_amount'),
        ];

        return Inertia::render('Banking/Referral', [
            'referralCode' => $user->referral_code,
            'referralLink' => url('/register?ref=' . $user->referral_code),
            'referrals' => $referrals,
            'stats' => $stats,
        ]);
    }
}