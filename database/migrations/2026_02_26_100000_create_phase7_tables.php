<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        // Support Tickets
        Schema::create('support_tickets', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('subject');
            $table->string('category')->default('general'); // general, account, card, transaction, technical
            $table->enum('priority', ['low', 'medium', 'high'])->default('medium');
            $table->enum('status', ['open', 'in_progress', 'waiting_customer', 'resolved', 'closed'])->default('open');
            $table->string('ticket_number')->unique();
            $table->foreignId('assigned_to')->nullable()->constrained('users')->onDelete('set null');
            $table->timestamp('resolved_at')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'status']);
            $table->index('ticket_number');
        });

        // Support Messages
        Schema::create('support_messages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('ticket_id')->constrained('support_tickets')->onDelete('cascade');
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->text('message');
            $table->boolean('is_admin')->default(false);
            $table->string('attachment_path')->nullable();
            $table->string('attachment_name')->nullable();
            $table->timestamps();

            $table->index('ticket_id');
        });

        // Referrals
        Schema::create('referrals', function (Blueprint $table) {
            $table->id();
            $table->foreignId('referrer_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('referred_id')->nullable()->constrained('users')->onDelete('set null');
            $table->string('referral_code')->unique();
            $table->enum('status', ['pending', 'completed', 'rewarded'])->default('pending');
            $table->decimal('reward_amount', 18, 4)->default(0);
            $table->string('reward_currency', 10)->default('EUR');
            $table->timestamp('completed_at')->nullable();
            $table->timestamps();

            $table->index('referrer_id');
            $table->index('referral_code');
        });

        // Login History
        Schema::create('login_history', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('ip_address')->nullable();
            $table->string('user_agent')->nullable();
            $table->string('device_type')->nullable(); // mobile, desktop, tablet
            $table->string('browser')->nullable();
            $table->string('os')->nullable();
            $table->string('country')->nullable();
            $table->string('city')->nullable();
            $table->boolean('is_successful')->default(true);
            $table->timestamp('created_at')->useCurrent();

            $table->index(['user_id', 'created_at']);
        });

        // Add ATM enabled to cards (if column doesn't exist)
        if (!Schema::hasColumn('cards', 'atm_enabled')) {
            Schema::table('cards', function (Blueprint $table) {
                $table->boolean('atm_enabled')->default(true)->after('contactless_enabled');
            });
        }

        // Add referral_code to users
        if (!Schema::hasColumn('users', 'referral_code')) {
            Schema::table('users', function (Blueprint $table) {
                $table->string('referral_code', 10)->nullable()->unique()->after('preferred_language');
                $table->foreignId('referred_by')->nullable()->after('referral_code');
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('login_history');
        Schema::dropIfExists('referrals');
        Schema::dropIfExists('support_messages');
        Schema::dropIfExists('support_tickets');

        if (Schema::hasColumn('cards', 'atm_enabled')) {
            Schema::table('cards', function (Blueprint $table) {
                $table->dropColumn('atm_enabled');
            });
        }
        if (Schema::hasColumn('users', 'referral_code')) {
            Schema::table('users', function (Blueprint $table) {
                $table->dropColumn(['referral_code', 'referred_by']);
            });
        }
    }
};