<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, ref, computed, onMounted, onUnmounted } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';

defineOptions({ layout: SiteLayout });

const lang = inject('lang', ref('ar'));
const isAr = inject('isAr', computed(() => true));

/* ─── Countdown — March 22, 2026 ─── */
const launchDate = new Date('2026-03-22T00:00:00');
const cd = ref({ d:0, h:0, m:0, s:0 });
let ti;
function tick(){const x=launchDate-new Date();if(x<=0)return;cd.value={d:Math.floor(x/864e5),h:Math.floor(x%864e5/36e5),m:Math.floor(x%36e5/6e4),s:Math.floor(x%6e4/1e3)}}
const em = ref('');
const done = ref(false);

let obs;
onMounted(()=>{tick();ti=setInterval(tick,1e3);obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.06});document.querySelectorAll('.an').forEach(el=>obs.observe(el))});
onUnmounted(()=>{clearInterval(ti);obs?.disconnect()});

const t = computed(() => isAr.value ? {
  /* Hero */
  tag: 'أول بنك إلكتروني سوري',
  hd1: 'سوريا تدخل',
  hd2: 'عصر البنوك الرقمية',
  sub: 'افتح حسابك من سوريا أو من أي مكان بالعالم. استلم معاشك، حوّل أموالك، وادفع فواتيرك — كل شيء من تطبيق واحد.',
  days:'يوم',hrs:'ساعة',min:'دقيقة',sec:'ثانية',
  emailPh:'بريدك الإلكتروني...',notify:'سجّل الآن',emailDone:'✓ تم! سنبلغك فور الإطلاق.',
  trust:['🇩🇰 مرخّص في الدنمارك','🇸🇾 مصمم للسوريين','🔒 تشفير 256-بت','🏦 ماستركارد معتمد'],
  /* For every Syrian */
  everyTitle:'لكل سوري',
  everyFade:'بالعالم.',
  everyDesc:'سواء كنت بدمشق أو برلين، بحلب أو إسطنبول — حسابك البنكي الرقمي جاهز بدقائق. لا فروع، لا طوابير، لا بيروقراطية. فقط هاتفك.',
  everyCards:[
    {ic:'🇸🇾',t:'داخل سوريا',d:'افتح حسابك وأنت بسوريا واستفد من كل خدماتنا البنكية'},
    {ic:'🌍',t:'خارج سوريا',d:'أي سوري بالعالم يقدر يفتح حساب ويحوّل لأهله بأقل الرسوم'},
    {ic:'📱',t:'بدقائق',d:'تسجيل سريع وتحقق رقمي — حسابك جاهز خلال دقائق'},
  ],
  /* Features */
  featTitle:'كل ما تحتاجه.',
  featFade:'لا شيء زائد.',
  features:[
    {ic:'💰',t:'استلام المعاشات',d:'معاشك يوصل مباشرة لحسابك الرقمي. بدون تأخير، بدون وسطاء. إشعار فوري عند الوصول.',tag:'رواتب'},
    {ic:'💳',t:'بطاقات ماستركارد',d:'بطاقة افتراضية فورية عند التسجيل. أو بطاقة معدنية فاخرة. ادفع بـ Apple Pay بأي مكان بالعالم.',tag:'بطاقات'},
    {ic:'💱',t:'أكثر من 30 عملة',d:'احتفظ وحوّل بأسعار السوق الحقيقية. يورو، دولار، جنيه إسترليني، ليرة تركية، درهم والمزيد.',tag:'عملات'},
    {ic:'⚡',t:'تحويلات فورية',d:'تحويلات داخلية مجانية بالكامل. دولية بـ 0.5% فقط. أرسل لأهلك بسوريا بأقل الرسوم.',tag:'تحويلات'},
    {ic:'🛡️',t:'أمان لا يُخترق',d:'تشفير بنكي 256-بت. مصادقة بالوجه والبصمة. فريق مراقبة احتيال يعمل 24/7.',tag:'أمان'},
    {ic:'🧾',t:'دفع الفواتير',d:'قريباً: ادفع فواتير الكهرباء والماء والإنترنت والهاتف مباشرة من التطبيق.',tag:'قريباً'},
  ],
  /* Tech section */
  techTag:'التأخر التكنولوجي انتهى',
  techTitle:'تكنولوجيا أوروبية.',
  techFade:'بروح سورية.',
  techDesc:'سنوات الحرب خلّفت فجوة تكنولوجية هائلة في القطاع المالي السوري. SDB Bank يسد هذه الفجوة بتقنيات أوروبية متقدمة — بنك رقمي بالكامل، بدون فروع، بدون ورق، بدون طوابير.',
  techFeats:[
    {ic:'☁️',t:'بنية سحابية',d:'خوادم أوروبية آمنة بأعلى معايير الحماية'},
    {ic:'🔐',t:'تشفير AES-256',d:'نفس التقنية المستخدمة بالبنوك العالمية'},
    {ic:'📲',t:'تطبيق ذكي',d:'iOS و Android — كل شيء من هاتفك'},
    {ic:'🪪',t:'تحقق رقمي',d:'KYC رقمي بدون أوراق أو زيارة فرع'},
  ],
  /* Salary */
  salaryTitle:'معاشك.',
  salaryFade:'بين يديك فوراً.',
  salaryDesc:'استلم معاشك مباشرة في حسابك البنكي الرقمي. بدون وسطاء، بدون تأخير.',
  salaryCards:[
    {ic:'📥',t:'إيداع مباشر',d:'معاشك يصل تلقائياً لحسابك'},
    {ic:'🔔',t:'إشعار لحظي',d:'تنبيه فوري عند وصول الراتب'},
    {ic:'🆓',t:'بدون رسوم',d:'لا رسوم على استلام الراتب'},
    {ic:'📊',t:'تحليل ذكي',d:'تتبع مصاريفك تلقائياً'},
  ],
  /* Transfers */
  trTitle:'حوّل لأهلك.',
  trFade:'بأقل الرسوم.',
  trDesc:'تحويلات داخلية مجانية بالكامل. دولية بـ 0.5% فقط. حتى من خارج سوريا تقدر تحوّل بلحظات.',
  trFeats:[
    {v:'مجاني',l:'تحويل داخلي',d:'بين حسابات SDB'},
    {v:'0.5%',l:'تحويل دولي',d:'SWIFT لأي بنك بالعالم'},
    {v:'فوري',l:'SEPA أوروبي',d:'يوصل بثوانٍ'},
    {v:'150+',l:'دولة',d:'أرسل لأي مكان'},
  ],
  /* Coming soon */
  soonTitle:'قريباً.',
  soonFade:'دفع الفواتير.',
  soonDesc:'ادفع فواتيرك من التطبيق — كهرباء، ماء، إنترنت، هاتف. بدون طوابير، بدون تأخير.',
  soonItems:['⚡ فواتير الكهرباء','💧 فواتير المياه','🌐 فواتير الإنترنت','📱 شحن الهاتف','🏠 إيجار المنزل','🎓 أقساط جامعية'],
  /* Stats */
  stats:[{v:'30+',l:'عملة'},{v:'150+',l:'دولة'},{v:'24/7',l:'دعم فني'},{v:'0',l:'رسوم مخفية'}],
  /* CTA */
  ctaTag:'جاهز؟',
  ctaTitle:'مستقبلك المالي يبدأ هنا.',
  ctaSub:'افتح حسابك المجاني بدقيقتين. بدون فروع، بدون أوراق.',
  ctaBtn:'افتح حسابك المجاني ←',
} : {
  tag:'The First Syrian Digital Bank',
  hd1:'Syria enters the',
  hd2:'digital banking era',
  sub:'Open your account from Syria or anywhere in the world. Receive your salary, transfer money, and pay your bills — all from one app.',
  days:'Days',hrs:'Hrs',min:'Min',sec:'Sec',
  emailPh:'Your email...',notify:'Sign up',emailDone:'✓ Done! We\'ll notify you at launch.',
  trust:['🇩🇰 Licensed in Denmark','🇸🇾 Built for Syrians','🔒 256-bit encrypted','🏦 Mastercard certified'],
  everyTitle:'For every Syrian.',
  everyFade:'Worldwide.',
  everyDesc:'Whether you\'re in Damascus or Berlin, Aleppo or Istanbul — your digital bank account is ready in minutes. No branches, no queues, no bureaucracy. Just your phone.',
  everyCards:[
    {ic:'🇸🇾',t:'Inside Syria',d:'Open your account while in Syria and access all our banking services'},
    {ic:'🌍',t:'Outside Syria',d:'Any Syrian worldwide can open an account and send money home at the lowest fees'},
    {ic:'📱',t:'In Minutes',d:'Quick registration and digital verification — your account is ready in minutes'},
  ],
  featTitle:'Everything you need.',
  featFade:'Nothing you don\'t.',
  features:[
    {ic:'💰',t:'Salary Deposits',d:'Your salary arrives directly into your digital account. No delays, no middlemen. Instant notification on arrival.',tag:'SALARY'},
    {ic:'💳',t:'Mastercard Cards',d:'Instant virtual card on signup. Or a premium metal card. Pay with Apple Pay anywhere in the world.',tag:'CARDS'},
    {ic:'💱',t:'30+ Currencies',d:'Hold and convert at real market rates. EUR, USD, GBP, TRY, AED and more.',tag:'FX'},
    {ic:'⚡',t:'Instant Transfers',d:'Free domestic transfers. International at only 0.5%. Send to your family in Syria at the lowest fees.',tag:'TRANSFERS'},
    {ic:'🛡️',t:'Unbreakable Security',d:'Bank-grade 256-bit encryption. Face ID and fingerprint auth. 24/7 fraud monitoring.',tag:'SECURITY'},
    {ic:'🧾',t:'Bill Payments',d:'Coming soon: Pay electricity, water, internet, and phone bills directly from the app.',tag:'SOON'},
  ],
  techTag:'The tech gap ends here',
  techTitle:'European technology.',
  techFade:'Syrian soul.',
  techDesc:'Years of war left a massive technological gap in Syria\'s financial sector. SDB Bank bridges this gap with advanced European technology — a fully digital bank, no branches, no paper, no queues.',
  techFeats:[
    {ic:'☁️',t:'Cloud Infrastructure',d:'Secure European servers with the highest protection standards'},
    {ic:'🔐',t:'AES-256 Encryption',d:'The same technology used by world\'s leading banks'},
    {ic:'📲',t:'Smart App',d:'iOS & Android — everything from your phone'},
    {ic:'🪪',t:'Digital Verification',d:'Digital KYC without paperwork or branch visits'},
  ],
  salaryTitle:'Your salary.',
  salaryFade:'Instantly yours.',
  salaryDesc:'Receive your salary directly into your digital bank account. No middlemen, no delays.',
  salaryCards:[
    {ic:'📥',t:'Direct Deposit',d:'Salary arrives automatically'},
    {ic:'🔔',t:'Instant Alert',d:'Notification the moment it arrives'},
    {ic:'🆓',t:'Zero Fees',d:'No fees on salary reception'},
    {ic:'📊',t:'Smart Analytics',d:'Track your spending automatically'},
  ],
  trTitle:'Send to family.',
  trFade:'Lowest fees.',
  trDesc:'Free domestic transfers. International at only 0.5%. Even from outside Syria, you can transfer in seconds.',
  trFeats:[
    {v:'Free',l:'Domestic',d:'Between SDB accounts'},
    {v:'0.5%',l:'International',d:'SWIFT to any bank worldwide'},
    {v:'Instant',l:'SEPA Europe',d:'Arrives in seconds'},
    {v:'150+',l:'Countries',d:'Send anywhere'},
  ],
  soonTitle:'Coming soon.',
  soonFade:'Bill payments.',
  soonDesc:'Pay your bills from the app — electricity, water, internet, phone. No queues, no delays.',
  soonItems:['⚡ Electricity bills','💧 Water bills','🌐 Internet bills','📱 Phone top-up','🏠 Rent payments','🎓 University fees'],
  stats:[{v:'30+',l:'Currencies'},{v:'150+',l:'Countries'},{v:'24/7',l:'Support'},{v:'0',l:'Hidden Fees'}],
  ctaTag:'Ready?',
  ctaTitle:'Your financial future starts here.',
  ctaSub:'Open your free account in 2 minutes. No branches, no paperwork.',
  ctaBtn:'Open your free account →',
});
</script>

