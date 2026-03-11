<?php

use App\Http\Controllers\Api\MobileApiController;
use App\Http\Controllers\Api\PaymentApiController;
use Illuminate\Support\Facades\Route;

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

            // Dashboard
            Route::get('/dashboard', [MobileApiController::class, 'dashboard']);

            // Accounts
            Route::get('/accounts', [MobileApiController::class, 'accounts']);

            // Transactions
            Route::get('/transactions', [MobileApiController::class, 'transactions']);
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

            // Cards
            Route::get('/cards', [MobileApiController::class, 'cards']);
            Route::post('/cards/issue', [MobileApiController::class, 'issueCard']);
            Route::post('/cards/{card}/toggle-freeze', [MobileApiController::class, 'toggleCardFreeze']);
            Route::get('/cards/{card}/wallet-pass', [\App\Http\Controllers\Api\AppleWalletController::class, 'generatePass']);

            // Notifications
            Route::get('/notifications', [MobileApiController::class, 'notifications']);
            Route::post('/notifications/{notification}/read', [MobileApiController::class, 'markNotificationRead']);

            // FCM Push Token
            Route::post('/fcm-token', [MobileApiController::class, 'updateFcmToken']);
        }
    );
});