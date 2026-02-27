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
  }, { threshold: 0.08 });
  document.querySelectorAll('.rv').forEach(el => observer.observe(el));
});
onUnmounted(() => { if (observer) observer.disconnect(); });
</script>

<template>
<Head :title="ar('SDB - مستقبل المصارف الرقمية','SDB - Change the way you money')">
  <meta name="description" :content="ar('SDB Bank - البنك الرقمي الأول','SDB Bank - The first digital bank')" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Cairo:wght@300;400;600;700;800;900&display=swap" rel="stylesheet" />
</Head>
<div :class="['rv-page', isAr ? 'rtl font-ar' : 'ltr']" :dir="isAr ? 'rtl' : 'ltr'">

<!-- NAV -->
<nav class="rv-nav">
  <div class="rv-container flex items-center justify-between h-16">
    <a href="/"><img src="/images/sdb-logo.png" alt="SDB" class="rv-logo" /></a>
    <div class="hidden md:flex items-center gap-7 text-[14px]">
      <a href="#currencies" class="rv-nav-link">{{ ar('العملات','Currencies') }}</a>
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
    <a v-for="s in [{id:'currencies',l:ar('العملات','Currencies')},{id:'cards',l:ar('البطاقات','Cards')},{id:'transfers',l:ar('التحويلات','Transfers')},{id:'security',l:ar('الأمان','Security')},{id:'pricing',l:ar('الخطط','Plans')}]" :key="s.id" :href="'#'+s.id" class="block text-white/60 text-sm py-1" @click="mobileMenuOpen=false">{{ s.l }}</a>
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
  <div class="rv-container relative z-10 grid md:grid-cols-2 gap-12 items-center min-h-[92vh] pt-24 pb-16">
    <div :class="isAr ? 'text-right' : ''" class="rv">
      <h1 class="rv-hero-heading">{{ ar('غيّر طريقة تعاملك مع أموالك','Change the way you money') }}</h1>
      <p class="rv-hero-sub">{{ ar('حسابات متعددة العملات، بطاقات Mastercard فورية، تحويلات دولية بسعر الصرف الحقيقي — كل ذلك من تطبيق واحد آمن.','Multi-currency accounts, instant Mastercard cards, international transfers at the real exchange rate — all from one secure app.') }}</p>
      <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-dark">{{ ar('افتح حسابك مجاناً','Open free account') }}</Link>
    </div>
    <div class="rv hidden md:flex justify-center">
      <div class="rv-phone-mockup">
        <div class="rv-phone-screen">
          <div class="rv-phone-header">
            <span class="text-xs text-white/40">Personal · EUR</span>
            <div class="text-3xl font-black text-white mt-1">€6,012</div>
            <div class="rv-phone-pill">Accounts</div>
          </div>
          <div class="rv-phone-tx">
            <div class="rv-tx-icon">💳</div>
            <div><div class="text-sm font-semibold text-[#0B1F3A]">Mastercard Payment</div><div class="text-xs text-[#0B1F3A]/40">Today, 14:22</div></div>
            <div class="text-sm font-bold text-[#0B1F3A] ml-auto">-€45.00</div>
          </div>
          <div class="rv-phone-tx mt-2">
            <div class="rv-tx-icon">💱</div>
            <div><div class="text-sm font-semibold text-[#0B1F3A]">EUR → USD</div><div class="text-xs text-[#0B1F3A]/40">Today, 11:15</div></div>
            <div class="text-sm font-bold text-green-600 ml-auto">+$500</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- PARTNERS MARQUEE -->
<section class="rv-marquee">
  <div class="rv-marquee-track">
    <span v-for="p in ['Mastercard','Visa','Apple Pay','Google Pay','Samsung Pay','Swift','Stripe','SEPA']" :key="p" class="rv-marquee-item">{{ p }}</span>
    <span v-for="p in ['Mastercard','Visa','Apple Pay','Google Pay','Samsung Pay','Swift','Stripe','SEPA']" :key="p+'2'" class="rv-marquee-item">{{ p }}</span>
  </div>
</section>

