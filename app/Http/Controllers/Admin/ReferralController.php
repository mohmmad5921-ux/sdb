<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class ReferralController extends Controller
{
    public function index()
    {
        $referrals = DB::table('referrals')
            ->join('users as r', 'referrals.referrer_id', '=', 'r.id')
            ->join('users as d', 'referrals.referred_id', '=', 'd.id')
            ->select('referrals.*', 'r.name as referrer_name', 'r.email as referrer_email', 'd.name as referred_name', 'd.email as referred_email')
            ->orderBy('referrals.created_at', 'desc')->limit(100)->get();
        $stats = [
            'total' => DB::table('referrals')->count(),
            'completed' => DB::table('referrals')->where('status', 'completed')->count(),
            'rewarded' => DB::table('referrals')->where('status', 'rewarded')->count(),
            'total_rewards' => DB::table('referrals')->where('status', 'rewarded')->sum('reward_amount'),
        ];
        return Inertia::render('Admin/Referrals', ['referrals' => $referrals, 'stats' => $stats]);
    }
}
