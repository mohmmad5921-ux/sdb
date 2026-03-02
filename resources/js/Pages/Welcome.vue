<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';
defineProps({ canLogin: Boolean, canRegister: Boolean });
const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');
const toggleLang = () => lang.value = lang.value === 'ar' ? 'en' : 'ar';
const mobileMenuOpen = ref(false);
const ar = (a, e) => isAr.value ? a : e;

// Countdown to launch (set a date ~30 days from now)
const launchDate = new Date('2026-04-15T00:00:00');
const countdown = ref({ days: 0, hours: 0, minutes: 0, seconds: 0 });
let countdownInterval;

function updateCountdown() {
  const now = new Date();
  const diff = launchDate - now;
  if (diff <= 0) return;
  countdown.value = {
    days: Math.floor(diff / (1000 * 60 * 60 * 24)),
    hours: Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
    minutes: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
    seconds: Math.floor((diff % (1000 * 60)) / 1000),
  };
}

// Email signup
const email = ref('');
const emailSubmitted = ref(false);
const submitEmail = () => { if (email.value) emailSubmitted.value = true; };

// Scroll reveal
let observer = null;
onMounted(() => {
  updateCountdown();
  countdownInterval = setInterval(updateCountdown, 1000);
  observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => { if (entry.isIntersecting) entry.target.classList.add('revealed'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.rv').forEach(el => observer.observe(el));
});
onUnmounted(() => {
  clearInterval(countdownInterval);
  if (observer) observer.disconnect();
});
</script>

<template>
<Head :title="ar('SDB Bank - قريباً','SDB Bank - Coming Soon')">
  <meta name="description" :content="ar('SDB Bank - البنك الرقمي الأول. قريباً!','SDB Bank - The first digital bank. Coming Soon!')" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Cairo:wght@300;400;600;700;800;900&display=swap" rel="stylesheet" />
</Head>
<div :class="['cs-page', isAr ? 'rtl font-ar' : 'ltr']" :dir="isAr ? 'rtl' : 'ltr'">

<!-- NAV -->
<nav class="cs-nav">
  <div class="cs-container flex items-center justify-between h-16">
    <a href="/"><img src="/images/sdb-logo.png" alt="SDB" class="cs-logo" /></a>
    <div class="flex items-center gap-4">
      <button @click="toggleLang" class="cs-lang-btn">{{ ar('EN','عربي') }}</button>
      <Link v-if="canLogin" :href="route('login')" class="cs-nav-link">{{ ar('تسجيل الدخول','Log in') }}</Link>
      <Link v-if="canRegister" :href="route('register')" class="cs-btn-glow">{{ ar('انضم لقائمة الانتظار','Join waitlist') }}</Link>
    </div>
  </div>
</nav>

<!-- HERO -->
<section class="cs-hero">
  <div class="cs-hero-particles"></div>
  <div class="cs-hero-glow"></div>
  <div class="cs-container relative z-10 text-center">
    <div class="cs-badge rv">{{ ar('🚀 قريباً — COMING SOON','🚀 COMING SOON') }}</div>
    <h1 class="cs-h1 rv">{{ ar('مستقبل المصارف الرقمية','The Future of Digital Banking') }}</h1>
    <p class="cs-hero-sub rv">{{ ar('بنك رقمي متكامل — حسابات متعددة العملات، بطاقات Mastercard فورية، تداول العملات الرقمية، وتحويلات دولية. كل ذلك من تطبيق واحد آمن.','A complete digital bank — multi-currency accounts, instant Mastercard cards, crypto trading, and international transfers. All from one secure app.') }}</p>

    <!-- Countdown -->
    <div class="cs-countdown rv">
      <div v-for="(u, k) in {days: ar('يوم','Days'), hours: ar('ساعة','Hours'), minutes: ar('دقيقة','Min'), seconds: ar('ثانية','Sec')}" :key="k" class="cs-count-item">
        <div class="cs-count-num">{{ String(countdown[k]).padStart(2, '0') }}</div>
        <div class="cs-count-label">{{ u }}</div>
      </div>
    </div>

    <!-- Email Signup -->
    <div class="cs-email-box rv">
      <div v-if="!emailSubmitted" class="cs-email-form">
        <input v-model="email" type="email" :placeholder="ar('أدخل بريدك الإلكتروني...','Enter your email...')" class="cs-email-input" @keyup.enter="submitEmail" />
        <button @click="submitEmail" class="cs-email-btn">{{ ar('سجّلني','Notify me') }}</button>
      </div>
      <div v-else class="cs-email-success">
        ✅ {{ ar('تم التسجيل! سنُعلمك عند الإطلاق.','Registered! We\'ll notify you at launch.') }}
      </div>
    </div>
  </div>
</section>

<!-- FEATURES -->
<section class="cs-section">
  <div class="cs-container">
    <h2 class="cs-h2 rv text-center">{{ ar('ما الذي نبنيه لك','What we\'re building for you') }}</h2>
    <p class="cs-sub rv text-center">{{ ar('منصة مصرفية رقمية شاملة بمعايير أوروبية عالمية','A comprehensive digital banking platform with European standards') }}</p>

    <div class="cs-features-grid">
      <div v-for="(f, i) in [
        {icon:'🏦',t:ar('حسابات متعددة العملات','Multi-Currency Accounts'),d:ar('افتح حسابات بـ 30+ عملة عالمية مع سعر صرف حقيقي بدون رسوم مخفية','Open accounts in 30+ currencies with real exchange rates and no hidden fees'),color:'#2563EB'},
        {icon:'💳',t:ar('بطاقات Mastercard','Mastercard Cards'),d:ar('بطاقة Mastercard افتراضية فورية + بطاقات معدنية فاخرة. Apple Pay و Google Pay','Instant virtual Mastercard + premium metal cards. Apple Pay & Google Pay'),color:'#EB4432'},
        {icon:'🪙',t:ar('تداول العملات الرقمية','Crypto Trading'),d:ar('اشترِ وبِع Bitcoin, Ethereum, Solana وأكثر مباشرة من حسابك. محافظ حقيقية.','Buy & sell Bitcoin, Ethereum, Solana and more directly. Real blockchain wallets.'),color:'#F7931A'},
        {icon:'🌍',t:ar('تحويلات دولية','International Transfers'),d:ar('أرسل أموالك لـ 150+ دولة بأقل الرسوم وأسرع الطرق. SWIFT + SEPA','Send money to 150+ countries at minimal fees. SWIFT + SEPA support'),color:'#10B981'},
        {icon:'🔐',t:ar('أمان متقدم','Advanced Security'),d:ar('تشفير 256-bit، مصادقة ثنائية، بصمة الوجه، ومراقبة احتيال 24/7','256-bit encryption, 2FA, Face ID, and 24/7 fraud monitoring'),color:'#8B5CF6'},
        {icon:'📱',t:ar('تطبيق ذكي','Smart App'),d:ar('تطبيق iOS و Android مع تحكم كامل بحساباتك وبطاقاتك وتداولاتك','iOS & Android app with full control over accounts, cards & trading'),color:'#EC4899'}
      ]" :key="i" class="cs-feature-card rv" :style="{transitionDelay:(i*80)+'ms'}">
        <div class="cs-feature-icon" :style="{background:f.color+'15',color:f.color}">{{ f.icon }}</div>
        <h3 class="cs-feature-title">{{ f.t }}</h3>
        <p class="cs-feature-desc">{{ f.d }}</p>
      </div>
    </div>
  </div>
</section>

<!-- CRYPTO PREVIEW -->
<section class="cs-section cs-section-dark">
  <div class="cs-container text-center">
    <div class="cs-badge-dark rv">{{ ar('🪙 تداول الكريبتو','🪙 Crypto Trading') }}</div>
    <h2 class="cs-h2 rv text-white">{{ ar('محافظ كريبتو حقيقية — قريباً','Real Crypto Wallets — Coming Soon') }}</h2>
    <p class="cs-sub rv text-white/40">{{ ar('كل عميل سيحصل على عنوان محفظة حقيقي ومعترف به عالمياً لكل عملة رقمية. إرسال واستقبال من وإلى أي محفظة بالعالم.','Every customer will get a globally recognized wallet address for each cryptocurrency. Send and receive from any wallet worldwide.') }}</p>
    <div class="cs-crypto-row rv">
      <div v-for="(c, i) in [
        {name:'Bitcoin',sym:'BTC',icon:'₿',color:'#F7931A'},
        {name:'Ethereum',sym:'ETH',icon:'⟠',color:'#627EEA'},
        {name:'Tether',sym:'USDT',icon:'₮',color:'#26A17B'},
        {name:'Solana',sym:'SOL',icon:'◎',color:'#9945FF'},
        {name:'Ripple',sym:'XRP',icon:'✕',color:'#23292F'},
        {name:'Cardano',sym:'ADA',icon:'⬡',color:'#3CC8C8'}
      ]" :key="i" class="cs-crypto-chip">
        <span class="cs-crypto-icon" :style="{background:c.color+'20',color:c.color}">{{ c.icon }}</span>
        <span class="text-white font-bold text-sm">{{ c.sym }}</span>
      </div>
    </div>
    <div class="cs-wallet-features rv">
      <div v-for="(f, i) in [
        {icon:'📥',t:ar('استقبال كريبتو','Receive crypto'),d:ar('عنوان محفظة فريد لكل عملة','Unique wallet address per currency')},
        {icon:'📤',t:ar('إرسال كريبتو','Send crypto'),d:ar('أرسل لأي محفظة بالعالم','Send to any wallet worldwide')},
        {icon:'💱',t:ar('تحويل فوري','Instant swap'),d:ar('حوّل بين الكريبتو والـ EUR','Convert between crypto and EUR')},
        {icon:'📊',t:ar('أسعار حية','Live prices'),d:ar('متابعة الأسعار لحظياً','Real-time price tracking')}
      ]" :key="i" class="cs-wallet-feat">
        <div class="text-2xl mb-2">{{ f.icon }}</div>
        <div class="font-bold text-white text-sm">{{ f.t }}</div>
        <div class="text-xs text-white/30">{{ f.d }}</div>
      </div>
    </div>
  </div>
