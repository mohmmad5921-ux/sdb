<script setup>
import InputError from '@/Components/InputError.vue';
import { Head, useForm } from '@inertiajs/vue3';

defineProps({ status: String });

const form = useForm({ email: '', password: '', remember: false });
const submit = () => form.post(route('login'), { onFinish: () => form.reset('password') });
</script>

<template>
<Head title="Admin Login — SDB Bank" />
<div class="al-page">
  <div class="al-bg">
    <div class="al-grid"></div>
    <div class="al-glow al-glow1"></div>
    <div class="al-glow al-glow2"></div>
  </div>

  <div class="al-center">
    <div class="al-card">
      <!-- Header -->
      <div class="al-header">
        <div class="al-shield">🛡️</div>
        <div class="al-logo">SDB<span>.</span></div>
        <div class="al-badge">ADMIN PANEL</div>
      </div>

      <h1 class="al-title">تسجيل دخول الإدارة</h1>
      <p class="al-sub">لوحة التحكم المركزية — الوصول مقيّد</p>

      <div v-if="status" class="al-alert">{{ status }}</div>

      <form @submit.prevent="submit" class="al-form">
        <div class="al-field">
          <label class="al-label">البريد الإلكتروني</label>
          <div class="al-input-wrap">
            <svg class="al-icon" viewBox="0 0 20 20" fill="currentColor"><path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"/><path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"/></svg>
            <input id="email" type="email" v-model="form.email" required autofocus autocomplete="username" placeholder="admin@sdb.sy" class="al-input" />
          </div>
          <InputError :message="form.errors.email" class="al-error" />
        </div>

        <div class="al-field">
          <label class="al-label">كلمة المرور</label>
          <div class="al-input-wrap">
            <svg class="al-icon" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"/></svg>
            <input id="password" type="password" v-model="form.password" required autocomplete="current-password" placeholder="••••••••" class="al-input" />
          </div>
          <InputError :message="form.errors.password" class="al-error" />
        </div>

        <label class="al-check"><input type="checkbox" v-model="form.remember" /><span>تذكرني</span></label>

        <button type="submit" class="al-btn" :disabled="form.processing">
          <span v-if="form.processing" class="al-spinner"></span>
          {{ form.processing ? 'جاري الدخول...' : '🔐 تسجيل الدخول' }}
        </button>
      </form>

      <div class="al-footer">
        <div class="al-sec-badge">🔒 اتصال مشفّر — 256-bit SSL</div>
        <p>SDB Bank — لوحة التحكم الإدارية المركزية</p>
      </div>
    </div>
  </div>
</div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap');
*{box-sizing:border-box}
.al-page{min-height:100vh;background:#070d18;position:relative;overflow:hidden;font-family:'Inter',system-ui,sans-serif;direction:rtl}

/* Grid background */
.al-bg{position:absolute;inset:0;pointer-events:none}
.al-grid{position:absolute;inset:0;background-image:linear-gradient(rgba(255,255,255,.02) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.02) 1px,transparent 1px);background-size:60px 60px}
.al-glow{position:absolute;border-radius:50%;filter:blur(100px)}
.al-glow1{width:600px;height:600px;background:radial-gradient(circle,rgba(239,68,68,.12),transparent);top:-20%;right:-10%;animation:pulse-glow 6s ease-in-out infinite}
.al-glow2{width:400px;height:400px;background:radial-gradient(circle,rgba(37,99,235,.1),transparent);bottom:-10%;left:-5%;animation:pulse-glow 8s ease-in-out infinite 3s}
@keyframes pulse-glow{0%,100%{opacity:.4;transform:scale(1)}50%{opacity:.7;transform:scale(1.1)}}

.al-center{position:relative;z-index:1;min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.al-card{width:100%;max-width:440px;background:rgba(15,23,42,.8);border:1px solid rgba(255,255,255,.06);border-radius:28px;padding:44px 40px;backdrop-filter:blur(40px);box-shadow:0 32px 64px rgba(0,0,0,.4),inset 0 1px 0 rgba(255,255,255,.04)}

.al-header{text-align:center;margin-bottom:20px}
.al-shield{font-size:40px;margin-bottom:8px}
.al-logo{font-size:40px;font-weight:900;color:#fff;letter-spacing:-2px;display:inline-block}.al-logo span{color:#ef4444;font-size:48px;line-height:0}
.al-badge{display:inline-block;margin-top:8px;padding:4px 16px;background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.2);border-radius:8px;font-size:11px;font-weight:800;color:#ef4444;letter-spacing:2px}

.al-title{font-size:24px;font-weight:800;color:#fff;text-align:center;margin-top:16px}
.al-sub{font-size:13px;color:rgba(255,255,255,.3);text-align:center;margin-top:6px;margin-bottom:28px}
.al-alert{padding:12px;background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.2);color:#10b981;font-size:13px;font-weight:600;border-radius:12px;margin-bottom:16px;text-align:center}

.al-form{display:flex;flex-direction:column;gap:16px}
.al-field{display:flex;flex-direction:column;gap:6px}
.al-label{font-size:13px;font-weight:600;color:rgba(255,255,255,.5)}
.al-input-wrap{position:relative;display:flex;align-items:center}
.al-icon{position:absolute;right:14px;width:18px;height:18px;color:rgba(255,255,255,.2)}
.al-input{width:100%;padding:14px 42px 14px 16px;background:rgba(255,255,255,.04);border:1.5px solid rgba(255,255,255,.08);border-radius:14px;font-size:15px;color:#fff;outline:none;transition:all .2s;font-family:inherit;box-sizing:border-box}
.al-input:focus{border-color:#ef4444;background:rgba(239,68,68,.04);box-shadow:0 0 0 4px rgba(239,68,68,.06)}
.al-input::placeholder{color:rgba(255,255,255,.15)}
.al-error{font-size:12px;color:#f87171;margin-top:4px}

.al-check{display:flex;align-items:center;gap:8px;font-size:13px;color:rgba(255,255,255,.4);cursor:pointer}
.al-check input{width:16px;height:16px;accent-color:#ef4444;border-radius:4px}

.al-btn{width:100%;padding:16px;background:linear-gradient(135deg,#dc2626,#991b1b);color:#fff;border:none;border-radius:14px;font-size:15px;font-weight:800;cursor:pointer;transition:all .25s;font-family:inherit;display:flex;align-items:center;justify-content:center;gap:8px;margin-top:4px}
.al-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(239,68,68,.25)}
.al-btn:disabled{opacity:.6;cursor:not-allowed;transform:none}
.al-spinner{width:18px;height:18px;border:2px solid rgba(255,255,255,.3);border-top-color:#fff;border-radius:50%;animation:spin .6s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}

.al-footer{text-align:center;margin-top:24px;padding-top:20px;border-top:1px solid rgba(255,255,255,.04)}
.al-sec-badge{display:inline-block;padding:4px 12px;background:rgba(255,255,255,.03);border:1px solid rgba(255,255,255,.06);border-radius:8px;font-size:11px;color:rgba(255,255,255,.3);margin-bottom:8px}
.al-footer p{font-size:11px;color:rgba(255,255,255,.15);margin-top:6px}
</style>
