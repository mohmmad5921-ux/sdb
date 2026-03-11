<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed, onMounted, onUnmounted } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const lang = inject('lang', ref('ar'));
const isAr = inject('isAr', computed(() => true));
const launchDate = new Date('2026-03-22T00:00:00');
const cd = ref({ d:0, h:0, m:0, s:0 });
let ti;
function tick(){const x=launchDate-new Date();if(x<=0)return;cd.value={d:Math.floor(x/864e5),h:Math.floor(x%864e5/36e5),m:Math.floor(x%36e5/6e4),s:Math.floor(x%6e4/1e3)}}
const em = ref('');const done = ref(false);const emailErr = ref('');const submitting = ref(false);
async function submitEmail() {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if(!em.value || !regex.test(em.value)) { emailErr.value = isAr.value ? 'أدخل بريد صحيح' : 'Enter a valid email'; return; }
  emailErr.value = '';submitting.value = true;
  try {
    const res = await fetch('/waitlist', { method: 'POST', headers: { 'Content-Type': 'application/json', 'Accept': 'application/json', 'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '' }, body: JSON.stringify({ email: em.value, source: 'hero' }) });
    const data = await res.json();
    if(res.ok && data.success) { done.value = true; } else { emailErr.value = isAr.value ? 'حدث خطأ' : 'Something went wrong'; }
  } catch(e) { emailErr.value = isAr.value ? 'خطأ بالاتصال' : 'Connection error'; }
  submitting.value = false;
}
const cAmt = ref(1000); const cFrom = ref('EUR'); const cTo = ref('SYP');
const cRates = {EUR:1,USD:1.08,GBP:0.86,SYP:13500,TRY:34.2,AED:3.97,SAR:4.05,DKK:7.46};
const cResult = computed(() => {const r=(cRates[cTo.value]||1)/(cRates[cFrom.value]||1);const v=cAmt.value*r; return v>=1000?Math.round(v).toLocaleString('en-US'):v.toFixed(2)});
const cRate = computed(() => {const r=(cRates[cTo.value]||1)/(cRates[cFrom.value]||1);return r>=100?Math.round(r).toLocaleString('en-US'):r.toFixed(4)});
function swapCurr(){const tmp=cFrom.value;cFrom.value=cTo.value;cTo.value=tmp}
const counted = ref(false);
const counters = ref({users:0,countries:0,currencies:0,uptime:0});
function animateCounters(){if(counted.value)return;counted.value=true;
  const targets={users:50000,countries:170,currencies:70,uptime:99.9};
  Object.keys(targets).forEach(k=>{let start=0;const end=targets[k];const dur=2000;const step=16;const inc=end*step/dur;
    const timer=setInterval(()=>{start+=inc;if(start>=end){counters.value[k]=end;clearInterval(timer)}else{counters.value[k]=Math.floor(start)}},step)})}
const faqOpen = ref(-1);
function toggleFaq(i){faqOpen.value = faqOpen.value === i ? -1 : i}
let obs;
onMounted(()=>{tick();ti=setInterval(tick,1e3);
  obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting){x.target.classList.add('vi');if(x.target.classList.contains('counter-trigger'))animateCounters();if(x.target.hasAttribute('data-stagger')){x.target.querySelectorAll(':scope > *').forEach((ch,i)=>{setTimeout(()=>ch.classList.add('vi'), i*120)})}}}),{threshold:.08,rootMargin:'0px 0px -40px 0px'});
  document.querySelectorAll('.an,.an-l,.an-r,.an-s,.counter-trigger').forEach(el=>obs.observe(el));
  document.querySelectorAll('[data-stagger]').forEach(p=>{p.querySelectorAll(':scope > *').forEach(ch=>ch.classList.add('an'));obs.observe(p)});
});
onUnmounted(()=>{clearInterval(ti);obs?.disconnect()});
const t = computed(() => isAr.value ? {
  tag:'⭐ 4.9 من 100,000+ تقييم',hd1:'حوّل أموالك',hd2:'بذكاء',
  sub:'أرسل واستقبل الأموال بسعر الصرف الحقيقي. وفّر حتى 90% مقارنة بالبنوك التقليدية.',
  days:'يوم',hrs:'ساعة',min:'دقيقة',sec:'ثانية',
  emailPh:'بريدك الإلكتروني...',notify:'سجّل مبكراً',emailDone:'✓ تم! سنبلغك فور الإطلاق.',
  cta1:'ابدأ مجاناً',cta2:'شاهد كيف يعمل',
  heroStats:[{v:'14M+',l:'عميل'},{v:'70+',l:'عملة'},{v:'170+',l:'دولة'}],
  badges:['⚡ تحويل فوري','🔒 آمن 100%'],
  convTitle:'💱 حاسبة التحويل',convSend:'ترسل',convGet:'تحصل على',convRate:'السعر:',convBtn:'حوّل الآن ←',
  howTitle:'أرسل المال في 4 خطوات بسيطة',howSub:'لا تعقيد، لا رسوم خفية. فقط طريقة بسيطة وشفافة.',
  steps:[{n:'01',t:'أنشئ حسابك',d:'التسجيل مجاني ويستغرق دقيقتين فقط.'},{n:'02',t:'أضف المستلم',d:'أدخل تفاصيل المستلم وحسابه البنكي.'},{n:'03',t:'اختر المبلغ',d:'شاهد سعر الصرف الحقيقي والرسوم.'},{n:'04',t:'أرسل فوراً',d:'أكد التحويل وسيصل المال خلال ثوانٍ.'}],
  featTag:'المميزات',featTitle:'كل ما تحتاجه في مكان واحد',featSub:'منصة مصرفية متكاملة توفر لك كل الأدوات لإدارة أموالك بذكاء',
  feats:[{ic:'⚡',t:'تحويلات فورية',d:'74% من التحويلات تصل خلال 20 ثانية'},{ic:'🔒',t:'حماية متقدمة',d:'تشفير على مستوى البنوك'},{ic:'💰',t:'السعر الحقيقي',d:'سعر الصرف بدون إضافات'},{ic:'🌍',t:'170+ دولة',d:'أرسل المال لأي مكان بالعالم'},{ic:'💳',t:'بطاقات ذكية',d:'بطاقات مجانية للدفع والسحب'},{ic:'📱',t:'تطبيق سهل',d:'أدر كل شيء من هاتفك'},{ic:'🕐',t:'دعم 24/7',d:'فريق دعم متاح على مدار الساعة'},{ic:'🐷',t:'وفر أكثر',d:'وفر حتى 90% من الرسوم'}],
  compTag:'قارن الأسعار',compTitle:'وفّر حتى 90% من رسوم التحويل',compSub:'البنوك تخفي الرسوم في سعر الصرف. نحن نقدم السعر الحقيقي بشفافية.',
  compSdb:{n:'SDB Bank',rec:'موصى به',amount:'14,250,000',points:['سعر الصرف الحقيقي','رسوم 2.99$ فقط','يصل خلال ثوانٍ']},
  compBank:{n:'بنك تقليدي',amount:'13,800,000',less:'- 450,000 أقل',points:['هامش 3-5% مخفي','رسوم 25$+','2-5 أيام عمل']},
  compWu:{n:'Western Union',amount:'13,500,000',less:'- 750,000 أقل',points:['سعر غير تنافسي +5%','رسوم 35$+','1-3 أيام']},
  testTag:'آراء العملاء',testTitle:'يثق بنا الملايين',testSub:'اكتشف لماذا يختار عملاؤنا SDB Bank',
  tests:[{n:'أحمد محمد',r:'رجل أعمال',q:'خدمة ممتازة وسريعة. التحويلات تصل في ثوانٍ. أنصح الجميع بتجربة SDB.',a:'A'},{n:'سارة العلي',r:'مهندسة برمجيات',q:'تطبيق سهل ورسوم شفافة. أفضل تجربة مصرفية رقمية.',a:'S'},{n:'محمود حسن',r:'طبيب',q:'أستخدم SDB منذ سنة. الأمان والسرعة لا مثيل لهما.',a:'M'},{n:'نور الدين',r:'مدير مشاريع',q:'وفرت الكثير مقارنة بالبنوك التقليدية.',a:'N'}],
  testStats:[{v:'4.9/5',l:'تقييم App Store'},{v:'100K+',l:'تقييمات'},{v:'14M+',l:'عميل سعيد'},{v:'99%',l:'رضا العملاء'}],
  faqTag:'الأسئلة الشائعة',faqTitle:'كل ما تريد معرفته',
  faqs:[{q:'كيف أفتح حساب في SDB Bank؟',a:'التسجيل مجاني ويستغرق دقيقتين. كل ما تحتاجه بريدك الإلكتروني وإثبات هوية.'},{q:'ما هي رسوم التحويل؟',a:'رسومنا تبدأ من 0.3% فقط — أقل بكثير من البنوك التقليدية التي تأخذ 3-5%.'},{q:'كم يستغرق التحويل؟',a:'74% من التحويلات تصل خلال 20 ثانية. الباقي خلال ساعات قليلة.'},{q:'هل أموالي آمنة؟',a:'نعم. نستخدم تشفير AES-256 وحماية ثنائية العامل. أموالك محمية بمعايير أوروبية صارمة.'},{q:'ما هي الدول المدعومة؟',a:'ندعم التحويلات إلى 170+ دولة حول العالم بما فيها سوريا والدول العربية.'}],
  ctaTag:'حمّل التطبيق',ctaTitle:'البنك في جيبك',ctaSub:'حمّل تطبيق SDB Bank وأرسل الأموال من أي مكان. متوفر على iOS و Android.',
  statsTitle:'أرقام تتحدث.',stat1L:'عميل مسجّل',stat2L:'دولة مدعومة',stat3L:'عملة',stat4L:'وقت تشغيل %',
  footServices:'خدماتنا',footAbout:'عن SDB',footHelp:'المساعدة',footLegal:'قانوني',
  footDesc:'نحن نجعل إرسال الأموال للخارج سهلاً وسريعاً وبتكلفة أقل.',
} : {
  tag:'⭐ 4.9 from 100,000+ reviews',hd1:'Move your money',hd2:'smarter',
  sub:'Send and receive money at the real exchange rate. Save up to 90% compared to banks.',
  days:'Days',hrs:'Hrs',min:'Min',sec:'Sec',
  emailPh:'Your email...',notify:'Sign up early',emailDone:'✓ Done! We\'ll notify you at launch.',
  cta1:'Get started free',cta2:'See how it works',
  heroStats:[{v:'14M+',l:'Customers'},{v:'70+',l:'Currencies'},{v:'170+',l:'Countries'}],
  badges:['⚡ Instant transfer','🔒 100% secure'],
  convTitle:'💱 Transfer Calculator',convSend:'You send',convGet:'They get',convRate:'Rate:',convBtn:'Convert now →',
  howTitle:'Send money in 4 simple steps',howSub:'No complexity, no hidden fees. Just a simple, transparent way.',
  steps:[{n:'01',t:'Create your account',d:'Signing up is free and takes just 2 minutes.'},{n:'02',t:'Add your recipient',d:'Enter recipient details and bank account.'},{n:'03',t:'Choose the amount',d:'See the real exchange rate and fees.'},{n:'04',t:'Send instantly',d:'Confirm and money arrives in seconds.'}],
  featTag:'FEATURES',featTitle:'Everything you need in one place',featSub:'A complete banking platform with all the tools to manage your money smartly',
  feats:[{ic:'⚡',t:'Instant transfers',d:'74% of transfers arrive in under 20 seconds'},{ic:'🔒',t:'Advanced security',d:'Bank-level encryption and fraud protection'},{ic:'💰',t:'Real exchange rate',d:'We use the real rate with no markup'},{ic:'🌍',t:'170+ countries',d:'Send money almost anywhere in the world'},{ic:'💳',t:'Smart cards',d:'Free cards to pay and withdraw anywhere'},{ic:'📱',t:'Easy app',d:'Manage everything easily from your phone'},{ic:'🕐',t:'24/7 support',d:'Support team available around the clock'},{ic:'🐷',t:'Save more',d:'Save up to 90% compared to banks'}],
  compTag:'COMPARE PRICES',compTitle:'Save up to 90% on transfer fees',compSub:'Banks hide fees in exchange rates. We offer the real rate with complete transparency.',
  compSdb:{n:'SDB Bank',rec:'Recommended',amount:'14,250,000',points:['Real exchange rate','Only $2.99 fee','Arrives in seconds']},
  compBank:{n:'Traditional Bank',amount:'13,800,000',less:'- 450,000 SYP less',points:['Marked up rate (+3%)','$25+ fees','2-5 business days']},
  compWu:{n:'Western Union',amount:'13,500,000',less:'- 750,000 SYP less',points:['Poor rate (+5%)','$35+ fees','1-3 days']},
  testTag:'TESTIMONIALS',testTitle:'Trusted by millions',testSub:'Discover why customers choose SDB Bank',
  tests:[{n:'Ahmad Mohammad',r:'Businessman',q:'Excellent and fast service. Transfers arrive in seconds. I recommend SDB.',a:'A'},{n:'Sara Al-Ali',r:'Software Engineer',q:'Easy to use app with transparent fees. Best digital banking experience.',a:'S'},{n:'Mahmoud Hassan',r:'Doctor',q:'I\'ve been using SDB for a year. Security and speed are unmatched.',a:'M'},{n:'Nour Al-Din',r:'Project Manager',q:'Saved a lot on fees compared to traditional banks.',a:'N'}],
  testStats:[{v:'4.9/5',l:'App Store Rating'},{v:'100K+',l:'Reviews'},{v:'14M+',l:'Happy Customers'},{v:'99%',l:'Satisfaction Rate'}],
  faqTag:'FAQ',faqTitle:'Everything you need to know',
  faqs:[{q:'How do I open an SDB Bank account?',a:'Registration is free and takes 2 minutes. All you need is your email and ID.'},{q:'What are the transfer fees?',a:'Our fees start from just 0.3% — much less than traditional banks charging 3-5%.'},{q:'How long does a transfer take?',a:'74% of transfers arrive in under 20 seconds. The rest within a few hours.'},{q:'Is my money safe?',a:'Yes. We use AES-256 encryption and two-factor authentication. Protected by strict European standards.'},{q:'Which countries are supported?',a:'We support transfers to 170+ countries worldwide including Syria and Arab countries.'}],
  ctaTag:'DOWNLOAD APP',ctaTitle:'Banking in your pocket',ctaSub:'Download the SDB Bank app and send money from anywhere. Available on iOS and Android.',
  statsTitle:'Numbers that speak.',stat1L:'Registered users',stat2L:'Countries',stat3L:'Currencies',stat4L:'Uptime %',
  footServices:'Services',footAbout:'About',footHelp:'Help',footLegal:'Legal',
  footDesc:'We make sending money abroad easy, fast, and affordable.',
});
const stepColors = ['from-blue-500 to-blue-600','from-purple-500 to-purple-600','from-amber-500 to-orange-500','from-green-500 to-emerald-500'];
const stepBgs = ['bg-blue-50','bg-purple-50','bg-amber-50','bg-green-50'];
const testColors = ['from-blue-400 to-blue-500','from-purple-400 to-purple-500','from-green-400 to-green-500','from-orange-400 to-orange-500'];
</script>
<template>
<Head :title="isAr?'SDB Bank — أول بنك إلكتروني سوري':'SDB Bank — First Syrian Digital Bank'"><meta :content="isAr?'SDB Bank — الأسرع والأوفر لتحويل الأموال':'SDB Bank — Fastest & cheapest money transfers'" name="description"/></Head>