<!-- MULTI-CURRENCY ACCOUNTS -->
<section id="currencies" class="rv-section rv-section-white">
  <div class="rv-container">
    <div class="grid md:grid-cols-2 gap-16 items-center">
      <div :class="isAr ? 'text-right' : ''">
        <div class="rv-badge rv">{{ ar('حسابات متعددة العملات','Multi-Currency Accounts') }}</div>
        <h2 class="rv-heading rv">{{ ar('احتفظ بأرصدة في 30+ عملة','Hold balances in 30+ currencies') }}</h2>
        <p class="rv-subtext rv">{{ ar('افتح حسابات فرعية بعملات مختلفة في ثوانٍ. حوّل بين العملات بسعر الصرف الحقيقي بدون رسوم مخفية. استلم وأرسل بأي عملة تريدها.','Open sub-accounts in different currencies in seconds. Convert between currencies at the real exchange rate with no hidden fees. Receive and send in any currency you want.') }}</p>
        <div class="space-y-4 mt-6">
          <div v-for="(f,i) in [
            {icon:'💱',t:ar('سعر الصرف الحقيقي','Real exchange rate'),d:ar('نفس سعر السوق بدون هوامش ربح مخفية','Same market rate with no hidden markups')},
            {icon:'⚡',t:ar('تحويل فوري بين العملات','Instant currency conversion'),d:ar('حوّل بين عملاتك في ثانية واحدة','Convert between your currencies in one second')},
            {icon:'🌍',t:ar('30+ عملة عالمية','30+ global currencies'),d:ar('EUR, USD, GBP, CHF, AED, SAR والمزيد','EUR, USD, GBP, CHF, AED, SAR and more')}
          ]" :key="i" class="rv-feature-row rv" :style="{transitionDelay:(i*100)+'ms'}">
            <div class="rv-feature-icon">{{ f.icon }}</div>
            <div>
              <div class="font-bold text-[#0B1F3A] text-[15px]">{{ f.t }}</div>
              <div class="text-sm text-[#0B1F3A]/40">{{ f.d }}</div>
            </div>
          </div>
        </div>
        <Link href="/currencies" class="rv-btn-pill-dark rv mt-8 inline-flex">{{ ar('اكتشف العملات','Explore currencies') }}</Link>
      </div>
      <div class="rv flex justify-center">
        <div class="rv-rates-grid">
          <div v-for="(c,i) in [
            {from:'EUR',to:'USD',rate:'1.0842',flag:'🇪🇺',flag2:'🇺🇸'},
            {from:'EUR',to:'GBP',rate:'0.8617',flag:'🇪🇺',flag2:'🇬🇧'},
            {from:'EUR',to:'AED',rate:'3.9815',flag:'🇪🇺',flag2:'🇦🇪'},
            {from:'EUR',to:'SAR',rate:'4.0658',flag:'🇪🇺',flag2:'🇸🇦'},
            {from:'EUR',to:'TRY',rate:'34.82',flag:'🇪🇺',flag2:'🇹🇷'},
            {from:'EUR',to:'CHF',rate:'0.9486',flag:'🇪🇺',flag2:'🇨🇭'}
          ]" :key="i" class="rv-rate-card rv" :style="{transitionDelay:(i*80)+'ms'}">
            <div class="flex items-center gap-2">
              <span class="text-xl">{{ c.flag }}</span>
              <span class="text-[#0B1F3A]/15">→</span>
              <span class="text-xl">{{ c.flag2 }}</span>
            </div>
            <div class="font-bold text-sm">{{ c.from }}/{{ c.to }}</div>
            <div class="font-black text-lg text-[#2563EB]">{{ c.rate }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- CRYPTO CURRENCIES -->
<section class="rv-section rv-section-light">
  <div class="rv-container">
    <div class="text-center mb-12">
      <div class="rv-badge rv mx-auto">{{ ar('العملات الرقمية','Crypto') }}</div>
      <h2 class="rv-heading rv">{{ ar('تداول العملات الرقمية بثقة','Trade crypto with confidence') }}</h2>
      <p class="rv-subtext rv max-w-2xl mx-auto">{{ ar('اشترِ وبِع Bitcoin و Ethereum و 50+ عملة رقمية أخرى. تابع الأسعار لحظياً واستثمر بذكاء.','Buy and sell Bitcoin, Ethereum and 50+ other cryptocurrencies. Track prices in real-time and invest smartly.') }}</p>
    </div>
    <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div v-for="(c,i) in [
        {name:'Bitcoin',sym:'BTC',price:'€89,450',change:'+2.4%',up:true,icon:'₿',color:'#F7931A'},
        {name:'Ethereum',sym:'ETH',price:'€3,210',change:'+5.1%',up:true,icon:'⟠',color:'#627EEA'},
        {name:'Tether',sym:'USDT',price:'€0.92',change:'+0.01%',up:true,icon:'₮',color:'#26A17B'},
        {name:'Solana',sym:'SOL',price:'€183.20',change:'-1.2%',up:false,icon:'◎',color:'#9945FF'},
        {name:'Ripple',sym:'XRP',price:'€2.15',change:'+3.8%',up:true,icon:'✕',color:'#23292F'},
        {name:'Cardano',sym:'ADA',price:'€0.68',change:'+1.5%',up:true,icon:'⬡',color:'#3CC8C8'},
        {name:'Polkadot',sym:'DOT',price:'€7.42',change:'+4.2%',up:true,icon:'●',color:'#E6007A'},
        {name:'Litecoin',sym:'LTC',price:'€95.60',change:'-0.8%',up:false,icon:'Ł',color:'#345D9D'}
      ]" :key="i" class="rv-crypto-card rv" :style="{transitionDelay:(i*60)+'ms'}">
        <div class="rv-crypto-icon" :style="{background:c.color+'15',color:c.color}">{{ c.icon }}</div>
        <div class="flex-1">
          <div class="font-bold text-sm">{{ c.name }} <span class="text-[#0B1F3A]/25 text-xs font-normal">{{ c.sym }}</span></div>
          <div class="font-black text-lg">{{ c.price }}</div>
        </div>
        <div class="rv-crypto-change" :class="c.up ? 'rv-up' : 'rv-dn'">{{ c.change }}</div>
      </div>
    </div>
    <div class="text-center mt-8">
      <Link href="/currencies" class="rv-btn-pill-dark rv">{{ ar('عرض كل العملات','View all currencies') }}</Link>
    </div>
  </div>