</section>

<!-- CARD PREVIEW -->
<section class="cs-section">
  <div class="cs-container text-center">
    <div class="cs-badge rv mx-auto">Mastercard</div>
    <h2 class="cs-h2 rv">{{ ar('بطاقات ذكية لكل أسلوب حياة','Smart cards for every lifestyle') }}</h2>
    <div class="cs-plans-grid rv">
      <div v-for="(p, i) in [
        {n:'Standard',price:ar('مجاني','Free'),features:[ar('بطاقة افتراضية فورية','Instant virtual card'),ar('Apple Pay & Google Pay','Apple Pay & Google Pay'),ar('حد سحب €500','€500 ATM limit')]},
        {n:'Premium',price:'7.99€',popular:true,features:[ar('صرف عملات غير محدود','Unlimited FX'),ar('تأمين سفر شامل','Travel insurance'),ar('صالات مطارات','Lounge access')]},
        {n:'Elite',price:'14.99€',features:[ar('صالات VIP غير محدودة','Unlimited VIP lounges'),ar('مدير حساب خاص','Personal manager'),ar('استرداد نقدي 1%','1% cashback')]}
      ]" :key="i" class="cs-plan-card" :class="{ 'cs-plan-popular': p.popular }">
        <div v-if="p.popular" class="cs-popular-tag">{{ ar('الأكثر طلباً','Most Popular') }}</div>
        <h3 class="text-xl font-black">{{ p.n }}</h3>
        <div class="text-2xl font-black mt-2 mb-4" :class="p.popular ? 'text-white' : ''">{{ p.price }}<span v-if="p.price!==ar('مجاني','Free')" class="text-sm font-normal opacity-40">/{{ ar('شهرياً','mo') }}</span></div>
        <ul class="space-y-2.5">
          <li v-for="f in p.features" :key="f" class="text-sm flex items-start gap-2" :class="p.popular ? 'text-white/70' : 'text-gray-500'"><span class="text-emerald-400">✓</span>{{ f }}</li>
        </ul>
      </div>
    </div>
  </div>
