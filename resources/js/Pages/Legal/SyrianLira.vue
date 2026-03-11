<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed, ref } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));

/* ─── SYP Live Rates (new lira after removing 2 zeros) ─── */
const amt = ref(1000);
const selCur = ref('USD');
const sypRates = {
  USD:138,EUR:150,GBP:174,TRY:4.02,AED:37.5,SAR:36.8,
  KWD:449,QAR:37.9,BHD:366,OMR:358,JOD:195,EGP:2.83,
  LBP:0.0015,IQD:0.1054,DKK:20.1,SEK:13.4,NOK:13.0,
  CHF:156,CAD:102,AUD:91,JPY:0.93,GBP:174
};
const curList = Object.keys(sypRates);
const converted = computed(() => (amt.value * sypRates[selCur.value]).toFixed(2));
const reverseConverted = computed(() => (amt.value / sypRates[selCur.value]).toFixed(2));

const t = computed(() => isAr.value ? {
  title:'الليرة السورية الجديدة — SDB Bank',tag:'🇸🇾 الليرة السورية الجديدة',
  heroH:'الليرة السورية.',heroEm:'عصر جديد.',
  heroP:'بعد مسح الصفرين — العملة السورية الجديدة أبسط وأقوى. تابع أسعار الصرف المباشرة وحوّل من وإلى الليرة السورية فوراً.',
  redenomTitle:'مسح الصفرين',redenomSub:'ما الذي تغيّر؟',
  redenomCards:[
    {ic:'🔢',t:'إزالة صفرين',d:'100,000 ليرة قديمة = 1,000 ليرة جديدة. نفس القيمة، رقم أبسط.'},
    {ic:'💵',t:'عملات ورقية جديدة',d:'فئات جديدة: 1, 5, 10, 50, 100, 500, 1000 ل.س بتصاميم حديثة تعكس تاريخ سوريا.'},
    {ic:'🪙',t:'عملات معدنية',d:'عودة العملات المعدنية: 1, 5, 10, 25, 50 قرش و 1 ل.س — عملية وسهلة الاستخدام.'},
    {ic:'📱',t:'رقمية بالكامل',d:'SDB Bank يدعم الليرة الجديدة رقمياً — حوّل، ادفع، واستلم بدون نقد.'},
    {ic:'🏦',t:'فترة انتقالية',d:'العملة القديمة والجديدة تُقبل معاً خلال الفترة الانتقالية لتسهيل التحول.'},
    {ic:'🛡️',t:'حماية القيمة',d:'SDB يحمي رصيدك — تحويل تلقائي للأرصدة من القديم للجديد بدون أي فقدان.'},
  ],
  calcTitle:'حاسبة الليرة السورية',calcFrom:'المبلغ بالليرة السورية',calcTo:'يعادل بـ',calcReverse:'أو أدخل',calcGet:'تحصل على',calcSyp:'ل.س',
  ratesTitle:'أسعار صرف الليرة السورية',rateNote:'أسعار إرشادية — محدّثة | السعر الفعلي بالتطبيق',
  rateCards:[
    {flag:'🇺🇸',code:'USD',name:'دولار أمريكي',buy:'138.50',sell:'137.50'},
    {flag:'🇪🇺',code:'EUR',name:'يورو',buy:'150.20',sell:'149.20'},
    {flag:'🇬🇧',code:'GBP',name:'جنيه إسترليني',buy:'174.80',sell:'173.80'},
    {flag:'🇹🇷',code:'TRY',name:'ليرة تركية',buy:'4.05',sell:'3.99'},
    {flag:'🇦🇪',code:'AED',name:'درهم إماراتي',buy:'37.70',sell:'37.30'},
    {flag:'🇸🇦',code:'SAR',name:'ريال سعودي',buy:'36.95',sell:'36.65'},
    {flag:'🇯🇴',code:'JOD',name:'دينار أردني',buy:'195.50',sell:'194.50'},
    {flag:'🇰🇼',code:'KWD',name:'دينار كويتي',buy:'450.00',sell:'448.00'},
    {flag:'🇶🇦',code:'QAR',name:'ريال قطري',buy:'38.05',sell:'37.75'},
    {flag:'🇧🇭',code:'BHD',name:'دينار بحريني',buy:'367.00',sell:'365.00'},
    {flag:'🇴🇲',code:'OMR',name:'ريال عماني',buy:'359.00',sell:'357.00'},
    {flag:'🇪🇬',code:'EGP',name:'جنيه مصري',buy:'2.85',sell:'2.81'},
  ],
  useCasesTitle:'استخدامات الليرة الجديدة',
  useCases:[
    {ic:'🛒',t:'التسوق اليومي',d:'ادفع مشترياتك ببطاقة SDB بالليرة السورية — بقالة، مطاعم، وقود، وأكثر. بدون نقد.'},
    {ic:'💸',t:'استلام الحوالات',d:'أهلك بالخارج يحوّلون لك بأي عملة وتستلم بالليرة الجديدة مباشرة بحسابك.'},
    {ic:'📱',t:'دفع الفواتير',d:'ادفع فواتير الكهرباء والماء والإنترنت والهاتف مباشرة من التطبيق (قريباً).'},
    {ic:'🏠',t:'إيجار ودفعات',d:'حوّل الإيجار والأقساط مباشرة لحساب المالك عبر SDB بدون تأخير.'},
    {ic:'💰',t:'التوفير بالليرة',d:'افتح حساب توفير بالليرة الجديدة مع أهداف ادخار ذكية وتقارير نمو.'},
    {ic:'🏪',t:'نقاط البيع',d:'للتجار — استلم المدفوعات بالليرة عبر SDB POS مباشرة بحسابك التجاري.'},
  ],
  compTitle:'مقارنة: SDB مقابل الصرافين التقليديين',
  compRows:[
    ['السعر','سعر السوق الحقيقي','هامش 2-5%'],
    ['السرعة','فوري — ثوانٍ','10-30 دقيقة انتظار'],
    ['التوفر','24/7 من التطبيق','ساعات العمل فقط'],
    ['الأمان','تشفير بنكي + بصمة','نقد — خطر سرقة'],
    ['السجل','كل عملية موثّقة','بدون إيصال'],
    ['الحد','حتى 30,000,000 ل.س','حسب توفر الصراف'],
  ],
  histTitle:'تاريخ الليرة السورية',
  histCards:[
    {y:'1919',t:'ولادة الليرة',d:'أول إصدار للليرة السورية بعد تأسيس الدولة.'},
    {y:'1947',t:'الاستقلال',d:'عملة سورية مستقلة بالكامل مرتبطة بالذهب.'},
    {y:'2011-2020',t:'فترة النزاع',d:'تراجع كبير بقيمة العملة — من 47 للدولار لأكثر من 3,000.'},
    {y:'2025',t:'إعادة الهيكلة',d:'مسح الصفرين وإصدار عملة جديدة — بداية عصر مالي جديد.'},
    {y:'2026',t:'الرقمنة مع SDB',d:'أول بنك رقمي يدعم الليرة الجديدة ويربطها بالعالم.'},
  ],
  ctaTitle:'حوّل ليرتك رقمياً',ctaSub:'افتح حسابك واستفد من أفضل أسعار صرف الليرة السورية.',ctaBtn:'افتح حسابك ←',
} : {
  title:'Syrian Lira (SYP) — SDB Bank',tag:'🇸🇾 New Syrian Lira',
  heroH:'Syrian Lira.',heroEm:'A new era.',
  heroP:'After removing two zeros — the new Syrian currency is simpler and stronger. Track live exchange rates and convert to and from Syrian Lira instantly.',
  redenomTitle:'Two Zeros Removed',redenomSub:'What changed?',
  redenomCards:[
    {ic:'🔢',t:'Two Zeros Removed',d:'100,000 old lira = 1,000 new lira. Same value, simpler number.'},
    {ic:'💵',t:'New Banknotes',d:'New denominations: 1, 5, 10, 50, 100, 500, 1000 SYP with modern designs reflecting Syria\'s heritage.'},
    {ic:'🪙',t:'Coins Return',d:'Coins are back: 1, 5, 10, 25, 50 piasters and 1 SYP — practical and easy to use.'},
    {ic:'📱',t:'Fully Digital',d:'SDB Bank supports the new lira digitally — convert, pay, and receive without cash.'},
    {ic:'🏦',t:'Transition Period',d:'Old and new currency accepted simultaneously during the transition period.'},
    {ic:'🛡️',t:'Value Protection',d:'SDB protects your balance — automatic conversion from old to new with zero loss.'},
  ],
  calcTitle:'Syrian Lira Calculator',calcFrom:'Amount in Syrian Lira',calcTo:'Equals in',calcReverse:'Or enter',calcGet:'You get',calcSyp:'SYP',
  ratesTitle:'Syrian Lira Exchange Rates',rateNote:'Indicative rates — updated | Actual rates in-app',
  rateCards:[
    {flag:'🇺🇸',code:'USD',name:'US Dollar',buy:'138.50',sell:'137.50'},
    {flag:'🇪🇺',code:'EUR',name:'Euro',buy:'150.20',sell:'149.20'},
    {flag:'🇬🇧',code:'GBP',name:'British Pound',buy:'174.80',sell:'173.80'},
    {flag:'🇹🇷',code:'TRY',name:'Turkish Lira',buy:'4.05',sell:'3.99'},
    {flag:'🇦🇪',code:'AED',name:'UAE Dirham',buy:'37.70',sell:'37.30'},
    {flag:'🇸🇦',code:'SAR',name:'Saudi Riyal',buy:'36.95',sell:'36.65'},
    {flag:'🇯🇴',code:'JOD',name:'Jordanian Dinar',buy:'195.50',sell:'194.50'},
    {flag:'🇰🇼',code:'KWD',name:'Kuwaiti Dinar',buy:'450.00',sell:'448.00'},
    {flag:'🇶🇦',code:'QAR',name:'Qatari Riyal',buy:'38.05',sell:'37.75'},
    {flag:'🇧🇭',code:'BHD',name:'Bahraini Dinar',buy:'367.00',sell:'365.00'},
    {flag:'🇴🇲',code:'OMR',name:'Omani Rial',buy:'359.00',sell:'357.00'},
    {flag:'🇪🇬',code:'EGP',name:'Egyptian Pound',buy:'2.85',sell:'2.81'},
  ],
  useCasesTitle:'New Lira Use Cases',
  useCases:[
    {ic:'🛒',t:'Daily Shopping',d:'Pay with your SDB card in Syrian Lira — groceries, restaurants, fuel, and more. Cashless.'},
    {ic:'💸',t:'Receive Remittances',d:'Your family abroad sends in any currency, you receive in new lira directly in your account.'},
    {ic:'📱',t:'Bill Payments',d:'Pay electricity, water, internet, and phone bills directly from the app (coming soon).'},
    {ic:'🏠',t:'Rent & Payments',d:'Transfer rent and installments directly to the landlord via SDB without delays.'},
    {ic:'💰',t:'Save in Lira',d:'Open a savings account in new lira with smart savings goals and growth reports.'},
    {ic:'🏪',t:'Point of Sale',d:'For merchants — receive payments in lira via SDB POS directly to your business account.'},
  ],
  compTitle:'Comparison: SDB vs Traditional Exchangers',
  compRows:[
    ['Rate','Real market rate','2-5% markup'],
    ['Speed','Instant — seconds','10-30 min wait'],
    ['Availability','24/7 from the app','Business hours only'],
    ['Security','Bank encryption + biometric','Cash — theft risk'],
    ['Records','Every transaction documented','No receipt'],
    ['Limit','Up to 30,000,000 SYP','Depends on exchanger'],
  ],
  histTitle:'History of the Syrian Lira',
  histCards:[
    {y:'1919',t:'Birth of the Lira',d:'First issuance of the Syrian Lira after the founding of the state.'},
    {y:'1947',t:'Independence',d:'Fully independent Syrian currency pegged to gold.'},
    {y:'2011-2020',t:'Conflict Period',d:'Major currency depreciation — from 47/USD to over 3,000.'},
    {y:'2025',t:'Restructuring',d:'Two zeros removed, new currency issued — a new financial era begins.'},
    {y:'2026',t:'Digitization with SDB',d:'First digital bank to support the new lira, connecting it to the world.'},
  ],
  ctaTitle:'Go digital with your lira',ctaSub:'Open your account and enjoy the best Syrian Lira exchange rates.',ctaBtn:'Open your account →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<!-- Redenomination -->
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.redenomTitle }}<br><span class="t2-em">{{ t.redenomSub }}</span></h2><div class="g3"><div v-for="(c,i) in t.redenomCards" :key="i" class="rd-c"><span class="rd-ic">{{ c.ic }}</span><h4 class="rd-t">{{ c.t }}</h4><p class="rd-d">{{ c.d }}</p></div></div></div></section>