</section>

<!-- MASTERCARD CARDS (BLACK) -->
<section id="cards" class="rv-section rv-section-black">
  <div class="rv-container">
    <div class="text-center mb-16">
      <div class="rv-badge rv rv-badge-dark mx-auto">Mastercard</div>
      <h2 class="rv-heading rv text-white">{{ ar('بطاقات Mastercard فورية','Instant Mastercard cards') }}</h2>
      <p class="rv-subtext rv text-white/40 max-w-2xl mx-auto">{{ ar('احصل على بطاقة Mastercard افتراضية فوراً عند فتح حسابك. أضفها إلى Apple Wallet أو Google Wallet وابدأ الدفع في ثوانٍ. اطلب بطاقتك المعدنية الفاخرة لاحقاً.','Get an instant virtual Mastercard when you open your account. Add it to Apple Wallet or Google Wallet and start paying in seconds. Order your premium metal card later.') }}</p>
      <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-w rv mt-2">{{ ar('احصل على بطاقتك','Get your card') }}</Link>
    </div>
    <!-- CARD GRID -->
    <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
      <div v-for="(c,i) in [
        {n:'Standard',sub:ar('مجاني','Free'),img:'/images/card-standard.png',features:[ar('بطاقة Mastercard افتراضية','Virtual Mastercard'),ar('Apple Pay & Google Pay','Apple Pay & Google Pay'),ar('دفع عبر الإنترنت','Online payments'),ar('حد سحب €500','€500 ATM limit')]},
        {n:'Plus',sub:'3.99€/'+ar('شهرياً','mo'),img:'/images/card-plus.png',features:[ar('بطاقة معدنية','Physical card'),ar('حماية مشتريات','Purchase protection'),ar('حدود مضاعفة','Double limits'),ar('دعم أولوية','Priority support')]},
        {n:'Premium',sub:'7.99€/'+ar('شهرياً','mo'),img:'/images/card-premium.png',features:[ar('صرف عملات غير محدود','Unlimited FX'),ar('تأمين سفر شامل','Travel insurance'),ar('3x صالات مطارات','3x lounge access'),ar('eSIM بيانات دولية','eSIM global data')]},
        {n:'Elite',sub:'14.99€/'+ar('شهرياً','mo'),img:'/images/card-elite.png',features:[ar('صالات VIP غير محدودة','Unlimited VIP lounges'),ar('مدير حساب خاص','Personal manager'),ar('استرداد نقدي 1%','1% cashback'),ar('تأمين شامل','Full insurance')]}
      ]" :key="i" class="rv-card-item rv" :style="{transitionDelay:(i*120)+'ms'}">
        <img :src="c.img" :alt="c.n" class="rv-card-img" />
        <h3 class="text-lg font-bold text-white mt-4">{{ c.n }}</h3>
        <div class="text-sm text-white/35 mb-3">{{ c.sub }}</div>
        <ul class="space-y-2">
          <li v-for="f in c.features" :key="f" class="text-xs text-white/30 flex items-start gap-2"><span class="text-green-400 mt-0.5">✓</span> {{ f }}</li>
        </ul>
      </div>
    </div>
    <!-- CARD FEATURES -->
    <div class="grid sm:grid-cols-3 gap-6 mt-16">
      <div v-for="(f,i) in [
        {icon:'📱',t:ar('Apple Pay & Google Pay','Apple Pay & Google Pay'),d:ar('أضف بطاقتك إلى محفظتك الرقمية وادفع بهاتفك في كل مكان.','Add your card to your digital wallet and pay with your phone everywhere.')},
        {icon:'🔒',t:ar('تجميد فوري','Instant freeze'),d:ar('جمّد بطاقتك فوراً من التطبيق إذا فقدتها. فعّلها مرة أخرى بضغطة.','Instantly freeze your card from the app if you lose it. Reactivate with a tap.')},
        {icon:'🔄',t:ar('CVV متغير','Dynamic CVV'),d:ar('رمز أمان يتغير تلقائياً لحماية إضافية في عمليات الشراء عبر الإنترنت.','Security code that changes automatically for extra protection in online purchases.')}
      ]" :key="i" class="rv-dark-feature rv" :style="{transitionDelay:(i*100)+'ms'}">
        <div class="text-2xl mb-3">{{ f.icon }}</div>
        <h4 class="font-bold text-white text-sm mb-1">{{ f.t }}</h4>
        <p class="text-xs text-white/30 leading-relaxed">{{ f.d }}</p>
      </div>
    </div>
  </div>
