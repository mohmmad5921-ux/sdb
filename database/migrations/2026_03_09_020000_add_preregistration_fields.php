<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('preregistrations', function (Blueprint $table) {
            $table->string('governorate')->nullable()->after('country');
            $table->string('employment')->nullable()->after('governorate');
            $table->string('referral')->nullable()->after('employment');
        });
    }

    public function down(): void
    {
        Schema::table('preregistrations', function (Blueprint $table) {
            $table->dropColumn(['governorate', 'employment', 'referral']);
        });
    }
};
