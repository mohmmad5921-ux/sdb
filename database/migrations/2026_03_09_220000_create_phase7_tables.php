<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration {
    public function up(): void
    {
        // Fraud alerts / rules
        Schema::create('fraud_rules', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->text('description')->nullable();
            $t->string('rule_type'); // amount_threshold, velocity, geo_anomaly, device_change, vpn_detected, multiple_accounts
            $t->json('conditions')->nullable();
            $t->enum('action', ['alert', 'block', 'review'])->default('alert');
            $t->enum('severity', ['low', 'medium', 'high', 'critical'])->default('medium');
            $t->boolean('active')->default(true);
            $t->integer('triggers_count')->default(0);
            $t->timestamps();
        });

        Schema::create('fraud_incidents', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->nullable()->constrained();
            $t->unsignedBigInteger('transaction_id')->nullable();
            $t->unsignedBigInteger('rule_id')->nullable();
            $t->string('type'); // suspicious_tx, unusual_login, vpn, proxy, velocity, geo
            $t->enum('severity', ['low', 'medium', 'high', 'critical'])->default('medium');
            $t->text('description');
            $t->json('metadata')->nullable();
            $t->enum('status', ['open', 'investigating', 'resolved', 'false_positive'])->default('open');
            $t->foreignId('handled_by')->nullable()->constrained('users');
            $t->timestamp('resolved_at')->nullable();
            $t->timestamps();
        });

        // AML reports
        Schema::create('aml_reports', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained();
            $t->string('type'); // large_transfer, rapid_transfers, sanctions_match, source_of_funds, pep
            $t->text('description');
            $t->decimal('amount', 15, 2)->default(0);
            $t->enum('risk_level', ['low', 'medium', 'high', 'critical'])->default('medium');
            $t->enum('status', ['pending', 'under_review', 'escalated', 'cleared', 'reported'])->default('pending');
            $t->text('admin_notes')->nullable();
            $t->foreignId('reviewed_by')->nullable()->constrained('users');
            $t->timestamp('reviewed_at')->nullable();
            $t->timestamps();
        });

        // Risk scores
        if (!Schema::hasColumn('users', 'risk_score')) {
            Schema::table('users', function (Blueprint $t) {
                $t->integer('risk_score')->default(0)->after('status');
                $t->enum('risk_level', ['low', 'medium', 'high', 'critical'])->default('low')->after('risk_score');
            });
        }

        // Verification log
        Schema::create('verification_logs', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained();
            $t->string('type'); // biometric, otp, email, phone, document, device, geo
            $t->enum('status', ['success', 'failed', 'pending'])->default('pending');
            $t->string('ip_address')->nullable();
            $t->string('device')->nullable();
            $t->string('location')->nullable();
            $t->json('metadata')->nullable();
            $t->timestamps();
        });

        // Integration status
        Schema::create('integrations', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->string('type'); // payment, kyc, aml, bank, cards, sms, email, analytics
            $t->string('provider')->nullable();
            $t->enum('status', ['active', 'inactive', 'error', 'maintenance'])->default('inactive');
            $t->json('config')->nullable();
            $t->timestamp('last_checked_at')->nullable();
            $t->text('last_error')->nullable();
            $t->timestamps();
        });

        // Scheduled reports
        Schema::create('scheduled_reports', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->string('type'); // profit, transactions, users, cards, fraud, aml, fees, support
            $t->enum('frequency', ['daily', 'weekly', 'monthly'])->default('monthly');
            $t->string('format')->default('pdf'); // pdf, csv, excel
            $t->string('email_to')->nullable();
            $t->timestamp('last_generated_at')->nullable();
            $t->boolean('active')->default(true);
            $t->timestamps();
        });

        // Seed fraud rules
        DB::table('fraud_rules')->insert([
            ['name' => 'معاملة كبيرة', 'description' => 'تنبيه عند تحويل مبلغ كبير', 'rule_type' => 'amount_threshold', 'conditions' => json_encode(['threshold' => 10000]), 'action' => 'alert', 'severity' => 'high', 'active' => true, 'triggers_count' => 0, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'معاملات متكررة', 'description' => 'أكثر من 10 معاملات في ساعة', 'rule_type' => 'velocity', 'conditions' => json_encode(['max_count' => 10, 'window_minutes' => 60]), 'action' => 'review', 'severity' => 'medium', 'active' => true, 'triggers_count' => 0, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'تغيير موقع مفاجئ', 'description' => 'تسجيل دخول من دول مختلفة بوقت قصير', 'rule_type' => 'geo_anomaly', 'conditions' => json_encode(['max_distance_km' => 1000, 'window_hours' => 2]), 'action' => 'block', 'severity' => 'critical', 'active' => true, 'triggers_count' => 0, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'كشف VPN/Proxy', 'description' => 'اكتشاف استخدام VPN أو Proxy', 'rule_type' => 'vpn_detected', 'conditions' => json_encode([]), 'action' => 'alert', 'severity' => 'medium', 'active' => true, 'triggers_count' => 0, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'تغيير جهاز مشبوه', 'description' => 'استخدام جهاز جديد مع معاملة كبيرة', 'rule_type' => 'device_change', 'conditions' => json_encode(['min_amount' => 5000]), 'action' => 'review', 'severity' => 'high', 'active' => true, 'triggers_count' => 0, 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Seed integrations
        DB::table('integrations')->insert([
            ['name' => 'Stripe Payments', 'type' => 'payment', 'provider' => 'Stripe', 'status' => 'active', 'config' => json_encode(['env' => 'live']), 'last_checked_at' => now(), 'last_error' => null, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'MoonPay KYC', 'type' => 'kyc', 'provider' => 'MoonPay', 'status' => 'active', 'config' => json_encode(['env' => 'sandbox']), 'last_checked_at' => now(), 'last_error' => null, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Mastercard Issuing', 'type' => 'cards', 'provider' => 'Mastercard', 'status' => 'maintenance', 'config' => null, 'last_checked_at' => now(), 'last_error' => null, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'SMTP Email', 'type' => 'email', 'provider' => 'SMTP', 'status' => 'active', 'config' => null, 'last_checked_at' => now(), 'last_error' => null, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Firebase Push', 'type' => 'sms', 'provider' => 'Firebase', 'status' => 'active', 'config' => null, 'last_checked_at' => now(), 'last_error' => null, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'CoinGecko API', 'type' => 'analytics', 'provider' => 'CoinGecko', 'status' => 'active', 'config' => null, 'last_checked_at' => now(), 'last_error' => null, 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('scheduled_reports');
        Schema::dropIfExists('integrations');
        Schema::dropIfExists('verification_logs');
        Schema::dropIfExists('aml_reports');
        Schema::dropIfExists('fraud_incidents');
        Schema::dropIfExists('fraud_rules');
        if (Schema::hasColumn('users', 'risk_score')) {
            Schema::table('users', function (Blueprint $t) {
                $t->dropColumn(['risk_score', 'risk_level']); });
        }
    }
};