</section>

<!-- HOW IT WORKS -->
<section class="rv-section rv-section-white">
  <div class="rv-container text-center">
    <h2 class="rv-heading rv">{{ ar('ابدأ في 3 دقائق','Get started in 3 minutes') }}</h2>
    <p class="rv-subtext rv max-w-xl mx-auto">{{ ar('لا حاجة لزيارة فرع. افتح حسابك بالكامل من هاتفك.','No branch visit needed. Open your account entirely from your phone.') }}</p>
    <div class="grid sm:grid-cols-3 gap-8 mt-12">
      <div v-for="(s,i) in [
        {num:'01',icon:'📱',t:ar('حمّل التطبيق','Download the app'),d:ar('حمّل تطبيق SDB من App Store أو Google Play وسجّل ببياناتك الأساسية.','Download SDB from App Store or Google Play and register with your basic info.')},
        {num:'02',icon:'🪪',t:ar('تحقق من هويتك','Verify your identity'),d:ar('ارفع صورة هويتك والتقط سيلفي سريع. التحقق يستغرق دقائق فقط.','Upload your ID photo and take a quick selfie. Verification takes just minutes.')},
        {num:'03',icon:'💳',t:ar('استلم بطاقتك','Get your card'),d:ar('احصل على بطاقة Mastercard افتراضية فوراً وابدأ الدفع والتحويل.','Get an instant virtual Mastercard and start paying and transferring.')}
      ]" :key="i" class="rv-step-card rv" :style="{transitionDelay:(i*150)+'ms'}">
        <div class="rv-step-num">{{ s.num }}</div>
        <div class="text-3xl mb-3">{{ s.icon }}</div>
        <h3 class="font-bold text-[#0B1F3A] text-lg mb-2">{{ s.t }}</h3>
        <p class="text-sm text-[#0B1F3A]/40 leading-relaxed">{{ s.d }}</p>
      </div>
    </div>
  </div>
</section>

<!-- TRANSFERS -->
<section id="transfers" class="rv-section rv-section-light">
  <div class="rv-container grid md:grid-cols-2 gap-16 items-center">
    <div :class="isAr ? 'text-right' : ''">
      <div class="rv-badge rv">{{ ar('تحويلات دولية','International Transfers') }}</div>
      <h2 class="rv-heading rv">{{ ar('أرسل أموالك إلى 150+ دولة','Send money to 150+ countries') }}</h2>
      <p class="rv-subtext rv">{{ ar('تحويلات دولية سريعة وآمنة بأقل الرسوم. ادعم عائلتك أو ادفع لشركائك التجاريين حول العالم بسعر الصرف الحقيقي.','Fast and secure international transfers at minimal fees. Support your family or pay your business partners worldwide at the real exchange rate.') }}</p>
      <div class="grid grid-cols-2 gap-4 mt-6">
        <div v-for="(f,i) in [
          {val:'150+',l:ar('دولة','Countries')},
          {val:'30+',l:ar('عملة','Currencies')},
          {val:'<1',l:ar('دقيقة','Minute')},
          {val:'0.5%',l:ar('رسوم فقط','Fees only')}
        ]" :key="i" class="rv-stat-card rv" :style="{transitionDelay:(i*100)+'ms'}">
          <div class="rv-stat-val">{{ f.val }}</div>
          <div class="rv-stat-label">{{ f.l }}</div>
        </div>
      </div>
      <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-dark rv mt-8 inline-flex">{{ ar('ابدأ التحويل','Start transfer') }}</Link>
    </div>
    <div class="rv flex justify-center">
      <img src="/images/world-transfer.png" alt="Global transfers" class="rv-section-img" />
    </div>
  </div>
</section>

<!-- SECURITY -->
<section id="security" class="rv-section rv-section-white">
  <div class="rv-container grid md:grid-cols-2 gap-16 items-center">
    <div class="rv flex justify-center order-2 md:order-1">
      <img src="/images/security-shield.png" alt="Security" class="rv-section-img max-w-[320px]" />
    </div>
    <div :class="isAr ? 'text-right' : ''" class="order-1 md:order-2">
      <div class="rv-badge rv">{{ ar('الأمان','Security') }}</div>
      <h2 class="rv-heading rv">{{ ar('أموالك في مكان آمن','Your money\'s safe space') }}</h2>
      <p class="rv-subtext rv">{{ ar('مع SDB Secure، أنت تدخل عصراً جديداً من أمان الأموال — حيث تحميك دفاعاتنا الاستباقية وفريق متخصصي الاحتيال على مدار الساعة.','With SDB Secure, you\'re entering a new era of money security — where our proactive defences and fraud specialists help protect every account, 24/7.') }}</p>
      <div class="space-y-3 mt-6">
        <div v-for="(f,i) in [
          {icon:'🛡️',t:ar('تشفير متقدم 256-bit','256-bit encryption')},
          {icon:'📲',t:ar('مصادقة ثنائية (2FA)','Two-factor authentication')},
          {icon:'🔔',t:ar('إشعارات فورية لكل عملية','Instant alerts for every transaction')},
          {icon:'❄️',t:ar('تجميد البطاقة من التطبيق','Freeze card from app')},
          {icon:'🔐',t:ar('بصمة الوجه والإصبع','Face ID & fingerprint')},
          {icon:'👁️',t:ar('فريق مراقبة احتيال 24/7','24/7 fraud monitoring team')}
        ]" :key="i" class="rv-check-row rv" :style="{transitionDelay:(i*60)+'ms'}">
          <span class="text-lg">{{ f.icon }}</span>
          <span class="font-medium text-sm text-[#0B1F3A]">{{ f.t }}</span>
        </div>
      </div>
      <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-dark rv mt-8 inline-flex">{{ ar('اعرف أكثر','Learn more') }}</Link>
    </div>
  </div>
