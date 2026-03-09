<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        // Promotions & Coupons
        Schema::create('promotions', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->string('code')->unique();
            $t->enum('type', ['percentage', 'fixed', 'free_transfer']);
            $t->decimal('value', 10, 2)->default(0);
            $t->string('applies_to')->default('all'); // all, transfer, exchange, card
            $t->integer('max_uses')->nullable();
            $t->integer('used_count')->default(0);
            $t->timestamp('starts_at')->nullable();
            $t->timestamp('expires_at')->nullable();
            $t->boolean('active')->default(true);
            $t->timestamps();
        });

        // CMS Content blocks
        Schema::create('cms_contents', function (Blueprint $t) {
            $t->id();
            $t->string('key')->unique();
            $t->string('section')->default('general');
            $t->string('label');
            $t->text('value_en')->nullable();
            $t->text('value_ar')->nullable();
            $t->enum('type', ['text', 'textarea', 'html', 'json'])->default('text');
            $t->timestamps();
        });

        // Account limits by KYC level
        Schema::create('account_limits', function (Blueprint $t) {
            $t->id();
            $t->string('kyc_level'); // basic, verified, premium
            $t->string('limit_type'); // daily_transfer, monthly_transfer, daily_withdrawal, single_transaction
            $t->decimal('amount', 15, 2);
            $t->string('currency')->default('EUR');
            $t->boolean('active')->default(true);
            $t->timestamps();
        });

        // Frozen accounts log
        Schema::create('frozen_accounts', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained();
            $t->foreignId('account_id')->nullable();
            $t->enum('action', ['freeze', 'unfreeze']);
            $t->string('reason');
            $t->text('notes')->nullable();
            $t->foreignId('admin_id')->nullable();
            $t->timestamps();
        });

        // System changelog
        Schema::create('system_changelog', function (Blueprint $t) {
            $t->id();
            $t->foreignId('admin_id')->constrained('users');
            $t->string('category'); // settings, fees, limits, rates, cms
            $t->string('action'); // create, update, delete
            $t->string('target');
            $t->json('old_value')->nullable();
            $t->json('new_value')->nullable();
            $t->string('ip_address')->nullable();
            $t->timestamps();
        });

        // Smart alerts
        Schema::create('smart_alerts', function (Blueprint $t) {
            $t->id();
            $t->string('type'); // large_transaction, failed_login, suspicious, system_error
            $t->string('severity')->default('medium'); // low, medium, high, critical
            $t->string('title');
            $t->text('description');
            $t->json('metadata')->nullable();
            $t->foreignId('user_id')->nullable();
            $t->boolean('read')->default(false);
            $t->foreignId('resolved_by')->nullable();
            $t->timestamp('resolved_at')->nullable();
            $t->timestamps();
        });

        // Seed default account limits
        DB::table('account_limits')->insert([
            ['kyc_level' => 'basic', 'limit_type' => 'daily_transfer', 'amount' => 1000, 'currency' => 'EUR', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['kyc_level' => 'basic', 'limit_type' => 'monthly_transfer', 'amount' => 5000, 'currency' => 'EUR', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['kyc_level' => 'basic', 'limit_type' => 'single_transaction', 'amount' => 500, 'currency' => 'EUR', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['kyc_level' => 'verified', 'limit_type' => 'daily_transfer', 'amount' => 10000, 'currency' => 'EUR', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['kyc_level' => 'verified', 'limit_type' => 'monthly_transfer', 'amount' => 50000, 'currency' => 'EUR', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['kyc_level' => 'verified', 'limit_type' => 'single_transaction', 'amount' => 5000, 'currency' => 'EUR', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['kyc_level' => 'premium', 'limit_type' => 'daily_transfer', 'amount' => 100000, 'currency' => 'EUR', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['kyc_level' => 'premium', 'limit_type' => 'monthly_transfer', 'amount' => 500000, 'currency' => 'EUR', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['kyc_level' => 'premium', 'limit_type' => 'single_transaction', 'amount' => 50000, 'currency' => 'EUR', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Seed default CMS content
        DB::table('cms_contents')->insert([
            ['key' => 'hero_title', 'section' => 'landing', 'label' => 'عنوان الصفحة الرئيسية', 'value_en' => 'Banking for a new era', 'value_ar' => 'مصرفية لعصر جديد', 'type' => 'text', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'hero_subtitle', 'section' => 'landing', 'label' => 'وصف الصفحة الرئيسية', 'value_en' => 'Open your account in minutes', 'value_ar' => 'افتح حسابك في دقائق', 'type' => 'text', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'maintenance_msg', 'section' => 'system', 'label' => 'رسالة الصيانة', 'value_en' => 'We are performing scheduled maintenance', 'value_ar' => 'نقوم بصيانة مجدولة', 'type' => 'text', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'welcome_email', 'section' => 'emails', 'label' => 'رسالة الترحيب', 'value_en' => 'Welcome to SDB Bank!', 'value_ar' => 'أهلاً بك في بنك SDB!', 'type' => 'textarea', 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('smart_alerts');
        Schema::dropIfExists('system_changelog');
        Schema::dropIfExists('frozen_accounts');
        Schema::dropIfExists('account_limits');
        Schema::dropIfExists('cms_contents');
        Schema::dropIfExists('promotions');
    }
};
