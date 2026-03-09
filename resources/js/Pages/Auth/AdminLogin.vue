<script setup>
import InputError from '@/Components/InputError.vue';
import { Head, useForm } from '@inertiajs/vue3';

defineProps({ canResetPassword: Boolean, status: String });

const form = useForm({ email: '', password: '', remember: false });
const submit = () => form.post(route('login'), { onFinish: () => form.reset('password') });
</script>

<template>
<Head title="Admin Login — SDB Bank" />
<div class="al-page">
  <div class="al-card">
    <div class="al-logo">SDB<span class="al-dot">.</span></div>
    <div class="al-badge">🔒 Admin Panel</div>
    <h1 class="al-title">تسجيل دخول الإدارة</h1>

    <div v-if="status" class="al-status">{{ status }}</div>

    <form @submit.prevent="submit" class="al-form">
      <div class="al-field">
        <label for="email" class="al-label">البريد الإلكتروني</label>
        <input id="email" type="email" v-model="form.email" required autofocus autocomplete="username" placeholder="admin@sdb.sy" class="al-input" />
        <InputError :message="form.errors.email" class="al-error" />
      </div>
      <div class="al-field">
        <label for="password" class="al-label">كلمة المرور</label>
        <input id="password" type="password" v-model="form.password" required autocomplete="current-password" placeholder="••••••••" class="al-input" />
        <InputError :message="form.errors.password" class="al-error" />
      </div>
      <label class="al-remember"><input type="checkbox" v-model="form.remember" class="al-checkbox" /><span>تذكرني</span></label>
      <button type="submit" class="al-btn" :disabled="form.processing">{{ form.processing ? '⏳ جاري الدخول...' : '🔐 تسجيل الدخول' }}</button>
    </form>

    <div class="al-footer">SDB Bank — لوحة التحكم الإدارية</div>
  </div>
</div>
</template>

<style scoped>
.al-page{min-height:100vh;display:flex;align-items:center;justify-content:center;background:#0f172a;font-family:'Inter',system-ui,sans-serif;direction:rtl}
.al-card{width:100%;max-width:420px;background:#fff;border-radius:24px;padding:44px 36px;box-shadow:0 25px 50px rgba(0,0,0,.15)}
.al-logo{font-size:42px;font-weight:900;color:#0f172a;letter-spacing:-2px;text-align:center}
.al-dot{color:#10b981;font-size:52px;line-height:0}
.al-badge{text-align:center;margin:10px 0 4px;font-size:12px;font-weight:700;color:#64748b;background:#f1f5f9;display:inline-block;padding:4px 14px;border-radius:8px;margin-left:auto;margin-right:auto;width:fit-content;display:block;margin-left:auto;margin-right:auto}
.al-title{font-size:22px;font-weight:800;color:#0f172a;text-align:center;margin-top:16px;margin-bottom:24px}
.al-status{padding:12px;background:#ecfdf5;color:#059669;font-size:13px;font-weight:600;border-radius:10px;margin-bottom:16px;text-align:center}
.al-form{display:flex;flex-direction:column;gap:16px}
.al-field{display:flex;flex-direction:column;gap:6px}
.al-label{font-size:13px;font-weight:700;color:#334155}
.al-input{width:100%;padding:13px 16px;border:2px solid #e2e8f0;border-radius:12px;font-size:14px;color:#0f172a;outline:none;transition:border-color .2s;box-sizing:border-box}.al-input:focus{border-color:#10b981}
.al-input::placeholder{color:#94a3b8}
.al-error{font-size:12px;color:#ef4444;margin-top:4px}
.al-remember{display:flex;align-items:center;gap:8px;font-size:13px;color:#64748b;cursor:pointer}
.al-checkbox{width:16px;height:16px;accent-color:#10b981;border-radius:4px}
.al-btn{width:100%;padding:14px;background:#0f172a;color:#fff;border:none;border-radius:12px;font-size:15px;font-weight:800;cursor:pointer;transition:all .2s;margin-top:4px}.al-btn:hover{background:#1e293b;transform:translateY(-1px)}.al-btn:disabled{opacity:.5;cursor:not-allowed;transform:none}
.al-footer{text-align:center;margin-top:24px;padding-top:20px;border-top:1px solid #f1f5f9;font-size:12px;color:#94a3b8}
</style>
