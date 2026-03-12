<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class SmsService
{
    /**
     * Send SMS via Twilio Messaging Service (messages appear from "SDB Bank")
     */
    public static function send(string $to, string $message): bool
    {
        $accountSid = config('services.twilio.account_sid');
        $authToken = config('services.twilio.auth_token');
        $messagingServiceSid = config('services.twilio.messaging_service_sid');

        if (!$accountSid || !$authToken || !$messagingServiceSid) {
            Log::error('SMS: Twilio credentials not configured');
            return false;
        }

        try {
            // Clean phone number
            $to = preg_replace('/\s+/', '', $to);
            if (!str_starts_with($to, '+')) {
                $to = '+' . $to;
            }

            $response = Http::withBasicAuth($accountSid, $authToken)
                ->asForm()
                ->post("https://api.twilio.com/2010-04-01/Accounts/{$accountSid}/Messages.json", [
                    'MessagingServiceSid' => $messagingServiceSid,
                    'To' => $to,
                    'Body' => $message,
                ]);

            if ($response->successful()) {
                Log::info("SMS: Sent to {$to} successfully (SID: {$response->json('sid')})");
                return true;
            }

            Log::warning("SMS: Failed to send to {$to} - " . $response->body());
            return false;
        } catch (\Exception $e) {
            Log::error("SMS: Exception - " . $e->getMessage());
            return false;
        }
    }

    /**
     * Send WhatsApp message via Twilio
     */
    public static function sendWhatsApp(string $to, string $message): bool
    {
        $accountSid = config('services.twilio.account_sid');
        $authToken = config('services.twilio.auth_token');
        $messagingServiceSid = config('services.twilio.messaging_service_sid');

        if (!$accountSid || !$authToken) {
            Log::error('WhatsApp: Twilio credentials not configured');
            return false;
        }

        try {
            $to = preg_replace('/\s+/', '', $to);
            if (!str_starts_with($to, '+')) {
                $to = '+' . $to;
            }

            $response = Http::withBasicAuth($accountSid, $authToken)
                ->asForm()
                ->post("https://api.twilio.com/2010-04-01/Accounts/{$accountSid}/Messages.json", [
                    'MessagingServiceSid' => $messagingServiceSid,
                    'To' => "whatsapp:{$to}",
                    'Body' => $message,
                ]);

            if ($response->successful()) {
                Log::info("WhatsApp: Sent to {$to} successfully");
                return true;
            }

            Log::warning("WhatsApp: Failed to send to {$to} - " . $response->body());
            return false;
        } catch (\Exception $e) {
            Log::error("WhatsApp: Exception - " . $e->getMessage());
            return false;
        }
    }

    /**
     * Send OTP verification code
     */
    public static function sendOtp(string $to, string $code): bool
    {
        $message = "SDB Bank: Your verification code is {$code}. Valid for 5 minutes. Do not share this code.";
        return self::send($to, $message);
    }

    /**
     * Send welcome SMS to new user
     */
    public static function sendWelcome(string $to, string $name): bool
    {
        $message = "Welcome to SDB Bank, {$name}! 🏦\nYour digital banking account is ready. Download our app to get started.\n\nSDB Bank Team";
        return self::send($to, $message);
    }

    /**
     * Send transaction notification
     */
    public static function sendTransactionAlert(string $to, string $type, string $amount, string $currency): bool
    {
        $message = "SDB Bank: {$type} of {$amount} {$currency} has been processed on your account.";
        return self::send($to, $message);
    }
}
