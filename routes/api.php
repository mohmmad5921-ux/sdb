<?php

use App\Http\Controllers\Api\MobileApiController;
use App\Http\Controllers\Api\PaymentApiController;
use Illuminate\Support\Facades\Route;

// Payment Gateway API (merchant API key auth)
Route::prefix('v1')->group(function () {
    Route::post('/checkout/sessions', [PaymentApiController::class , 'createSession']);
    Route::get('/checkout/sessions/{sessionId}', [PaymentApiController::class , 'getSession']);
    Route::post('/checkout/sessions/{sessionId}/refund', [PaymentApiController::class , 'refund']);
});

// Mobile App API (Sanctum auth)
Route::prefix('v1/mobile')->group(function () {
    // Auth (no token required)
    Route::post('/auth/login', [MobileApiController::class , 'login']);
    Route::post('/auth/register', [MobileApiController::class , 'register']);

    // Public
    Route::get('/currencies', [MobileApiController::class , 'currencies']);

    // Authenticated routes
    Route::middleware('auth:sanctum')->group(function () {
            Route::post('/auth/logout', [MobileApiController::class , 'logout']);

            // Profile
            Route::get('/profile', [MobileApiController::class , 'profile']);
            Route::patch('/profile', [MobileApiController::class , 'updateProfile']);

            // Dashboard
            Route::get('/dashboard', [MobileApiController::class , 'dashboard']);

            // Accounts
            Route::get('/accounts', [MobileApiController::class , 'accounts']);

            // Transactions
            Route::get('/transactions', [MobileApiController::class , 'transactions']);
            Route::post('/transfer', [MobileApiController::class , 'transfer']);
            Route::post('/exchange', [MobileApiController::class , 'exchange']);

            // Deposit
            Route::post('/deposit', [MobileApiController::class , 'deposit']);

            // Cards
            Route::get('/cards', [MobileApiController::class , 'cards']);
            Route::post('/cards/issue', [MobileApiController::class , 'issueCard']);
            Route::post('/cards/{card}/toggle-freeze', [MobileApiController::class , 'toggleCardFreeze']);

            // Notifications
            Route::get('/notifications', [MobileApiController::class , 'notifications']);
            Route::post('/notifications/{notification}/read', [MobileApiController::class , 'markNotificationRead']);
        }
        );
    });