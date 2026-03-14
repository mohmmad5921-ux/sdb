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
     * Send WhatsApp message via Twilio (Sandbox: uses From number)
     */
    public static function sendWhatsApp(string $to, string $message): bool
    {
        $accountSid = config('services.twilio.account_sid');
        $authToken = config('services.twilio.auth_token');
        $from = config('services.twilio.whatsapp_from', 'whatsapp:+14155238886');

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
                    'From' => $from,
                    'To' => "whatsapp:{$to}",
                    'Body' => $message,
                ]);

            if ($response->successful()) {
                Log::info("WhatsApp: Sent to {$to} successfully (SID: {$response->json('sid')})");
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

    // ═══════════════════════════════════════════
    // Remittance WhatsApp Notifications
    // ═══════════════════════════════════════════

    /**
     * Notify sender: remittance created
     */
    public static function remittanceCreated(string $phone, string $recipientName, string $amount, string $code, string $agentName): bool
    {
        $msg = "🏦 *SDB Bank — تأكيد حوالة*\n\n"
             . "✅ تم إرسال حوالتك بنجاح!\n\n"
             . "📋 *التفاصيل:*\n"
             . "• المستلم: {$recipientName}\n"
             . "• المبلغ: €{$amount}\n"
             . "• الوكيل: {$agentName}\n"
             . "• كود الاستلام: *{$code}*\n\n"
             . "📌 أعطِ المستلم كود الاستلام ليتمكن من سحب الحوالة.\n\n"
             . "SDB Bank 🏦";
        return self::sendWhatsApp($phone, $msg);
    }

    /**
     * Notify sender: remittance collected
     */
    public static function remittanceCollected(string $phone, string $recipientName, string $code): bool
    {
        $msg = "🏦 *SDB Bank — تم تسليم الحوالة*\n\n"
             . "✅ تم استلام الحوالة رقم *{$code}* بنجاح!\n\n"
             . "• المستلم: {$recipientName}\n\n"
             . "شكراً لاستخدامك SDB Bank 🏦";
        return self::sendWhatsApp($phone, $msg);
    }

    /**
     * Notify sender: remittance cancelled
     */
    public static function remittanceCancelled(string $phone, string $code): bool
    {
        $msg = "🏦 *SDB Bank — إلغاء حوالة*\n\n"
             . "❌ تم إلغاء الحوالة رقم *{$code}*.\n\n"
             . "للاستفسار تواصل مع الدعم.\n\n"
             . "SDB Bank 🏦";
        return self::sendWhatsApp($phone, $msg);
    }
}

