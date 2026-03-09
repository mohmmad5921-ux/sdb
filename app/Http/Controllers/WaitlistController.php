<?php

namespace App\Http\Controllers;

use App\Models\WaitlistEmail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use App\Mail\WaitlistConfirmation;

class WaitlistController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'email' => 'required|email|max:255',
        ]);

        $existing = WaitlistEmail::where('email', $request->email)->first();

        if ($existing) {
            return response()->json(['message' => 'already_registered', 'success' => true]);
        }

        $entry = WaitlistEmail::create([
            'email' => $request->email,
            'source' => $request->input('source', 'hero'),
            'ip_address' => $request->ip(),
        ]);

        // Send confirmation email
        try {
            Mail::to($entry->email)->send(new WaitlistConfirmation($entry));
        } catch (\Exception $e) {
            \Log::warning('Waitlist email failed: ' . $e->getMessage());
        }

        // Telegram notification
        try {
            $token = env('TELEGRAM_BOT_TOKEN');
            $chatId = env('TELEGRAM_CHAT_ID');
            if ($token && $chatId) {
                $msg = "🆕 New Waitlist Signup!\n📧 {$entry->email}\n📍 Source: {$entry->source}\n🌐 IP: {$entry->ip_address}\n⏰ " . now()->format('Y-m-d H:i');
                file_get_contents("https://api.telegram.org/bot{$token}/sendMessage?" . http_build_query(['chat_id' => $chatId, 'text' => $msg, 'parse_mode' => 'HTML']));
            }
        } catch (\Exception $e) {
            \Log::warning('Telegram notify failed: ' . $e->getMessage());
        }

        return response()->json(['message' => 'registered', 'success' => true]);
    }
}
