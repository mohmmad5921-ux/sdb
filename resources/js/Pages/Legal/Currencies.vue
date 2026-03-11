<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));

const pairs = [
  {from:'EUR',to:'USD',rate:'1.0842',f1:'🇪🇺',f2:'🇺🇸'},{from:'EUR',to:'GBP',rate:'0.8617',f1:'🇪🇺',f2:'🇬🇧'},
  {from:'EUR',to:'CHF',rate:'0.9486',f1:'🇪🇺',f2:'🇨🇭'},{from:'EUR',to:'TRY',rate:'34.82',f1:'🇪🇺',f2:'🇹🇷'},
  {from:'EUR',to:'AED',rate:'3.9815',f1:'🇪🇺',f2:'🇦🇪'},{from:'EUR',to:'SAR',rate:'4.0658',f1:'🇪🇺',f2:'🇸🇦'},
  {from:'EUR',to:'JPY',rate:'162.35',f1:'🇪🇺',f2:'🇯🇵'},{from:'EUR',to:'CAD',rate:'1.4723',f1:'🇪🇺',f2:'🇨🇦'},
  {from:'EUR',to:'NOK',rate:'11.58',f1:'🇪🇺',f2:'🇳🇴'},{from:'EUR',to:'DKK',rate:'7.4589',f1:'🇪🇺',f2:'🇩🇰'},
  {from:'EUR',to:'SEK',rate:'11.24',f1:'🇪🇺',f2:'🇸🇪'},{from:'EUR',to:'AUD',rate:'1.6548',f1:'🇪🇺',f2:'🇦🇺'},
];
const currencies = [
  {name:'يورو',en:'Euro',code:'EUR',flag:'🇪🇺',sym:'€'},{name:'دولار',en:'US Dollar',code:'USD',flag:'🇺🇸',sym:'$'},
  {name:'جنيه إسترليني',en:'British Pound',code:'GBP',flag:'🇬🇧',sym:'£'},{name:'فرنك سويسري',en:'Swiss Franc',code:'CHF',flag:'🇨🇭',sym:'Fr'},
  {name:'ين ياباني',en:'Japanese Yen',code:'JPY',flag:'🇯🇵',sym:'¥'},{name:'درهم إماراتي',en:'UAE Dirham',code:'AED',flag:'🇦🇪',sym:'د.إ'},
  {name:'ريال سعودي',en:'Saudi Riyal',code:'SAR',flag:'🇸🇦',sym:'﷼'},{name:'ليرة تركية',en:'Turkish Lira',code:'TRY',flag:'🇹🇷',sym:'₺'},
  {name:'دولار كندي',en:'Canadian Dollar',code:'CAD',flag:'🇨🇦',sym:'C$'},{name:'دولار أسترالي',en:'Australian Dollar',code:'AUD',flag:'🇦🇺',sym:'A$'},
  {name:'كرونة سويدية',en:'Swedish Krona',code:'SEK',flag:'🇸🇪',sym:'kr'},{name:'كرونة نرويجية',en:'Norwegian Krone',code:'NOK',flag:'🇳🇴',sym:'kr'},
  {name:'كرونة دنماركية',en:'Danish Krone',code:'DKK',flag:'🇩🇰',sym:'kr'},{name:'زلوتي بولندي',en:'Polish Złoty',code:'PLN',flag:'🇵🇱',sym:'zł'},
  {name:'كورونا تشيكية',en:'Czech Koruna',code:'CZK',flag:'🇨🇿',sym:'Kč'},{name:'فورنت مجري',en:'Hungarian Forint',code:'HUF',flag:'🇭🇺',sym:'Ft'},
  {name:'لاي روماني',en:'Romanian Leu',code:'RON',flag:'🇷🇴',sym:'lei'},{name:'راند جنوب أفريقي',en:'South African Rand',code:'ZAR',flag:'🇿🇦',sym:'R'},
  {name:'دولار سنغافوري',en:'Singapore Dollar',code:'SGD',flag:'🇸🇬',sym:'S$'},{name:'دولار هونغ كونغ',en:'Hong Kong Dollar',code:'HKD',flag:'🇭🇰',sym:'HK$'},
  {name:'وون كوري',en:'Korean Won',code:'KRW',flag:'🇰🇷',sym:'₩'},{name:'بات تايلاندي',en:'Thai Baht',code:'THB',flag:'🇹🇭',sym:'฿'},
  {name:'بيزو مكسيكي',en:'Mexican Peso',code:'MXN',flag:'🇲🇽',sym:'$'},{name:'روبية هندية',en:'Indian Rupee',code:'INR',flag:'🇮🇳',sym:'₹'},
];
const t = computed(() => isAr.value ? {
  title:'العملات — SDB Bank',tag:'أكثر من 30 عملة',
  heroH:'حوّل بأسعار',heroEm:'السوق الحقيقية.',heroP:'لا رسوم مخفية ولا هوامش ربح على الأسعار. السعر اللي تشوفه هو السعر اللي تاخذه.',
  ratesTitle:'أسعار الصرف الحية',ratesSub:'محدّثة لحظياً — ما تشوفه هو ما تحصل عليه.',
  curTitle:'العملات المدعومة',
  whyTitle:'ليش SDB للعملات؟',
  whyCards:[
    {ic:'💱',t:'أسعار حقيقية',d:'لا هوامش ربح مخفية. سعر السوق الحقيقي بدون زيادات.'},
    {ic:'⚡',t:'تحويل فوري',d:'حوّل بين العملات بثوانٍ مباشرة من حسابك.'},
    {ic:'🔒',t:'آمن 100%',d:'تشفير متقدم وحماية على مدار الساعة لكل معاملاتك.'},
  ],
  ctaTitle:'ابدأ التداول اليوم',ctaSub:'افتح حسابك وحوّل بين 30+ عملة بالسعر الحقيقي.',ctaBtn:'افتح حسابك المجاني ←',
} : {
  title:'Currencies — SDB Bank',tag:'30+ Currencies',
  heroH:'Convert at real',heroEm:'market rates.',heroP:'No hidden fees or markup on rates. The price you see is the price you get.',
  ratesTitle:'Live Exchange Rates',ratesSub:'Updated in real-time — what you see is what you get.',
  curTitle:'Supported Currencies',
  whyTitle:'Why SDB for currencies?',
  whyCards:[
    {ic:'💱',t:'Real rates',d:'No hidden markup. The real market rate without additions.'},
    {ic:'⚡',t:'Instant conversion',d:'Convert between currencies in seconds from your account.'},
    {ic:'🔒',t:'100% secure',d:'Advanced encryption and round-the-clock protection.'},
  ],
  ctaTitle:'Start converting today',ctaSub:'Open your account and convert between 30+ currencies at the real rate.',ctaBtn:'Open free account →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>
<section class="sec"><div class="sw"><h2 class="t2">{{ t.ratesTitle }}</h2><p class="t2-sub">{{ t.ratesSub }}</p><div class="fx-grid"><div v-for="p in pairs" :key="p.to" class="fx-c"><div class="fx-pair"><span>{{ p.f1 }}</span><span class="fx-ar">→</span><span>{{ p.f2 }}</span></div><div class="fx-code">{{ p.from }}/{{ p.to }}</div><div class="fx-rate">{{ p.rate }}</div></div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2">{{ t.curTitle }}</h2><div class="cur-grid"><div v-for="c in currencies" :key="c.code" class="cur-c"><span class="cur-fl">{{ c.flag }}</span><div><div class="cur-code">{{ c.code }}</div><div class="cur-name">{{ isAr ? c.name : c.en }}</div></div><div class="cur-sym">{{ c.sym }}</div></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.whyTitle }}</h2><div class="g3"><div v-for="w in t.whyCards" :key="w.t" class="why-c"><span class="why-ic">{{ w.ic }}</span><h3 class="why-t">{{ w.t }}</h3><p class="why-d">{{ w.d }}</p></div></div></div></section>
<section class="sec sec-dark tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="p-cta">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}
.sec{padding:100px 0}.sec-alt{background:#fafafa}.sec-dark{background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.tc{text-align:center}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.t2-w{color:#fff}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:500px;margin-bottom:32px}.t2-sub-w{color:rgba(255,255,255,.3)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#0a0a0a 0%,#162d4d 100%);color:#fff;text-align:center}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#9FE870;text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}
.p-hero-em{color:#9FE870}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.45);max-width:560px;margin:0 auto;line-height:1.8}
.p-cta{display:inline-block;padding:16px 44px;background:#fff;color:#0a0a0a;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.p-cta:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,.2)}
.fx-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:10px}
.fx-c{padding:16px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:14px;display:flex;align-items:center;gap:12px;transition:all .3s}.fx-c:hover{border-color:rgba(159,232,112,.15);transform:translateY(-2px)}
.fx-pair{display:flex;align-items:center;gap:4px;font-size:20px}
.fx-ar{color:rgba(10,10,10,.15);font-size:14px}
.fx-code{font-size:13px;font-weight:700;flex:1}
.fx-rate{font-size:14px;font-weight:800;color:#9FE870}
.cur-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:8px}
.cur-c{display:flex;align-items:center;gap:12px;padding:14px 16px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:12px;transition:all .3s}.cur-c:hover{border-color:rgba(159,232,112,.15);transform:translateY(-1px)}
.cur-fl{font-size:24px}
.cur-code{font-size:14px;font-weight:800}
.cur-name{font-size:11px;color:rgba(10,10,10,.4)}
.cur-sym{margin-inline-start:auto;font-size:16px;font-weight:800;color:rgba(10,10,10,.15)}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.why-c{padding:36px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;text-align:center;transition:all .3s}.why-c:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(0,0,0,.05)}
.why-ic{font-size:32px;display:block;margin-bottom:12px}
.why-t{font-size:16px;font-weight:800;margin-bottom:8px}
.why-d{font-size:13px;color:rgba(10,10,10,.35);line-height:1.7}
@media(max-width:768px){.g3{grid-template-columns:1fr}.fx-grid{grid-template-columns:1fr 1fr}}
</style>