<!-- ═══ HERO ═══ -->
<section class="v-hero"><div class="v-hero-bg"></div><div class="v-hero-circles"><div class="v-circle v-c1"></div><div class="v-circle v-c2"></div><div class="v-circle v-c3"></div></div>
<div class="sw v-hero-grid">
  <div class="v-hero-left">
    <div class="v-badge an">{{ t.tag }}</div>
    <h1 class="v-h1 an" style="transition-delay:100ms">{{ t.hd1 }}<br><span class="v-h1-em">{{ t.hd2 }}</span></h1>
    <p class="v-hero-p an" style="transition-delay:200ms">{{ t.sub }}</p>
    <div class="v-badges an" style="transition-delay:250ms"><span v-for="b in t.badges" :key="b" class="v-mini-badge">{{ b }}</span></div>
    <div class="v-hero-cd an" style="transition-delay:300ms"><div v-for="(lb,k) in {d:t.days,h:t.hrs,m:t.min,s:t.sec}" :key="k" class="vcd-b"><div class="vcd-n">{{ String(cd[k]).padStart(2,'0') }}</div><div class="vcd-l">{{ lb }}</div></div></div>
    <div class="v-hero-eml an" style="transition-delay:400ms"><template v-if="!done"><input v-model="em" type="email" :placeholder="t.emailPh" class="veml-i" @keyup.enter="submitEmail"/><button @click="submitEmail" class="veml-b">{{ t.notify }}</button></template><div v-else class="veml-ok">✨ {{ t.emailDone }}</div><div v-if="emailErr" class="veml-err">{{ emailErr }}</div></div>
    <div class="v-hero-stats an" style="transition-delay:500ms"><div v-for="s in t.heroStats" :key="s.l" class="vhs"><div class="vhs-v">{{ s.v }}</div><div class="vhs-l">{{ s.l }}</div></div></div>
  </div>
  <div class="v-hero-right an-r">
    <div class="v-conv">
      <div class="vc-head">{{ t.convTitle }}</div>
      <div class="vc-field"><label class="vc-lbl">{{ t.convSend }}</label><div class="vc-row"><select v-model="cFrom" class="vc-sel"><option v-for="c in Object.keys(cRates)" :key="c" :value="c">{{ c }}</option></select><input v-model.number="cAmt" type="number" class="vc-inp"/></div></div>
      <div class="vc-swap" @click="swapCurr">⇅</div>
      <div class="vc-field"><label class="vc-lbl">{{ t.convGet }}</label><div class="vc-row"><select v-model="cTo" class="vc-sel"><option v-for="c in Object.keys(cRates)" :key="c" :value="c">{{ c }}</option></select><div class="vc-res">{{ cResult }}</div></div></div>
      <div class="vc-rate">{{ t.convRate }} 1 {{ cFrom }} = {{ cRate }} {{ cTo }}</div>
      <Link href="/exchange-rates" class="vc-cta">{{ t.convBtn }}</Link>
    </div>
  </div>
