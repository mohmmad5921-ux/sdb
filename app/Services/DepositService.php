<?php

namespace App\Services;

use App\Models\Account;
use App\Models\CardDeposit;
use App\Models\Transaction;
use App\Models\Setting;
use Illuminate\Support\Facades\DB;

class DepositService
{
    public function __construct(
        private AccountService $accountService,
        )
    {
    }

    /**
     * Process a deposit via external bank card (Visa/Mastercard).
     *
     * In production, this would integrate with a real payment processor
     * (Stripe, PayPal, etc.) to charge the external card.
     * Currently simulates successful processing.
     */
    public function depositViaCard(
        Account $account,
        float $amount,
        string $cardNumber,
        string $cardHolder,
        string $cardExpiry,
        string $cardCvv,
        ?string $ipAddress = null,
        ): CardDeposit
    {
        // Validate
        if ($amount < 1) {
            throw new \Exception('Minimum deposit is 1.00');
        }
        if ($amount > 50000) {
            throw new \Exception('Maximum single deposit is 50,000');
        }
        if (!$account->isActive()) {
            throw new \Exception('Account is not active');
        }

        // Calculate fee (configurable via settings)
        $feePercentage = (float)Setting::getValue('deposit_fee_percentage', 1.5);
        $feeFixed = (float)Setting::getValue('deposit_fee_fixed', 0.50);
        $feeAmount = round(($amount * $feePercentage / 100) + $feeFixed, 2);
        $netAmount = $amount - $feeAmount;

        // Detect card brand
        $cleanCardNumber = preg_replace('/\D/', '', $cardNumber);
        $cardBrand = $this->detectCardBrand($cleanCardNumber);

        // Mask card number — only store last 4
        $lastFour = substr($cleanCardNumber, -4);

        return DB::transaction(function () use ($account, $amount, $netAmount, $feeAmount, $cardBrand, $lastFour, $cardHolder, $cardExpiry, $ipAddress) {
            // Create deposit record
            $deposit = CardDeposit::create([
                'reference' => CardDeposit::generateReference(),
                'user_id' => $account->user_id,
                'account_id' => $account->id,
                'amount' => $amount,
                'currency_code' => $account->currency->code ?? 'EUR',
                'fee_amount' => $feeAmount,
                'net_amount' => $netAmount,
                'card_brand' => $cardBrand,
                'card_last_four' => $lastFour,
                'card_holder_name' => $cardHolder,
                'card_expiry_masked' => $cardExpiry,
                'status' => 'processing',
                'ip_address' => $ipAddress,
            ]);

            /**
             * PRODUCTION: Here you would call the real payment processor:
             *
             * $charge = Stripe::charges()->create([
             *     'amount' => $amount * 100,
             *     'currency' => strtolower($account->currency->code),
             *     'source' => $stripeToken,
             *     'description' => 'Syria Digital Bank Deposit ' . $deposit->reference,
             * ]);
             *
             * For now, we simulate successful processing.
             */
            $processorRef = 'SIM_' . strtoupper(bin2hex(random_bytes(8)));

            // Simulate: ~2% chance of failure for realism
            if (mt_rand(1, 100) <= 2) {
                $deposit->update([
                    'status' => 'failed',
                    'failure_reason' => 'Card declined by issuing bank',
                    'processor_reference' => $processorRef,
                ]);
                throw new \Exception('Card declined. Please try a different card.');
            }

            // Credit the account
            $this->accountService->credit($account, $netAmount);

            // Create transaction record
            $transaction = Transaction::create([
                'reference_number' => Transaction::generateReference(),
                'to_account_id' => $account->id,
                'currency_id' => $account->currency_id,
                'amount' => $netAmount,
                'fee' => $feeAmount,
                'type' => 'deposit',
                'status' => 'completed',
                'description' => "Card deposit via {$cardBrand} •••• {$lastFour}",
                'metadata' => [
                    'deposit_id' => $deposit->id,
                    'card_brand' => $cardBrand,
                    'card_last_four' => $lastFour,
                    'gross_amount' => $amount,
                ],
                'completed_at' => now(),
            ]);

            // Update deposit
            $deposit->update([
                'status' => 'completed',
                'transaction_id' => $transaction->id,
                'processor_reference' => $processorRef,
                'completed_at' => now(),
            ]);

            return $deposit->fresh();
        });
    }

    /**
     * Detect card brand from number
     */
    private function detectCardBrand(string $cardNumber): string
    {
        if (preg_match('/^4/', $cardNumber))
            return 'visa';
        if (preg_match('/^5[1-5]/', $cardNumber))
            return 'mastercard';
        if (preg_match('/^3[47]/', $cardNumber))
            return 'amex';
        if (preg_match('/^6(?:011|5)/', $cardNumber))
            return 'discover';
        return 'unknown';
    }
}