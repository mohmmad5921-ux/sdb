<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';
defineProps({ canLogin: Boolean, canRegister: Boolean });
const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');
const toggleLang = () => lang.value = lang.value === 'ar' ? 'en' : 'ar';
const mobileMenuOpen = ref(false);
const ar = (a, e) => isAr.value ? a : e;

let observer = null;
onMounted(() => {
  observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => { if (entry.isIntersecting) entry.target.classList.add('revealed'); });
  }, { threshold: 0.1 });
  document.querySelectorAll('.rv').forEach(el => observer.observe(el));
});
onUnmounted(() => { if (observer) observer.disconnect(); });
</script>

<template>
<Head :title="ar('SDB - مستقبل المصارف الرقمية','SDB - Change the way you money')">
  <meta name="description" :content="ar('سوريا ديجيتال بنك - البنك الرقمي الأول','Syria Digital Bank - The first digital bank')" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Cairo:wght@300;400;600;700;800;900&display=swap" rel="stylesheet" />
</Head>
<div :class="['rv-page', isAr ? 'rtl font-ar' : 'ltr']" :dir="isAr ? 'rtl' : 'ltr'">

<!-- NAV -->
<nav class="rv-nav">
  <div class="rv-container flex items-center justify-between h-16">
    <a href="/"><img src="/images/sdb-logo.png" alt="SDB" class="rv-logo" /></a>
    <div class="hidden md:flex items-center gap-7 text-[14px]">
      <a href="#salary" class="rv-nav-link">{{ ar('الحسابات','Accounts') }}</a>
      <a href="#cards" class="rv-nav-link">{{ ar('البطاقات','Cards') }}</a>
      <a href="#transfers" class="rv-nav-link">{{ ar('التحويلات','Transfers') }}</a>
      <a href="#security" class="rv-nav-link">{{ ar('الأمان','Security') }}</a>
      <a href="#pricing" class="rv-nav-link">{{ ar('الخطط','Plans') }}</a>
      <button @click="toggleLang" class="rv-nav-link">{{ ar('EN','عربي') }}</button>
    </div>
    <div class="hidden md:flex items-center gap-4">
      <Link v-if="canLogin" :href="route('login')" class="rv-nav-link font-medium">{{ ar('تسجيل الدخول','Log in') }}</Link>
      <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-w">{{ ar('فتح حساب','Sign up') }}</Link>
    </div>
    <button @click="mobileMenuOpen=!mobileMenuOpen" class="md:hidden text-white"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg></button>
  </div>
  <div v-if="mobileMenuOpen" class="md:hidden px-6 pb-4 space-y-3">
    <a v-for="s in [{id:'salary',l:ar('الحسابات','Accounts')},{id:'cards',l:ar('البطاقات','Cards')},{id:'transfers',l:ar('التحويلات','Transfers')},{id:'security',l:ar('الأمان','Security')},{id:'pricing',l:ar('الخطط','Plans')}]" :key="s.id" :href="'#'+s.id" class="block text-white/60 text-sm py-1" @click="mobileMenuOpen=false">{{ s.l }}</a>
    <div class="flex gap-3 pt-2">
      <Link v-if="canLogin" :href="route('login')" class="text-white/60 text-sm">{{ ar('تسجيل الدخول','Log in') }}</Link>
      <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-dark text-sm">{{ ar('فتح حساب','Sign up') }}</Link>
    </div>
  </div>
</nav>

<!-- HERO -->
<section class="rv-hero">
  <div class="rv-hero-bg" style="background-image:url('/images/hero-lifestyle.png')"></div>
  <div class="rv-hero-overlay"></div>
  <div class="rv-container relative z-10 grid md:grid-cols-2 gap-12 items-center min-h-[90vh] pt-24 pb-16">
    <div :class="isAr ? 'text-right' : ''" class="rv">
      <h1 class="rv-hero-heading">{{ ar('غيّر طريقة تعاملك مع أموالك','Change the way you money') }}</h1>
      <p class="rv-hero-sub">{{ ar('بيتك أو بره، محلياً أو عالمياً — تنقّل بحرية بين العملات والدول. سجّل مجاناً بضغطة زر.','Home or away, local or global — move freely between countries and currencies. Sign up for free, in a tap.') }}</p>
      <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-dark">{{ ar('حمّل التطبيق','Download the app') }}</Link>
    </div>
    <div class="rv hidden md:flex justify-center">
      <div class="rv-phone-mockup">
        <div class="rv-phone-screen">
          <div class="rv-phone-header">
            <span class="text-xs text-white/40">Personal</span>
            <div class="text-3xl font-black text-white mt-1">€6,012</div>
            <div class="rv-phone-pill">Accounts</div>
          </div>
          <div class="rv-phone-tx">
            <div class="rv-tx-icon">💰</div>
            <div>
              <div class="text-sm font-semibold text-[#0B1F3A]">Salary</div>
              <div class="text-xs text-[#0B1F3A]/40">Today, 11:28</div>
            </div>
            <div class="text-sm font-bold text-[#0B1F3A] ml-auto">+€2,550</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- SALARY / YOUR SALARY REIMAGINED -->
