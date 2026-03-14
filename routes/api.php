<?php

use App\Http\Controllers\Api\MobileApiController;
use App\Http\Controllers\Api\PaymentApiController;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Route;

// Public exchange rates (no auth needed, cached)
Route::get('/public/rates', function () {
    $rates = Cache::get('live_rates');
    $updated = Cache::get('live_rates_updated');

    if (!$rates) {
        // Fallback hardcoded rates if cache is empty
        $rates = [
            'EUR' => 1, 'USD' => 1.08, 'GBP' => 0.86, 'DKK' => 7.46,
            'SEK' => 11.2, 'NOK' => 11.5, 'CHF' => 0.96, 'TRY' => 34.2,
            'AED' => 3.97, 'SAR' => 4.05, 'KWD' => 0.33, 'QAR' => 3.93,
            'BHD' => 0.41, 'OMR' => 0.42, 'JOD' => 0.77, 'EGP' => 53.2,
            'LBP' => 96800, 'IQD' => 1415, 'SYP' => 13500,
            'CAD' => 1.47, 'AUD' => 1.65, 'JPY' => 162,
        ];
        $updated = null;
    }

    return response()->json([
        'base' => 'EUR',
        'rates' => $rates,
        'updated_at' => $updated,
        'is_live' => $updated !== null,
    ])->header('Access-Control-Allow-Origin', '*')
      ->header('Cache-Control', 'public, max-age=300');
});

// Payment Gateway API (merchant API key auth)
Route::prefix('v1')->group(function () {
    Route::post('/checkout/sessions', [PaymentApiController::class, 'createSession']);
    Route::get('/checkout/sessions/{sessionId}', [PaymentApiController::class, 'getSession']);
    Route::post('/checkout/sessions/{sessionId}/refund', [PaymentApiController::class, 'refund']);
});

// Mobile App API (Sanctum auth)
Route::prefix('v1/mobile')->group(function () {
    // Auth (no token required)
    Route::post('/auth/login', [MobileApiController::class, 'login']);
    Route::post('/auth/register', [MobileApiController::class, 'register']);

    // Public
    Route::get('/currencies', [MobileApiController::class, 'currencies']);
    Route::post('/auth/check-username', [MobileApiController::class, 'checkUsername']);

    // Authenticated routes
    Route::middleware('auth:sanctum')->group(
        function () {
            Route::post('/auth/logout', [MobileApiController::class, 'logout']);

            // Profile
            Route::get('/profile', [MobileApiController::class, 'profile']);
            Route::patch('/profile', [MobileApiController::class, 'updateProfile']);
            Route::get('/users/@{username}', [MobileApiController::class, 'findByUsername']);

            // KYC
            Route::get('/kyc/status', [MobileApiController::class, 'kycStatus']);
            Route::post('/kyc/upload', [MobileApiController::class, 'uploadKyc']);
            Route::post('/kyc/upload-additional', [MobileApiController::class, 'uploadAdditionalDoc']);
            Route::post('/security/toggle-2fa', [MobileApiController::class, 'toggle2fa']);

            // Phone Verification (Twilio Verify)
            Route::post('/verify/send', [MobileApiController::class, 'sendVerification']);
            Route::post('/verify/check', [MobileApiController::class, 'checkVerification']);

            // Dashboard
            Route::get('/dashboard', [MobileApiController::class, 'dashboard']);

            // Accounts
            Route::get('/accounts', [MobileApiController::class, 'accounts']);

            // Transactions
            Route::get('/transactions', [MobileApiController::class, 'transactions']);
            Route::post('/transactions/{transaction}/note', [MobileApiController::class, 'updateTransactionNote']);
            Route::post('/transactions/{transaction}/receipt', [MobileApiController::class, 'uploadTransactionReceipt']);
            Route::post('/transfer', [MobileApiController::class, 'transfer']);
            Route::post('/exchange', [MobileApiController::class, 'exchange']);
            Route::get('/exchange-rate', [MobileApiController::class, 'exchangeRate']);

            // New Transfer System (lookup + execute)
            Route::post('/banking/transfer/lookup', [\App\Http\Controllers\TransferController::class, 'lookup']);
            Route::post('/banking/transfer/qr-lookup', [\App\Http\Controllers\TransferController::class, 'qrLookup']);
            Route::post('/banking/transfer/execute', [\App\Http\Controllers\TransferController::class, 'transfer']);
            Route::get('/banking/transfer/my-accounts', [\App\Http\Controllers\TransferController::class, 'myAccounts']);

            // Deposit
            Route::post('/deposit', [MobileApiController::class, 'deposit']);

            // Stripe Deposit
            Route::get('/stripe/config', [\App\Http\Controllers\Api\StripeDepositController::class, 'config']);
            Route::post('/stripe/create-intent', [\App\Http\Controllers\Api\StripeDepositController::class, 'createIntent']);
            Route::post('/stripe/confirm', [\App\Http\Controllers\Api\StripeDepositController::class, 'confirmDeposit']);

            // Cards
            Route::get('/cards', [MobileApiController::class, 'cards']);
            Route::post('/cards/issue', [MobileApiController::class, 'issueCard']);
            Route::post('/cards/{card}/toggle-freeze', [MobileApiController::class, 'toggleCardFreeze']);
            Route::post('/cards/{card}/delete', [MobileApiController::class, 'deleteCard']);
            Route::patch('/cards/{card}/settings', [MobileApiController::class, 'updateCardSettings']);
            Route::get('/cards/{card}/wallet-pass', [\App\Http\Controllers\Api\AppleWalletController::class, 'generatePass']);

            // Notifications
            Route::get('/notifications', [MobileApiController::class, 'notifications']);
            Route::post('/notifications/{notification}/read', [MobileApiController::class, 'markNotificationRead']);

            // FCM Push Token
            Route::post('/fcm-token', [MobileApiController::class, 'updateFcmToken']);

            // Wallets
            Route::get('/wallets/available', [MobileApiController::class, 'availableWallets']);
            Route::post('/wallets/open', [MobileApiController::class, 'openWallet']);

            // AI Chat
            Route::post('/ai-chat', [MobileApiController::class, 'aiChat']);

            // Support Chat
            Route::get('/support/messages', [MobileApiController::class, 'supportMessages']);
            Route::post('/support/send', [MobileApiController::class, 'sendSupportMessage']);
        }
    );
});