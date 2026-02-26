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
      <Link v-if="canLogin" :href="route('login')" class="text-[#0B1F3A]/60 hover:text-[#1E5EFF] text-sm px-4 py-2 transition-colors font-medium">{{ ar('تسجيل الدخول','Login') }}</Link>
      <Link v-if="canRegister" :href="route('register')" class="btn-blue text-sm">{{ ar('فتح حساب','Open Account') }}</Link>
    </div>
    <button @click="mobileMenuOpen=!mobileMenuOpen" class="md:hidden text-[#0B1F3A]"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg></button>
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
<section class="hero-white">
  <div class="hero-blob-1"></div>
  <div class="hero-blob-2"></div>
  <div class="relative max-w-7xl mx-auto px-6 grid md:grid-cols-2 gap-16 items-center pt-36 pb-24 md:pt-44 md:pb-32">
    <div :class="isAr ? 'text-right' : ''" class="reveal">
      <div class="hero-tag"><span class="tag-dot"></span>Banking. Reimagined.</div>
      <h1 class="text-[clamp(2.4rem,5vw,3.6rem)] font-black leading-[1.08] text-[#0B1F3A] mb-6">{{ ar('أدر أموالك بطريقة ذكية مع','Manage Your Money Smarter with') }} <span class="bg-gradient-to-r from-[#1E5EFF] to-[#00C2FF] bg-clip-text text-transparent">SDB</span></h1>
      <p class="text-[#0B1F3A]/50 text-[17px] leading-relaxed mb-10 max-w-lg">{{ ar('افتح حسابك الرقمي خلال دقائق، بدّل بين العملات بسهولة، وتحكم الكامل ببطاقاتك من تطبيق واحد آمن.','Open your digital account in minutes, switch currencies easily, and fully control your cards from one secure app.') }}</p>
      <div class="flex items-center gap-3 mb-3 max-w-md">
        <div class="phone-wrap"><span class="phone-pre">963+</span><input v-model="phone" type="tel" :placeholder="ar('رقم هاتفك','Your phone')" class="phone-inp" /></div>
        <Link v-if="canRegister" :href="route('register')" class="btn-blue btn-big whitespace-nowrap">{{ ar('ابدأ الآن','Start Now') }}</Link>
      </div>
      <p class="text-[11px] text-[#0B1F3A]/25">{{ ar('يجب أن يكون عمرك 18 عاماً على الأقل.','You must be at least 18 years old.') }}</p>
    </div>
    <!-- CARD -->
    <div class="flex justify-center reveal-scale" style="perspective:1200px" @mousemove="handleCardMove" @mouseleave="handleCardLeave">
      <div class="card-shadow-ring"></div>
      <div class="credit-card" ref="cardRef">
        <div class="card-gloss"></div>
        <div class="relative z-10 flex flex-col justify-between h-full p-7">
          <div class="flex justify-between items-start"><img src="/images/sdb-logo.png" alt="SDB" class="card-logo" /><div class="flex"><div class="w-6 h-6 rounded-full bg-[#EB001B]/80"></div><div class="w-6 h-6 rounded-full bg-[#F79E1B]/70 -ml-2.5"></div></div></div>
          <div class="gold-chip"></div>
          <div class="font-mono text-xl tracking-[0.3em] text-white/80">•••• •••• •••• 4821</div>
          <div class="flex justify-between"><div><div class="text-[7px] text-white/30 uppercase tracking-widest mb-0.5">Card Holder</div><div class="text-white/90 text-[13px] font-semibold">AHMAD MOHAMMAD</div></div><div class="text-right"><div class="text-[7px] text-white/30 uppercase tracking-widest mb-0.5">Expires</div><div class="text-white/90 text-[13px] font-semibold">12/28</div></div></div>
        </div>
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
      <p class="text-sm text-[#0B1F3A]/40 leading-relaxed">{{ step.d }}</p>
      <div v-if="i<2" class="step-arrow">→</div>
    </div>
  </div>
</section>

