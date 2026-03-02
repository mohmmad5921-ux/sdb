<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\Account;
use App\Models\Currency;
use App\Models\Transaction;
use App\Services\CryptoPriceService;
use App\Services\CryptoService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CryptoController extends Controller
{
    public function __construct(
        private CryptoService $cryptoService,
        private CryptoPriceService $priceService,
    ) {
    }

    /**
     * Crypto trading page
     */
    public function index()
    {
        $user = auth()->user();
        $prices = $this->priceService->getAllPrices();

        // Get user's crypto accounts with balances
        $cryptoCurrencies = Currency::where('type', 'crypto')->where('is_active', true)->get();
        $cryptoBalances = [];

        foreach ($cryptoCurrencies as $currency) {
            $account = Account::where('user_id', $user->id)
                ->where('currency_id', $currency->id)
                ->first();

            $price = $prices[$currency->code]['price'] ?? 0;
            $balance = $account ? (float) $account->balance : 0;

            $cryptoBalances[] = [
                'code' => $currency->code,
                'name' => $currency->name,
                'name_ar' => $currency->name_ar,
                'symbol' => $currency->symbol,
                'balance' => $balance,
                'price' => $price,
                'value_eur' => round($balance * $price, 2),
                'change_24h' => $prices[$currency->code]['change_24h'] ?? 0,
            ];
        }

        // EUR account balance
        $eurAccount = Account::where('user_id', $user->id)
            ->whereHas('currency', fn($q) => $q->where('code', 'EUR'))
            ->first();

        // Recent crypto transactions
        $accountIds = Account::where('user_id', $user->id)->pluck('id');
        $recentTrades = Transaction::where(function ($q) use ($accountIds) {
            $q->whereIn('from_account_id', $accountIds)
                ->orWhereIn('to_account_id', $accountIds);
        })
            ->where('metadata', 'like', '%crypto_%')
            ->with(['currency', 'fromAccount.currency', 'toAccount.currency'])
            ->orderByDesc('created_at')
            ->limit(20)
            ->get();

        return Inertia::render('Banking/Crypto', [
            'cryptoBalances' => $cryptoBalances,
            'eurBalance' => $eurAccount ? round((float) $eurAccount->available_balance, 2) : 0,
            'recentTrades' => $recentTrades,
            'spreadPercent' => config('crypto.spread_percent', 0.5),
        ]);
    }

    /**
     * AJAX: Get live prices
     */
    public function prices()
    {
        return response()->json($this->priceService->getAllPrices());
    }

    /**
     * Buy crypto with EUR
     */
    public function buy(Request $request)
    {
        $request->validate([
            'crypto_code' => 'required|string|in:BTC,ETH,USDT,SOL,XRP,ADA',
            'eur_amount' => 'required|numeric|min:10',
        ]);

        try {
            $transaction = $this->cryptoService->buy(
                auth()->user(),
                $request->crypto_code,
                $request->eur_amount
            );

            return back()->with('success', "Bought {$request->crypto_code} successfully!");
        } catch (\Exception $e) {
            return back()->withErrors(['eur_amount' => $e->getMessage()]);
        }
    }

    /**
     * Sell crypto for EUR
     */
    public function sell(Request $request)
    {
        $request->validate([
            'crypto_code' => 'required|string|in:BTC,ETH,USDT,SOL,XRP,ADA',
            'crypto_amount' => 'required|numeric|min:0.00000001',
        ]);

        try {
            $transaction = $this->cryptoService->sell(
                auth()->user(),
                $request->crypto_code,
                $request->crypto_amount
            );

            return back()->with('success', "Sold {$request->crypto_code} successfully!");
        } catch (\Exception $e) {
            return back()->withErrors(['crypto_amount' => $e->getMessage()]);
        }
    }
}
