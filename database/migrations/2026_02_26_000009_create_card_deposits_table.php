<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('card_deposits', function (Blueprint $table) {
            $table->id();
            $table->string('reference', 32)->unique();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('account_id')->constrained()->onDelete('cascade');
            $table->foreignId('transaction_id')->nullable()->constrained()->onDelete('set null');
            $table->decimal('amount', 18, 4);
            $table->string('currency_code', 10);
            $table->decimal('fee_amount', 18, 4)->default(0);
            $table->decimal('net_amount', 18, 4);
            // External card info (masked for security)
            $table->string('card_brand')->nullable(); // visa, mastercard
            $table->string('card_last_four', 4);
            $table->string('card_holder_name');
            $table->string('card_expiry_masked', 5); // MM/YY
            // Processing
            $table->enum('status', ['processing', 'completed', 'failed', 'refunded'])->default('processing');
            $table->string('processor_reference')->nullable(); // external gateway reference
            $table->string('failure_reason')->nullable();
            $table->string('ip_address')->nullable();
            $table->timestamp('completed_at')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('card_deposits');
    }
};