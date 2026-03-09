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
const em = ref('');const done = ref(false);
/* Mini converter */
const cAmt = ref(1000); const cFrom = ref('EUR'); const cTo = ref('SYP');
const cRates = {EUR:1,USD:1.08,GBP:0.86,SYP:13500,TRY:34.2,AED:3.97,SAR:4.05,DKK:7.46};
const cResult = computed(() => {const r=(cRates[cTo.value]||1)/(cRates[cFrom.value]||1);const v=cAmt.value*r; return v>=1000?Math.round(v).toLocaleString('en-US'):v.toFixed(2)});
const cRate = computed(() => {const r=(cRates[cTo.value]||1)/(cRates[cFrom.value]||1);return r>=100?Math.round(r).toLocaleString('en-US'):r.toFixed(4)});
/* Scroll counter animation */
const counted = ref(false);
const counters = ref({users:0,countries:0,currencies:0,uptime:0});
function animateCounters(){if(counted.value)return;counted.value=true;
  const targets={users:50000,countries:150,currencies:30,uptime:99.99};
  Object.keys(targets).forEach(k=>{let start=0;const end=targets[k];const dur=2000;const step=16;const inc=end*step/dur;
    const timer=setInterval(()=>{start+=inc;if(start>=end){counters.value[k]=end;clearInterval(timer)}else{counters.value[k]=Math.floor(start)}},step)});}