<!-- Calculator -->
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.calcTitle }}</h2><div class="calc-box"><div class="calc-row"><label class="calc-l">{{ t.calcFrom }}</label><div class="calc-in"><input v-model.number="amt" type="number" class="calc-input"/><span class="calc-syp">{{ t.calcSyp }}</span></div></div><div class="calc-eq">⇅</div><div class="calc-row"><label class="calc-l">{{ t.calcTo }} <select v-model="selCur" class="calc-sel"><option v-for="c in curList" :key="c" :value="c">{{ c }}</option></select></label><div class="calc-result-big">{{ converted }}</div></div></div></div></section>

<!-- Live Rates Table -->
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.ratesTitle }}</h2><p class="t2-note tc">{{ t.rateNote }}</p><div class="rates-grid"><div v-for="r in t.rateCards" :key="r.code" class="rate-c"><div class="rate-top"><span class="rate-flag">{{ r.flag }}</span><div><div class="rate-code">{{ r.code }}</div><div class="rate-name">{{ r.name }}</div></div></div><div class="rate-prices"><div class="rate-col"><span class="rate-label">{{ isAr?'شراء':'Buy' }}</span><span class="rate-val">{{ r.buy }}</span></div><div class="rate-col"><span class="rate-label">{{ isAr?'بيع':'Sell' }}</span><span class="rate-val rate-sell">{{ r.sell }}</span></div></div></div></div></div></section>

