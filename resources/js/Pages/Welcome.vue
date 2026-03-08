<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

/* ─── Language ─── */
const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');
function toggleLang() { lang.value = lang.value === 'ar' ? 'en' : 'ar'; }

const t = computed(() => lang.value === 'ar' ? {
  /* Nav */
  earlyAccess: 'سجّل الآن',
  /* Hero */
  launching: 'قريباً جداً',
  hd1: 'بنك لعصر',
  hd2: 'جديد',
  sub: 'استلام المعاشات · بطاقات ماستركارد فورية · تحويلات لأكثر من 150 دولة · أكثر من 30 عملة. كل شيء في مكان واحد.',
  days: 'يوم', hrs: 'ساعة', min: 'دقيقة', sec: 'ثانية',
  emailPh: 'بريدك الإلكتروني...',
  notify: 'أعلمني عند الإطلاق',
  emailDone: '✓ تم! سنبلغك فور الإطلاق.',
  trust1: '🇩🇰 مرخّص في الدنمارك',
  trust2: '🔒 تشفير 256-بت',
  trust3: '🏦 معتمد من ماستركارد',
  /* Marquee */
  marquee: ['Mastercard','Visa','Apple Pay','Google Pay','SWIFT','SEPA','Mastercard','Visa','Apple Pay','Google Pay','SWIFT','SEPA'],
  /* Features */
  featTitle: 'كل ما تحتاجه.',
  featFade: 'لا شيء زائد.',
  features: [
    { ic:'💰', t:'استلام المعاشات', p:'استلم راتبك مباشرة في حسابك. تحويل تلقائي وسريع بدون تأخير. متوافق مع جميع أنظمة الرواتب.', tag:'رواتب' },
    { ic:'💳', t:'بطاقات ماستركارد', p:'بطاقة افتراضية فورية عند التسجيل. أو اطلب بطاقة معدنية فاخرة. ادفع عبر Apple Pay في أي مكان بالعالم.', tag:'بطاقات' },
    { ic:'💱', t:'أكثر من 30 عملة', p:'احتفظ وحوّل بأسعار السوق الحقيقية. بدون رسوم مخفية. يورو، دولار، جنيه إسترليني، درهم، ريال والمزيد.', tag:'عملات' },
    { ic:'⚡', t:'تحويلات دولية', p:'أرسل أموالك لأكثر من 150 دولة عبر SWIFT و SEPA. تصل في دقائق بأقل الرسوم الممكنة.', tag:'تحويلات' },
    { ic:'🛡️', t:'أمان لا يُخترق', p:'تشفير بنكي 256-بت. مصادقة ثنائية وبصمة الوجه. فريق مراقبة احتيال يعمل على مدار الساعة.', tag:'أمان' },
    { ic:'📱', t:'تطبيق واحد لكل شيء', p:'iOS و Android. تحكم كامل بحساباتك وبطاقاتك وتحويلاتك — كل شيء من مكان واحد.', tag:'تطبيق' },
  ],
  /* Stats */
  stats: [{ v:'30+', l:'عملة' },{ v:'150+', l:'دولة' },{ v:'24/7', l:'دعم فني' },{ v:'0', l:'رسوم مخفية' }],
  /* Salary highlight */
  salaryTitle: 'معاشك.',
  salaryFade: 'بين يديك فوراً.',
  salaryDesc: 'استلم معاشك مباشرة في حسابك البنكي الرقمي. بدون وسطاء، بدون تأخير. حوّل واسحب بحرية تامة.',
  salaryF1t: 'إيداع مباشر', salaryF1d: 'معاشك يصل تلقائياً',
  salaryF2t: 'تحويل فوري', salaryF2d: 'حوّل لأي حساب بالعالم',
  salaryF3t: 'بدون رسوم', salaryF3d: 'لا رسوم على استلام الراتب',
  salaryF4t: 'إشعار لحظي', salaryF4d: 'تنبيه فوري عند وصول الراتب',
  /* CTA */
  ctaTitle: 'مستعد للمستقبل؟',
  ctaSub: 'سجّل الآن واحصل على وصول مبكّر. مجاناً بالكامل.',
  ctaBtn: 'افتح حسابك المجاني ←',
  /* Footer */
  fProducts: 'المنتجات',
  fCurrencies: 'العملات', fCards: 'البطاقات', fTransfers: 'التحويلات',
  fLegal: 'قانوني',
  fTerms: 'الشروط', fPrivacy: 'الخصوصية', fAbout: 'عنّا',
  fContact: 'تواصل معنا',
  fDesc: 'بنك رقمي مرخّص في الدنمارك.\nخدمات بنكية بمعايير أوروبية.',
  fCopy: '© 2026 SDB Bank ApS. جميع الحقوق محفوظة.',
} : {
  /* Nav */
  earlyAccess: 'Early access',
  /* Hero */
  launching: 'LAUNCHING SOON',
  hd1: 'Banking for',
  hd2: 'a new era',
  sub: 'Salary deposits · Instant Mastercard · Transfers to 150+ countries · 30+ currencies. All in one place.',
  days: 'Days', hrs: 'Hrs', min: 'Min', sec: 'Sec',
  emailPh: 'Your email...',
  notify: 'Notify me',
  emailDone: '✓ Done! We\'ll let you know at launch.',
  trust1: '🇩🇰 Licensed in Denmark',
  trust2: '🔒 256-bit encrypted',
  trust3: '🏦 Mastercard certified',
  /* Marquee */
  marquee: ['Mastercard','Visa','Apple Pay','Google Pay','SWIFT','SEPA','Mastercard','Visa','Apple Pay','Google Pay','SWIFT','SEPA'],
  /* Features */
  featTitle: 'Everything you need.',
  featFade: 'Nothing you don\'t.',
  features: [
    { ic:'💰', t:'Salary Deposits', p:'Receive your salary directly into your account. Automatic and instant transfers with zero delays. Compatible with all payroll systems.', tag:'SALARY' },
    { ic:'💳', t:'Mastercard Cards', p:'Instant virtual card on signup. Or order a premium metal card. Pay with Apple Pay anywhere in the world.', tag:'CARDS' },
    { ic:'💱', t:'30+ Global Currencies', p:'Hold and convert at real market rates. No hidden fees. EUR, USD, GBP, AED, SAR and more.', tag:'FX' },
    { ic:'⚡', t:'International Transfers', p:'Send money to 150+ countries via SWIFT & SEPA. Arrives in minutes with the lowest fees possible.', tag:'TRANSFERS' },
    { ic:'🛡️', t:'Unbreakable Security', p:'Bank-grade 256-bit encryption. Two-factor authentication and Face ID. 24/7 fraud monitoring team.', tag:'SECURITY' },
    { ic:'📱', t:'One App for Everything', p:'iOS & Android. Full control of your accounts, cards, and transfers — all from one place.', tag:'APP' },
  ],
  /* Stats */
  stats: [{ v:'30+', l:'Currencies' },{ v:'150+', l:'Countries' },{ v:'24/7', l:'Support' },{ v:'0', l:'Hidden Fees' }],
  /* Salary highlight */
  salaryTitle: 'Your salary.',
  salaryFade: 'Instantly yours.',
  salaryDesc: 'Receive your salary directly into your digital bank account. No middlemen, no delays. Transfer and withdraw freely.',
  salaryF1t: 'Direct Deposit', salaryF1d: 'Salary arrives automatically',
  salaryF2t: 'Instant Transfer', salaryF2d: 'Send to any account worldwide',
  salaryF3t: 'Zero Fees', salaryF3d: 'No fees on salary reception',
  salaryF4t: 'Real-time Alert', salaryF4d: 'Instant notification on arrival',
  /* CTA */
  ctaTitle: 'Ready for the future?',
  ctaSub: 'Sign up now and get early access. Completely free.',
  ctaBtn: 'Open your free account →',
  /* Footer */
  fProducts: 'Products',
  fCurrencies: 'Currencies', fCards: 'Cards', fTransfers: 'Transfers',
  fLegal: 'Legal',
  fTerms: 'Terms', fPrivacy: 'Privacy', fAbout: 'About',
  fContact: 'Contact',
  fDesc: 'Licensed digital bank in Denmark.\nBanking with European standards.',
  fCopy: '© 2026 SDB Bank ApS. All rights reserved.',
});

