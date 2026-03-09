<?php

namespace App\Services;

use App\Models\Account;

class AccountNumberService
{
    /**
     * Generate a unique 10-digit account number
     * Format: SDB + 7 random digits = 10 digits total (all numeric)
     */
    public static function generateAccountNumber(): string
    {
        do {
            // Prefix with 30 (SDB code) + 8 random digits = 10 digits
            $number = '30' . str_pad(random_int(0, 99999999), 8, '0', STR_PAD_LEFT);
        } while (Account::where('account_number', $number)->exists());

        return $number;
    }

    /**
     * Generate a unique 4-digit business code (1000-9999)
     */
    public static function generateBusinessCode(): string
    {
        do {
            $code = (string) random_int(1000, 9999);
        } while (Account::where('business_code', $code)->exists());

        return $code;
    }

    /**
     * Generate IBAN for Syria (hypothetical — SDB format)
     * Format: SY + 2 check digits + SDB(3) + account_number(10)
     */
    public static function generateIban(string $accountNumber): string
    {
        $countryCode = 'SY';
        $bankCode = 'SDB';
        $checkDigits = str_pad(random_int(10, 99), 2, '0', STR_PAD_LEFT);
        return $countryCode . $checkDigits . $bankCode . $accountNumber;
    }

    /**
     * Generate QR code data payload for an account
     */
    public static function generateQrData(Account $account): string
    {
        return json_encode([
            'bank' => 'SDB',
            'acc' => $account->account_number,
            'name' => $account->user->full_name ?? '',
            'cur' => $account->currency->code ?? 'EUR',
            'type' => $account->account_type,
            'biz' => $account->business_code,
        ]);
    }
}