let obs;
onMounted(()=>{tick();ti=setInterval(tick,1e3);
  obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting){
    x.target.classList.add('vi');
    if(x.target.classList.contains('counter-trigger'))animateCounters();
    /* Stagger children when parent enters viewport */
    if(x.target.hasAttribute('data-stagger')){
      x.target.querySelectorAll(':scope > *').forEach((ch,i)=>{
        setTimeout(()=>ch.classList.add('vi'), i*120);
      });
    }
  }}),{threshold:.08,rootMargin:'0px 0px -40px 0px'});
  document.querySelectorAll('.an,.an-l,.an-r,.an-s,.counter-trigger').forEach(el=>obs.observe(el));
  document.querySelectorAll('[data-stagger]').forEach(parent=>{
    parent.querySelectorAll(':scope > *').forEach((ch)=>{ch.classList.add('an')});
    obs.observe(parent);
  });
});
onUnmounted(()=>{clearInterval(ti);obs?.disconnect()});
const t = computed(() => isAr.value ? {
  tag:'أول بنك إلكتروني سوري',hd1:'حوّل، ادفع، ووفّر',hd2:'بدون رسوم مخفية.',
  sub:'افتح حسابك من سوريا أو من أي مكان بالعالم. معاشات، تحويلات، بطاقات — كل شيء بتطبيق واحد.',
  days:'يوم',hrs:'ساعة',min:'دقيقة',sec:'ثانية',
  emailPh:'بريدك الإلكتروني...',notify:'سجّل مبكراً',emailDone:'✓ تم! سنبلغك فور الإطلاق.',
  trust:['🇩🇰 مرخّص بالدنمارك','🔒 تشفير 256-بت','🏦 ماستركارد معتمد'],
  convTitle:'جرّب المحوّل',convSend:'ترسل',convGet:'تحصل على',convRate:'السعر:',convBtn:'حوّل الآن ←',
  compTitle:'لا تدفع رسوم مخفية بعد اليوم',compSub:'البنوك التقليدية تضيف هوامش ربح على سعر الصرف. نحن لا نفعل ذلك.',
  compRows:[
    ['السعر','سعر السوق الحقيقي','هامش 3-5% مخفي'],
    ['الرسوم','0.3% فقط','2-5% + رسوم خفية'],
    ['السرعة','ثوانٍ','1-3 أيام عمل'],
    ['التوفر','24/7 من التطبيق','ساعات عمل البنك'],
  ],
  compSdb:'SDB Bank',compBank:'البنوك التقليدية',
  servTitle:'كل ما تحتاجه.',servFade:'بتطبيق واحد.',
  servCards:[
    {ic:'💸',t:'أرسل لأهلك بسوريا',d:'تحويلات فورية بأقل رسوم — 0.5% فقط. أسرع طريقة لإرسال الأموال لعائلتك.',btn:'تفاصيل التحويلات',href:'/transfers-info'},
    {ic:'💳',t:'بطاقة ماستركارد',d:'بطاقة افتراضية فورية مجانية. بطاقة معدنية فاخرة. ادفع بأي مكان بالعالم.',btn:'اكتشف البطاقات',href:'/cards-info'},
    {ic:'💱',t:'صرف 30+ عملة',d:'حوّل بسعر السوق الحقيقي. بدون هوامش ربح. يورو، دولار، ليرة، درهم والمزيد.',btn:'أسعار الصرف',href:'/exchange-rates'},
  ],
  feat1Title:'استلم معاشك',feat1Em:'مباشرة.',
  feat1Desc:'معاشك يصل تلقائياً لحسابك الرقمي. بدون وسطاء، بدون تأخير. إشعار فوري عند الوصول مع تحليل ذكي لمصاريفك.',
  feat1Btn:'المزيد عن الرواتب',feat1Href:'/salary',
  feat1Points:['إيداع مباشر فوري','إشعار لحظي بالهاتف','تحليل ذكي للمصاريف','صفر رسوم استلام'],
  feat2Title:'أمانك',feat2Em:'أولويتنا.',
  feat2Desc:'نستخدم نفس تقنيات الحماية المستخدمة بأكبر بنوك العالم. أموالك محمية بمعايير أوروبية صارمة 24/7.',
  feat2Btn:'تفاصيل الأمان',feat2Href:'/security',
  feat2Points:['تشفير AES-256 بنكي','بصمة الوجه والإصبع','فريق مراقبة احتيال 24/7','CVV ديناميكي كل ساعة'],
  cardsTitle:'اختر بطاقتك.',cardsFade:'4 مستويات.',
  cardTiers:[
    {n:'Standard',p:'مجاني',c:'#0EA5E9',feat:'بطاقة افتراضية + Apple Pay'},
    {n:'Plus',p:'600 ل.س/شهر',c:'#7C3AED',feat:'بطاقة معدنية + CVV ديناميكي'},
    {n:'Premium',p:'1,200 ل.س/شهر',c:'#DB2777',feat:'صرف بلا حدود + تأمين سفر'},
    {n:'Elite',p:'2,250 ل.س/شهر',c:'#B45309',feat:'مدير شخصي + VIP lounges'},
  ],
  cardsBtn:'قارن كل الباقات',
  testimonials:[
    {q:'بنك مصمم خصيصاً للسوريين. حوّلت لأهلي وهم بدمشق خلال ثوانٍ — شي ما كنت أحلم فيه.',n:'أحمد م.',loc:'برلين 🇩🇪'},
    {q:'فتحت حسابي من إسطنبول بـ 5 دقائق. بطاقة افتراضية فوراً. خلّصت من مشاكل التحويلات التقليدية.',n:'سارة ع.',loc:'إسطنبول 🇹🇷'},
    {q:'أسعار صرف أفضل بكتير من الصرافين التقليديين. والتطبيق سهل وبسيط. SDB غيّر حياتي المالية.',n:'محمد ك.',loc:'الرياض 🇸🇦'},
  ],
  testTitle:'سوريون حول العالم يثقون بـ SDB',
  statsTitle:'أرقام تتحدث.',
  stat1L:'عميل مسجّل',stat2L:'دولة مدعومة',stat3L:'عملة',stat4L:'وقت تشغيل %',
  moreTitle:'المزيد مع SDB',
  moreCards:[
    {ic:'📱',t:'التطبيق الذكي',d:'iOS و Android',href:'/app'},
    {ic:'🪪',t:'الهوية الرقمية',d:'تحقق فوري',href:'/digital-id'},
    {ic:'🧾',t:'دفع فواتير',d:'قريباً',href:'/bills'},
    {ic:'📊',t:'تحليلات AI',d:'مصاريفك بذكاء',href:'/analytics'},
    {ic:'🇸🇾',t:'الليرة السورية',d:'أسعار حية',href:'/syrian-lira'},
    {ic:'🪙',t:'عملات رقمية',d:'BTC, ETH + 10',href:'/crypto'},
  ],
  ctaTag:'جاهز؟',ctaTitle:'مستقبلك المالي يبدأ هنا.',
  ctaSub:'افتح حسابك المجاني بدقيقتين. أول بنك إلكتروني سوري مصمم لخدمتك.',
  ctaBtn:'افتح حسابك المجاني ←',ctaBtn2:'تواصل معنا',
} : {
  tag:'The First Syrian Digital Bank',hd1:'Send, pay and save',hd2:'with no hidden fees.',
  sub:'Open your account from Syria or anywhere in the world. Salary, transfers, cards — everything in one app.',
  days:'Days',hrs:'Hrs',min:'Min',sec:'Sec',
  emailPh:'Your email...',notify:'Sign up early',emailDone:'✓ Done! We\'ll notify you at launch.',
  trust:['🇩🇰 Licensed in Denmark','🔒 256-bit encrypted','🏦 Mastercard certified'],
  convTitle:'Try the converter',convSend:'You send',convGet:'They get',convRate:'Rate:',convBtn:'Convert now →',
  compTitle:'Never pay a hidden fee again',compSub:'Banks add markup to exchange rates to make you pay more. We don\'t.',
  compRows:[
    ['Rate','Real market rate','3-5% hidden markup'],
    ['Fees','Only 0.3%','2-5% + hidden fees'],
    ['Speed','Seconds','1-3 business days'],
    ['Availability','24/7 from app','Bank hours only'],
  ],
  compSdb:'SDB Bank',compBank:'Traditional Banks',
  servTitle:'Everything you need.',servFade:'In one app.',
  servCards:[
    {ic:'💸',t:'Send to family in Syria',d:'Instant transfers at lowest fees — just 0.5%. Fastest way to send money to your family.',btn:'Transfer details',href:'/transfers-info'},
    {ic:'💳',t:'Mastercard Card',d:'Free instant virtual card. Premium metal card. Pay anywhere worldwide.',btn:'Explore cards',href:'/cards-info'},
    {ic:'💱',t:'Exchange 30+ currencies',d:'Convert at real market rate. Zero markup. EUR, USD, GBP, TRY, AED and more.',btn:'Exchange rates',href:'/exchange-rates'},
  ],
  feat1Title:'Receive your salary',feat1Em:'directly.',
  feat1Desc:'Your salary arrives directly into your digital account. No middlemen, no delays. Instant notification with smart spending analytics.',
  feat1Btn:'More about salary',feat1Href:'/salary',
  feat1Points:['Direct instant deposit','Real-time phone alert','Smart spending analytics','Zero reception fees'],
  feat2Title:'Your security',feat2Em:'our priority.',
  feat2Desc:'We use the same protection technologies as the world\'s largest banks. Your money protected by strict European standards 24/7.',
  feat2Btn:'Security details',feat2Href:'/security',
  feat2Points:['AES-256 bank encryption','Face ID & fingerprint','24/7 fraud monitoring','Dynamic CVV every hour'],
  cardsTitle:'Choose your card.',cardsFade:'4 tiers.',
  cardTiers:[
    {n:'Standard',p:'Free',c:'#0EA5E9',feat:'Virtual card + Apple Pay'},
    {n:'Plus',p:'€3.99/mo',c:'#7C3AED',feat:'Metal card + Dynamic CVV'},
    {n:'Premium',p:'€7.99/mo',c:'#DB2777',feat:'Unlimited FX + Travel insurance'},
    {n:'Elite',p:'€14.99/mo',c:'#B45309',feat:'Personal manager + VIP lounges'},
  ],
  cardsBtn:'Compare all plans',
  testimonials:[
    {q:'A bank designed for Syrians. I sent money to my family in Damascus in seconds — something I never dreamed of.',n:'Ahmed M.',loc:'Berlin 🇩🇪'},
    {q:'I opened my account from Istanbul in 5 minutes. Instant virtual card. No more traditional transfer headaches.',n:'Sara A.',loc:'Istanbul 🇹🇷'},
    {q:'Exchange rates way better than traditional exchangers. The app is simple and easy. SDB changed my financial life.',n:'Mohammad K.',loc:'Riyadh 🇸🇦'},
  ],
  testTitle:'Syrians worldwide trust SDB',
  statsTitle:'Numbers that speak.',
  stat1L:'Registered users',stat2L:'Countries',stat3L:'Currencies',stat4L:'Uptime %',
  moreTitle:'More with SDB',
  moreCards:[
    {ic:'📱',t:'Smart App',d:'iOS & Android',href:'/app'},
    {ic:'🪪',t:'Digital Identity',d:'Instant verification',href:'/digital-id'},
    {ic:'🧾',t:'Bill Payments',d:'Coming soon',href:'/bills'},
    {ic:'📊',t:'AI Analytics',d:'Smart spending',href:'/analytics'},
    {ic:'🇸🇾',t:'Syrian Lira',d:'Live rates',href:'/syrian-lira'},
    {ic:'🪙',t:'Crypto',d:'BTC, ETH + 10',href:'/crypto'},
  ],
  ctaTag:'Ready?',ctaTitle:'Your financial future starts here.',
  ctaSub:'Open your free account in 2 minutes. The first Syrian digital bank designed for you.',
  ctaBtn:'Open free account →',ctaBtn2:'Contact us',
});
</script>
<template>
<Head :title="isAr?'SDB Bank — أول بنك إلكتروني سوري':'SDB Bank — First Syrian Digital Bank'"><meta :content="isAr?'SDB Bank — أول بنك إلكتروني سوري':'SDB Bank — First Syrian Digital Bank'" name="description"/></Head>