</div></section>

<!-- ═══ MARQUEE ═══ -->
<div class="v-mq"><div class="v-mq-track"><span v-for="(p,i) in ['SDB Bank','Mastercard','Apple Pay','Google Pay','SWIFT','SEPA','Syria 🇸🇾','Damascus','SDB Bank','Mastercard','Apple Pay','Google Pay','SWIFT','SEPA','Syria 🇸🇾','Damascus']" :key="i" class="v-mq-i">{{ p }}</span></div></div>

<!-- ═══ HOW IT WORKS ═══ -->
<section class="v-sec"><div class="sw">
  <div class="v-sec-hdr an"><span class="v-pill">{{ isAr?'كيف يعمل':'HOW IT WORKS' }}</span><h2 class="v-t2">{{ t.howTitle }}</h2><p class="v-t2-sub">{{ t.howSub }}</p></div>
  <div class="v-steps" data-stagger><div v-for="(s,i) in t.steps" :key="i" class="v-step">
    <div class="v-step-num" :class="stepColors[i]">{{ s.n }}</div>
    <div class="v-step-card" :class="stepBgs[i]"><h3 class="v-step-t">{{ s.t }}</h3><p class="v-step-d">{{ s.d }}</p></div>
  </div></div>
</div></section>

<!-- ═══ FEATURES ═══ -->
<section class="v-sec v-sec-light"><div class="sw">
  <div class="v-sec-hdr an"><span class="v-pill">{{ t.featTag }}</span><h2 class="v-t2">{{ t.featTitle }}</h2><p class="v-t2-sub">{{ t.featSub }}</p></div>
  <div class="v-feats" data-stagger><div v-for="f in t.feats" :key="f.t" class="v-feat">
    <span class="v-feat-ic">{{ f.ic }}</span><h3 class="v-feat-t">{{ f.t }}</h3><p class="v-feat-d">{{ f.d }}</p>
  </div></div>
