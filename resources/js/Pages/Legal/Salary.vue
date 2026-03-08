<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, ref, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'المعاشات — SDB Bank',
  heroTag:'استلام المعاشات',
  heroH:'معاشك يوصل',
  heroEm:'قبل ما تصحى.',
  heroP:'استلم راتبك مباشرة في حسابك الرقمي. بدون بنوك تقليدية، بدون طوابير، بدون تأخير. كل شيء تلقائي.',
  heroCta:'ابدأ الآن',
  stepsTitle:'كيف يعمل؟',
  steps:[
    {n:'01',ic:'📝',t:'سجّل حسابك',d:'افتح حسابك الرقمي بدقائق. تحقق سريع من هويتك إلكترونياً بدون أوراق.'},
    {n:'02',ic:'🏦',t:'شارك IBAN',d:'أعطِ صاحب العمل رقم حسابك الدولي (IBAN). هذا كل ما يحتاجه لتحويل راتبك.'},
    {n:'03',ic:'💰',t:'استلم تلقائياً',d:'معاشك يوصل تلقائياً لحسابك. إشعار فوري على هاتفك لحظة وصول الراتب.'},
  ],
  featTitle:'مميزات لا تنتهي.',
  feats:[
    {ic:'📥',t:'إيداع مباشر',d:'معاشك يصل تلقائياً بدون أي تدخل منك. متوافق مع كل أنظمة الرواتب العالمية.'},
    {ic:'🔔',t:'إشعار فوري',d:'تنبيه لحظي على هاتفك لحظة وصول الراتب. اعرف بالضبط متى يوصل.'},
    {ic:'🆓',t:'بدون رسوم',d:'لا رسوم على استلام الراتب. لا رسوم شهرية. لا رسوم مخفية.'},
    {ic:'📊',t:'تحليل ذكي',d:'تصنيف تلقائي لمصاريفك. اعرف وين رايحة فلوسك بنظرة وحدة.'},
    {ic:'💳',t:'سحب فوري',d:'اسحب من أي صراف آلي بالعالم ببطاقة ماستركارد. أو حوّل لأي حساب.'},
    {ic:'🔄',t:'تحويل تلقائي',d:'حدد نسبة من راتبك تروح تلقائياً للتوفير أو لحساب ثاني.'},
  ],
  compTitle:'SDB vs البنوك التقليدية',
  compHeaders:['الميزة','SDB Bank','بنك تقليدي'],
  compRows:[
    ['وصول الراتب','فوري — لحظة التحويل','1-3 أيام عمل'],
    ['رسوم الاستلام','مجاني بالكامل','رسوم شهرية متنوعة'],
    ['إشعارات','فوري على الهاتف','بريد أو SMS متأخر'],
    ['تحليل المصاريف','تلقائي وذكي','غير متوفر'],
    ['فتح الحساب','دقائق — رقمي بالكامل','أيام — زيارة فرع'],
    ['متوفر','24/7 من أي مكان','ساعات عمل فقط'],
  ],
  ctaTitle:'جاهز تستلم معاشك رقمياً؟',
  ctaSub:'افتح حسابك المجاني وابدأ استلام راتبك مباشرة.',
  ctaBtn:'افتح حسابك المجاني ←',
} : {
  title:'Salary — SDB Bank',
  heroTag:'Salary Deposits',
  heroH:'Your salary arrives',
  heroEm:'before you wake up.',
  heroP:'Receive your salary directly into your digital account. No traditional banks, no queues, no delays. Everything is automatic.',
  heroCta:'Get Started',
  stepsTitle:'How it works',
  steps:[
    {n:'01',ic:'📝',t:'Create your account',d:'Open your digital account in minutes. Quick digital identity verification without paperwork.'},
    {n:'02',ic:'🏦',t:'Share your IBAN',d:'Give your employer your international account number (IBAN). That\'s all they need to send your salary.'},
    {n:'03',ic:'💰',t:'Receive automatically',d:'Your salary arrives automatically. Instant notification on your phone the moment it lands.'},
  ],
  featTitle:'Endless features.',
  feats:[
    {ic:'📥',t:'Direct Deposit',d:'Your salary arrives automatically without any action from you. Compatible with all global payroll systems.'},
    {ic:'🔔',t:'Instant Alert',d:'Real-time notification on your phone the moment your salary arrives.'},
    {ic:'🆓',t:'Zero Fees',d:'No fees on salary reception. No monthly fees. No hidden charges.'},
    {ic:'📊',t:'Smart Analytics',d:'Automatic categorization of your spending. Know where your money goes at a glance.'},
    {ic:'💳',t:'Instant Withdrawal',d:'Withdraw from any ATM worldwide with your Mastercard. Or transfer to any account.'},
    {ic:'🔄',t:'Auto-Transfer',d:'Set a percentage of your salary to automatically go to savings or another account.'},
  ],
  compTitle:'SDB vs Traditional Banks',
  compHeaders:['Feature','SDB Bank','Traditional Bank'],
  compRows:[
    ['Salary arrival','Instant — the moment it\'s sent','1-3 business days'],
    ['Reception fees','Completely free','Various monthly fees'],
    ['Notifications','Instant on phone','Delayed mail/SMS'],
    ['Spending analytics','Automatic & smart','Not available'],
    ['Account opening','Minutes — fully digital','Days — branch visit'],
    ['Available','24/7 from anywhere','Business hours only'],
  ],
  ctaTitle:'Ready to receive your salary digitally?',
  ctaSub:'Open your free account and start receiving your salary directly.',
  ctaBtn:'Open your free account →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw"><div class="p-hero-tag">{{ t.heroTag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><a href="/preregister" class="p-cta">{{ t.heroCta }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.stepsTitle }}</h2><div class="steps"><div v-for="s in t.steps" :key="s.n" class="step"><div class="step-n">{{ s.n }}</div><div class="step-ic">{{ s.ic }}</div><h3 class="step-t">{{ s.t }}</h3><p class="step-d">{{ s.d }}</p></div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2">{{ t.featTitle }}</h2><div class="feat-g"><div v-for="f in t.feats" :key="f.t" class="feat-c"><span class="feat-ic">{{ f.ic }}</span><h4 class="feat-t">{{ f.t }}</h4><p class="feat-d">{{ f.d }}</p></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.compTitle }}</h2><div class="tbl-wrap"><table class="tbl"><thead><tr><th v-for="h in t.compHeaders" :key="h">{{ h }}</th></tr></thead><tbody><tr v-for="(r,i) in t.compRows" :key="i"><td v-for="(c,j) in r" :key="j" :class="{'tbl-hl':j===1}">{{ c }}</td></tr></tbody></table></div></div></section>
<section class="sec sec-dark tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="p-cta p-cta-w">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}
.sec{padding:100px 0}.sec-alt{background:#fafafa}.sec-dark{background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.tc{text-align:center}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:500px}.t2-sub-w{color:rgba(255,255,255,.3)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#0a0a0a 0%,#162d4d 100%);color:#fff;text-align:center}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#7DD3FC;text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}
.p-hero-em{color:#7DD3FC}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.45);max-width:560px;margin:0 auto 32px;line-height:1.8}
.p-cta{display:inline-block;padding:16px 44px;background:#fff;color:#0a0a0a;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.p-cta:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,.2)}
.p-cta-w{background:#fff;color:#0a0a0a}
.steps{display:grid;grid-template-columns:repeat(3,1fr);gap:24px;margin-top:20px}
.step{padding:40px 28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;text-align:center;transition:all .3s}.step:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(0,0,0,.05)}
.step-n{font-size:48px;font-weight:900;color:rgba(14,165,233,.08);line-height:1;margin-bottom:8px}
.step-ic{font-size:36px;margin-bottom:12px}
.step-t{font-size:16px;font-weight:800;margin-bottom:8px}
.step-d{font-size:13px;color:rgba(10,10,10,.4);line-height:1.75}
.feat-g{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.feat-c{padding:32px 24px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:18px;transition:all .3s}.feat-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.feat-ic{font-size:28px;display:block;margin-bottom:12px}
.feat-t{font-size:15px;font-weight:800;margin-bottom:6px}
.feat-d{font-size:13px;color:rgba(10,10,10,.35);line-height:1.75}
.tbl-wrap{overflow-x:auto;margin-top:12px}
.tbl{width:100%;border-collapse:collapse;font-size:14px}
.tbl th{padding:16px;text-align:center;font-weight:800;background:#0a0a0a;color:#fff;font-size:13px}.tbl th:first-child{text-align:start;border-radius:12px 0 0 0}.tbl th:last-child{border-radius:0 12px 0 0}
.tbl td{padding:14px 16px;text-align:center;border-bottom:1px solid rgba(10,10,10,.06);font-size:13px;color:rgba(10,10,10,.55)}.tbl td:first-child{text-align:start;font-weight:600;color:#0a0a0a}
.tbl-hl{color:#0EA5E9!important;font-weight:700!important}
.tbl tbody tr:hover{background:rgba(14,165,233,.02)}
@media(max-width:768px){.steps,.feat-g{grid-template-columns:1fr}}
</style>
