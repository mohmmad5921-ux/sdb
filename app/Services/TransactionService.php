<?php

namespace App\Services;

use App\Models\Account;
use App\Models\Transaction;
use Illuminate\Support\Facades\DB;

class TransactionService
{
    public function __construct(
        private AccountService $accountService,
        private CurrencyService $currencyService,
        )
    {
    }

    /**
     * Process internal transfer between accounts
     */
    public function transfer(
        Account $fromAccount,
        Account $toAccount,
        float $amount,
        string $description = '',
        float $fee = 0
        ): Transaction
    {
        return DB::transaction(function () use ($fromAccount, $toAccount, $amount, $description, $fee) {
            $totalDebit = $amount + $fee;

            // Validate
            if ($fromAccount->id === $toAccount->id) {
                throw new \Exception('Cannot transfer to the same account');
            }
            if (!$fromAccount->isActive() || !$toAccount->isActive()) {
                throw new \Exception('One or both accounts are not active');
            }
            if ($fromAccount->available_balance < $totalDebit) {
                throw new \Exception('Insufficient balance');
            }

            // Handle currency conversion if needed
            $exchangeRate = null;
            $creditAmount = $amount;

            if ($fromAccount->currency_id !== $toAccount->currency_id) {
                $exchangeRate = $this->currencyService->getRate(
                    $fromAccount->currency_id,
                    $toAccount->currency_id
                );
                $creditAmount = $amount * $exchangeRate;
            }

            // Debit sender
            $this->accountService->debit($fromAccount, $totalDebit);

            // Credit receiver
            $this->accountService->credit($toAccount, $creditAmount);

            // Create transaction record
            $transaction = Transaction::create([
                'reference_number' => Transaction::generateReference(),
                'from_account_id' => $fromAccount->id,
                'to_account_id' => $toAccount->id,
                'currency_id' => $fromAccount->currency_id,
                'amount' => $amount,
                'fee' => $fee,
                'exchange_rate' => $exchangeRate,
                'original_amount' => $exchangeRate ? $creditAmount : null,
                'original_currency_id' => $exchangeRate ? $toAccount->currency_id : null,
                'type' => 'transfer',
                'status' => 'completed',
                'description' => $description,
                'completed_at' => now(),
            ]);

            // Create fee transaction if applicable
            if ($fee > 0) {
                Transaction::create([
                    'reference_number' => Transaction::generateReference(),
                    'from_account_id' => $fromAccount->id,
                    'currency_id' => $fromAccount->currency_id,
                    'amount' => $fee,
                    'type' => 'fee',
                    'status' => 'completed',
                    'description' => 'Transfer fee - ' . $transaction->reference_number,
                    'completed_at' => now(),
                    'metadata' => ['parent_transaction_id' => $transaction->id],
                ]);
            }

            return $transaction;
        });
    }

    /**
     * Process currency exchange
     */
    public function exchange(
        Account $fromAccount,
        Account $toAccount,
        float $amount,
        float $rate
        ): Transaction
    {
        return DB::transaction(function () use ($fromAccount, $toAccount, $amount, $rate) {
            if (!$fromAccount->isActive() || !$toAccount->isActive()) {
                throw new \Exception('Accounts must be active');
            }
            if ($fromAccount->user_id !== $toAccount->user_id) {
                throw new \Exception('Exchange only between own accounts');
            }
            if ($fromAccount->available_balance < $amount) {
                throw new \Exception('Insufficient balance');
            }

            $convertedAmount = $amount * $rate;

            $this->accountService->debit($fromAccount, $amount);
            $this->accountService->credit($toAccount, $convertedAmount);

            return Transaction::create([
                'reference_number' => Transaction::generateReference(),
                'from_account_id' => $fromAccount->id,
                'to_account_id' => $toAccount->id,
                'currency_id' => $fromAccount->currency_id,
                'amount' => $amount,
                'exchange_rate' => $rate,
                'original_amount' => $convertedAmount,
                'original_currency_id' => $toAccount->currency_id,
                'type' => 'exchange',
                'status' => 'completed',
                'description' => "Exchange {$fromAccount->currency->code} → {$toAccount->currency->code}",
                'completed_at' => now(),
            ]);
        });
    }

    /**
     * Process deposit
     */
    public function deposit(Account $account, float $amount, string $description = ''): Transaction
    {
        return DB::transaction(function () use ($account, $amount, $description) {
            $this->accountService->credit($account, $amount);

            return Transaction::create([
                'reference_number' => Transaction::generateReference(),
                'to_account_id' => $account->id,
                'currency_id' => $account->currency_id,
                'amount' => $amount,
                'type' => 'deposit',
                'status' => 'completed',
                'description' => $description ?: 'Deposit',
                'completed_at' => now(),
            ]);
        });
    }

    /**
     * Get user transactions across all accounts
     */
    public function getUserTransactions(int $userId, int $perPage = 20)
    {
        $accountIds = Account::where('user_id', $userId)->pluck('id');

        return Transaction::where(function ($query) use ($accountIds) {
            $query->whereIn('from_account_id', $accountIds)
                ->orWhereIn('to_account_id', $accountIds);
        })
            ->with(['currency', 'fromAccount.currency', 'toAccount.currency'])
            ->orderByDesc('created_at')
            ->paginate($perPage);
    }
}