/* ─── Countdown — 14 days from now: March 22, 2026 ─── */
const launchDate = new Date('2026-03-22T00:00:00');
const cd = ref({ d:0, h:0, m:0, s:0 });
let ti;
function tick(){
  const x = launchDate - new Date();
  if(x <= 0) return;
  cd.value = {
    d: Math.floor(x/864e5),
    h: Math.floor(x%864e5/36e5),
    m: Math.floor(x%36e5/6e4),
    s: Math.floor(x%6e4/1e3)
  };
}

const em = ref('');
const done = ref(false);

let obs;
onMounted(() => {
  tick(); ti = setInterval(tick, 1e3);
  obs = new IntersectionObserver(e => e.forEach(x => {
    if(x.isIntersecting) x.target.classList.add('vi');
  }), { threshold: .08 });
  document.querySelectorAll('.a').forEach(el => obs.observe(el));
});
onUnmounted(() => { clearInterval(ti); obs?.disconnect(); });
</script>

<template>
<Head :title="isAr ? 'SDB Bank — قريباً' : 'SDB Bank — Coming Soon'">
  <meta :content="isAr ? 'SDB Bank — البنك الرقمي الجديد. استلام معاشات، بطاقات ماستركارد، تحويلات دولية.' : 'SDB Bank — The new digital bank. Salary deposits, Mastercard cards, international transfers.'" name="description" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
