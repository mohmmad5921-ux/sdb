<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';
defineProps({ canLogin: Boolean, canRegister: Boolean });
const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');
const toggleLang = () => lang.value = lang.value === 'ar' ? 'en' : 'ar';
const ar = (a, e) => isAr.value ? a : e;

const launchDate = new Date('2026-04-15T00:00:00');
const countdown = ref({ days: 0, hours: 0, minutes: 0, seconds: 0 });
let timer;
function tick() {
  const d = launchDate - new Date();
  if (d <= 0) return;
  countdown.value = {
    days: Math.floor(d / 864e5),
    hours: Math.floor((d % 864e5) / 36e5),
    minutes: Math.floor((d % 36e5) / 6e4),
    seconds: Math.floor((d % 6e4) / 1e3),
  };
}
const email = ref('');
const submitted = ref(false);

let obs;
onMounted(() => { tick(); timer = setInterval(tick, 1000); obs = new IntersectionObserver(e => e.forEach(x => { if (x.isIntersecting) x.target.classList.add('vi'); }), { threshold: 0.1 }); document.querySelectorAll('.an').forEach(el => obs.observe(el)); });
onUnmounted(() => { clearInterval(timer); obs?.disconnect(); });
</script>

<template>
<Head :title="ar('SDB Bank — قريباً','SDB Bank — Coming Soon')">
  <meta name="description" :content="ar('SDB Bank — البنك الرقمي الجديد','SDB Bank — The new digital bank')" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Cairo:wght@300;400;600;700;800;900&display=swap" rel="stylesheet" />
</Head>

<div :class="['page', isAr ? 'rtl ar-font' : 'ltr']" :dir="isAr ? 'rtl' : 'ltr'">

<!-- Top bar -->
<header class="topbar">
  <div class="wrap flex items-center justify-between">
    <a href="/" class="logo">SDB<span class="logo-dot">.</span></a>
    <div class="flex items-center gap-5">
      <button @click="toggleLang" class="lang">{{ ar('EN','عربي') }}</button>
      <Link v-if="canLogin" :href="route('login')" class="login-link">{{ ar('دخول','Log in') }}</Link>
      <Link v-if="canRegister" :href="route('register')" class="cta-sm">{{ ar('سجّل مبكراً','Early access') }}</Link>
    </div>
  </div>
</header>

<!-- Hero -->
<section class="hero">
  <div class="wrap hero-inner">
    <p class="pill an">{{ ar('نطلق قريباً','Launching Soon') }}</p>
    <h1 class="h1 an">{{ ar('طريقة جديدة كلياً\nلإدارة أموالك','A completely new way\nto manage your money') }}</h1>
    <p class="hero-p an">{{ ar('حسابات متعددة العملات · بطاقات Mastercard · تداول كريبتو · تحويلات دولية','Multi-currency accounts · Mastercard cards · Crypto trading · International transfers') }}</p>

    <div class="timer an">
      <div v-for="(label, key) in { days: ar('يوم','days'), hours: ar('ساعة','hrs'), minutes: ar('دقيقة','min'), seconds: ar('ثانية','sec') }" :key="key" class="timer-block">
        <span class="timer-n">{{ String(countdown[key]).padStart(2,'0') }}</span>
        <span class="timer-l">{{ label }}</span>
      </div>
    </div>

    <div class="email-row an">
      <template v-if="!submitted">
        <input v-model="email" type="email" class="email-in" :placeholder="ar('بريدك الإلكتروني','Your email')" @keyup.enter="submitted = !!email" />
        <button class="email-btn" @click="submitted = !!email">{{ ar('أُبلغني','Notify me') }}</button>
      </template>
      <p v-else class="done-msg">✓ {{ ar('تم! سنُبلغك عند الإطلاق','Done! We\'ll notify you at launch') }}</p>
    </div>
  </div>
</section>

