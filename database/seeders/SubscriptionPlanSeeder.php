<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class SubscriptionPlanSeeder extends Seeder
{
    public function run(): void
    {
        $plans = [
            [
                'slug' => 'basic',
                'name_en' => 'Basic',
                'name_ar' => 'أساسي',
                'price_monthly' => 0,
                'price_yearly' => 0,
                'currency' => 'DKK',
                'max_wallets' => 1,
                'max_transfers_monthly' => 5,
                'has_virtual_card' => false,
                'has_physical_card' => false,
                'has_remittance' => false,
                'cashback_pct' => 0,
                'sort_order' => 0,
                'features' => json_encode(['1_wallet', 'limited_transfers', 'email_support']),
            ],
            [
                'slug' => 'premium',
                'name_en' => 'Premium',
                'name_ar' => 'بريميوم',
                'price_monthly' => 2900, // 29 DKK in øre
                'price_yearly' => 27840, // 29*12*0.8
                'currency' => 'DKK',
                'max_wallets' => 5,
                'max_transfers_monthly' => 0, // unlimited
                'has_virtual_card' => true,
                'has_physical_card' => false,
                'has_remittance' => true,
                'cashback_pct' => 0,
                'sort_order' => 1,
                'features' => json_encode(['multi_wallet', 'unlimited_transfers', 'virtual_card', 'remittance', 'priority_support']),
            ],
            [
                'slug' => 'vip',
                'name_en' => 'VIP',
                'name_ar' => 'VIP',
                'price_monthly' => 7900, // 79 DKK
                'price_yearly' => 75840, // 79*12*0.8
                'currency' => 'DKK',
                'max_wallets' => 10,
                'max_transfers_monthly' => 0,
                'has_virtual_card' => true,
                'has_physical_card' => true,
                'has_remittance' => true,
                'cashback_pct' => 2.0,
                'sort_order' => 2,
                'features' => json_encode(['all_premium', 'physical_card', 'cashback', 'free_remittance', 'account_manager', 'reports']),
            ],
            [
                'slug' => 'business',
                'name_en' => 'Business',
                'name_ar' => 'أعمال',
                'price_monthly' => 14900, // 149 DKK
                'price_yearly' => 143040, // 149*12*0.8
                'currency' => 'DKK',
                'max_wallets' => 20,
                'max_transfers_monthly' => 0,
                'has_virtual_card' => true,
                'has_physical_card' => true,
                'has_remittance' => true,
                'cashback_pct' => 3.0,
                'sort_order' => 3,
                'features' => json_encode(['all_vip', 'business_accounts', 'invoicing', 'auto_accounting', 'api_access', '24_7_support']),
            ],
        ];

        foreach ($plans as $plan) {
            DB::table('subscription_plans')->updateOrInsert(
                ['slug' => $plan['slug']],
                array_merge($plan, ['created_at' => now(), 'updated_at' => now()])
            );
        }
    }
}
