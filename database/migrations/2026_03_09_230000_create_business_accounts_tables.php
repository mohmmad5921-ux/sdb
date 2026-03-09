<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('business_accounts', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->onDelete('cascade'); // owner
            $t->foreignId('account_id')->nullable()->constrained()->onDelete('set null'); // linked bank account
            $t->string('business_name');
            $t->string('business_name_ar')->nullable();
            $t->string('commercial_register')->nullable(); // سجل تجاري
            $t->string('tax_number')->nullable();
            $t->string('category'); // ecommerce, retail, services, food, etc.
            $t->string('size'); // small, medium, large, enterprise
            $t->string('owner_name');
            $t->string('owner_phone')->nullable();
            $t->string('email');
            $t->string('phone')->nullable();
            $t->text('address')->nullable();
            $t->string('city')->nullable();
            $t->string('country')->default('Syria');
            $t->string('website')->nullable();
            $t->string('status')->default('pending'); // pending, active, suspended, rejected
            $t->decimal('transfer_limit_daily', 18, 2)->default(50000);
            $t->decimal('transfer_limit_monthly', 18, 2)->default(500000);
            $t->decimal('fee_percentage', 5, 2)->default(1.5);
            $t->decimal('fee_fixed', 10, 2)->default(0);
            $t->text('notes')->nullable();
            $t->string('logo_url')->nullable();
            $t->timestamp('activated_at')->nullable();
            $t->timestamp('suspended_at')->nullable();
            $t->string('suspension_reason')->nullable();
            $t->timestamps();
        });

        Schema::create('business_employees', function (Blueprint $t) {
            $t->id();
            $t->foreignId('business_account_id')->constrained()->onDelete('cascade');
            $t->foreignId('user_id')->constrained()->onDelete('cascade');
            $t->string('role')->default('employee'); // owner, admin, manager, accountant, employee
            $t->string('position')->nullable();
            $t->json('permissions')->nullable(); // view_balance, make_transfers, view_reports, manage_invoices
            $t->string('status')->default('active'); // active, inactive
            $t->timestamps();
        });

        Schema::create('business_invoices', function (Blueprint $t) {
            $t->id();
            $t->foreignId('business_account_id')->constrained()->onDelete('cascade');
            $t->string('invoice_number')->unique();
            $t->string('customer_name');
            $t->string('customer_email')->nullable();
            $t->decimal('amount', 18, 2);
            $t->decimal('tax_amount', 18, 2)->default(0);
            $t->decimal('total_amount', 18, 2);
            $t->string('currency')->default('SYP');
            $t->string('status')->default('draft'); // draft, sent, paid, cancelled, overdue
            $t->text('description')->nullable();
            $t->date('due_date')->nullable();
            $t->timestamp('paid_at')->nullable();
            $t->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('business_invoices');
        Schema::dropIfExists('business_employees');
        Schema::dropIfExists('business_accounts');
    }
};
