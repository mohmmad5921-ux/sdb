<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        // Email Templates
        Schema::create('email_templates', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->string('slug')->unique();
            $t->string('subject_en')->nullable();
            $t->string('subject_ar')->nullable();
            $t->text('body_en')->nullable();
            $t->text('body_ar')->nullable();
            $t->enum('type', ['welcome', 'alert', 'promotion', 'notification', 'custom'])->default('custom');
            $t->boolean('active')->default(true);
            $t->timestamps();
        });

        // Scheduled Tasks
        Schema::create('admin_tasks', function (Blueprint $t) {
            $t->id();
            $t->string('title');
            $t->text('description')->nullable();
            $t->foreignId('assigned_to')->nullable()->constrained('users');
            $t->foreignId('created_by')->constrained('users');
            $t->enum('priority', ['low', 'medium', 'high', 'urgent'])->default('medium');
            $t->enum('status', ['pending', 'in_progress', 'completed', 'cancelled'])->default('pending');
            $t->string('category')->nullable();
            $t->foreignId('related_user_id')->nullable();
            $t->timestamp('due_date')->nullable();
            $t->timestamp('completed_at')->nullable();
            $t->timestamps();
        });

        // Customer Tags
        if (!Schema::hasTable('customer_tags')) {
            Schema::create('customer_tags', function (Blueprint $t) {
                $t->id();
                $t->string('name');
                $t->string('color')->default('#2563eb');
                $t->text('description')->nullable();
                $t->timestamps();
            });
        }

        if (!Schema::hasTable('customer_tag_user')) {
            Schema::create('customer_tag_user', function (Blueprint $t) {
                $t->id();
                $t->foreignId('user_id')->constrained()->onDelete('cascade');
                $t->unsignedBigInteger('tag_id');
                $t->timestamps();
            });
        }

        // Special Requests
        Schema::create('special_requests', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained();
            $t->string('type'); // limit_raise, close_account, name_change, currency_add
            $t->text('description');
            $t->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $t->text('admin_notes')->nullable();
            $t->foreignId('handled_by')->nullable()->constrained('users');
            $t->timestamp('handled_at')->nullable();
            $t->timestamps();
        });

        // Referrals
        Schema::create('referrals', function (Blueprint $t) {
            $t->id();
            $t->foreignId('referrer_id')->constrained('users');
            $t->foreignId('referred_id')->constrained('users');
            $t->string('code');
            $t->enum('status', ['pending', 'completed', 'rewarded'])->default('pending');
            $t->decimal('reward_amount', 10, 2)->default(0);
            $t->timestamps();
        });

        // Email Campaigns
        Schema::create('email_campaigns', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->string('subject');
            $t->text('body');
            $t->string('target_segment')->default('all'); // all, vip, new, dormant, tag:x
            $t->integer('recipients_count')->default(0);
            $t->integer('sent_count')->default(0);
            $t->enum('status', ['draft', 'scheduled', 'sending', 'sent'])->default('draft');
            $t->timestamp('scheduled_at')->nullable();
            $t->timestamp('sent_at')->nullable();
            $t->foreignId('created_by')->constrained('users');
            $t->timestamps();
        });

        // IP Whitelist
        Schema::create('admin_ip_whitelist', function (Blueprint $t) {
            $t->id();
            $t->string('ip_address');
            $t->string('label')->nullable();
            $t->foreignId('added_by')->constrained('users');
            $t->boolean('active')->default(true);
            $t->timestamps();
        });

        // Seed email templates
        DB::table('email_templates')->insert([
            ['name' => 'ترحيب بعميل جديد', 'slug' => 'welcome', 'subject_en' => 'Welcome to SDB Bank!', 'subject_ar' => 'أهلاً بك في بنك SDB!', 'body_en' => 'Dear {name}, Welcome to SDB Bank. Your account is ready.', 'body_ar' => 'عزيزي {name}، أهلاً بك في بنك SDB. حسابك جاهز.', 'type' => 'welcome', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'تنبيه أمني', 'slug' => 'security-alert', 'subject_en' => 'Security Alert', 'subject_ar' => 'تنبيه أمني', 'body_en' => 'We detected unusual activity on your account.', 'body_ar' => 'مراقبنا نشاطاً غير اعتيادياً على حسابك.', 'type' => 'alert', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'عرض ترويجي', 'slug' => 'promo', 'subject_en' => 'Special Offer!', 'subject_ar' => 'عرض خاص!', 'body_en' => 'Enjoy exclusive benefits with SDB Bank.', 'body_ar' => 'استمتع بمزايا حصرية مع بنك SDB.', 'type' => 'promotion', 'active' => true, 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Seed customer tags
        DB::table('customer_tags')->insert([
            ['name' => 'VIP', 'color' => '#8b5cf6', 'description' => 'عملاء مهمين', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Corporate', 'color' => '#0ea5e9', 'description' => 'حسابات شركات', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'New', 'color' => '#10b981', 'description' => 'عملاء جدد', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'At-Risk', 'color' => '#ef4444', 'description' => 'عملاء معرضين للمغادرة', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Premium', 'color' => '#f59e0b', 'description' => 'عملاء بريميوم', 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('admin_ip_whitelist');
        Schema::dropIfExists('email_campaigns');
        Schema::dropIfExists('referrals');
        Schema::dropIfExists('special_requests');
        Schema::dropIfExists('customer_tag_user');
        Schema::dropIfExists('customer_tags');
        Schema::dropIfExists('admin_tasks');
        Schema::dropIfExists('email_templates');
    }
};