</div></section>

<!-- ═══ COMPARISON ═══ -->
<section class="v-sec v-sec-green"><div class="sw">
  <div class="v-sec-hdr an"><span class="v-pill">{{ t.compTag }}</span><h2 class="v-t2">{{ t.compTitle }}</h2><p class="v-t2-sub">{{ t.compSub }}</p></div>
  <div class="v-comp" data-stagger>
    <div class="v-comp-card v-comp-best"><div class="v-comp-badge">{{ isAr?'الأفضل قيمة':'BEST VALUE' }}</div><div class="v-comp-logo"><div class="v-comp-sdb-logo">SDB</div><div><h3 class="v-comp-name">{{ t.compSdb.n }}</h3><span class="v-comp-rec">{{ t.compSdb.rec }}</span></div></div><div class="v-comp-amt"><span class="v-comp-amt-lbl">{{ isAr?'المستلم يحصل على':'Recipient gets' }}</span><span class="v-comp-amt-val">{{ t.compSdb.amount }} <small>SYP</small></span></div><ul class="v-comp-pts"><li v-for="p in t.compSdb.points" :key="p"><span class="v-check">✓</span>{{ p }}</li></ul><Link href="/preregister" class="v-comp-cta">{{ isAr?'ابدأ الآن':'Get started' }} →</Link></div>
    <div class="v-comp-card v-comp-dim"><div class="v-comp-logo"><div class="v-comp-dim-logo">BANK</div><h3 class="v-comp-name-dim">{{ t.compBank.n }}</h3></div><div class="v-comp-amt"><span class="v-comp-amt-lbl">{{ isAr?'المستلم يحصل على':'Recipient gets' }}</span><span class="v-comp-amt-dim">{{ t.compBank.amount }} <small>SYP</small></span><span class="v-comp-less">{{ t.compBank.less }}</span></div><ul class="v-comp-pts-dim"><li v-for="p in t.compBank.points" :key="p"><span class="v-x">✗</span>{{ p }}</li></ul></div>
    <div class="v-comp-card v-comp-dim"><div class="v-comp-logo"><div class="v-comp-wu-logo">WU</div><h3 class="v-comp-name-dim">{{ t.compWu.n }}</h3></div><div class="v-comp-amt"><span class="v-comp-amt-lbl">{{ isAr?'المستلم يحصل على':'Recipient gets' }}</span><span class="v-comp-amt-dim">{{ t.compWu.amount }} <small>SYP</small></span><span class="v-comp-less">{{ t.compWu.less }}</span></div><ul class="v-comp-pts-dim"><li v-for="p in t.compWu.points" :key="p"><span class="v-x">✗</span>{{ p }}</li></ul></div>
  </div>
