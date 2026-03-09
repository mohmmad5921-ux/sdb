<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('waitlist_emails', function (Blueprint $table) {
            $table->id();
            $table->string('email')->unique();
            $table->string('source')->default('hero'); // hero, footer, etc.
            $table->string('ip_address')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('waitlist_emails');
    }
};
