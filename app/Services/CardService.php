<?php

namespace App\Services;

use App\Models\Card;
use App\Models\Account;
use App\Models\User;
use Stripe\StripeClient;

class CardService
{
    private ?StripeClient $stripe;
    private bool $useStripe;

    public function __construct()
    {
        $key = config('services.stripe.secret');
        $this->useStripe = !empty($key) && $key !== 'sk_test_placeholder';
        $this->stripe = $this->useStripe ? new StripeClient($key) : null;
    }

    /**
     * Issue a new card — via Stripe Issuing if configured, otherwise local
     */
    public function issueCard(User $user, Account $account): Card
    {
        if ($this->useStripe) {
            return $this->issueViaStripe($user, $account);
        }
        return $this->issueLocal($user, $account);
    }

    /**
     * Issue card via Stripe Issuing API
     */
    private function issueViaStripe(User $user, Account $account): Card
    {
        // 1. Create or get Stripe cardholder
        $cardholderId = $user->stripe_cardholder_id;
        if (!$cardholderId) {
            $cardholder = $this->stripe->issuing->cardholders->create([
                'name' => $user->full_name,
                'email' => $user->email,
                'phone_number' => $user->phone,
                'status' => 'active',
                'type' => 'individual',
                'billing' => [
                    'address' => [
                        'line1' => $user->address ?? 'N/A',
                        'city' => $user->city ?? 'Copenhagen',
                        'state' => $user->state ?? '',
                        'country' => $user->country ?? 'DK',
                        'postal_code' => $user->postal_code ?? '1000',
                    ],
                ],
            ]);
            $cardholderId = $cardholder->id;
            $user->update(['stripe_cardholder_id' => $cardholderId]);
        }

        // 2. Create virtual card
        $stripeCard = $this->stripe->issuing->cards->create([
            'cardholder' => $cardholderId,
            'currency' => strtolower($account->currency->code ?? 'eur'),
            'type' => 'virtual',
            'status' => 'active',
            'spending_controls' => [
                'spending_limits' => [
                    ['amount' => 500000, 'interval' => 'per_authorization'], // 5000.00
                    ['amount' => 200000, 'interval' => 'daily'], // 2000.00
                    ['amount' => 1000000, 'interval' => 'monthly'], // 10000.00
                ],
            ],
        ]);

        // 3. Get full card details
        $details = $this->stripe->issuing->cards->retrieve($stripeCard->id, [
            'expand' => ['number', 'cvc'],
        ]);

        $cardNumber = $details->number;
        $cvv = $details->cvc;
        $expMonth = str_pad($stripeCard->exp_month, 2, '0', STR_PAD_LEFT);
        $expYear = $stripeCard->exp_year;
        $masked = substr($cardNumber, 0, 4) . ' **** **** ' . substr($cardNumber, -4);

        return Card::create([
            'user_id' => $user->id,
            'account_id' => $account->id,
            'card_number_masked' => $masked,
            'card_number_encrypted' => encrypt($cardNumber),
            'card_type' => 'virtual_' . $stripeCard->brand,
            'card_holder_name' => strtoupper($user->full_name),
            'status' => 'active',
            'spending_limit' => 5000,
            'daily_limit' => 2000,
            'monthly_limit' => 10000,
            'expiry_date' => "{$expYear}-{$expMonth}-28",
            'cvv_hash' => bcrypt($cvv),
            'online_payment_enabled' => true,
            'contactless_enabled' => true,
            'stripe_card_id' => $stripeCard->id,
        ]);
    }

    /**
     * Local card generation (fallback when Stripe not configured)
     */
    private function issueLocal(User $user, Account $account): Card
    {
        $cardNumber = '5' . str_pad(mt_rand(100, 999), 3, '0', STR_PAD_LEFT)
            . str_pad(mt_rand(0, 9999), 4, '0', STR_PAD_LEFT)
            . str_pad(mt_rand(0, 9999), 4, '0', STR_PAD_LEFT)
            . str_pad(mt_rand(0, 9999), 4, '0', STR_PAD_LEFT);

        $cardNumber = $this->applyLuhnCheckDigit($cardNumber);
        $masked = substr($cardNumber, 0, 4) . ' **** **** ' . substr($cardNumber, -4);
        $cvv = str_pad(mt_rand(100, 999), 3, '0', STR_PAD_LEFT);

        return Card::create([
            'user_id' => $user->id,
            'account_id' => $account->id,
            'card_number_masked' => $masked,
            'card_number_encrypted' => encrypt($cardNumber),
            'card_type' => 'virtual_mastercard',
            'card_holder_name' => strtoupper($user->full_name),
            'status' => 'active',
            'spending_limit' => 5000,
            'daily_limit' => 2000,
            'monthly_limit' => 10000,
            'expiry_date' => now()->addYears(3),
            'cvv_hash' => bcrypt($cvv),
            'online_payment_enabled' => true,
            'contactless_enabled' => true,
        ]);
    }

    public function freeze(Card $card): Card
    {
        if ($this->useStripe && $card->stripe_card_id) {
            $this->stripe->issuing->cards->update($card->stripe_card_id, ['status' => 'inactive']);
        }
        $card->update(['status' => 'frozen']);
        return $card;
    }

    public function unfreeze(Card $card): Card
    {
        if ($card->isExpired()) {
            throw new \Exception('Cannot unfreeze an expired card');
        }
        if ($this->useStripe && $card->stripe_card_id) {
            $this->stripe->issuing->cards->update($card->stripe_card_id, ['status' => 'active']);
        }
        $card->update(['status' => 'active']);
        return $card;
    }

    public function cancel(Card $card): Card
    {
        if ($this->useStripe && $card->stripe_card_id) {
            $this->stripe->issuing->cards->update($card->stripe_card_id, ['status' => 'canceled']);
        }
        $card->update(['status' => 'cancelled']);
        return $card;
    }

    public function updateLimits(Card $card, array $limits): Card
    {
        $card->update(array_intersect_key($limits, array_flip([
            'spending_limit', 'daily_limit', 'monthly_limit',
        ])));
        return $card->fresh();
    }

    private function applyLuhnCheckDigit(string $number): string
    {
        $base = substr($number, 0, -1);
        $sum = 0;
        $length = strlen($base);
        for ($i = 0; $i < $length; $i++) {
            $digit = (int)$base[$length - 1 - $i];
            if ($i % 2 === 0) {
                $digit *= 2;
                if ($digit > 9)
                    $digit -= 9;
            }
            $sum += $digit;
        }
        return $base . ((10 - ($sum % 10)) % 10);
    }
}