<template>
<Head :title="isAr ? 'SDB Bank — أول بنك إلكتروني سوري' : 'SDB Bank — First Syrian Digital Bank'">
  <meta :content="isAr ? 'SDB Bank — أول بنك إلكتروني سوري. افتح حسابك من سوريا أو أي مكان بالعالم.' : 'SDB Bank — The first Syrian digital bank. Open your account from Syria or anywhere.'" name="description" />
</Head>

<!-- HERO -->
<section class="hero">
  <div class="sw hero-inner">
    <div class="hero-tag an">{{ t.tag }}</div>
    <h1 class="hero-h an">
      <span class="hero-h1">{{ t.hd1 }}</span>
      <span class="hero-h2">{{ t.hd2 }}</span>
    </h1>
    <p class="hero-p an">{{ t.sub }}</p>
    <div class="hero-cd an">
      <div v-for="(lb,k) in {d:t.days,h:t.hrs,m:t.min,s:t.sec}" :key="k" class="cd-b">
        <div class="cd-n">{{ String(cd[k]).padStart(2,'0') }}</div>
        <div class="cd-l">{{ lb }}</div>
      </div>
    </div>
    <div class="hero-eml an">
      <template v-if="!done">
        <input v-model="em" type="email" :placeholder="t.emailPh" class="eml-i" @keyup.enter="done=!!em"/>
        <button @click="done=!!em" class="eml-b">{{ t.notify }}</button>
      </template>
      <div v-else class="eml-ok">{{ t.emailDone }}</div>
    </div>
    <div class="hero-trust an">
      <span v-for="tr in t.trust" :key="tr" class="trust-i">{{ tr }}</span>
    </div>
  </div>