<!-- ═══ HERO ═══ -->
<section class="hero"><div class="sw hero-grid">
  <div class="hero-left">
    <div class="hero-tag an">{{ t.tag }}</div>
    <h1 class="hero-h an" style="transition-delay:100ms"><span class="hero-h1">{{ t.hd1 }}</span><span class="hero-h2">{{ t.hd2 }}</span></h1>
    <p class="hero-p an" style="transition-delay:200ms">{{ t.sub }}</p>
    <div class="hero-cd an" style="transition-delay:300ms"><div v-for="(lb,k) in {d:t.days,h:t.hrs,m:t.min,s:t.sec}" :key="k" class="cd-b"><div class="cd-n">{{ String(cd[k]).padStart(2,'0') }}</div><div class="cd-l">{{ lb }}</div></div></div>
    <div class="hero-eml an" style="transition-delay:400ms"><template v-if="!done"><input v-model="em" type="email" :placeholder="t.emailPh" class="eml-i" @keyup.enter="done=!!em"/><button @click="done=!!em" class="eml-b">{{ t.notify }}</button></template><div v-else class="eml-ok">{{ t.emailDone }}</div></div>
    <div class="hero-trust an" style="transition-delay:500ms"><span v-for="tr in t.trust" :key="tr" class="trust-i">{{ tr }}</span></div>
  </div>
  <!-- Mini Converter -->
  <div class="hero-right an-r">
    <div class="conv-mini">
      <div class="conv-head">{{ t.convTitle }}</div>
      <div class="conv-field"><label class="conv-lbl">{{ t.convSend }}</label><div class="conv-row"><select v-model="cFrom" class="conv-sel"><option v-for="c in Object.keys(cRates)" :key="c" :value="c">{{ c }}</option></select><input v-model.number="cAmt" type="number" class="conv-inp"/></div></div>
      <div class="conv-swap-mini" @click="[cFrom.value,cTo.value]=[cTo,cFrom];let tmp=cFrom;cFrom=cTo;cTo=tmp">⇅</div>
      <div class="conv-field"><label class="conv-lbl">{{ t.convGet }}</label><div class="conv-row"><select v-model="cTo" class="conv-sel"><option v-for="c in Object.keys(cRates)" :key="c" :value="c">{{ c }}</option></select><div class="conv-res">{{ cResult }}</div></div></div>
      <div class="conv-rate">{{ t.convRate }} 1 {{ cFrom }} = {{ cRate }} {{ cTo }}</div>
      <Link href="/exchange-rates" class="conv-cta">{{ t.convBtn }}</Link>
    </div>
  </div>