</Head>

<div class="pg" :class="{ rtl: isAr }" :dir="isAr ? 'rtl' : 'ltr'">

<!-- Nav -->
<nav class="nav">
  <div class="mx flex items-center justify-between">
    <a href="/" class="mark">SDB<span class="dot">.</span></a>
    <div class="nav-r">
      <button @click="toggleLang" class="lang-btn">{{ isAr ? 'EN' : 'عربي' }}</button>
      <Link href="/preregister" class="nbtn">{{ t.earlyAccess }}</Link>
    </div>
  </div>
</nav>

<!-- HERO -->
<section class="hero">
  <div class="mx hero-mx">
    <div class="htag a">{{ t.launching }}</div>
    <h1 class="hd a">
      <span class="hd-line">{{ t.hd1 }}</span>
      <span class="hd-em">{{ t.hd2 }}</span>
    </h1>
    <p class="hp a">{{ t.sub }}</p>

    <div class="cd a">
      <div v-for="(lb,k) in {d: t.days, h: t.hrs, m: t.min, s: t.sec}" :key="k" class="cd-b">
        <div class="cd-n">{{ String(cd[k]).padStart(2,'0') }}</div>
        <div class="cd-l">{{ lb }}</div>
      </div>
    </div>

    <div class="eml a">
      <template v-if="!done">
        <input v-model="em" type="email" :placeholder="t.emailPh" class="eml-i" @keyup.enter="done=!!em"/>
        <button @click="done=!!em" class="eml-b">{{ t.notify }}</button>
      </template>
      <div v-else class="eml-ok">{{ t.emailDone }}</div>
    </div>

    <div class="trust a">
      <span class="trust-i">{{ t.trust1 }}</span>
      <span class="trust-i">{{ t.trust2 }}</span>
      <span class="trust-i">{{ t.trust3 }}</span>
    </div>
  </div>
</section>

<!-- Marquee -->
<div class="mq">
  <div class="mq-track">
    <span v-for="(p,i) in t.marquee" :key="i" class="mq-i">{{ p }}</span>
  </div>
</div>

<!-- Features -->
<section class="sec sec-w">
  <div class="mx">
    <div class="sec-hdr a">
      <h2 class="t2">{{ t.featTitle }}<br><span class="t2-fade">{{ t.featFade }}</span></h2>
    </div>
    <div class="fg">
      <div v-for="(f,i) in t.features" :key="i" class="fc a" :style="{transitionDelay:(i*60)+'ms'}">
        <div class="fc-top">
          <span class="fc-tag">{{ f.tag }}</span>
          <span class="fc-ic">{{ f.ic }}</span>
        </div>
        <h3 class="fc-t">{{ f.t }}</h3>
        <p class="fc-p">{{ f.p }}</p>
      </div>
    </div>
  </div>
