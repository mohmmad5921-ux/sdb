<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class LimitsController extends Controller
{
    public function index()
    {
        $limits = DB::table('account_limits')->orderBy('kyc_level')->orderBy('limit_type')->get();
        $grouped = $limits->groupBy('kyc_level');
        return Inertia::render('Admin/Limits', ['limits' => $limits, 'grouped' => $grouped]);
    }

    public function update(Request $request)
    {
        foreach ($request->limits as $limit) {
            $old = DB::table('account_limits')->find($limit['id']);
            DB::table('account_limits')->where('id', $limit['id'])->update([
                'amount' => $limit['amount'],
                'active' => $limit['active'] ?? true,
                'updated_at' => now(),
            ]);

            if ($old && $old->amount != $limit['amount']) {
                DB::table('system_changelog')->insert([
                    'admin_id' => auth()->id(),
                    'category' => 'limits',
                    'action' => 'update',
                    'target' => "{$old->kyc_level}_{$old->limit_type}",
                    'old_value' => json_encode(['amount' => $old->amount]),
                    'new_value' => json_encode(['amount' => $limit['amount']]),
                    'ip_address' => $request->ip(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }
        return back()->with('success', 'تم تحديث الحدود');
    }
}