</div></section>

<!-- ═══ MARQUEE ═══ -->
<div class="mq"><div class="mq-track"><span v-for="(p,i) in ['SDB Bank','Mastercard','Apple Pay','Google Pay','SWIFT','SEPA','Syria 🇸🇾','Damascus','Berlin','Istanbul','SDB Bank','Mastercard','Apple Pay','Google Pay','SWIFT','SEPA','Syria 🇸🇾','Damascus','Berlin','Istanbul']" :key="i" class="mq-i">{{ p }}</span></div></div>

<!-- ═══ COMPARISON (Wise-style) ═══ -->
<section class="sec"><div class="sw">
  <div class="comp-hdr an"><h2 class="t2 tc">{{ t.compTitle }}</h2><p class="t2-sub tc" style="margin:0 auto 48px">{{ t.compSub }}</p></div>
  <div class="comp-table an-s">
    <div class="comp-header"><div class="comp-f"></div><div class="comp-v comp-sdb-h">✅ {{ t.compSdb }}</div><div class="comp-v comp-bank-h">{{ t.compBank }}</div></div>
    <div v-for="r in t.compRows" :key="r[0]" class="comp-row"><div class="comp-f">{{ r[0] }}</div><div class="comp-v comp-sdb">{{ r[1] }}</div><div class="comp-v comp-bank">{{ r[2] }}</div></div>
  </div>
</div></section>

<!-- ═══ 3 SERVICE CARDS (Wise-style showcase) ═══ -->
<section class="sec sec-alt"><div class="sw">
  <div class="sec-hdr an-l"><h2 class="t2">{{ t.servTitle }}<br><span class="t2-em">{{ t.servFade }}</span></h2></div>
  <div class="serv-grid" data-stagger>
    <Link v-for="(s,i) in t.servCards" :key="i" :href="s.href" class="serv-c" :style="{animationDelay:(i*120)+'ms'}">
      <span class="serv-ic">{{ s.ic }}</span>
      <h3 class="serv-t">{{ s.t }}</h3>
      <p class="serv-d">{{ s.d }}</p>
      <span class="serv-btn">{{ s.btn }} →</span>
    </Link>
  </div>
</div></section>

<!-- ═══ FEATURE 1: Salary (left text, right visual) ═══ -->
<section class="sec"><div class="sw feat-row an-l">
  <div class="feat-text">
    <h2 class="t2">{{ t.feat1Title }}<br><span class="t2-em">{{ t.feat1Em }}</span></h2>
    <p class="t2-sub">{{ t.feat1Desc }}</p>
    <ul class="feat-points"><li v-for="p in t.feat1Points" :key="p">{{ p }}</li></ul>
    <Link :href="t.feat1Href" class="link-btn">{{ t.feat1Btn }} →</Link>
  </div>
  <div class="feat-visual">
    <div class="feat-phone"><div class="fp-notif"><span class="fp-dot"></span><div><div class="fp-notif-t">{{ isAr?'وصل الراتب!':'Salary received!' }}</div><div class="fp-notif-v">+ 750,000 {{ isAr?'ل.س':'SYP' }}</div></div></div><div class="fp-balance"><div class="fp-bl">{{ isAr?'الرصيد الحالي':'Current Balance' }}</div><div class="fp-bv">1,250,000 <small>{{ isAr?'ل.س':'SYP' }}</small></div></div></div>
  </div>
</div></section>

<!-- ═══ FEATURE 2: Security (right text, left visual) ═══ -->
<section class="sec sec-dark"><div class="sw feat-row feat-row-rev an-r">
  <div class="feat-text">
    <h2 class="t2 t2-w">{{ t.feat2Title }}<br><span class="t2-em-w">{{ t.feat2Em }}</span></h2>
    <p class="t2-sub t2-sub-w">{{ t.feat2Desc }}</p>
    <ul class="feat-points feat-points-w"><li v-for="p in t.feat2Points" :key="p">{{ p }}</li></ul>
    <Link :href="t.feat2Href" class="link-btn link-btn-w">{{ t.feat2Btn }} →</Link>
  </div>
  <div class="feat-visual">
    <div class="sec-shield"><div class="shield-ring"><div class="shield-ring2"><span class="shield-ic">🔒</span></div></div><div class="shield-labels"><span>AES-256</span><span>3D Secure</span><span>Biometric</span><span>24/7</span></div></div>
  </div>
</div></section>