</section>

<!-- Marquee -->
<div class="mq"><div class="mq-track"><span v-for="(p,i) in ['Mastercard','Visa','Apple Pay','Google Pay','SWIFT','SEPA','Syria','Mastercard','Visa','Apple Pay','Google Pay','SWIFT','SEPA','Syria']" :key="i" class="mq-i">{{ p }}</span></div></div>

<!-- For Every Syrian -->
<section class="sec">
  <div class="sw">
    <div class="sec-hdr an">
      <h2 class="t2">{{ t.everyTitle }}<br><span class="t2-em">{{ t.everyFade }}</span></h2>
      <p class="t2-sub">{{ t.everyDesc }}</p>
    </div>
    <div class="g3 an">
      <div v-for="(c,i) in t.everyCards" :key="i" class="ev-card" :style="{transitionDelay:(i*80)+'ms'}">
        <span class="ev-ic">{{ c.ic }}</span>
        <h3 class="ev-t">{{ c.t }}</h3>
        <p class="ev-d">{{ c.d }}</p>
      </div>
    </div>
  </div>
</section>

<!-- Features Grid -->
<section class="sec sec-alt">
  <div class="sw">
    <div class="sec-hdr an">
      <h2 class="t2">{{ t.featTitle }}<br><span class="t2-fade">{{ t.featFade }}</span></h2>
    </div>
    <div class="fg an">
      <div v-for="(f,i) in t.features" :key="i" class="fc" :style="{transitionDelay:(i*60)+'ms'}">
        <div class="fc-top"><span class="fc-tag">{{ f.tag }}</span><span class="fc-ic">{{ f.ic }}</span></div>
        <h3 class="fc-t">{{ f.t }}</h3>
        <p class="fc-p">{{ f.d }}</p>
      </div>
    </div>
  </div>
