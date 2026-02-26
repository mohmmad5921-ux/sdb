<?php

namespace App\Services;

use App\Models\Currency;
use App\Models\ExchangeRate;

class CurrencyService
{
    /**
     * Get exchange rate between two currencies
     */
    public function getRate(int $fromCurrencyId, int $toCurrencyId): float
    {
        // Direct rate
        $rate = ExchangeRate::where('from_currency_id', $fromCurrencyId)
            ->where('to_currency_id', $toCurrencyId)
            ->where('is_active', true)
            ->first();

        if ($rate) {
            return (float)$rate->sell_rate;
        }

        // Reverse rate
        $reverseRate = ExchangeRate::where('from_currency_id', $toCurrencyId)
            ->where('to_currency_id', $fromCurrencyId)
            ->where('is_active', true)
            ->first();

        if ($reverseRate) {
            return 1 / (float)$reverseRate->buy_rate;
        }

        // Cross rate through EUR
        $fromCurrency = Currency::findOrFail($fromCurrencyId);
        $toCurrency = Currency::findOrFail($toCurrencyId);

        if ($fromCurrency->exchange_rate_to_eur > 0 && $toCurrency->exchange_rate_to_eur > 0) {
            return (float)$toCurrency->exchange_rate_to_eur / (float)$fromCurrency->exchange_rate_to_eur;
        }

        throw new \Exception('Exchange rate not available');
    }

    /**
     * Convert amount between currencies
     */
    public function convert(float $amount, int $fromCurrencyId, int $toCurrencyId): array
    {
        $rate = $this->getRate($fromCurrencyId, $toCurrencyId);
        return [
            'amount' => round($amount * $rate, 4),
            'rate' => $rate,
            'from_currency_id' => $fromCurrencyId,
            'to_currency_id' => $toCurrencyId,
        ];
    }

    /**
     * Get all available exchange rates for a currency
     */
    public function getRatesForCurrency(int $currencyId): array
    {
        $rates = [];
        $currencies = Currency::where('id', '!=', $currencyId)->where('is_active', true)->get();

        foreach ($currencies as $currency) {
            try {
                $rates[] = [
                    'currency' => $currency,
                    'rate' => $this->getRate($currencyId, $currency->id),
                ];
            }
            catch (\Exception $e) {
                continue;
            }
        }

        return $rates;
    }
}