</div></section>

<!-- ═══ TESTIMONIALS ═══ -->
<section class="v-sec v-sec-green"><div class="sw">
  <div class="v-sec-hdr an"><span class="v-pill">{{ t.testTag }}</span><h2 class="v-t2">{{ t.testTitle }}</h2><p class="v-t2-sub">{{ t.testSub }}</p></div>
  <div class="v-tests" data-stagger><div v-for="(tt,i) in t.tests" :key="i" class="v-test-card">
    <div class="v-test-top"><span class="v-test-quote">❝</span><div class="v-test-stars">★★★★★</div></div>
    <p class="v-test-q">"{{ tt.q }}"</p>
    <div class="v-test-author"><div class="v-test-avatar" :class="testColors[i]">{{ tt.a }}</div><div><div class="v-test-name">{{ tt.n }}</div><div class="v-test-role">{{ tt.r }}</div></div></div>
  </div></div>
  <div class="v-test-stats an"><div v-for="s in t.testStats" :key="s.l" class="v-tstat"><div class="v-tstat-v">{{ s.v }}</div><div class="v-tstat-l">{{ s.l }}</div></div></div>
</div></section>

<!-- ═══ COUNTERS ═══ -->
<section class="v-sec"><div class="sw">
  <h2 class="v-t2 tc an">{{ t.statsTitle }}</h2>
  <div class="v-counters counter-trigger"><div class="vctr"><div class="vctr-v">{{ counters.users >= 50000 ? '50,000+' : counters.users.toLocaleString() }}</div><div class="vctr-l">{{ t.stat1L }}</div></div><div class="vctr"><div class="vctr-v">{{ counters.countries }}+</div><div class="vctr-l">{{ t.stat2L }}</div></div><div class="vctr"><div class="vctr-v">{{ counters.currencies }}+</div><div class="vctr-l">{{ t.stat3L }}</div></div><div class="vctr"><div class="vctr-v">{{ counters.uptime }}%</div><div class="vctr-l">{{ t.stat4L }}</div></div></div>
</div></section>

<!-- ═══ FAQ ═══ -->
<section class="v-sec v-sec-light"><div class="sw" style="max-width:800px">
  <div class="v-sec-hdr an"><span class="v-pill">{{ t.faqTag }}</span><h2 class="v-t2">{{ t.faqTitle }}</h2></div>
  <div class="v-faqs an"><div v-for="(f,i) in t.faqs" :key="i" class="v-faq" :class="{open:faqOpen===i}" @click="toggleFaq(i)">
    <div class="v-faq-q"><span>{{ f.q }}</span><span class="v-faq-arrow">{{ faqOpen===i?'−':'+' }}</span></div>
    <div class="v-faq-a" v-if="faqOpen===i">{{ f.a }}</div>
  </div></div>
</div></section>

<!-- ═══ CTA ═══ -->
<section class="v-sec v-sec-cta"><div class="sw tc">
  <div class="v-cta-tag an">{{ t.ctaTag }}</div>
  <h2 class="v-t2 an" style="color:#163300">{{ t.ctaTitle }}</h2>
  <p class="v-t2-sub an tc" style="margin:0 auto 32px">{{ t.ctaSub }}</p>
  <div class="v-cta-row an"><a href="/preregister" class="v-cta-btn">{{ isAr?'افتح حسابك المجاني ←':'Open free account →' }}</a><a href="/support" class="v-cta-btn2">{{ isAr?'تواصل معنا':'Contact us' }}</a></div>
</div></section>
</template>

