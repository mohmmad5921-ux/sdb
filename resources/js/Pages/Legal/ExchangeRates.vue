<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, computed, ref } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const fromCur = ref('EUR');const toCur = ref('SYP');const fromAmt = ref(100);
const rates = {EUR:1,USD:1.08,GBP:0.86,TRY:34.2,AED:3.97,SAR:4.05,SYP:13500,SEK:11.2,NOK:11.5,DKK:7.46,CHF:0.96,CAD:1.47,AUD:1.65,JPY:162,KWD:0.33,QAR:3.93,BHD:0.41,OMR:0.42,EGP:53.2,JOD:0.77,LBP:96800,IQD:1415,LYD:5.2,MAD:10.8,TND:3.38,SDG:601,SOS:620};
const currencies = Object.keys(rates);
const converted = computed(() => {
  const f = rates[fromCur.value]||1;const to = rates[toCur.value]||1;
  return ((fromAmt.value / f) * to).toFixed(2);
});
const t = computed(() => isAr.value ? {
  title:'أسعار الصرف — SDB Bank',tag:'أسعار الصرف',
  heroH:'أسعار حقيقية.',heroEm:'بدون هوامش.',
  heroP:'صرف عملات بأسعار السوق الحقيقية. بدون هوامش ربح مخفية. حوّل بين 30+ عملة فوراً.',
  calcTitle:'حاسبة العملات',from:'من',to:'إلى',result:'النتيجة',
  ratesTitle:'أسعار الصرف الحية',rateNote:'آخر تحديث: الآن | أسعار إرشادية — الأسعار الفعلية بالتطبيق',
  currTitle:'العملات المدعومة',
  curGroups:[
    {n:'أوروبا',cc:['EUR يورو','GBP جنيه إسترليني','CHF فرنك سويسري','DKK كرونة دنماركية','SEK كرونة سويدية','NOK كرونة نرويجية']},
    {n:'أمريكا',cc:['USD دولار أمريكي','CAD دولار كندي']},
    {n:'آسيا والمحيط',cc:['JPY ين ياباني','AUD دولار أسترالي']},
    {n:'الشرق الأوسط',cc:['AED درهم إماراتي','SAR ريال سعودي','KWD دينار كويتي','QAR ريال قطري','BHD دينار بحريني','OMR ريال عماني','JOD دينار أردني','EGP جنيه مصري','LBP ليرة لبنانية','IQD دينار عراقي','SYP ليرة سورية']},
    {n:'تركيا',cc:['TRY ليرة تركية']},
    {n:'أفريقيا',cc:['MAD درهم مغربي','TND دينار تونسي','LYD دينار ليبي','SDG جنيه سوداني']},
  ],
  advantTitle:'لماذا SDB أفضل؟',
  advants:[
    {ic:'💰',t:'سعر السوق الحقيقي',d:'لا هوامش ربح مخفية. نفس السعر الذي تشاهده بسوق العملات العالمي.'},
    {ic:'⚡',t:'صرف فوري',d:'حوّل بين عملاتك فوراً — بضغطة واحدة. حتى عطلة نهاية الأسبوع.'},
    {ic:'🔔',t:'تنبيهات الأسعار',d:'حدد سعرك المستهدف وسنبلّغك فوراً عند وصوله. لا تفوّت الفرصة.'},
    {ic:'📊',t:'رسوم بيانية حية',d:'تتبع تاريخ الأسعار، اتجاهات السوق، ومقارنات العملات.'},
  ],
  ctaTitle:'حوّل الآن',ctaSub:'افتح حسابك وابدأ بصرف العملات بأفضل الأسعار.',ctaBtn:'افتح حسابك ←',
} : {
  title:'Exchange Rates — SDB Bank',tag:'Exchange Rates',
  heroH:'Real rates.',heroEm:'No markup.',
  heroP:'Currency exchange at real market rates. No hidden markup. Convert between 30+ currencies instantly.',
  calcTitle:'Currency Calculator',from:'From',to:'To',result:'Result',
  ratesTitle:'Live Exchange Rates',rateNote:'Last update: Now | Indicative rates — actual rates in-app',
  currTitle:'Supported Currencies',
  curGroups:[
    {n:'Europe',cc:['EUR Euro','GBP British Pound','CHF Swiss Franc','DKK Danish Krone','SEK Swedish Krona','NOK Norwegian Krone']},
    {n:'Americas',cc:['USD US Dollar','CAD Canadian Dollar']},
    {n:'Asia & Pacific',cc:['JPY Japanese Yen','AUD Australian Dollar']},
    {n:'Middle East',cc:['AED UAE Dirham','SAR Saudi Riyal','KWD Kuwaiti Dinar','QAR Qatari Riyal','BHD Bahraini Dinar','OMR Omani Rial','JOD Jordanian Dinar','EGP Egyptian Pound','LBP Lebanese Pound','IQD Iraqi Dinar','SYP Syrian Pound']},
    {n:'Turkey',cc:['TRY Turkish Lira']},
    {n:'Africa',cc:['MAD Moroccan Dirham','TND Tunisian Dinar','LYD Libyan Dinar','SDG Sudanese Pound']},
  ],
  advantTitle:'Why SDB is better?',
  advants:[
    {ic:'💰',t:'Real Market Rate',d:'No hidden markup. Same rate you see on the global currency market.'},
    {ic:'⚡',t:'Instant Exchange',d:'Convert between currencies instantly — one tap. Even on weekends.'},
    {ic:'🔔',t:'Rate Alerts',d:'Set your target rate and we\'ll notify you instantly when reached. Don\'t miss out.'},
    {ic:'📊',t:'Live Charts',d:'Track rate history, market trends, and currency comparisons.'},
  ],
  ctaTitle:'Convert now',ctaSub:'Open your account and start exchanging at the best rates.',ctaBtn:'Open your account →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.calcTitle }}</h2><div class="calc"><div class="calc-row"><label class="calc-l">{{ t.from }}</label><div class="calc-in"><input v-model.number="fromAmt" type="number" class="calc-input"/><select v-model="fromCur" class="calc-sel"><option v-for="c in currencies" :key="c" :value="c">{{ c }}</option></select></div></div><div class="calc-eq">⇅</div><div class="calc-row"><label class="calc-l">{{ t.to }}</label><div class="calc-in"><div class="calc-result">{{ converted }}</div><select v-model="toCur" class="calc-sel"><option v-for="c in currencies" :key="c" :value="c">{{ c }}</option></select></div></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.currTitle }}</h2><div class="cur-groups"><div v-for="g in t.curGroups" :key="g.n" class="cur-group"><h4 class="cur-gh">{{ g.n }}</h4><div class="cur-pills"><span v-for="c in g.cc" :key="c" class="cur-pill">{{ c }}</span></div></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.advantTitle }}</h2><div class="g4"><div v-for="a in t.advants" :key="a.t" class="adv-c"><span class="adv-ic">{{ a.ic }}</span><h4 class="adv-t">{{ a.t }}</h4><p class="adv-d">{{ a.d }}</p></div></div></div></section>

<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F0F9FF}.sec-sky{background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 60px;background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.6);text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#7DD3FC}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto;line-height:1.8}
.calc{max-width:500px;margin:0 auto;background:#fff;border:1px solid rgba(14,165,233,.1);border-radius:20px;padding:32px}
.calc-row{margin-bottom:8px}.calc-l{font-size:12px;font-weight:700;color:#0EA5E9;margin-bottom:6px;display:block}
.calc-in{display:flex;gap:8px;align-items:center}
.calc-input{flex:1;padding:14px;border:1px solid rgba(14,165,233,.12);border-radius:12px;font-size:20px;font-weight:800;color:#0C4A6E;outline:none;font-family:inherit}.calc-input:focus{border-color:#0EA5E9}
.calc-result{flex:1;padding:14px;background:#F0F9FF;border-radius:12px;font-size:20px;font-weight:800;color:#0C4A6E}
.calc-sel{padding:14px;border:1px solid rgba(14,165,233,.12);border-radius:12px;font-size:14px;font-weight:700;color:#0C4A6E;background:#fff;cursor:pointer;font-family:inherit;outline:none}
.calc-eq{text-align:center;font-size:20px;color:rgba(14,165,233,.3);margin:8px 0}
.cur-groups{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.cur-group{padding:24px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:16px}
.cur-gh{font-size:13px;font-weight:800;color:#0EA5E9;margin-bottom:12px;padding-bottom:8px;border-bottom:2px solid rgba(14,165,233,.08)}
.cur-pills{display:flex;flex-direction:column;gap:6px}.cur-pill{font-size:12px;font-weight:600;color:#0C4A6E;padding:6px 0;border-bottom:1px solid rgba(14,165,233,.04)}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.adv-c{padding:28px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:18px;text-align:center}
.adv-ic{font-size:28px;display:block;margin-bottom:10px}.adv-t{font-size:14px;font-weight:800;color:#0C4A6E;margin-bottom:6px}.adv-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.75}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#0C4A6E;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.g4{grid-template-columns:repeat(2,1fr)}.cur-groups{grid-template-columns:1fr}}
</style>
