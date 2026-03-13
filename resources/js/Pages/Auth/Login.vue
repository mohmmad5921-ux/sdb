<script setup>
import InputError from '@/Components/InputError.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';

defineProps({
    canResetPassword: { type: Boolean },
    status: { type: String },
});

const form = useForm({ email: '', password: '', remember: false, portal: 'customer' });
const submit = () => form.post(route('login'), { onFinish: () => form.reset('password') });
</script>

<template>
<Head title="تسجيل الدخول — SDB Bank" />
<div class="lg-page">
  <div class="lg-container">
    <!-- Left: Visual Panel -->
    <div class="lg-left">
      <div class="lg-left-content">
        <div class="lg-left-top">
          <Link href="/" class="lg-back-link">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none"><path d="M12.5 15L7.5 10L12.5 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
            العودة للرئيسية
          </Link>
        </div>
        <div class="lg-left-center">
          <div class="lg-brand-logo">
            <span class="lg-brand-text">SDB</span>
            <span class="sdb-flag"></span>
          </div>
          <p class="lg-brand-tagline">SYRIA DIGITAL BANK</p>
          <h2 class="lg-brand-headline">مصرفك الرقمي<br/>لعصر جديد</h2>
          <div class="lg-brand-features">
            <div class="lg-bf"><span class="lg-bf-dot"></span>حسابات متعددة العملات</div>
            <div class="lg-bf"><span class="lg-bf-dot"></span>تحويلات فورية لأكثر من 170 دولة</div>
            <div class="lg-bf"><span class="lg-bf-dot"></span>بطاقات رقمية آمنة</div>
          </div>
        </div>
        <div class="lg-left-bottom">
          <div class="lg-trust-badges">
            <span>🔒 تشفير 256-bit</span>
            <span>🇩🇰 مرخص أوروبياً</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Right: Login Form -->
    <div class="lg-right">
      <div class="lg-card">
        <div class="lg-card-header">
          <div class="lg-card-logo">
            <span class="lg-card-logo-text">SDB</span>
            <span class="sdb-flag sm"></span>
          </div>
          <h1 class="lg-title">مرحباً بك</h1>
          <p class="lg-subtitle">سجّل دخولك للوصول إلى حسابك</p>
        </div>

        <div v-if="status" class="lg-alert">{{ status }}</div>

        <form @submit.prevent="submit" class="lg-form">
          <div class="lg-field">
            <label class="lg-label" for="email">البريد الإلكتروني</label>
            <input id="email" type="email" v-model="form.email" required autofocus autocomplete="username" placeholder="you@example.com" class="lg-input" />
            <InputError :message="form.errors.email" class="lg-error" />
          </div>

          <div class="lg-field">
            <label class="lg-label" for="password">كلمة المرور</label>
            <input id="password" type="password" v-model="form.password" required autocomplete="current-password" placeholder="••••••••" class="lg-input" />
            <InputError :message="form.errors.password" class="lg-error" />
          </div>

          <div class="lg-options">
            <label class="lg-check">
              <input type="checkbox" v-model="form.remember" />
              <span>تذكرني</span>
            </label>
            <Link v-if="canResetPassword" :href="route('password.request')" class="lg-forgot">نسيت كلمة المرور؟</Link>
          </div>

          <button type="submit" class="lg-btn" :disabled="form.processing">
            <span v-if="form.processing" class="lg-spinner"></span>
            {{ form.processing ? 'جاري تسجيل الدخول...' : 'تسجيل الدخول' }}
          </button>
        </form>

        <div class="lg-divider"><span>أو</span></div>

        <div class="lg-footer">
          <span>ليس لديك حساب؟</span>
          <Link href="/preregister" class="lg-footer-link">سجّل الآن ←</Link>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Cairo:wght@400;600;700;800;900&display=swap');
*{box-sizing:border-box;margin:0;padding:0}