</section>

<!-- STATS -->
<section class="rv-section rv-section-dark">
  <div class="rv-container">
    <div class="grid sm:grid-cols-4 gap-8 text-center">
      <div v-for="s in [
        {val:'1M+',l:ar('عميل نشط','Active customers')},
        {val:'€250M+',l:ar('حجم التداول','Trading volume')},
        {val:'99.9%',l:ar('وقت التشغيل','Uptime')},
        {val:'30+',l:ar('عملة مدعومة','Supported currencies')}
      ]" :key="s.val" class="rv">
        <div class="text-4xl font-black text-white mb-2">{{ s.val }}</div>
        <div class="text-sm text-white/35">{{ s.l }}</div>
      </div>
    </div>
  </div>
</section>

<!-- PRICING -->
<section id="pricing" class="rv-section rv-section-light">
  <div class="rv-container">
    <h2 class="rv-heading rv mb-4">{{ ar('اختر خطتك','Choose your plan') }}</h2>
    <p class="rv-subtext rv mb-12">{{ ar('ابدأ مجاناً وطوّر خطتك حسب احتياجاتك. بدون عقود أو التزامات.','Start free and upgrade as you need. No contracts or commitments.') }}</p>
    <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-5 mb-5">
      <div v-for="(p,i) in [
        {n:'Standard',price:ar('مجاني','Free'),desc:ar('كل الأساسيات — حساب رقمي متعدد العملات، بطاقة Mastercard افتراضية، تحويلات محلية، وإدارة أموالك من تطبيق واحد.','The basics — multi-currency digital account, virtual Mastercard, local transfers, and money management from one app.')},
        {n:'Plus',price:'3.99€',desc:ar('للمنفق الذكي — بطاقة Mastercard معدنية، حدود أعلى للتحويلات، حماية مشتريات، ودعم أولوية على مدار الساعة.','For the smart spender — physical Mastercard, higher transfer limits, purchase protection, and 24/7 priority support.')},
        {n:'Premium',price:'7.99€',desc:ar('لحياة أفضل كل يوم — صرف عملات غير محدود، تأمين سفر شامل، 3 زيارات لصالات المطارات شهرياً، وبيانات eSIM دولية.','For elevating every day — unlimited FX, travel insurance, 3 monthly lounge visits, and international eSIM data.')}
      ]" :key="i" class="rv-plan-card rv" :style="{transitionDelay:(i*100)+'ms'}">
        <h3 class="text-xl font-black text-[#0B1F3A] mb-1">{{ p.n }}</h3>
        <div class="text-lg font-bold text-[#0B1F3A] mb-4">{{ p.price }}<span v-if="!['مجاني','Free'].includes(p.price)" class="text-sm text-[#0B1F3A]/40 font-normal">/{{ ar('شهرياً','month') }}</span></div>
        <p class="text-sm text-[#0B1F3A]/45 leading-relaxed mb-8">{{ p.desc }}</p>
        <Link v-if="canRegister" :href="route('register')" class="rv-plan-arrow mt-auto">→</Link>
      </div>
    </div>
    <div class="grid sm:grid-cols-2 gap-5">
      <div v-for="(p,i) in [
        {n:'Metal',price:'14.99€',desc:ar('للمسافرين والتجار — تأمين سفر شامل، حدود محسّنة، استرداد نقدي 1%، واشتراكات شركاء بقيمة 2,100€ سنوياً.','For travellers and traders — full travel insurance, enhanced limits, 1% cashback, and partner subscriptions worth €2,100 annually.')},
        {n:'Ultra',price:'45€',desc:ar('لمن يريد الأفضل — صالات مطارات VIP غير محدودة، بيانات دولية شهرية، مدير حساب خاص، واشتراكات شركاء حصرية.','For the best — unlimited VIP lounges, monthly global data, dedicated account manager, and exclusive partner subscriptions.')}
      ]" :key="i" class="rv-plan-card rv" :style="{transitionDelay:((i+3)*100)+'ms'}">
        <h3 class="text-xl font-black text-[#0B1F3A] mb-1">{{ p.n }}</h3>
        <div class="text-lg font-bold text-[#0B1F3A] mb-4">{{ p.price }}<span class="text-sm text-[#0B1F3A]/40 font-normal">/{{ ar('شهرياً','month') }}</span></div>
        <p class="text-sm text-[#0B1F3A]/45 leading-relaxed mb-8">{{ p.desc }}</p>
        <Link v-if="canRegister" :href="route('register')" class="rv-plan-arrow mt-auto">→</Link>
      </div>
    </div>
  </div>
