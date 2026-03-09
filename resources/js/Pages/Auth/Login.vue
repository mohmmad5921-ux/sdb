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
<Head title="Sign in — SDB Bank" />
<div class="lg-page">
  <!-- Animated background -->
  <div class="lg-bg">
    <div class="lg-orb lg-orb-1"></div>
    <div class="lg-orb lg-orb-2"></div>
    <div class="lg-orb lg-orb-3"></div>
  </div>

  <div class="lg-container">
    <!-- Left side: branding -->
    <div class="lg-left">
      <div class="lg-brand-wrap">
        <Link href="/" class="lg-logo">SDB<span class="sdb-flag"></span></Link>
        <p class="lg-slogan">Banking for a new era</p>
      </div>
      <div class="lg-features">
        <div class="lg-feat" v-for="f in [
          {e:'💳',t:'Mastercard Cards',d:'Virtual & physical cards with instant issuance'},
          {e:'💱',t:'Multi-Currency',d:'Hold, exchange & send 30+ currencies'},
          {e:'🪙',t:'Crypto Trading',d:'Buy & sell crypto at competitive rates'},
          {e:'⚡',t:'Instant Transfers',d:'Send money to 150+ countries instantly'}
        ]" :key="f.t">
          <span class="lg-feat-emoji">{{ f.e }}</span>
          <div>
            <div class="lg-feat-t">{{ f.t }}</div>
            <div class="lg-feat-d">{{ f.d }}</div>
          </div>
        </div>
      </div>
      <div class="lg-trust">
        <span>🔒 256-bit encryption</span>
        <span>🇪🇺 EU regulated</span>
        <span>📱 Mobile & Web</span>
      </div>
    </div>

    <!-- Right side: login card -->
    <div class="lg-right">
      <div class="lg-card">
        <div class="lg-card-logo">SDB<span class="sdb-flag"></span></div>
        <h1 class="lg-title">Welcome back</h1>
        <p class="lg-subtitle">Sign in to your account</p>

        <div v-if="status" class="lg-alert">{{ status }}</div>

        <form @submit.prevent="submit" class="lg-form">
          <div class="lg-field">
            <label class="lg-label">Email address</label>
            <div class="lg-input-wrap">
              <svg class="lg-icon" viewBox="0 0 20 20" fill="currentColor"><path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"/><path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"/></svg>
              <input id="email" type="email" v-model="form.email" required autofocus autocomplete="username" placeholder="you@example.com" class="lg-input" />
            </div>
            <InputError :message="form.errors.email" class="lg-error" />
          </div>

          <div class="lg-field">
            <label class="lg-label">Password</label>
            <div class="lg-input-wrap">
              <svg class="lg-icon" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"/></svg>
              <input id="password" type="password" v-model="form.password" required autocomplete="current-password" placeholder="••••••••" class="lg-input" />
            </div>
            <InputError :message="form.errors.password" class="lg-error" />
          </div>

          <div class="lg-options">
            <label class="lg-check">
              <input type="checkbox" v-model="form.remember" />
              <span>Remember me</span>
            </label>
            <Link v-if="canResetPassword" :href="route('password.request')" class="lg-forgot">Forgot password?</Link>
          </div>

          <button type="submit" class="lg-btn" :disabled="form.processing">
            <span v-if="form.processing" class="lg-spinner"></span>
            {{ form.processing ? 'Signing in...' : 'Sign in' }}
          </button>
        </form>

        <div class="lg-divider"><span>or</span></div>

        <div class="lg-footer">
          <span>Don't have an account?</span>
          <Link href="/preregister" class="lg-footer-link">Get early access →</Link>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap');
