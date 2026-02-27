<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';
defineProps({ canLogin: Boolean, canRegister: Boolean });
const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');
const toggleLang = () => lang.value = lang.value === 'ar' ? 'en' : 'ar';
const phone = ref('');
const mobileMenuOpen = ref(false);
const ar = (a, e) => isAr.value ? a : e;

// Active nav section
const activeSection = ref('');

// Testimonial rotation
const activeTestimonial = ref(0);
const testimonials = [
  { name: ar('أحمد محمد','Ahmad M.'), role: ar('رائد أعمال','Entrepreneur'), text: ar('SDB غيّر طريقة إدارتي لأموالي. التطبيق سهل وسريع والتحويلات فورية.','SDB changed how I manage my finances. The app is fast and transfers are instant.'), rating: 5 },
  { name: ar('سارة علي','Sara A.'), role: ar('مصممة','Designer'), text: ar('بطاقة Elite رائعة! صالات المطارات والتأمين يخلوا السفر بدون قلق.','The Elite card is amazing! Lounge access and insurance make travel stress-free.'), rating: 5 },
  { name: ar('عمر حسن','Omar H.'), role: ar('مهندس برمجيات','Software Engineer'), text: ar('أفضل تجربة مصرفية رقمية. الأمان عالي والإشعارات الفورية ممتازة.','Best digital banking experience. Security is top-notch and instant alerts are great.'), rating: 5 },
];
let testimonialTimer = null;

// Stats counter animation
const stats = ref([
  { target: 1, suffix: 'M+', current: 0 },
  { target: 250, prefix: '$', suffix: 'M+', current: 0 },
  { target: 99.9, suffix: '%', current: 0 },
  { target: 15, suffix: '+', current: 0 },
]);
const statsVisible = ref(false);
function animateCounters() {
  if (statsVisible.value) return;
  statsVisible.value = true;
  stats.value.forEach((s, i) => {
    const dur = 2000, steps = 60, inc = s.target / steps;
    let cur = 0;
    const t = setInterval(() => {
      cur += inc;
      if (cur >= s.target) { cur = s.target; clearInterval(t); }
      stats.value[i].current = s.target < 10 ? Math.round(cur * 10) / 10 : Math.round(cur);
    }, dur / steps);
  });
}

// Card tilt
const cardRef = ref(null);
function handleCardMove(e) {
  if (!cardRef.value) return;
  const r = cardRef.value.getBoundingClientRect();
  const x = (e.clientX - r.left) / r.width - 0.5;
  const y = (e.clientY - r.top) / r.height - 0.5;
  cardRef.value.style.transform = `rotateY(${x * 20}deg) rotateX(${-y * 15}deg)`;
}
function handleCardLeave() { if (cardRef.value) cardRef.value.style.transform = 'rotateY(-6deg) rotateX(4deg)'; }

// Scroll reveal + active section tracking
let observer = null;
onMounted(() => {
  observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('revealed');
        if (entry.target.classList.contains('stats-bar')) animateCounters();
        if (entry.target.id) activeSection.value = entry.target.id;
      }
    });
  }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });
  document.querySelectorAll('.reveal, .reveal-left, .reveal-right, .reveal-scale, .stats-bar, section[id]').forEach(el => observer.observe(el));
  testimonialTimer = setInterval(() => { activeTestimonial.value = (activeTestimonial.value + 1) % testimonials.length; }, 5000);
});
onUnmounted(() => { if (observer) observer.disconnect(); if (testimonialTimer) clearInterval(testimonialTimer); });
</script>

<template>
<Head :title="ar('SDB - مستقبل المصارف الرقمية','SDB - Banking. Reimagined.')">
  <meta name="description" :content="ar('سوريا ديجيتال بنك - البنك الرقمي الأول في سوريا','Syria Digital Bank - The first digital bank in Syria')" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Cairo:wght@300;400;600;700;800;900&display=swap" rel="stylesheet" />
</Head>
<div :class="['sdb', isAr ? 'rtl font-ar' : 'ltr']" :dir="isAr ? 'rtl' : 'ltr'">

<!-- NAV -->
<nav class="nav-bar">
  <div class="max-w-7xl mx-auto px-6 flex items-center justify-between h-[90px]">
    <a href="/"><img src="/images/sdb-logo.png" alt="SDB" class="nav-logo" /></a>
    <div class="hidden md:flex items-center gap-8 text-[13.5px]">
      <a v-for="s in [{id:'salary',l:ar('الراتب','Salary')},{id:'cards',l:ar('البطاقات','Cards')},{id:'travel',l:ar('السفر','Travel')},{id:'security',l:ar('الأمان','Security')},{id:'pricing',l:ar('الخطط','Plans')}]" :key="s.id" :href="'#'+s.id" class="nav-lnk" :class="activeSection===s.id ? 'nav-active' : ''">{{ s.l }}</a>
      <button @click="toggleLang" class="lang-toggle">{{ ar('EN','عربي') }}</button>
    </div>
    <div class="hidden md:flex items-center gap-3">
      <Link v-if="canLogin" :href="route('login')" class="text-white/60 hover:text-[#60A5FA] text-sm px-4 py-2 transition-colors font-medium">{{ ar('تسجيل الدخول','Login') }}</Link>
      <Link v-if="canRegister" :href="route('register')" class="btn-glow text-sm">{{ ar('فتح حساب','Open Account') }}</Link>
    </div>
    <button @click="mobileMenuOpen=!mobileMenuOpen" class="md:hidden text-white"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg></button>
  </div>
  <!-- MOBILE MENU -->
  <div v-if="mobileMenuOpen" class="md:hidden mob-menu">
    <a v-for="s in [{id:'salary',l:ar('الراتب','Salary')},{id:'cards',l:ar('البطاقات','Cards')},{id:'travel',l:ar('السفر','Travel')},{id:'security',l:ar('الأمان','Security')},{id:'pricing',l:ar('الخطط','Plans')}]" :key="s.id" :href="'#'+s.id" class="mob-link" @click="mobileMenuOpen=false">{{ s.l }}</a>
    <div class="flex gap-3 mt-4">
      <Link v-if="canLogin" :href="route('login')" class="mob-link">{{ ar('تسجيل الدخول','Login') }}</Link>
      <Link v-if="canRegister" :href="route('register')" class="btn-blue text-sm w-full text-center">{{ ar('فتح حساب','Open Account') }}</Link>
    </div>
  </div>
</nav>

