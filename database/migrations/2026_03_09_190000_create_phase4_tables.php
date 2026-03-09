<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        // Fee structures
        Schema::create('fee_structures', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('type', 50); // transfer_internal, transfer_external, exchange, withdrawal, card_payment, monthly
            $table->decimal('fixed_fee', 10, 2)->default(0);
            $table->decimal('percentage_fee', 5, 4)->default(0); // e.g., 0.0150 = 1.5%
            $table->decimal('min_fee', 10, 2)->default(0);
            $table->decimal('max_fee', 10, 2)->default(0);
            $table->string('currency', 3)->default('EUR');
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Seed default fees
        \DB::table('fee_structures')->insert([
            ['name' => 'تحويل داخلي', 'type' => 'transfer_internal', 'fixed_fee' => 0, 'percentage_fee' => 0, 'min_fee' => 0, 'max_fee' => 0, 'currency' => 'EUR', 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'تحويل خارجي', 'type' => 'transfer_external', 'fixed_fee' => 2.50, 'percentage_fee' => 0.005, 'min_fee' => 2.50, 'max_fee' => 25, 'currency' => 'EUR', 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'صرف عملات', 'type' => 'exchange', 'fixed_fee' => 0, 'percentage_fee' => 0.015, 'min_fee' => 0.50, 'max_fee' => 50, 'currency' => 'EUR', 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'سحب ATM', 'type' => 'withdrawal', 'fixed_fee' => 1.50, 'percentage_fee' => 0, 'min_fee' => 1.50, 'max_fee' => 0, 'currency' => 'EUR', 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'دفع بالبطاقة', 'type' => 'card_payment', 'fixed_fee' => 0, 'percentage_fee' => 0, 'min_fee' => 0, 'max_fee' => 0, 'currency' => 'EUR', 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'اشتراك شهري', 'type' => 'monthly', 'fixed_fee' => 4.99, 'percentage_fee' => 0, 'min_fee' => 4.99, 'max_fee' => 4.99, 'currency' => 'EUR', 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
        ]);

        // User tags
        Schema::create('user_tags', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('tag', 50);
            $table->string('color', 7)->default('#64748b');
            $table->foreignId('added_by')->constrained('users');
            $table->timestamps();
            $table->unique(['user_id', 'tag']);
        });

        // Pending approvals
        Schema::create('pending_approvals', function (Blueprint $table) {
            $table->id();
            $table->string('type', 50); // large_transfer, withdrawal, account_close
            $table->foreignId('user_id')->constrained('users');
            $table->foreignId('requested_by')->nullable()->constrained('users');
            $table->json('data')->nullable();
            $table->decimal('amount', 15, 2)->default(0);
            $table->string('currency', 3)->default('EUR');
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $table->foreignId('reviewed_by')->nullable()->constrained('users');
            $table->text('review_note')->nullable();
            $table->timestamp('reviewed_at')->nullable();
            $table->timestamps();
            $table->index(['status', 'created_at']);
        });

        // Communication logs
        Schema::create('communication_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('channel', 20)->default('email'); // email, sms, push, system
            $table->string('subject');
            $table->text('content')->nullable();
            $table->string('status', 20)->default('sent'); // sent, failed, pending
            $table->string('template')->nullable();
            $table->timestamps();
            $table->index(['user_id', 'created_at']);
        });

        // Admin login history
        Schema::create('admin_login_history', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('ip_address', 45);
            $table->string('user_agent')->nullable();
            $table->string('device', 100)->nullable();
            $table->string('location')->nullable();
            $table->enum('status', ['success', 'failed'])->default('success');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('admin_login_history');
        Schema::dropIfExists('communication_logs');
        Schema::dropIfExists('pending_approvals');
        Schema::dropIfExists('user_tags');
        Schema::dropIfExists('fee_structures');
    }
};
