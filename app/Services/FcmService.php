<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Cache;

class FcmService
{
    /**
     * Send push notification to a user by ID
     * Automatically uses APNs for iOS and FCM for Android
     */
    public static function sendToUser(int $userId, string $title, string $body, array $data = []): bool
    {
        $user = \App\Models\User::find($userId);
        if (!$user || !$user->fcm_token) {
            return false;
        }

        // If iOS user with APNS token, send directly via APNs
        if ($user->device_platform === 'ios' && $user->apns_token) {
            Log::info("FCM: iOS user #{$userId} — sending via APNs directly");
            $apnsResult = self::sendViaApns($user->apns_token, $title, $body, $data);

            // Fallback to FCM if APNs fails
            if (!$apnsResult) {
                Log::warning("FCM: APNs failed for user #{$userId}, falling back to FCM");
                return self::sendViaFcm($user->fcm_token, $title, $body, $data);
            }
            return true;
        }

        // Android or iOS without APNS token — use FCM
        return self::sendViaFcm($user->fcm_token, $title, $body, $data);
    }

    /**
     * Send push notification via FCM HTTP v1 API (works for Android, iOS if APNs key configured in Firebase)
     */
    public static function send(string $fcmToken, string $title, string $body, array $data = []): bool
    {
        return self::sendViaFcm($fcmToken, $title, $body, $data);
    }