<!-- What we offer -->
<section class="sec">
  <div class="wrap">
    <h2 class="h2 an">{{ ar('كل ما تحتاجه في مكان واحد','Everything you need in one place') }}</h2>
    <div class="grid3">
      <div v-for="(f,i) in [
        { icon:'💳', title:ar('بطاقات Mastercard','Mastercard Cards'), text:ar('بطاقة افتراضية فورية أو معدنية فاخرة. ادفع في أي مكان بالعالم وأضفها لـ Apple Pay.','Instant virtual or premium metal card. Pay anywhere and add to Apple Pay.') },
        { icon:'🌍', title:ar('30+ عملة','30+ Currencies'), text:ar('احتفظ بأرصدة وحوّل بأسعار السوق الحقيقية بدون عمولات مخفية.','Hold balances and convert at real market rates with no hidden fees.') },
        { icon:'🪙', title:ar('تداول كريبتو','Crypto Trading'), text:ar('اشترِ وبِع Bitcoin وEthereum وعملات أخرى. محافظ حقيقية على البلوكتشين.','Buy and sell Bitcoin, Ethereum and more. Real blockchain wallets.') },
        { icon:'⚡', title:ar('تحويلات فورية','Instant Transfers'), text:ar('أرسل لـ 150+ دولة بأقل الرسوم عبر SWIFT وSEPA. يوصل بدقائق.','Send to 150+ countries at low fees via SWIFT & SEPA. Arrives in minutes.') },
        { icon:'🛡️', title:ar('أمان بنكي','Bank-grade Security'), text:ar('تشفير 256-bit ومصادقة ثنائية ومراقبة احتيال على مدار الساعة.','256-bit encryption, 2FA, and 24/7 fraud monitoring.') },
        { icon:'📱', title:ar('تطبيق iOS + Android','iOS + Android App'), text:ar('تحكم كامل بحساباتك وبطاقاتك وتداولاتك من هاتفك.','Full control of accounts, cards and trades from your phone.') }
      ]" :key="i" class="card an" :style="{ transitionDelay: (i*70)+'ms' }">
        <span class="card-icon">{{ f.icon }}</span>
        <h3 class="card-t">{{ f.title }}</h3>
        <p class="card-p">{{ f.text }}</p>
      </div>
    </div>
  </div>
</section>

<!-- Crypto -->
<section class="sec sec-alt">
  <div class="wrap text-center">
    <h2 class="h2 an">{{ ar('عملاتك الرقمية، محفظتك الحقيقية','Your crypto, your real wallet') }}</h2>
    <p class="sub an">{{ ar('كل عميل يحصل على عنوان محفظة معترف به عالمياً. أرسل واستقبل بحرية.','Every customer gets a globally recognized wallet address. Send and receive freely.') }}</p>
    <div class="coins an">
      <div v-for="c in [{s:'BTC',n:'Bitcoin',cl:'#F7931A'},{s:'ETH',n:'Ethereum',cl:'#627EEA'},{s:'USDT',n:'Tether',cl:'#26A17B'},{s:'SOL',n:'Solana',cl:'#9945FF'},{s:'XRP',n:'Ripple',cl:'#23292F'},{s:'ADA',n:'Cardano',cl:'#3CC8C8'}]" :key="c.s" class="coin">
        <span class="coin-dot" :style="{ background: c.cl }"></span>
        <span class="coin-name">{{ c.n }}</span>
        <span class="coin-sym">{{ c.s }}</span>
      </div>
    </div>
    <div class="grid4 an">
      <div v-for="f in [
        {icon:'📥',t:ar('استقبال','Receive')},
        {icon:'📤',t:ar('إرسال','Send')},
        {icon:'💱',t:ar('تحويل','Swap')},
        {icon:'📊',t:ar('أسعار حية','Live Prices')}
      ]" :key="f.t" class="mini-card">
        <span class="text-2xl">{{ f.icon }}</span>
        <span class="mini-t">{{ f.t }}</span>
      </div>
    </div>
  </div>
</section>

