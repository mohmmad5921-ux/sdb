<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        // Payment Gateway Merchants
        Schema::create('merchants', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->nullable()->constrained()->onDelete('set null');
            $table->string('business_name');
            $table->string('business_name_ar')->nullable();
            $table->string('business_email');
            $table->string('business_phone')->nullable();
            $table->string('website_url')->nullable();
            $table->text('description')->nullable();
            $table->string('logo')->nullable();
            $table->enum('status', ['pending', 'active', 'suspended', 'rejected'])->default('pending');
            $table->enum('category', ['ecommerce', 'retail', 'services', 'food', 'travel', 'education', 'healthcare', 'other'])->default('other');
            $table->decimal('fee_percentage', 5, 2)->default(2.5);
            $table->decimal('fee_fixed', 10, 2)->default(0);
            $table->foreignId('settlement_account_id')->nullable()->constrained('accounts')->onDelete('set null');
            $table->string('settlement_currency', 10)->default('EUR');
            $table->decimal('total_volume', 18, 4)->default(0);
            $table->integer('total_transactions')->default(0);
            $table->json('allowed_currencies')->nullable();
            $table->json('webhook_urls')->nullable();
            $table->timestamps();
        });

        // API Keys for merchants
        Schema::create('merchant_api_keys', function (Blueprint $table) {
            $table->id();
            $table->foreignId('merchant_id')->constrained()->onDelete('cascade');
            $table->string('name')->default('Default');
            $table->string('public_key', 64)->unique();
            $table->string('secret_key_hash');
            $table->string('secret_key_prefix', 12);
            $table->enum('environment', ['sandbox', 'production'])->default('sandbox');
            $table->boolean('is_active')->default(true);
            $table->timestamp('last_used_at')->nullable();
            $table->timestamps();

            $table->index(['merchant_id', 'is_active']);
        });

        // Payment Sessions
        Schema::create('payment_sessions', function (Blueprint $table) {
            $table->id();
            $table->string('session_id', 64)->unique();
            $table->foreignId('merchant_id')->constrained()->onDelete('cascade');
            $table->decimal('amount', 18, 4);
            $table->string('currency_code', 10)->default('EUR');
            $table->enum('status', ['pending', 'paid', 'failed', 'expired', 'refunded', 'cancelled'])->default('pending');
            $table->string('description')->nullable();
            $table->string('order_id')->nullable();
            $table->string('customer_email')->nullable();
            $table->string('customer_name')->nullable();
            $table->string('success_url')->nullable();
            $table->string('cancel_url')->nullable();
            $table->string('webhook_url')->nullable();
            $table->foreignId('paid_by_user_id')->nullable()->constrained('users')->onDelete('set null');
            $table->foreignId('paid_from_account_id')->nullable()->constrained('accounts')->onDelete('set null');
            $table->foreignId('transaction_id')->nullable()->constrained()->onDelete('set null');
            $table->json('metadata')->nullable();
            $table->decimal('fee_amount', 18, 4)->default(0);
            $table->string('payment_method')->nullable();
            $table->string('ip_address')->nullable();
            $table->timestamp('paid_at')->nullable();
            $table->timestamp('expires_at');
            $table->timestamps();

            $table->index(['merchant_id', 'status']);
            $table->index('session_id');
            $table->index('order_id');
        });

        // Webhook delivery log
        Schema::create('webhook_deliveries', function (Blueprint $table) {
            $table->id();
            $table->foreignId('payment_session_id')->constrained()->onDelete('cascade');
            $table->string('url');
            $table->string('event');
            $table->json('payload');
            $table->integer('http_status')->nullable();
            $table->text('response_body')->nullable();
            $table->boolean('is_successful')->default(false);
            $table->integer('attempt_number')->default(1);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('webhook_deliveries');
        Schema::dropIfExists('payment_sessions');
        Schema::dropIfExists('merchant_api_keys');
        Schema::dropIfExists('merchants');
    }
};