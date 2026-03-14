<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('subscription_plans', function (Blueprint $table) {
            $table->id();
            $table->string('slug')->unique(); // basic, premium, vip, business
            $table->string('name_en');
            $table->string('name_ar');
            $table->integer('price_monthly'); // in DKK øre (0 = free)
            $table->integer('price_yearly')->nullable();
            $table->string('currency', 3)->default('DKK');
            $table->json('features')->nullable(); // JSON array of feature keys
            $table->integer('max_wallets')->default(1);
            $table->integer('max_transfers_monthly')->default(5);
            $table->boolean('has_virtual_card')->default(false);
            $table->boolean('has_physical_card')->default(false);
            $table->boolean('has_remittance')->default(false);
            $table->decimal('cashback_pct', 4, 2)->default(0);
            $table->boolean('is_active')->default(true);
            $table->integer('sort_order')->default(0);
            $table->timestamps();
        });

        Schema::create('subscriptions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('plan_id')->constrained('subscription_plans')->onDelete('cascade');
            $table->string('status')->default('active'); // active, cancelled, expired, past_due
            $table->string('billing_cycle')->default('monthly'); // monthly, yearly
            $table->string('stripe_subscription_id')->nullable();
            $table->string('stripe_payment_intent_id')->nullable();
            $table->timestamp('starts_at')->nullable();
            $table->timestamp('ends_at')->nullable();
            $table->timestamp('cancelled_at')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('subscriptions');
        Schema::dropIfExists('subscription_plans');
    }
};