.lg-page{min-height:100vh;background:#ffffff;font-family:'Cairo','Inter',system-ui,sans-serif;direction:rtl}

.lg-container{display:flex;min-height:100vh}

/* ═══════════════════ Left Panel ═══════════════════ */
.lg-left{
  flex:1;
  background:#0a0a0a;
  display:flex;
  position:relative;
  overflow:hidden;
}
.lg-left::before{
  content:'';position:absolute;inset:0;
  background:
    radial-gradient(ellipse at 20% 80%, rgba(0,122,61,.15) 0%, transparent 50%),
    radial-gradient(ellipse at 80% 20%, rgba(0,122,61,.08) 0%, transparent 50%);
}
.lg-left-content{
  position:relative;z-index:1;
  display:flex;flex-direction:column;justify-content:space-between;
  padding:40px 60px;width:100%;
}

.lg-back-link{
  display:inline-flex;align-items:center;gap:6px;
  color:rgba(255,255,255,.4);font-size:13px;font-weight:600;
  text-decoration:none;transition:color .2s;direction:ltr;
}
.lg-back-link:hover{color:rgba(255,255,255,.7)}

.lg-left-center{flex:1;display:flex;flex-direction:column;justify-content:center}

.lg-brand-logo{display:flex;align-items:center;gap:4px;direction:ltr;margin-bottom:4px}
.lg-brand-text{font-family:'Inter',sans-serif;font-size:48px;font-weight:900;color:#fff;letter-spacing:-2px;line-height:1}

/* Syrian Flag */
.sdb-flag{
  display:inline-block;width:28px;height:28px;border-radius:50%;flex-shrink:0;
  background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 120 120'%3E%3CcircleF cx='60' cy='60' r='60' fill='%23007a3d'/%3E%3Cpath d='M0 40h120v40H0z' fill='%23fff'/%3E%3Cpath d='M0 80h120v40a60 60 0 01-120 0z' fill='%23000'/%3E%3Cpath d='M0 0h120v40a0 0 0 010 0H0z' fill='%23007a3d'/%3E%3Cg fill='%23ce1126'%3E%3Cpolygon points='35,55 36.5,60 41.5,60 37.5,63 39,68 35,65 31,68 32.5,63 28.5,60 33.5,60'/%3E%3Cpolygon points='60,55 61.5,60 66.5,60 62.5,63 64,68 60,65 56,68 57.5,63 53.5,60 58.5,60'/%3E%3Cpolygon points='85,55 86.5,60 91.5,60 87.5,63 89,68 85,65 81,68 82.5,63 78.5,60 83.5,60'/%3E%3C/g%3E%3C/svg%3E");
  background-size:cover;
}
.sdb-flag.sm{width:22px;height:22px}

.lg-brand-tagline{
  font-family:'Inter',sans-serif;font-size:10px;font-weight:700;color:rgba(255,255,255,.25);
  letter-spacing:4px;text-transform:uppercase;margin-bottom:32px;direction:ltr;
}

.lg-brand-headline{
  font-size:36px;font-weight:900;color:#fff;line-height:1.3;margin-bottom:40px;
}

.lg-brand-features{display:flex;flex-direction:column;gap:14px}
.lg-bf{display:flex;align-items:center;gap:12px;font-size:15px;color:rgba(255,255,255,.5);font-weight:600}
.lg-bf-dot{width:6px;height:6px;border-radius:50%;background:#007a3d;flex-shrink:0}

.lg-left-bottom{padding-top:20px}
.lg-trust-badges{display:flex;gap:24px;font-size:12px;color:rgba(255,255,255,.2);font-weight:500}

/* ═══════════════════ Right Panel (Form) ═══════════════════ */
.lg-right{
  flex:1;
  display:flex;align-items:center;justify-content:center;
  padding:40px;
  background:#fafafa;
}
.lg-card{
  width:100%;max-width:400px;
  background:#ffffff;
  border:1px solid #e5e7eb;
  border-radius:20px;
  padding:44px 36px;
  box-shadow:0 1px 3px rgba(0,0,0,.04), 0 8px 24px rgba(0,0,0,.04);
}

.lg-card-header{text-align:center;margin-bottom:32px}
.lg-card-logo{display:flex;align-items:center;justify-content:center;gap:3px;margin-bottom:16px;direction:ltr}
.lg-card-logo-text{font-family:'Inter',sans-serif;font-size:32px;font-weight:900;color:#0a0a0a;letter-spacing:-1.5px}

.lg-title{font-size:24px;font-weight:900;color:#0a0a0a;letter-spacing:-.02em}
.lg-subtitle{font-size:14px;color:#6b7280;margin-top:6px;font-weight:500}

.lg-alert{
  padding:12px 16px;background:#f0fdf4;border:1px solid #bbf7d0;
  color:#166534;font-size:13px;font-weight:600;border-radius:12px;
  margin-bottom:20px;text-align:center;
}

.lg-form{display:flex;flex-direction:column;gap:20px}
.lg-field{display:flex;flex-direction:column;gap:6px}
.lg-label{font-size:13px;font-weight:700;color:#374151}
.lg-input{
  width:100%;padding:13px 16px;
  background:#f9fafb;
  border:1.5px solid #e5e7eb;
  border-radius:12px;
  font-size:15px;color:#0a0a0a;
  outline:none;transition:all .2s;
  font-family:inherit;
}
.lg-input:focus{
  border-color:#007a3d;
  background:#fff;
  box-shadow:0 0 0 3px rgba(0,122,61,.08);
}
.lg-input::placeholder{color:#9ca3af}
.lg-error{font-size:12px;color:#dc2626;margin-top:4px}

.lg-options{display:flex;justify-content:space-between;align-items:center}
.lg-check{display:flex;align-items:center;gap:8px;font-size:13px;color:#6b7280;cursor:pointer;font-weight:500}
.lg-check input{width:16px;height:16px;accent-color:#007a3d;border-radius:4px}
.lg-forgot{font-size:13px;color:#007a3d;text-decoration:none;font-weight:700}
.lg-forgot:hover{text-decoration:underline}

.lg-btn{
  width:100%;padding:14px;
  background:#0a0a0a;color:#fff;
  border:none;border-radius:12px;
  font-size:15px;font-weight:800;
  cursor:pointer;transition:all .2s;
  font-family:inherit;
  display:flex;align-items:center;justify-content:center;gap:8px;
}
.lg-btn:hover{background:#1a1a1a;transform:translateY(-1px);box-shadow:0 4px 12px rgba(0,0,0,.15)}
.lg-btn:active{transform:translateY(0)}
.lg-btn:disabled{opacity:.5;cursor:not-allowed;transform:none}
.lg-spinner{width:18px;height:18px;border:2px solid rgba(255,255,255,.3);border-top-color:#fff;border-radius:50%;animation:spin .6s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}

.lg-divider{text-align:center;margin:24px 0;position:relative}
.lg-divider::before{content:'';position:absolute;left:0;right:0;top:50%;height:1px;background:#e5e7eb}
.lg-divider span{background:#fff;padding:0 12px;font-size:12px;color:#9ca3af;position:relative}

.lg-footer{text-align:center;font-size:14px;color:#6b7280;font-weight:500}
.lg-footer-link{color:#007a3d;font-weight:800;text-decoration:none;margin-right:6px}
.lg-footer-link:hover{text-decoration:underline}

/* ═══════════════════ Responsive ═══════════════════ */
@media(max-width:900px){
  .lg-container{flex-direction:column}
  .lg-left{display:none}
  .lg-right{min-height:100vh;padding:24px;background:#fff}
  .lg-card{padding:36px 24px;border:none;box-shadow:none;max-width:100%}
}
</style>
