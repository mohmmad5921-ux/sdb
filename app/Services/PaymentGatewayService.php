<?php

namespace App\Services;

use App\Models\Account;
use App\Models\Merchant;
use App\Models\MerchantApiKey;
use App\Models\PaymentSession;
use App\Models\Transaction;
use App\Models\WebhookDelivery;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

class PaymentGatewayService
{
    public function __construct(
        private AccountService $accountService,
    ) {}

    /**
     * Create a new payment session (called via API by merchant)
     */
    public function createSession(Merchant $merchant, array $data): PaymentSession
    {
        if (!$merchant->isActive()) {
            throw new \Exception('Merchant is not active');
        }

        $feeAmount = $merchant->calculateFee($data['amount']);

        return PaymentSession::create([
            'session_id' => PaymentSession::generateSessionId(),
            'merchant_id' => $merchant->id,
            'amount' => $data['amount'],
            'currency_code' => $data['currency'] ?? $merchant->settlement_currency,
            'description' => $data['description'] ?? null,
            'order_id' => $data['order_id'] ?? null,
            'customer_email' => $data['customer_email'] ?? null,
            'customer_name' => $data['customer_name'] ?? null,
            'success_url' => $data['success_url'] ?? null,
            'cancel_url' => $data['cancel_url'] ?? null,
            'webhook_url' => $data['webhook_url'] ?? $merchant->webhook_urls['payment'] ?? null,
            'metadata' => $data['metadata'] ?? null,
            'fee_amount' => $feeAmount,
            'expires_at' => now()->addMinutes(30),
        ]);
    }

    /**
     * Process payment (customer pays a session)
     */
    public function processPayment(PaymentSession $session, Account $fromAccount): PaymentSession
    {
        return DB::transaction(function () use ($session, $fromAccount) {
            if (!$session->isPending()) {
                throw new \Exception('Payment session is not pending');
            }
            if ($session->isExpired()) {
                $session->update(['status' => 'expired']);
                throw new \Exception('Payment session has expired');
            }
            if (!$fromAccount->isActive()) {
                throw new \Exception('Account is not active');
            }
            if ($fromAccount->available_balance < $session->amount) {
                throw new \Exception('Insufficient balance');
            }

            $merchant = $session->merchant;

            // Debit customer
            $this->accountService->debit($fromAccount, (float) $session->amount);

            // Credit merchant settlement account (minus fees)
            $netAmount = $session->amount - $session->fee_amount;
            if ($merchant->settlement_account_id) {
                $settlementAccount = Account::find($merchant->settlement_account_id);
                if ($settlementAccount) {
                    $this->accountService->credit($settlementAccount, (float) $netAmount);
                }
            }

            // Create transaction record
            $transaction = Transaction::create([
                'reference_number' => Transaction::generateReference(),
                'from_account_id' => $fromAccount->id,
                'to_account_id' => $merchant->settlement_account_id,
                'currency_id' => $fromAccount->currency_id,
                'amount' => $session->amount,
                'fee' => $session->fee_amount,
                'type' => 'card_payment',
                'status' => 'completed',
                'description' => 'Payment to ' . $merchant->business_name . ' - ' . ($session->description ?? $session->order_id),
                'metadata' => [
                    'payment_session_id' => $session->id,
                    'merchant_id' => $merchant->id,
                    'order_id' => $session->order_id,
                ],
                'completed_at' => now(),
            ]);

            // Update session
            $session->update([
                'status' => 'paid',
                'paid_by_user_id' => $fromAccount->user_id,
                'paid_from_account_id' => $fromAccount->id,
                'transaction_id' => $transaction->id,
                'payment_method' => 'account_balance',
                'paid_at' => now(),
            ]);

            // Update merchant stats
            $merchant->increment('total_volume', $session->amount);
            $merchant->increment('total_transactions');

            // Send webhook
            $this->deliverWebhook($session->fresh(), 'payment.completed');

            return $session->fresh();
        });
    }

    /**
     * Refund a payment
     */
    public function refundPayment(PaymentSession $session): PaymentSession
    {
        return DB::transaction(function () use ($session) {
            if (!$session->isPaid()) {
                throw new \Exception('Can only refund paid sessions');
            }

            $merchant = $session->merchant;

            // Debit merchant settlement
            if ($merchant->settlement_account_id) {
                $settlementAccount = Account::find($merchant->settlement_account_id);
                $netAmount = $session->amount - $session->fee_amount;
                if ($settlementAccount && $settlementAccount->available_balance >= $netAmount) {
                    $this->accountService->debit($settlementAccount, (float) $netAmount);
                }
            }

            // Credit customer back
            if ($session->paid_from_account_id) {
                $customerAccount = Account::find($session->paid_from_account_id);
                if ($customerAccount) {
                    $this->accountService->credit($customerAccount, (float) $session->amount);
                }
            }

            // Create refund transaction
            Transaction::create([
                'reference_number' => Transaction::generateReference(),
                'from_account_id' => $merchant->settlement_account_id,
                'to_account_id' => $session->paid_from_account_id,
                'currency_id' => $session->transaction->currency_id ?? 1,
                'amount' => $session->amount,
                'type' => 'refund',
                'status' => 'completed',
                'description' => 'Refund: ' . $session->session_id,
                'completed_at' => now(),
            ]);

            $session->update(['status' => 'refunded']);
            $merchant->decrement('total_volume', $session->amount);

            $this->deliverWebhook($session->fresh(), 'payment.refunded');

            return $session->fresh();
        });
    }

    /**
     * Deliver webhook to merchant
     */
    public function deliverWebhook(PaymentSession $session, string $event): void
    {
        $url = $session->webhook_url;
        if (!$url) return;

        $payload = [
            'event' => $event,
            'session_id' => $session->session_id,
            'order_id' => $session->order_id,
            'amount' => $session->amount,
            'currency' => $session->currency_code,
            'status' => $session->status,
            'customer_email' => $session->customer_email,
            'paid_at' => $session->paid_at?->toISOString(),
            'metadata' => $session->metadata,
        ];

        try {
            $response = Http::timeout(10)->post($url, $payload);
            WebhookDelivery::create([
                'payment_session_id' => $session->id,
                'url' => $url,
                'event' => $event,
                'payload' => $payload,
                'http_status' => $response->status(),
                'response_body' => substr($response->body(), 0, 1000),
                'is_successful' => $response->successful(),
            ]);
        } catch (\Exception $e) {
            WebhookDelivery::create([
                'payment_session_id' => $session->id,
                'url' => $url,
                'event' => $event,
                'payload' => $payload,
                'http_status' => 0,
                'response_body' => $e->getMessage(),
                'is_successful' => false,
            ]);
        }
    }

    /**
     * Authenticate merchant via API key
     */
    public function authenticateMerchant(string $secretKey): ?Merchant
    {
        $prefix = substr($secretKey, 0, 12);
        $apiKey = MerchantApiKey::where('secret_key_prefix', $prefix)
            ->where('is_active', true)
            ->first();

        if (!$apiKey || !$apiKey->verifySecretKey($secretKey)) {
            return null;
        }

        $apiKey->update(['last_used_at' => now()]);
        return $apiKey->merchant;
    }
}