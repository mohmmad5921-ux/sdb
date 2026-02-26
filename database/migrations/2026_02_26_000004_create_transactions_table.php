<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->string('reference_number', 30)->unique();
            $table->foreignId('from_account_id')->nullable()->constrained('accounts')->onDelete('set null');
            $table->foreignId('to_account_id')->nullable()->constrained('accounts')->onDelete('set null');
            $table->foreignId('currency_id')->constrained()->onDelete('restrict');
            $table->decimal('amount', 18, 4);
            $table->decimal('fee', 18, 4)->default(0);
            $table->decimal('exchange_rate', 18, 8)->nullable();
            $table->decimal('original_amount', 18, 4)->nullable();
            $table->foreignId('original_currency_id')->nullable()->constrained('currencies')->onDelete('set null');
            $table->enum('type', [
                'transfer',
                'deposit',
                'withdrawal',
                'exchange',
                'card_payment',
                'card_topup',
                'fee',
                'refund',
            ]);
            $table->enum('status', ['pending', 'processing', 'completed', 'failed', 'reversed', 'cancelled'])->default('pending');
            $table->string('description')->nullable();
            $table->string('beneficiary_name')->nullable();
            $table->string('beneficiary_iban')->nullable();
            $table->json('metadata')->nullable();
            $table->timestamp('completed_at')->nullable();
            $table->timestamps();

            $table->index(['from_account_id', 'status']);
            $table->index(['to_account_id', 'status']);
            $table->index(['type', 'status']);
            $table->index('created_at');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};