</section>

<!-- STATS -->
<section class="cs-section cs-section-dark">
  <div class="cs-container">
    <div class="cs-stats-grid rv">
      <div v-for="s in [
        {val:'30+',l:ar('عملة مدعومة','Supported currencies'),icon:'💱'},
        {val:'6+',l:ar('عملة رقمية','Cryptocurrencies'),icon:'🪙'},
        {val:'150+',l:ar('دولة','Countries'),icon:'🌍'},
        {val:'24/7',l:ar('دعم فني','Support'),icon:'🎧'}
      ]" :key="s.val" class="cs-stat-item">
        <div class="text-3xl mb-2">{{ s.icon }}</div>
        <div class="text-3xl font-black text-white mb-1">{{ s.val }}</div>
        <div class="text-sm text-white/30">{{ s.l }}</div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="cs-section cs-cta">
  <div class="cs-container text-center relative z-10">
    <h2 class="cs-h2 rv text-white">{{ ar('كن أول من يجرّب SDB Bank','Be the first to try SDB Bank') }}</h2>
    <p class="cs-sub rv text-white/40">{{ ar('سجّل الآن في قائمة الانتظار واحصل على وصول مبكر عند الإطلاق.','Sign up for the waitlist and get early access at launch.') }}</p>
    <Link v-if="canRegister" :href="route('register')" class="cs-btn-glow cs-btn-lg rv">{{ ar('سجّل الآن مجاناً','Sign up for free') }}</Link>
  </div>
