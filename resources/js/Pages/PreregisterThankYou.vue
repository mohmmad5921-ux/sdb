<script setup>
import { Head } from '@inertiajs/vue3';

defineProps({
  name: String,
  email: String,
});
</script>

<template>
<Head title="Welcome — SDB Bank">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
</Head>

<div class="ty-page">
  <div class="ty-wrap">
    <a href="/" class="ty-mark">SDB<span class="ty-dot">.</span></a>

    <div class="ty-check">✓</div>
    <h1 class="ty-h1">You're in, {{ name }}!</h1>
    <p class="ty-sub">We've sent a confirmation email to <strong>{{ email }}</strong>. You'll be among the first to know when SDB Bank launches.</p>

    <div class="ty-box">
      <div class="ty-box-t">What happens next?</div>
      <div class="ty-steps">
        <div class="ty-step">
          <span class="ty-sn">01</span>
          <div><div class="ty-st">Check your inbox</div><div class="ty-sd">We sent you a welcome email with details.</div></div>
        </div>
        <div class="ty-step">
          <span class="ty-sn">02</span>
          <div><div class="ty-st">We'll keep you updated</div><div class="ty-sd">Expect updates about our launch and new features.</div></div>
        </div>
        <div class="ty-step">
          <span class="ty-sn">03</span>
          <div><div class="ty-st">Get early access</div><div class="ty-sd">Be the first to open your account when we launch.</div></div>
        </div>
      </div>
    </div>

    <a href="/" class="ty-back">← Back to homepage</a>
  </div>
</div>
</template>

<style>
*{margin:0;padding:0;box-sizing:border-box}
.ty-page{min-height:100vh;background:#fff;font-family:'Inter',sans-serif;display:flex;align-items:center;justify-content:center;padding:40px 24px}
.ty-wrap{max-width:520px;width:100%;text-align:center}

.ty-mark{font-size:28px;font-weight:900;color:#0a0a0a;text-decoration:none;letter-spacing:-1.5px;display:inline-block;margin-bottom:48px}
.ty-dot{color:#2563EB;font-size:32px;line-height:0}

.ty-check{width:72px;height:72px;border-radius:50%;background:#0a0a0a;color:#fff;font-size:32px;display:flex;align-items:center;justify-content:center;margin:0 auto 28px;font-weight:900}
.ty-h1{font-size:clamp(1.8rem,4vw,2.6rem);font-weight:900;letter-spacing:-.03em;color:#0a0a0a;margin-bottom:16px}
.ty-sub{font-size:15px;color:#888;line-height:1.7;margin-bottom:48px;max-width:400px;margin-left:auto;margin-right:auto}
.ty-sub strong{color:#0a0a0a}

.ty-box{border:1px solid rgba(0,0,0,.07);border-radius:16px;padding:32px;text-align:left;margin-bottom:40px}
.ty-box-t{font-size:12px;font-weight:800;letter-spacing:2px;text-transform:uppercase;color:#0a0a0a;opacity:.2;margin-bottom:24px}
.ty-steps{display:flex;flex-direction:column;gap:20px}
.ty-step{display:flex;gap:16px;align-items:flex-start}
.ty-sn{font-size:13px;font-weight:900;color:#2563EB;opacity:.4;min-width:28px;padding-top:2px}
.ty-st{font-size:14px;font-weight:800;color:#0a0a0a;margin-bottom:2px}
.ty-sd{font-size:13px;color:#999;line-height:1.5}

.ty-back{font-size:14px;color:#999;text-decoration:none;font-weight:500;transition:color .2s}.ty-back:hover{color:#0a0a0a}
</style>