<style scoped>
/* ═══ V0 GREEN DESIGN ═══ */
:root{--g1:#9FE870;--g2:#163300;--g3:#2D6A00;--g4:#E8F5E0;--g5:#F5F9F3;--g6:#F0FBE8;}

/* HERO */
.v-hero{padding:160px 0 80px;position:relative;overflow:hidden;min-height:100vh;display:flex;align-items:center}
.v-hero-bg{position:absolute;inset:0;background:linear-gradient(135deg,#E8F5E0,#F0FBE8,#fff)}
.v-hero-circles{position:absolute;inset:0;overflow:hidden}
.v-circle{position:absolute;border-radius:50%;filter:blur(80px)}
.v-c1{top:-20%;right:-10%;width:600px;height:600px;background:rgba(159,232,112,.3);animation:pulse 4s ease-in-out infinite}
.v-c2{bottom:-20%;left:-10%;width:500px;height:500px;background:rgba(159,232,112,.2);animation:pulse 6s ease-in-out infinite}
.v-c3{top:40%;left:30%;width:300px;height:300px;background:rgba(22,51,0,.05)}
.v-hero-grid{display:grid;grid-template-columns:1.1fr 1fr;gap:48px;align-items:center;position:relative;z-index:1}
.v-badge{display:inline-flex;align-items:center;gap:8px;background:rgba(255,255,255,.8);backdrop-filter:blur(8px);border-radius:999px;padding:8px 16px;font-size:13px;font-weight:600;color:#163300;border:1px solid rgba(159,232,112,.3);margin-bottom:24px;box-shadow:0 2px 8px rgba(0,0,0,.04)}
.v-h1{font-size:clamp(2.5rem,5.5vw,4.5rem);font-weight:900;color:#163300;line-height:1.05;letter-spacing:-.04em;margin-bottom:20px}.rtl .v-h1{letter-spacing:0}
.v-h1-em{color:#2D6A00;position:relative;display:inline-block}
.v-hero-p{font-size:18px;color:#555;line-height:1.85;margin-bottom:24px;max-width:500px}
.v-badges{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:24px}
.v-mini-badge{display:flex;align-items:center;gap:4px;background:rgba(255,255,255,.6);backdrop-filter:blur(4px);padding:6px 14px;border-radius:999px;font-size:13px;font-weight:600;color:#163300}
.v-hero-cd{display:flex;gap:18px;margin-bottom:28px}
.vcd-b{text-align:center}.vcd-n{font-size:38px;font-weight:900;color:#163300;line-height:1;font-variant-numeric:tabular-nums}.vcd-l{font-size:10px;color:rgba(22,51,0,.4);margin-top:3px;font-weight:700;letter-spacing:1px;text-transform:uppercase}
.v-hero-eml{display:flex;gap:0;max-width:420px;border:2px solid #163300;border-radius:999px;overflow:hidden;margin-bottom:28px}
.veml-i{flex:1;padding:14px 20px;border:none;outline:none;font-size:15px;background:transparent;color:#163300;font-family:inherit}.veml-i::placeholder{color:#aaa}
.veml-b{padding:14px 28px;background:#163300;color:#fff;border:none;font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;transition:all .2s;white-space:nowrap}.veml-b:hover{background:#1e4400}
.veml-ok{padding:14px;color:#2D6A00;font-weight:700;font-size:14px}.veml-err{font-size:12px;color:#DC2626;font-weight:700;margin-top:6px}
.rtl .v-hero-eml{flex-direction:row-reverse}
.v-hero-stats{display:flex;gap:32px}
.vhs{text-align:center}.vhs-v{font-size:26px;font-weight:900;color:#163300}.vhs-l{font-size:12px;color:#888}

/* CONVERTER */
.v-conv{background:#fff;border:1px solid rgba(159,232,112,.15);border-radius:24px;padding:28px;box-shadow:0 20px 60px rgba(0,0,0,.06);position:relative}
.vc-head{font-size:15px;font-weight:800;color:#163300;margin-bottom:20px;text-align:center}
.vc-field{margin-bottom:8px}.vc-lbl{font-size:12px;font-weight:700;color:#888;margin-bottom:6px;display:block}
.vc-row{display:flex;gap:8px;align-items:center}
.vc-sel{padding:12px;border:1px solid rgba(159,232,112,.15);border-radius:12px;font-size:16px;font-weight:800;color:#163300;background:#F8FAF6;cursor:pointer;font-family:inherit;outline:none;min-width:80px}
.vc-inp{flex:1;padding:12px;border:1px solid rgba(159,232,112,.15);border-radius:12px;font-size:22px;font-weight:900;color:#163300;outline:none;font-family:inherit;text-align:end;background:#F8FAF6}.vc-inp:focus{border-color:#9FE870}
.vc-inp::-webkit-inner-spin-button,.vc-inp::-webkit-outer-spin-button{-webkit-appearance:none}.vc-inp{-moz-appearance:textfield}
.rtl .vc-inp{text-align:start}
.vc-res{flex:1;padding:12px;background:#F0FBE8;border-radius:12px;font-size:22px;font-weight:900;color:#2D6A00;text-align:end}.rtl .vc-res{text-align:start}
.vc-swap{text-align:center;font-size:16px;color:rgba(159,232,112,.4);margin:4px 0;cursor:pointer;transition:color .2s}.vc-swap:hover{color:#9FE870}
.vc-rate{font-size:12px;color:#888;text-align:center;margin:12px 0;font-weight:600}
.vc-cta{display:block;padding:14px;background:linear-gradient(135deg,#163300,#2D6A00);color:#fff;font-size:15px;font-weight:800;text-align:center;border-radius:12px;text-decoration:none;transition:all .2s}.vc-cta:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(22,51,0,.15)}

/* MARQUEE */
.v-mq{padding:16px 0;border-top:1px solid rgba(0,0,0,.04);border-bottom:1px solid rgba(0,0,0,.04);overflow:hidden;background:#fafafa}
.v-mq-track{display:flex;gap:48px;animation:mqs 25s linear infinite;white-space:nowrap}
.v-mq-i{font-size:13px;font-weight:800;color:rgba(22,51,0,.06);letter-spacing:3px;text-transform:uppercase}
@keyframes mqs{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}

/* SECTIONS */
.v-sec{padding:100px 0}.v-sec-light{background:#fff}.v-sec-green{background:#F5F9F3}
.v-sec-cta{padding:120px 0;background:linear-gradient(135deg,#F0FBE8,#E8F5E0)}
.v-sec-hdr{text-align:center;margin-bottom:48px}.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.v-pill{display:inline-block;padding:6px 16px;background:#E8F5E0;color:#2D6A00;font-size:12px;font-weight:700;border-radius:999px;margin-bottom:12px;letter-spacing:1px}
.v-t2{font-size:clamp(1.8rem,4vw,3rem);font-weight:900;line-height:1.1;letter-spacing:-.02em;margin-bottom:16px;color:#163300}.rtl .v-t2{letter-spacing:0}
.v-t2-sub{font-size:16px;color:#666;line-height:1.85;max-width:550px;margin:0 auto}

/* HOW IT WORKS */
.v-steps{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;position:relative}
.v-step-num{width:72px;height:72px;border-radius:20px;display:flex;align-items:center;justify-content:center;font-size:22px;font-weight:900;color:#fff;margin-bottom:14px;box-shadow:0 8px 20px rgba(0,0,0,.1);transition:all .4s}
.v-step-num:hover{transform:scale(1.1) rotate(6deg)}
.v-step-card{border-radius:16px;padding:20px;transition:all .3s}.v-step-card:hover{box-shadow:0 8px 24px rgba(0,0,0,.06)}
.v-step-t{font-size:17px;font-weight:800;color:#163300;margin-bottom:8px}
.v-step-d{font-size:14px;color:#666;line-height:1.7}

/* FEATURES */
.v-feats{display:grid;grid-template-columns:repeat(4,1fr);gap:14px}
.v-feat{padding:24px;background:#fff;border:2px solid #f0f0f0;border-radius:20px;transition:all .4s;cursor:pointer}
.v-feat:hover{border-color:#9FE870;transform:translateY(-6px);box-shadow:0 16px 40px rgba(159,232,112,.15)}
.v-feat-ic{font-size:32px;display:block;margin-bottom:12px}
.v-feat-t{font-size:16px;font-weight:800;color:#163300;margin-bottom:6px}
.v-feat-d{font-size:13px;color:#666;line-height:1.7}

/* COMPARISON */
.v-comp{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.v-comp-card{background:#fff;border-radius:24px;padding:28px;border:1px solid #e8e8e8;position:relative;transition:all .3s}
.v-comp-best{border:2px solid #9FE870;box-shadow:0 16px 40px rgba(159,232,112,.15)}
.v-comp-badge{position:absolute;top:-14px;left:50%;transform:translateX(-50%);padding:6px 18px;background:linear-gradient(135deg,#163300,#2D6A00);color:#fff;font-size:11px;font-weight:800;border-radius:999px;white-space:nowrap;box-shadow:0 4px 12px rgba(22,51,0,.2)}
.v-comp-logo{display:flex;align-items:center;gap:10px;margin-bottom:20px}
.v-comp-sdb-logo{width:48px;height:48px;background:linear-gradient(135deg,#9FE870,#7ACC50);border-radius:14px;display:flex;align-items:center;justify-content:center;font-weight:800;color:#163300;font-size:13px;box-shadow:0 4px 12px rgba(159,232,112,.3)}
.v-comp-name{font-weight:800;color:#163300;font-size:16px}.v-comp-rec{font-size:11px;color:#2D6A00}
.v-comp-dim{opacity:.75;transition:opacity .3s}.v-comp-dim:hover{opacity:1}
.v-comp-dim-logo{width:48px;height:48px;background:#f0f0f0;border-radius:14px;display:flex;align-items:center;justify-content:center;font-weight:800;color:#aaa;font-size:12px}
.v-comp-wu-logo{width:48px;height:48px;background:#FEF9E7;border:1px solid #F59E0B;border-radius:14px;display:flex;align-items:center;justify-content:center;font-weight:800;color:#D97706;font-size:12px}
.v-comp-name-dim{font-weight:800;color:#888;font-size:16px}
.v-comp-amt{margin-bottom:20px;padding-bottom:20px;border-bottom:1px solid #f0f0f0}
.v-comp-amt-lbl{display:block;font-size:12px;color:#888;margin-bottom:4px}
.v-comp-amt-val{font-size:28px;font-weight:900;color:#163300}.v-comp-amt-val small{font-size:14px;color:#888;margin-inline-start:4px}
.v-comp-amt-dim{font-size:28px;font-weight:900;color:#bbb}.v-comp-amt-dim small{font-size:14px}
.v-comp-less{display:block;font-size:11px;color:#EF4444;margin-top:2px}
.v-comp-pts{list-style:none;padding:0;margin:0 0 20px;display:flex;flex-direction:column;gap:10px}
.v-comp-pts li{display:flex;align-items:center;gap:8px;font-size:13px;font-weight:600;color:#333}
.v-check{width:22px;height:22px;background:#E8F5E0;border-radius:50%;display:flex;align-items:center;justify-content:center;color:#2D6A00;font-size:12px;font-weight:900;flex-shrink:0}
.v-comp-pts-dim{list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:10px}
.v-comp-pts-dim li{display:flex;align-items:center;gap:8px;font-size:13px;color:#aaa}
.v-x{width:22px;height:22px;background:#FEE2E2;border-radius:50%;display:flex;align-items:center;justify-content:center;color:#EF4444;font-size:12px;font-weight:900;flex-shrink:0}
.v-comp-cta{display:block;padding:14px;background:#163300;color:#fff;text-align:center;border-radius:14px;font-weight:800;font-size:14px;text-decoration:none;transition:all .2s}.v-comp-cta:hover{background:#1e4400;box-shadow:0 8px 20px rgba(22,51,0,.15)}

/* TESTIMONIALS */
.v-tests{display:grid;grid-template-columns:repeat(2,1fr);gap:16px}
.v-test-card{background:#fff;border-radius:24px;padding:28px;border:1px solid #e8e8e8;transition:all .4s;cursor:pointer}
.v-test-card:hover{border-color:rgba(159,232,112,.3);box-shadow:0 16px 40px rgba(0,0,0,.06);transform:translateY(-3px)}
.v-test-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:16px}
.v-test-quote{font-size:36px;color:rgba(159,232,112,.3);line-height:1;font-weight:900}
.v-test-stars{color:#F59E0B;font-size:14px;letter-spacing:2px}
.v-test-q{font-size:16px;color:#333;line-height:1.8;margin-bottom:20px}
.v-test-author{display:flex;align-items:center;gap:12px}
.v-test-avatar{width:48px;height:48px;border-radius:16px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:16px;transition:transform .3s}
.v-test-card:hover .v-test-avatar{transform:scale(1.1)}
.v-test-name{font-weight:800;color:#163300;font-size:15px}.v-test-role{font-size:12px;color:#888}
.v-test-stats{margin-top:40px;background:#fff;border-radius:24px;padding:28px;border:1px solid #e8e8e8}
.v-test-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;text-align:center}
.v-tstat-v{font-size:24px;font-weight:900;color:#163300;margin-bottom:2px}
.v-tstat-l{font-size:12px;color:#888}

/* COUNTERS */
.v-counters{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:rgba(159,232,112,.1);border:1px solid rgba(159,232,112,.15);border-radius:20px;overflow:hidden}
.vctr{padding:48px 24px;background:#fff;text-align:center}
.vctr-v{font-size:clamp(2rem,4vw,3rem);font-weight:900;color:#2D6A00;margin-bottom:6px;font-variant-numeric:tabular-nums}
.vctr-l{font-size:13px;color:#888;font-weight:700}

/* FAQ */
.v-faqs{display:flex;flex-direction:column;gap:8px}
.v-faq{background:#fff;border:1px solid #e8e8e8;border-radius:16px;padding:16px 20px;cursor:pointer;transition:all .3s}
.v-faq:hover,.v-faq.open{border-color:#9FE870;box-shadow:0 4px 16px rgba(159,232,112,.1)}
.v-faq-q{display:flex;justify-content:space-between;align-items:center;font-size:15px;font-weight:700;color:#163300}
.v-faq-arrow{font-size:20px;color:#9FE870;font-weight:300}
.v-faq-a{margin-top:12px;font-size:14px;color:#666;line-height:1.8;padding-top:12px;border-top:1px solid #f0f0f0}

/* CTA */
.v-cta-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#2D6A00;text-transform:uppercase;margin-bottom:20px}.rtl .v-cta-tag{letter-spacing:0}
.v-cta-row{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}
.v-cta-btn{display:inline-block;padding:18px 48px;background:#163300;color:#fff;font-size:16px;font-weight:800;border-radius:999px;text-decoration:none;transition:all .3s}.v-cta-btn:hover{background:#1e4400;transform:translateY(-2px);box-shadow:0 12px 32px rgba(22,51,0,.15)}
.v-cta-btn2{display:inline-block;padding:18px 48px;background:transparent;color:#163300;font-size:16px;font-weight:800;border-radius:999px;text-decoration:none;border:2px solid rgba(22,51,0,.15);transition:all .2s}.v-cta-btn2:hover{border-color:#163300}

/* BG Classes for steps */
.from-blue-500{background:linear-gradient(135deg,#3B82F6,#2563EB)}.from-purple-500{background:linear-gradient(135deg,#8B5CF6,#7C3AED)}.from-amber-500{background:linear-gradient(135deg,#F59E0B,#EA580C)}.from-green-500{background:linear-gradient(135deg,#22C55E,#10B981)}
.from-blue-400{background:linear-gradient(135deg,#60A5FA,#3B82F6)}.from-purple-400{background:linear-gradient(135deg,#A78BFA,#8B5CF6)}.from-green-400{background:linear-gradient(135deg,#4ADE80,#22C55E)}.from-orange-400{background:linear-gradient(135deg,#FB923C,#F97316)}
.bg-blue-50{background:#EFF6FF}.bg-purple-50{background:#F5F3FF}.bg-amber-50{background:#FFFBEB}.bg-green-50{background:#F0FDF4}

/* ANIMATIONS */
.an{opacity:0;transform:translateY(28px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
.an-l{opacity:0;transform:translateX(-40px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an-l.vi{opacity:1;transform:none}
.an-r{opacity:0;transform:translateX(40px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an-r.vi{opacity:1;transform:none}
.an-s{opacity:0;transform:scale(.92);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an-s.vi{opacity:1;transform:none}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.5}}

/* RESPONSIVE */
@media(max-width:900px){
  .v-hero-grid{grid-template-columns:1fr;gap:32px;text-align:center}
  .v-hero-left{display:flex;flex-direction:column;align-items:center}
  .v-hero-p{text-align:center}
  .v-hero-stats{justify-content:center}
  .v-badges{justify-content:center}
  .v-steps{grid-template-columns:repeat(2,1fr)}
  .v-feats{grid-template-columns:repeat(2,1fr)}
  .v-comp{grid-template-columns:1fr}
  .v-tests{grid-template-columns:1fr}
  .v-counters{grid-template-columns:repeat(2,1fr)}
  .v-test-stats{grid-template-columns:repeat(2,1fr)}
}
@media(max-width:600px){
  .v-hero{padding:120px 0 40px}
  .v-sec{padding:60px 0}.sw{padding:0 16px}
  .v-t2{font-size:clamp(1.4rem,6vw,2rem)}
  .v-steps{grid-template-columns:1fr}
  .v-feats{grid-template-columns:1fr}
  .v-counters{grid-template-columns:1fr}
  .v-test-stats{grid-template-columns:repeat(2,1fr)}
  .v-hero-cd{flex-wrap:wrap;gap:12px;justify-content:center}
  .vcd-n{font-size:28px}
  .v-hero-eml{flex-direction:column!important;border:none!important;border-radius:0!important;overflow:visible!important;gap:10px}
  .veml-i{border:2px solid #163300!important;border-radius:14px!important;background:#fff}
  .veml-b{border-radius:14px!important;width:100%}
  .v-cta-btn,.v-cta-btn2{width:100%;text-align:center;padding:16px}
  .v-cta-row{flex-direction:column;padding:0 16px}
}
</style>