<!-- HERO -->
<section class="hero-dark">
  <!-- Animated particles -->
  <div class="particles">
    <div v-for="i in 20" :key="i" class="particle" :style="{left: Math.random()*100+'%', top: Math.random()*100+'%', animationDelay: Math.random()*5+'s', animationDuration: (3+Math.random()*4)+'s', width: (2+Math.random()*4)+'px', height: (2+Math.random()*4)+'px'}"></div>
  </div>
  <div class="hero-glow-1"></div>
  <div class="hero-glow-2"></div>
  <div class="hero-grid-bg"></div>
  <div class="relative max-w-7xl mx-auto px-6 grid md:grid-cols-2 gap-16 items-center pt-36 pb-24 md:pt-44 md:pb-32">
    <div :class="isAr ? 'text-right' : ''" class="reveal">
      <div class="hero-tag-dark"><span class="tag-dot"></span>{{ ar('مصرفية رقمية من الجيل الجديد','Next-Gen Digital Banking') }}</div>
      <h1 class="text-[clamp(2.4rem,5vw,3.6rem)] font-black leading-[1.08] text-white mb-6">{{ ar('مستقبل المصارف بين يديك مع','The Future of Banking in Your Hands with') }} <span class="bg-gradient-to-r from-[#1E5EFF] to-[#00C2FF] bg-clip-text text-transparent">SDB</span></h1>
      <p class="text-white/55 text-[17px] leading-relaxed mb-10 max-w-lg">{{ ar('افتح حسابك الرقمي خلال دقائق. حسابات متعددة العملات، بطاقات افتراضية وحقيقية، تحويلات دولية فورية — كل ذلك من تطبيق واحد آمن.','Open your digital account in minutes. Multi-currency accounts, virtual and physical cards, instant international transfers — all from one secure app.') }}</p>
      <div class="flex items-center gap-3 mb-3 max-w-md">
        <Link v-if="canRegister" :href="route('register')" class="btn-glow btn-big whitespace-nowrap">{{ ar('افتح حسابك مجاناً','Open Free Account') }}</Link>
        <a href="#cards" class="btn-glass whitespace-nowrap">{{ ar('اكتشف البطاقات','Explore Cards') }}</a>
      </div>
      <div class="flex items-center gap-4 mt-6">
        <div class="flex -space-x-2">
          <div class="w-8 h-8 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 border-2 border-[#0B1F3A] flex items-center justify-center text-white text-[10px] font-bold">A</div>
          <div class="w-8 h-8 rounded-full bg-gradient-to-br from-violet-400 to-violet-600 border-2 border-[#0B1F3A] flex items-center justify-center text-white text-[10px] font-bold">S</div>
          <div class="w-8 h-8 rounded-full bg-gradient-to-br from-emerald-400 to-emerald-600 border-2 border-[#0B1F3A] flex items-center justify-center text-white text-[10px] font-bold">M</div>
        </div>
        <p class="text-[12px] text-white/30">{{ ar('انضم لآلاف العملاء الذين يثقون بنا','Join thousands of customers who trust us') }}</p>
      </div>
    </div>
    <!-- 3D HERO IMAGE -->
    <div class="flex justify-center reveal-scale">
      <img src="/images/hero-3d.png" alt="SDB Banking App" class="hero-3d-img" />
    </div>
  </div>
</section>

<!-- CRYPTO TICKER -->
<section class="crypto-ticker">
  <div class="max-w-7xl mx-auto px-6">
    <div class="crypto-grid">
      <div v-for="(coin,i) in [
        {name:'Bitcoin',sym:'BTC',price:'$97,245',change:'+2.4%',up:true,icon:'₿',color:'#F7931A'},
        {name:'Ethereum',sym:'ETH',price:'$3,480',change:'+5.1%',up:true,icon:'⟠',color:'#627EEA'},
        {name:'Tether',sym:'USDT',price:'$1.00',change:'+0.01%',up:true,icon:'₮',color:'#26A17B'},
        {name:'Solana',sym:'SOL',price:'$198.50',change:'-1.2%',up:false,icon:'◎',color:'#9945FF'}
      ]" :key="i" class="crypto-card reveal" :style="{transitionDelay: (i*100)+'ms'}">
        <div class="crypto-icon" :style="{background: coin.color+'18', color: coin.color}">{{ coin.icon }}</div>
        <div>
          <div class="text-sm font-bold text-[#0B1F3A]">{{ coin.name }} <span class="text-[#0B1F3A]/30 text-xs font-normal">{{ coin.sym }}</span></div>
          <div class="text-lg font-black text-[#0B1F3A]">{{ coin.price }}</div>
        </div>
        <div class="crypto-change" :class="coin.up ? 'crypto-up' : 'crypto-down'">{{ coin.change }}</div>
      </div>
    </div>
  </div>
</section>

<!-- HOW IT WORKS -->
<section class="sec">
  <div class="max-w-7xl mx-auto px-6 text-center mb-16 reveal">
    <h2 class="sec-title">{{ ar('كيف تبدأ مع SDB؟','How It Works') }}</h2>
    <p class="sec-desc">{{ ar('ثلاث خطوات بسيطة لبدء رحلتك المصرفية الرقمية','Three simple steps to start your digital banking journey') }}</p>
  </div>
  <div class="max-w-4xl mx-auto px-6 grid md:grid-cols-3 gap-8">
    <div v-for="(step,i) in [{num:'01',icon:'📱',t:ar('سجّل حسابك','Create Account'),d:ar('أدخل بياناتك الأساسية وأنشئ حسابك خلال دقائق','Enter your basic info and create your account in minutes')},{num:'02',icon:'✅',t:ar('تحقق من هويتك','Verify Identity'),d:ar('ارفع صورة هويتك وأكمل التحقق السريع','Upload your ID and complete quick verification')},{num:'03',icon:'🚀',t:ar('ابدأ الاستخدام','Start Banking'),d:ar('استلم بطاقتك الرقمية وابدأ إدارة أموالك','Get your digital card and start managing your money')}]" :key="i" class="step-card reveal" :style="{transitionDelay: (i*150)+'ms'}">
      <div class="step-num">{{ step.num }}</div>
      <div class="step-icon">{{ step.icon }}</div>
      <h3 class="font-bold text-lg text-[#0B1F3A] mb-2">{{ step.t }}</h3>
      <p class="text-sm text-[#0B1F3A]/55 leading-relaxed">{{ step.d }}</p>
      <div v-if="i<2" class="step-arrow">→</div>
    </div>
  </div>
</section>