<section id="salary" class="rv-section rv-section-light">
  <div class="rv-container text-center">
    <h2 class="rv-heading rv">{{ ar('راتبك، بشكل جديد','Your salary, reimagined') }}</h2>
    <p class="rv-subtext rv max-w-2xl mx-auto">{{ ar('أنفق بذكاء، أرسل بسرعة، قسّم راتبك تلقائياً، وشاهد مدخراتك تنمو — كل ذلك مع SDB.','Spend smartly, send quickly, sort your salary automatically, and watch your savings grow — all with SDB.') }}</p>
    <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-dark rv">{{ ar('حوّل راتبك','Move your salary') }}</Link>
    <div class="grid sm:grid-cols-3 gap-6 mt-16">
      <div v-for="(item,i) in [
        {img:'/images/card-standard.png',label:ar('حساب شخصي - يورو','Personal · EUR'),balance:'€3,126',tx:ar('قهوة في باريس','Coffee in Paris'),txAmount:'-€3.25',txTime:ar('أمس, 09:02','Yesterday, 09:02')},
        {img:'/images/card-plus.png',label:ar('شخصي','Personal'),balance:'€6,012',tx:ar('الراتب','Salary'),txAmount:'+€2,550',txTime:ar('اليوم, 11:28','Today, 11:28')},
        {img:'/images/card-premium.png',label:ar('شخصي','Personal'),balance:'€2,350',tx:ar('فواتير المنزل','House bills'),txAmount:'-€225',txTime:ar('مستحق اليوم','Due today')}
      ]" :key="i" class="rv-lifestyle-card rv" :style="{transitionDelay:(i*150)+'ms'}">
        <img :src="item.img" :alt="item.label" class="rv-lifestyle-img" />
        <div class="rv-lifestyle-overlay">
          <span class="text-xs text-white/60">{{ item.label }}</span>
          <div class="text-2xl font-black text-white">{{ item.balance }}</div>
          <div class="rv-lifestyle-pill">Accounts</div>
        </div>
        <div class="rv-lifestyle-tx">
          <div class="text-sm font-semibold">{{ item.tx }}</div>
          <div class="text-xs text-[#0B1F3A]/40">{{ item.txTime }}</div>
          <div class="text-sm font-bold ml-auto">{{ item.txAmount }}</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- CARDS SECTION (BLACK) -->
<section id="cards" class="rv-section rv-section-black">
  <div class="rv-container">
    <div class="text-center mb-16">
      <h2 class="rv-heading rv text-white">{{ ar('بطاقاتك الافتراضية','Go virtual') }}</h2>
      <p class="rv-subtext rv text-white/50 max-w-2xl mx-auto">{{ ar('أنشئ بطاقات افتراضية وأضفها إلى Apple Wallet أو Google Wallet وابدأ الدفع فوراً.','Create and add virtual cards to your Apple Wallet or Google Wallet to start paying right away.') }}</p>
      <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-w rv mt-2">{{ ar('أنشئ بطاقة','Create a card') }}</Link>
    </div>
    <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
      <div v-for="(c,i) in [
        {n:'Standard',sub:ar('مجاني','Free'),img:'/images/card-standard.png',desc:ar('بطاقة افتراضية مجانية للعمليات اليومية','Free virtual card for daily transactions')},
        {n:'Plus',sub:'3.99€/mo',img:'/images/card-plus.png',desc:ar('حدود أعلى وحماية مشتريات','Higher limits & purchase protection')},
        {n:'Premium',sub:'7.99€/mo',img:'/images/card-premium.png',desc:ar('صرف عملات غير محدود وتأمين سفر','Unlimited FX & travel insurance')},
        {n:'Elite',sub:'14.99€/mo',img:'/images/card-elite.png',desc:ar('صالات مطارات ومدير حساب خاص','Lounge access & dedicated manager')}
      ]" :key="i" class="rv-card-item rv" :style="{transitionDelay:(i*120)+'ms'}">
        <img :src="c.img" :alt="c.n" class="rv-card-img" />
        <h3 class="text-lg font-bold text-white mt-4">{{ c.n }}</h3>
        <div class="text-sm text-white/40 mb-2">{{ c.sub }}</div>
        <p class="text-xs text-white/30 leading-relaxed">{{ c.desc }}</p>
      </div>
    </div>
    <div class="flex flex-wrap justify-center gap-3 mt-12">
      <span v-for="f in ['Apple Pay','Google Pay', ar('تجميد فوري','Instant freeze'), ar('CVV متغير','Dynamic CVV'), ar('بطاقة معدنية','Physical card')]" :key="f" class="rv-tag-dark">{{ f }}</span>
    </div>
  </div>
