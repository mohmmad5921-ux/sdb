<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('app_settings', function (Blueprint $table) {
            $table->id();
            $table->string('key')->unique();
            $table->text('value')->nullable();
            $table->string('type', 20)->default('string'); // string, boolean, json
            $table->string('group', 50)->default('general');
            $table->string('label')->nullable();
            $table->timestamps();
        });

        // Seed default settings
        \DB::table('app_settings')->insert([
            ['key' => 'maintenance_mode', 'value' => '0', 'type' => 'boolean', 'group' => 'app', 'label' => 'وضع الصيانة', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'maintenance_message', 'value' => 'النظام تحت الصيانة، يرجى المحاولة لاحقاً', 'type' => 'string', 'group' => 'app', 'label' => 'رسالة الصيانة', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'force_update', 'value' => '0', 'type' => 'boolean', 'group' => 'app', 'label' => 'تحديث إجباري', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'min_app_version', 'value' => '1.0.0', 'type' => 'string', 'group' => 'app', 'label' => 'أقل إصدار مطلوب', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'feature_transfers', 'value' => '1', 'type' => 'boolean', 'group' => 'features', 'label' => 'التحويلات', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'feature_cards', 'value' => '1', 'type' => 'boolean', 'group' => 'features', 'label' => 'البطاقات', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'feature_exchange', 'value' => '1', 'type' => 'boolean', 'group' => 'features', 'label' => 'صرف العملات', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'feature_crypto', 'value' => '1', 'type' => 'boolean', 'group' => 'features', 'label' => 'العملات الرقمية', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'feature_deposits', 'value' => '1', 'type' => 'boolean', 'group' => 'features', 'label' => 'الإيداع', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'feature_withdrawals', 'value' => '1', 'type' => 'boolean', 'group' => 'features', 'label' => 'السحب', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'max_transfer_amount', 'value' => '50000', 'type' => 'string', 'group' => 'limits', 'label' => 'الحد الأقصى للتحويل', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'daily_transfer_limit', 'value' => '100000', 'type' => 'string', 'group' => 'limits', 'label' => 'الحد اليومي للتحويلات', 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('app_settings');
    }
};