<!-- SALARY -->
<section id="salary" class="sec">
  <div class="sec-blue-bg"></div>
  <div class="relative max-w-7xl mx-auto px-6 grid md:grid-cols-2 gap-16 items-center">
    <div class="reveal">
      <img src="/images/app-screens.png" alt="SDB App Screens" class="section-img" />
    </div>
    <div class="reveal-right" :class="isAr ? 'text-right' : ''">
      <div class="sec-tag">{{ ar('إدارة الراتب','Salary Management') }}</div>
      <h2 class="sec-title" style="text-align:inherit">{{ ar('راتبك في مكان واحد — وتحكم كامل','Your Salary in One Place — Full Control') }}</h2>
      <p class="sec-desc" style="margin:0 0 24px 0">{{ ar('استقبل راتبك مباشرة، قسّمه تلقائياً بين المصاريف والادخار والاستثمار، وتابع تحليل مصاريفك الشهري بالوقت الحقيقي.','Receive your salary directly, auto-split between spending, savings, and investment. Track your monthly expense analysis in real-time.') }}</p>
      <div class="feature-list">
        <div v-for="(f,i) in [{t:ar('إيداع مباشر لراتبك','Direct salary deposit')},{t:ar('تقسيم تلقائي: مصاريف / ادخار / استثمار','Auto split: spend / save / invest')},{t:ar('إشعارات لحظية لكل حركة مالية','Real-time alerts for every transaction')},{t:ar('تحليل مصاريف ذكي بالرسوم البيانية','Smart expense analysis with charts')}]" :key="i" class="feature-item reveal" :style="{transitionDelay: (i * 100) + 'ms'}">
          <svg class="w-5 h-5 flex-shrink-0 text-[#00D084]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/></svg>
          <span class="text-sm text-[#0B1F3A]/60">{{ f.t }}</span>
        </div>
      </div>
      <Link v-if="canRegister" :href="route('register')" class="btn-outline mt-6 inline-flex">{{ ar('حوّل راتبك إلى SDB','Transfer Your Salary to SDB') }} →</Link>
    </div>
  </div>
</section>

<!-- CARDS -->
<section id="cards" class="sec">
  <div class="relative max-w-7xl mx-auto px-6 text-center mb-16 reveal">
    <h2 class="sec-title">{{ ar('بطاقات تناسب أسلوب حياتك','Cards That Fit Your Lifestyle') }}</h2>
    <p class="sec-desc">{{ ar('بطاقات رقمية ومعدنية بتصميم فاخر، إشعارات فورية، وإدارة كاملة للأمان.','Digital and metal cards with premium design and full security management.') }}</p>
  </div>
  <div class="max-w-6xl mx-auto px-6 grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
    <div v-for="(c,i) in [
      {n:'Standard',sub:ar('مجاني','Free'),img:'/images/card-standard.png',tc:'text-[#0B1F3A]',feats:ar(['بطاقة افتراضية','إشعارات فورية','تحويلات محلية','حد سحب 500€'],['Virtual card','Alerts','Local transfers','€500 limit'])},
      {n:'Plus',sub:'5€/mo',img:'/images/card-plus.png',tc:'text-[#1E5EFF]',feats:ar(['حدود مضاعفة','حماية مشتريات','Google &amp; Apple Pay','دعم أولوية'],['Double limits','Purchase protection','Google &amp; Apple Pay','Priority'])},
      {n:'Premium',sub:'12€/mo',img:'/images/card-premium.png',tc:'text-violet-600',feats:ar(['صرف غير محدود','تأمين سفر','بيانات eSIM','3x Lounge'],['Unlimited FX','Travel insurance','eSIM','3x Lounge'])},
      {n:'Elite',sub:'25€/mo',img:'/images/card-elite.png',tc:'text-[#C6A75E]',feats:ar(['Lounge غير محدود','مدير حساب خاص','مزايا VIP','استرداد نقدي'],['Unlimited Lounge','Dedicated manager','VIP perks','Cashback'])}
    ]" :key="i" class="card-tier-wrap reveal" :style="{transitionDelay: (i * 120) + 'ms'}">
      <div class="real-card-wrap">
        <img :src="c.img" :alt="c.n + ' Card'" class="real-card-img" />
      </div>
      <div class="text-xl font-black mt-5 mb-3" :class="c.tc">{{ c.sub }}</div>
      <ul class="space-y-2"><li v-for="f in c.feats" :key="f" class="text-[13px] text-[#0B1F3A]/60 flex items-center gap-2"><span class="w-1.5 h-1.5 rounded-full bg-[#1E5EFF]/50 flex-shrink-0"></span>{{ f }}</li></ul>
    </div>
  </div>
  <div class="max-w-4xl mx-auto px-6 mt-8 flex flex-wrap justify-center gap-3">
    <span v-for="f in ar(['Google Pay','Apple Pay','تجميد فوري','CVV متغير','بطاقة افتراضية'],['Google Pay','Apple Pay','Instant freeze','Dynamic CVV','Virtual card'])" :key="f" class="pill">{{ f }}</span>
  </div>
</section>

<!-- TRAVEL -->
<section id="travel" class="sec sec-dark">
  <div class="relative max-w-7xl mx-auto px-6 grid md:grid-cols-2 gap-16 items-center">
    <div class="reveal" :class="isAr ? 'text-right' : ''">
      <div class="sec-tag sec-tag-light">{{ ar('تحويلات دولية','International Transfers') }}</div>
      <h2 class="sec-title text-white" style="text-align:inherit">{{ ar('سافر وأرسل أموالك حول العالم','Travel & Send Money Worldwide') }}</h2>
      <p class="text-white/50 text-[15px] leading-relaxed mb-8">{{ ar('حسابات بعملات متعددة (DKK, USD, EUR, GBP)، تحويلات SWIFT فورية، صرف بأسعار تنافسية، وبطاقات تعمل في أكثر من 150 دولة.','Multi-currency accounts (DKK, USD, EUR, GBP), instant SWIFT transfers, competitive exchange rates, and cards accepted in 150+ countries.') }}</p>
      <div class="grid grid-cols-2 gap-4 mb-8">
        <div v-for="(f,i) in [{n:ar('عملة مدعومة','Currencies'),v:'15+'},{n:ar('دولة','Countries'),v:'150+'},{n:ar('تحويل فوري','Instant Transfer'),v:'24/7'},{n:ar('أقل رسوم','Low Fees'),v:'0.5%'}]" :key="i" class="travel-stat reveal" :style="{transitionDelay: (i * 100) + 'ms'}">
          <div class="text-2xl font-black text-white">{{ f.v }}</div>
          <div class="text-xs text-white/40">{{ f.n }}</div>
        </div>
      </div>
      <Link v-if="canRegister" :href="route('register')" class="btn-blue btn-big">{{ ar('افتح حساب متعدد العملات','Open Multi-Currency Account') }}</Link>
    </div>
    <div class="reveal-scale">
      <img src="/images/world-map.png" alt="Global Network" class="section-img rounded-2xl" />
    </div>
  </div>
