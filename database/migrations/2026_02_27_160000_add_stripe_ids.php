<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('cards', function (Blueprint $table) {
            $table->string('stripe_card_id')->nullable()->after('contactless_enabled');
        });
        Schema::table('users', function (Blueprint $table) {
            $table->string('stripe_cardholder_id')->nullable()->after('kyc_status');
        });
    }

    public function down(): void
    {
        Schema::table('cards', function (Blueprint $table) {
            $table->dropColumn('stripe_card_id');
        });
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('stripe_cardholder_id');
        });
    }
};