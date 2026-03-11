<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class FcmService
{
    /**
     * Send a push notification via Firebase Cloud Messaging (Legacy HTTP API)
     */
    public static function send(string $fcmToken, string $title, string $body, array $data = []): bool
    {
        $serverKey = config('services.firebase.server_key');

        if (!$serverKey || !$fcmToken) {
            Log::warning('FCM: Missing server key or token');
            return false;
        }

        try {
            $response = Http::withHeaders([
                'Authorization' => 'key=' . $serverKey,
                'Content-Type' => 'application/json',
            ])->post('https://fcm.googleapis.com/fcm/send', [
                'to' => $fcmToken,
                'notification' => [
                    'title' => $title,
                    'body' => $body,
                    'sound' => 'default',
                    'badge' => 1,
                ],
                'data' => array_merge($data, [
                    'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
                ]),
            ]);

            if ($response->successful()) {
                Log::info('FCM: Push sent to token ' . substr($fcmToken, 0, 20) . '...');
                return true;
            }

            Log::warning('FCM: Failed - ' . $response->body());
            return false;
        } catch (\Exception $e) {
            Log::error('FCM: Exception - ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Send push to a user by their ID
     */
    public static function sendToUser(int $userId, string $title, string $body, array $data = []): bool
    {
        $user = \App\Models\User::find($userId);
        if (!$user || !$user->fcm_token) {
            return false;
        }
        return self::send($user->fcm_token, $title, $body, $data);
    }
}