</section>

<!-- Technology Section -->
<section class="sec sec-dark">
  <div class="sw">
    <div class="sec-hdr an">
      <div class="tech-tag">{{ t.techTag }}</div>
      <h2 class="t2 t2-w">{{ t.techTitle }}<br><span class="t2-em-w">{{ t.techFade }}</span></h2>
      <p class="t2-sub t2-sub-w">{{ t.techDesc }}</p>
    </div>
    <div class="g4 an">
      <div v-for="(f,i) in t.techFeats" :key="i" class="tech-card" :style="{transitionDelay:(i*80)+'ms'}">
        <span class="tech-ic">{{ f.ic }}</span>
        <h4 class="tech-t">{{ f.t }}</h4>
        <p class="tech-d">{{ f.d }}</p>
      </div>
    </div>
  </div>
</section>

<!-- Salary Section -->
<section class="sec">
  <div class="sw">
    <div class="sec-hdr an">
      <h2 class="t2">{{ t.salaryTitle }}<br><span class="t2-em">{{ t.salaryFade }}</span></h2>
      <p class="t2-sub">{{ t.salaryDesc }}</p>
    </div>
    <div class="g4 an">
      <div v-for="(c,i) in t.salaryCards" :key="i" class="sal-card" :style="{transitionDelay:(i*80)+'ms'}">
        <span class="sal-ic">{{ c.ic }}</span>
        <h4 class="sal-t">{{ c.t }}</h4>
        <p class="sal-d">{{ c.d }}</p>
      </div>
    </div>
  </div>