<!-- Use Cases -->
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.useCasesTitle }}</h2><div class="g3"><div v-for="u in t.useCases" :key="u.t" class="uc-c"><span class="uc-ic">{{ u.ic }}</span><h4 class="uc-t">{{ u.t }}</h4><p class="uc-d">{{ u.d }}</p></div></div></div></section>

<!-- Comparison -->
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.compTitle }}</h2><div class="comp-tbl"><div class="comp-hdr"><div class="comp-f"></div><div class="comp-v comp-sdb">SDB</div><div class="comp-v comp-trad">{{ isAr?'الصرافين':'Exchangers' }}</div></div><div v-for="r in t.compRows" :key="r[0]" class="comp-row"><div class="comp-f">{{ r[0] }}</div><div class="comp-v comp-sdb">✅ {{ r[1] }}</div><div class="comp-v comp-trad">{{ r[2] }}</div></div></div></div></section>

<!-- History -->
<section class="sec sec-dark"><div class="sw"><h2 class="t2 t2-w tc">{{ t.histTitle }}</h2><div class="timeline"><div v-for="h in t.histCards" :key="h.y" class="tl-c"><div class="tl-y">{{ h.y }}</div><h4 class="tl-t">{{ h.t }}</h4><p class="tl-d">{{ h.d }}</p></div></div></div></section>

