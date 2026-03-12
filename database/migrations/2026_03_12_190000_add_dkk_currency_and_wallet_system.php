<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Add DKK currency if not exists
        if (!DB::table('currencies')->where('code', 'DKK')->exists()) {
            DB::table('currencies')->insert([
                'code' => 'DKK',
                'name' => 'Danish Krone',
                'name_ar' => 'كرون دنماركي',
                'symbol' => 'kr',
                'type' => 'fiat',
                'exchange_rate_to_eur' => 0.1340,
                'is_active' => true,
                'is_default' => false,
                'decimal_places' => 2,
                'flag_icon' => '🇩🇰',
                'sort_order' => 4,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Add GBP currency if not exists
        if (!DB::table('currencies')->where('code', 'GBP')->exists()) {
            DB::table('currencies')->insert([
                'code' => 'GBP',
                'name' => 'British Pound',
                'name_ar' => 'جنيه إسترليني',
                'symbol' => '£',
                'type' => 'fiat',
                'exchange_rate_to_eur' => 1.1700,
                'is_active' => true,
                'is_default' => false,
                'decimal_places' => 2,
                'flag_icon' => '🇬🇧',
                'sort_order' => 5,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Add SEK currency if not exists
        if (!DB::table('currencies')->where('code', 'SEK')->exists()) {
            DB::table('currencies')->insert([
                'code' => 'SEK',
                'name' => 'Swedish Krona',
                'name_ar' => 'كرون سويدي',
                'symbol' => 'kr',
                'type' => 'fiat',
                'exchange_rate_to_eur' => 0.0880,
                'is_active' => true,
                'is_default' => false,
                'decimal_places' => 2,
                'flag_icon' => '🇸🇪',
                'sort_order' => 6,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Add TRY currency if not exists
        if (!DB::table('currencies')->where('code', 'TRY')->exists()) {
            DB::table('currencies')->insert([
                'code' => 'TRY',
                'name' => 'Turkish Lira',
                'name_ar' => 'ليرة تركية',
                'symbol' => '₺',
                'type' => 'fiat',
                'exchange_rate_to_eur' => 0.0260,
                'is_active' => true,
                'is_default' => false,
                'decimal_places' => 2,
                'flag_icon' => '🇹🇷',
                'sort_order' => 7,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Update existing currencies with flag icons
        DB::table('currencies')->where('code', 'EUR')->update(['flag_icon' => '🇪🇺', 'name_ar' => 'يورو']);
        DB::table('currencies')->where('code', 'USD')->update(['flag_icon' => '🇺🇸', 'name_ar' => 'دولار أمريكي']);
        DB::table('currencies')->where('code', 'SYP')->update(['flag_icon' => '🇸🇾', 'name_ar' => 'ليرة سورية']);
    }

    public function down(): void
    {
        DB::table('currencies')->whereIn('code', ['DKK', 'GBP', 'SEK', 'TRY'])->delete();
    }
};