<!-- SALARY -->
<section id="salary" class="sec">
  <div class="sec-blue-bg"></div>
  <div class="relative max-w-7xl mx-auto px-6 text-center mb-16 reveal">
    <h2 class="sec-title">{{ ar('راتبك في مكان واحد — وتحكم كامل','Your Salary in One Place — Full Control') }}</h2>
    <p class="sec-desc">{{ ar('تحويلات فورية، تقسيم تلقائي للراتب، ادخار ذكي، وتحليل مصاريف لحظي.','Instant transfers, auto salary split, smart savings, and real-time expense analysis.') }}</p>
  </div>
  <div class="relative max-w-5xl mx-auto px-6 grid sm:grid-cols-2 lg:grid-cols-4 gap-5">
    <div v-for="(f,i) in [{icon:'💰',t:ar('استقبال الراتب','Salary Receipt'),d:ar('إيداع مباشر لراتبك','Direct deposit')},{icon:'📊',t:ar('تقسيم تلقائي','Auto Split'),d:ar('مصاريف / ادخار / استثمار','Spend / Save / Invest')},{icon:'🔔',t:ar('إشعارات لحظية','Instant Alerts'),d:ar('تنبيه فوري لكل حركة','Real-time alerts')},{icon:'📈',t:ar('متابعة ذكية','Smart Tracking'),d:ar('تحليل مصاريف شهري','Monthly analysis')}]" :key="i" class="fcard reveal" :style="{transitionDelay: (i * 100) + 'ms'}">
      <div class="fcard-icon">{{ f.icon }}</div>
      <h3 class="font-bold text-[15px] text-[#0B1F3A] mb-1">{{ f.t }}</h3>
      <p class="text-sm text-[#0B1F3A]/40">{{ f.d }}</p>
    </div>
  </div>
  <div class="text-center mt-10"><Link v-if="canRegister" :href="route('register')" class="btn-outline">{{ ar('حوّل راتبك إلى SDB','Transfer Your Salary to SDB') }} →</Link></div>
</section>

<!-- CARDS -->
<section id="cards" class="sec">
  <div class="relative max-w-7xl mx-auto px-6 text-center mb-16 reveal">
    <h2 class="sec-title">{{ ar('بطاقات تناسب أسلوب حياتك','Cards That Fit Your Lifestyle') }}</h2>
    <p class="sec-desc">{{ ar('بطاقات رقمية ومعدنية بتصميم فاخر، إشعارات فورية، وإدارة كاملة للأمان.','Digital and metal cards with premium design and full security management.') }}</p>
  </div>
  <div class="max-w-6xl mx-auto px-6 grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
    <div v-for="(c,i) in [
      {n:'Standard',sub:ar('مجاني','Free'),cls:'bk-standard',tc:'text-[#0B1F3A]',feats:ar(['بطاقة افتراضية','إشعارات فورية','تحويلات محلية','حد سحب 500$'],['Virtual card','Alerts','Local transfers','$500 limit'])},
      {n:'Plus',sub:'5$/mo',cls:'bk-plus',tc:'text-[#1E5EFF]',feats:ar(['حدود مضاعفة','حماية مشتريات','Google & Apple Pay','دعم أولوية'],['Double limits','Purchase protection','Google & Apple Pay','Priority'])},
      {n:'Premium',sub:'12$/mo',cls:'bk-premium',tc:'text-violet-600',feats:ar(['صرف غير محدود','تأمين سفر','بيانات eSIM','3x Lounge'],['Unlimited FX','Travel insurance','eSIM','3x Lounge'])},
      {n:'Elite',sub:'25$/mo',cls:'bk-elite',tc:'text-[#C6A75E]',feats:ar(['Lounge غير محدود','مدير حساب خاص','مزايا VIP','استرداد نقدي'],['Unlimited Lounge','Dedicated manager','VIP perks','Cashback'])}
    ]" :key="i" class="card-tier-wrap reveal" :style="{transitionDelay: (i * 120) + 'ms'}">
      <div class="bk-card" :class="c.cls">
        <div class="bk-shine"></div>
        <div class="bk-inner">
          <div class="flex justify-between items-start"><img src="/images/sdb-logo.png" alt="SDB" class="h-4 w-auto opacity-70" /><span class="text-[7px] text-white/35 font-bold tracking-[0.2em]">{{ c.n.toUpperCase() }}</span></div>
          <div class="bk-chip"></div>
          <div class="font-mono text-[11px] tracking-[0.18em] text-white/60 mt-1.5">•••• •••• •••• 4821</div>
          <div class="flex justify-between items-end mt-auto"><div><div class="text-[5px] text-white/20 uppercase tracking-widest">HOLDER</div><div class="text-white/75 text-[9px] font-semibold">AHMAD M.</div></div><div class="text-right"><div class="text-[5px] text-white/20 uppercase tracking-widest">VALID</div><div class="text-white/75 text-[9px] font-semibold">12/28</div></div><div class="flex"><div class="w-3.5 h-3.5 rounded-full bg-[#EB001B]/80"></div><div class="w-3.5 h-3.5 rounded-full bg-[#F79E1B]/70 -ml-1.5"></div></div></div>
        </div>
      </div>
      <div class="text-xl font-black mt-5 mb-3" :class="c.tc">{{ c.sub }}</div>
      <ul class="space-y-2"><li v-for="f in c.feats" :key="f" class="text-[13px] text-[#0B1F3A]/40 flex items-center gap-2"><span class="w-1.5 h-1.5 rounded-full bg-[#1E5EFF]/40 flex-shrink-0"></span>{{ f }}</li></ul>
    </div>
  </div>
  <div class="max-w-4xl mx-auto px-6 mt-8 flex flex-wrap justify-center gap-3">
    <span v-for="f in ar(['Google Pay','Apple Pay','تجميد فوري','CVV متغير','بطاقة افتراضية'],['Google Pay','Apple Pay','Instant freeze','Dynamic CVV','Virtual card'])" :key="f" class="pill">{{ f }}</span>
  </div>