<!-- CTA -->
<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F9F3}.sec-dark{background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}.sec-sky{background:linear-gradient(135deg,#163300,#9FE870);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:32px}.t2-w{color:#fff}.t2-em{color:#9FE870;font-size:.7em}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.t2-note{font-size:12px;color:rgba(10,10,10,.25);margin-top:-24px;margin-bottom:32px}
.p-hero{padding:160px 0 60px;background:linear-gradient(135deg,#065F46 0%,#047857 50%,#10B981 100%);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.7);margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#6EE7B7}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.55);max-width:560px;margin:0 auto;line-height:1.8}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.rd-c{padding:28px;background:#fff;border:1px solid rgba(16,185,129,.08);border-radius:18px;text-align:center;transition:all .3s}.rd-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(16,185,129,.08)}
.rd-ic{font-size:32px;display:block;margin-bottom:12px}.rd-t{font-size:15px;font-weight:800;color:#065F46;margin-bottom:6px}.rd-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.calc-box{max-width:500px;margin:0 auto;background:#fff;border:2px solid rgba(16,185,129,.1);border-radius:24px;padding:36px}
.calc-row{margin-bottom:12px}.calc-l{font-size:13px;font-weight:700;color:#047857;margin-bottom:8px;display:flex;align-items:center;gap:8px}
.calc-in{display:flex;gap:8px;align-items:center}
.calc-input{flex:1;padding:16px;border:1px solid rgba(16,185,129,.15);border-radius:14px;font-size:24px;font-weight:900;color:#065F46;outline:none;font-family:inherit}.calc-input:focus{border-color:#10B981}
.calc-syp{font-size:14px;font-weight:800;color:#047857;padding:16px;background:rgba(16,185,129,.06);border-radius:14px}
.calc-sel{padding:8px 12px;border:1px solid rgba(16,185,129,.15);border-radius:10px;font-size:14px;font-weight:700;color:#065F46;background:#fff;cursor:pointer;font-family:inherit;outline:none}
.calc-eq{text-align:center;font-size:20px;color:rgba(16,185,129,.3);margin:8px 0}
.calc-result-big{padding:16px;background:#ECFDF5;border-radius:14px;font-size:28px;font-weight:900;color:#065F46;text-align:center}
.rates-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.rate-c{padding:20px;background:#fff;border:1px solid rgba(16,185,129,.06);border-radius:16px;transition:all .3s}.rate-c:hover{transform:translateY(-2px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.rate-top{display:flex;align-items:center;gap:10px;margin-bottom:14px}
.rate-flag{font-size:28px}.rate-code{font-size:14px;font-weight:900;color:#065F46}.rate-name{font-size:11px;color:rgba(10,10,10,.3)}
.rate-prices{display:flex;gap:12px}.rate-col{flex:1;text-align:center;padding:8px;background:#F0FDF4;border-radius:10px}
.rate-label{font-size:10px;font-weight:700;color:#047857;display:block;margin-bottom:2px}
.rate-val{font-size:16px;font-weight:900;color:#065F46}.rate-sell{color:#DC2626}
.uc-c{padding:28px;background:#fff;border:1px solid rgba(16,185,129,.08);border-radius:18px;text-align:center;transition:all .3s}.uc-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(16,185,129,.06)}
.uc-ic{font-size:28px;display:block;margin-bottom:10px}.uc-t{font-size:14px;font-weight:800;color:#065F46;margin-bottom:6px}.uc-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.75}
.comp-tbl{max-width:700px;margin:0 auto;border:1px solid rgba(16,185,129,.08);border-radius:20px;overflow:hidden}
.comp-hdr{display:grid;grid-template-columns:1fr 1fr 1fr;background:#F0FDF4}
.comp-hdr .comp-f,.comp-hdr .comp-v{padding:14px 16px;font-size:13px;font-weight:800;color:#065F46}
.comp-row{display:grid;grid-template-columns:1fr 1fr 1fr;border-top:1px solid rgba(16,185,129,.06)}
.comp-f{padding:12px 16px;font-size:13px;font-weight:700;color:#065F46}
.comp-v{padding:12px 16px;font-size:12px;color:rgba(10,10,10,.5)}
.comp-sdb{color:#047857;font-weight:600}.comp-trad{color:rgba(10,10,10,.3)}
.timeline{display:flex;gap:16px;overflow-x:auto;padding-bottom:16px}
.tl-c{min-width:200px;padding:24px;background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.08);border-radius:16px;flex-shrink:0}
.tl-y{font-size:24px;font-weight:900;color:#6EE7B7;margin-bottom:8px}
.tl-t{font-size:14px;font-weight:800;color:#fff;margin-bottom:6px}.tl-d{font-size:12px;color:rgba(255,255,255,.4);line-height:1.6}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#065F46;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:900px){.g3{grid-template-columns:repeat(2,1fr)}.rates-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:600px){.g3,.rates-grid{grid-template-columns:1fr}.timeline{flex-direction:column}.tl-c{min-width:auto}}
</style>
