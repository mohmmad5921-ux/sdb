<script setup>
import InputError from '@/Components/InputError.vue';
import { Head, useForm } from '@inertiajs/vue3';

defineProps({ status: String });

const form = useForm({ email: '', password: '', remember: false, portal: 'admin' });
const submit = () => form.post(route('login'), { onFinish: () => form.reset('password') });
</script>

<template>
<Head title="Admin — SDB Bank" />
<div class="al-page">
  <!-- Background -->
  <div class="al-bg">
    <div class="al-circle al-c1"></div>
    <div class="al-circle al-c2"></div>
    <div class="al-circle al-c3"></div>
  </div>

  <div class="al-center">
    <!-- Logo -->
    <div class="al-logo-area">
      <div class="al-mark">SDB<span class="sdb-flag"></span></div>
    </div>

    <div class="al-card">
      <div class="al-lock">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
      </div>
      <h1 class="al-title">لوحة التحكم</h1>
      <p class="al-sub">الوصول مقيّد للمسؤولين فقط</p>

      <div v-if="status" class="al-alert">{{ status }}</div>

      <form @submit.prevent="submit" class="al-form">
        <div class="al-field">
          <label class="al-label">البريد الإلكتروني</label>
          <input id="email" type="email" v-model="form.email" required autofocus autocomplete="username" placeholder="admin@sdb-bank.com" class="al-input" />
          <InputError :message="form.errors.email" class="al-error" />
        </div>

        <div class="al-field">
          <label class="al-label">كلمة المرور</label>
          <input id="password" type="password" v-model="form.password" required autocomplete="current-password" placeholder="••••••••" class="al-input" />
          <InputError :message="form.errors.password" class="al-error" />
        </div>

        <label class="al-check"><input type="checkbox" v-model="form.remember" /><span>تذكرني</span></label>

        <button type="submit" class="al-btn" :disabled="form.processing">
          <span v-if="form.processing" class="al-spinner"></span>
          {{ form.processing ? 'جاري الدخول...' : 'تسجيل الدخول' }}
        </button>
      </form>

      <div class="al-footer">
        <div class="al-sec">🔒 اتصال مشفّر — 256-bit SSL</div>
      </div>
    </div>

    <p class="al-copy">© 2026 SDB Bank — Syria Digital Bank</p>
  </div>
</div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap');
*{box-sizing:border-box;margin:0;padding:0}

.al-page{min-height:100vh;background:#f0f5eb;position:relative;overflow:hidden;font-family:'Inter',system-ui,sans-serif;direction:rtl}

/* Decorative circles */
.al-bg{position:absolute;inset:0;pointer-events:none;overflow:hidden}
.al-circle{position:absolute;border-radius:50%;opacity:.15}
.al-c1{width:500px;height:500px;background:radial-gradient(circle,#9FE870,transparent 70%);top:-15%;right:-10%}
.al-c2{width:350px;height:350px;background:radial-gradient(circle,#2D6A00,transparent 70%);bottom:-10%;left:-5%}
.al-c3{width:200px;height:200px;background:radial-gradient(circle,#9FE870,transparent 70%);top:50%;left:30%}

.al-center{position:relative;z-index:1;min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:24px}

/* Logo */
.al-logo-area{margin-bottom:32px;text-align:center}
.al-mark{font-size:36px;font-weight:900;color:#163300;letter-spacing:-2px;display:inline-flex;align-items:center;gap:4px}

/* Card */
.al-card{width:100%;max-width:400px;background:#fff;border:1px solid rgba(22,51,0,.06);border-radius:24px;padding:40px 36px;box-shadow:0 16px 48px rgba(0,0,0,.06)}

.al-lock{width:48px;height:48px;display:flex;align-items:center;justify-content:center;background:linear-gradient(135deg,#2D6A00,#9FE870);color:#fff;border-radius:14px;margin:0 auto 16px}
.al-title{font-size:22px;font-weight:900;color:#163300;text-align:center;letter-spacing:-.03em}
.al-sub{font-size:13px;color:rgba(22,51,0,.35);text-align:center;margin-top:4px;margin-bottom:28px}

.al-alert{padding:12px;background:rgba(45,106,0,.06);border:1px solid rgba(45,106,0,.1);color:#2D6A00;font-size:13px;font-weight:600;border-radius:12px;margin-bottom:16px;text-align:center}

.al-form{display:flex;flex-direction:column;gap:16px}
.al-field{display:flex;flex-direction:column;gap:5px}
.al-label{font-size:12px;font-weight:700;color:rgba(22,51,0,.5);letter-spacing:.3px}
.al-input{width:100%;padding:14px 16px;background:#f8faf6;border:1.5px solid rgba(22,51,0,.08);border-radius:12px;font-size:14px;color:#163300;outline:none;transition:all .2s;font-family:inherit}
.al-input:focus{border-color:#9FE870;background:#fff;box-shadow:0 0 0 3px rgba(159,232,112,.12)}
.al-input::placeholder{color:rgba(22,51,0,.2)}
.al-error{font-size:12px;color:#ef4444;margin-top:2px;font-weight:600}

.al-check{display:flex;align-items:center;gap:8px;font-size:13px;color:rgba(22,51,0,.4);cursor:pointer}
.al-check input{width:16px;height:16px;accent-color:#2D6A00;border-radius:4px}

.al-btn{width:100%;padding:15px;background:linear-gradient(135deg,#2D6A00,#3d8a00);color:#fff;border:none;border-radius:14px;font-size:15px;font-weight:800;cursor:pointer;transition:all .2s;font-family:inherit;display:flex;align-items:center;justify-content:center;gap:8px;margin-top:4px}
.al-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(45,106,0,.2)}
.al-btn:disabled{opacity:.5;cursor:not-allowed;transform:none}

.al-spinner{width:18px;height:18px;border:2px solid rgba(255,255,255,.3);border-top-color:#fff;border-radius:50%;animation:spin .6s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}

.al-footer{text-align:center;margin-top:20px;padding-top:16px;border-top:1px solid rgba(22,51,0,.04)}
.al-sec{display:inline-block;padding:4px 12px;background:rgba(45,106,0,.04);border:1px solid rgba(22,51,0,.06);border-radius:8px;font-size:11px;color:rgba(22,51,0,.3);font-weight:600}

.al-copy{margin-top:24px;font-size:11px;color:rgba(22,51,0,.2);text-align:center}

@media(max-width:480px){
  .al-card{padding:28px 20px;border-radius:20px}
  .al-mark{font-size:28px}
}
</style>