</section>

<!-- SECURITY -->
<section id="security" class="sec">
  <div class="relative max-w-7xl mx-auto px-6 grid md:grid-cols-2 gap-16 items-center">
    <div class="reveal-scale">
      <img src="/images/security-shield.png" alt="Bank Security" class="section-img rounded-2xl" style="max-width:400px;margin:0 auto" />
    </div>
    <div class="reveal-right" :class="isAr ? 'text-right' : ''">
      <div class="sec-tag">{{ ar('حماية متقدمة','Advanced Protection') }}</div>
      <h2 class="sec-title" style="text-align:inherit">{{ ar('أموالك محمية بأعلى معايير الأمان','Your Money Protected by Highest Security Standards') }}</h2>
      <p class="sec-desc" style="margin:0 0 24px 0">{{ ar('نستخدم تشفير AES-256 بمعايير بنكية عالمية، مراقبة ذكية بالذكاء الاصطناعي لكشف الاحتيال، والمصادقة البيومترية لحماية حسابك.','We use AES-256 bank-grade encryption, AI-powered fraud monitoring, and biometric authentication to protect your account.') }}</p>
      <div class="grid grid-cols-2 gap-3">
        <div v-for="(f,i) in [{icon:'🔐',t:ar('Face ID / بصمة','Face ID / Touch ID')},{icon:'🔑',t:ar('مصادقة ثنائية','Two-Factor Auth')},{icon:'🤖',t:ar('كشف احتيال AI','AI Fraud Detection')},{icon:'❄️',t:ar('تجميد فوري','Instant Freeze')},{icon:'🔒',t:ar('تشفير AES-256','AES-256 Encryption')},{icon:'💬',t:ar('دعم 24/7','24/7 Support')}]" :key="i" class="sec-card reveal-scale" :style="{transitionDelay: (i * 80) + 'ms'}">
          <div class="text-2xl mb-2">{{ f.icon }}</div>
          <div class="text-[13px] text-[#0B1F3A] font-semibold">{{ f.t }}</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- STATS -->
<section class="stats-bar">
  <div class="max-w-7xl mx-auto px-6 text-center mb-6">
    <p class="text-[#0B1F3A]/50 text-sm font-medium">{{ ar('انضم إلى آلاف المستخدمين','Join thousands of users') }}</p>
  </div>
  <div class="max-w-5xl mx-auto px-6 grid grid-cols-2 md:grid-cols-4 gap-6">
    <div v-for="(s,i) in stats" :key="i" class="text-center py-6 reveal" :style="{transitionDelay: (i * 150) + 'ms'}">
      <div class="text-[clamp(2rem,4vw,3rem)] font-black bg-gradient-to-br from-[#1E5EFF] to-[#00C2FF] bg-clip-text text-transparent">{{ s.prefix || '' }}{{ s.current }}{{ s.suffix }}</div>
      <div class="text-xs text-[#0B1F3A]/55 mt-2 font-semibold">{{ [ar('مستخدم نشط','Active Users'),ar('حجم المعاملات','Transaction Volume'),ar('وقت التشغيل','Uptime'),ar('عملة مدعومة','Currencies')][i] }}</div>
    </div>
  </div>
</section>

<!-- TESTIMONIALS -->
<section class="sec">
  <div class="max-w-7xl mx-auto px-6 text-center mb-12 reveal">
    <h2 class="sec-title">{{ ar('ماذا يقول عملاؤنا','What Our Clients Say') }}</h2>
  </div>
  <div class="max-w-3xl mx-auto px-6">
    <div class="testimonial-card reveal-scale">
      <div class="flex items-center gap-1 mb-4"><span v-for="s in 5" :key="s" class="text-lg">⭐</span></div>
      <p class="text-[#0B1F3A]/70 text-lg leading-relaxed mb-6 italic">"{{ testimonials[activeTestimonial].text }}"</p>
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-full bg-gradient-to-br from-[#1E5EFF] to-[#00C2FF] flex items-center justify-center text-white font-bold text-sm">{{ testimonials[activeTestimonial].name[0] }}</div>
        <div><div class="font-bold text-[#0B1F3A] text-sm">{{ testimonials[activeTestimonial].name }}</div><div class="text-xs text-[#0B1F3A]/40">{{ testimonials[activeTestimonial].role }}</div></div>
      </div>
      <div class="flex justify-center gap-2 mt-6">
        <button v-for="(t,i) in testimonials" :key="i" @click="activeTestimonial=i" class="w-2.5 h-2.5 rounded-full transition-all" :class="activeTestimonial===i ? 'bg-[#1E5EFF] w-6' : 'bg-[#0B1F3A]/15'"></button>
      </div>
    </div>
  </div>
</section>

<!-- PARTNERS -->
<section class="partners-sec">
  <div class="max-w-7xl mx-auto px-6 text-center mb-8">
    <p class="text-[#0B1F3A]/30 text-xs font-semibold tracking-widest uppercase">{{ ar('شركاؤنا وداعمونا','Trusted By') }}</p>
  </div>
  <div class="marquee-wrap">
    <div class="marquee-track">
      <span v-for="p in ['Visa','Mastercard','Apple Pay','Google Pay','Samsung Pay','Swift','Stripe','PayPal','Visa','Mastercard','Apple Pay','Google Pay','Samsung Pay','Swift','Stripe','PayPal']" :key="p+Math.random()" class="marquee-item">{{ p }}</span>
    </div>
  </div>
</section>

<!-- PRICING -->
<section id="pricing" class="pricing-dark">
  <div class="max-w-7xl mx-auto px-6">
    <h2 class="text-[clamp(2rem,4vw,3rem)] font-black text-white mb-12 reveal">{{ ar('اختر خطتك','Choose your plan') }}</h2>
    <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-5 mb-5">
      <div v-for="(p,i) in [
        {n:'Standard',price:ar('مجاني','Free'),desc:ar('كل الأساسيات — حساب رقمي، بطاقة افتراضية، تحويلات محلية، وإدارة أموالك من تطبيق واحد.','The financial basics — everything you need for better money management in one place.')},
        {n:'Plus',price:'3.99€',desc:ar('للمنفق الذكي — حدود أعلى للتحويلات، حماية مشتريات، وتأمين على مشترياتك بسعر معقول.','For the smart spender — access better limits for spending abroad and insurance for your purchases.')},
        {n:'Premium',price:'7.99€',desc:ar('لحياة أفضل كل يوم — صرف عملات غير محدود، اشتراكات حصرية، وأسعار ادخار أفضل.','For elevating every day — access exclusive subscriptions, better savings rates, and unlimited currency exchange.')}
      ]" :key="i" class="plan-card reveal" :style="{transitionDelay: (i * 100) + 'ms'}">
        <h3 class="text-xl font-black text-[#0B1F3A] mb-1">{{ p.n }}</h3>
        <div class="text-lg font-bold text-[#0B1F3A] mb-4">{{ p.price }}<span v-if="!['مجاني','Free'].includes(p.price)" class="text-sm text-[#0B1F3A]/40 font-normal">/{{ ar('شهرياً','month') }}</span></div>
        <p class="text-sm text-[#0B1F3A]/50 leading-relaxed mb-6">{{ p.desc }}</p>
        <Link v-if="canRegister" :href="route('register')" class="plan-arrow">→</Link>
      </div>
    </div>
    <div class="grid sm:grid-cols-2 gap-5">
      <div v-for="(p,i) in [
        {n:'Metal',price:'14.99€',desc:ar('للمسافرين والتجار حول العالم — تأمين سفر شامل، حدود محسّنة، واشتراكات بقيمة 2,100€ سنوياً.','For the global travellers and traders — relax with travel insurance, enjoy enhanced limits, and subscriptions worth €2,100 annually.')},
        {n:'Ultra',price:'45€',desc:ar('لمن يريد الأفضل — صالات مطارات غير محدودة، بيانات دولية شهرية، اشتراكات شركاء، وحماية إلغاء شاملة.','For those seeking the best — get unlimited airport lounge access, monthly global data, partner subscriptions, and cancellation cover.')}
      ]" :key="i" class="plan-card reveal" :style="{transitionDelay: ((i+3) * 100) + 'ms'}">
        <h3 class="text-xl font-black text-[#0B1F3A] mb-1">{{ p.n }}</h3>
        <div class="text-lg font-bold text-[#0B1F3A] mb-4">{{ p.price }}<span class="text-sm text-[#0B1F3A]/40 font-normal">/{{ ar('شهرياً','month') }}</span></div>
        <p class="text-sm text-[#0B1F3A]/50 leading-relaxed mb-6">{{ p.desc }}</p>
        <Link v-if="canRegister" :href="route('register')" class="plan-arrow">→</Link>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="cta-sec">
  <div class="max-w-4xl mx-auto px-6 text-center reveal-scale">
    <h2 class="text-[clamp(2rem,4vw,3rem)] font-black text-[#0B1F3A] mb-5 leading-tight">{{ ar('افتح حسابك اليوم وانضم لمستقبل المصارف الرقمية','Open Your Account Today') }}</h2>
    <p class="text-[#0B1F3A]/40 mb-10 text-lg max-w-xl mx-auto">{{ ar('سجّل خلال دقائق وابدأ رحلتك المصرفية الرقمية مع SDB','Register in minutes and start your journey with SDB') }}</p>
    <Link v-if="canRegister" :href="route('register')" class="btn-blue btn-huge btn-pulse">{{ ar('سجّل الآن','Register Now') }}</Link>
  </div>