</section>

<!-- FOOTER -->
<footer class="cs-footer">
  <div class="cs-container">
    <div class="grid md:grid-cols-4 gap-8 mb-10">
      <div class="md:col-span-2">
        <img src="/images/sdb-logo.png" alt="SDB" class="cs-footer-logo" />
        <p class="text-white/20 text-xs leading-relaxed max-w-sm mt-4">{{ ar('بنك رقمي مرخّص في الدنمارك. خدمات مصرفية مبتكرة بمعايير أوروبية — حسابات متعددة العملات، بطاقات Mastercard، تداول كريبتو.','Licensed digital bank in Denmark. Innovative banking with European standards — multi-currency accounts, Mastercard cards, crypto trading.') }}</p>
      </div>
      <div><h4 class="text-sm font-bold text-white/50 mb-4">{{ ar('روابط','Links') }}</h4><ul class="space-y-2.5 text-xs text-white/20"><li><Link href="/terms" class="hover:text-white/50 transition">{{ ar('الشروط والأحكام','Terms') }}</Link></li><li><Link href="/privacy" class="hover:text-white/50 transition">{{ ar('سياسة الخصوصية','Privacy') }}</Link></li><li><Link href="/about" class="hover:text-white/50 transition">{{ ar('عن البنك','About') }}</Link></li><li><Link href="/support" class="hover:text-white/50 transition">{{ ar('الدعم','Support') }}</Link></li></ul></div>
      <div><h4 class="text-sm font-bold text-white/50 mb-4">{{ ar('تواصل','Contact') }}</h4><ul class="space-y-2.5 text-xs text-white/20"><li>📧 info@sdb-bank.com</li><li>📞 +45 42 80 55 94</li><li>📍 Denmark 🇩🇰</li></ul></div>
    </div>
    <div class="border-t border-white/5 pt-6 flex flex-col md:flex-row items-center justify-between gap-3">
      <p class="text-white/10 text-[11px]">© 2026 SDB Bank ApS. {{ ar('جميع الحقوق محفوظة.','All rights reserved.') }}</p>
      <button @click="toggleLang" class="text-[11px] text-white/15 hover:text-white/40 transition">{{ ar('English','عربي') }}</button>
    </div>
  </div>
</footer>

</div>
</template>

