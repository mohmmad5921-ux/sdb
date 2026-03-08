<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const countries = [
  {flag:'🇸🇾',ar:'سوريا',en:'Syria',c:'SYP'},{flag:'🇦🇪',ar:'الإمارات',en:'UAE',c:'AED'},{flag:'🇸🇦',ar:'السعودية',en:'Saudi Arabia',c:'SAR'},
  {flag:'🇹🇷',ar:'تركيا',en:'Turkey',c:'TRY'},{flag:'🇩🇪',ar:'ألمانيا',en:'Germany',c:'EUR'},{flag:'🇬🇧',ar:'بريطانيا',en:'UK',c:'GBP'},
  {flag:'🇺🇸',ar:'أمريكا',en:'USA',c:'USD'},{flag:'🇫🇷',ar:'فرنسا',en:'France',c:'EUR'},{flag:'🇪🇬',ar:'مصر',en:'Egypt',c:'EGP'},
  {flag:'🇯🇴',ar:'الأردن',en:'Jordan',c:'JOD'},{flag:'🇱🇧',ar:'لبنان',en:'Lebanon',c:'LBP'},{flag:'🇮🇶',ar:'العراق',en:'Iraq',c:'IQD'},
  {flag:'🇸🇪',ar:'السويد',en:'Sweden',c:'SEK'},{flag:'🇳🇴',ar:'النرويج',en:'Norway',c:'NOK'},{flag:'🇩🇰',ar:'الدنمارك',en:'Denmark',c:'DKK'},
  {flag:'🇨🇦',ar:'كندا',en:'Canada',c:'CAD'},{flag:'🇦🇺',ar:'أستراليا',en:'Australia',c:'AUD'},{flag:'🇯🇵',ar:'اليابان',en:'Japan',c:'JPY'},
  {flag:'🇰🇷',ar:'كوريا',en:'South Korea',c:'KRW'},{flag:'🇮🇳',ar:'الهند',en:'India',c:'INR'},
];
const t = computed(() => isAr.value ? {
  title:'التحويلات — SDB Bank',tag:'حوّل لأهلك',
  heroH:'أرسل أموالك.',heroEm:'بأقل الرسوم.',heroP:'تحويلات داخلية مجانية بالكامل. دولية بـ 0.5% فقط. حتى من خارج سوريا تقدر تحوّل بلحظات لأي مكان بالعالم.',
  stats:[{v:'150+',l:'دولة'},{v:'30+',l:'عملة'},{v:'<60',l:'ثانية'},{v:'0.5%',l:'فقط'}],
  stepsTitle:'كيف تحوّل؟',
  steps:[
    {n:'01',ic:'👤',t:'أضف مستفيد',d:'أدخل بيانات المستلم — الاسم والبلد ورقم الحساب (IBAN) أو رقم الهاتف.'},
    {n:'02',ic:'💱',t:'حدد المبلغ',d:'اختر المبلغ والعملة. شاهد سعر الصرف الحقيقي والرسوم قبل الإرسال.'},
    {n:'03',ic:'🚀',t:'أرسل فوراً',d:'أكّد التحويل والمبلغ يوصل خلال ثوانٍ إلى دقائق حسب الوجهة.'},
  ],
  typesTitle:'أنواع التحويلات',
  types:[
    {ic:'⚡',t:'SEPA (أوروبا)',d:'تحويلات فورية داخل منطقة اليورو. يوصل بثوانٍ بدون رسوم إضافية.',time:'0-10 ثوانٍ',fee:'مجاني'},
    {ic:'🌐',t:'SWIFT (دولي)',d:'تحويلات دولية لأي بنك بالعالم عبر شبكة SWIFT. آمنة وموثوقة.',time:'1-3 أيام عمل',fee:'0.5%'},
    {ic:'📱',t:'داخلي (SDB)',d:'أرسل فوراً لأي عميل SDB مجاناً. فقط أدخل رقم هاتفه.',time:'فوري',fee:'مجاني'},
    {ic:'🔄',t:'تحويل متكرر',d:'جدوِل تحويلات تلقائية — أسبوعية أو شهرية. مثالي للإيجار ودعم العائلة.',time:'حسب النوع',fee:'حسب النوع'},
  ],
  syriaTitle:'حوّل لأهلك بسوريا.',
  syriaFade:'من أي مكان.',
  syriaDesc:'سواء كنت بأوروبا أو تركيا أو الخليج — ابعث لأهلك بسوريا بـ 0.5% فقط. أقل رسوم، أسرع وصول.',
  countriesTitle:'أرسل لأكثر من 150 دولة',
  faqTitle:'الأسئلة الشائعة',
  faqs:[
    {q:'كم تستغرق التحويلات الدولية؟',a:'SEPA (أوروبا) يوصل بثوانٍ. SWIFT الدولي يوصل خلال 1-3 أيام عمل حسب بلد وبنك المستلم.'},
    {q:'كم رسوم التحويل؟',a:'تحويلات SEPA والداخلية مجانية. التحويلات الدولية 0.5% من المبلغ بحد أدنى €1.'},
    {q:'هل يمكن إلغاء تحويل؟',a:'فقط التحويلات المعلقة يمكن إلغاؤها. التحويلات المكتملة لا يمكن التراجع عنها.'},
    {q:'ما الحد الأقصى للتحويل؟',a:'يعتمد على باقتك: Standard حتى €5,000/شهر، Plus €20,000، Premium €50,000، Elite €200,000.'},
    {q:'هل التحويلات آمنة؟',a:'نعم. كل تحويل محمي بتشفير 256-بت، مصادقة ثنائية، ومراقبة على مدار الساعة.'},
  ],
  ctaTitle:'ابدأ أول تحويل اليوم',ctaSub:'سجّل مجاناً وأرسل أموالك لأي مكان بالعالم بالسعر الحقيقي.',ctaBtn:'سجّل مجاناً ←',
} : {
  title:'Transfers — SDB Bank',tag:'Send to Family',
  heroH:'Send money.',heroEm:'Lowest fees.',heroP:'Free domestic transfers. International at only 0.5%. Even from outside Syria, you can transfer in seconds anywhere in the world.',
  stats:[{v:'150+',l:'Countries'},{v:'30+',l:'Currencies'},{v:'<60',l:'Seconds'},{v:'0.5%',l:'Fee only'}],
  stepsTitle:'How to transfer',
  steps:[
    {n:'01',ic:'👤',t:'Add beneficiary',d:'Enter recipient details — name, country, and IBAN or phone number.'},
    {n:'02',ic:'💱',t:'Choose amount',d:'Set amount and currency. See real exchange rate and fees before sending.'},
    {n:'03',ic:'🚀',t:'Send instantly',d:'Confirm the transfer and money arrives in seconds to minutes.'},
  ],
  typesTitle:'Transfer Types',
  types:[
    {ic:'⚡',t:'SEPA (Europe)',d:'Instant transfers within Eurozone. Arrives in seconds, no extra fees.',time:'0-10 secs',fee:'Free'},
    {ic:'🌐',t:'SWIFT (International)',d:'International transfers to any bank worldwide via SWIFT network.',time:'1-3 business days',fee:'0.5%'},
    {ic:'📱',t:'Internal (SDB)',d:'Send instantly to any SDB customer for free. Just enter their phone.',time:'Instant',fee:'Free'},
    {ic:'🔄',t:'Recurring',d:'Schedule automatic transfers — weekly or monthly. Perfect for rent and family.',time:'Varies',fee:'Varies'},
  ],
  syriaTitle:'Send to Syria.',
  syriaFade:'From anywhere.',
  syriaDesc:'Whether you\'re in Europe, Turkey, or the Gulf — send to your family in Syria at only 0.5%. Lowest fees, fastest delivery.',
  countriesTitle:'Send to 150+ countries',
  faqTitle:'FAQ',
  faqs:[
    {q:'How long do transfers take?',a:'SEPA (Europe) arrives in seconds. SWIFT international takes 1-3 business days.'},
    {q:'What are the fees?',a:'SEPA and internal transfers are free. International is 0.5% with €1 minimum.'},
    {q:'Can I cancel a transfer?',a:'Only pending transfers can be cancelled. Completed ones cannot be reversed.'},
    {q:'What\'s the maximum amount?',a:'Depends on plan: Standard €5,000/mo, Plus €20,000, Premium €50,000, Elite €200,000.'},
    {q:'Are transfers secure?',a:'Yes. 256-bit encryption, 2FA, and 24/7 fraud monitoring on every transfer.'},
  ],
  ctaTitle:'Start your first transfer today',ctaSub:'Sign up free and send money anywhere at the real exchange rate.',ctaBtn:'Sign up free →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<section class="sec"><div class="sw"><div class="stats"><div v-for="s in t.stats" :key="s.v" class="stat-i"><div class="stat-v">{{ s.v }}</div><div class="stat-l">{{ s.l }}</div></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.stepsTitle }}</h2><div class="steps"><div v-for="s in t.steps" :key="s.n" class="step"><div class="step-n">{{ s.n }}</div><div class="step-ic">{{ s.ic }}</div><h3 class="step-t">{{ s.t }}</h3><p class="step-d">{{ s.d }}</p></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.typesTitle }}</h2><div class="types"><div v-for="tp in t.types" :key="tp.t" class="typ-c"><div class="typ-ic">{{ tp.ic }}</div><h3 class="typ-t">{{ tp.t }}</h3><p class="typ-d">{{ tp.d }}</p><div class="typ-row"><div class="typ-mini"><span class="typ-ml">⏱️</span><span class="typ-mv">{{ tp.time }}</span></div><div class="typ-mini"><span class="typ-ml">💵</span><span class="typ-mv">{{ tp.fee }}</span></div></div></div></div></div></section>

<section class="sec sec-dark"><div class="sw"><div class="sec-hdr"><h2 class="t2 t2-w">{{ t.syriaTitle }}<br><span class="t2-em-w">{{ t.syriaFade }}</span></h2><p class="t2-sub t2-sub-w">{{ t.syriaDesc }}</p></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.countriesTitle }}</h2><div class="country-g"><div v-for="c in countries" :key="c.c" class="cnt-c"><span class="cnt-fl">{{ c.flag }}</span><div><div class="cnt-name">{{ isAr ? c.ar : c.en }}</div><div class="cnt-code">{{ c.c }}</div></div></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.faqTitle }}</h2><div class="faqs"><div v-for="f in t.faqs" :key="f.q" class="faq-c"><h4 class="faq-q">{{ f.q }}</h4><p class="faq-a">{{ f.a }}</p></div></div></div></section>