</section>

<!-- TRAVEL -->
<section id="travel" class="sec">
  <div class="sec-blue-bg" style="top:auto;bottom:0"></div>
  <div class="relative max-w-7xl mx-auto px-6 text-center mb-16 reveal">
    <h2 class="sec-title">{{ ar('سافر بثقة مع SDB','Travel with Confidence') }}</h2>
  </div>
  <div class="relative max-w-5xl mx-auto px-6 grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
    <div v-for="(f,i) in [{icon:'🌍',t:ar('دعم SYP – USD – EUR','SYP – USD – EUR'),d:ar('صرف مباشر بأسعار تنافسية','Competitive exchange')},{icon:'⚡',t:ar('تحويل دولي سريع','Fast Intl Transfer'),d:ar('أرسل واستقبل بسرعة','Send & receive fast')},{icon:'💳',t:ar('استخدام عالمي','Global Card Use'),d:ar('ادفع في أي دولة','Pay anywhere')},{icon:'🛋',t:ar('صالات مطارات','Airport Lounges'),d:ar('دخول مجاني لـ Elite','Free for Elite')},{icon:'📶',t:ar('بيانات eSIM','eSIM Data'),d:ar('إنترنت في 100+ دولة','100+ countries')},{icon:'🛡',t:ar('تأمين سفر','Travel Insurance'),d:ar('تغطية شاملة','Full coverage')}]" :key="i" class="fcard reveal" :style="{transitionDelay: (i * 100) + 'ms'}">
      <div class="fcard-icon">{{ f.icon }}</div>
      <h3 class="font-bold text-[15px] text-[#0B1F3A] mb-1">{{ f.t }}</h3>
      <p class="text-sm text-[#0B1F3A]/40">{{ f.d }}</p>
    </div>
  </div>
</section>

<!-- SECURITY -->
<section id="security" class="sec">
  <div class="relative max-w-7xl mx-auto px-6 text-center mb-16 reveal">
    <h2 class="sec-title">{{ ar('أموالك محمية 24/7','Your Money Protected 24/7') }}</h2>
  </div>
  <div class="max-w-4xl mx-auto px-6 grid grid-cols-2 sm:grid-cols-3 gap-4">
    <div v-for="(f,i) in [{icon:'🔐',t:ar('Face ID / بصمة','Face ID / Touch ID')},{icon:'🔑',t:ar('OTP متقدم','Advanced OTP')},{icon:'💳',t:ar('بطاقات متجددة','Auto-rotating Cards')},{icon:'🤖',t:ar('كشف احتيال AI','AI Fraud Detection')},{icon:'❄️',t:ar('تجميد فوري','Instant Freeze')},{icon:'💬',t:ar('دعم 24/7','24/7 Support')}]" :key="i" class="sec-card reveal-scale" :style="{transitionDelay: (i * 80) + 'ms'}">
      <div class="text-3xl mb-3">{{ f.icon }}</div>
      <div class="text-[13px] text-[#0B1F3A] font-semibold">{{ f.t }}</div>
    </div>
  </div>