    /**
     * Send via FCM HTTP v1 API
     */
    private static function sendViaFcm(string $fcmToken, string $title, string $body, array $data = []): bool
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
                Log::info('FCM: Push sent successfully via FCM');
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
     * Send push notification directly via APNs HTTP/2 API using .p8 auth key
     * This bypasses Firebase entirely for iOS
     */
    private static function sendViaApns(string $apnsToken, string $title, string $body, array $data = []): bool
    {
        try {
            $keyPath = storage_path('app/apns-auth-key.p8');
            if (!file_exists($keyPath)) {
                Log::error('APNs: Auth key .p8 not found at ' . $keyPath);
                return false;
            }

            $keyContent = file_get_contents($keyPath);
            $keyId = '3AUCW97XGM'; // APNs Auth Key ID
            $teamId = '7YL3972NBW'; // Apple Developer Team ID
            $bundleId = 'com.sdb.sdbApp';

            // Generate APNs JWT token
            $jwt = self::generateApnsJwt($keyContent, $keyId, $teamId);
            if (!$jwt) {
                return false;
            }

            // Build APNs payload
            $payload = [
                'aps' => [
                    'alert' => [
                        'title' => $title,
                        'body' => $body,
                    ],
                    'sound' => 'default',
                    'badge' => 1,
                ],
            ];

            if (!empty($data)) {
                $payload = array_merge($payload, $data);
            }

            // Use production APNs server (api.push.apple.com for production, api.sandbox.push.apple.com for dev)
            // Try production first, then sandbox
            $apnsUrl = "https://api.push.apple.com/3/device/{$apnsToken}";

            $ch = curl_init($apnsUrl);
            curl_setopt_array($ch, [
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_2_0,
                CURLOPT_POST => true,
                CURLOPT_POSTFIELDS => json_encode($payload),
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_TIMEOUT => 30,
                CURLOPT_HTTPHEADER => [
                    'Authorization: bearer ' . $jwt,
                    'apns-topic: ' . $bundleId,
                    'apns-push-type: alert',
                    'apns-priority: 10',
                    'apns-expiration: 0',
                    'Content-Type: application/json',
                ],
            ]);

            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $error = curl_error($ch);
            curl_close($ch);

            if ($error) {
                Log::error("APNs: cURL error - {$error}");

                // Try sandbox if production fails
                return self::sendViaApnsSandbox($apnsToken, $jwt, $bundleId, $payload);
            }

            if ($httpCode === 200) {
                Log::info('APNs: Push sent successfully (production)');
                return true;
            }

            Log::warning("APNs: Production failed (HTTP {$httpCode}): {$response}");

            // Try sandbox as fallback (for development builds)
            return self::sendViaApnsSandbox($apnsToken, $jwt, $bundleId, $payload);

        } catch (\Exception $e) {
            Log::error('APNs: Exception - ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Send via APNs Sandbox (for development/debug builds)
     */
    private static function sendViaApnsSandbox(string $apnsToken, string $jwt, string $bundleId, array $payload): bool
    {
        $apnsUrl = "https://api.sandbox.push.apple.com/3/device/{$apnsToken}";

        $ch = curl_init($apnsUrl);
        curl_setopt_array($ch, [
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_2_0,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => json_encode($payload),
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTPHEADER => [
                'Authorization: bearer ' . $jwt,
                'apns-topic: ' . $bundleId,
                'apns-push-type: alert',
                'apns-priority: 10',
                'apns-expiration: 0',
                'Content-Type: application/json',
            ],
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);

        if ($error) {
            Log::error("APNs Sandbox: cURL error - {$error}");
            return false;
        }

        if ($httpCode === 200) {
            Log::info('APNs: Push sent successfully (sandbox)');
            return true;
        }

        Log::warning("APNs Sandbox: Failed (HTTP {$httpCode}): {$response}");
        return false;
    }

    /**
     * Generate APNs JWT token using ES256 algorithm
     */
    private static function generateApnsJwt(string $keyContent, string $keyId, string $teamId): ?string
    {
        return Cache::remember('apns_jwt_token', 2400, function () use ($keyContent, $keyId, $teamId) {
            try {
                $b64url = fn($data) => rtrim(strtr(base64_encode($data), '+/', '-_'), '=');

                $header = $b64url(json_encode([
                    'alg' => 'ES256',
                    'kid' => $keyId,
                ]));

                $claims = $b64url(json_encode([
                    'iss' => $teamId,
                    'iat' => time(),
                ]));

                $signInput = $header . '.' . $claims;

                $privateKey = openssl_pkey_get_private($keyContent);
                if (!$privateKey) {
                    Log::error('APNs: Failed to load private key');
                    return null;
                }

                $success = openssl_sign($signInput, $signature, $privateKey, OPENSSL_ALGO_SHA256);
                if (!$success) {
                    Log::error('APNs: Failed to sign JWT');
                    return null;
                }

                // Convert DER signature to raw R+S format for ES256
                // OpenSSL produces DER-encoded signature, APNs needs raw 64-byte R||S
                $rawSig = self::derToRaw($signature);
                if (!$rawSig) {
                    Log::error('APNs: Failed to convert DER signature');
                    return null;
                }

                return $signInput . '.' . $b64url($rawSig);
            } catch (\Exception $e) {
                Log::error('APNs: JWT generation error - ' . $e->getMessage());
                return null;
            }
        });
    }

    /**
     * Convert DER-encoded ECDSA signature to raw R||S format (64 bytes)
     */
    private static function derToRaw(string $der): ?string
    {
        $hex = bin2hex($der);

        if (substr($hex, 0, 2) !== '30') {
            return null;
        }

        $pos = 4; // Skip SEQUENCE tag and length

        // Read R
        if (substr($hex, $pos, 2) !== '02') return null;
        $pos += 2;
        $rLen = hexdec(substr($hex, $pos, 2)) * 2;
        $pos += 2;
        $r = substr($hex, $pos, $rLen);
        $pos += $rLen;

        // Read S
        if (substr($hex, $pos, 2) !== '02') return null;
        $pos += 2;
        $sLen = hexdec(substr($hex, $pos, 2)) * 2;
        $pos += 2;
        $s = substr($hex, $pos, $sLen);

        // Pad or trim R and S to 32 bytes (64 hex chars)
        $r = str_pad(ltrim($r, '0'), 64, '0', STR_PAD_LEFT);
        $s = str_pad(ltrim($s, '0'), 64, '0', STR_PAD_LEFT);

        // Ensure exactly 64 hex chars each
        $r = substr($r, -64);
        $s = substr($s, -64);

        return hex2bin($r . $s);
    }

    /**
     * Get OAuth2 access token from service account (cached 50min) — for FCM
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