<section class="sec sec-dark tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="p-cta">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}
.sec{padding:100px 0}.sec-alt{background:#fafafa}.sec-dark{background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.tc{text-align:center}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px}.t2-w{color:#fff}
.t2-em-w{color:#7DD3FC}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:500px}.t2-sub-w{color:rgba(255,255,255,.3)}
.sec-hdr{margin-bottom:0}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff;text-align:center}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.7);text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}
.p-hero-em{color:rgba(255,255,255,.6)}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.55);max-width:560px;margin:0 auto;line-height:1.8}
.p-cta{display:inline-block;padding:16px 44px;background:#fff;color:#0a0a0a;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.p-cta:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,.2)}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.stat-i{padding:32px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:18px;text-align:center}
.stat-v{font-size:36px;font-weight:900;color:#0EA5E9;margin-bottom:4px}
.stat-l{font-size:13px;color:rgba(10,10,10,.3);font-weight:600}
.steps{display:grid;grid-template-columns:repeat(3,1fr);gap:24px}
.step{padding:40px 28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;text-align:center;transition:all .3s}.step:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(0,0,0,.05)}
.step-n{font-size:48px;font-weight:900;color:rgba(14,165,233,.08);line-height:1;margin-bottom:8px}
.step-ic{font-size:36px;margin-bottom:12px}
.step-t{font-size:16px;font-weight:800;margin-bottom:8px}
.step-d{font-size:13px;color:rgba(10,10,10,.4);line-height:1.75}
.types{display:grid;grid-template-columns:repeat(2,1fr);gap:16px}
.typ-c{padding:32px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;transition:all .3s}.typ-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,.04)}
.typ-ic{font-size:32px;margin-bottom:12px}
.typ-t{font-size:17px;font-weight:800;margin-bottom:8px}
.typ-d{font-size:13px;color:rgba(10,10,10,.4);line-height:1.7;margin-bottom:16px}
.typ-row{display:flex;gap:16px}
.typ-mini{display:flex;align-items:center;gap:6px}
.typ-ml{font-size:14px}
.typ-mv{font-size:13px;font-weight:700;color:#0EA5E9}
.country-g{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:10px}
.cnt-c{display:flex;align-items:center;gap:12px;padding:14px 16px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:12px;transition:all .3s}.cnt-c:hover{border-color:rgba(14,165,233,.15);transform:translateY(-2px)}
.cnt-fl{font-size:28px}
.cnt-name{font-size:13px;font-weight:700}
.cnt-code{font-size:11px;color:rgba(10,10,10,.3)}
.faqs{max-width:700px;margin:0 auto;display:flex;flex-direction:column;gap:12px}
.faq-c{padding:24px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px}
.faq-q{font-size:15px;font-weight:800;margin-bottom:8px}
.faq-a{font-size:13px;color:rgba(10,10,10,.45);line-height:1.8}
@media(max-width:768px){.stats{grid-template-columns:repeat(2,1fr)}.steps,.types{grid-template-columns:1fr}}
</style>
