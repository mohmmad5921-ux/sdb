<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class PushNotificationService
{
    /**
     * Send push notification to a user via FCM v1 API
     */
    public static function sendToUser(User $user, string $title, string $body, array $data = []): bool
    {
        $fcmToken = $user->fcm_token;
        if (!$fcmToken) {
            Log::info("PushNotification: No FCM token for user #{$user->id}");
            return false;
        }

        return self::sendToToken($fcmToken, $title, $body, $data);
    }

    /**
     * Send push notification to a specific FCM token
     */
    public static function sendToToken(string $fcmToken, string $title, string $body, array $data = []): bool
    {
        try {
            $accessToken = self::getAccessToken();
            if (!$accessToken) {
                Log::error('PushNotification: Failed to get access token');
                return false;
            }

            $projectId = self::getProjectId();
            $url = "https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send";

            $message = [
                'message' => [
                    'token' => $fcmToken,
                    'notification' => [
                        'title' => $title,
                        'body' => $body,
                    ],
                    'apns' => [
                        'payload' => [
                            'aps' => [
                                'sound' => 'default',
                                'badge' => 1,
                                'mutable-content' => 1,
                            ],
                        ],
                    ],
                    'android' => [
                        'priority' => 'high',
                        'notification' => [
                            'sound' => 'default',
                            'channel_id' => 'sdb_notifications',
                        ],
                    ],
                ],
            ];

            // Only add data if non-empty (FCM data must be a map/object, not array)
            if (!empty($data)) {
                $message['message']['data'] = (object) array_map('strval', $data);
            }

            $response = Http::withToken($accessToken)
                ->timeout(10)
                ->post($url, $message);

            if ($response->successful()) {
                Log::info("PushNotification: Sent to token " . substr($fcmToken, 0, 20) . "...");
                return true;
            }

            Log::error("PushNotification: FCM error {$response->status()}: {$response->body()}");
            return false;
        } catch (\Exception $e) {
            Log::error("PushNotification: Exception: {$e->getMessage()}");
            return false;
        }
    }

    /**
     * Get OAuth2 access token from service account
     */
    private static function getAccessToken(): ?string
    {
        $credPath = storage_path('app/firebase-adminsdk.json');
        if (!file_exists($credPath)) {
            // Try realpath for Simply.com hosting
            $altPath = '/var/www/sdb-bank.com/sdb/storage/app/firebase-adminsdk.json';
            if (file_exists($altPath)) {
                $credPath = $altPath;
            } else {
                Log::error("PushNotification: Service account file not found");
                return null;
            }
        }

        $creds = json_decode(file_get_contents($credPath), true);
        
        // Build JWT with URL-safe base64
        $now = time();
        $header = self::base64url(json_encode(['alg' => 'RS256', 'typ' => 'JWT']));
        $payload = self::base64url(json_encode([
            'iss' => $creds['client_email'],
            'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
            'aud' => 'https://oauth2.googleapis.com/token',
            'iat' => $now,
            'exp' => $now + 3600,
        ]));

        $signature = '';
        openssl_sign(
            "{$header}.{$payload}",
            $signature,
            $creds['private_key'],
            OPENSSL_ALGO_SHA256
        );

        $jwt = "{$header}.{$payload}." . self::base64url($signature);

        // Exchange JWT for access token
        $response = Http::asForm()->post('https://oauth2.googleapis.com/token', [
            'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            'assertion' => $jwt,
        ]);

        if ($response->successful()) {
            return $response->json('access_token');
        }

        Log::error("PushNotification: Token exchange failed: {$response->body()}");
        return null;
    }

    /**
     * URL-safe base64 encode (required for JWT)
     */
    private static function base64url(string $data): string
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    /**
     * Get Firebase project ID from service account
     */
    private static function getProjectId(): string
    {
        $credPath = storage_path('app/firebase-adminsdk.json');
        $creds = json_decode(file_get_contents($credPath), true);
        return $creds['project_id'] ?? '';
    }
}
