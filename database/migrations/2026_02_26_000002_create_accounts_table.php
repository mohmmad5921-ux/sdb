<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('accounts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('currency_id')->constrained()->onDelete('restrict');
            $table->string('account_number', 20)->unique();
            $table->string('iban', 34)->unique();
            $table->decimal('balance', 18, 4)->default(0);
            $table->decimal('available_balance', 18, 4)->default(0);
            $table->decimal('held_balance', 18, 4)->default(0);
            $table->enum('status', ['active', 'frozen', 'closed'])->default('active');
            $table->boolean('is_default')->default(false);
            $table->string('account_name')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'currency_id']);
            $table->index('status');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('accounts');
    }
};