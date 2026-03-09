<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AdminActivityLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Inertia\Inertia;

class RateController extends Controller
{
    public function index()
    {
        // Get live rates from CoinGecko
        $liveRates = [];
        try {
            $response = Http::timeout(5)->get('https://api.coingecko.com/api/v3/exchange_rates');
            if ($response->ok()) {
                $data = $response->json('rates');
                $liveRates = collect($data)->take(15)->map(fn($r, $k) => [
                    'code' => strtoupper($k),
                    'name' => $r['name'],
                    'value' => $r['value'],
                    'type' => $r['type'],
                ])->values();
            }
        } catch (\Exception $e) {
        }

        // Custom rate overrides from app_settings
        $overrides = [];
        try {
            $setting = DB::table('app_settings')->where('key', 'rate_overrides')->first();
            if ($setting)
                $overrides = json_decode($setting->value, true) ?: [];
        } catch (\Exception $e) {
        }

        // Spread settings
        $spread = DB::table('app_settings')->where('key', 'exchange_spread')->value('value') ?? '1.5';

        return Inertia::render('Admin/RateManagement', [
            'liveRates' => $liveRates,
            'overrides' => $overrides,
            'spread' => $spread,
        ]);
    }

    public function updateSpread(Request $request)
    {
        $request->validate(['spread' => 'required|numeric|min:0|max:10']);
        DB::table('app_settings')->updateOrInsert(
            ['key' => 'exchange_spread'],
            ['value' => $request->spread, 'type' => 'string', 'group' => 'rates', 'label' => 'هامش الصرف %', 'updated_at' => now()]
        );
        AdminActivityLog::log('rates.spread_update', null, null, ['spread' => $request->spread]);
        return back()->with('success', 'تم تحديث هامش الصرف');
    }
}