</section>

<!-- TRANSFERS -->
<section id="transfers" class="rv-section rv-section-white">
  <div class="rv-container grid md:grid-cols-2 gap-16 items-center">
    <div :class="isAr ? 'text-right' : ''">
      <h2 class="rv-heading rv">{{ ar('أرسل أموالك حول العالم','Send money abroad') }}</h2>
      <p class="rv-subtext rv">{{ ar('تحويلات دولية بأقل الرسوم وبسعر الصرف الحقيقي. أرسل بأكثر من 30 عملة إلى أكثر من 150 دولة.','International transfers at the real exchange rate with minimal fees. Send in 30+ currencies to 150+ countries.') }}</p>
      <div class="space-y-4 mt-8">
        <div v-for="(f,i) in [
          {icon:'🌍',t:ar('150+ دولة','150+ countries'),d:ar('أرسل إلى أي مكان في العالم','Send anywhere in the world')},
          {icon:'💱',t:ar('سعر الصرف الحقيقي','Real exchange rate'),d:ar('بدون رسوم مخفية أو هوامش ربح','No hidden fees or markups')},
          {icon:'⚡',t:ar('تحويلات فورية','Instant transfers'),d:ar('يصل المال خلال ثوانٍ','Money arrives in seconds')}
        ]" :key="i" class="rv-feature-row rv" :style="{transitionDelay:(i*100)+'ms'}">
          <div class="rv-feature-icon">{{ f.icon }}</div>
          <div>
            <div class="font-bold text-[#0B1F3A] text-[15px]">{{ f.t }}</div>
            <div class="text-sm text-[#0B1F3A]/40">{{ f.d }}</div>
          </div>
        </div>
      </div>
      <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-dark rv mt-8 inline-flex">{{ ar('ابدأ التحويل','Start a transfer') }}</Link>
    </div>
    <div class="rv flex justify-center">
      <img src="/images/world-transfer.png" alt="Global transfers" class="rv-section-img" />
    </div>
  </div>
</section>

<!-- SECURITY -->
<section id="security" class="rv-section rv-section-light">
  <div class="rv-container grid md:grid-cols-2 gap-16 items-center">
    <div class="rv flex justify-center order-2 md:order-1">
      <img src="/images/security-shield.png" alt="Security" class="rv-section-img max-w-[300px]" />
    </div>
    <div :class="isAr ? 'text-right' : ''" class="order-1 md:order-2">
      <h2 class="rv-heading rv">{{ ar('أموالك في مكان آمن','Your money\'s safe space') }}</h2>
      <p class="rv-subtext rv">{{ ar('مع SDB Secure، أنت تدخل عصراً جديداً من أمان الأموال — حيث تحميك دفاعاتنا الاستباقية وفريق متخصصي الاحتيال على مدار الساعة.','With SDB Secure, you\'re entering a new era of money security — where our proactive, purpose-built defences and team of fraud specialists help protect every account, 24/7.') }}</p>
      <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-dark rv mt-2 inline-flex">{{ ar('اعرف أكثر','Learn more') }}</Link>
    </div>
  </div>
</section>

