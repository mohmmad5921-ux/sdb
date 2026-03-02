<script setup>
import { Head, useForm } from '@inertiajs/vue3';

const form = useForm({
  full_name: '',
  email: '',
  phone: '',
  country: '',
});

const submit = () => form.post('/preregister');
</script>

<template>
<Head title="Early Access — SDB Bank">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
</Head>

<div class="pr-page">
  <div class="pr-wrap">
    <!-- Left -->
    <div class="pr-left">
      <a href="/" class="pr-mark">SDB<span class="pr-dot">.</span></a>
      <h1 class="pr-h1">Get early<br>access</h1>
      <p class="pr-sub">Join the waitlist and be among the first to experience the future of digital banking.</p>
      <div class="pr-features">
        <div v-for="f in ['💳 Instant Mastercard','💱 30+ Currencies','🪙 Crypto Wallets','⚡ 150+ Countries','🛡️ Bank-grade Security']" :key="f" class="pr-feat">{{ f }}</div>
      </div>
    </div>

    <!-- Right / Form -->
    <div class="pr-right">
      <div class="pr-card">
        <h2 class="pr-card-t">Create your spot</h2>
        <p class="pr-card-s">No commitment — we'll notify you at launch.</p>

        <form @submit.prevent="submit" class="pr-form">
          <div class="pr-field">
            <label class="pr-label">Full name</label>
            <input v-model="form.full_name" type="text" class="pr-input" placeholder="John Smith" required />
            <div v-if="form.errors.full_name" class="pr-err">{{ form.errors.full_name }}</div>
          </div>
          <div class="pr-field">
            <label class="pr-label">Email</label>
            <input v-model="form.email" type="email" class="pr-input" placeholder="john@example.com" required />
            <div v-if="form.errors.email" class="pr-err">{{ form.errors.email }}</div>
          </div>
          <div class="pr-row">
            <div class="pr-field" style="flex:1">
              <label class="pr-label">Phone <span class="pr-opt">(optional)</span></label>
              <input v-model="form.phone" type="tel" class="pr-input" placeholder="+45..." />
            </div>
            <div class="pr-field" style="flex:1">
              <label class="pr-label">Country <span class="pr-opt">(optional)</span></label>
              <input v-model="form.country" type="text" class="pr-input" placeholder="Denmark" />
            </div>
          </div>
          <button type="submit" class="pr-btn" :disabled="form.processing">
            {{ form.processing ? 'Joining...' : 'Join the waitlist →' }}
          </button>
          <p class="pr-note">By joining you agree to our <a href="/terms">Terms</a> and <a href="/privacy">Privacy Policy</a>.</p>
        </form>
      </div>
    </div>
  </div>
</div>
</template>

<style>
*{margin:0;padding:0;box-sizing:border-box}
.pr-page{min-height:100vh;background:#fff;font-family:'Inter',sans-serif;display:flex;align-items:center;justify-content:center;padding:40px 24px}
.pr-wrap{display:flex;gap:80px;max-width:960px;width:100%;align-items:center}

.pr-left{flex:1}
.pr-mark{font-size:28px;font-weight:900;color:#0a0a0a;text-decoration:none;letter-spacing:-1.5px;display:inline-block;margin-bottom:48px}
.pr-dot{color:#2563EB;font-size:32px;line-height:0}
.pr-h1{font-size:clamp(2.4rem,5vw,3.8rem);font-weight:900;line-height:1.08;letter-spacing:-.04em;color:#0a0a0a;margin-bottom:20px}
.pr-sub{font-size:16px;color:#0a0a0a;opacity:.35;line-height:1.7;margin-bottom:40px;max-width:360px}
.pr-features{display:flex;flex-direction:column;gap:10px}
.pr-feat{font-size:14px;font-weight:600;color:#0a0a0a;opacity:.5;padding:8px 0;border-bottom:1px solid rgba(0,0,0,.04)}

.pr-right{flex:1;max-width:420px}
.pr-card{padding:40px;border:1px solid rgba(0,0,0,.08);border-radius:20px}
.pr-card-t{font-size:22px;font-weight:900;color:#0a0a0a;margin-bottom:4px;letter-spacing:-.03em}
.pr-card-s{font-size:13px;color:#999;margin-bottom:32px}

.pr-form{display:flex;flex-direction:column;gap:18px}
.pr-field{display:flex;flex-direction:column;gap:6px}
.pr-label{font-size:12px;font-weight:700;color:#0a0a0a;opacity:.4;letter-spacing:.3px}
.pr-opt{font-weight:400;opacity:.5}
.pr-input{padding:13px 16px;border:1.5px solid rgba(0,0,0,.08);border-radius:10px;font-size:14px;font-family:inherit;outline:none;color:#0a0a0a;transition:border-color .2s;background:#fff}.pr-input:focus{border-color:#2563EB}.pr-input::placeholder{color:#ddd}
.pr-err{font-size:12px;color:#ef4444;font-weight:500}
.pr-row{display:flex;gap:12px}

.pr-btn{padding:15px;background:#0a0a0a;color:#fff;border:none;border-radius:12px;font-size:15px;font-weight:800;cursor:pointer;font-family:inherit;transition:background .2s;margin-top:4px}.pr-btn:hover{background:#222}.pr-btn:disabled{opacity:.5;cursor:not-allowed}
.pr-note{font-size:11px;color:#ccc;text-align:center;line-height:1.5}.pr-note a{color:#999;text-decoration:underline}

@media(max-width:768px){
  .pr-wrap{flex-direction:column;gap:40px}
  .pr-right{max-width:100%;width:100%}
  .pr-row{flex-direction:column}
}
</style>