</section>

<!-- Salary Highlight Section -->
<section class="sec sec-bk">
  <div class="mx">
    <div class="sec-hdr a">
      <h2 class="t2 text-white">{{ t.salaryTitle }}<br><span class="t2-fade-w">{{ t.salaryFade }}</span></h2>
      <p class="sp sp-w">{{ t.salaryDesc }}</p>
    </div>
    <div class="sal-grid a">
      <div class="sal-box">
        <span class="sal-ic">📥</span>
        <span class="sal-t">{{ t.salaryF1t }}</span>
        <span class="sal-d">{{ t.salaryF1d }}</span>
      </div>
      <div class="sal-box">
        <span class="sal-ic">📤</span>
        <span class="sal-t">{{ t.salaryF2t }}</span>
        <span class="sal-d">{{ t.salaryF2d }}</span>
      </div>
      <div class="sal-box">
        <span class="sal-ic">🆓</span>
        <span class="sal-t">{{ t.salaryF3t }}</span>
        <span class="sal-d">{{ t.salaryF3d }}</span>
      </div>
      <div class="sal-box">
        <span class="sal-ic">🔔</span>
        <span class="sal-t">{{ t.salaryF4t }}</span>
        <span class="sal-d">{{ t.salaryF4d }}</span>
      </div>
    </div>
  </div>
</section>

<!-- Numbers -->
<section class="sec sec-w">
  <div class="mx">
    <div class="st a">
      <div v-for="s in t.stats" :key="s.v" class="st-i">
        <div class="st-v">{{ s.v }}</div>
        <div class="st-l">{{ s.l }}</div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="sec sec-w" style="padding:120px 0">
  <div class="mx text-center">
    <h2 class="t2 a">{{ t.ctaTitle }}</h2>
    <p class="sp a" style="margin-bottom:32px">{{ t.ctaSub }}</p>
    <Link href="/preregister" class="cta-big a">{{ t.ctaBtn }}</Link>
  </div>
</section>

<!-- Footer -->
<footer class="ft">
  <div class="mx">
    <div class="ft-g">
      <div>
        <a href="/" class="mark mark-ft">SDB<span class="dot">.</span></a>
        <p class="ft-d">{{ t.fDesc }}</p>
      </div>
      <div>
        <div class="ft-h">{{ t.fProducts }}</div>
        <div class="ft-lk"><Link href="/currencies">{{ t.fCurrencies }}</Link><Link href="/cards-info">{{ t.fCards }}</Link><Link href="/transfers-info">{{ t.fTransfers }}</Link></div>
      </div>
      <div>
        <div class="ft-h">{{ t.fLegal }}</div>
        <div class="ft-lk"><Link href="/terms">{{ t.fTerms }}</Link><Link href="/privacy">{{ t.fPrivacy }}</Link><Link href="/about">{{ t.fAbout }}</Link></div>
      </div>
      <div>
        <div class="ft-h">{{ t.fContact }}</div>
        <div class="ft-lk" style="gap:4px"><span>info@sdb-bank.com</span><span>+45 42 80 55 94</span><span>Denmark 🇩🇰</span></div>
      </div>
    </div>
    <div class="ft-btm">
      <span>{{ t.fCopy }}</span>
    </div>
  </div>
</footer>

</div>
</template>