<!-- PRICING -->
<section id="pricing" class="rv-section rv-section-dark">
  <div class="rv-container">
    <h2 class="rv-heading rv text-white mb-12">{{ ar('اختر خطتك','Choose your plan') }}</h2>
    <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-5 mb-5">
      <div v-for="(p,i) in [
        {n:'Standard',price:ar('مجاني','Free'),desc:ar('كل الأساسيات — حساب رقمي، بطاقة افتراضية، تحويلات محلية، وإدارة أموالك من تطبيق واحد.','The financial basics — everything you need for better money management in one place.')},
        {n:'Plus',price:'3.99€',desc:ar('للمنفق الذكي — حدود أعلى للتحويلات، حماية مشتريات، وتأمين على مشترياتك بسعر معقول.','For the smart spender — access better limits for spending abroad and insurance for your purchases.')},
        {n:'Premium',price:'7.99€',desc:ar('لحياة أفضل — صرف عملات غير محدود، اشتراكات حصرية، وأسعار ادخار أفضل.','For elevating every day — access exclusive subscriptions, better savings rates, and unlimited currency exchange.')}
      ]" :key="i" class="rv-plan-card rv" :style="{transitionDelay:(i*100)+'ms'}">
        <h3 class="text-xl font-black text-[#0B1F3A] mb-1">{{ p.n }}</h3>
        <div class="text-lg font-bold text-[#0B1F3A] mb-4">{{ p.price }}<span v-if="!['مجاني','Free'].includes(p.price)" class="text-sm text-[#0B1F3A]/40 font-normal">/{{ ar('شهرياً','month') }}</span></div>
        <p class="text-sm text-[#0B1F3A]/50 leading-relaxed mb-8">{{ p.desc }}</p>
        <Link v-if="canRegister" :href="route('register')" class="rv-plan-arrow mt-auto">→</Link>
      </div>
    </div>
    <div class="grid sm:grid-cols-2 gap-5">
      <div v-for="(p,i) in [
        {n:'Metal',price:'14.99€',desc:ar('للمسافرين والتجار حول العالم — تأمين سفر شامل، حدود محسّنة، واشتراكات بقيمة 2,100€ سنوياً.','For the global travellers and traders — relax with travel insurance, enjoy enhanced limits, and subscriptions worth €2,100 annually.')},
        {n:'Ultra',price:'45€',desc:ar('لمن يريد الأفضل — صالات مطارات غير محدودة، بيانات دولية شهرية، اشتراكات شركاء، وحماية إلغاء شاملة.','For those seeking the best — get unlimited airport lounge access, monthly global data, partner subscriptions, and cancellation cover.')}
      ]" :key="i" class="rv-plan-card rv" :style="{transitionDelay:((i+3)*100)+'ms'}">
        <h3 class="text-xl font-black text-[#0B1F3A] mb-1">{{ p.n }}</h3>
        <div class="text-lg font-bold text-[#0B1F3A] mb-4">{{ p.price }}<span class="text-sm text-[#0B1F3A]/40 font-normal">/{{ ar('شهرياً','month') }}</span></div>
        <p class="text-sm text-[#0B1F3A]/50 leading-relaxed mb-8">{{ p.desc }}</p>
        <Link v-if="canRegister" :href="route('register')" class="rv-plan-arrow mt-auto">→</Link>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="rv-section rv-section-white">
  <div class="rv-container text-center">
    <h2 class="rv-heading rv max-w-3xl mx-auto">{{ ar('افتح حسابك اليوم وانضم لمستقبل المصارف الرقمية','Open your account today and join the future of digital banking') }}</h2>
    <p class="rv-subtext rv max-w-xl mx-auto">{{ ar('سجّل خلال دقائق وابدأ رحلتك المصرفية الرقمية مع SDB','Register in minutes and start your digital banking journey with SDB') }}</p>
    <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-dark rv-btn-lg rv">{{ ar('سجّل الآن','Sign up now') }}</Link>
  </div>
</section>

