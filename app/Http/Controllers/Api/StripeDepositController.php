<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Account;
use App\Models\CardDeposit;
use App\Models\Transaction;
use App\Models\Setting;
use App\Services\AccountService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Stripe\StripeClient;

class StripeDepositController extends Controller
{
    private StripeClient $stripe;
    private AccountService $accountService;

    public function __construct(AccountService $accountService)
    {
        $this->stripe = new StripeClient(config('services.stripe.secret'));
        $this->accountService = $accountService;
    }

    /**
     * Create a Stripe PaymentIntent
     * POST /api/v1/mobile/stripe/create-intent
     */
    public function createIntent(Request $request)
    {
        $request->validate([
            'account_id' => 'required|exists:accounts,id',
            'amount' => 'required|numeric|min:1|max:50000',
        ]);

        $user = $request->user();
        $account = Account::where('id', $request->account_id)
            ->where('user_id', $user->id)->firstOrFail();

        $currencyCode = strtolower($account->currency->code ?? 'eur');
        $amountCents = (int) round($request->amount * 100);

        // Calculate fee
        $feePercentage = (float) Setting::getValue('deposit_fee_percentage', 1.5);
        $feeFixed = (float) Setting::getValue('deposit_fee_fixed', 0.50);
        $feeAmount = round(($request->amount * $feePercentage / 100) + $feeFixed, 2);

        try {
            $intent = $this->stripe->paymentIntents->create([
                'amount' => $amountCents,
                'currency' => $currencyCode,
                'metadata' => [
                    'user_id' => $user->id,
                    'account_id' => $account->id,
                    'sdb_fee' => $feeAmount,
                ],
                'description' => "SDB Bank Deposit — {$user->full_name}",
            ]);

            return response()->json([
                'client_secret' => $intent->client_secret,
                'payment_intent_id' => $intent->id,
                'amount' => $request->amount,
                'fee' => $feeAmount,
                'net' => round($request->amount - $feeAmount, 2),
                'currency' => strtoupper($currencyCode),
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'فشل إنشاء عملية الدفع: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Confirm deposit after successful Stripe payment
     * POST /api/v1/mobile/stripe/confirm
     */
    public function confirmDeposit(Request $request)
    {
        $request->validate([
            'payment_intent_id' => 'required|string',
            'account_id' => 'required|exists:accounts,id',
        ]);

        $user = $request->user();
        $account = Account::where('id', $request->account_id)
            ->where('user_id', $user->id)->firstOrFail();

        try {
            // Verify payment with Stripe
            $intent = $this->stripe->paymentIntents->retrieve($request->payment_intent_id);

            if ($intent->status !== 'succeeded') {
                return response()->json(['message' => 'الدفع لم يكتمل بعد', 'status' => $intent->status], 400);
            }

            // Prevent double-crediting
            $existing = CardDeposit::where('processor_reference', $intent->id)->first();
            if ($existing) {
                return response()->json(['message' => 'تم معالجة هذا الإيداع مسبقاً'], 409);
            }

            $grossAmount = $intent->amount / 100;
            $feeAmount = (float) ($intent->metadata->sdb_fee ?? 0);
            $netAmount = $grossAmount - $feeAmount;

            // Get card details from payment method
            $cardBrand = 'card';
            $lastFour = '****';
            if ($intent->payment_method) {
                try {
                    $pm = $this->stripe->paymentMethods->retrieve($intent->payment_method);
                    $cardBrand = $pm->card->brand ?? 'card';
                    $lastFour = $pm->card->last4 ?? '****';
                } catch (\Exception $e) {}
            }

            return DB::transaction(function () use ($account, $grossAmount, $netAmount, $feeAmount, $cardBrand, $lastFour, $intent) {
                $deposit = CardDeposit::create([
                    'reference' => CardDeposit::generateReference(),
                    'user_id' => $account->user_id,
                    'account_id' => $account->id,
                    'amount' => $grossAmount,
                    'currency_code' => strtoupper($intent->currency),
                    'fee_amount' => $feeAmount,
                    'net_amount' => $netAmount,
                    'card_brand' => $cardBrand,
                    'card_last_four' => $lastFour,
                    'card_holder_name' => 'Stripe Payment',
                    'card_expiry_masked' => '',
                    'status' => 'completed',
                    'processor_reference' => $intent->id,
                    'completed_at' => now(),
                ]);

                $this->accountService->credit($account, $netAmount);

                $transaction = Transaction::create([
                    'reference_number' => Transaction::generateReference(),
                    'to_account_id' => $account->id,
                    'currency_id' => $account->currency_id,
                    'amount' => $netAmount,
                    'fee' => $feeAmount,
                    'type' => 'deposit',
                    'status' => 'completed',
                    'description' => "Stripe deposit via {$cardBrand} •••• {$lastFour}",
                    'metadata' => [
                        'deposit_id' => $deposit->id,
                        'stripe_pi' => $intent->id,
                        'card_brand' => $cardBrand,
                        'card_last_four' => $lastFour,
                        'gross_amount' => $grossAmount,
                    ],
                    'completed_at' => now(),
                ]);

                $deposit->update(['transaction_id' => $transaction->id]);

                return response()->json([
                    'success' => true,
                    'message' => 'تم الإيداع بنجاح ✅',
                    'deposit' => $deposit->fresh(),
                    'new_balance' => $account->fresh()->balance,
                ]);
            });
        } catch (\Exception $e) {
            return response()->json(['message' => 'خطأ: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Get Stripe publishable key for client-side initialization
     * GET /api/v1/mobile/stripe/config
     */
    public function config()
    {
        return response()->json([
            'publishable_key' => config('services.stripe.key'),
        ]);
    }
}
