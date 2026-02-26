<?php

namespace App\Services;

use App\Models\Card;
use App\Models\Account;
use App\Models\User;

class CardService
{
    /**
     * Issue a new virtual Mastercard
     */
    public function issueCard(User $user, Account $account): Card
    {
        // Generate card number (test format: 5xxx xxxx xxxx xxxx)
        $cardNumber = '5' . str_pad(mt_rand(100, 999), 3, '0', STR_PAD_LEFT)
            . str_pad(mt_rand(0, 9999), 4, '0', STR_PAD_LEFT)
            . str_pad(mt_rand(0, 9999), 4, '0', STR_PAD_LEFT)
            . str_pad(mt_rand(0, 9999), 4, '0', STR_PAD_LEFT);

        // Luhn check digit fix
        $cardNumber = $this->applyLuhnCheckDigit($cardNumber);

        $masked = substr($cardNumber, 0, 4) . ' **** **** ' . substr($cardNumber, -4);

        // Generate CVV
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

    /**
     * Freeze a card
     */
    public function freeze(Card $card): Card
    {
        $card->update(['status' => 'frozen']);
        return $card;
    }

    /**
     * Unfreeze a card
     */
    public function unfreeze(Card $card): Card
    {
        if ($card->isExpired()) {
            throw new \Exception('Cannot unfreeze an expired card');
        }
        $card->update(['status' => 'active']);
        return $card;
    }

    /**
     * Cancel a card
     */
    public function cancel(Card $card): Card
    {
        $card->update(['status' => 'cancelled']);
        return $card;
    }

    /**
     * Update spending limits
     */
    public function updateLimits(Card $card, array $limits): Card
    {
        $card->update(array_intersect_key($limits, array_flip([
            'spending_limit', 'daily_limit', 'monthly_limit',
        ])));
        return $card->fresh();
    }

    /**
     * Apply Luhn check digit algorithm
     */
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

        $checkDigit = (10 - ($sum % 10)) % 10;
        return $base . $checkDigit;
    }
}