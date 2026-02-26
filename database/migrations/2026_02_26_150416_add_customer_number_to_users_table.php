<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('customer_number', 10)->unique()->nullable()->after('id');
        });

        // Generate customer numbers for existing users
        $users = \App\Models\User::whereNull('customer_number')->get();
        foreach ($users as $user) {
            $number = str_pad(mt_rand(0, 9999999999), 10, '0', STR_PAD_LEFT);
            while (\App\Models\User::where('customer_number', $number)->exists()) {
                $number = str_pad(mt_rand(0, 9999999999), 10, '0', STR_PAD_LEFT);
            }
            $user->update(['customer_number' => $number]);
        }
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('customer_number');
        });
    }
};