</section>

<!-- STATS -->
<section class="stats-bar">
  <div class="max-w-7xl mx-auto px-6 text-center mb-6">
    <p class="text-[#0B1F3A]/35 text-sm font-medium">{{ ar('انضم إلى آلاف المستخدمين','Join thousands of users') }}</p>
  </div>
  <div class="max-w-5xl mx-auto px-6 grid grid-cols-2 md:grid-cols-4 gap-6">
    <div v-for="(s,i) in stats" :key="i" class="text-center py-6 reveal" :style="{transitionDelay: (i * 150) + 'ms'}">
      <div class="text-[clamp(2rem,4vw,3rem)] font-black bg-gradient-to-br from-[#1E5EFF] to-[#00C2FF] bg-clip-text text-transparent">{{ s.prefix || '' }}{{ s.current }}{{ s.suffix }}</div>
      <div class="text-xs text-[#1E5EFF]/40 mt-2 font-semibold">{{ [ar('مستخدم','Users'),ar('معاملات','Volume'),ar('استقرار','Uptime'),ar('شراكة','Partners')][i] }}</div>
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
<section id="pricing" class="sec">
  <div class="relative max-w-7xl mx-auto px-6 text-center mb-16 reveal">
    <h2 class="sec-title">{{ ar('اختر خطتك','Choose Your Plan') }}</h2>
  </div>
  <div class="max-w-5xl mx-auto px-6 grid sm:grid-cols-2 lg:grid-cols-4 gap-5">
    <div v-for="(p,i) in [
      {n:'Standard',price:ar('مجاني','Free'),nc:'text-[#0B1F3A]',pc:'text-[#0B1F3A]',bc:'btn-light',feats:ar(['حساب أساسي','بطاقة افتراضية','تحويلات محلية','إشعارات'],['Basic account','Virtual card','Local transfers','Alerts'])},
      {n:'Plus',price:'5$',nc:'text-[#1E5EFF]',pc:'text-[#0B1F3A]',bc:'btn-pop',pop:true,feats:ar(['كل مزايا Standard','حدود أعلى','حماية مشتريات','دعم أولوية'],['All Standard +','Higher limits','Purchase protection','Priority'])},
      {n:'Premium',price:'12$',nc:'text-violet-600',pc:'text-[#0B1F3A]',bc:'btn-prem',feats:ar(['كل مزايا Plus','صرف غير محدود','تأمين سفر','eSIM'],['All Plus +','Unlimited FX','Travel insurance','eSIM'])},
      {n:'Elite',price:'25$',nc:'text-[#C6A75E]',pc:'text-[#C6A75E]',bc:'btn-elite',feats:ar(['كل مزايا Premium','Lounge غير محدود','مدير خاص','VIP + استرداد'],['All Premium +','Unlimited Lounge','Manager','VIP + Cashback'])}
    ]" :key="i" class="pcard reveal" :class="p.pop ? 'pcard-pop' : ''" :style="{transitionDelay: (i * 120) + 'ms'}">
      <div v-if="p.pop" class="pop-tag">{{ ar('الأكثر طلباً','Popular') }}</div>
      <h3 class="font-black text-lg mb-1" :class="p.nc">{{ p.n }}</h3>
      <div class="text-3xl font-black mb-5" :class="p.pc">{{ p.price }}<span v-if="p.price!==ar('مجاني','Free')" class="text-sm text-[#0B1F3A]/30 font-normal">/{{ ar('شهرياً','mo') }}</span></div>
      <ul class="space-y-3 mb-6"><li v-for="f in p.feats" :key="f" class="text-[13px] text-[#0B1F3A]/45 flex items-center gap-2"><svg class="w-4 h-4 flex-shrink-0 text-[#00D084]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/></svg>{{ f }}</li></ul>
      <Link v-if="canRegister" :href="route('register')" class="pricing-btn" :class="p.bc">{{ ar('ابدأ الآن','Get Started') }}</Link>
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
        <p class="text-[#0B1F3A]/35 text-xs leading-relaxed max-w-xs">{{ ar('البنك الرقمي الأول في سوريا. خدمات مصرفية مبتكرة بمعايير عالمية.','The first digital bank in Syria.') }}</p>
      </div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('المنتجات','Products') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/35"><li><a href="#" class="hover:text-[#1E5EFF] transition-colors">{{ ar('حسابات شخصية','Personal') }}</a></li><li><a href="#cards" class="hover:text-[#1E5EFF] transition-colors">{{ ar('البطاقات','Cards') }}</a></li><li><a href="#" class="hover:text-[#1E5EFF] transition-colors">{{ ar('حسابات الشركات','Business') }}</a></li><li><a href="#travel" class="hover:text-[#1E5EFF] transition-colors">{{ ar('التحويلات','Transfers') }}</a></li></ul></div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('قانوني','Legal') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/35"><li><a href="#" class="hover:text-[#1E5EFF] transition-colors">{{ ar('الشروط','Terms') }}</a></li><li><a href="#" class="hover:text-[#1E5EFF] transition-colors">{{ ar('الخصوصية','Privacy') }}</a></li><li><a href="#" class="hover:text-[#1E5EFF] transition-colors">{{ ar('مكافحة غسل الأموال','AML') }}</a></li><li><a href="#" class="hover:text-[#1E5EFF] transition-colors">{{ ar('التراخيص','Licenses') }}</a></li></ul></div>
      <div><h4 class="text-sm font-bold text-[#0B1F3A] mb-4">{{ ar('تواصل','Contact') }}</h4><ul class="space-y-2.5 text-xs text-[#0B1F3A]/35"><li>📧 info@sdb.sy</li><li>📞 +963 11 000 0000</li><li>📍 {{ ar('دمشق، سوريا','Damascus, Syria') }}</li></ul></div>
    </div>
    <div class="border-t border-[#0B1F3A]/8 pt-6 flex flex-col md:flex-row items-center justify-between gap-3">
      <p class="text-[#0B1F3A]/25 text-[11px]">© 2026 Syria Digital Bank (SDB). {{ ar('جميع الحقوق محفوظة.','All rights reserved.') }}</p>
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
.nav-bar{position:fixed;top:0;left:0;right:0;z-index:50;background:rgba(255,255,255,0.85);backdrop-filter:blur(20px) saturate(1.5);border-bottom:1px solid rgba(11,31,58,0.06)}
.nav-lnk{color:rgba(11,31,58,0.45);font-weight:500;transition:all .3s}.nav-lnk:hover{color:#1E5EFF}
.lang-toggle{padding:4px 14px;border-radius:8px;border:1px solid rgba(11,31,58,0.1);color:rgba(11,31,58,0.4);font-size:12px;transition:all .3s}.lang-toggle:hover{border-color:#1E5EFF;color:#1E5EFF}
.nav-logo{height:120px;width:auto;object-fit:contain}
.card-logo{height:50px;width:auto;object-fit:contain;filter:brightness(2) drop-shadow(0 0 4px rgba(30,94,255,0.3))}
.footer-logo{height:100px;width:auto;object-fit:contain}

/* BUTTONS */
.btn-blue{padding:10px 28px;border-radius:14px;font-weight:700;background:linear-gradient(135deg,#1E5EFF,#3B82F6);color:#fff;box-shadow:0 4px 20px rgba(30,94,255,0.25);transition:all .4s}.btn-blue:hover{transform:translateY(-2px);box-shadow:0 8px 30px rgba(30,94,255,0.35)}
.btn-big{padding:14px 32px;font-size:15px;border-radius:16px}
.btn-huge{padding:18px 48px;font-size:18px;border-radius:20px;box-shadow:0 8px 35px rgba(30,94,255,0.3)}
.btn-outline{display:inline-flex;padding:12px 32px;border-radius:14px;font-weight:600;font-size:14px;color:#1E5EFF;border:2px solid rgba(30,94,255,0.25);transition:all .3s;background:transparent}.btn-outline:hover{background:#1E5EFF;color:#fff;box-shadow:0 4px 20px rgba(30,94,255,0.25)}

/* HERO */
.hero-white{position:relative;background:#fff;overflow:hidden;min-height:100vh;display:flex;align-items:center}
.hero-blob-1{position:absolute;top:0;right:0;width:60%;height:100%;background:linear-gradient(160deg,rgba(30,94,255,0.04) 0%,rgba(0,194,255,0.06) 40%,rgba(30,94,255,0.03) 70%,transparent 100%);border-radius:0 0 0 40%}
.hero-blob-2{position:absolute;bottom:-20%;left:10%;width:500px;height:500px;background:radial-gradient(circle,rgba(30,94,255,0.05),transparent 70%);filter:blur(80px)}
.hero-tag{display:inline-flex;align-items:center;gap:8px;padding:6px 18px;border-radius:100px;border:1px solid rgba(30,94,255,0.15);background:rgba(30,94,255,0.04);color:#1E5EFF;font-size:12px;font-weight:600;margin-bottom:28px}
.tag-dot{width:6px;height:6px;border-radius:50%;background:#00D084;box-shadow:0 0 8px #00D084;animation:pulse 2s infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.4}}

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
.sec-desc{color:rgba(11,31,58,0.4);max-width:560px;margin:0 auto;font-size:15px;line-height:1.7}

/* FEATURE CARDS */
.fcard{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:20px;padding:28px;transition:all .35s}.fcard:hover{border-color:rgba(30,94,255,0.2);box-shadow:0 12px 40px rgba(30,94,255,0.08);transform:translateY(-4px)}
.fcard-icon{width:52px;height:52px;border-radius:16px;background:linear-gradient(135deg,#EEF2FF,#DBEAFE);display:flex;align-items:center;justify-content:center;font-size:24px;margin-bottom:14px;transition:transform .3s}.fcard:hover .fcard-icon{transform:scale(1.1)}
.sec-card{background:rgba(30,94,255,0.02);border:1.5px solid rgba(11,31,58,0.06);border-radius:20px;padding:28px;text-align:center;transition:all .3s}.sec-card:hover{border-color:rgba(30,94,255,0.2);transform:translateY(-3px);box-shadow:0 10px 30px rgba(30,94,255,0.06)}
.pill{padding:8px 18px;background:rgba(30,94,255,0.04);border:1px solid rgba(30,94,255,0.1);border-radius:100px;font-size:12px;color:rgba(11,31,58,0.4);transition:all .3s}.pill:hover{border-color:#1E5EFF;color:#1E5EFF}

/* REALISTIC BANK CARDS */
.card-tier-wrap{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:20px;padding:24px;transition:all .35s}.card-tier-wrap:hover{border-color:rgba(30,94,255,0.15);box-shadow:0 12px 40px rgba(30,94,255,0.08);transform:translateY(-4px)}
.bk-card{position:relative;width:100%;aspect-ratio:1.586;border-radius:14px;overflow:hidden;box-shadow:0 10px 30px rgba(0,0,0,0.2),0 4px 12px rgba(0,0,0,0.1);transition:transform .5s cubic-bezier(.16,1,.3,1)}.bk-card:hover{transform:perspective(800px) rotateY(-8deg) rotateX(4deg) scale(1.04)}
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

/* PRICING */
.pcard{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:22px;padding:28px;transition:all .35s;position:relative}.pcard:hover{transform:translateY(-4px);box-shadow:0 15px 40px rgba(30,94,255,0.08)}
.pcard-pop{border-color:rgba(30,94,255,0.25);box-shadow:0 4px 20px rgba(30,94,255,0.08)}
.pop-tag{position:absolute;top:-12px;left:50%;transform:translateX(-50%);padding:4px 16px;background:linear-gradient(135deg,#1E5EFF,#3B82F6);border-radius:100px;font-size:11px;font-weight:700;color:#fff;box-shadow:0 4px 12px rgba(30,94,255,0.25);white-space:nowrap}
.pricing-btn{display:block;text-align:center;padding:12px;border-radius:14px;font-size:14px;font-weight:700;transition:all .3s}
.btn-light{background:#F3F4F6;color:#374151}.btn-light:hover{background:#E5E7EB}
.btn-pop{background:linear-gradient(135deg,#1E5EFF,#3B82F6);color:#fff;box-shadow:0 4px 15px rgba(30,94,255,0.2)}.btn-pop:hover{box-shadow:0 8px 25px rgba(30,94,255,0.3)}
.btn-prem{background:linear-gradient(135deg,#6d28d9,#8b5cf6);color:#fff}.btn-prem:hover{box-shadow:0 4px 15px rgba(109,40,217,0.25)}
.btn-elite{background:linear-gradient(135deg,#C6A75E,#d4b56c);color:#0B1F3A;font-weight:800}.btn-elite:hover{box-shadow:0 4px 15px rgba(198,167,94,0.3)}

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
</style>
