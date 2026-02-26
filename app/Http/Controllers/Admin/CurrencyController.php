<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Currency;
use App\Models\ExchangeRate;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CurrencyController extends Controller
{
    public function index()
    {
        $currencies = Currency::withCount('accounts')->get();
        $exchangeRates = ExchangeRate::with(['fromCurrency', 'toCurrency'])->get();

        return Inertia::render('Admin/Currencies', [
            'currencies' => $currencies,
            'exchangeRates' => $exchangeRates,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'code' => 'required|string|max:10|unique:currencies,code',
            'name' => 'required|string|max:100',
            'name_ar' => 'required|string|max:100',
            'symbol' => 'required|string|max:10',
            'type' => 'required|in:fiat,crypto',
            'exchange_rate_to_eur' => 'required|numeric|min:0',
            'is_active' => 'boolean',
            'decimal_places' => 'integer|min:0|max:8',
        ]);

        Currency::create($validated);
        return back()->with('success', 'Currency added');
    }

    public function update(Request $request, Currency $currency)
    {
        $validated = $request->validate([
            'name' => 'string|max:100',
            'name_ar' => 'string|max:100',
            'symbol' => 'string|max:10',
            'exchange_rate_to_eur' => 'numeric|min:0',
            'is_active' => 'boolean',
            'is_default' => 'boolean',
        ]);

        $currency->update($validated);
        return back()->with('success', 'Currency updated');
    }

    public function updateRate(Request $request)
    {
        $validated = $request->validate([
            'from_currency_id' => 'required|exists:currencies,id',
            'to_currency_id' => 'required|exists:currencies,id',
            'rate' => 'required|numeric|min:0',
            'buy_rate' => 'required|numeric|min:0',
            'sell_rate' => 'required|numeric|min:0',
            'spread' => 'numeric|min:0',
        ]);

        ExchangeRate::updateOrCreate(
        ['from_currency_id' => $validated['from_currency_id'], 'to_currency_id' => $validated['to_currency_id']],
            $validated
        );

        return back()->with('success', 'Exchange rate updated');
    }
}