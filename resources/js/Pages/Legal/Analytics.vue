<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'التحليلات المالية — SDB Bank',tag:'التحليلات',
  heroH:'افهم أموالك.',heroEm:'بالذكاء الاصطناعي.',
  heroP:'أدوات تحليل مالية ذكية تصنّف مصاريفك تلقائياً، تنشئ ميزانيات، وتعطيك رؤى واقتراحات لتوفير المال.',
  heroBtn:'افتح حسابك ←',
  featTitle:'أدوات التحليل',
  feats:[
    {ic:'📊',t:'تصنيف تلقائي',d:'كل عملية تُصنّف تلقائياً: طعام، تنقل، تسوق، ترفيه، فواتير. دقة 95% بفضل الذكاء الاصطناعي.'},
    {ic:'🎯',t:'ميزانيات شهرية',d:'حدد ميزانية لكل فئة. إشعار عند وصولك لـ 80%. مقارنة فعلي vs مخطط.'},
    {ic:'📈',t:'اتجاهات المصاريف',d:'كيف تغيّرت مصاريفك عبر الوقت؟ رسوم بيانية أسبوعية وشهرية وسنوية.'},
    {ic:'🔍',t:'رؤى ذكية',d:'"أنفقت 30% أكثر على الطعام هذا الشهر" — اقتراحات مخصصة لتوفير المال.'},
    {ic:'📋',t:'كشف حساب',d:'كشف حساب مفصّل. تصفية حسب التاريخ والفئة والمبلغ. تصدير PDF أو CSV.'},
    {ic:'🏷️',t:'علامات مخصصة',d:'أضف علامات خاصة لمشاريع أو أحداث. "عطلة تركيا" — شوف كل المصاريف المتعلقة.'},
    {ic:'💰',t:'تتبع الاشتراكات',d:'كل اشتراكاتك الشهرية بمكان واحد. Netflix, Spotify, جيم — المجموع الشهري واضح.'},
    {ic:'🔔',t:'تنبيهات ذكية',d:'إنفاق غير عادي؟ تكرار مشبوه؟ مبلغ كبير؟ تنبيه فوري مع تحليل.'},
    {ic:'🤖',t:'مساعد AI',d:'اسأل المساعد الذكي: "كم أنفقت على الطعام هذا الشهر؟" — إجابة فورية.'},
  ],
  reportTitle:'أنواع التقارير',
  reports:[
    {t:'يومي',d:'ملخص نهاية اليوم — كم أنفقت اليوم ومن أين.'},
    {t:'أسبوعي',d:'مقارنة مع الأسبوع الماضي. هل أنت على المسار الصحيح؟'},
    {t:'شهري',d:'تقرير شامل — تصنيف كامل، ميزانيات، اتجاهات.'},
    {t:'سنوي',d:'رؤية شاملة لأموالك خلال السنة. أفضل وأسوأ الأشهر.'},
  ],
  ctaTitle:'تحكّم بمصاريفك',ctaSub:'أدوات ذكية لفهم أموالك والتوفير أكثر.',ctaBtn:'افتح حسابك ←',ctaTag:'متاح مع كل الحسابات',
} : {
  title:'Financial Analytics — SDB Bank',tag:'Analytics',
  heroH:'Understand your money.',heroEm:'With AI.',
  heroP:'Smart financial analysis tools that auto-categorize expenses, create budgets, and give you insights to save money.',
  heroBtn:'Open your account →',
  featTitle:'Analysis Tools',
  feats:[
    {ic:'📊',t:'Auto-categorization',d:'Every transaction auto-categorized: food, transport, shopping, entertainment, bills. 95% accuracy with AI.'},
    {ic:'🎯',t:'Monthly Budgets',d:'Set budget per category. Alert at 80%. Actual vs planned comparison.'},
    {ic:'📈',t:'Spending Trends',d:'How did your spending change over time? Weekly, monthly, and yearly charts.'},
    {ic:'🔍',t:'Smart Insights',d:'"You spent 30% more on food this month" — personalized suggestions to save.'},
    {ic:'📋',t:'Statements',d:'Detailed account statement. Filter by date, category, amount. Export PDF or CSV.'},
    {ic:'🏷️',t:'Custom Tags',d:'Add custom tags for projects or events. "Turkey vacation" — see all related expenses.'},
    {ic:'💰',t:'Subscription Tracking',d:'All monthly subscriptions in one place. Netflix, Spotify, gym — monthly total clear.'},
    {ic:'🔔',t:'Smart Alerts',d:'Unusual spending? Suspicious repeat? Large amount? Instant alert with analysis.'},
    {ic:'🤖',t:'AI Assistant',d:'Ask the smart assistant: "How much did I spend on food this month?" — instant answer.'},
  ],
  reportTitle:'Report Types',
  reports:[
    {t:'Daily',d:'End of day summary — how much you spent and where.'},
    {t:'Weekly',d:'Comparison with last week. Are you on track?'},
    {t:'Monthly',d:'Comprehensive report — full categorization, budgets, trends.'},
    {t:'Yearly',d:'Full year financial overview. Best and worst months.'},
  ],
  ctaTitle:'Control your spending',ctaSub:'Smart tools to understand your money and save more.',ctaBtn:'Open your account →',ctaTag:'Available with all accounts',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><a href="/preregister" class="hero-btn">{{ t.heroBtn }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.featTitle }}</h2><div class="g3"><div v-for="f in t.feats" :key="f.t" class="fc"><span class="fc-ic">{{ f.ic }}</span><h3 class="fc-t">{{ f.t }}</h3><p class="fc-d">{{ f.d }}</p></div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.reportTitle }}</h2><div class="g4"><div v-for="r in t.reports" :key="r.t" class="rep-c"><h4 class="rep-t">{{ r.t }}</h4><p class="rep-d">{{ r.d }}</p></div></div></div></section>
<section class="sec sec-sky tc"><div class="sw"><div class="tag-sm">{{ t.ctaTag }}</div><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#EFF6FF}.sec-sky{background:linear-gradient(135deg,#0C4A6E,#0369A1,#0EA5E9);color:#fff;padding:100px 0}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.tag-sm{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:16px}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#0C4A6E,#0369A1,#0EA5E9);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#7DD3FC}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto 28px;line-height:1.8}
.hero-btn{display:inline-block;padding:16px 44px;background:#fff;color:#0C4A6E;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.hero-btn:hover{transform:translateY(-2px)}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.fc{padding:28px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:18px;transition:all .3s}.fc:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(14,165,233,.06)}
.fc-ic{font-size:28px;display:block;margin-bottom:10px}.fc-t{font-size:15px;font-weight:800;color:#0C4A6E;margin-bottom:6px}.fc-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.rep-c{padding:24px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:16px;text-align:center}
.rep-t{font-size:16px;font-weight:800;color:#0EA5E9;margin-bottom:6px}.rep-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.7}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#0C4A6E;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.g3{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}}
</style>