<!-- FOOTER -->
<footer class="rv-footer">
  <div class="rv-container">
    <div class="grid md:grid-cols-5 gap-8 mb-12">
      <div class="md:col-span-2">
        <img src="/images/sdb-logo.png" alt="SDB" class="rv-footer-logo" />
        <p class="text-[#0B1F3A]/30 text-xs leading-relaxed max-w-xs mt-4">{{ ar('بنك رقمي مرخّص في الدنمارك. خدمات مصرفية مبتكرة بمعايير أوروبية عالمية.','A licensed digital bank in Denmark. Innovative banking services with European standards.') }}</p>
      </div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('المنتجات','Products') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/30"><li><a href="#salary" class="hover:text-[#0B1F3A] transition">{{ ar('حسابات شخصية','Personal Accounts') }}</a></li><li><a href="#cards" class="hover:text-[#0B1F3A] transition">{{ ar('البطاقات','Cards') }}</a></li><li><a href="#transfers" class="hover:text-[#0B1F3A] transition">{{ ar('التحويلات الدولية','International Transfers') }}</a></li><li><Link href="/currencies" class="hover:text-[#0B1F3A] transition">{{ ar('العملات','Currencies') }}</Link></li></ul></div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('قانوني','Legal') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/30"><li><Link href="/terms" class="hover:text-[#0B1F3A] transition">{{ ar('الشروط والأحكام','Terms') }}</Link></li><li><Link href="/privacy" class="hover:text-[#0B1F3A] transition">{{ ar('سياسة الخصوصية','Privacy') }}</Link></li><li><Link href="/about" class="hover:text-[#0B1F3A] transition">{{ ar('عن البنك','About') }}</Link></li><li><Link href="/support" class="hover:text-[#0B1F3A] transition">{{ ar('الدعم','Support') }}</Link></li></ul></div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('تواصل','Contact') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/30"><li>📧 info@sdb-bank.com</li><li>📞 +45 42 80 55 94</li><li>📍 Wimosem 18, 4000 Roskilde</li><li>🇩🇰 Denmark</li></ul></div>
    </div>
    <div class="border-t border-[#0B1F3A]/8 pt-6 flex flex-col md:flex-row items-center justify-between gap-3">
      <p class="text-[#0B1F3A]/20 text-[11px]">© 2026 SDB Bank ApS. {{ ar('جميع الحقوق محفوظة.','All rights reserved.') }}</p>
      <button @click="toggleLang" class="text-[11px] text-[#0B1F3A]/25 hover:text-[#0B1F3A] transition">{{ ar('English','عربي') }}</button>
    </div>
  </div>
</footer>

</div>
</template>

