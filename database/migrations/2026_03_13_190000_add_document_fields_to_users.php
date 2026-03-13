<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('document_number', 50)->nullable()->after('kyc_status');
            $table->string('document_type', 30)->nullable()->after('document_number');
            $table->date('document_expiry')->nullable()->after('document_type');
            $table->string('sex', 10)->nullable()->after('document_expiry');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['document_number', 'document_type', 'document_expiry', 'sex']);
        });
    }
};