</section>

<!-- Transfers Section -->
<section class="sec sec-alt">
  <div class="sw">
    <div class="sec-hdr an">
      <h2 class="t2">{{ t.trTitle }}<br><span class="t2-em">{{ t.trFade }}</span></h2>
      <p class="t2-sub">{{ t.trDesc }}</p>
    </div>
    <div class="g4 an">
      <div v-for="(f,i) in t.trFeats" :key="i" class="tr-card" :style="{transitionDelay:(i*80)+'ms'}">
        <div class="tr-v">{{ f.v }}</div>
        <div class="tr-l">{{ f.l }}</div>
        <div class="tr-d">{{ f.d }}</div>
      </div>
    </div>
  </div>
</section>

<!-- Coming Soon — Bills -->
<section class="sec sec-dark">
  <div class="sw">
    <div class="sec-hdr an">
      <h2 class="t2 t2-w">{{ t.soonTitle }}<br><span class="t2-em-w">{{ t.soonFade }}</span></h2>
      <p class="t2-sub t2-sub-w">{{ t.soonDesc }}</p>
    </div>
    <div class="soon-grid an">
      <div v-for="(s,i) in t.soonItems" :key="i" class="soon-item">{{ s }}</div>
    </div>
  </div>
</section>

<!-- Stats -->
<section class="sec">
  <div class="sw">
    <div class="stats an">
      <div v-for="s in t.stats" :key="s.v" class="stat-i">
        <div class="stat-v">{{ s.v }}</div>
        <div class="stat-l">{{ s.l }}</div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="sec sec-cta">
  <div class="sw" style="text-align:center">
    <div class="cta-tag an">{{ t.ctaTag }}</div>
    <h2 class="t2 an" style="margin-bottom:16px">{{ t.ctaTitle }}</h2>
    <p class="t2-sub an" style="margin:0 auto 32px;text-align:center">{{ t.ctaSub }}</p>
    <a href="/preregister" class="cta-btn an">{{ t.ctaBtn }}</a>
  </div>
</section>
</template>

