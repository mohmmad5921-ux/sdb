<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'حساب التوفير — SDB Bank',tag:'التوفير',
  heroH:'وفّر ذكي.',heroEm:'حقق أهدافك.',
  heroP:'أدوات ادخار ذكية تساعدك توفّر بدون ما تحس. أهداف مخصصة، تحويل تلقائي، وتتبع تقدمك لحظياً.',
  heroBtn:'سجّل اهتمامك ←',
  featTitle:'أدوات التوفير الذكية',
  feats:[
    {ic:'🎯',t:'أهداف ادخار',d:'حدد هدفك — سيارة، سفر، طوارئ، زواج. اسم وصورة ومبلغ مستهدف. تتبع التقدم بصرياً.'},
    {ic:'🔄',t:'توفير تلقائي',d:'حدد مبلغ يومي أو أسبوعي أو شهري يُحوّل تلقائياً لصندوق التوفير. وفّر بدون ما تفكّر.'},
    {ic:'💡',t:'Round-ups',d:'كل عملية شراء يُدوّر المبلغ للأعلى والفرق يروح للتوفير. اشتريت بـ €4.30؟ €0.70 روحت للتوفير تلقائياً.'},
    {ic:'📊',t:'تقارير التوفير',d:'كم وفّرت هذا الشهر؟ هذا الأسبوع؟ مقارنة بالشهر الماضي. رسوم بيانية واضحة.'},
    {ic:'🔐',t:'صناديق مقفلة',d:'اقفل مبلغ لفترة محددة — 3 أشهر، 6 أشهر، سنة. لمنع نفسك من السحب المبكر.'},
    {ic:'🤖',t:'مساعد ادخار AI',d:'الذكاء الاصطناعي يحلل مصاريفك ويقترح مبلغ التوفير الأمثل بدون ما يأثر على حياتك اليومية.'},
    {ic:'🏷️',t:'تصنيف الأهداف',d:'أهداف قصيرة المدى (شهر)، متوسطة (سنة)، طويلة (5+ سنوات). أولويات مرنة.'},
    {ic:'👨‍👩‍👧‍👦',t:'أهداف عائلية',d:'شاركوا نفس الهدف — كل العائلة تساهم بالتوفير لهدف واحد.'},
    {ic:'🎉',t:'مكافآت الادخار',d:'وصلت لهدفك؟ تهانينا! شارات إنجاز + نقاط مكافآت إضافية.'},
  ],
  howTitle:'كيف يعمل؟',
  steps:[
    {n:'1',t:'أنشئ هدف',d:'سمّيه وحط مبلغ مستهدف.'},
    {n:'2',t:'فعّل التوفير التلقائي',d:'يومي، أسبوعي، أو round-ups.'},
    {n:'3',t:'تتبع تقدمك',d:'شاهد صندوقك يكبر لحظياً.'},
    {n:'4',t:'حقق هدفك! 🎉',d:'اسحب أو أعد الاستثمار.'},
  ],
  examplesTitle:'أمثلة على الأهداف',
  examples:[
    {ic:'✈️',t:'سفر لتركيا',v:'€2,000',d:'€5/يوم × 400 يوم = هدفك!'},
    {ic:'🚗',t:'سيارة جديدة',v:'€15,000',d:'€200/شهر × ~6 سنوات'},
    {ic:'🏠',t:'دفعة أولى لبيت',v:'€25,000',d:'€500/شهر + round-ups'},
    {ic:'🎓',t:'تعليم الأطفال',v:'€10,000',d:'€150/شهر هدف طويل'},
    {ic:'💍',t:'زواج',v:'€8,000',d:'€300/شهر × ~27 شهر'},
    {ic:'⛑️',t:'صندوق طوارئ',v:'€3,000',d:'€100/شهر + التوفير الذكي'},
  ],
  ctaTitle:'ابدأ التوفير اليوم',ctaSub:'أدوات ذكية تساعدك تحقق أحلامك.',ctaBtn:'سجّل اهتمامك ←',ctaTag:'قريباً',
} : {
  title:'Savings Account — SDB Bank',tag:'Savings',
  heroH:'Save smart.',heroEm:'Reach your goals.',
  heroP:'Smart savings tools that help you save without thinking. Custom goals, auto-transfers, and real-time progress tracking.',
  heroBtn:'Register interest →',
  featTitle:'Smart Savings Tools',
  feats:[
    {ic:'🎯',t:'Savings Goals',d:'Set your goal — car, travel, emergency, wedding. Name, image, and target amount. Visual progress tracking.'},
    {ic:'🔄',t:'Auto Save',d:'Set daily, weekly, or monthly amount auto-transferred to savings. Save without thinking.'},
    {ic:'💡',t:'Round-ups',d:'Every purchase rounds up and the difference goes to savings. Bought for €4.30? €0.70 goes to savings automatically.'},
    {ic:'📊',t:'Savings Reports',d:'How much did you save this month? This week? Compared to last month. Clear visual charts.'},
    {ic:'🔐',t:'Locked Vaults',d:'Lock an amount for a set period — 3 months, 6 months, 1 year. Prevent early withdrawal.'},
    {ic:'🤖',t:'AI Savings Assistant',d:'AI analyzes your spending and suggests optimal savings amount without affecting your daily life.'},
    {ic:'🏷️',t:'Goal Categories',d:'Short-term (month), medium (year), long-term (5+ years). Flexible priorities.'},
    {ic:'👨‍👩‍👧‍👦',t:'Family Goals',d:'Share the same goal — whole family contributes to saving for one target.'},
    {ic:'🎉',t:'Savings Rewards',d:'Reached your goal? Congrats! Achievement badges + bonus reward points.'},
  ],
  howTitle:'How it works',
  steps:[
    {n:'1',t:'Create a goal',d:'Name it and set a target amount.'},
    {n:'2',t:'Enable auto-save',d:'Daily, weekly, or round-ups.'},
    {n:'3',t:'Track progress',d:'Watch your vault grow in real-time.'},
    {n:'4',t:'Achieve your goal! 🎉',d:'Withdraw or reinvest.'},
  ],
  examplesTitle:'Goal Examples',
  examples:[
    {ic:'✈️',t:'Trip to Turkey',v:'€2,000',d:'€5/day × 400 days = goal!'},
    {ic:'🚗',t:'New Car',v:'€15,000',d:'€200/mo × ~6 years'},
    {ic:'🏠',t:'House Down Payment',v:'€25,000',d:'€500/mo + round-ups'},
    {ic:'🎓',t:'Kids Education',v:'€10,000',d:'€150/mo long-term goal'},
    {ic:'💍',t:'Wedding',v:'€8,000',d:'€300/mo × ~27 months'},
    {ic:'⛑️',t:'Emergency Fund',v:'€3,000',d:'€100/mo + smart saving'},
  ],
  ctaTitle:'Start saving today',ctaSub:'Smart tools to help you achieve your dreams.',ctaBtn:'Register interest →',ctaTag:'Coming Soon',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><a href="/preregister" class="hero-btn">{{ t.heroBtn }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.featTitle }}</h2><div class="g3"><div v-for="f in t.feats" :key="f.t" class="fc"><span class="fc-ic">{{ f.ic }}</span><h3 class="fc-t">{{ f.t }}</h3><p class="fc-d">{{ f.d }}</p></div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.howTitle }}</h2><div class="g4"><div v-for="s in t.steps" :key="s.n" class="step-c"><div class="step-n">{{ s.n }}</div><h3 class="step-t">{{ s.t }}</h3><p class="step-d">{{ s.d }}</p></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.examplesTitle }}</h2><div class="g3"><div v-for="e in t.examples" :key="e.t" class="ex-c"><span class="ex-ic">{{ e.ic }}</span><h4 class="ex-t">{{ e.t }}</h4><div class="ex-v">{{ e.v }}</div><p class="ex-d">{{ e.d }}</p></div></div></div></section>
