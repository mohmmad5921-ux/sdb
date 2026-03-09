<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AdminActivityLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class FeeController extends Controller
{
    public function index()
    {
        $fees = DB::table('fee_structures')->orderBy('type')->get();

        // Revenue overview (last 30 days)
        $revenue = [];
        try {
            $revenue = DB::table('transactions')
                ->where('created_at', '>=', now()->subDays(30))
                ->where('fee', '>', 0)
                ->selectRaw('type, COUNT(*) as tx_count, SUM(fee) as total_fees')
                ->groupBy('type')
                ->get();
        } catch (\Exception $e) {
        }

        $totalRevenue = collect($revenue)->sum('total_fees');

        return Inertia::render('Admin/FeeManagement', [
            'fees' => $fees,
            'revenue' => $revenue,
            'totalRevenue' => round($totalRevenue, 2),
        ]);
    }

    public function update(Request $request)
    {
        $fees = $request->input('fees', []);
        foreach ($fees as $id => $data) {
            DB::table('fee_structures')->where('id', $id)->update([
                'fixed_fee' => $data['fixed_fee'] ?? 0,
                'percentage_fee' => $data['percentage_fee'] ?? 0,
                'min_fee' => $data['min_fee'] ?? 0,
                'max_fee' => $data['max_fee'] ?? 0,
                'is_active' => $data['is_active'] ?? true,
                'updated_at' => now(),
            ]);
        }
        AdminActivityLog::log('fees.update', null, null, ['count' => count($fees)]);
        return back()->with('success', 'تم تحديث الرسوم بنجاح');
    }
}
