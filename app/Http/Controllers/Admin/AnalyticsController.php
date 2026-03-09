<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Transaction;
use App\Models\Preregistration;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Inertia\Inertia;

class AnalyticsController extends Controller
{
    public function index()
    {
        // Monthly stats (last 6 months)
        $monthly = [];
        for ($i = 5; $i >= 0; $i--) {
            $start = Carbon::now()->subMonths($i)->startOfMonth();
            $end = Carbon::now()->subMonths($i)->endOfMonth();
            $monthly[] = [
                'month' => $start->format('Y-m'),
                'label' => $start->translatedFormat('M Y'),
                'users' => User::where('role', 'customer')->whereBetween('created_at', [$start, $end])->count(),
                'transactions' => Transaction::whereBetween('created_at', [$start, $end])->count(),
                'volume' => Transaction::where('status', 'completed')->whereBetween('created_at', [$start, $end])->sum('amount_in_eur'),
            ];
        }

        // Conversion rate: preregistration -> actual user
        $totalPrereg = 0;
        $converted = 0;
        try {
            $totalPrereg = Preregistration::count();
            $preregEmails = Preregistration::pluck('email');
            $converted = User::where('role', 'customer')->whereIn('email', $preregEmails)->count();
        } catch (\Exception $e) {
        }

        // Peak hours (last 30 days)
        $peakHours = [];
        try {
            $hourlyData = Transaction::where('created_at', '>=', Carbon::now()->subDays(30))
                ->selectRaw('cast(strftime('%H', created_at) as integer) as hour, COUNT(*) as count')
                ->groupBy('hour')
                ->orderBy('hour')
                ->get();
            for ($h = 0; $h < 24; $h++) {
                $found = $hourlyData->firstWhere('hour', $h);
                $peakHours[] = ['hour' => $h, 'label' => sprintf('%02d:00', $h), 'count' => $found ? $found->count : 0];
            }
        } catch (\Exception $e) {
            for ($h = 0; $h < 24; $h++) {
                $peakHours[] = ['hour' => $h, 'label' => sprintf('%02d:00', $h), 'count' => 0];
            }
        }

        // Transaction types breakdown
        $typeBreakdown = [];
        try {
            $typeBreakdown = Transaction::where('created_at', '>=', Carbon::now()->subDays(30))
                ->selectRaw('type, COUNT(*) as count, SUM(amount_in_eur) as volume')
                ->groupBy('type')
                ->orderByDesc('count')
                ->get();
        } catch (\Exception $e) {
        }

        // User status breakdown
        $userStatus = User::where('role', 'customer')
            ->selectRaw('status, COUNT(*) as count')
            ->groupBy('status')
            ->get();

        // KYC status breakdown
        $kycStatus = User::where('role', 'customer')
            ->selectRaw('kyc_status, COUNT(*) as count')
            ->groupBy('kyc_status')
            ->get();

        return Inertia::render('Admin/Analytics', [
            'monthly' => $monthly,
            'conversion' => ['total_prereg' => $totalPrereg, 'converted' => $converted, 'rate' => $totalPrereg > 0 ? round(($converted / $totalPrereg) * 100, 1) : 0],
            'peakHours' => $peakHours,
            'typeBreakdown' => $typeBreakdown,
            'userStatus' => $userStatus,
            'kycStatus' => $kycStatus,
        ]);
    }
}
