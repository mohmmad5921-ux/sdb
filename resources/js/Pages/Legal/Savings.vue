<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'حساب التوفير — SDB Bank',tag:'قريباً',
  h:'حساب التوفير',em:'قيد التطوير.',
  p:'نعمل على تطوير أدوات ادخار ذكية تساعدك توفّر بدون ما تحس. أهداف مخصصة، تحويل تلقائي، ومتابعة تقدمك لحظياً.',
  feats:['🎯 أهداف ادخار مخصصة','🔄 توفير تلقائي','💡 Round-ups ذكي','📊 تقارير التوفير','🔐 صناديق مقفلة','🤖 مساعد ادخار AI','👨‍👩‍👧‍👦 أهداف عائلية','🎉 مكافآت الادخار'],
  btn:'سجّل اهتمامك ←',
} : {
  title:'Savings Account — SDB Bank',tag:'COMING SOON',
  h:'Savings Account',em:'Under Development.',
  p:'We\'re building smart savings tools to help you save effortlessly. Custom goals, auto-transfers, and real-time progress tracking.',
  feats:['🎯 Custom savings goals','🔄 Auto-save','💡 Smart Round-ups','📊 Savings reports','🔐 Locked vaults','🤖 AI savings assistant','👨‍👩‍👧‍👦 Family goals','🎉 Savings rewards'],
  btn:'Register interest →',
});
</script>
<template>
<Head :title="t.title" />
<section class="cs-hero"><div class="cs-bg"></div>
<div class="cs-circles"><div class="csc csc1"></div><div class="csc csc2"></div></div>
<div class="sw tc" style="position:relative;z-index:1">
  <div class="cs-badge">🚧 {{ t.tag }}</div>
  <h1 class="cs-h1">{{ t.h }}<br><span class="cs-em">{{ t.em }}</span></h1>
  <p class="cs-p">{{ t.p }}</p>
  <div class="cs-feats"><span v-for="f in t.feats" :key="f" class="cs-feat">{{ f }}</span></div>
  <a href="/preregister" class="cs-btn">{{ t.btn }}</a>
</div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.cs-hero{min-height:100vh;display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden;padding:160px 0 80px}
.cs-bg{position:absolute;inset:0;background:linear-gradient(135deg,#163300,#1a3d00,#0f2600)}
.cs-circles{position:absolute;inset:0;overflow:hidden}
.csc{position:absolute;border-radius:50%;filter:blur(100px)}.csc1{top:-20%;right:-10%;width:600px;height:600px;background:rgba(159,232,112,.15);animation:pulse 5s ease-in-out infinite}.csc2{bottom:-20%;left:-10%;width:500px;height:500px;background:rgba(159,232,112,.08);animation:pulse 7s ease-in-out infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.4}}
.cs-badge{display:inline-block;padding:8px 20px;background:rgba(159,232,112,.15);color:#9FE870;font-size:13px;font-weight:800;border-radius:999px;margin-bottom:24px;border:1px solid rgba(159,232,112,.25);letter-spacing:1px}
.cs-h1{font-size:clamp(2.5rem,5.5vw,4.5rem);font-weight:900;color:#fff;line-height:1.05;letter-spacing:-.04em;margin-bottom:20px}
.cs-em{color:#9FE870}
.cs-p{font-size:17px;color:rgba(255,255,255,.5);line-height:1.85;margin:0 auto 40px;max-width:600px}
.cs-feats{display:flex;flex-wrap:wrap;gap:10px;justify-content:center;max-width:700px;margin:0 auto 40px}
.cs-feat{padding:10px 18px;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.08);border-radius:12px;color:rgba(255,255,255,.7);font-size:13px;font-weight:600;backdrop-filter:blur(4px)}
.cs-btn{display:inline-block;padding:18px 48px;background:linear-gradient(135deg,#2D6A00,#9FE870);color:#fff;font-size:16px;font-weight:800;border-radius:999px;text-decoration:none;transition:all .3s;box-shadow:0 4px 20px rgba(159,232,112,.2)}.cs-btn:hover{transform:translateY(-3px);box-shadow:0 8px 32px rgba(159,232,112,.3)}
@media(max-width:768px){.cs-hero{padding:120px 0 60px}.cs-feats{flex-direction:column;align-items:center}}
</style>
