<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('cards', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('account_id')->constrained()->onDelete('cascade');
            $table->string('card_number_masked', 19);
            $table->string('card_number_encrypted')->nullable();
            $table->string('card_type', 30)->default('virtual_mastercard');
            $table->string('card_holder_name');
            $table->enum('status', ['active', 'frozen', 'expired', 'cancelled'])->default('active');
            $table->decimal('spending_limit', 18, 4)->default(5000);
            $table->decimal('daily_limit', 18, 4)->default(2000);
            $table->decimal('monthly_limit', 18, 4)->default(10000);
            $table->date('expiry_date');
            $table->string('cvv_hash')->nullable();
            $table->string('billing_address')->nullable();
            $table->boolean('online_payment_enabled')->default(true);
            $table->boolean('contactless_enabled')->default(true);
            $table->timestamps();

            $table->index(['user_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cards');
    }
};