<style>
*{margin:0;padding:0;box-sizing:border-box}
.pg{font-family:'Inter',sans-serif;color:#0a0a0a;overflow-x:hidden}
html{scroll-behavior:smooth}
.mx{max-width:1120px;margin:0 auto;padding:0 28px}
.text-center{text-align:center}
.text-white{color:#fff}

/* RTL */
.rtl{direction:rtl;text-align:right}
.rtl .text-center{text-align:center}
.rtl .fc-top{flex-direction:row-reverse}

/* Nav */
.nav{position:fixed;top:0;left:0;right:0;z-index:99;height:64px;display:flex;align-items:center;background:rgba(255,255,255,.88);backdrop-filter:blur(20px) saturate(1.8);border-bottom:1px solid rgba(0,0,0,.06)}
.mark{font-size:28px;font-weight:900;color:#0a0a0a;text-decoration:none;letter-spacing:-1.5px}
.dot{color:#2563EB;font-size:32px;line-height:0}
.nav-r{display:flex;align-items:center;gap:12px}
.lang-btn{font-size:13px;font-weight:700;color:#0a0a0a;background:transparent;border:2px solid rgba(0,0,0,.1);padding:8px 18px;border-radius:10px;cursor:pointer;transition:all .2s;font-family:inherit;letter-spacing:.3px}.lang-btn:hover{border-color:#2563EB;color:#2563EB}
.nbtn{font-size:13px;font-weight:700;color:#fff;background:#0a0a0a;padding:9px 22px;border-radius:10px;text-decoration:none;transition:all .2s;border:none}.nbtn:hover{background:#222}

/* Hero */
.hero{padding:200px 0 120px;background:#fff;position:relative;overflow:hidden}
.hero::after{content:'';position:absolute;top:0;right:-20%;width:60%;height:100%;background:radial-gradient(ellipse at center,rgba(37,99,235,.04) 0%,transparent 70%);pointer-events:none}
.rtl .hero::after{right:auto;left:-20%}
.hero-mx{max-width:720px;position:relative;z-index:1}
.htag{font-size:11px;font-weight:800;letter-spacing:3px;color:#2563EB;margin-bottom:32px;text-transform:uppercase}
.hd{margin-bottom:28px;line-height:1}
.hd-line{display:block;font-size:clamp(3rem,7vw,5.5rem);font-weight:900;letter-spacing:-.04em;color:#0a0a0a}
.hd-em{display:block;font-size:clamp(3rem,7vw,5.5rem);font-weight:900;letter-spacing:-.04em;color:#2563EB}
.rtl .hd-line,.rtl .hd-em{letter-spacing:0}
.hp{font-size:17px;color:#0a0a0a;opacity:.35;line-height:1.9;margin-bottom:56px;max-width:540px}

.cd{display:flex;gap:24px;margin-bottom:48px}
.cd-b{text-align:center;min-width:60px}
.cd-n{font-size:52px;font-weight:900;color:#0a0a0a;line-height:1;font-variant-numeric:tabular-nums}
.cd-l{font-size:10px;color:#0a0a0a;opacity:.2;margin-top:8px;font-weight:700;letter-spacing:1.5px;text-transform:uppercase}

.eml{display:flex;gap:0;max-width:460px;border:2px solid #0a0a0a;border-radius:14px;overflow:hidden}
.eml-i{flex:1;padding:16px 20px;border:none;outline:none;font-size:15px;background:transparent;color:#0a0a0a;font-family:inherit}.eml-i::placeholder{color:#ccc}
.eml-b{padding:16px 28px;background:#0a0a0a;color:#fff;border:none;font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;transition:background .2s;white-space:nowrap}.eml-b:hover{background:#222}
.eml-ok{padding:16px;color:#2563EB;font-weight:700;font-size:15px}
.rtl .eml{flex-direction:row-reverse}

.trust{display:flex;gap:24px;margin-top:48px;flex-wrap:wrap}
.trust-i{font-size:12px;color:#0a0a0a;opacity:.25;font-weight:600}

/* Marquee */
.mq{padding:20px 0;border-top:1px solid rgba(0,0,0,.04);border-bottom:1px solid rgba(0,0,0,.04);overflow:hidden;background:#fafafa}
.mq-track{display:flex;gap:56px;animation:mqs 18s linear infinite;white-space:nowrap}
.mq-i{font-size:13px;font-weight:800;color:#0a0a0a;opacity:.08;letter-spacing:3px;text-transform:uppercase}
@keyframes mqs{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}

/* Sections */
.sec{padding:120px 0}
.sec-w{background:#fff}
.sec-bk{background:#0a0a0a}
.sec-hdr{margin-bottom:64px}
.t2{font-size:clamp(2rem,4.5vw,3.2rem);font-weight:900;line-height:1.1;letter-spacing:-.03em}
.rtl .t2{letter-spacing:0}
.t2-fade{opacity:.15}
.t2-fade-w{opacity:.25}
.sp{font-size:16px;opacity:.35;line-height:1.8;max-width:440px;margin:0 auto 48px}.sp-w{color:#fff}
.rtl .sp{margin:0 0 48px}

/* Feature grid */
.fg{display:grid;grid-template-columns:repeat(3,1fr);gap:1px;background:rgba(0,0,0,.06);border:1px solid rgba(0,0,0,.06);border-radius:20px;overflow:hidden}
.fc{padding:36px 32px;background:#fff;transition:background .3s}.fc:hover{background:#fafafa}
.fc-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:20px}
.fc-tag{font-size:10px;font-weight:800;letter-spacing:2px;color:#2563EB;opacity:.5;text-transform:uppercase}
.rtl .fc-tag{letter-spacing:0}
.fc-ic{font-size:32px}
.fc-t{font-size:17px;font-weight:800;color:#0a0a0a;margin-bottom:8px}
.fc-p{font-size:13px;color:#0a0a0a;opacity:.3;line-height:1.8}

/* Salary section */
.sal-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.06);border-radius:16px;overflow:hidden}
.sal-box{padding:28px 20px;background:#0a0a0a;text-align:center;display:flex;flex-direction:column;align-items:center;gap:8px}
.sal-ic{font-size:28px}
.sal-t{font-size:14px;font-weight:800;color:#fff}
.sal-d{font-size:11px;color:rgba(255,255,255,.2);line-height:1.5}

/* Stats */
.st{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:rgba(0,0,0,.06);border:1px solid rgba(0,0,0,.06);border-radius:16px;overflow:hidden}
.st-i{padding:48px 24px;background:#fff;text-align:center}
.st-v{font-size:44px;font-weight:900;color:#0a0a0a;margin-bottom:4px}
.st-l{font-size:12px;color:#0a0a0a;opacity:.2;font-weight:600}

/* CTA */
.cta-big{display:inline-block;padding:18px 48px;background:#0a0a0a;color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s;letter-spacing:-.02em}.cta-big:hover{background:#222;transform:translateY(-2px)}

/* Footer */
.ft{padding:80px 0 32px;background:#fafafa;border-top:1px solid rgba(0,0,0,.05)}
.ft-g{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:40px;margin-bottom:40px}
.mark-ft{font-size:22px;display:block;margin-bottom:8px}
.ft-d{font-size:12px;color:#0a0a0a;opacity:.2;line-height:1.7;white-space:pre-line;max-width:260px}
.ft-h{font-size:11px;font-weight:800;letter-spacing:1.5px;text-transform:uppercase;color:#0a0a0a;opacity:.2;margin-bottom:16px}
.rtl .ft-h{letter-spacing:0}
.ft-lk{display:flex;flex-direction:column;gap:10px}.ft-lk a,.ft-lk span{font-size:13px;color:#0a0a0a;opacity:.35;text-decoration:none;transition:opacity .2s}.ft-lk a:hover{opacity:.7}
.ft-btm{display:flex;justify-content:space-between;align-items:center;border-top:1px solid rgba(0,0,0,.05);padding-top:24px}
.ft-btm span{font-size:11px;color:#0a0a0a;opacity:.15}

/* Animation */
.a{opacity:0;transform:translateY(22px);transition:opacity .65s cubic-bezier(.25,.46,.45,.94),transform .65s cubic-bezier(.25,.46,.45,.94)}.a.vi{opacity:1;transform:none}

/* Responsive */
@media(max-width:768px){
  .fg{grid-template-columns:1fr}
  .sal-grid,.st{grid-template-columns:repeat(2,1fr)}
  .ft-g{grid-template-columns:1fr;gap:24px}
  .hero{padding:140px 0 80px}
  .sec{padding:80px 0}
  .cd{gap:14px}.cd-n{font-size:36px}
  .trust{flex-direction:column;gap:8px}
}
</style>