<section class="sec sec-teal tc"><div class="sw"><div class="tag-sm">{{ t.ctaTag }}</div><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F0FDFA}
.sec-teal{background:linear-gradient(135deg,#134E4A,#0F766E,#14B8A6);color:#fff;padding:100px 0}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.tag-sm{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:16px}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#134E4A,#0F766E,#14B8A6);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#99F6E4}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto 28px;line-height:1.8}
.hero-btn{display:inline-block;padding:16px 44px;background:#fff;color:#134E4A;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.hero-btn:hover{transform:translateY(-2px)}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.fc{padding:28px;background:#fff;border:1px solid rgba(20,184,166,.08);border-radius:18px;transition:all .3s}.fc:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(20,184,166,.06)}
.fc-ic{font-size:28px;display:block;margin-bottom:10px}.fc-t{font-size:15px;font-weight:800;color:#134E4A;margin-bottom:6px}.fc-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.step-c{padding:28px;background:#fff;border:1px solid rgba(20,184,166,.08);border-radius:16px;text-align:center}
.step-n{font-size:40px;font-weight:900;color:rgba(20,184,166,.12);line-height:1;margin-bottom:8px}
.step-t{font-size:14px;font-weight:800;color:#134E4A;margin-bottom:4px}.step-d{font-size:12px;color:rgba(10,10,10,.4)}
.ex-c{padding:24px;background:#fff;border:1px solid rgba(20,184,166,.08);border-radius:16px;text-align:center;transition:all .3s}.ex-c:hover{transform:translateY(-2px);box-shadow:0 6px 18px rgba(20,184,166,.06)}
.ex-ic{font-size:28px;display:block;margin-bottom:8px}.ex-t{font-size:14px;font-weight:800;color:#134E4A;margin-bottom:4px}
.ex-v{font-size:24px;font-weight:900;color:#14B8A6;margin-bottom:6px}.ex-d{font-size:11px;color:rgba(10,10,10,.3)}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#134E4A;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.g3{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}}
</style>
