<?php

return [
    /*
    |--------------------------------------------------------------------------
    | MoonPay API Keys
    |--------------------------------------------------------------------------
    |
    | Public key (pk_test_* or pk_live_*) is safe to expose to frontend.
    | Secret key (sk_test_* or sk_live_*) is used only on the backend for
    | signing widget URLs (HMAC-SHA256).
    |
    */
    'api_key' => env('MOONPAY_API_KEY', ''),
    'secret_key' => env('MOONPAY_SECRET_KEY', ''),

    /*
    |--------------------------------------------------------------------------
    | Environment
    |--------------------------------------------------------------------------
    |
    | 'sandbox' for testing (no real money), 'production' for live.
    |
    */
    'environment' => env('MOONPAY_ENVIRONMENT', 'sandbox'),
];