<style scoped>
/* ─── Hero ─── */
.hero{padding:180px 0 100px;background:#fff;position:relative;overflow:hidden}
.hero::after{content:'';position:absolute;top:-30%;right:-15%;width:60%;height:160%;background:radial-gradient(ellipse,rgba(37,99,235,.04) 0%,transparent 65%);pointer-events:none}
.rtl .hero::after{right:auto;left:-15%}
.hero-inner{max-width:720px;position:relative;z-index:1}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:#2563EB;margin-bottom:28px;text-transform:uppercase}
.rtl .hero-tag{letter-spacing:0}
.hero-h{margin-bottom:24px;line-height:1.05}
.hero-h1{display:block;font-size:clamp(2.8rem,6.5vw,5rem);font-weight:900;letter-spacing:-.04em;color:#0a0a0a}
.hero-h2{display:block;font-size:clamp(2.8rem,6.5vw,5rem);font-weight:900;letter-spacing:-.04em;color:#2563EB}
.rtl .hero-h1,.rtl .hero-h2{letter-spacing:0}
.hero-p{font-size:17px;color:rgba(10,10,10,.35);line-height:1.9;margin-bottom:48px;max-width:560px}
.hero-cd{display:flex;gap:24px;margin-bottom:40px}
.cd-b{text-align:center;min-width:56px}
.cd-n{font-size:48px;font-weight:900;color:#0a0a0a;line-height:1;font-variant-numeric:tabular-nums}
.cd-l{font-size:10px;color:rgba(10,10,10,.18);margin-top:6px;font-weight:700;letter-spacing:1.2px;text-transform:uppercase}
.hero-eml{display:flex;gap:0;max-width:460px;border:2px solid #0a0a0a;border-radius:14px;overflow:hidden;margin-bottom:40px}
.eml-i{flex:1;padding:15px 20px;border:none;outline:none;font-size:15px;background:transparent;color:#0a0a0a;font-family:inherit}.eml-i::placeholder{color:#ccc}
.eml-b{padding:15px 28px;background:#0a0a0a;color:#fff;border:none;font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;transition:background .2s;white-space:nowrap}.eml-b:hover{background:#222}
.eml-ok{padding:15px;color:#2563EB;font-weight:700;font-size:15px}
.rtl .hero-eml{flex-direction:row-reverse}
.hero-trust{display:flex;gap:20px;flex-wrap:wrap}
.trust-i{font-size:12px;color:rgba(10,10,10,.22);font-weight:600}

/* ─── Marquee ─── */
.mq{padding:18px 0;border-top:1px solid rgba(0,0,0,.04);border-bottom:1px solid rgba(0,0,0,.04);overflow:hidden;background:#fafafa}
.mq-track{display:flex;gap:48px;animation:mqs 20s linear infinite;white-space:nowrap}
.mq-i{font-size:13px;font-weight:800;color:rgba(10,10,10,.07);letter-spacing:3px;text-transform:uppercase}
@keyframes mqs{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}

/* ─── Sections ─── */
.sec{padding:100px 0}
.sec-alt{background:#fafafa}
.sec-dark{background:#0a0a0a;color:#fff}
.sec-cta{padding:120px 0;background:#fff}
.sec-hdr{margin-bottom:56px}
.t2{font-size:clamp(2rem,4.5vw,3.2rem);font-weight:900;line-height:1.1;letter-spacing:-.03em;margin-bottom:16px}
.rtl .t2{letter-spacing:0}
.t2-fade{opacity:.12}
.t2-em{color:#2563EB}
.t2-w{color:#fff}
.t2-em-w{color:#60A5FA}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.85;max-width:540px;margin-top:8px}
.t2-sub-w{color:rgba(255,255,255,.3)}
.rtl .t2-sub{text-align:right}

/* ─── For Every Syrian ─── */
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.ev-card{padding:36px 28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;transition:all .35s}.ev-card:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(0,0,0,.06)}
.ev-ic{font-size:36px;display:block;margin-bottom:16px}
.ev-t{font-size:17px;font-weight:800;margin-bottom:8px}
.ev-d{font-size:13.5px;color:rgba(10,10,10,.35);line-height:1.75}

/* ─── Features Grid ─── */
.fg{display:grid;grid-template-columns:repeat(3,1fr);gap:1px;background:rgba(0,0,0,.06);border:1px solid rgba(0,0,0,.06);border-radius:20px;overflow:hidden}
.fc{padding:36px 28px;background:#fafafa;transition:background .3s}.fc:hover{background:#fff}
.fc-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:18px}
.rtl .fc-top{flex-direction:row-reverse}
.fc-tag{font-size:10px;font-weight:800;letter-spacing:1.5px;color:#2563EB;opacity:.5;text-transform:uppercase}
.rtl .fc-tag{letter-spacing:0}
.fc-ic{font-size:28px}
.fc-t{font-size:16px;font-weight:800;margin-bottom:8px}
.fc-p{font-size:13px;color:rgba(10,10,10,.3);line-height:1.8}

/* ─── Tech Section ─── */
.tech-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#60A5FA;text-transform:uppercase;margin-bottom:20px}
.rtl .tech-tag{letter-spacing:0}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.06);border-radius:16px;overflow:hidden}
.tech-card{padding:32px 24px;background:#0a0a0a;text-align:center;transition:background .3s}.tech-card:hover{background:#111}
.tech-ic{font-size:32px;display:block;margin-bottom:12px}
.tech-t{font-size:14px;font-weight:800;color:#fff;margin-bottom:6px}
.tech-d{font-size:12px;color:rgba(255,255,255,.2);line-height:1.6}

/* ─── Salary Section ─── */
.sal-card{padding:32px 24px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px;text-align:center;transition:all .3s}.sal-card:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,.05)}
.sal-ic{font-size:28px;display:block;margin-bottom:10px}
.sal-t{font-size:14px;font-weight:800;margin-bottom:4px}
.sal-d{font-size:12px;color:rgba(10,10,10,.3);line-height:1.5}
.sec:not(.sec-dark) .g4{background:rgba(0,0,0,.06);border-color:rgba(0,0,0,.06)}
.sec:not(.sec-dark) .g4>div{background:#fff}

/* ─── Transfers ─── */
.tr-card{padding:32px 24px;background:#fafafa;text-align:center;border:1px solid rgba(10,10,10,.06);border-radius:16px;transition:all .3s}.tr-card:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,.05)}
.tr-v{font-size:32px;font-weight:900;color:#2563EB;margin-bottom:4px}
.tr-l{font-size:14px;font-weight:700;margin-bottom:4px}
.tr-d{font-size:12px;color:rgba(10,10,10,.3)}

/* ─── Coming Soon ─── */
.soon-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.soon-item{padding:20px 24px;background:rgba(255,255,255,.04);border:1px solid rgba(255,255,255,.06);border-radius:12px;font-size:14px;font-weight:600;color:rgba(255,255,255,.5);transition:all .3s}.soon-item:hover{background:rgba(255,255,255,.08);border-color:rgba(255,255,255,.12)}

/* ─── Stats ─── */
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:rgba(10,10,10,.06);border:1px solid rgba(10,10,10,.06);border-radius:16px;overflow:hidden}
.stat-i{padding:48px 24px;background:#fff;text-align:center}
.stat-v{font-size:44px;font-weight:900;color:#0a0a0a;margin-bottom:4px}
.stat-l{font-size:12px;color:rgba(10,10,10,.2);font-weight:600}

/* ─── CTA ─── */
.cta-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#2563EB;text-transform:uppercase;margin-bottom:20px}
.rtl .cta-tag{letter-spacing:0}
.cta-btn{display:inline-block;padding:18px 52px;background:#0a0a0a;color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s;letter-spacing:-.02em}.cta-btn:hover{background:#222;transform:translateY(-2px)}

/* ─── Animation ─── */
.an{opacity:0;transform:translateY(20px);transition:opacity .6s cubic-bezier(.25,.46,.45,.94),transform .6s cubic-bezier(.25,.46,.45,.94)}.an.vi{opacity:1;transform:none}

/* ─── Responsive ─── */
@media(max-width:768px){
  .hero{padding:130px 0 70px}
  .sec{padding:70px 0}
  .g3,.fg,.soon-grid{grid-template-columns:1fr}
  .g4,.stats{grid-template-columns:repeat(2,1fr)}
  .hero-cd{gap:14px}.cd-n{font-size:36px}
  .hero-trust{flex-direction:column;gap:8px}
  .hero-h1,.hero-h2{font-size:2.5rem}
}
</style>