<!-- Plans -->
<section class="sec">
  <div class="wrap text-center">
    <h2 class="h2 an">{{ ar('خطط بسيطة وواضحة','Simple, clear plans') }}</h2>
    <div class="plans an">
      <div v-for="(p,i) in [
        {n:'Standard',pr:ar('مجاناً','Free'),items:[ar('بطاقة افتراضية','Virtual card'),'Apple Pay & Google Pay',ar('حساب EUR + USD','EUR + USD account')]},
        {n:'Premium',pr:'7.99€',pop:true,items:[ar('صرف عملات غير محدود','Unlimited FX'),ar('تأمين سفر','Travel insurance'),ar('صالات مطارات','Lounge access')]},
        {n:'Elite',pr:'14.99€',items:[ar('استرداد نقدي 1%','1% cashback'),ar('مدير حساب خاص','Personal manager'),ar('صالات VIP غير محدودة','Unlimited VIP lounges')]}
      ]" :key="i" class="plan" :class="{ 'plan-pop': p.pop }">
        <h3 class="plan-n">{{ p.n }}</h3>
        <div class="plan-pr">{{ p.pr }}<span v-if="!['مجاناً','Free'].includes(p.pr)" class="plan-mo">/{{ ar('شهرياً','mo') }}</span></div>
        <ul class="plan-list"><li v-for="item in p.items" :key="item"><span class="chk">✓</span>{{ item }}</li></ul>
      </div>
    </div>
  </div>
</section>

<!-- Numbers -->
<section class="sec sec-dark">
  <div class="wrap">
    <div class="nums an">
      <div v-for="s in [{v:'30+',l:ar('عملة','currencies')},{v:'6',l:ar('عملة رقمية','cryptos')},{v:'150+',l:ar('دولة','countries')},{v:'24/7',l:ar('دعم','support')}]" :key="s.v" class="num-item">
        <div class="num-v">{{ s.v }}</div>
        <div class="num-l">{{ s.l }}</div>
      </div>
    </div>
  </div>
</section>

<!-- Final CTA -->
<section class="sec sec-cta">
  <div class="wrap text-center">
    <h2 class="h2 an" style="color:#fff">{{ ar('كن من الأوائل','Be among the first') }}</h2>
    <p class="sub an" style="opacity:.4">{{ ar('سجّل الآن واحصل على وصول مبكر عند الإطلاق. بدون رسوم.','Sign up now and get early access at launch. No fees.') }}</p>
    <Link v-if="canRegister" :href="route('register')" class="cta-lg an">{{ ar('افتح حساب مجاناً','Open free account') }}</Link>
  </div>
</section>

<!-- Footer -->
<footer class="ft">
  <div class="wrap">
    <div class="ft-top">
      <div>
        <a href="/" class="logo ft-logo">SDB<span class="logo-dot">.</span></a>
        <p class="ft-desc">{{ ar('بنك رقمي مرخّص في الدنمارك. خدمات مصرفية مبتكرة بمعايير أوروبية.','Licensed digital bank in Denmark. Innovative banking with European standards.') }}</p>
      </div>
      <div class="ft-links">
        <Link href="/terms">{{ ar('الشروط','Terms') }}</Link>
        <Link href="/privacy">{{ ar('الخصوصية','Privacy') }}</Link>
        <Link href="/about">{{ ar('عن البنك','About') }}</Link>
        <Link href="/support">{{ ar('الدعم','Support') }}</Link>
      </div>
      <div class="ft-contact">
        <p>info@sdb-bank.com</p>
        <p>+45 42 80 55 94</p>
        <p>Denmark 🇩🇰</p>
      </div>
    </div>
    <div class="ft-btm">
      <span>© 2026 SDB Bank ApS</span>
      <button @click="toggleLang" class="lang">{{ ar('English','عربي') }}</button>
    </div>
  </div>
</footer>

</div>
</template>

