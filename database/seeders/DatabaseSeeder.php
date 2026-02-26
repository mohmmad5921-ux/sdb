<?php

namespace Database\Seeders;

use App\Models\Currency;
use App\Models\ExchangeRate;
use App\Models\Setting;
use App\Models\User;
use App\Services\AccountService;
use App\Services\IbanService;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Seed Currencies
        $eur = Currency::create([
            'code' => 'EUR', 'name' => 'Euro', 'name_ar' => 'يورو',
            'symbol' => '€', 'type' => 'fiat', 'exchange_rate_to_eur' => 1,
            'is_active' => true, 'is_default' => true, 'decimal_places' => 2, 'sort_order' => 1,
        ]);
        $usd = Currency::create([
            'code' => 'USD', 'name' => 'US Dollar', 'name_ar' => 'دولار أمريكي',
            'symbol' => '$', 'type' => 'fiat', 'exchange_rate_to_eur' => 0.92,
            'is_active' => true, 'is_default' => true, 'decimal_places' => 2, 'sort_order' => 2,
        ]);
        $syp = Currency::create([
            'code' => 'SYP', 'name' => 'Syrian Pound', 'name_ar' => 'ليرة سورية',
            'symbol' => 'ل.س', 'type' => 'fiat', 'exchange_rate_to_eur' => 0.000029,
            'is_active' => true, 'is_default' => false, 'decimal_places' => 0, 'sort_order' => 3,
        ]);
        $usdt = Currency::create([
            'code' => 'USDT', 'name' => 'Tether', 'name_ar' => 'تيثر',
            'symbol' => '₮', 'type' => 'crypto', 'exchange_rate_to_eur' => 0.92,
            'is_active' => true, 'is_default' => false, 'decimal_places' => 6, 'sort_order' => 4,
        ]);
        $btc = Currency::create([
            'code' => 'BTC', 'name' => 'Bitcoin', 'name_ar' => 'بيتكوين',
            'symbol' => '₿', 'type' => 'crypto', 'exchange_rate_to_eur' => 82000,
            'is_active' => true, 'is_default' => false, 'decimal_places' => 8, 'sort_order' => 5,
        ]);
        $eth = Currency::create([
            'code' => 'ETH', 'name' => 'Ethereum', 'name_ar' => 'إيثيريوم',
            'symbol' => 'Ξ', 'type' => 'crypto', 'exchange_rate_to_eur' => 2800,
            'is_active' => true, 'is_default' => false, 'decimal_places' => 8, 'sort_order' => 6,
        ]);

        // 2. Seed Exchange Rates
        ExchangeRate::create([
            'from_currency_id' => $eur->id, 'to_currency_id' => $usd->id,
            'rate' => 1.0870, 'spread' => 0.5, 'buy_rate' => 1.0820, 'sell_rate' => 1.0920,
        ]);
        ExchangeRate::create([
            'from_currency_id' => $eur->id, 'to_currency_id' => $syp->id,
            'rate' => 34500, 'spread' => 1.0, 'buy_rate' => 34300, 'sell_rate' => 34700,
        ]);
        ExchangeRate::create([
            'from_currency_id' => $usd->id, 'to_currency_id' => $syp->id,
            'rate' => 31700, 'spread' => 1.0, 'buy_rate' => 31500, 'sell_rate' => 31900,
        ]);
        ExchangeRate::create([
            'from_currency_id' => $eur->id, 'to_currency_id' => $usdt->id,
            'rate' => 1.0870, 'spread' => 0.3, 'buy_rate' => 1.0840, 'sell_rate' => 1.0900,
        ]);

        // 3. Seed Admin User
        $admin = User::create([
            'full_name' => 'مدير سوريا ديجيتال بنك',
            'email' => 'admin@sdb.sy',
            'phone' => '+963000000000',
            'password' => Hash::make('Admin@2026!'),
            'status' => 'active',
            'kyc_status' => 'verified',
            'role' => 'super_admin',
            'preferred_language' => 'ar',
            'email_verified_at' => now(),
        ]);

        // 4. Seed Demo Customer
        $customer = User::create([
            'full_name' => 'أحمد محمد',
            'email' => 'demo@sdb.sy',
            'phone' => '+963111111111',
            'password' => Hash::make('Demo@2026!'),
            'status' => 'active',
            'kyc_status' => 'verified',
            'nationality' => 'Syrian',
            'date_of_birth' => '1990-01-15',
            'address' => 'دمشق، سوريا',
            'city' => 'Damascus',
            'country' => 'SY',
            'role' => 'customer',
            'preferred_language' => 'ar',
            'email_verified_at' => now(),
        ]);

        // Create default accounts for demo customer
        $accountService = new AccountService(new IbanService());
        $accounts = $accountService->createDefaultAccounts($customer);

        // Add some balance to demo accounts
        foreach ($accounts as $account) {
            $accountService->credit($account, $account->currency->code === 'EUR' ? 5000 : 3000, 'Welcome bonus');
        }

        // 5. Seed Settings
        $settings = [
            ['key' => 'bank_name', 'value' => 'Syria Digital Bank', 'group' => 'general'],
            ['key' => 'bank_name_ar', 'value' => 'سوريا ديجيتال بنك', 'group' => 'general'],
            ['key' => 'transfer_fee_percentage', 'value' => '0.5', 'group' => 'fees'],
            ['key' => 'transfer_fee_min', 'value' => '0', 'group' => 'fees'],
            ['key' => 'transfer_fee_max', 'value' => '50', 'group' => 'fees'],
            ['key' => 'exchange_spread', 'value' => '0.5', 'group' => 'exchange'],
            ['key' => 'daily_transfer_limit', 'value' => '10000', 'group' => 'limits'],
            ['key' => 'monthly_transfer_limit', 'value' => '50000', 'group' => 'limits'],
            ['key' => 'max_cards_per_user', 'value' => '5', 'group' => 'cards'],
            ['key' => 'default_card_daily_limit', 'value' => '2000', 'group' => 'cards'],
        ];
        foreach ($settings as $setting) {
            Setting::create($setting);
        }
    }
}