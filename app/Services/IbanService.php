<?php

namespace App\Services;

class IbanService
{
    // Syria Digital Bank country code and bank code
    private const COUNTRY_CODE = 'SY';
    private const BANK_CODE = 'SHMB';
    private const BRANCH_CODE = '0001';

    /**
     * Generate a valid IBAN for a new account
     */
    public function generate(): string
    {
        $accountNumber = $this->generateAccountNumber();
        $bban = self::BANK_CODE . self::BRANCH_CODE . $accountNumber;
        $checkDigits = $this->calculateCheckDigits(self::COUNTRY_CODE, $bban);

        return self::COUNTRY_CODE . $checkDigits . $bban;
    }

    /**
     * Generate internal account number (10 digits)
     */
    public function generateAccountNumber(): string
    {
        // Format: YYMMDD + 4 random digits
        $datePart = now()->format('ymd');
        $randomPart = str_pad(mt_rand(0, 9999), 4, '0', STR_PAD_LEFT);

        $number = $datePart . $randomPart;

        // Ensure uniqueness
        while (\App\Models\Account::where('account_number', $number)->exists()) {
            $randomPart = str_pad(mt_rand(0, 9999), 4, '0', STR_PAD_LEFT);
            $number = $datePart . $randomPart;
        }

        return $number;
    }

    /**
     * Validate IBAN format and checksum
     */
    public function validate(string $iban): bool
    {
        $iban = str_replace(' ', '', strtoupper($iban));

        if (strlen($iban) < 15 || strlen($iban) > 34) {
            return false;
        }

        // Move first 4 chars to end
        $rearranged = substr($iban, 4) . substr($iban, 0, 4);

        // Replace letters with numbers (A=10, B=11, ..., Z=35)
        $numericString = '';
        foreach (str_split($rearranged) as $char) {
            if (ctype_alpha($char)) {
                $numericString .= (ord($char) - 55);
            }
            else {
                $numericString .= $char;
            }
        }

        // Modulo 97
        return bcmod($numericString, '97') === '1';
    }

    /**
     * Format IBAN with spaces for display
     */
    public function format(string $iban): string
    {
        return implode(' ', str_split($iban, 4));
    }

    /**
     * Calculate IBAN check digits
     */
    private function calculateCheckDigits(string $countryCode, string $bban): string
    {
        $rearranged = $bban . $countryCode . '00';

        $numericString = '';
        foreach (str_split($rearranged) as $char) {
            if (ctype_alpha($char)) {
                $numericString .= (ord(strtoupper($char)) - 55);
            }
            else {
                $numericString .= $char;
            }
        }

        $remainder = bcmod($numericString, '97');
        $checkDigits = 98 - (int)$remainder;

        return str_pad($checkDigits, 2, '0', STR_PAD_LEFT);
    }
}