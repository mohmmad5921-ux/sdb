<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\Account;
use App\Models\Transaction;
use App\Models\Currency;
use App\Services\AccountService;
use App\Services\CardService;
use App\Services\CurrencyService;
use App\Services\DepositService;
use App\Services\IbanService;
use App\Services\TransactionService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class BankingController extends Controller
{
    public function __construct(
        private AccountService $accountService,
        private TransactionService $transactionService,
        private CardService $cardService,
        private CurrencyService $currencyService,
        private DepositService $depositService,
        )
    {
    }

    /**
     * Customer Dashboard
     */
    public function dashboard()
    {
        $user = auth()->user();
        $accounts = $user->accounts()->with('currency')->get();
        $cards = $user->cards()->with('account.currency')->get();

        $accountIds = $accounts->pluck('id');
        $recentTransactions = Transaction::where(function ($q) use ($accountIds) {
            $q->whereIn('from_account_id', $accountIds)
                ->orWhereIn('to_account_id', $accountIds);
        })
            ->with(['currency', 'fromAccount.currency', 'toAccount.currency'])
            ->orderByDesc('created_at')
            ->limit(10)
            ->get();

        $totalBalance = $accounts->sum(function ($account) {
            return $account->balance * ($account->currency->exchange_rate_to_eur ?: 1);
        });

        // Monthly spending (outgoing from user's accounts)
        $monthlySpending = Transaction::whereIn('from_account_id', $accountIds)
            ->where('status', 'completed')
            ->where('created_at', '>=', now()->startOfMonth())
            ->sum('amount');

        // Monthly income (incoming to user's accounts)
        $monthlyIncome = Transaction::whereIn('to_account_id', $accountIds)
            ->where('status', 'completed')
            ->where('created_at', '>=', now()->startOfMonth())
            ->sum('amount');

        // 7-day mini chart data
        $weeklyData = [];
        for ($i = 6; $i >= 0; $i--) {
            $date = now()->subDays($i);
            $dayOut = Transaction::whereIn('from_account_id', $accountIds)
                ->where('status', 'completed')
                ->whereDate('created_at', $date)
                ->sum('amount');
            $dayIn = Transaction::whereIn('to_account_id', $accountIds)
                ->where('status', 'completed')
                ->whereDate('created_at', $date)
                ->sum('amount');
            $weeklyData[] = [
                'day' => $date->locale('ar')->shortDayName,
                'out' => round($dayOut, 2),
                'in' => round($dayIn, 2),
            ];
        }

        // Notifications count
        $notifCount = $user->notifications()->where('is_read', false)->count();

        // Pending transactions
        $pendingTx = Transaction::where(function ($q) use ($accountIds) {
            $q->whereIn('from_account_id', $accountIds)
                ->orWhereIn('to_account_id', $accountIds);
        })->where('status', 'pending')->count();

        return Inertia::render('Banking/Dashboard', [
            'accounts' => $accounts,
            'cards' => $cards,
            'recentTransactions' => $recentTransactions,
            'totalBalanceEur' => round($totalBalance, 2),
            'currencies' => Currency::active()->get(),
            'monthlySpending' => round($monthlySpending, 2),
            'monthlyIncome' => round($monthlyIncome, 2),
            'weeklyData' => $weeklyData,
            'notifCount' => $notifCount,
            'pendingTx' => $pendingTx,
            'kycStatus' => $user->kyc_status ?? 'none',
        ]);
    }

    /**
     * Transfer money
     */
    public function transfer(Request $request)
    {
        $request->validate([
            'from_account_id' => 'required|exists:accounts,id',
            'to_iban' => 'required|string',
            'amount' => 'required|numeric|min:0.01',
            'description' => 'nullable|string|max:255',
        ]);

        $fromAccount = Account::where('id', $request->from_account_id)
            ->where('user_id', auth()->id())
            ->firstOrFail();

        $toAccount = Account::where('iban', str_replace(' ', '', $request->to_iban))->first();

        if (!$toAccount) {
            return back()->withErrors(['to_iban' => 'Account not found']);
        }

        try {
            $transaction = $this->transactionService->transfer(
                $fromAccount, $toAccount, $request->amount, $request->description ?? ''
            );
            return back()->with('success', 'Transfer completed! Ref: ' . $transaction->reference_number);
        }
        catch (\Exception $e) {
            return back()->withErrors(['amount' => $e->getMessage()]);
        }
    }

    /**
     * Exchange currencies
     */
    public function exchange(Request $request)
    {
        $request->validate([
            'from_account_id' => 'required|exists:accounts,id',
            'to_account_id' => 'required|exists:accounts,id',
            'amount' => 'required|numeric|min:0.01',
        ]);

        $fromAccount = Account::where('id', $request->from_account_id)
            ->where('user_id', auth()->id())->firstOrFail();
        $toAccount = Account::where('id', $request->to_account_id)
            ->where('user_id', auth()->id())->firstOrFail();

        try {
            $rate = $this->currencyService->getRate($fromAccount->currency_id, $toAccount->currency_id);
            $transaction = $this->transactionService->exchange($fromAccount, $toAccount, $request->amount, $rate);
            return back()->with('success', 'Exchange completed!');
        }
        catch (\Exception $e) {
            return back()->withErrors(['amount' => $e->getMessage()]);
        }
    }

    /**
     * Issue virtual card
     */
    public function issueCard(Request $request)
    {
        $request->validate(['account_id' => 'required|exists:accounts,id']);

        $account = Account::where('id', $request->account_id)
            ->where('user_id', auth()->id())->firstOrFail();

        try {
            $card = $this->cardService->issueCard(auth()->user(), $account);
            return back()->with('success', 'Virtual Mastercard issued!');
        }
        catch (\Exception $e) {
            return back()->withErrors(['account_id' => $e->getMessage()]);
        }
    }

    /**
     * Toggle card freeze
     */
    public function toggleCardFreeze(Request $request, $cardId)
    {
        $card = auth()->user()->cards()->findOrFail($cardId);

        if ($card->isActive()) {
            $this->cardService->freeze($card);
            return back()->with('success', 'Card frozen');
        }
        else {
            $this->cardService->unfreeze($card);
            return back()->with('success', 'Card activated');
        }
    }

    /**
     * Deposit via external card, Apple Pay, or Google Pay
     */
    public function deposit(Request $request)
    {
        $request->validate([
            'account_id' => 'required|exists:accounts,id',
            'amount' => 'required|numeric|min:1|max:50000',
            'payment_method' => 'required|in:card,apple_pay,google_pay',
            'card_number' => 'required_if:payment_method,card|nullable|string',
            'card_holder' => 'required|string|max:255',
            'card_expiry' => 'required|string|max:5',
            'card_cvv' => 'required_if:payment_method,card|nullable|string|max:4',
        ]);

        $account = Account::where('id', $request->account_id)
            ->where('user_id', auth()->id())
            ->firstOrFail();

        try {
            $cardNumber = $request->card_number;
            if ($request->payment_method === 'apple_pay') {
                $cardNumber = '4' . str_pad(mt_rand(0, 999999999999999), 15, '0', STR_PAD_LEFT);
            }
            elseif ($request->payment_method === 'google_pay') {
                $cardNumber = '5' . str_pad(mt_rand(0, 99999999999999), 14, '0', STR_PAD_LEFT) . '1';
            }

            $deposit = $this->depositService->depositViaCard(
                $account,
                (float)$request->amount,
                $cardNumber,
                $request->card_holder,
                $request->card_expiry,
                $request->card_cvv ?? '000',
                $request->ip(),
            );

            $methodLabel = match ($request->payment_method) {
                    'apple_pay' => 'Apple Pay',
                    'google_pay' => 'Google Pay',
                    default => 'Card ••••' . $deposit->card_last_four,
                };

            return back()->with('success', "Deposit of {$deposit->net_amount} {$deposit->currency_code} via {$methodLabel} completed! Ref: {$deposit->reference}");
        }
        catch (\Exception $e) {
            return back()->withErrors(['deposit' => $e->getMessage()]);
        }
    }
}