<!-- ═══ CARD TIERS ═══ -->
<section class="sec"><div class="sw">
  <div class="sec-hdr an"><h2 class="t2 tc">{{ t.cardsTitle }}<br><span class="t2-em">{{ t.cardsFade }}</span></h2></div>
  <div class="tiers" data-stagger>
    <Link v-for="(c,i) in [{h:'/cards/standard'},{h:'/cards/plus'},{h:'/cards/premium'},{h:'/cards/elite'}]" :key="i" :href="c.h" class="tier-c" :style="{animationDelay:(i*80)+'ms'}">
      <div class="tier-bar" :style="{background:t.cardTiers[i].c}"></div>
      <h4 class="tier-n">{{ t.cardTiers[i].n }}</h4>
      <div class="tier-p" :style="{color:t.cardTiers[i].c}">{{ t.cardTiers[i].p }}</div>
      <p class="tier-feat">{{ t.cardTiers[i].feat }}</p>
    </Link>
  </div>
  <div class="tc an" style="margin-top:32px"><Link href="/plans" class="link-btn">{{ t.cardsBtn }} →</Link></div>
</div></section>

<!-- ═══ TESTIMONIALS (Wise-style) ═══ -->
<section class="sec sec-alt"><div class="sw">
  <h2 class="t2 tc an">{{ t.testTitle }}</h2>
  <div class="test-grid" data-stagger>
    <div v-for="(tt,i) in t.testimonials" :key="i" class="test-c" :style="{animationDelay:(i*100)+'ms'}">
      <div class="test-stars">★★★★★</div>
      <p class="test-q">"{{ tt.q }}"</p>
      <div class="test-author"><strong>{{ tt.n }}</strong><span class="test-loc">{{ tt.loc }}</span></div>
    </div>
  </div>
</div></section>

<!-- ═══ ANIMATED COUNTERS ═══ -->
<section class="sec"><div class="sw">
  <h2 class="t2 tc an">{{ t.statsTitle }}</h2>
  <div class="counters counter-trigger">
    <div class="ctr-i"><div class="ctr-v">{{ counters.users >= 50000 ? '50,000+' : counters.users.toLocaleString() }}</div><div class="ctr-l">{{ t.stat1L }}</div></div>
    <div class="ctr-i"><div class="ctr-v">{{ counters.countries }}+</div><div class="ctr-l">{{ t.stat2L }}</div></div>
    <div class="ctr-i"><div class="ctr-v">{{ counters.currencies }}+</div><div class="ctr-l">{{ t.stat3L }}</div></div>
    <div class="ctr-i"><div class="ctr-v">{{ counters.uptime }}%</div><div class="ctr-l">{{ t.stat4L }}</div></div>
  </div>
</div></section>

<!-- ═══ MORE WITH SDB ═══ -->
<section class="sec sec-alt"><div class="sw">
  <h2 class="t2 tc an">{{ t.moreTitle }}</h2>
  <div class="more-grid" data-stagger>
    <Link v-for="m in t.moreCards" :key="m.t" :href="m.href" class="more-c">
      <span class="more-ic">{{ m.ic }}</span>
      <h4 class="more-t">{{ m.t }}</h4>
      <p class="more-d">{{ m.d }}</p>
    </Link>
  </div>
</div></section>

<!-- ═══ CTA ═══ -->
<section class="sec sec-cta"><div class="sw tc">
  <div class="cta-tag an">{{ t.ctaTag }}</div>
  <h2 class="t2 an">{{ t.ctaTitle }}</h2>
  <p class="t2-sub an tc" style="margin:0 auto 32px">{{ t.ctaSub }}</p>
  <div class="cta-row an"><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a><a href="/support" class="cta-btn2">{{ t.ctaBtn2 }}</a></div>
</div></section>
</template>

