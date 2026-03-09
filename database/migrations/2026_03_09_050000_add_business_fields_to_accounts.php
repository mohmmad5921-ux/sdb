<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('accounts', function (Blueprint $table) {
            $table->string('business_code', 4)->nullable()->unique()->after('iban');
            $table->text('qr_data')->nullable()->after('business_code');
            $table->enum('account_type', ['personal', 'business'])->default('personal')->after('account_name');
        });
    }

    public function down(): void
    {
        Schema::table('accounts', function (Blueprint $table) {
            $table->dropColumn(['business_code', 'qr_data', 'account_type']);
        });
    }
};
