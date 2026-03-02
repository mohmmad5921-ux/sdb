<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration {
    public function up(): void
    {
        // Seed crypto currencies
        $cryptos = [
            ['code' => 'BTC', 'name' => 'Bitcoin', 'name_ar' => 'بتكوين', 'symbol' => '₿', 'type' => 'crypto', 'exchange_rate_to_eur' => 89450, 'decimal_places' => 8, 'flag_icon' => '₿', 'sort_order' => 100],
            ['code' => 'ETH', 'name' => 'Ethereum', 'name_ar' => 'إيثريوم', 'symbol' => 'Ξ', 'type' => 'crypto', 'exchange_rate_to_eur' => 3210, 'decimal_places' => 8, 'flag_icon' => '⟠', 'sort_order' => 101],
            ['code' => 'USDT', 'name' => 'Tether', 'name_ar' => 'تيثر', 'symbol' => '₮', 'type' => 'crypto', 'exchange_rate_to_eur' => 0.92, 'decimal_places' => 6, 'flag_icon' => '₮', 'sort_order' => 102],
            ['code' => 'SOL', 'name' => 'Solana', 'name_ar' => 'سولانا', 'symbol' => '◎', 'type' => 'crypto', 'exchange_rate_to_eur' => 183, 'decimal_places' => 8, 'flag_icon' => '◎', 'sort_order' => 103],
            ['code' => 'XRP', 'name' => 'Ripple', 'name_ar' => 'ريبل', 'symbol' => '✕', 'type' => 'crypto', 'exchange_rate_to_eur' => 2.15, 'decimal_places' => 6, 'flag_icon' => '✕', 'sort_order' => 104],
            ['code' => 'ADA', 'name' => 'Cardano', 'name_ar' => 'كاردانو', 'symbol' => '₳', 'type' => 'crypto', 'exchange_rate_to_eur' => 0.68, 'decimal_places' => 6, 'flag_icon' => '⬡', 'sort_order' => 105],
        ];

        foreach ($cryptos as $crypto) {
            DB::table('currencies')->updateOrInsert(
                ['code' => $crypto['code']],
                array_merge($crypto, [
                    'is_active' => true,
                    'is_default' => false,
                    'created_at' => now(),
                    'updated_at' => now(),
                ])
            );
        }
    }

    public function down(): void
    {
        DB::table('currencies')->whereIn('code', ['BTC', 'ETH', 'USDT', 'SOL', 'XRP', 'ADA'])->delete();
    }
};