<style scoped>
/* ═══ HERO ═══ */
.hero{padding:160px 0 80px;background:linear-gradient(-45deg,#F0F9FF,#E0F2FE,#BAE6FD,#F0F9FF);background-size:400% 400%;animation:heroGrad 15s ease infinite;position:relative;overflow:hidden}
.hero::after{content:'';position:absolute;top:-20%;right:-10%;width:50%;height:140%;background:radial-gradient(ellipse,rgba(14,165,233,.08) 0%,transparent 65%);pointer-events:none;animation:heroBlob 8s ease-in-out infinite}
.rtl .hero::after{right:auto;left:-10%}
@keyframes heroGrad{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
@keyframes heroBlob{0%,100%{transform:translate(0,0) scale(1)}33%{transform:translate(30px,-20px) scale(1.05)}66%{transform:translate(-20px,10px) scale(.95)}}
.hero-grid{display:grid;grid-template-columns:1.1fr 1fr;gap:48px;align-items:center;position:relative;z-index:1}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:#0EA5E9;margin-bottom:24px;text-transform:uppercase}.rtl .hero-tag{letter-spacing:0}
.hero-h{margin-bottom:20px;line-height:1.05}
.hero-h1,.hero-h2{display:block;font-size:clamp(2.4rem,5vw,4rem);font-weight:900;letter-spacing:-.04em}.hero-h1{color:#0C4A6E}.hero-h2{color:#0EA5E9}.rtl .hero-h1,.rtl .hero-h2{letter-spacing:0}
.hero-p{font-size:17px;color:rgba(10,10,10,.6);line-height:1.85;margin-bottom:36px;max-width:480px}
.hero-cd{display:flex;gap:20px;margin-bottom:32px}
.cd-b{text-align:center}.cd-n{font-size:40px;font-weight:900;color:#0a0a0a;line-height:1;font-variant-numeric:tabular-nums}.cd-l{font-size:10px;color:rgba(10,10,10,.4);margin-top:4px;font-weight:700;letter-spacing:1px;text-transform:uppercase}
.hero-eml{display:flex;gap:0;max-width:420px;border:2px solid #0a0a0a;border-radius:14px;overflow:hidden;margin-bottom:28px}
.eml-i{flex:1;padding:14px 18px;border:none;outline:none;font-size:15px;background:transparent;color:#0a0a0a;font-family:inherit}.eml-i::placeholder{color:#ccc}
.eml-b{padding:14px 24px;background:#0a0a0a;color:#fff;border:none;font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;transition:background .2s;white-space:nowrap}.eml-b:hover{background:#222}
.eml-ok{padding:14px;color:#0EA5E9;font-weight:700;font-size:14px}
.rtl .hero-eml{flex-direction:row-reverse}
.hero-trust{display:flex;gap:16px;flex-wrap:wrap}.trust-i{font-size:12px;color:rgba(10,10,10,.5);font-weight:700}

/* ═══ MINI CONVERTER ═══ */
.conv-mini{background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:24px;padding:28px;box-shadow:0 16px 48px rgba(0,0,0,.06);position:relative}
.conv-head{font-size:14px;font-weight:800;color:#0C4A6E;margin-bottom:20px;text-align:center}
.conv-field{margin-bottom:8px}.conv-lbl{font-size:12px;font-weight:700;color:rgba(10,10,10,.55);margin-bottom:6px;display:block}
.conv-row{display:flex;gap:8px;align-items:center}
.conv-sel{padding:12px;border:1px solid rgba(14,165,233,.1);border-radius:12px;font-size:16px;font-weight:800;color:#0C4A6E;background:#F8FAFC;cursor:pointer;font-family:inherit;outline:none;min-width:80px}
.conv-inp{flex:1;padding:12px;border:1px solid rgba(14,165,233,.1);border-radius:12px;font-size:22px;font-weight:900;color:#0C4A6E;outline:none;font-family:inherit;text-align:end;background:#F8FAFC}.conv-inp:focus{border-color:#0EA5E9}
.conv-inp::-webkit-inner-spin-button,.conv-inp::-webkit-outer-spin-button{-webkit-appearance:none}.conv-inp{-moz-appearance:textfield}
.rtl .conv-inp{text-align:start}
.conv-res{flex:1;padding:12px;background:#F0F9FF;border-radius:12px;font-size:22px;font-weight:900;color:#0EA5E9;text-align:end}.rtl .conv-res{text-align:start}
.conv-swap-mini{text-align:center;font-size:16px;color:rgba(14,165,233,.3);margin:4px 0;cursor:pointer;transition:color .2s}.conv-swap-mini:hover{color:#0EA5E9}
.conv-rate{font-size:12px;color:rgba(10,10,10,.5);text-align:center;margin:12px 0;font-weight:600}
.conv-cta{display:block;padding:14px;background:linear-gradient(135deg,#0EA5E9,#0369A1);color:#fff;font-size:15px;font-weight:800;text-align:center;border-radius:12px;text-decoration:none;transition:all .2s}.conv-cta:hover{transform:translateY(-2px);box-shadow:0 6px 20px rgba(14,165,233,.2)}

/* ═══ MARQUEE ═══ */
.mq{padding:16px 0;border-top:1px solid rgba(0,0,0,.04);border-bottom:1px solid rgba(0,0,0,.04);overflow:hidden;background:#fafafa}
.mq-track{display:flex;gap:48px;animation:mqs 25s linear infinite;white-space:nowrap}
.mq-i{font-size:13px;font-weight:800;color:rgba(10,10,10,.06);letter-spacing:3px;text-transform:uppercase}
@keyframes mqs{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}

/* ═══ SECTIONS ═══ */
.sec{padding:100px 0}.sec-alt{background:#FAFAFA}.sec-dark{background:linear-gradient(135deg,#0C4A6E,#0369A1,#0EA5E9);color:#fff}.sec-cta{padding:120px 0;background:linear-gradient(135deg,#F0F9FF,#E0F2FE)}
.sec-hdr{margin-bottom:48px}.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.t2{font-size:clamp(1.8rem,4vw,3rem);font-weight:900;line-height:1.1;letter-spacing:-.02em;margin-bottom:16px;color:#0C4A6E}.rtl .t2{letter-spacing:0}
.t2-em{color:#0EA5E9}.t2-w{color:#fff}.t2-em-w{color:#7DD3FC}
.t2-sub{font-size:16px;color:rgba(10,10,10,.6);line-height:1.85;max-width:520px;margin-top:8px}.t2-sub-w{color:rgba(255,255,255,.65)}

/* ═══ COMPARISON TABLE ═══ */
.comp-table{max-width:700px;margin:0 auto;border:1px solid rgba(14,165,233,.08);border-radius:20px;overflow:hidden;box-shadow:0 4px 16px rgba(0,0,0,.03)}
.comp-header{display:grid;grid-template-columns:1fr 1fr 1fr;background:#F0F9FF}
.comp-header .comp-f,.comp-header .comp-v{padding:16px 20px;font-size:14px;font-weight:800;color:#0C4A6E}
.comp-sdb-h{color:#059669!important;background:rgba(5,150,105,.04)}.comp-bank-h{color:rgba(10,10,10,.5)!important}
.comp-row{display:grid;grid-template-columns:1fr 1fr 1fr;border-top:1px solid rgba(14,165,233,.06);transition:background .2s}.comp-row:hover{background:rgba(14,165,233,.02)}
.comp-f{padding:14px 20px;font-size:14px;font-weight:700;color:#0C4A6E}
.comp-v{padding:14px 20px;font-size:14px}
.comp-sdb{color:#059669;font-weight:700}.comp-bank{color:rgba(10,10,10,.4);text-decoration:line-through}

/* ═══ SERVICE CARDS ═══ */
.serv-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.serv-c{padding:36px 28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;text-decoration:none;color:inherit;transition:all .4s;display:flex;flex-direction:column}.serv-c:hover{transform:translateY(-6px);box-shadow:0 16px 40px rgba(0,0,0,.06)}
.serv-ic{font-size:36px;display:block;margin-bottom:16px}
.serv-t{font-size:20px;font-weight:900;color:#0C4A6E;margin-bottom:10px}
.serv-d{font-size:14px;color:rgba(10,10,10,.6);line-height:1.8;flex:1}
.serv-btn{font-size:13px;font-weight:700;color:#0EA5E9;margin-top:16px}

/* ═══ FEATURE ROWS ═══ */
.feat-row{display:grid;grid-template-columns:1fr 1fr;gap:60px;align-items:center}
.feat-row-rev{direction:ltr}.rtl .feat-row-rev{direction:rtl}
.feat-points{list-style:none;padding:0;margin:20px 0;display:flex;flex-direction:column;gap:10px}
.feat-points li{font-size:14px;font-weight:600;color:#0C4A6E;padding:10px 16px;background:rgba(14,165,233,.04);border-radius:10px;display:flex;align-items:center;gap:8px}
.feat-points li::before{content:'✓';color:#059669;font-weight:900;font-size:16px}
.feat-points-w li{color:rgba(255,255,255,.9);background:rgba(255,255,255,.08)}
.feat-points-w li::before{color:#7DD3FC}
.link-btn{font-size:14px;font-weight:700;color:#0EA5E9;text-decoration:none;transition:opacity .2s}.link-btn:hover{opacity:.7}.link-btn-w{color:#7DD3FC}

/* Feature phone mockup */
.feat-phone{max-width:320px;margin:0 auto;background:#fff;border-radius:28px;padding:24px;box-shadow:0 20px 60px rgba(0,0,0,.08);border:1px solid rgba(14,165,233,.08)}
.fp-notif{display:flex;align-items:center;gap:12px;padding:16px;background:#F0FDF4;border-radius:14px;margin-bottom:16px}
.fp-dot{width:8px;height:8px;background:#059669;border-radius:50%;display:block;animation:pulse 2s infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
.fp-notif-t{font-size:13px;font-weight:800;color:#059669}.fp-notif-v{font-size:18px;font-weight:900;color:#065F46}
.fp-balance{padding:20px;background:#F8FAFC;border-radius:14px;text-align:center}
.fp-bl{font-size:12px;color:rgba(10,10,10,.5);margin-bottom:4px;font-weight:600}.fp-bv{font-size:28px;font-weight:900;color:#0C4A6E}
.fp-bv small{font-size:14px;color:rgba(10,10,10,.45)}

/* Security visual */
.sec-shield{text-align:center}
.shield-ring{width:160px;height:160px;border:3px solid rgba(255,255,255,.1);border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto;animation:ringPulse 3s ease-in-out infinite;position:relative}
.shield-ring::before{content:'';position:absolute;inset:-8px;border:1px solid rgba(255,255,255,.04);border-radius:50%;animation:ringPulse 3s ease-in-out infinite .5s}
.shield-ring2{width:100px;height:100px;background:rgba(255,255,255,.06);border-radius:50%;display:flex;align-items:center;justify-content:center}
.shield-ic{font-size:40px}
@keyframes ringPulse{0%,100%{transform:scale(1);border-color:rgba(255,255,255,.1)}50%{transform:scale(1.05);border-color:rgba(255,255,255,.2)}}
.shield-labels{display:flex;justify-content:center;gap:12px;margin-top:20px}
.shield-labels span{font-size:11px;font-weight:800;color:rgba(255,255,255,.6);padding:6px 14px;border:1px solid rgba(255,255,255,.15);border-radius:8px}

/* ═══ CARD TIERS ═══ */
.tiers{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.tier-c{padding:28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:18px;position:relative;overflow:hidden;text-decoration:none;color:inherit;transition:all .3s}.tier-c:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(0,0,0,.06)}
.tier-bar{height:4px;position:absolute;top:0;left:0;right:0}
.tier-n{font-size:20px;font-weight:900;color:#0C4A6E;margin:12px 0 6px}
.tier-p{font-size:15px;font-weight:800;margin-bottom:10px}
.tier-feat{font-size:13px;color:rgba(10,10,10,.55);line-height:1.6}

/* ═══ TESTIMONIALS ═══ */
.test-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.test-c{padding:32px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;transition:all .3s}.test-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,.05)}
.test-stars{font-size:16px;color:#F59E0B;margin-bottom:14px;letter-spacing:2px}
.test-q{font-size:15px;color:#0C4A6E;line-height:1.8;margin-bottom:16px;font-style:italic}
.test-author{font-size:13px;color:#0C4A6E}.test-loc{color:rgba(10,10,10,.5);margin-inline-start:8px}

/* ═══ ANIMATED COUNTERS ═══ */
.counters{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:rgba(10,10,10,.06);border:1px solid rgba(10,10,10,.06);border-radius:20px;overflow:hidden}
.ctr-i{padding:48px 24px;background:#fff;text-align:center}
.ctr-v{font-size:clamp(2rem,4vw,3rem);font-weight:900;color:#0EA5E9;margin-bottom:6px;font-variant-numeric:tabular-nums}
.ctr-l{font-size:13px;color:rgba(10,10,10,.5);font-weight:700}

/* ═══ MORE GRID ═══ */
.more-grid{display:grid;grid-template-columns:repeat(6,1fr);gap:12px}
.more-c{padding:24px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px;text-align:center;text-decoration:none;color:inherit;transition:all .3s}.more-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.more-ic{font-size:28px;display:block;margin-bottom:8px}
.more-t{font-size:13px;font-weight:800;color:#0C4A6E;margin-bottom:4px}.more-d{font-size:12px;color:rgba(10,10,10,.5);font-weight:500}

/* ═══ CTA ═══ */
.cta-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#0EA5E9;text-transform:uppercase;margin-bottom:20px}.rtl .cta-tag{letter-spacing:0}
.cta-row{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}
.cta-btn{display:inline-block;padding:18px 48px;background:linear-gradient(135deg,#0284C7,#0EA5E9);color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(14,165,233,.2)}
.cta-btn2{display:inline-block;padding:18px 48px;background:transparent;color:#0C4A6E;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;border:2px solid rgba(10,10,10,.1);transition:all .2s}.cta-btn2:hover{border-color:rgba(10,10,10,.3)}

/* ═══ ANIMATIONS ═══ */
.an{opacity:0;transform:translateY(28px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
.an-l{opacity:0;transform:translateX(-40px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an-l.vi{opacity:1;transform:none}
.an-r{opacity:0;transform:translateX(40px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an-r.vi{opacity:1;transform:none}
.an-s{opacity:0;transform:scale(.92);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an-s.vi{opacity:1;transform:none}

/* ═══ RESPONSIVE ═══ */
@media(max-width:900px){
  .hero-grid{grid-template-columns:1fr;gap:32px;text-align:center}
  .hero-grid .an-l,.hero-grid .an-r{text-align:center}
  .hero-sub{margin:0 auto 28px}
  .email-row{justify-content:center;max-width:400px;margin:0 auto 20px}
  .trust-row{justify-content:center}
  .tiers{grid-template-columns:repeat(2,1fr)}
  .serv-grid{grid-template-columns:1fr}
  .counters{grid-template-columns:repeat(2,1fr)}
  .test-grid{grid-template-columns:1fr}
  .more-grid{grid-template-columns:repeat(3,1fr)}
  .feat-row{grid-template-columns:1fr;gap:32px;text-align:center}
  .feat-info{text-align:center}
  .comp-table{border-radius:14px}
}
@media(max-width:600px){
  .hero{padding:120px 0 40px}
  .hero-grid{gap:24px}
  .sec{padding:50px 0}
  .sw{padding:0 16px}
  .t2{font-size:clamp(1.4rem,5vw,2rem);margin-bottom:32px}
  .t2-sub{font-size:14px}
  .hero-h{font-size:clamp(1.8rem,7vw,2.6rem)}
  .hero-sub{font-size:14px;padding:0 8px}
  .email-row{flex-direction:column;gap:8px;padding:0 8px}
  .email-row input{width:100%}
  .email-row button{width:100%}
  .conv-box{margin:0 -8px;border-radius:16px}
  .trust-row{flex-wrap:wrap;gap:8px;font-size:11px}
  .cd{gap:12px}
  .cd-n{font-size:clamp(1.4rem,5vw,2rem)}
  .cd-l{font-size:10px}
  .comp-table{margin:0 -8px;border-radius:12px;font-size:13px}
  .serv-c{padding:28px 20px}
  .tiers{grid-template-columns:1fr;gap:12px}
  .tier{padding:28px 20px}
  .test-c{padding:24px 20px}
  .counters{grid-template-columns:1fr}
  .ctr-i{padding:28px 16px}
  .more-grid{grid-template-columns:repeat(2,1fr);gap:8px}
  .more-c{padding:16px 12px}
  .more-ic{font-size:22px}
  .more-t{font-size:11px}
  .more-d{font-size:10px}
  .feat-row{gap:20px}
  .feat-img{max-width:280px;margin:0 auto}
  .cta-btn,.cta-btn2{width:100%;text-align:center;padding:16px 24px;font-size:15px}
  .cta-row{flex-direction:column;padding:0 16px}
  .partners-row{gap:16px;padding:0 16px}
  .partners-row img{height:18px!important}
}
</style>