<style>
/* CORE */
.font-ar{font-family:'Cairo',sans-serif}
.cs-page{font-family:'Inter',sans-serif;background:#060b18;color:#fff;min-height:100vh}
.rtl{direction:rtl}.ltr{direction:ltr}
html{scroll-behavior:smooth}
.cs-container{max-width:1100px;margin:0 auto;padding:0 24px}

/* NAV */
.cs-nav{position:fixed;top:0;left:0;right:0;z-index:50;background:rgba(6,11,24,0.85);backdrop-filter:blur(20px);border-bottom:1px solid rgba(255,255,255,0.04)}
.cs-nav-link{color:rgba(255,255,255,0.4);font-weight:500;font-size:14px;transition:color .3s}.cs-nav-link:hover{color:#fff}
.cs-logo{height:40px;width:auto;object-fit:contain;filter:brightness(0) invert(1)}
.cs-lang-btn{color:rgba(255,255,255,0.3);font-size:13px;font-weight:600;padding:6px 14px;border:1px solid rgba(255,255,255,0.08);border-radius:8px;background:transparent;cursor:pointer;transition:all .2s}.cs-lang-btn:hover{color:#fff;border-color:rgba(255,255,255,0.2)}

/* GLOWING BUTTON */
.cs-btn-glow{display:inline-flex;align-items:center;justify-content:center;padding:10px 28px;border-radius:12px;font-weight:700;font-size:14px;color:#fff;background:linear-gradient(135deg,#2563EB,#7C3AED);box-shadow:0 0 20px rgba(37,99,235,0.3),0 0 60px rgba(124,58,237,0.15);transition:all .3s;border:none;cursor:pointer;text-decoration:none}.cs-btn-glow:hover{transform:translateY(-2px);box-shadow:0 0 30px rgba(37,99,235,0.5),0 0 80px rgba(124,58,237,0.25)}
.cs-btn-lg{padding:16px 44px;font-size:16px;border-radius:14px}

/* HERO */
.cs-hero{position:relative;min-height:100vh;display:flex;align-items:center;justify-content:center;padding:120px 0 80px;overflow:hidden}
.cs-hero-particles{position:absolute;inset:0;background:radial-gradient(circle at 20% 50%,rgba(37,99,235,0.08) 0%,transparent 50%),radial-gradient(circle at 80% 30%,rgba(124,58,237,0.06) 0%,transparent 40%);animation:particleFloat 8s ease-in-out infinite alternate}
.cs-hero-glow{position:absolute;top:50%;left:50%;width:600px;height:600px;transform:translate(-50%,-50%);background:radial-gradient(circle,rgba(37,99,235,0.12) 0%,transparent 70%);animation:glowPulse 4s ease-in-out infinite alternate}
@keyframes particleFloat{0%{opacity:0.6}100%{opacity:1}}
@keyframes glowPulse{0%{transform:translate(-50%,-50%) scale(0.9);opacity:0.5}100%{transform:translate(-50%,-50%) scale(1.1);opacity:1}}

.cs-badge{display:inline-flex;padding:8px 20px;border-radius:100px;background:rgba(37,99,235,0.1);color:#60A5FA;font-size:13px;font-weight:700;margin-bottom:24px;letter-spacing:1px;border:1px solid rgba(37,99,235,0.15)}
.cs-badge-dark{display:inline-flex;padding:8px 20px;border-radius:100px;background:rgba(247,147,26,0.1);color:#F7931A;font-size:13px;font-weight:700;margin-bottom:24px;letter-spacing:1px;border:1px solid rgba(247,147,26,0.15)}

.cs-h1{font-size:clamp(2.5rem,6vw,4.5rem);font-weight:900;line-height:1.05;background:linear-gradient(135deg,#fff 0%,rgba(255,255,255,0.6) 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;margin-bottom:20px;letter-spacing:-0.02em}
.cs-hero-sub{font-size:17px;color:rgba(255,255,255,0.35);line-height:1.8;max-width:600px;margin:0 auto 40px}

/* COUNTDOWN */
.cs-countdown{display:flex;justify-content:center;gap:16px;margin-bottom:40px}
.cs-count-item{text-align:center}
.cs-count-num{font-size:48px;font-weight:900;background:linear-gradient(135deg,#2563EB,#7C3AED);-webkit-background-clip:text;-webkit-text-fill-color:transparent;line-height:1}
.cs-count-label{font-size:11px;color:rgba(255,255,255,0.25);margin-top:6px;font-weight:600;text-transform:uppercase;letter-spacing:1px}

/* EMAIL */
.cs-email-box{max-width:480px;margin:0 auto}
.cs-email-form{display:flex;gap:8px;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:6px}
.cs-email-input{flex:1;background:transparent;border:none;outline:none;color:#fff;padding:10px 16px;font-size:14px}.cs-email-input::placeholder{color:rgba(255,255,255,0.2)}
.cs-email-btn{padding:10px 24px;border-radius:10px;background:linear-gradient(135deg,#2563EB,#7C3AED);color:#fff;font-weight:700;font-size:14px;border:none;cursor:pointer;white-space:nowrap;transition:all .2s}.cs-email-btn:hover{filter:brightness(1.1)}
.cs-email-success{padding:16px;background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.2);border-radius:14px;color:#10B981;font-weight:600;font-size:14px}

/* SECTIONS */
.cs-section{padding:100px 0}
.cs-section-dark{background:rgba(255,255,255,0.02)}
.cs-h2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:16px;letter-spacing:-0.02em}
.cs-sub{font-size:16px;color:rgba(255,255,255,0.3);line-height:1.7;max-width:600px;margin:0 auto 48px}

/* FEATURES GRID */
.cs-features-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.cs-feature-card{padding:32px 24px;background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.05);border-radius:20px;transition:all .4s}.cs-feature-card:hover{border-color:rgba(37,99,235,0.15);transform:translateY(-4px);box-shadow:0 8px 30px rgba(37,99,235,0.06)}
.cs-feature-icon{width:52px;height:52px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:24px;margin-bottom:16px}
.cs-feature-title{font-size:16px;font-weight:800;color:#fff;margin-bottom:8px}
.cs-feature-desc{font-size:13px;color:rgba(255,255,255,0.25);line-height:1.7}

/* CRYPTO */
.cs-crypto-row{display:flex;justify-content:center;gap:12px;margin:32px 0;flex-wrap:wrap}
.cs-crypto-chip{display:flex;align-items:center;gap:8px;padding:10px 20px;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.06);border-radius:12px;transition:all .3s}.cs-crypto-chip:hover{border-color:rgba(255,255,255,0.15)}
.cs-crypto-icon{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:16px;font-weight:bold}
.cs-wallet-features{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-top:40px}
.cs-wallet-feat{padding:24px;background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.05);border-radius:16px;text-align:center}

/* PLANS */
.cs-plans-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-top:32px}
.cs-plan-card{padding:32px;background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:20px;text-align:right;transition:all .4s;position:relative}.cs-plan-card:hover{transform:translateY(-4px);border-color:rgba(255,255,255,0.12)}
.cs-plan-popular{background:linear-gradient(135deg,#2563EB,#7C3AED)!important;border-color:transparent!important;box-shadow:0 8px 40px rgba(37,99,235,0.3)}
.cs-popular-tag{position:absolute;top:-10px;right:20px;padding:4px 14px;background:#fff;color:#2563EB;font-size:11px;font-weight:700;border-radius:100px}

/* STATS */
.cs-stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.cs-stat-item{text-align:center;padding:24px;background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.05);border-radius:16px}

/* CTA */
.cs-cta{position:relative;background:linear-gradient(135deg,rgba(37,99,235,0.1),rgba(124,58,237,0.08));overflow:hidden;padding:120px 0}

/* FOOTER */
.cs-footer{padding:60px 0 32px;border-top:1px solid rgba(255,255,255,0.04)}
.cs-footer-logo{height:40px;width:auto;object-fit:contain;filter:brightness(0) invert(1);opacity:0.5}

/* SCROLL REVEAL */
.rv{opacity:0;transform:translateY(25px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.rv.revealed{opacity:1;transform:translateY(0)}

/* RESPONSIVE */
@media(max-width:768px){
  .cs-features-grid{grid-template-columns:1fr}
  .cs-wallet-features{grid-template-columns:repeat(2,1fr)}
  .cs-plans-grid{grid-template-columns:1fr}
  .cs-stats-grid{grid-template-columns:repeat(2,1fr)}
  .cs-countdown{gap:10px}
  .cs-count-num{font-size:32px}
}

::-webkit-scrollbar{width:4px}::-webkit-scrollbar-track{background:#060b18}::-webkit-scrollbar-thumb{background:rgba(37,99,235,0.4);border-radius:4px}
</style>
