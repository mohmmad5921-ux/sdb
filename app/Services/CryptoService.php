<?php

namespace App\Services;

use App\Models\Account;
use App\Models\Currency;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class CryptoService
{
    public function __construct(
        private AccountService $accountService,
        private CryptoPriceService $priceService,
        private IbanService $ibanService,
    ) {
    }

    /**
     * Get a quote for buying crypto with EUR
     */
    public function getBuyQuote(string $cryptoCode, float $eurAmount): array
    {
        $buyPrice = $this->priceService->getBuyPrice($cryptoCode);
        $marketPrice = $this->priceService->getPrice($cryptoCode);

        if ($buyPrice <= 0) {
            throw new \Exception("Price not available for {$cryptoCode}");
        }

        $cryptoAmount = $eurAmount / $buyPrice;
        $spread = $eurAmount - ($cryptoAmount * $marketPrice);

        return [
            'crypto_code' => $cryptoCode,
            'eur_amount' => round($eurAmount, 2),
            'crypto_amount' => $cryptoAmount,
            'price_per_unit' => round($buyPrice, 2),
            'market_price' => round($marketPrice, 2),
            'spread_fee' => round($spread, 2),
            'side' => 'buy',
        ];
    }

    /**
     * Get a quote for selling crypto for EUR
     */
    public function getSellQuote(string $cryptoCode, float $cryptoAmount): array
    {
        $sellPrice = $this->priceService->getSellPrice($cryptoCode);
        $marketPrice = $this->priceService->getPrice($cryptoCode);

        if ($sellPrice <= 0) {
            throw new \Exception("Price not available for {$cryptoCode}");
        }

        $eurAmount = $cryptoAmount * $sellPrice;
        $spread = ($cryptoAmount * $marketPrice) - $eurAmount;

        return [
            'crypto_code' => $cryptoCode,
            'eur_amount' => round($eurAmount, 2),
            'crypto_amount' => $cryptoAmount,
            'price_per_unit' => round($sellPrice, 2),
            'market_price' => round($marketPrice, 2),
            'spread_fee' => round($spread, 2),
            'side' => 'sell',
        ];
    }

    /**
     * Execute a crypto buy: debit EUR, credit crypto
     */
    public function buy(User $user, string $cryptoCode, float $eurAmount): Transaction
    {
        $minTrade = config('crypto.min_trade_eur', 10);
        $maxTrade = config('crypto.max_trade_eur', 50000);

        if ($eurAmount < $minTrade) {
            throw new \Exception("Minimum trade is €{$minTrade}");
        }
        if ($eurAmount > $maxTrade) {
            throw new \Exception("Maximum trade is €{$maxTrade}");
        }

        $quote = $this->getBuyQuote($cryptoCode, $eurAmount);

        return DB::transaction(function () use ($user, $quote, $cryptoCode, $eurAmount) {
            // Find or create EUR account
            $eurAccount = $this->getOrCreateAccount($user, 'EUR');

            if ($eurAccount->available_balance < $eurAmount) {
                throw new \Exception('Insufficient EUR balance');
            }

            // Find or create crypto account
            $cryptoAccount = $this->getOrCreateAccount($user, $cryptoCode);

            // Debit EUR
            $this->accountService->debit($eurAccount, $eurAmount);

            // Credit crypto
            $this->accountService->credit($cryptoAccount, $quote['crypto_amount']);

            // Record transaction
            return Transaction::create([
                'reference_number' => Transaction::generateReference(),
                'from_account_id' => $eurAccount->id,
                'to_account_id' => $cryptoAccount->id,
                'currency_id' => $eurAccount->currency_id,
                'amount' => $eurAmount,
                'exchange_rate' => $quote['price_per_unit'],
                'original_amount' => $quote['crypto_amount'],
                'original_currency_id' => $cryptoAccount->currency_id,
                'type' => 'exchange',
                'status' => 'completed',
                'description' => "Buy {$cryptoCode} — {$quote['crypto_amount']} @ €{$quote['price_per_unit']}",
                'metadata' => [
                    'trade_type' => 'crypto_buy',
                    'crypto_code' => $cryptoCode,
                    'market_price' => $quote['market_price'],
                    'spread_fee' => $quote['spread_fee'],
                ],
                'completed_at' => now(),
            ]);
        });
    }

    /**
     * Execute a crypto sell: debit crypto, credit EUR
     */
    public function sell(User $user, string $cryptoCode, float $cryptoAmount): Transaction
    {
        $quote = $this->getSellQuote($cryptoCode, $cryptoAmount);

        $minTrade = config('crypto.min_trade_eur', 10);
        if ($quote['eur_amount'] < $minTrade) {
            throw new \Exception("Minimum trade value is €{$minTrade}");
        }

        return DB::transaction(function () use ($user, $quote, $cryptoCode, $cryptoAmount) {
            $cryptoAccount = $this->getOrCreateAccount($user, $cryptoCode);

            if ($cryptoAccount->available_balance < $cryptoAmount) {
                throw new \Exception("Insufficient {$cryptoCode} balance");
            }

            $eurAccount = $this->getOrCreateAccount($user, 'EUR');

            // Debit crypto
            $this->accountService->debit($cryptoAccount, $cryptoAmount);

            // Credit EUR
            $this->accountService->credit($eurAccount, $quote['eur_amount']);

            // Record transaction
            return Transaction::create([
                'reference_number' => Transaction::generateReference(),
                'from_account_id' => $cryptoAccount->id,
                'to_account_id' => $eurAccount->id,
                'currency_id' => $cryptoAccount->currency_id,
                'amount' => $cryptoAmount,
                'exchange_rate' => $quote['price_per_unit'],
                'original_amount' => $quote['eur_amount'],
                'original_currency_id' => $eurAccount->currency_id,
                'type' => 'exchange',
                'status' => 'completed',
                'description' => "Sell {$cryptoCode} — {$cryptoAmount} @ €{$quote['price_per_unit']}",
                'metadata' => [
                    'trade_type' => 'crypto_sell',
                    'crypto_code' => $cryptoCode,
                    'market_price' => $quote['market_price'],
                    'spread_fee' => $quote['spread_fee'],
                ],
                'completed_at' => now(),
            ]);
        });
    }

    /**
     * Get or create an account for a given currency code
     */
    private function getOrCreateAccount(User $user, string $currencyCode): Account
    {
        $currency = Currency::where('code', $currencyCode)->firstOrFail();

        $account = Account::where('user_id', $user->id)
            ->where('currency_id', $currency->id)
            ->first();

        if (!$account) {
            $account = $this->accountService->createAccount($user, $currency);
        }

        return $account;
    }
}