<style>
/* ── Base ── */
*{margin:0;padding:0;box-sizing:border-box}
.ar-font{font-family:'Cairo',sans-serif}
.page{font-family:'Inter',sans-serif;background:#fff;color:#111;overflow-x:hidden}
.rtl{direction:rtl}.ltr{direction:ltr}
html{scroll-behavior:smooth}
.wrap{max-width:1080px;margin:0 auto;padding:0 24px}
.text-center{text-align:center}

/* ── Top bar ── */
.topbar{position:fixed;top:0;left:0;right:0;z-index:50;background:rgba(255,255,255,.92);backdrop-filter:blur(16px);border-bottom:1px solid rgba(0,0,0,.06);height:60px;display:flex;align-items:center}
.logo{font-size:26px;font-weight:900;color:#111;text-decoration:none;letter-spacing:-1px}
.logo-dot{color:#2563EB}
.lang{font-size:13px;color:#999;font-weight:500;background:none;border:none;cursor:pointer}.lang:hover{color:#111}
.login-link{font-size:14px;color:#666;font-weight:500;text-decoration:none}.login-link:hover{color:#111}
.cta-sm{font-size:13px;font-weight:700;color:#fff;background:#111;padding:8px 20px;border-radius:8px;text-decoration:none;transition:background .2s}.cta-sm:hover{background:#333}

/* ── Hero ── */
.hero{padding:160px 0 100px;background:#fafafa;border-bottom:1px solid rgba(0,0,0,.05)}
.hero-inner{max-width:680px}
.pill{display:inline-block;font-size:12px;font-weight:700;color:#2563EB;background:rgba(37,99,235,.07);padding:6px 16px;border-radius:6px;margin-bottom:28px;letter-spacing:.5px}
.h1{font-size:clamp(2.2rem,5vw,3.6rem);font-weight:900;line-height:1.15;letter-spacing:-.03em;color:#111;margin-bottom:20px;white-space:pre-line}
.hero-p{font-size:16px;color:#888;line-height:1.8;margin-bottom:48px}

/* Timer */
.timer{display:flex;gap:20px;margin-bottom:40px}
.timer-block{display:flex;flex-direction:column;align-items:center}
.timer-n{font-size:42px;font-weight:900;color:#111;line-height:1;font-variant-numeric:tabular-nums}
.timer-l{font-size:11px;color:#bbb;margin-top:6px;font-weight:600;text-transform:uppercase;letter-spacing:1px}

/* Email */
.email-row{display:flex;gap:8px;max-width:420px}
.email-in{flex:1;padding:12px 16px;border:1px solid #e0e0e0;border-radius:8px;font-size:14px;outline:none;background:#fff;color:#111}.email-in:focus{border-color:#2563EB}.email-in::placeholder{color:#ccc}
.email-btn{padding:12px 24px;background:#111;color:#fff;font-size:14px;font-weight:700;border:none;border-radius:8px;cursor:pointer;white-space:nowrap;transition:background .2s}.email-btn:hover{background:#333}
.done-msg{font-size:14px;color:#2563EB;font-weight:600;padding:12px 0}

/* ── Sections ── */
.sec{padding:100px 0}
.sec-alt{background:#fafafa}
.sec-dark{background:#111}
.sec-cta{background:#111;padding:120px 0}
.h2{font-size:clamp(1.6rem,3.5vw,2.4rem);font-weight:900;line-height:1.15;letter-spacing:-.02em;margin-bottom:16px}
.sub{font-size:15px;color:#999;line-height:1.7;max-width:480px;margin:0 auto 48px}

/* ── Feature cards ── */
.grid3{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-top:48px}
.card{padding:28px 24px;border:1px solid rgba(0,0,0,.06);border-radius:12px;background:#fff;transition:all .3s}.card:hover{border-color:rgba(0,0,0,.12);box-shadow:0 4px 20px rgba(0,0,0,.04)}
.card-icon{font-size:28px;display:block;margin-bottom:14px}
.card-t{font-size:15px;font-weight:800;color:#111;margin-bottom:6px}
.card-p{font-size:13px;color:#999;line-height:1.7}

/* ── Crypto ── */
.coins{display:flex;justify-content:center;gap:10px;margin-bottom:40px;flex-wrap:wrap}
.coin{display:flex;align-items:center;gap:8px;padding:10px 18px;border:1px solid rgba(0,0,0,.06);border-radius:10px;background:#fff}
.coin-dot{width:10px;height:10px;border-radius:50%;flex-shrink:0}
.coin-name{font-size:14px;font-weight:600;color:#111}
.coin-sym{font-size:12px;color:#bbb;font-weight:500}
.grid4{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;max-width:560px;margin:0 auto}
.mini-card{padding:20px;border:1px solid rgba(0,0,0,.06);border-radius:10px;display:flex;flex-direction:column;align-items:center;gap:8px;background:#fff}
.mini-t{font-size:13px;font-weight:700;color:#111}

/* ── Plans ── */
.plans{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-top:40px;text-align:right}
.plan{padding:32px 28px;border:1px solid rgba(0,0,0,.06);border-radius:14px;background:#fff;transition:all .3s}.plan:hover{box-shadow:0 6px 24px rgba(0,0,0,.06)}
.plan-pop{background:#111;color:#fff;border-color:transparent}
.plan-n{font-size:18px;font-weight:900;margin-bottom:4px}
.plan-pr{font-size:26px;font-weight:900;margin-bottom:20px}
.plan-mo{font-size:13px;font-weight:400;opacity:.4}
.plan-list{list-style:none;padding:0;display:flex;flex-direction:column;gap:10px}
.plan-list li{font-size:13px;display:flex;align-items:center;gap:8px}
.plan-pop .plan-list li{color:rgba(255,255,255,.6)}
.chk{color:#2563EB;font-weight:700;font-size:12px}
.plan-pop .chk{color:#60A5FA}

/* ── Numbers ── */
.nums{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;text-align:center}
.num-v{font-size:36px;font-weight:900;color:#fff;margin-bottom:4px}
.num-l{font-size:13px;color:rgba(255,255,255,.3);font-weight:500}

/* ── CTA ── */
.cta-lg{display:inline-block;padding:16px 40px;background:#fff;color:#111;font-size:15px;font-weight:800;border-radius:10px;text-decoration:none;transition:all .2s;margin-top:8px}.cta-lg:hover{background:#f0f0f0;transform:translateY(-1px)}

/* ── Footer ── */
.ft{padding:60px 0 28px;border-top:1px solid rgba(0,0,0,.06);background:#fafafa}
.ft-top{display:grid;grid-template-columns:2fr 1fr 1fr;gap:32px;margin-bottom:32px}
.ft-logo{font-size:22px}
.ft-desc{font-size:12px;color:#bbb;line-height:1.7;max-width:280px;margin-top:10px}
.ft-links{display:flex;flex-direction:column;gap:10px}.ft-links a{font-size:13px;color:#999;text-decoration:none}.ft-links a:hover{color:#111}
.ft-contact p{font-size:12px;color:#bbb;margin-bottom:4px}
.ft-btm{display:flex;justify-content:space-between;align-items:center;border-top:1px solid rgba(0,0,0,.06);padding-top:20px}
.ft-btm span{font-size:11px;color:#ccc}

/* ── Animation ── */
.an{opacity:0;transform:translateY(18px);transition:opacity .6s ease,transform .6s ease}.an.vi{opacity:1;transform:none}

/* ── Responsive ── */
@media(max-width:768px){
  .grid3,.plans{grid-template-columns:1fr}
  .grid4{grid-template-columns:repeat(2,1fr)}
  .nums{grid-template-columns:repeat(2,1fr);gap:20px}
  .ft-top{grid-template-columns:1fr}
  .timer{gap:12px}.timer-n{font-size:30px}
  .hero{padding:120px 0 60px}
  .sec{padding:60px 0}
}
</style>
