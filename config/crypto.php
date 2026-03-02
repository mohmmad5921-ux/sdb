<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Binance API (for future use)
    |--------------------------------------------------------------------------
    */
    'binance_api_key' => env('BINANCE_API_KEY', ''),
    'binance_secret_key' => env('BINANCE_SECRET_KEY', ''),
    'binance_testnet' => env('BINANCE_TESTNET', true),

    /*
    |--------------------------------------------------------------------------
    | CoinGecko (free price API, no key needed)
    |--------------------------------------------------------------------------
    */
    'price_provider' => env('CRYPTO_PRICE_PROVIDER', 'coingecko'),

    /*
    |--------------------------------------------------------------------------
    | Trading Settings
    |--------------------------------------------------------------------------
    */
    'spread_percent' => env('CRYPTO_SPREAD_PERCENT', 0.5),   // 0.5% commission
    'min_trade_eur' => env('CRYPTO_MIN_TRADE_EUR', 10),       // Minimum €10
    'max_trade_eur' => env('CRYPTO_MAX_TRADE_EUR', 50000),    // Maximum €50,000
];
