<script setup>
import { Head, useForm, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');

const form = useForm({ full_name:'', email:'', phone:'', country:'' });
const submit = () => form.post('/preregister');

const t = computed(() => isAr.value ? {
  title:'التسجيل المسبق — SDB Bank',
  h1:'كن من الأوائل.',
  sub:'سجّل الآن وكن من أوائل المستخدمين لأول بنك إلكتروني سوري. سنبلغك فور الإطلاق.',
  feats:['💳 بطاقات ماستركارد فورية','💱 أكثر من 30 عملة','⚡ تحويلات لـ 150+ دولة','💰 استلام المعاشات','🛡️ أمان بمعايير أوروبية','🧾 دفع الفواتير (قريباً)'],
  cardT:'سجّل مكانك',
  cardS:'بدون التزام — سنبلغك عند الإطلاق.',
  name:'الاسم الكامل',namePh:'أحمد محمد',
  email:'البريد الإلكتروني',emailPh:'ahmed@example.com',
  phone:'الهاتف',phonePh:'+45...',phoneOpt:'اختياري',
  country:'البلد',countryPh:'سوريا',countryOpt:'اختياري',
  btn:'سجّل الآن ←',btnL:'جاري التسجيل...',
  note:'بالتسجيل توافق على',terms:'الشروط',and:'و',privacy:'سياسة الخصوصية',
} : {
  title:'Early Access — SDB Bank',
  h1:'Be among the first.',
  sub:'Sign up now and be among the first users of the first Syrian digital bank. We\'ll notify you at launch.',
  feats:['💳 Instant Mastercard','💱 30+ Currencies','⚡ 150+ Countries','💰 Salary Deposits','🛡️ European Security','🧾 Bill Payments (Soon)'],
  cardT:'Reserve your spot',
  cardS:'No commitment — we\'ll notify you at launch.',
  name:'Full name',namePh:'John Smith',
  email:'Email',emailPh:'john@example.com',
  phone:'Phone',phonePh:'+45...',phoneOpt:'optional',
  country:'Country',countryPh:'Syria',countryOpt:'optional',
  btn:'Join the waitlist →',btnL:'Joining...',
  note:'By joining you agree to our',terms:'Terms',and:'and',privacy:'Privacy Policy',
});
</script>
<template>
<Head :title="t.title"><link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" /></Head>
<div class="pr-page" :class="{rtl:isAr}" :dir="isAr?'rtl':'ltr'">
  <div class="pr-wrap">
    <div class="pr-left">
      <div class="pr-top-row">
        <a href="/" class="pr-mark">SDB<span class="pr-dot">.</span></a>
        <button @click="lang=lang==='ar'?'en':'ar'" class="pr-lang">{{ isAr?'EN':'عربي' }}</button>
      </div>
      <h1 class="pr-h1">{{ t.h1 }}</h1>
      <p class="pr-sub">{{ t.sub }}</p>
      <div class="pr-features"><div v-for="f in t.feats" :key="f" class="pr-feat">{{ f }}</div></div>
    </div>
    <div class="pr-right"><div class="pr-card">
      <h2 class="pr-card-t">{{ t.cardT }}</h2>
      <p class="pr-card-s">{{ t.cardS }}</p>
      <form @submit.prevent="submit" class="pr-form">
        <div class="pr-field"><label class="pr-label">{{ t.name }}</label><input v-model="form.full_name" type="text" class="pr-input" :placeholder="t.namePh" required /><div v-if="form.errors.full_name" class="pr-err">{{ form.errors.full_name }}</div></div>
        <div class="pr-field"><label class="pr-label">{{ t.email }}</label><input v-model="form.email" type="email" class="pr-input" :placeholder="t.emailPh" required /><div v-if="form.errors.email" class="pr-err">{{ form.errors.email }}</div></div>
        <div class="pr-row">
          <div class="pr-field" style="flex:1"><label class="pr-label">{{ t.phone }} <span class="pr-opt">({{ t.phoneOpt }})</span></label><input v-model="form.phone" type="tel" class="pr-input" :placeholder="t.phonePh" /></div>
          <div class="pr-field" style="flex:1"><label class="pr-label">{{ t.country }} <span class="pr-opt">({{ t.countryOpt }})</span></label><input v-model="form.country" type="text" class="pr-input" :placeholder="t.countryPh" /></div>
        </div>
        <button type="submit" class="pr-btn" :disabled="form.processing">{{ form.processing ? t.btnL : t.btn }}</button>
        <p class="pr-note">{{ t.note }} <a href="/terms">{{ t.terms }}</a> {{ t.and }} <a href="/privacy">{{ t.privacy }}</a>.</p>
      </form>
    </div></div>
  </div>
</div>
</template>
<style>
*{margin:0;padding:0;box-sizing:border-box}
.rtl{direction:rtl;text-align:right}
.pr-page{min-height:100vh;background:#fff;font-family:'Inter',sans-serif;display:flex;align-items:center;justify-content:center;padding:40px 24px}
.pr-wrap{display:flex;gap:80px;max-width:960px;width:100%;align-items:center}
.pr-left{flex:1}
.pr-top-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:48px}
.pr-mark{font-size:28px;font-weight:900;color:#0a0a0a;text-decoration:none;letter-spacing:-1.5px}
.pr-dot{color:#0EA5E9;font-size:32px;line-height:0}
.pr-lang{font-size:13px;font-weight:600;color:rgba(10,10,10,.4);background:transparent;border:1.5px solid rgba(10,10,10,.1);padding:6px 14px;border-radius:8px;cursor:pointer;font-family:inherit;transition:all .2s}.pr-lang:hover{border-color:rgba(10,10,10,.3);color:#0a0a0a}
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
.pr-input{padding:13px 16px;border:1.5px solid rgba(0,0,0,.08);border-radius:10px;font-size:14px;font-family:inherit;outline:none;color:#0a0a0a;transition:border-color .2s;background:#fff}.pr-input:focus{border-color:#0EA5E9}.pr-input::placeholder{color:#ddd}
.pr-err{font-size:12px;color:#ef4444;font-weight:500}
.pr-row{display:flex;gap:12px}
.pr-btn{padding:15px;background:#0a0a0a;color:#fff;border:none;border-radius:12px;font-size:15px;font-weight:800;cursor:pointer;font-family:inherit;transition:background .2s;margin-top:4px}.pr-btn:hover{background:#222}.pr-btn:disabled{opacity:.5;cursor:not-allowed}
.pr-note{font-size:11px;color:#ccc;text-align:center;line-height:1.5}.pr-note a{color:#999;text-decoration:underline}
@media(max-width:768px){.pr-wrap{flex-direction:column;gap:40px}.pr-right{max-width:100%;width:100%}.pr-row{flex-direction:column}}
</style>
