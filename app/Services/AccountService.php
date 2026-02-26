<?php

namespace App\Services;

use App\Models\Account;
use App\Models\Currency;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class AccountService
{
    public function __construct(private IbanService $ibanService)
    {
    }

    /**
     * Create default accounts (EUR + USD) for a new user
     */
    public function createDefaultAccounts(User $user): array
    {
        $accounts = [];
        $defaultCurrencies = Currency::where('is_default', true)->get();

        if ($defaultCurrencies->isEmpty()) {
            $defaultCurrencies = Currency::whereIn('code', ['EUR', 'USD'])->get();
        }

        foreach ($defaultCurrencies as $index => $currency) {
            $accounts[] = $this->createAccount($user, $currency, $index === 0);
        }

        return $accounts;
    }

    /**
     * Create a new account for a user
     */
    public function createAccount(User $user, Currency $currency, bool $isDefault = false): Account
    {
        $accountNumber = $this->ibanService->generateAccountNumber();
        $iban = $this->ibanService->generate();

        return Account::create([
            'user_id' => $user->id,
            'currency_id' => $currency->id,
            'account_number' => $accountNumber,
            'iban' => $iban,
            'balance' => 0,
            'available_balance' => 0,
            'held_balance' => 0,
            'status' => 'active',
            'is_default' => $isDefault,
            'account_name' => $currency->name . ' Account',
        ]);
    }

    /**
     * Credit an account (add money)
     */
    public function credit(Account $account, float $amount, string $description = ''): void
    {
        DB::transaction(function () use ($account, $amount) {
            $account->lockForUpdate();
            $account->increment('balance', $amount);
            $account->increment('available_balance', $amount);
        });
    }

    /**
     * Debit an account (remove money)
     */
    public function debit(Account $account, float $amount, string $description = ''): bool
    {
        return DB::transaction(function () use ($account, $amount) {
            $account->lockForUpdate();

            if ($account->available_balance < $amount) {
                return false;
            }

            $account->decrement('balance', $amount);
            $account->decrement('available_balance', $amount);
            return true;
        });
    }

    /**
     * Hold funds (for pending transactions)
     */
    public function holdFunds(Account $account, float $amount): bool
    {
        return DB::transaction(function () use ($account, $amount) {
            $account->lockForUpdate();

            if ($account->available_balance < $amount) {
                return false;
            }

            $account->decrement('available_balance', $amount);
            $account->increment('held_balance', $amount);
            return true;
        });
    }

    /**
     * Release held funds
     */
    public function releaseFunds(Account $account, float $amount): void
    {
        DB::transaction(function () use ($account, $amount) {
            $account->lockForUpdate();
            $account->increment('available_balance', $amount);
            $account->decrement('held_balance', $amount);
        });
    }

    /**
     * Get account statement
     */
    public function getStatement(Account $account, ?string $from = null, ?string $to = null)
    {
        $query = $account->outgoingTransactions()
            ->orWhere('to_account_id', $account->id)
            ->with(['currency', 'fromAccount', 'toAccount'])
            ->orderByDesc('created_at');

        if ($from)
            $query->where('created_at', '>=', $from);
        if ($to)
            $query->where('created_at', '<=', $to);

        return $query->paginate(20);
    }
}