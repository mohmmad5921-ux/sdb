<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class FetchExchangeRates extends Command
{
    protected $signature = 'rates:fetch';
    protected $description = 'Fetch live exchange rates from free API and cache them';

    public function handle()
    {
        $this->info('Fetching exchange rates...');

        try {
            // Primary: open.er-api.com (free, no key, includes SYP)
            $response = Http::timeout(10)->get('https://open.er-api.com/v6/latest/EUR');

            if ($response->successful()) {
                $data = $response->json();
                if ($data['result'] === 'success') {
                    $rates = $data['rates'];

                    // SYP: API returns official central bank rate (~130).
                    // Override with market rate (configurable via .env or admin)
                    $sypMarket = (float) env('SYP_MARKET_RATE', 13500);
                    if ($sypMarket > 0) {
                        $rates['SYP'] = $sypMarket;
                    }

                    // Store rates vs EUR (base)
                    Cache::put('live_rates', $rates, now()->addHours(6));
                    Cache::put('live_rates_updated', now()->toISOString(), now()->addHours(6));

                    // Also update Currency model if exchange_rate_to_eur column exists
                    $this->updateDatabaseRates($rates);

                    $this->info('✅ Rates fetched successfully: ' . count($rates) . ' currencies');
                    $this->info('SYP rate: 1 EUR = ' . ($rates['SYP'] ?? 'N/A') . ' SYP');
                    return 0;
                }
            }

            // Fallback: frankfurter.app (ECB data, fewer currencies but reliable)
            $this->warn('Primary API failed, trying fallback...');
            $fallback = Http::timeout(10)->get('https://api.frankfurter.app/latest?from=EUR');

            if ($fallback->successful()) {
                $rates = $fallback->json()['rates'] ?? [];
                $rates['EUR'] = 1;

                Cache::put('live_rates', $rates, now()->addHours(6));
                Cache::put('live_rates_updated', now()->toISOString(), now()->addHours(6));

                $this->info('✅ Fallback rates fetched: ' . count($rates) . ' currencies');
                return 0;
            }

            $this->error('❌ Both APIs failed');
            return 1;

        } catch (\Exception $e) {
            Log::error('FetchExchangeRates failed: ' . $e->getMessage());
            $this->error('❌ Error: ' . $e->getMessage());
            return 1;
        }
    }

    private function updateDatabaseRates(array $rates): void
    {
        try {
            $currencies = \App\Models\Currency::all();
            foreach ($currencies as $currency) {
                $code = strtoupper($currency->code);
                if (isset($rates[$code])) {
                    // exchange_rate_to_eur = how many units of this currency per 1 EUR
                    $currency->exchange_rate_to_eur = $rates[$code];
                    $currency->save();
                }
            }
        } catch (\Exception $e) {
            // Database update is optional, don't fail the command
            Log::warning('Could not update database rates: ' . $e->getMessage());
        }
    }
}
