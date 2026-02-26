<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('exchange_rates', function (Blueprint $table) {
            $table->id();
            $table->foreignId('from_currency_id')->constrained('currencies')->onDelete('cascade');
            $table->foreignId('to_currency_id')->constrained('currencies')->onDelete('cascade');
            $table->decimal('rate', 18, 8);
            $table->decimal('spread', 8, 4)->default(0);
            $table->decimal('buy_rate', 18, 8);
            $table->decimal('sell_rate', 18, 8);
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->unique(['from_currency_id', 'to_currency_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('exchange_rates');
    }
};