</section>

<!-- TESTIMONIALS -->
<section class="rv-section rv-section-white">
  <div class="rv-container text-center">
    <h2 class="rv-heading rv">{{ ar('ماذا يقول عملاؤنا','What our customers say') }}</h2>
    <div class="grid sm:grid-cols-3 gap-6 mt-12">
      <div v-for="(t,i) in [
        {name:ar('أحمد محمد','Ahmad M.'),role:ar('رائد أعمال','Entrepreneur'),text:ar('SDB غيّر طريقة إدارتي لأموالي. الحسابات المتعددة العملات والتحويلات الفورية وبطاقة Mastercard — كل شي بتطبيق واحد.','SDB changed how I manage my money. Multi-currency accounts, instant transfers and Mastercard — everything in one app.')},
        {name:ar('سارة علي','Sara A.'),role:ar('مصممة','Designer'),text:ar('بطاقة Premium رائعة! صالات المطارات والتأمين يخلوا السفر بدون قلق. وسعر الصرف أفضل من البنوك التقليدية.','The Premium card is amazing! Lounge access and insurance make travel stress-free. And the exchange rate beats traditional banks.')},
        {name:ar('عمر حسن','Omar H.'),role:ar('مهندس برمجيات','Software Engineer'),text:ar('أفضل تجربة مصرفية رقمية استخدمتها. الأمان عالي، الإشعارات الفورية ممتازة، والتطبيق سلس جداً.','Best digital banking I\'ve used. Security is top-notch, instant alerts are great, and the app is super smooth.')}
      ]" :key="i" class="rv-testimonial rv" :style="{transitionDelay:(i*120)+'ms'}">
        <div class="rv-test-stars">⭐⭐⭐⭐⭐</div>
        <p class="rv-test-text">{{ t.text }}</p>
        <div class="rv-test-author">
          <div class="rv-test-avatar">{{ t.name[0] }}</div>
          <div>
            <div class="font-bold text-sm text-[#0B1F3A]">{{ t.name }}</div>
            <div class="text-xs text-[#0B1F3A]/35">{{ t.role }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="rv-section rv-section-dark">
  <div class="rv-container text-center">
    <h2 class="rv-heading rv text-white max-w-3xl mx-auto">{{ ar('افتح حسابك اليوم وانضم لآلاف العملاء الذين يثقون بنا','Open your account today and join thousands of customers who trust us') }}</h2>
    <p class="rv-subtext rv text-white/35 max-w-xl mx-auto">{{ ar('سجّل خلال دقائق واحصل على بطاقة Mastercard افتراضية فوراً. بدون رسوم، بدون عقود.','Register in minutes and get an instant virtual Mastercard. No fees, no contracts.') }}</p>
    <Link v-if="canRegister" :href="route('register')" class="rv-btn-pill-w rv-btn-lg rv">{{ ar('سجّل الآن مجاناً','Sign up for free') }}</Link>
  </div>
</section>

<!-- FOOTER -->
<footer class="rv-footer">
  <div class="rv-container">
    <div class="grid md:grid-cols-5 gap-8 mb-12">
      <div class="md:col-span-2">
        <img src="/images/sdb-logo.png" alt="SDB" class="rv-footer-logo" />
        <p class="text-[#0B1F3A]/25 text-xs leading-relaxed max-w-xs mt-4">{{ ar('بنك رقمي مرخّص في الدنمارك. خدمات مصرفية مبتكرة بمعايير أوروبية عالمية. حسابات متعددة العملات وبطاقات Mastercard ذكية.','A licensed digital bank in Denmark. Innovative banking with European standards. Multi-currency accounts and smart Mastercard cards.') }}</p>
      </div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('المنتجات','Products') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/30"><li><a href="#currencies" class="hover:text-[#0B1F3A] transition">{{ ar('العملات','Currencies') }}</a></li><li><a href="#cards" class="hover:text-[#0B1F3A] transition">{{ ar('بطاقات Mastercard','Mastercard Cards') }}</a></li><li><a href="#transfers" class="hover:text-[#0B1F3A] transition">{{ ar('التحويلات الدولية','International Transfers') }}</a></li><li><Link href="/currencies" class="hover:text-[#0B1F3A] transition">{{ ar('أسعار الصرف','Exchange Rates') }}</Link></li></ul></div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('قانوني','Legal') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/30"><li><Link href="/terms" class="hover:text-[#0B1F3A] transition">{{ ar('الشروط والأحكام','Terms') }}</Link></li><li><Link href="/privacy" class="hover:text-[#0B1F3A] transition">{{ ar('سياسة الخصوصية','Privacy') }}</Link></li><li><Link href="/about" class="hover:text-[#0B1F3A] transition">{{ ar('عن البنك','About') }}</Link></li><li><Link href="/support" class="hover:text-[#0B1F3A] transition">{{ ar('الدعم','Support') }}</Link></li></ul></div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('تواصل','Contact') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/30"><li>📧 info@sdb-bank.com</li><li>📞 +45 42 80 55 94</li><li>📍 Wimosem 18, 4000 Roskilde</li><li>🇩🇰 Denmark</li></ul></div>
    </div>
    <div class="border-t border-[#0B1F3A]/8 pt-6 flex flex-col md:flex-row items-center justify-between gap-3">
      <p class="text-[#0B1F3A]/20 text-[11px]">© 2026 SDB Bank ApS. {{ ar('جميع الحقوق محفوظة. مسجل في الدنمارك.','All rights reserved. Registered in Denmark.') }}</p>
      <button @click="toggleLang" class="text-[11px] text-[#0B1F3A]/25 hover:text-[#0B1F3A] transition">{{ ar('English','عربي') }}</button>
    </div>
  </div>
</footer>

</div>
</template>

<style>
/* CORE */
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
.rv-btn-pill-w{display:inline-flex;align-items:center;justify-content:center;padding:10px 24px;border-radius:100px;font-weight:600;font-size:14px;background:#fff;color:#0B1F3A;transition:all .25s;border:none;cursor:pointer}.rv-btn-pill-w:hover{background:rgba(255,255,255,0.85)}
.rv-btn-lg{padding:18px 48px;font-size:17px}

/* HERO */
.rv-hero{position:relative;background:#4DA3E8;overflow:hidden}
.rv-hero-bg{position:absolute;inset:0;background-size:cover;background-position:center top;opacity:0.55}
.rv-hero-overlay{position:absolute;inset:0;background:linear-gradient(135deg,rgba(77,163,232,0.75) 0%,rgba(77,163,232,0.3) 50%,rgba(77,163,232,0.55) 100%)}
.rv-hero-heading{font-size:clamp(2.8rem,6vw,4.5rem);font-weight:900;line-height:1.05;color:#fff;margin-bottom:24px;letter-spacing:-0.02em}
.rv-hero-sub{font-size:18px;color:rgba(255,255,255,0.7);line-height:1.7;max-width:500px;margin-bottom:32px}

/* PHONE */
.rv-phone-mockup{width:320px;background:rgba(255,255,255,0.15);backdrop-filter:blur(20px);border-radius:32px;border:2px solid rgba(255,255,255,0.2);overflow:hidden;padding:20px}
.rv-phone-header{text-align:center;padding:20px 0}
.rv-phone-pill{display:inline-flex;padding:6px 20px;border-radius:100px;background:rgba(255,255,255,0.2);color:#fff;font-size:13px;font-weight:600;margin-top:12px}
.rv-phone-tx{display:flex;align-items:center;gap:12px;background:#fff;border-radius:16px;padding:12px 16px;box-shadow:0 4px 20px rgba(0,0,0,0.08)}
.rv-tx-icon{width:36px;height:36px;border-radius:50%;background:#EEF2FF;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}

/* MARQUEE */
.rv-marquee{padding:20px 0;background:#FAFBFC;border-bottom:1px solid rgba(11,31,58,0.04);overflow:hidden}
.rv-marquee-track{display:flex;gap:48px;animation:marqueeScroll 20s linear infinite;white-space:nowrap}
.rv-marquee-item{font-size:14px;font-weight:700;color:rgba(11,31,58,0.12);text-transform:uppercase;letter-spacing:2px}
@keyframes marqueeScroll{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}

/* SECTIONS */
.rv-section{padding:100px 0;position:relative}
.rv-section-light{background:#F0F0F0}
.rv-section-white{background:#fff}
.rv-section-black{background:#0B1F3A}
.rv-section-dark{background:#111}
.rv-heading{font-size:clamp(2rem,4.5vw,3.2rem);font-weight:900;line-height:1.1;margin-bottom:16px;letter-spacing:-0.02em}
.rv-subtext{font-size:17px;color:rgba(11,31,58,0.45);line-height:1.7;margin-bottom:24px}
.rv-badge{display:inline-flex;padding:6px 18px;border-radius:100px;background:rgba(37,99,235,0.08);color:#2563EB;font-size:12px;font-weight:700;margin-bottom:16px;text-transform:uppercase;letter-spacing:1px}
.rv-badge-dark{background:rgba(255,255,255,0.06);color:rgba(255,255,255,0.5)}

/* RATES GRID */
.rv-rates-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px;max-width:420px}
.rv-rate-card{padding:16px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.06);border-radius:14px;text-align:center;transition:all .3s}.rv-rate-card:hover{border-color:rgba(37,99,235,0.15);transform:translateY(-3px);box-shadow:0 8px 20px rgba(37,99,235,0.06)}

/* CRYPTO */
.rv-crypto-card{display:flex;align-items:center;gap:14px;padding:18px;background:#fff;border:1px solid rgba(11,31,58,0.06);border-radius:16px;transition:all .3s}.rv-crypto-card:hover{border-color:rgba(37,99,235,0.12);box-shadow:0 8px 20px rgba(0,0,0,0.04);transform:translateY(-2px)}
.rv-crypto-icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:bold;flex-shrink:0}
.rv-crypto-change{padding:4px 10px;border-radius:8px;font-size:12px;font-weight:700}
.rv-up{background:rgba(0,208,132,0.1);color:#00D084}
.rv-dn{background:rgba(255,59,48,0.1);color:#FF3B30}

/* FEATURE ROW */
.rv-feature-row{display:flex;align-items:flex-start;gap:16px;padding:14px 0;border-bottom:1px solid rgba(11,31,58,0.06)}
.rv-feature-icon{width:44px;height:44px;border-radius:14px;background:#F0F0F0;display:flex;align-items:center;justify-content:center;font-size:22px;flex-shrink:0}

/* CARDS */
.rv-card-item{text-align:center;padding:24px;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.06);border-radius:20px;transition:all .4s}.rv-card-item:hover{transform:translateY(-6px);border-color:rgba(255,255,255,0.15)}
.rv-card-img{width:100%;height:auto;border-radius:16px;box-shadow:0 8px 30px rgba(0,0,0,0.3);transition:transform .5s}.rv-card-img:hover{transform:perspective(600px) rotateY(-5deg)}
.rv-dark-feature{padding:24px;background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:16px;text-align:center}

/* STEPS */
.rv-step-card{padding:32px 24px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.05);border-radius:20px;transition:all .3s}.rv-step-card:hover{transform:translateY(-4px);box-shadow:0 12px 35px rgba(0,0,0,0.06)}
.rv-step-num{font-size:48px;font-weight:900;color:rgba(37,99,235,0.08);line-height:1;margin-bottom:8px}

/* STATS */
.rv-stat-card{padding:20px;background:#fff;border:1px solid rgba(11,31,58,0.06);border-radius:16px;text-align:center}
.rv-stat-val{font-size:28px;font-weight:900;color:#2563EB;margin-bottom:4px}
.rv-stat-label{font-size:12px;color:rgba(11,31,58,0.35);font-weight:600}

/* CHECK ROW */
.rv-check-row{display:flex;align-items:center;gap:12px;padding:8px 0}

/* SECTION IMAGE */
.rv-section-img{width:100%;max-width:450px;height:auto;filter:drop-shadow(0 20px 60px rgba(0,0,0,0.15))}

/* PRICING */
.rv-plan-card{background:#fff;border-radius:20px;padding:32px;display:flex;flex-direction:column;border:1px solid rgba(11,31,58,0.06);transition:all .35s}.rv-plan-card:hover{transform:translateY(-4px);box-shadow:0 15px 40px rgba(0,0,0,0.08)}
.rv-plan-arrow{display:inline-flex;align-items:center;justify-content:center;width:40px;height:40px;border-radius:50%;background:rgba(11,31,58,0.04);color:#0B1F3A;font-size:18px;transition:all .3s;align-self:flex-end}.rv-plan-arrow:hover{background:#0B1F3A;color:#fff;transform:translateX(4px)}

/* TESTIMONIALS */
.rv-testimonial{padding:32px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.05);border-radius:20px;text-align:right;transition:all .3s}.rv-testimonial:hover{box-shadow:0 12px 35px rgba(0,0,0,0.05);transform:translateY(-3px)}
.rv-test-stars{margin-bottom:16px;font-size:14px;letter-spacing:2px}
.rv-test-text{font-size:14px;color:rgba(11,31,58,0.55);line-height:1.8;margin-bottom:20px}
.rv-test-author{display:flex;align-items:center;gap:12px}
.rv-test-avatar{width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,#2563EB,#4DA3E8);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:16px;flex-shrink:0}

/* FOOTER */
.rv-footer{padding:60px 0 32px;background:#FAFBFC;border-top:1px solid rgba(11,31,58,0.06)}
.rv-footer-logo{height:50px;width:auto;object-fit:contain}

/* SCROLL REVEAL */
.rv{opacity:0;transform:translateY(25px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.rv.revealed{opacity:1;transform:translateY(0)}

/* RESPONSIVE */
@media(max-width:768px){.rv-hero-heading{font-size:2.4rem}.rv-heading{font-size:1.8rem}.rv-section{padding:60px 0}.rv-rates-grid{grid-template-columns:repeat(2,1fr)}}

::-webkit-scrollbar{width:4px}::-webkit-scrollbar-track{background:#fff}::-webkit-scrollbar-thumb{background:#0B1F3A;border-radius:4px}
</style>
