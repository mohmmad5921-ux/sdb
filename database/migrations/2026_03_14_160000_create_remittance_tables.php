<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Syrian Governorates
        Schema::create('governorates', function (Blueprint $table) {
            $table->id();
            $table->string('name_ar');
            $table->string('name_en');
            $table->string('code', 10)->unique();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Districts within governorates
        Schema::create('districts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('governorate_id')->constrained()->cascadeOnDelete();
            $table->string('name_ar');
            $table->string('name_en');
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Agent offices (cash pickup points)
        Schema::create('agents', function (Blueprint $table) {
            $table->id();
            $table->foreignId('district_id')->constrained()->cascadeOnDelete();
            $table->string('name_ar');
            $table->string('name_en');
            $table->string('phone')->nullable();
            $table->string('address_ar')->nullable();
            $table->string('address_en')->nullable();
            $table->decimal('commission_rate', 5, 2)->default(0); // percentage
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Remittance transactions
        Schema::create('remittances', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('agent_id')->constrained();
            $table->string('recipient_name');
            $table->string('recipient_phone');
            $table->decimal('amount', 15, 2);
            $table->string('send_currency', 5)->default('EUR');
            $table->decimal('receive_amount', 15, 2)->nullable();
            $table->string('receive_currency', 5)->default('SYP');
            $table->decimal('exchange_rate', 15, 4)->nullable();
            $table->decimal('fee', 10, 2)->default(0);
            $table->enum('status', ['pending', 'ready', 'collected', 'expired', 'cancelled'])->default('pending');
            $table->string('notification_code', 8)->unique();
            $table->uuid('qr_token')->unique();
            $table->text('notes')->nullable();
            $table->timestamp('collected_at')->nullable();
            $table->timestamp('expires_at')->nullable();
            $table->timestamps();

            $table->index('notification_code');
            $table->index('qr_token');
            $table->index('recipient_phone');
            $table->index('status');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('remittances');
        Schema::dropIfExists('agents');
        Schema::dropIfExists('districts');
        Schema::dropIfExists('governorates');
    }
};