</section>

<!-- FOOTER -->
<footer class="ft">
  <div class="max-w-7xl mx-auto px-6">
    <div class="grid md:grid-cols-5 gap-8 mb-12">
      <div class="md:col-span-2">
        <div class="flex items-center gap-2.5 mb-4"><img src="/images/sdb-logo.png" alt="SDB" class="footer-logo" /></div>
        <p class="text-[#0B1F3A]/35 text-xs leading-relaxed max-w-xs">{{ ar('بنك رقمي مرخّص في الدنمارك. خدمات مصرفية مبتكرة بمعايير أوروبية عالمية. حسابات متعددة العملات وبطاقات ذكية.','A licensed digital bank in Denmark. Innovative banking services with European standards. Multi-currency accounts and smart cards.') }}</p>
      </div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('المنتجات','Products') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/35"><li><a href="#salary" class="hover:text-[#1E5EFF] transition-colors">{{ ar('حسابات شخصية','Personal Accounts') }}</a></li><li><a href="#cards" class="hover:text-[#1E5EFF] transition-colors">{{ ar('البطاقات','Cards') }}</a></li><li><a href="#travel" class="hover:text-[#1E5EFF] transition-colors">{{ ar('التحويلات الدولية','International Transfers') }}</a></li><li><Link href="/faq" class="hover:text-[#1E5EFF] transition-colors">{{ ar('الأسئلة الشائعة','FAQ') }}</Link></li></ul></div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('قانوني','Legal') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/35"><li><Link href="/terms" class="hover:text-[#1E5EFF] transition-colors">{{ ar('الشروط والأحكام','Terms') }}</Link></li><li><Link href="/privacy" class="hover:text-[#1E5EFF] transition-colors">{{ ar('سياسة الخصوصية','Privacy') }}</Link></li><li><Link href="/about" class="hover:text-[#1E5EFF] transition-colors">{{ ar('عن البنك','About Us') }}</Link></li><li><Link href="/support" class="hover:text-[#1E5EFF] transition-colors">{{ ar('الدعم','Support') }}</Link></li></ul></div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('تواصل','Contact') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/35"><li>📧 info@sdb-bank.com</li><li>📞 +45 42 80 55 94</li><li>📍 Wimosem 18, 4000 Roskilde</li><li>🇩🇰 Denmark</li></ul></div>
    </div>
    <div class="border-t border-[#0B1F3A]/8 pt-6 flex flex-col md:flex-row items-center justify-between gap-3">
      <p class="text-[#0B1F3A]/25 text-[11px]">© 2026 SDB Bank ApS. {{ ar('جميع الحقوق محفوظة. مسجل في الدنمارك.','All rights reserved. Registered in Denmark.') }}</p>
      <button @click="toggleLang" class="text-[11px] text-[#0B1F3A]/30 hover:text-[#1E5EFF] transition-colors">{{ ar('English','عربي') }}</button>
    </div>
  </div>
</footer>

</div>
</template>

