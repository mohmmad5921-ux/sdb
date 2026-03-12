<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Cache;

class FcmService
{
    /**
     * Send push notification via FCM HTTP v1 API
     */
    public static function send(string $fcmToken, string $title, string $body, array $data = []): bool
    {
        $accessToken = self::getAccessToken();
        if (!$accessToken || !$fcmToken) {
            Log::warning('FCM: Missing access token or FCM token');
            return false;
        }

        $projectId = self::getProjectId();

        try {
            $payload = [
                'message' => [
                    'token' => $fcmToken,
                    'notification' => [
                        'title' => $title,
                        'body' => $body,
                    ],
                    'android' => [
                        'priority' => 'high',
                        'notification' => ['sound' => 'default'],
                    ],
                    'apns' => [
                        'payload' => [
                            'aps' => [
                                'sound' => 'default',
                                'badge' => 1,
                            ],
                        ],
                    ],
                ],
            ];

            // Only include data field if non-empty (empty array breaks FCM)
            if (!empty($data)) {
                $payload['message']['data'] = array_map('strval', $data);
            }

            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $accessToken,
                'Content-Type' => 'application/json',
            ])->post("https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send", $payload);

            if ($response->successful()) {
                Log::info('FCM: Push sent successfully');
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
     * Send push to a user by ID
     */
    public static function sendToUser(int $userId, string $title, string $body, array $data = []): bool
    {
        $user = \App\Models\User::find($userId);
        if (!$user || !$user->fcm_token) {
            return false;
        }
        return self::send($user->fcm_token, $title, $body, $data);
    }

    /**
     * Get OAuth2 access token from service account (cached 50min)
     */
    private static function getAccessToken(): ?string
    {
        return Cache::remember('fcm_access_token', 3000, function () {
            $saPath = storage_path('app/firebase-adminsdk.json');
            if (!file_exists($saPath)) {
                Log::error('FCM: Service account JSON not found at ' . $saPath);
                return null;
            }

            $sa = json_decode(file_get_contents($saPath), true);
            $now = time();

            // Build JWT (requires URL-safe base64)
            $b64url = fn($data) => rtrim(strtr(base64_encode($data), '+/', '-_'), '=');

            $header = $b64url(json_encode(['typ' => 'JWT', 'alg' => 'RS256']));
            $payload = $b64url(json_encode([
                'iss' => $sa['client_email'],
                'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
                'aud' => 'https://oauth2.googleapis.com/token',
                'iat' => $now,
                'exp' => $now + 3600,
            ]));

            $signInput = $header . '.' . $payload;
            openssl_sign($signInput, $signature, $sa['private_key'], OPENSSL_ALGO_SHA256);
            $jwt = $signInput . '.' . $b64url($signature);

            // Exchange JWT for access token
            $response = Http::asForm()->post('https://oauth2.googleapis.com/token', [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $jwt,
            ]);

            if ($response->successful()) {
                Log::info('FCM: OAuth2 token obtained successfully');
                return $response->json('access_token');
            }

            Log::error('FCM: Token exchange failed - ' . $response->body());
            return null;
        });
    }

    /**
     * Get project ID from service account JSON
     */
    private static function getProjectId(): string
    {
        $saPath = storage_path('app/firebase-adminsdk.json');
        if (file_exists($saPath)) {
            $sa = json_decode(file_get_contents($saPath), true);
            return $sa['project_id'] ?? 'sdb-banking-471e1';
        }
        return 'sdb-banking-471e1';
    }
}