<style>
/* RESET */
.font-ar{font-family:'Cairo',sans-serif}
.rv-page{font-family:'Inter',sans-serif;background:#fff;color:#0B1F3A}
.rtl{direction:rtl}.ltr{direction:ltr}
html{scroll-behavior:smooth}
.rv-container{max-width:1200px;margin:0 auto;padding:0 24px}

/* NAV */
.rv-nav{position:fixed;top:0;left:0;right:0;z-index:50;background:rgba(11,31,58,0.95);backdrop-filter:blur(20px)}
.rv-nav-link{color:rgba(255,255,255,0.55);font-weight:500;transition:color .3s;font-size:14px}.rv-nav-link:hover{color:#fff}
.rv-logo{height:45px;width:auto;object-fit:contain;filter:brightness(0) invert(1)}

/* BUTTONS */
.rv-btn-pill-dark{display:inline-flex;align-items:center;justify-content:center;padding:14px 36px;border-radius:100px;font-weight:700;font-size:15px;background:#0B1F3A;color:#fff;transition:all .25s;border:none;cursor:pointer}.rv-btn-pill-dark:hover{background:#162d4d;transform:translateY(-1px)}
.rv-btn-pill-w{display:inline-flex;align-items:center;justify-content:center;padding:8px 22px;border-radius:100px;font-weight:600;font-size:14px;background:#fff;color:#0B1F3A;transition:all .25s;border:none;cursor:pointer}.rv-btn-pill-w:hover{background:rgba(255,255,255,0.8)}
.rv-btn-lg{padding:18px 48px;font-size:17px}

/* HERO */
.rv-hero{position:relative;background:#4DA3E8;overflow:hidden}
.rv-hero-bg{position:absolute;inset:0;background-size:cover;background-position:center top;opacity:0.6}
.rv-hero-overlay{position:absolute;inset:0;background:linear-gradient(135deg,rgba(77,163,232,0.7) 0%,rgba(77,163,232,0.3) 50%,rgba(77,163,232,0.5) 100%)}
.rv-hero-heading{font-size:clamp(2.8rem,6vw,4.5rem);font-weight:900;line-height:1.05;color:#fff;margin-bottom:24px;letter-spacing:-0.02em}
.rv-hero-sub{font-size:18px;color:rgba(255,255,255,0.7);line-height:1.7;max-width:480px;margin-bottom:32px}

/* PHONE MOCKUP */
.rv-phone-mockup{width:320px;background:rgba(255,255,255,0.15);backdrop-filter:blur(20px);border-radius:32px;border:2px solid rgba(255,255,255,0.2);overflow:hidden;padding:20px}
.rv-phone-screen{background:transparent}
.rv-phone-header{text-align:center;padding:20px 0}
.rv-phone-pill{display:inline-flex;padding:6px 20px;border-radius:100px;background:rgba(255,255,255,0.2);color:#fff;font-size:13px;font-weight:600;margin-top:12px}
.rv-phone-tx{display:flex;align-items:center;gap:12px;background:#fff;border-radius:16px;padding:14px 18px;margin-top:20px;box-shadow:0 4px 20px rgba(0,0,0,0.08)}
.rv-tx-icon{width:36px;height:36px;border-radius:50%;background:#EEF2FF;display:flex;align-items:center;justify-content:center;font-size:18px}

/* SECTIONS */
.rv-section{padding:100px 0;position:relative}
.rv-section-light{background:#F0F0F0}
.rv-section-white{background:#fff}
.rv-section-black{background:#0B1F3A}
.rv-section-dark{background:#1a1a1a}
.rv-heading{font-size:clamp(2rem,4.5vw,3.5rem);font-weight:900;line-height:1.1;margin-bottom:16px;letter-spacing:-0.02em}
.rv-subtext{font-size:17px;color:rgba(11,31,58,0.5);line-height:1.7;margin-bottom:24px}

/* LIFESTYLE CARDS */
.rv-lifestyle-card{border-radius:20px;overflow:hidden;position:relative;background:#000;cursor:pointer;transition:transform .4s}
.rv-lifestyle-card:hover{transform:scale(1.02)}
.rv-lifestyle-img{width:100%;height:200px;object-fit:cover;opacity:0.7}
.rv-lifestyle-overlay{position:absolute;top:20px;left:0;right:0;text-align:center;z-index:2}
.rv-lifestyle-pill{display:inline-flex;padding:4px 16px;border-radius:100px;background:rgba(255,255,255,0.2);color:#fff;font-size:11px;font-weight:600;margin-top:8px;backdrop-filter:blur(10px)}
.rv-lifestyle-tx{display:flex;align-items:center;gap:8px;padding:14px 18px;background:#fff;position:relative;z-index:2}

/* CARDS */
.rv-card-item{text-align:center;transition:transform .4s}.rv-card-item:hover{transform:translateY(-6px)}
.rv-card-img{width:100%;height:auto;border-radius:16px;box-shadow:0 8px 30px rgba(0,0,0,0.3);transition:transform .5s}.rv-card-img:hover{transform:perspective(600px) rotateY(-5deg)}
.rv-tag-dark{padding:8px 18px;background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.1);border-radius:100px;font-size:12px;color:rgba(255,255,255,0.4);font-weight:500}

/* FEATURE ROW */
.rv-feature-row{display:flex;align-items:flex-start;gap:16px;padding:16px 0;border-bottom:1px solid rgba(11,31,58,0.06)}
.rv-feature-icon{width:44px;height:44px;border-radius:14px;background:#F0F0F0;display:flex;align-items:center;justify-content:center;font-size:22px;flex-shrink:0}

/* SECTION IMAGE */
.rv-section-img{width:100%;max-width:450px;height:auto;filter:drop-shadow(0 20px 60px rgba(0,0,0,0.15))}

/* PRICING */
.rv-plan-card{background:#fff;border-radius:20px;padding:32px;display:flex;flex-direction:column;transition:all .35s}.rv-plan-card:hover{transform:translateY(-4px);box-shadow:0 15px 40px rgba(0,0,0,0.15)}
.rv-plan-arrow{display:inline-flex;align-items:center;justify-content:center;width:40px;height:40px;border-radius:50%;background:rgba(11,31,58,0.05);color:#0B1F3A;font-size:18px;transition:all .3s;align-self:flex-end}.rv-plan-arrow:hover{background:#0B1F3A;color:#fff;transform:translateX(4px)}

/* CTA */
/* (uses rv-section-white) */

/* FOOTER */
.rv-footer{padding:60px 0 32px;background:#FAFBFC;border-top:1px solid rgba(11,31,58,0.06)}
.rv-footer-logo{height:50px;width:auto;object-fit:contain}

/* SCROLL REVEAL */
.rv{opacity:0;transform:translateY(30px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.rv.revealed{opacity:1;transform:translateY(0)}

/* RESPONSIVE */
@media(max-width:768px){
  .rv-hero-heading{font-size:2.4rem}
  .rv-heading{font-size:1.8rem}
  .rv-section{padding:60px 0}
}

::-webkit-scrollbar{width:4px}::-webkit-scrollbar-track{background:#fff}::-webkit-scrollbar-thumb{background:#0B1F3A;border-radius:4px}
</style>