<style>
.font-ar{font-family:'Cairo',sans-serif}
.sdb{font-family:'Inter',sans-serif;background:#fff;color:#0B1F3A}
.rtl{direction:rtl}.ltr{direction:ltr}
html{scroll-behavior:smooth}

/* NAV */
.nav-bar{position:fixed;top:0;left:0;right:0;z-index:50;background:rgba(5,13,26,0.85);backdrop-filter:blur(20px) saturate(1.5);border-bottom:1px solid rgba(30,94,255,0.08)}
.nav-lnk{color:rgba(255,255,255,0.45);font-weight:500;transition:all .3s}.nav-lnk:hover{color:#60A5FA}
.lang-toggle{padding:4px 14px;border-radius:8px;border:1px solid rgba(255,255,255,0.1);color:rgba(255,255,255,0.4);font-size:12px;transition:all .3s}.lang-toggle:hover{border-color:#60A5FA;color:#60A5FA}
.nav-logo{height:120px;width:auto;object-fit:contain;filter:brightness(0) invert(1)}
.card-logo{height:50px;width:auto;object-fit:contain;filter:brightness(2) drop-shadow(0 0 4px rgba(30,94,255,0.3))}
.footer-logo{height:100px;width:auto;object-fit:contain}

/* BUTTONS */
.btn-blue{padding:10px 28px;border-radius:14px;font-weight:700;background:linear-gradient(135deg,#1E5EFF,#3B82F6);color:#fff;box-shadow:0 4px 20px rgba(30,94,255,0.25);transition:all .4s}.btn-blue:hover{transform:translateY(-2px);box-shadow:0 8px 30px rgba(30,94,255,0.35)}
.btn-big{padding:14px 32px;font-size:15px;border-radius:16px}
.btn-huge{padding:18px 48px;font-size:18px;border-radius:20px;box-shadow:0 8px 35px rgba(30,94,255,0.3)}
.btn-outline{display:inline-flex;padding:12px 32px;border-radius:14px;font-weight:600;font-size:14px;color:#1E5EFF;border:2px solid rgba(30,94,255,0.25);transition:all .3s;background:transparent}.btn-outline:hover{background:#1E5EFF;color:#fff;box-shadow:0 4px 20px rgba(30,94,255,0.25)}

/* HERO DARK */
.hero-dark{position:relative;background:linear-gradient(145deg,#050d1a 0%,#0B1F3A 30%,#0a1a30 60%,#040c18 100%);overflow:hidden;min-height:100vh;display:flex;align-items:center}
.hero-glow-1{position:absolute;top:-20%;right:10%;width:600px;height:600px;background:radial-gradient(circle,rgba(30,94,255,0.15),transparent 70%);filter:blur(100px);animation:glowPulse 4s ease-in-out infinite}
.hero-glow-2{position:absolute;bottom:-10%;left:20%;width:400px;height:400px;background:radial-gradient(circle,rgba(0,194,255,0.1),transparent 70%);filter:blur(80px);animation:glowPulse 5s ease-in-out infinite 1s}
@keyframes glowPulse{0%,100%{opacity:0.6;transform:scale(1)}50%{opacity:1;transform:scale(1.1)}}
.hero-grid-bg{position:absolute;inset:0;background-image:linear-gradient(rgba(30,94,255,0.03) 1px,transparent 1px),linear-gradient(90deg,rgba(30,94,255,0.03) 1px,transparent 1px);background-size:60px 60px;mask-image:radial-gradient(ellipse 70% 70% at 50% 50%,black,transparent)}
.hero-tag-dark{display:inline-flex;align-items:center;gap:8px;padding:6px 18px;border-radius:100px;border:1px solid rgba(30,94,255,0.25);background:rgba(30,94,255,0.1);color:#60A5FA;font-size:12px;font-weight:600;margin-bottom:28px;backdrop-filter:blur(10px)}
.tag-dot{width:6px;height:6px;border-radius:50%;background:#00D084;box-shadow:0 0 8px #00D084;animation:pulse 2s infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.4}}

/* PARTICLES */
.particles{position:absolute;inset:0;overflow:hidden;pointer-events:none}
.particle{position:absolute;background:rgba(30,94,255,0.4);border-radius:50%;animation:float linear infinite}
@keyframes float{0%{transform:translateY(0) rotate(0deg);opacity:0}10%{opacity:1}90%{opacity:1}100%{transform:translateY(-100vh) rotate(720deg);opacity:0}}

/* HERO 3D IMAGE */
.hero-3d-img{max-width:500px;width:100%;height:auto;filter:drop-shadow(0 30px 80px rgba(30,94,255,0.3));animation:hero3dFloat 6s ease-in-out infinite}
@keyframes hero3dFloat{0%,100%{transform:translateY(0) rotateY(0deg)}50%{transform:translateY(-20px) rotateY(3deg)}}

/* GLOW BUTTON */
.btn-glow{padding:10px 28px;border-radius:14px;font-weight:700;background:linear-gradient(135deg,#1E5EFF,#3B82F6);color:#fff;box-shadow:0 4px 20px rgba(30,94,255,0.4),0 0 40px rgba(30,94,255,0.15);transition:all .4s}.btn-glow:hover{transform:translateY(-2px);box-shadow:0 8px 30px rgba(30,94,255,0.5),0 0 60px rgba(30,94,255,0.2)}
.btn-glass{display:inline-flex;padding:12px 32px;border-radius:14px;font-weight:600;font-size:14px;color:#fff;border:1px solid rgba(255,255,255,0.15);background:rgba(255,255,255,0.05);backdrop-filter:blur(10px);transition:all .3s}.btn-glass:hover{background:rgba(255,255,255,0.1);border-color:rgba(255,255,255,0.3)}

/* CRYPTO TICKER */
.crypto-ticker{padding:60px 0;background:linear-gradient(180deg,#fff 0%,#f8faff 100%);position:relative}
.crypto-ticker::before{content:'';position:absolute;top:-60px;left:0;right:0;height:60px;background:linear-gradient(180deg,#050d1a,transparent)}
.crypto-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}@media(max-width:768px){.crypto-grid{grid-template-columns:repeat(2,1fr)}}
.crypto-card{display:flex;align-items:center;gap:12px;padding:20px;background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:16px;transition:all .35s}.crypto-card:hover{border-color:rgba(30,94,255,0.2);box-shadow:0 12px 40px rgba(30,94,255,0.08);transform:translateY(-4px)}
.crypto-icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:bold;flex-shrink:0}
.crypto-change{margin-left:auto;padding:4px 10px;border-radius:8px;font-size:12px;font-weight:700}
.crypto-up{background:rgba(0,208,132,0.1);color:#00D084}
.crypto-down{background:rgba(255,59,48,0.1);color:#FF3B30}

/* CARD */
.credit-card{position:relative;width:360px;height:220px;border-radius:20px;background:linear-gradient(145deg,#0B1F3A,#143060,#0f2540);border:1px solid rgba(30,94,255,0.15);box-shadow:0 30px 60px rgba(11,31,58,0.25),0 8px 25px rgba(30,94,255,0.1);transform:rotateY(-6deg) rotateX(4deg);transition:transform .6s;z-index:1}.credit-card:hover{transform:rotateY(0) rotateX(0) scale(1.03)}
.card-gloss{position:absolute;inset:0;border-radius:20px;background:linear-gradient(125deg,transparent 30%,rgba(255,255,255,0.04) 45%,rgba(255,255,255,0.08) 50%,rgba(255,255,255,0.04) 55%,transparent 70%);z-index:2;pointer-events:none}
.card-shadow-ring{position:absolute;width:400px;height:260px;top:50%;left:50%;transform:translate(-50%,-50%);background:radial-gradient(ellipse,rgba(30,94,255,0.1),transparent 65%);filter:blur(40px);z-index:0}
.gold-chip{width:44px;height:34px;border-radius:6px;background:linear-gradient(145deg,#C6A75E,#d4b56c,#b8943f);box-shadow:0 2px 6px rgba(198,167,94,0.3),inset 0 1px 2px rgba(255,255,255,0.3)}
.phone-wrap{flex:1;display:flex;align-items:center;background:rgba(11,31,58,0.03);border:1.5px solid rgba(11,31,58,0.08);border-radius:16px;overflow:hidden;transition:all .3s}.phone-wrap:focus-within{border-color:#1E5EFF;box-shadow:0 0 0 3px rgba(30,94,255,0.08)}
.phone-pre{padding:0 16px;font-size:14px;color:rgba(11,31,58,0.25);font-family:monospace}
.phone-inp{flex:1;background:transparent;padding:14px 16px;color:#0B1F3A;outline:none;font-size:14px}.phone-inp::placeholder{color:rgba(11,31,58,0.2)}

/* SECTIONS - see ENHANCED SECTIONS below */
.sec-title{font-size:clamp(1.8rem,3.5vw,2.6rem);font-weight:900;margin-bottom:14px;color:#0B1F3A}
.sec-desc{color:rgba(11,31,58,0.6);max-width:560px;margin:0 auto;font-size:15px;line-height:1.7}

/* FEATURE CARDS */
.fcard{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:20px;padding:28px;transition:all .35s}.fcard:hover{border-color:rgba(30,94,255,0.2);box-shadow:0 12px 40px rgba(30,94,255,0.08);transform:translateY(-4px)}
.fcard-icon{width:52px;height:52px;border-radius:16px;background:linear-gradient(135deg,#EEF2FF,#DBEAFE);display:flex;align-items:center;justify-content:center;font-size:24px;margin-bottom:14px;transition:transform .3s}.fcard:hover .fcard-icon{transform:scale(1.1)}
.sec-card{background:rgba(30,94,255,0.02);border:1.5px solid rgba(11,31,58,0.06);border-radius:20px;padding:28px;text-align:center;transition:all .3s}.sec-card:hover{border-color:rgba(30,94,255,0.2);transform:translateY(-3px);box-shadow:0 10px 30px rgba(30,94,255,0.06)}
.pill{padding:8px 18px;background:rgba(30,94,255,0.05);border:1px solid rgba(30,94,255,0.15);border-radius:100px;font-size:12px;color:rgba(11,31,58,0.55);font-weight:500;transition:all .3s}.pill:hover{border-color:#1E5EFF;color:#1E5EFF}

/* REALISTIC BANK CARDS */
.card-tier-wrap{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:20px;padding:24px;transition:all .35s}.card-tier-wrap:hover{border-color:rgba(30,94,255,0.15);box-shadow:0 12px 40px rgba(30,94,255,0.08);transform:translateY(-4px)}
.real-card-wrap{perspective:800px;overflow:visible}
.real-card-img{width:100%;height:auto;border-radius:14px;box-shadow:0 10px 30px rgba(0,0,0,0.2),0 4px 12px rgba(0,0,0,0.1);transition:transform .5s cubic-bezier(.16,1,.3,1)}.real-card-img:hover{transform:perspective(800px) rotateY(-8deg) rotateX(4deg) scale(1.04)}
.bk-shine{position:absolute;inset:0;background:linear-gradient(125deg,transparent 20%,rgba(255,255,255,0.06) 40%,rgba(255,255,255,0.12) 50%,rgba(255,255,255,0.06) 60%,transparent 80%);z-index:2;pointer-events:none}
.bk-inner{position:relative;z-index:1;display:flex;flex-direction:column;justify-content:space-between;height:100%;padding:16px 18px}
.bk-chip{width:32px;height:24px;border-radius:4px;background:linear-gradient(145deg,#C6A75E,#d4b56c,#b8943f);box-shadow:0 1px 4px rgba(198,167,94,0.3),inset 0 1px 2px rgba(255,255,255,0.3);margin-top:8px;position:relative;overflow:hidden}.bk-chip::after{content:'';position:absolute;inset:3px;border:1px solid rgba(0,0,0,0.1);border-radius:2px}
.bk-standard{background:linear-gradient(145deg,#0B1F3A 0%,#143060 40%,#1a3d70 70%,#0f2540 100%)}
.bk-plus{background:linear-gradient(145deg,#1047b8 0%,#1E5EFF 30%,#3B82F6 60%,#1a50d1 100%)}
.bk-premium{background:linear-gradient(145deg,#4c1d95 0%,#6d28d9 30%,#8b5cf6 65%,#5b21b6 100%)}
.bk-elite{background:linear-gradient(145deg,#0a0a0a 0%,#1a1a1a 30%,#2a2a2a 60%,#111 100%)}.bk-elite .bk-chip{box-shadow:0 1px 6px rgba(198,167,94,0.5),0 0 15px rgba(198,167,94,0.15),inset 0 1px 2px rgba(255,255,255,0.3)}.bk-elite::before{content:'';position:absolute;top:0;left:0;right:0;bottom:0;border:1px solid rgba(198,167,94,0.15);border-radius:14px;z-index:3;pointer-events:none}

/* ENHANCED SECTIONS */
.sec{padding:100px 0;position:relative;background:#fff;overflow:hidden}
.sec-blue-bg{position:absolute;top:0;left:50%;transform:translateX(-50%);width:80%;height:100%;background:radial-gradient(ellipse,rgba(30,94,255,0.03),transparent 70%);pointer-events:none}
.sec:nth-child(even)::before{content:'';position:absolute;top:0;left:0;right:0;bottom:0;background:linear-gradient(180deg,rgba(30,94,255,0.01) 0%,rgba(30,94,255,0.03) 50%,rgba(30,94,255,0.01) 100%);pointer-events:none}

/* STATS */
.stats-bar{padding:80px 0;background:linear-gradient(180deg,rgba(30,94,255,0.02),rgba(30,94,255,0.05),rgba(30,94,255,0.02))}

/* PRICING - DARK */
.pricing-dark{padding:100px 0;background:#0B1F3A}
.plan-card{background:#fff;border-radius:20px;padding:32px;transition:all .35s;display:flex;flex-direction:column}.plan-card:hover{transform:translateY(-4px);box-shadow:0 15px 40px rgba(0,0,0,0.2)}
.plan-arrow{display:inline-flex;align-items:center;justify-content:center;width:40px;height:40px;border-radius:50%;background:rgba(11,31,58,0.05);color:#0B1F3A;font-size:18px;transition:all .3s;margin-top:auto;align-self:flex-end}.plan-arrow:hover{background:#1E5EFF;color:#fff;transform:translateX(4px)}

/* CTA */
.cta-sec{padding:120px 0;background:linear-gradient(180deg,rgba(30,94,255,0.03),rgba(0,194,255,0.05),rgba(30,94,255,0.03))}

/* FOOTER */
.ft{padding:60px 0 32px;background:#FAFBFC;border-top:1px solid rgba(11,31,58,0.06)}

/* NAV ACTIVE */
.nav-active{color:#1E5EFF !important;position:relative}.nav-active::after{content:'';position:absolute;bottom:-4px;left:0;right:0;height:2px;background:#1E5EFF;border-radius:2px}

/* MOBILE MENU */
.mob-menu{padding:16px 24px;background:rgba(255,255,255,0.98);border-top:1px solid rgba(11,31,58,0.06);animation:slideDown .3s ease}
.mob-link{display:block;padding:12px 0;color:rgba(11,31,58,0.6);font-size:14px;font-weight:500;border-bottom:1px solid rgba(11,31,58,0.04);transition:color .2s}.mob-link:hover{color:#1E5EFF}
@keyframes slideDown{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}

/* STEP CARDS */
.step-card{text-align:center;padding:32px 24px;border-radius:20px;background:#fff;border:1.5px solid rgba(11,31,58,0.06);position:relative;transition:all .35s}.step-card:hover{border-color:rgba(30,94,255,0.2);box-shadow:0 12px 40px rgba(30,94,255,0.08);transform:translateY(-4px)}
.step-num{font-size:48px;font-weight:900;background:linear-gradient(135deg,rgba(30,94,255,0.08),rgba(0,194,255,0.08));-webkit-background-clip:text;-webkit-text-fill-color:transparent;margin-bottom:8px;line-height:1}
.step-icon{font-size:36px;margin-bottom:16px}
.step-arrow{position:absolute;top:50%;right:-24px;font-size:20px;color:rgba(30,94,255,0.3);font-weight:bold;display:none}@media(min-width:768px){.step-arrow{display:block}}

/* TESTIMONIALS */
.testimonial-card{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:24px;padding:40px;text-align:center;box-shadow:0 4px 40px rgba(30,94,255,0.04)}

/* PARTNERS MARQUEE */
.partners-sec{padding:40px 0 60px;overflow:hidden}
.marquee-wrap{overflow:hidden;mask-image:linear-gradient(90deg,transparent,black 10%,black 90%,transparent)}
.marquee-track{display:flex;gap:48px;animation:marquee 20s linear infinite;width:max-content}
.marquee-item{font-size:18px;font-weight:800;color:rgba(11,31,58,0.12);white-space:nowrap;letter-spacing:0.05em}
@keyframes marquee{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}

::-webkit-scrollbar{width:4px}::-webkit-scrollbar-track{background:#fff}::-webkit-scrollbar-thumb{background:linear-gradient(#1E5EFF,#00C2FF);border-radius:4px}

/* SCROLL REVEAL */
.reveal{opacity:0;transform:translateY(40px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}
.reveal.revealed{opacity:1;transform:translateY(0)}
.reveal-left{opacity:0;transform:translateX(-50px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}
.reveal-left.revealed{opacity:1;transform:translateX(0)}
.reveal-right{opacity:0;transform:translateX(50px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}
.reveal-right.revealed{opacity:1;transform:translateX(0)}
.reveal-scale{opacity:0;transform:scale(0.9);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}
.reveal-scale.revealed{opacity:1;transform:scale(1)}

/* CARD FLOAT */
.credit-card{animation:cardFloat 6s ease-in-out infinite}
@keyframes cardFloat{0%,100%{transform:rotateY(-6deg) rotateX(4deg) translateY(0)}50%{transform:rotateY(-6deg) rotateX(4deg) translateY(-12px)}}
.credit-card:hover{animation:none}

/* BUTTON PULSE */
.btn-pulse{animation:btnPulse 2.5s ease-in-out infinite}
@keyframes btnPulse{0%,100%{box-shadow:0 8px 35px rgba(30,94,255,0.3)}50%{box-shadow:0 8px 50px rgba(30,94,255,0.5),0 0 20px rgba(30,94,255,0.15)}}
.btn-pulse:hover{animation:none}

/* ICON BOUNCE ON REVEAL */
.revealed .fcard-icon{animation:iconBounce .5s cubic-bezier(.16,1,.3,1) forwards}
@keyframes iconBounce{0%{transform:scale(0.5);opacity:0}60%{transform:scale(1.15)}100%{transform:scale(1);opacity:1}}

/* HERO PHONE IMAGE (legacy) */
.hero-phone-img{max-width:420px;width:100%;height:auto;filter:drop-shadow(0 30px 60px rgba(11,31,58,0.15));animation:phoneFloat 6s ease-in-out infinite}
@keyframes phoneFloat{0%,100%{transform:translateY(0)}50%{transform:translateY(-15px)}}

/* SECTION IMAGES */
.section-img{width:100%;height:auto;border-radius:16px;filter:drop-shadow(0 20px 40px rgba(11,31,58,0.1))}

/* DARK TRAVEL SECTION */
.sec-dark{background:linear-gradient(145deg,#0B1F3A 0%,#0f2d52 40%,#0B1F3A 100%);padding:120px 0;overflow:hidden}
.sec-dark::before{content:'';position:absolute;top:0;left:0;right:0;bottom:0;background:url('/images/world-map.png') center/contain no-repeat;opacity:0.03;pointer-events:none}
.travel-stat{background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.08);border-radius:16px;padding:20px;text-align:center;transition:all .3s}
.travel-stat:hover{background:rgba(255,255,255,0.08);border-color:rgba(30,94,255,0.3)}

/* FEATURE LIST WITH CHECKMARKS */
.feature-list{display:flex;flex-direction:column;gap:12px;margin-bottom:8px}
.feature-item{display:flex;align-items:center;gap:10px}

/* SECTION TAG */
.sec-tag{display:inline-flex;padding:6px 16px;border-radius:100px;background:rgba(30,94,255,0.08);color:#1E5EFF;font-size:12px;font-weight:700;margin-bottom:16px;letter-spacing:0.02em}
.sec-tag-light{background:rgba(255,255,255,0.1);color:rgba(255,255,255,0.7)}
</style>
