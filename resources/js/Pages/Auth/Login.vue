<script setup>
import InputError from '@/Components/InputError.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';

defineProps({
    canResetPassword: { type: Boolean },
    status: { type: String },
});

const form = useForm({
    email: '',
    password: '',
    remember: false,
});

const submit = () => {
    form.post(route('login'), {
        onFinish: () => form.reset('password'),
    });
};
</script>

<template>
<Head title="Log in — SDB Bank" />
<div class="login-page">
  <div class="login-left">
    <div class="login-brand">
      <Link href="/" class="login-logo">SDB<span class="login-dot">.</span></Link>
      <p class="login-tagline">Banking for a new era</p>
    </div>
    <div class="login-features">
      <div class="login-feat" v-for="f in [
        {icon:'💳',t:'Mastercard Cards',d:'Virtual & metal cards'},
        {icon:'💱',t:'30+ Currencies',d:'Exchange at real rates'},
        {icon:'🪙',t:'Crypto Wallets',d:'Buy, sell, send & receive'},
        {icon:'⚡',t:'Instant Transfers',d:'150+ countries'}
      ]" :key="f.t">
        <span class="login-feat-icon">{{ f.icon }}</span>
        <div>
          <div class="login-feat-title">{{ f.t }}</div>
          <div class="login-feat-desc">{{ f.d }}</div>
        </div>
      </div>
    </div>
  </div>

  <div class="login-right">
    <div class="login-card">
      <h1 class="login-heading">Welcome back</h1>
      <p class="login-sub">Sign in to your SDB account</p>

      <div v-if="status" class="login-status">{{ status }}</div>

      <form @submit.prevent="submit" class="login-form">
        <div class="login-field">
          <label for="email" class="login-label">Email</label>
          <input
            id="email"
            type="email"
            class="login-input"
            v-model="form.email"
            required
            autofocus
            autocomplete="username"
            placeholder="you@example.com"
          />
          <InputError class="login-error" :message="form.errors.email" />
        </div>

        <div class="login-field">
          <label for="password" class="login-label">Password</label>
          <input
            id="password"
            type="password"
            class="login-input"
            v-model="form.password"
            required
            autocomplete="current-password"
            placeholder="••••••••"
          />
          <InputError class="login-error" :message="form.errors.password" />
        </div>

        <div class="login-row">
          <label class="login-remember">
            <input type="checkbox" v-model="form.remember" class="login-checkbox" />
            <span>Remember me</span>
          </label>
          <Link v-if="canResetPassword" :href="route('password.request')" class="login-forgot">
            Forgot password?
          </Link>
        </div>

        <button type="submit" class="login-btn" :disabled="form.processing" :class="{'login-btn-loading': form.processing}">
          {{ form.processing ? 'Signing in...' : 'Sign in' }}
        </button>
      </form>

      <div class="login-footer">
        <span class="login-footer-text">Don't have an account?</span>
        <Link href="/preregister" class="login-footer-link">Get early access</Link>
      </div>
    </div>
  </div>
</div>
</template>

<style scoped>
.login-page{display:flex;min-height:100vh;font-family:'Inter',system-ui,sans-serif}

/* Left Panel */
.login-left{flex:1;background:#0a0a0a;display:flex;flex-direction:column;justify-content:center;padding:60px;position:relative;overflow:hidden}
.login-left::after{content:'';position:absolute;top:-20%;right:-30%;width:80%;height:140%;background:radial-gradient(circle,rgba(37,99,235,.08) 0%,transparent 70%);pointer-events:none}
.login-brand{margin-bottom:56px;position:relative;z-index:1}
.login-logo{font-size:48px;font-weight:900;color:#fff;text-decoration:none;letter-spacing:-2px;display:block}
.login-dot{color:#2563EB;font-size:56px;line-height:0}
.login-tagline{font-size:15px;color:rgba(255,255,255,.25);margin-top:8px;font-weight:400}
.login-features{display:flex;flex-direction:column;gap:20px;position:relative;z-index:1}
.login-feat{display:flex;align-items:center;gap:16px;padding:16px 20px;border-radius:14px;border:1px solid rgba(255,255,255,.05);transition:border-color .3s}.login-feat:hover{border-color:rgba(37,99,235,.2)}
.login-feat-icon{font-size:28px;flex-shrink:0}
.login-feat-title{font-size:14px;font-weight:700;color:#fff}
.login-feat-desc{font-size:12px;color:rgba(255,255,255,.25);margin-top:2px}

/* Right Panel */
.login-right{flex:1;display:flex;align-items:center;justify-content:center;padding:40px;background:#fff}
.login-card{width:100%;max-width:400px}
.login-heading{font-size:28px;font-weight:900;color:#0a0a0a;letter-spacing:-.03em}
.login-sub{font-size:14px;color:rgba(10,10,10,.35);margin-top:6px;margin-bottom:32px}
.login-status{padding:12px 16px;background:rgba(16,185,129,.08);color:#10B981;font-size:13px;font-weight:600;border-radius:10px;margin-bottom:20px}

.login-form{display:flex;flex-direction:column;gap:20px}
.login-field{display:flex;flex-direction:column;gap:6px}
.login-label{font-size:13px;font-weight:700;color:#0a0a0a}
.login-input{width:100%;padding:14px 16px;border:2px solid rgba(10,10,10,.08);border-radius:12px;font-size:15px;color:#0a0a0a;background:#fff;transition:border-color .2s;outline:none;font-family:inherit;box-sizing:border-box}
.login-input:focus{border-color:#2563EB}
.login-input::placeholder{color:rgba(10,10,10,.18)}
.login-error{font-size:12px;color:#EF4444;margin-top:4px}

.login-row{display:flex;justify-content:space-between;align-items:center}
.login-remember{display:flex;align-items:center;gap:8px;font-size:13px;color:rgba(10,10,10,.5);cursor:pointer}
.login-checkbox{width:16px;height:16px;border-radius:4px;accent-color:#2563EB}
.login-forgot{font-size:13px;color:#2563EB;text-decoration:none;font-weight:600}.login-forgot:hover{text-decoration:underline}

.login-btn{width:100%;padding:16px;background:#0a0a0a;color:#fff;border:none;border-radius:12px;font-size:15px;font-weight:800;cursor:pointer;transition:all .2s;font-family:inherit;margin-top:4px}
.login-btn:hover{background:#222;transform:translateY(-1px)}
.login-btn:disabled{opacity:.5;cursor:not-allowed;transform:none}
.login-btn-loading{background:#333}

.login-footer{text-align:center;margin-top:28px;padding-top:24px;border-top:1px solid rgba(10,10,10,.06)}
.login-footer-text{font-size:13px;color:rgba(10,10,10,.3)}
.login-footer-link{font-size:13px;color:#2563EB;font-weight:700;text-decoration:none;margin-left:6px}.login-footer-link:hover{text-decoration:underline}

@media(max-width:768px){
  .login-page{flex-direction:column}
  .login-left{display:none}
  .login-right{padding:32px 24px;min-height:100vh}
}
</style>
