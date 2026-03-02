<?php

namespace App\Services;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;

class CryptoPriceService
{
    /**
     * Supported cryptos with their CoinGecko IDs
     */
    private array $cryptoMap = [
        'BTC' => 'bitcoin',
        'ETH' => 'ethereum',
        'USDT' => 'tether',
        'SOL' => 'solana',
        'XRP' => 'ripple',
        'ADA' => 'cardano',
    ];

    /**
     * Get live prices for all supported cryptos in EUR
     */
    public function getAllPrices(): array
    {
        return Cache::remember('crypto_prices', 30, function () {
            try {
                $ids = implode(',', array_values($this->cryptoMap));
                $response = Http::timeout(10)->get(
                    'https://api.coingecko.com/api/v3/simple/price',
                    [
                        'ids' => $ids,
                        'vs_currencies' => 'eur',
                        'include_24hr_change' => 'true',
                    ]
                );

                if (!$response->successful()) {
                    return $this->getFallbackPrices();
                }

                $data = $response->json();
                $prices = [];

                foreach ($this->cryptoMap as $code => $geckoId) {
                    if (isset($data[$geckoId])) {
                        $prices[$code] = [
                            'price' => $data[$geckoId]['eur'] ?? 0,
                            'change_24h' => round($data[$geckoId]['eur_24h_change'] ?? 0, 2),
                        ];
                    }
                }

                return $prices;
            } catch (\Exception $e) {
                return $this->getFallbackPrices();
            }
        });
    }

    /**
     * Get price for a single crypto in EUR
     */
    public function getPrice(string $code): float
    {
        $prices = $this->getAllPrices();
        return $prices[$code]['price'] ?? 0;
    }

    /**
     * Get buy price (with spread added)
     */
    public function getBuyPrice(string $code): float
    {
        $price = $this->getPrice($code);
        $spread = config('crypto.spread_percent', 0.5) / 100;
        return $price * (1 + $spread);
    }

    /**
     * Get sell price (with spread subtracted)
     */
    public function getSellPrice(string $code): float
    {
        $price = $this->getPrice($code);
        $spread = config('crypto.spread_percent', 0.5) / 100;
        return $price * (1 - $spread);
    }

    /**
     * Fallback prices in case CoinGecko is unreachable
     */
    private function getFallbackPrices(): array
    {
        return [
            'BTC' => ['price' => 89450, 'change_24h' => 0],
            'ETH' => ['price' => 3210, 'change_24h' => 0],
            'USDT' => ['price' => 0.92, 'change_24h' => 0],
            'SOL' => ['price' => 183, 'change_24h' => 0],
            'XRP' => ['price' => 2.15, 'change_24h' => 0],
            'ADA' => ['price' => 0.68, 'change_24h' => 0],
        ];
    }
}