*{box-sizing:border-box}
.lg-page{min-height:100vh;background:#050d1a;position:relative;overflow:hidden;font-family:'Inter',system-ui,sans-serif}

/* Animated orbs */
.lg-bg{position:absolute;inset:0;overflow:hidden;pointer-events:none}
.lg-orb{position:absolute;border-radius:50%;filter:blur(80px);opacity:.4;animation:float 12s ease-in-out infinite}
.lg-orb-1{width:500px;height:500px;background:radial-gradient(circle,#10b981,transparent);top:-10%;right:-5%;animation-delay:0s}
.lg-orb-2{width:400px;height:400px;background:radial-gradient(circle,#2563eb,transparent);bottom:-15%;left:-10%;animation-delay:-4s}
.lg-orb-3{width:300px;height:300px;background:radial-gradient(circle,#8b5cf6,transparent);top:40%;left:30%;animation-delay:-8s;opacity:.2}
@keyframes float{0%,100%{transform:translate(0,0) scale(1)}33%{transform:translate(20px,-30px) scale(1.05)}66%{transform:translate(-15px,20px) scale(.95)}}

.lg-container{position:relative;z-index:1;display:flex;min-height:100vh}

/* Left */
.lg-left{flex:1;display:flex;flex-direction:column;justify-content:center;padding:60px 80px;color:#fff}
.lg-brand-wrap{margin-bottom:48px}
.lg-logo{font-size:56px;font-weight:900;color:#fff;text-decoration:none;letter-spacing:-3px;display:block;align-items:baseline;display:inline-flex}
.lg-slogan{font-size:16px;color:rgba(255,255,255,.3);margin-top:8px;font-weight:400;letter-spacing:.5px}
.lg-features{display:flex;flex-direction:column;gap:16px}
.lg-feat{display:flex;align-items:center;gap:16px;padding:18px 22px;border-radius:16px;border:1px solid rgba(255,255,255,.06);background:rgba(255,255,255,.02);backdrop-filter:blur(10px);transition:all .3s}
.lg-feat:hover{border-color:rgba(16,185,129,.2);background:rgba(16,185,129,.04);transform:translateX(4px)}
.lg-feat-emoji{font-size:28px;flex-shrink:0}
.lg-feat-t{font-size:14px;font-weight:700;color:#fff}
.lg-feat-d{font-size:12px;color:rgba(255,255,255,.3);margin-top:3px}
.lg-trust{display:flex;gap:24px;margin-top:40px;font-size:12px;color:rgba(255,255,255,.2);font-weight:500}

/* Right */
.lg-right{flex:1;display:flex;align-items:center;justify-content:center;padding:40px}
.lg-card{width:100%;max-width:420px;background:rgba(255,255,255,.03);border:1px solid rgba(255,255,255,.08);border-radius:28px;padding:44px 40px;backdrop-filter:blur(40px);box-shadow:0 32px 64px rgba(0,0,0,.3)}
.lg-card-logo{font-size:36px;font-weight:900;color:#fff;text-align:center;letter-spacing:-2px;margin-bottom:8px;display:inline-flex;align-items:baseline;justify-content:center;width:100%}
.lg-title{font-size:26px;font-weight:800;color:#fff;text-align:center;letter-spacing:-.03em}
.lg-subtitle{font-size:14px;color:rgba(255,255,255,.35);text-align:center;margin-top:6px;margin-bottom:28px}
.lg-alert{padding:12px 16px;background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.2);color:#10b981;font-size:13px;font-weight:600;border-radius:12px;margin-bottom:20px;text-align:center}

.lg-form{display:flex;flex-direction:column;gap:18px}
.lg-field{display:flex;flex-direction:column;gap:6px}
.lg-label{font-size:13px;font-weight:600;color:rgba(255,255,255,.5)}
.lg-input-wrap{position:relative;display:flex;align-items:center}
.lg-icon{position:absolute;left:14px;width:18px;height:18px;color:rgba(255,255,255,.2)}
.lg-input{width:100%;padding:14px 16px 14px 42px;background:rgba(255,255,255,.05);border:1.5px solid rgba(255,255,255,.08);border-radius:14px;font-size:15px;color:#fff;outline:none;transition:all .2s;font-family:inherit;box-sizing:border-box}
.lg-input:focus{border-color:#10b981;background:rgba(16,185,129,.04);box-shadow:0 0 0 4px rgba(16,185,129,.08)}
.lg-input::placeholder{color:rgba(255,255,255,.15)}
.lg-error{font-size:12px;color:#f87171;margin-top:4px}

.lg-options{display:flex;justify-content:space-between;align-items:center}
.lg-check{display:flex;align-items:center;gap:8px;font-size:13px;color:rgba(255,255,255,.4);cursor:pointer}
.lg-check input{width:16px;height:16px;accent-color:#10b981;border-radius:4px}
.lg-forgot{font-size:13px;color:#10b981;text-decoration:none;font-weight:600}.lg-forgot:hover{text-decoration:underline}

.lg-btn{width:100%;padding:16px;background:linear-gradient(135deg,#10b981,#059669);color:#fff;border:none;border-radius:14px;font-size:15px;font-weight:800;cursor:pointer;transition:all .25s;font-family:inherit;display:flex;align-items:center;justify-content:center;gap:8px;margin-top:4px}
.lg-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(16,185,129,.3)}
.lg-btn:disabled{opacity:.6;cursor:not-allowed;transform:none}
.lg-spinner{width:18px;height:18px;border:2px solid rgba(255,255,255,.3);border-top-color:#fff;border-radius:50%;animation:spin .6s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}

.lg-divider{text-align:center;margin:20px 0;position:relative}
.lg-divider::before{content:'';position:absolute;left:0;right:0;top:50%;height:1px;background:rgba(255,255,255,.06)}
.lg-divider span{background:transparent;padding:0 12px;font-size:12px;color:rgba(255,255,255,.2);position:relative}

.lg-footer{text-align:center;font-size:13px;color:rgba(255,255,255,.3)}
.lg-footer-link{color:#10b981;font-weight:700;text-decoration:none;margin-left:6px}.lg-footer-link:hover{text-decoration:underline}

@media(max-width:900px){
  .lg-container{flex-direction:column}
  .lg-left{display:none}
  .lg-right{min-height:100vh;padding:24px}
  .lg-card{padding:36px 28px}
}
</style>
