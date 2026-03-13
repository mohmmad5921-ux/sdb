<script setup>
import { Link } from '@inertiajs/vue3';
import { ref, computed, provide, onMounted, onBeforeUnmount } from 'vue';

const props = defineProps({ page: { type: String, default: '' } });

/* ─── Language System ─── */
const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');
function toggleLang() { lang.value = lang.value === 'ar' ? 'en' : 'ar'; }
provide('lang', lang);
provide('isAr', isAr);

/* ─── Segment: Private / Business ─── */
const segment = ref('private');
const isBiz = computed(() => segment.value === 'business');
function setSegment(s) { segment.value = s; mobileOpen.value = false; window.scrollTo({top:0,behavior:'instant'}); if(typeof localStorage!=='undefined') localStorage.setItem('sdb_segment',s); }
provide('segment', segment);
provide('isBiz', isBiz);

/* ─── Dark Mode ─── */
const isDark = ref(false);
function toggleDark() { isDark.value = !isDark.value; localStorage.setItem('sdb-dark', isDark.value ? '1' : '0'); }
provide('isDark', isDark);

/* ─── Global Currency System ─── */
const allCurrencies = [
  {code:'EUR',symbol:'€',flag:'🇪🇺'},{code:'USD',symbol:'$',flag:'🇺🇸'},
  {code:'GBP',symbol:'£',flag:'🇬🇧'},{code:'DKK',symbol:'kr',flag:'🇩🇰'},
  {code:'SEK',symbol:'kr',flag:'🇸🇪'},{code:'NOK',symbol:'kr',flag:'🇳🇴'},
  {code:'CHF',symbol:'CHF',flag:'🇨🇭'},{code:'TRY',symbol:'₺',flag:'🇹🇷'},
  {code:'AED',symbol:'AED',flag:'🇦🇪'},{code:'SAR',symbol:'SAR',flag:'🇸🇦'},
  {code:'KWD',symbol:'KWD',flag:'🇰🇼'},{code:'QAR',symbol:'QAR',flag:'🇶🇦'},
  {code:'JOD',symbol:'JOD',flag:'🇯🇴'},{code:'EGP',symbol:'EGP',flag:'🇪🇬'},
  {code:'SYP',symbol:'SYP',flag:'🇸🇾'},{code:'IQD',symbol:'IQD',flag:'🇮🇶'},
  {code:'LBP',symbol:'LBP',flag:'🇱🇧'},{code:'CAD',symbol:'CA$',flag:'🇨🇦'},
  {code:'AUD',symbol:'A$',flag:'🇦🇺'},{code:'JPY',symbol:'¥',flag:'🇯🇵'},
];
const liveRates = ref({}); // rates vs EUR from API
const userCurrency = ref({code:'EUR',symbol:'€',flag:'🇪🇺',rate:1});
const showCurPicker = ref(false);

function convertPrice(eurAmount) {
  const r = userCurrency.value.rate || 1;
  const val = eurAmount * r;
  if (val >= 1000) return Math.round(val).toLocaleString();
  if (val >= 1) return val.toFixed(2);
  return val.toFixed(4);
}
function formatPriceWithSymbol(eurAmount) {
  return convertPrice(eurAmount) + ' ' + userCurrency.value.code;
}

function setUserCurrency(code) {
  const c = allCurrencies.find(x => x.code === code);
  if (!c) return;
  const rate = liveRates.value[code] || 1;
  userCurrency.value = { ...c, rate };
  showCurPicker.value = false;
  localStorage.setItem('sdb-currency', code);
}

const tzToCur = {
  'America/New_York':'USD','America/Chicago':'USD','America/Denver':'USD','America/Los_Angeles':'USD',
  'America/Toronto':'CAD','America/Vancouver':'CAD',
  'Europe/London':'GBP','Europe/Dublin':'GBP',
  'Europe/Berlin':'EUR','Europe/Paris':'EUR','Europe/Rome':'EUR','Europe/Madrid':'EUR',
  'Europe/Amsterdam':'EUR','Europe/Brussels':'EUR','Europe/Vienna':'EUR',
  'Europe/Copenhagen':'DKK','Europe/Stockholm':'SEK','Europe/Oslo':'NOK','Europe/Zurich':'CHF',
  'Europe/Istanbul':'TRY',
  'Asia/Dubai':'AED','Asia/Riyadh':'SAR','Asia/Kuwait':'KWD','Asia/Doha':'QAR',
  'Asia/Bahrain':'BHD','Asia/Muscat':'OMR','Asia/Amman':'JOD',
  'Africa/Cairo':'EGP','Asia/Damascus':'SYP','Asia/Baghdad':'IQD','Asia/Beirut':'LBP',
  'Asia/Tokyo':'JPY','Australia/Sydney':'AUD',
};

function initCurrency() {
  // 1. Fetch live rates
  fetch('/api/public/rates').then(r => r.json()).then(data => {
    if (data.rates) {
      liveRates.value = data.rates;
      // Update widget rates too
      if (data.rates.SYP) {
        const syp = data.rates.SYP;
        widgetRates.value = {
          EUR: Math.round(syp),
          USD: Math.round(syp / (data.rates.USD || 1.08)),
          TRY: Math.round(syp / (data.rates.TRY || 34.2)),
          AED: Math.round(syp / (data.rates.AED || 3.97)),
        };
      }
      // 2. Detect or restore currency
      const saved = localStorage.getItem('sdb-currency');
      let code = saved;
      if (!code) {
        try { code = tzToCur[Intl.DateTimeFormat().resolvedOptions().timeZone]; } catch(e) {}
      }
      if (code && code !== 'EUR') {
        const c = allCurrencies.find(x => x.code === code);
        if (c) {
          userCurrency.value = { ...c, rate: data.rates[code] || 1 };
          if (!saved) localStorage.setItem('sdb-currency', code);
        }
      }
    }
  }).catch(() => {});
}

provide('userCurrency', userCurrency);
provide('liveRates', liveRates);
provide('convertPrice', convertPrice);
provide('formatPriceWithSymbol', formatPriceWithSymbol);
provide('allCurrencies', allCurrencies);

/* ─── Cookie Consent ─── */
const cookieAccepted = ref(true);

/* ─── Mobile Menu ─── */
const mobileOpen = ref(false);

/* ─── Mega Menu ─── */
const activeMenu = ref(null);
let closeTimer = null;
function openMenu(id) { clearTimeout(closeTimer); activeMenu.value = id; }
function startClose() { closeTimer = setTimeout(() => { activeMenu.value = null; }, 200); }
function cancelClose() { clearTimeout(closeTimer); }

/* ─── Social Proof ─── */
const regCount = ref(847);
let proofTimer;
onMounted(() => {
  proofTimer = setInterval(() => { regCount.value += Math.floor(Math.random()*3)+1; }, 15000);
});
onBeforeUnmount(() => { clearInterval(proofTimer); });

/* ─── Notification Bell ─── */
const showNotif = ref(false);
const hasNewNotif = ref(true);
const news = computed(() => isAr.value ? [
  {ic:'🚀',t:'الإطلاق قريباً!',d:'سجّل الآن لتكون من أوائل المستخدمين.',time:'اليوم'},
  {ic:'💳',t:'بطاقات ماستركارد',d:'4 مستويات من البطاقات متوفرة.',time:'أمس'},
  {ic:'🌍',t:'تحويلات لـ 150+ دولة',d:'أسرع طريقة للتحويل.',time:'هذا الاسبوع'},
] : [
  {ic:'🚀',t:'Launch coming soon!',d:'Register now to be among the first users.',time:'Today'},
  {ic:'💳',t:'Mastercard cards',d:'4 tier levels available.',time:'Yesterday'},
  {ic:'🌍',t:'Transfers to 150+ countries',d:'The fastest way to transfer.',time:'This week'},
]);
function toggleNotif() { showNotif.value = !showNotif.value; hasNewNotif.value = false; }

/* ─── Floating Currency Widget ─── */
const showWidget = ref(false);
const widgetRates = ref({EUR:13500,USD:12500,TRY:395,AED:3400});
const widgetRate = computed(() => (widgetRates.value.EUR || 13500).toLocaleString());
function closeAll() { activeMenu.value = null; }

/* ─── Fetch live rates for widget ─── */
function fetchWidgetRates() {
  fetch('/api/public/rates').then(r => r.json()).then(data => {
    if (data.rates && data.rates.SYP) {
      const syp = data.rates.SYP;
      widgetRates.value = {
        EUR: Math.round(syp),
        USD: Math.round(syp / (data.rates.USD || 1.08)),
        TRY: Math.round(syp / (data.rates.TRY || 34.2)),
        AED: Math.round(syp / (data.rates.AED || 3.97)),
      };
    }
  }).catch(() => {});
}

/* ─── App Download Modal (for Private segment login) ─── */
const showAppModal = ref(false);
function handleLogin() {
  if (isBiz.value) {
    window.location.href = '/login';
  } else {
    showAppModal.value = true;
  }
}

/* Close on scroll + sticky header + progress + back-to-top */
const scrolled = ref(false);
const scrollProgress = ref(0);
const showTop = ref(false);
function onScroll() {
  activeMenu.value = null;
  scrolled.value = window.scrollY > 20;
  showTop.value = window.scrollY > 400;
  const h = document.documentElement.scrollHeight - window.innerHeight;
  scrollProgress.value = h > 0 ? Math.min((window.scrollY / h) * 100, 100) : 0;
}
function scrollToTop() { window.scrollTo({ top: 0, behavior: 'smooth' }); }

/* Toast Notification System */
const toasts = ref([]);
let toastId = 0;
function showToast(msg, type='success') {
  const id = ++toastId;
  toasts.value.push({id, msg, type});
  setTimeout(() => { toasts.value = toasts.value.filter(t => t.id !== id); }, 4000);
}
provide('showToast', showToast);

onMounted(() => {
  window.addEventListener('scroll', onScroll);
  onScroll(); /* set initial state */
  /* Restore dark mode */
  if(localStorage.getItem('sdb-dark')==='1') isDark.value = true;
  /* Cookie consent */
  if(!localStorage.getItem('sdb-cookie')) cookieAccepted.value = false;
  /* Fetch live rates + detect currency */
  initCurrency();
  /* Tawk.to Live Chat — replace with your Tawk.to property ID when ready
  const s = document.createElement('script');
  s.async = true;
  s.src = 'https://embed.tawk.to/YOUR_PROPERTY_ID/default';
  s.charset = 'UTF-8';
  s.setAttribute('crossorigin','*');
  document.head.appendChild(s);
  */
});
onBeforeUnmount(() => window.removeEventListener('scroll', onScroll));
function acceptCookies() { cookieAccepted.value = true; localStorage.setItem('sdb-cookie','1'); }

/* ─── Mega Nav Structure ─── */
const megaNav = computed(() => isAr.value ? [
  { id:'accounts', label:'الحسابات', cols:[
    { title:'أنواع الحسابات', links:[
      {l:'حساب شخصي',h:'/personal',d:'حساب مجاني لكل فرد'},
      {l:'حساب تجاري',h:'/business',d:'للشركات ورجال الأعمال'},
      {l:'حساب عائلي',h:'/family',d:'بطاقات للأطفال مع تحكم الأهل'},
      {l:'حساب توفير',h:'/savings',d:'أدوات ادخار ذكية'},
    ]},
    { title:'الباقات', links:[
      {l:'مقارنة الباقات',h:'/plans',d:'Standard · Plus · Premium · Elite'},
      {l:'المعاشات',h:'/salary',d:'استلام راتبك مباشرة'},
    ]},
  ]},
  { id:'cards', label:'البطاقات', cols:[
    { title:'مستويات البطاقات', links:[
      {l:'Standard 🔵',h:'/cards/standard',d:'مجانية للأبد'},
      {l:'Plus 🟣',h:'/cards/plus',d:'€3.99/شهر — CVV ديناميكي'},
      {l:'Premium 🩷',h:'/cards/premium',d:'€7.99/شهر — بطاقة معدنية'},
      {l:'Elite 🟡',h:'/cards/elite',d:'€14.99/شهر — مدير شخصي'},
    ]},
    { title:'معلومات البطاقات', links:[
      {l:'نظرة عامة',h:'/cards-info',d:'كل شيء عن بطاقات SDB'},
      {l:'Apple/Google Wallet',h:'/wallet-guide',d:'أضف بطاقتك للمحفظة'},
    ]},
  ]},
  { id:'services', label:'الخدمات', cols:[
    { title:'خدمات مالية', links:[
      {l:'التحويلات',h:'/transfers-info',d:'محلي، SEPA، SWIFT'},
      {l:'العملات',h:'/currencies',d:'30+ عملة'},
      {l:'الليرة السورية 🇸🇾',h:'/syrian-lira',d:'أسعار صرف حية'},
      {l:'ليرتنا 💱',h:'/lirtna',d:'محوّل الليرة السورية'},
      {l:'العملات الرقمية 🪙',h:'/crypto',d:'BTC، ETH، USDT + 9'},
      {l:'أسعار الصرف',h:'/exchange-rates',d:'حاسبة تفاعلية'},
      {l:'دفع الفواتير',h:'/bills',d:'كهرباء، ماء، إنترنت (قريباً)'},
    ]},
    { title:'أدوات ذكية', links:[
      {l:'التحليلات المالية',h:'/analytics',d:'AI لتحليل مصاريفك'},
      {l:'الهوية الرقمية',h:'/digital-id',d:'تحقق هويتك رقمياً'},
      {l:'التطبيق',h:'/app',d:'حمّل التطبيق'},
    ]},
  ]},
  { id:'security', label:'الأمان', cols:[
    { title:'الحماية', links:[
      {l:'الأمان والحماية',h:'/security',d:'8 طبقات حماية'},
      {l:'إبلاغ عن احتيال',h:'/report-fraud',d:'فريق طوارئ 24/7'},
    ]},
    { title:'القانوني', links:[
      {l:'الامتثال والتراخيص',h:'/compliance',d:'مرخّص بالدنمارك'},
      {l:'سياسة الخصوصية',h:'/privacy',d:'GDPR'},
      {l:'الشروط والأحكام',h:'/terms',d:'شروط الاستخدام'},
    ]},
  ]},
  { id:'company', label:'الشركة', cols:[
    { title:'عن SDB', links:[
      {l:'عنّا',h:'/about',d:'قصتنا ورؤيتنا'},
      {l:'وظائف',h:'/careers',d:'انضم لفريقنا'},
      {l:'المدونة',h:'/blog',d:'أخبار ومقالات'},
    ]},
    { title:'تواصل', links:[
      {l:'الشراكات',h:'/partners',d:'كن شريكنا'},
      {l:'الصحافة',h:'/press',d:'غرفة الأخبار'},
      {l:'الدعم',h:'/support',d:'تواصل معنا'},
    ]},
  ]},
] : [
  { id:'accounts', label:'Accounts', cols:[
    { title:'Account Types', links:[
      {l:'Personal',h:'/personal',d:'Free account for everyone'},
      {l:'Business',h:'/business',d:'For companies & entrepreneurs'},
      {l:'Family',h:'/family',d:'Kids cards with parental controls'},
      {l:'Savings',h:'/savings',d:'Smart saving tools'},
    ]},
    { title:'Plans', links:[
      {l:'Compare Plans',h:'/plans',d:'Standard · Plus · Premium · Elite'},
      {l:'Salary',h:'/salary',d:'Receive your salary directly'},
    ]},
  ]},
  { id:'cards', label:'Cards', cols:[
    { title:'Card Tiers', links:[
      {l:'Standard 🔵',h:'/cards/standard',d:'Free forever'},
      {l:'Plus 🟣',h:'/cards/plus',d:'€3.99/mo — Dynamic CVV'},
      {l:'Premium 🩷',h:'/cards/premium',d:'€7.99/mo — Metal card'},
      {l:'Elite 🟡',h:'/cards/elite',d:'€14.99/mo — Personal manager'},
    ]},
    { title:'Card Info', links:[
      {l:'Overview',h:'/cards-info',d:'All about SDB cards'},
      {l:'Apple/Google Wallet',h:'/wallet-guide',d:'Add card to wallet'},
    ]},
  ]},
  { id:'services', label:'Services', cols:[
    { title:'Financial Services', links:[
      {l:'Transfers',h:'/transfers-info',d:'Local, SEPA, SWIFT'},
      {l:'Currencies',h:'/currencies',d:'30+ currencies'},
      {l:'Syrian Lira 🇸🇾',h:'/syrian-lira',d:'Live SYP exchange rates'},
      {l:'Lirtna 💱',h:'/lirtna',d:'Syrian Lira converter'},
      {l:'Crypto 🪙',h:'/crypto',d:'BTC, ETH, USDT + 9'},
      {l:'Exchange Rates',h:'/exchange-rates',d:'Interactive calculator'},
      {l:'Bill Payments',h:'/bills',d:'Electricity, water, internet (Soon)'},
    ]},
    { title:'Smart Tools', links:[
      {l:'Financial Analytics',h:'/analytics',d:'AI to analyze spending'},
      {l:'Digital ID',h:'/digital-id',d:'Verify your identity digitally'},
      {l:'The App',h:'/app',d:'Download the app'},
    ]},
  ]},
  { id:'security', label:'Security', cols:[
    { title:'Protection', links:[
      {l:'Security & Protection',h:'/security',d:'8 security layers'},
      {l:'Report Fraud',h:'/report-fraud',d:'24/7 emergency team'},
    ]},
    { title:'Legal', links:[
      {l:'Compliance & Licensing',h:'/compliance',d:'Licensed in Denmark'},
      {l:'Privacy Policy',h:'/privacy',d:'GDPR'},
      {l:'Terms of Service',h:'/terms',d:'Terms of use'},
    ]},
  ]},
  { id:'company', label:'Company', cols:[
    { title:'About SDB', links:[
      {l:'About Us',h:'/about',d:'Our story & vision'},
      {l:'Careers',h:'/careers',d:'Join our team'},
      {l:'Blog',h:'/blog',d:'News & articles'},
    ]},
    { title:'Connect', links:[
      {l:'Partners',h:'/partners',d:'Become a partner'},
      {l:'Press',h:'/press',d:'Newsroom'},
      {l:'Support',h:'/support',d:'Contact us'},
    ]},
  ]},
]);

/* ─── Footer ─── */
const t = computed(() => isAr.value ? {
  cta: 'افتح حسابك',
  col1h: 'الحسابات', col1: [
    { label: 'حساب شخصي', href: '/personal' },
    { label: 'حساب تجاري', href: '/business' },
    { label: 'حساب عائلي', href: '/family' },
    { label: 'حساب توفير', href: '/savings' },
    { label: 'مقارنة الباقات', href: '/plans' },
  ],
  col2h: 'البطاقات', col2: [
    { label: 'Standard', href: '/cards/standard' },
    { label: 'Plus', href: '/cards/plus' },
    { label: 'Premium', href: '/cards/premium' },
    { label: 'Elite', href: '/cards/elite' },
    { label: 'نظرة عامة', href: '/cards-info' },
  ],
  col3h: 'الخدمات', col3: [
    { label: 'التحويلات', href: '/transfers-info' },
    { label: 'العملات', href: '/currencies' },
    { label: 'أسعار الصرف', href: '/exchange-rates' },
    { label: 'دفع الفواتير', href: '/bills' },
    { label: 'التحليلات', href: '/analytics' },
    { label: 'المعاشات', href: '/salary' },
    { label: 'ليرتنا', href: '/lirtna' },
    { label: 'التطبيق', href: '/app' },
  ],
  col4h: 'الأمان', col4: [
    { label: 'الحماية', href: '/security' },
    { label: 'إبلاغ عن احتيال', href: '/report-fraud' },
    { label: 'الامتثال', href: '/compliance' },
    { label: 'الخصوصية', href: '/privacy' },
    { label: 'الشروط والأحكام', href: '/terms' },
  ],
  col5h: 'الشركة', col5: [
    { label: 'عنّا', href: '/about' },
    { label: 'وظائف', href: '/careers' },
    { label: 'المدونة', href: '/blog' },
    { label: 'الشراكات', href: '/partners' },
    { label: 'الصحافة', href: '/press' },
    { label: 'الدعم', href: '/support' },
  ],
  col6h: 'تواصل معنا',
  ftDesc: 'أول بنك إلكتروني سوري — مرخّص في الدنمارك بمعايير أوروبية.\nمصمم لخدمة كل سوري بالعالم.',
  ftCopy: '© 2026 SDB Bank ApS. جميع الحقوق محفوظة.',
  ftReg: 'SDB Bank ApS مسجّلة في الدنمارك. خاضعة لرقابة الجهات المالية الأوروبية. جميع الأموال محمية وفقاً لمعايير الاتحاد الأوروبي.',
} : {
  cta: 'Open Account',
  col1h: 'Accounts', col1: [
    { label: 'Personal', href: '/personal' },
    { label: 'Business', href: '/business' },
    { label: 'Family', href: '/family' },
    { label: 'Savings', href: '/savings' },
    { label: 'Compare Plans', href: '/plans' },
  ],
  col2h: 'Cards', col2: [
    { label: 'Standard', href: '/cards/standard' },
    { label: 'Plus', href: '/cards/plus' },
    { label: 'Premium', href: '/cards/premium' },
    { label: 'Elite', href: '/cards/elite' },
    { label: 'Overview', href: '/cards-info' },
  ],
  col3h: 'Services', col3: [
    { label: 'Transfers', href: '/transfers-info' },
    { label: 'Currencies', href: '/currencies' },
    { label: 'Exchange Rates', href: '/exchange-rates' },
    { label: 'Bill Payments', href: '/bills' },
    { label: 'Analytics', href: '/analytics' },
    { label: 'Salary', href: '/salary' },
    { label: 'Lirtna', href: '/lirtna' },
    { label: 'The App', href: '/app' },
  ],
  col4h: 'Security', col4: [
    { label: 'Protection', href: '/security' },
    { label: 'Report Fraud', href: '/report-fraud' },
    { label: 'Compliance', href: '/compliance' },
    { label: 'Privacy', href: '/privacy' },
    { label: 'Terms', href: '/terms' },
  ],
  col5h: 'Company', col5: [
    { label: 'About Us', href: '/about' },
    { label: 'Careers', href: '/careers' },
    { label: 'Blog', href: '/blog' },
    { label: 'Partners', href: '/partners' },
    { label: 'Press', href: '/press' },
    { label: 'Support', href: '/support' },
  ],
  col6h: 'Contact',
  ftDesc: 'The first Syrian digital bank — licensed in Denmark with European standards.\nDesigned to serve every Syrian worldwide.',
  ftCopy: '© 2026 SDB Bank ApS. All rights reserved.',
  ftReg: 'SDB Bank ApS is registered in Denmark. Subject to European financial regulations. All funds are protected under EU standards.',
});

/* ─── Mobile Nav Sections ─── */
const mobileActiveSection = ref(null);
function toggleMobileSection(id) { mobileActiveSection.value = mobileActiveSection.value === id ? null : id; }
</script>

<template>
<div class="site" :class="{ rtl: isAr, dark: isDark }" :dir="isAr ? 'rtl' : 'ltr'">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />

  <!-- Scroll Progress Bar -->
  <div class="scroll-progress" :style="{width: scrollProgress+'%'}"></div>

  <!-- Segment Toggle Bar -->
  <div class="seg-bar">
    <div class="sw seg-bar-inner">
      <div class="seg-toggle">
        <button class="seg-btn" :class="{active:segment==='private'}" @click="setSegment('private')">{{ isAr ? 'خاص' : 'Private' }}</button>
        <button class="seg-btn" :class="{active:segment==='business'}" @click="setSegment('business')">{{ isAr ? 'أعمال' : 'Business' }}</button>
      </div>
    </div>
  </div>

  <!-- Nav -->
  <nav class="sn" :class="{scrolled}">
    <div class="sw">
      <Link href="/" class="sn-logo"><img src="/images/sdb-logo-new.png" alt="SDB Bank" class="sn-logo-img"/></Link>
      <div class="sn-links">
        <div v-for="m in megaNav" :key="m.id" class="sn-dd" @mouseenter="openMenu(m.id)" @mouseleave="startClose">
          <span class="sn-link" :class="{'sn-active':activeMenu===m.id}">{{ m.label }} <span class="sn-arr">▾</span></span>
          <Transition name="mm">
            <div v-if="activeMenu===m.id" class="mm" @mouseenter="cancelClose" @mouseleave="startClose">
              <div class="mm-inner">
                <div v-for="col in m.cols" :key="col.title" class="mm-col">
                  <div class="mm-col-h">{{ col.title }}</div>
                  <Link v-for="lnk in col.links" :key="lnk.h" :href="lnk.h" class="mm-item" @click="closeAll">
                    <span class="mm-item-l">{{ lnk.l }}</span>
                    <span class="mm-item-d">{{ lnk.d }}</span>
                  </Link>
                </div>
              </div>
            </div>
          </Transition>
        </div>
      </div>
      <div class="sn-right">
        <div class="sn-cur-wrap" style="position:relative">
          <button @click="showCurPicker=!showCurPicker" class="sn-lang" style="gap:4px">{{ userCurrency.flag }} {{ userCurrency.code }} <span style="font-size:8px;opacity:.4">▾</span></button>
          <div v-if="showCurPicker" class="sn-cur-dd" @click.stop>
            <div v-for="c in allCurrencies" :key="c.code" class="sn-cur-item" :class="{'sn-cur-active':c.code===userCurrency.code}" @click="setUserCurrency(c.code)">{{ c.flag }} <span>{{ c.code }}</span></div>
          </div>
        </div>
        <button @click="toggleLang" class="sn-lang">{{ isAr ? 'EN' : 'عربي' }}</button>
        <button v-if="isBiz" @click="handleLogin" class="sn-login">{{ isAr ? 'تسجيل الدخول' : 'Log in' }}</button>
        <Link :href="isBiz ? '/preregister?type=business' : '/preregister'" class="sn-cta">{{ t.cta }}</Link>
        <button @click="mobileOpen=!mobileOpen" class="sn-hamburger">
          <span></span><span></span><span></span>
        </button>
      </div>
    </div>
  </nav>

  <!-- Mobile mega menu (outside nav to avoid clipping) -->
  <Transition name="mob-slide">
  <div v-if="mobileOpen" class="sn-mobile">
    <div class="mob-seg-toggle">
      <button class="mob-seg-btn" :class="{active:segment==='private'}" @click="setSegment('private')">{{ isAr ? 'خاص' : 'Private' }}</button>
      <button class="mob-seg-btn" :class="{active:segment==='business'}" @click="setSegment('business')">{{ isAr ? 'أعمال' : 'Business' }}</button>
    </div>

    <!-- ═══ Private Mobile Menu ═══ -->
    <template v-if="!isBiz">
      <Link href="/" class="sn-mob-link" @click="mobileOpen=false">{{ isAr?'الرئيسية':'Home' }}</Link>
      <div v-for="m in megaNav" :key="m.id" class="mob-sec">
        <button class="mob-sec-btn" @click="toggleMobileSection(m.id)">
          {{ m.label }} <span class="mob-arr" :class="{'mob-arr-open':mobileActiveSection===m.id}">▸</span>
        </button>
        <div v-if="mobileActiveSection===m.id" class="mob-sec-body">
          <template v-for="col in m.cols" :key="col.title">
            <div class="mob-col-h">{{ col.title }}</div>
            <Link v-for="lnk in col.links" :key="lnk.h" :href="lnk.h" class="sn-mob-link mob-sub" @click="mobileOpen=false">{{ lnk.l }}</Link>
          </template>
        </div>
      </div>
      <Link href="/preregister" class="sn-cta sn-mob-cta" @click="mobileOpen=false">{{ t.cta }}</Link>
    </template>

    <!-- ═══ Business Mobile Menu ═══ -->
    <template v-else>
      <Link href="/" class="sn-mob-link" @click="mobileOpen=false">{{ isAr?'الرئيسية':'Home' }}</Link>
      <Link href="/business" class="sn-mob-link" @click="mobileOpen=false">{{ isAr?'🖥️ نت بنك الأعمال':'🖥️ Business Net Bank' }}</Link>
      <Link href="/business" class="sn-mob-link" @click="mobileOpen=false">{{ isAr?'💼 حسابات الأعمال':'💼 Business Accounts' }}</Link>
      <Link href="/transfers-info" class="sn-mob-link" @click="mobileOpen=false">{{ isAr?'🌐 التحويلات الدولية':'🌐 International Transfers' }}</Link>
      <Link href="/currencies" class="sn-mob-link" @click="mobileOpen=false">{{ isAr?'💱 العملات والصرف':'💱 Currencies & Exchange' }}</Link>
      <Link href="/plans" class="sn-mob-link" @click="mobileOpen=false">{{ isAr?'📋 الباقات والأسعار':'📋 Plans & Pricing' }}</Link>
      <Link href="/security" class="sn-mob-link" @click="mobileOpen=false">{{ isAr?'🔐 الأمان':'🔐 Security' }}</Link>
      <Link href="/about" class="sn-mob-link" @click="mobileOpen=false">{{ isAr?'🏢 عن الشركة':'🏢 About Us' }}</Link>
      <Link href="/support" class="sn-mob-link" @click="mobileOpen=false">{{ isAr?'📞 الدعم':'📞 Support' }}</Link>
      <button @click="handleLogin(); mobileOpen=false" class="sn-mob-link" style="color:#2D6A00;font-weight:800;background:none;border:none;border-bottom:1px solid rgba(22,51,0,.06);width:100%;text-align:start;font-size:16px;cursor:pointer;font-family:inherit">{{ isAr ? 'تسجيل الدخول' : 'Log in' }}</button>
      <Link href="/preregister?type=business" class="sn-cta sn-mob-cta" @click="mobileOpen=false">{{ isAr?'افتح حساب أعمال ←':'Open Business Account →' }}</Link>
    </template>
  </div>
  </Transition>

  <!-- Page Content -->
  <main class="site-main">
    <slot />
  </main>

  <!-- Toast Notifications -->
  <div class="toast-container">
    <TransitionGroup name="toast">
      <div v-for="t in toasts" :key="t.id" class="toast-item" :class="'toast-'+t.type">{{ t.msg }}</div>
    </TransitionGroup>
  </div>

  <!-- Back to Top -->
  <Transition name="btt">
    <button v-if="showTop" class="back-top" @click="scrollToTop" :title="isAr?'العودة للأعلى':'Back to top'">↑</button>
  </Transition>

  <!-- Get the App Modal (Personal users) -->
  <Transition name="modal">
  <div v-if="showAppModal" class="app-modal-overlay" @click.self="showAppModal=false">
    <div class="app-modal-card">
      <button class="app-modal-close" @click="showAppModal=false">×</button>
      <img src="/images/sdb-logo-new.png" alt="SDB" class="app-modal-logo"/>
      <h2 class="app-modal-title">{{ isAr ? 'حمّل تطبيق SDB Bank' : 'Get the SDB Bank app' }}</h2>
      <p class="app-modal-desc">{{ isAr ? 'سجّل دخولك من التطبيق. حمّله الآن من المتجر.' : 'Log in from the app. Download it now from your store.' }}</p>
      <div class="app-modal-stores">
        <a href="#" class="app-store-btn">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09zM13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/></svg>
          <div><small>{{ isAr ? 'حمّل من' : 'Download on the' }}</small><strong>App Store</strong></div>
        </a>
        <a href="#" class="app-store-btn">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M3.609 1.814L13.792 12 3.61 22.186a.996.996 0 01-.61-.92V2.734a1 1 0 01.609-.92zm10.89 10.893l2.302 2.302-10.937 6.333 8.635-8.635zm3.199-3.198l2.807 1.626a1 1 0 010 1.73l-2.808 1.626L15.206 12l2.492-2.491zM5.864 2.658L16.8 8.99l-2.302 2.302-8.634-8.634z"/></svg>
          <div><small>{{ isAr ? 'متوفر على' : 'Get it on' }}</small><strong>Google Play</strong></div>
        </a>
      </div>
      <p class="app-modal-hint">{{ isAr ? 'العملاء الأفراد يسجّلون الدخول حصراً من التطبيق' : 'Personal customers log in exclusively via the app' }}</p>
      <button class="app-modal-biz-link" @click="showAppModal=false; setSegment('business')">{{ isAr ? 'لديك حساب أعمال؟ سجّل دخول من هنا' : 'Have a business account? Log in here' }} →</button>
    </div>
  </div>
  </Transition>

  <!-- Cookie Consent -->
  <Transition name="cookie">
  <div v-if="!cookieAccepted" class="cookie-bar">
    <p class="cookie-text">{{ isAr?'نستخدم ملفات تعريف الارتباط لتحسين تجربتك. بالمتابعة أنت توافق على':'We use cookies to improve your experience. By continuing you agree to our' }} <Link :href="'/privacy'" class="cookie-link">{{ isAr?'سياسة الخصوصية':'Privacy Policy' }}</Link></p>
    <div class="cookie-btns">
      <button @click="acceptCookies" class="cookie-accept">{{ isAr?'موافق':'Accept' }}</button>
      <button @click="acceptCookies" class="cookie-decline">{{ isAr?'الضروري فقط':'Essential only' }}</button>
    </div>
  </div>
  </Transition>

  <!-- Mega Footer -->
  <footer class="sf">
    <div class="sw">
      <div class="sf-top">
        <div class="sf-brand">
          <a href="/" class="sn-logo sn-logo-ft"><img src="/images/sdb-logo-white.png" alt="SDB Bank" class="sn-logo-img sn-logo-img-ft"/></a>
          <p class="sf-desc">{{ t.ftDesc }}</p>
          <div class="sf-social">
            <span class="sf-soc-icon">𝕏</span>
            <span class="sf-soc-icon">in</span>
            <span class="sf-soc-icon">ig</span>
          </div>
        </div>
        <div class="sf-col">
          <div class="sf-col-h">{{ t.col1h }}</div>
          <Link v-for="l in t.col1" :key="l.label" :href="l.href" class="sf-link">{{ l.label }}</Link>
        </div>
        <div class="sf-col">
          <div class="sf-col-h">{{ t.col2h }}</div>
          <Link v-for="l in t.col2" :key="l.label" :href="l.href" class="sf-link">{{ l.label }}</Link>
        </div>
        <div class="sf-col">
          <div class="sf-col-h">{{ t.col3h }}</div>
          <Link v-for="l in t.col3" :key="l.label" :href="l.href" class="sf-link">{{ l.label }}</Link>
        </div>
        <div class="sf-col">
          <div class="sf-col-h">{{ t.col4h }}</div>
          <Link v-for="l in t.col4" :key="l.label" :href="l.href" class="sf-link">{{ l.label }}</Link>
        </div>
        <div class="sf-col">
          <div class="sf-col-h">{{ t.col5h }}</div>
          <Link v-for="l in t.col5" :key="l.label" :href="l.href" class="sf-link">{{ l.label }}</Link>
        </div>
      </div>

      <div class="sf-contact">
        <div class="sf-col-h" style="margin-bottom:12px">{{ t.col6h }}</div>
        <div class="sf-contact-row">
          <span class="sf-contact-item">📧 info@sdb-bank.com</span>
          <span class="sf-contact-item">📍 Denmark 🇩🇰</span>
        </div>
      </div>

      <div class="sf-bottom">
        <div class="sf-badges">
          <span class="sf-badge">🔒 256-bit SSL</span>
          <span class="sf-badge">🇩🇰 EU Regulated</span>
          <span class="sf-badge">🛡️ PCI DSS</span>
        </div>
        <div class="sf-share">
          <span class="sf-share-label">{{ isAr ? 'شارك:' : 'Share:' }}</span>
          <a :href="'https://wa.me/?text='+encodeURIComponent(isAr?'تعرّف على SDB Bank — أول بنك إلكتروني سوري https://sdb-bank.com':'Check out SDB Bank — the first Syrian digital bank https://sdb-bank.com')" target="_blank" class="sf-share-btn" title="WhatsApp">💬</a>
          <a :href="'https://twitter.com/intent/tweet?text='+encodeURIComponent(isAr?'تعرّف على SDB Bank — أول بنك إلكتروني سوري https://sdb-bank.com':'Check out SDB Bank — the first Syrian digital bank https://sdb-bank.com')" target="_blank" class="sf-share-btn" title="Twitter">𝕏</a>
          <a :href="'https://t.me/share/url?url=https://sdb-bank.com&text='+encodeURIComponent(isAr?'SDB Bank — أول بنك إلكتروني سوري':'SDB Bank — first Syrian digital bank')" target="_blank" class="sf-share-btn" title="Telegram">✈️</a>
        </div>
        <p class="sf-reg">{{ t.ftReg }}</p>
        <span class="sf-copy">{{ t.ftCopy }}</span>
      </div>
    </div>
  </footer>

  <!-- Floating Currency Widget -->
  <div class="cur-widget" :class="{open:showWidget}">
    <button class="cur-trigger" @click="showWidget=!showWidget">💱 <span v-if="!showWidget">{{ widgetRate }} SYP</span><span v-else>×</span></button>
    <div v-if="showWidget" class="cur-body">
      <div class="cur-row"><span class="cur-flag">🇪🇺</span><span class="cur-pair">EUR/SYP</span><span class="cur-val">{{ widgetRates.EUR.toLocaleString() }}</span></div>
      <div class="cur-row"><span class="cur-flag">🇺🇸</span><span class="cur-pair">USD/SYP</span><span class="cur-val">{{ widgetRates.USD.toLocaleString() }}</span></div>
      <div class="cur-row"><span class="cur-flag">🇹🇷</span><span class="cur-pair">TRY/SYP</span><span class="cur-val">{{ widgetRates.TRY.toLocaleString() }}</span></div>
      <div class="cur-row"><span class="cur-flag">🇦🇪</span><span class="cur-pair">AED/SYP</span><span class="cur-val">{{ widgetRates.AED.toLocaleString() }}</span></div>
      <Link href="/exchange-rates" class="cur-link" @click="showWidget=false">{{ isAr ? 'كل الأسعار →' : 'All rates →' }}</Link>
    </div>
  </div>
</div>
</template>

<style>
/* ─── Global Reset ─── */
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth}
#app{background:#fff;position:relative;z-index:1}
html,body{background:#fff}
.site{font-family:'Inter',system-ui,-apple-system,sans-serif;color:#0a0a0a;overflow-x:hidden;min-height:100vh;display:flex;flex-direction:column;background:#fff}
.site>main{flex:1}
.site-main{background:#fff;position:relative;z-index:1}
.sw{max-width:1200px;margin:0 auto;padding:0 24px}
.rtl{direction:rtl;text-align:right}
.rtl .text-center{text-align:center}

/* ─── Segment Toggle Bar ─── */
.seg-bar{position:fixed;top:0;left:0;right:0;z-index:100;height:36px;background:#163300;display:flex;align-items:center}
.seg-bar-inner{display:flex;justify-content:flex-end;width:100%}
.seg-toggle{display:flex;gap:0;background:rgba(255,255,255,.1);border-radius:6px;padding:3px}
.seg-btn{padding:4px 20px;font-size:12px;font-weight:700;border:none;background:none;color:rgba(255,255,255,.6);cursor:pointer;border-radius:4px;font-family:inherit;transition:all .2s;letter-spacing:.5px}
.seg-btn.active{background:#9FE870;color:#163300}
.seg-btn:hover:not(.active){color:#fff}
/* Mobile segment toggle inside side menu */
.mob-seg-toggle{display:flex;gap:0;background:#f0f4ec;border-radius:10px;padding:4px;margin:0 16px 12px}
.mob-seg-btn{flex:1;padding:10px 0;font-size:14px;font-weight:700;border:none;background:none;color:#8a9a7e;cursor:pointer;border-radius:8px;font-family:inherit;transition:all .2s;text-align:center}
.mob-seg-btn.active{background:#2D6A00;color:#fff;box-shadow:0 2px 8px rgba(45,106,0,.2)}
@media(max-width:900px){.seg-bar{display:none}.sn{top:0!important}.sn-mobile{top:68px!important}}

/* ─── Nav — V0 Green ─── */
.sn{position:fixed;top:36px;left:0;right:0;z-index:99;height:68px;display:flex;align-items:center;background:#fff;backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);box-shadow:0 1px 0 rgba(0,0,0,.04);transition:all .35s cubic-bezier(.16,1,.3,1)}
.sn.scrolled{background:rgba(255,255,255,.95);box-shadow:0 4px 20px rgba(0,0,0,.06)}

/* ─── Login Button ─── */
.sn-login{font-size:14px;font-weight:700;color:#163300;border:2px solid #163300;padding:8px 22px;border-radius:999px;text-decoration:none;transition:all .2s;white-space:nowrap}.sn-login:hover{background:#163300;color:#fff}
.sn .sw{display:flex;align-items:center;justify-content:space-between;width:100%}
.sn-logo{text-decoration:none;flex-shrink:0;display:inline-flex;align-items:center}
.sn-logo-img{height:42px;width:auto}
.sn-logo-img-ft{height:120px}
.sn-dot{color:#E0F2FE;font-size:32px;line-height:0}
.sn-links{display:flex;gap:4px;margin:0 auto}
.sn-dd{position:relative}
.sn-link{font-size:15px;font-weight:600;color:#555;text-decoration:none;transition:all .2s;letter-spacing:.2px;cursor:pointer;padding:8px 14px;border-radius:8px;display:flex;align-items:center;gap:4px;user-select:none}
.sn-link:hover,.sn-active{color:#163300!important;background:rgba(159,232,112,.1)}
.sn-arr{font-size:10px;opacity:.7;transition:transform .2s}
.sn-active .sn-arr{transform:rotate(180deg);opacity:.8}
.sn-right{display:flex;align-items:center;gap:10px}
.sn-lang{font-size:14px;font-weight:700;color:#163300;background:rgba(159,232,112,.1);border:1.5px solid rgba(159,232,112,.3);padding:8px 18px;border-radius:8px;cursor:pointer;transition:all .2s;font-family:inherit;display:flex;align-items:center}.sn-lang:hover{background:rgba(159,232,112,.2);border-color:rgba(159,232,112,.5)}
.sn-cur-dd{position:absolute;top:calc(100% + 6px);right:0;min-width:160px;background:#fff;border:1px solid rgba(0,0,0,.08);border-radius:12px;box-shadow:0 12px 36px rgba(0,0,0,.12);padding:6px;z-index:200;max-height:300px;overflow-y:auto}
.rtl .sn-cur-dd{right:auto;left:0}
.sn-cur-item{display:flex;align-items:center;gap:8px;padding:8px 12px;border-radius:8px;cursor:pointer;font-size:14px;transition:background .15s}.sn-cur-item:hover{background:rgba(159,232,112,.08)}.sn-cur-item span{font-weight:700;font-size:13px;color:#163300}
.sn-cur-active{background:rgba(159,232,112,.12)!important;font-weight:800}
.sn-cta{font-size:14px;font-weight:800;color:#fff;background:#163300;padding:10px 24px;border-radius:999px;text-decoration:none;transition:all .2s;border:none;white-space:nowrap;box-shadow:0 2px 8px rgba(22,51,0,.15)}.sn-cta:hover{background:#1e4400;transform:translateY(-1px);box-shadow:0 4px 12px rgba(22,51,0,.2)}
.sn-hamburger{display:none;flex-direction:column;gap:5px;background:none;border:none;cursor:pointer;padding:4px}
.sn-hamburger span{width:22px;height:2px;background:#163300;border-radius:2px;transition:all .2s}

/* ─── Mega Menu Dropdown ─── */
.mm{position:absolute;top:calc(100% + 12px);left:50%;transform:translateX(-50%);min-width:480px;z-index:100}
.rtl .mm{left:auto;right:50%;transform:translateX(50%)}
.mm-inner{background:#fff;border-radius:16px;box-shadow:0 16px 48px rgba(0,0,0,.12),0 0 0 1px rgba(14,165,233,.06);padding:24px;display:grid;grid-template-columns:repeat(2,1fr);gap:24px}
.mm::before{content:'';position:absolute;top:-6px;left:50%;margin-left:-6px;border-left:6px solid transparent;border-right:6px solid transparent;border-bottom:6px solid #fff}
.rtl .mm::before{left:auto;right:50%;margin-left:0;margin-right:-6px}
.mm-col-h{font-size:10px;font-weight:800;letter-spacing:1.5px;text-transform:uppercase;color:rgba(45,106,0,.5);margin-bottom:10px;padding-bottom:6px;border-bottom:1px solid rgba(159,232,112,.1)}
.rtl .mm-col-h{letter-spacing:0}
.mm-item{display:flex;flex-direction:column;gap:2px;padding:10px 12px;border-radius:10px;text-decoration:none;transition:all .15s}.mm-item:hover{background:rgba(159,232,112,.06)}
.mm-item-l{font-size:13.5px;font-weight:700;color:#163300}
.mm-item-d{font-size:11px;color:rgba(10,10,10,.3)}

/* Mega menu transition */
.mm-enter-active{animation:mmIn .2s ease}.mm-leave-active{animation:mmIn .15s ease reverse}
@keyframes mmIn{from{opacity:0;transform:translateX(-50%) translateY(8px)}to{opacity:1;transform:translateX(-50%) translateY(0)}}

/* Mobile nav */
.sn-mobile{position:fixed;top:104px;left:0;right:0;bottom:0;background:#fff;padding:20px 24px;display:flex;flex-direction:column;gap:2px;border-top:1px solid rgba(159,232,112,.15);z-index:98;box-shadow:0 8px 24px rgba(0,0,0,.08);overflow-y:auto;-webkit-overflow-scrolling:touch}
.mob-slide-enter-active,.mob-slide-leave-active{transition:all .3s cubic-bezier(.16,1,.3,1)}
.mob-slide-enter-from,.mob-slide-leave-to{opacity:0;transform:translateY(-12px)}
.sn-mob-link{font-size:16px;color:#163300;text-decoration:none;padding:14px 0;border-bottom:1px solid rgba(22,51,0,.06);font-weight:600}
.sn-mob-cta{text-align:center;margin-top:16px;display:block;font-size:16px}
.mob-sec{border-bottom:1px solid rgba(22,51,0,.06)}
.mob-sec-btn{width:100%;text-align:start;padding:14px 0;background:none;border:none;font-size:16px;font-weight:700;color:#163300;cursor:pointer;font-family:inherit;display:flex;justify-content:space-between;align-items:center}
.rtl .mob-sec-btn{text-align:right}
.mob-arr{font-size:14px;transition:transform .2s;color:rgba(22,51,0,.3)}.mob-arr-open{transform:rotate(90deg);color:#163300}
.mob-sec-body{padding-bottom:12px}
.mob-col-h{font-size:11px;font-weight:800;letter-spacing:1px;text-transform:uppercase;color:rgba(22,51,0,.35);padding:8px 12px 4px}
.mob-sub{padding:10px 16px;font-size:14px;color:#555;border:none}

/* ─── Mega Footer — V0 Dark Green ─── */
.sf{background:#163300;padding:80px 0 0;color:#fff;margin-top:auto}
.sf-top{display:grid;grid-template-columns:1.8fr repeat(5,1fr);gap:32px;padding-bottom:48px;border-bottom:1px solid rgba(159,232,112,.1)}
.sf-brand{display:flex;flex-direction:column;gap:12px}
.sn-logo-ft{font-size:22px;display:inline-block;margin-bottom:4px}
.sf-desc{font-size:15px;font-weight:400;color:rgba(255,255,255,.6);line-height:1.8;white-space:pre-line;max-width:300px}
.sf-social{display:flex;gap:8px;margin-top:4px}
.sf-soc-icon{width:36px;height:36px;display:flex;align-items:center;justify-content:center;border:1px solid rgba(255,255,255,.25);border-radius:12px;font-size:13px;font-weight:800;color:rgba(255,255,255,.6);cursor:pointer;transition:all .2s}.sf-soc-icon:hover{border-color:rgba(159,232,112,.5);color:#163300;background:#9FE870}
.sf-col{display:flex;flex-direction:column;gap:10px}
.sf-col-h{font-size:14px;font-weight:800;letter-spacing:1.2px;text-transform:uppercase;color:#fff;margin-bottom:10px}
.rtl .sf-col-h{letter-spacing:0}
.sf-link{font-size:15px;font-weight:500;color:rgba(255,255,255,.7);text-decoration:none;transition:color .2s;line-height:1.7}.sf-link:hover{color:#9FE870}
.sf-contact{padding:28px 0;border-bottom:1px solid rgba(159,232,112,.1)}
.sf-contact-row{display:flex;gap:32px;flex-wrap:wrap}
.sf-contact-item{font-size:15px;font-weight:600;color:rgba(255,255,255,.75)}
.sf-bottom{padding:24px 0;display:flex;flex-direction:column;gap:12px}
.sf-reg{font-size:13px;font-weight:400;color:rgba(255,255,255,.4);line-height:1.7;max-width:700px}
.sf-copy{font-size:13px;font-weight:600;color:rgba(255,255,255,.5)}

/* ─── Responsive ─── */
@media(max-width:900px){
  .sn-links{display:none}
  .sn-hamburger{display:flex}
  .sn-login{display:none!important}
  .sn-cta{display:none}
  .sf-top{grid-template-columns:1fr 1fr;gap:28px}
  .sf-brand{grid-column:1/-1}
}
@media(max-width:600px){
  .site{overflow-x:hidden}
  .sw{padding:0 16px}
  .sf-top{grid-template-columns:1fr}
  .sf-contact-row{flex-direction:column;gap:8px}
  .sf{padding:48px 0 32px}
  .sf-btm{flex-direction:column;gap:12px;text-align:center}
  .cookie-bar{flex-direction:column;gap:12px;padding:16px;text-align:center}
  .cookie-text{font-size:13px}
  .cookie-btns{width:100%;display:flex;gap:8px}
  .cookie-accept,.cookie-decline{flex:1;padding:10px 16px;font-size:13px}
  .toast-container{right:12px;left:12px;top:76px}
  .toast-item{min-width:auto}
  .sn{height:60px;top:0}
  .sn-mobile{top:60px}
  .sn-logo{font-size:24px}
  .sn-cta{font-size:12px;padding:8px 16px}
  .sn-lang{font-size:13px;padding:7px 14px;border-width:2px}
  .sn-hamburger span{width:24px;height:3px}
  .sn-hamburger{gap:5px;padding:6px}
}

/* ─── Dark Mode Toggle ─── */
.sn-dark{background:none;border:1px solid rgba(255,255,255,.2);border-radius:8px;padding:6px 10px;cursor:pointer;font-size:14px;transition:all .2s;line-height:1}.sn-dark:hover{border-color:rgba(255,255,255,.5);background:rgba(255,255,255,.06)}

/* ─── Cookie Consent ─── */
.cookie-bar{position:fixed;bottom:0;left:0;right:0;background:#0C4A6E;color:#fff;padding:16px 24px;display:flex;align-items:center;justify-content:center;gap:16px;z-index:9999;box-shadow:0 -4px 24px rgba(0,0,0,.15);flex-wrap:wrap}
.cookie-text{font-size:14px;color:rgba(255,255,255,.8);max-width:600px;line-height:1.6}
.cookie-link{color:#7DD3FC;text-decoration:underline;font-weight:600}
.cookie-btns{display:flex;gap:8px}
.cookie-accept{padding:10px 24px;background:#0EA5E9;color:#fff;border:none;border-radius:10px;font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;transition:all .2s}.cookie-accept:hover{background:#0284C7}
.cookie-decline{padding:10px 24px;background:transparent;color:rgba(255,255,255,.6);border:1px solid rgba(255,255,255,.2);border-radius:10px;font-size:14px;font-weight:600;cursor:pointer;font-family:inherit;transition:all .2s}.cookie-decline:hover{border-color:rgba(255,255,255,.5)}
.cookie-enter-active,.cookie-leave-active{transition:all .4s ease}.cookie-enter-from,.cookie-leave-to{transform:translateY(100%);opacity:0}

/* ─── Toast Notifications ─── */
.toast-container{position:fixed;top:80px;right:24px;z-index:10000;display:flex;flex-direction:column;gap:8px}
.toast-item{padding:14px 24px;border-radius:12px;font-size:14px;font-weight:700;font-family:'Inter',sans-serif;box-shadow:0 8px 24px rgba(0,0,0,.12);min-width:280px;animation:toastIn .3s ease}
.toast-success{background:#059669;color:#fff}
.toast-error{background:#DC2626;color:#fff}
.toast-info{background:#0EA5E9;color:#fff}
.toast-enter-active{transition:all .3s ease}.toast-leave-active{transition:all .3s ease}
.toast-enter-from{opacity:0;transform:translateX(40px)}.toast-leave-to{opacity:0;transform:translateX(40px)}

/* ─── Dark Mode ─── */
.dark{background:#0a0a0a;color:#e0e0e0}
.dark .sn{background:linear-gradient(135deg,rgba(17,17,17,.85) 0%,rgba(26,26,46,.85) 100%);border-bottom:1px solid rgba(255,255,255,.06)}
.dark .sn.scrolled{background:linear-gradient(135deg,#111 0%,#1a1a2e 100%);box-shadow:0 4px 20px rgba(0,0,0,.4)}
.dark .mm{background:#1a1a2e;border-color:rgba(255,255,255,.08)}
.dark .mm-inner{background:#1a1a2e}
.dark .mm-col-h{color:rgba(255,255,255,.5)}
.dark .mm-item:hover{background:rgba(255,255,255,.04)}
.dark .mm-item-l{color:rgba(255,255,255,.85)}
.dark .mm-item-d{color:rgba(255,255,255,.35)}
.dark .sf{background:linear-gradient(180deg,#111 0%,#0a0a0a 100%)}
.dark main{background:#0a0a0a}
/* These dark overrides work with page content via CSS cascade */
.dark :deep(.sec){background:#0a0a0a;}
.dark :deep(.sec-alt){background:#111}
.dark :deep(.sec-cta){background:linear-gradient(135deg,#111,#1a1a2e)}
.dark :deep(.hero){background:linear-gradient(180deg,#111 0%,#0a0a0a 50%)}
.dark :deep(.t2){color:#e0e0e0}
.dark :deep(.t2-sub){color:rgba(255,255,255,.55)}
.dark :deep(.hero-h1){color:#e0e0e0}
.dark :deep(.hero-p){color:rgba(255,255,255,.55)}
.dark :deep(.cd-n){color:#e0e0e0}
.dark :deep(.cd-l){color:rgba(255,255,255,.35)}
.dark :deep(.trust-i){color:rgba(255,255,255,.4)}
.dark :deep(.conv-mini){background:#1a1a2e;border-color:rgba(255,255,255,.08)}
.dark :deep(.conv-sel){background:#222;border-color:rgba(255,255,255,.08);color:#e0e0e0}
.dark :deep(.conv-inp){background:#222;border-color:rgba(255,255,255,.08);color:#e0e0e0}
.dark :deep(.eml-i){color:#e0e0e0}
.dark :deep(.hero-eml){border-color:rgba(255,255,255,.2)}
.dark :deep(.comp-table){background:#1a1a2e;border-color:rgba(255,255,255,.06)}
.dark :deep(.comp-header){background:#222}
.dark :deep(.comp-header .comp-f),.dark :deep(.comp-header .comp-v){color:#e0e0e0}
.dark :deep(.comp-f){color:#e0e0e0}
.dark :deep(.comp-row){border-color:rgba(255,255,255,.04)}
.dark :deep(.serv-c),.dark :deep(.tier-c),.dark :deep(.test-c),.dark :deep(.more-c),.dark :deep(.feat-phone){background:#1a1a2e;border-color:rgba(255,255,255,.06)}
.dark :deep(.serv-t),.dark :deep(.tier-n),.dark :deep(.test-q){color:#e0e0e0}
.dark :deep(.serv-d),.dark :deep(.tier-feat),.dark :deep(.test-loc){color:rgba(255,255,255,.45)}
.dark :deep(.counters){background:rgba(255,255,255,.04);border-color:rgba(255,255,255,.04)}
.dark :deep(.ctr-i){background:#1a1a2e}
.dark :deep(.ctr-l){color:rgba(255,255,255,.4)}
.dark :deep(.feat-points li){background:rgba(255,255,255,.04);color:#e0e0e0}
.dark :deep(.fp-balance){background:#222}
.dark :deep(.fp-bv){color:#e0e0e0}
.dark :deep(.mq){background:#111;border-color:rgba(255,255,255,.03)}
.dark :deep(.mq-i){color:rgba(255,255,255,.06)}
.dark :deep(.cta-btn2){color:#e0e0e0;border-color:rgba(255,255,255,.15)}
.dark :deep(.link-btn){color:#38BDF8}

/* ─── Scroll Progress Bar ─── */
.scroll-progress{position:fixed;top:0;left:0;height:3px;background:linear-gradient(90deg,#9FE870,#2D6A00);z-index:10001;transition:width .1s linear;pointer-events:none;border-radius:0 2px 2px 0}

/* ─── Back to Top ─── */
.back-top{position:fixed;bottom:24px;right:24px;width:48px;height:48px;background:#163300;color:#fff;border:none;border-radius:50%;font-size:20px;font-weight:900;cursor:pointer;box-shadow:0 4px 16px rgba(22,51,0,.2);z-index:9998;transition:all .2s;display:flex;align-items:center;justify-content:center;font-family:'Inter',system-ui,sans-serif}
.back-top:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(22,51,0,.3)}
.back-top:active{transform:scale(.92)}
.rtl .back-top{right:auto;left:24px}
.btt-enter-active,.btt-leave-active{transition:all .3s cubic-bezier(.16,1,.3,1)}
.btt-enter-from,.btt-leave-to{opacity:0;transform:translateY(16px) scale(.8)}

/* ─── Touch Active States ─── */
@media(hover:none){
  .sn-cta:active,.cta-btn:active,.eml-b:active,.conv-cta:active,.cookie-accept:active,.back-top:active{transform:scale(.95)!important;opacity:.85}
  .sn-mob-link:active,.mob-sec-btn:active{background:rgba(255,255,255,.1)}
  .mm-item:active{background:rgba(14,165,233,.08)}
}

/* ─── Dark mode for new components ─── */
.dark .scroll-progress{background:linear-gradient(90deg,#38BDF8,#0EA5E9)}
.dark .back-top{background:linear-gradient(135deg,#1a1a2e,#0C4A6E);box-shadow:0 4px 16px rgba(0,0,0,.4)}

/* ─── Social Proof Ticker ─── */
.social-proof{position:fixed;bottom:24px;left:24px;display:flex;align-items:center;gap:8px;padding:10px 18px;background:#fff;border:1px solid rgba(14,165,233,.1);border-radius:50px;box-shadow:0 4px 16px rgba(0,0,0,.08);z-index:9997;font-size:13px;font-weight:700;color:#0C4A6E}
.rtl .social-proof{left:auto;right:24px}
.sp-dot{width:8px;height:8px;background:#10B981;border-radius:50%;animation:pulse-dot 2s infinite}
@keyframes pulse-dot{0%,100%{opacity:1;transform:scale(1)}50%{opacity:.5;transform:scale(1.3)}}
.sp-text{white-space:nowrap}
.dark .social-proof{background:#1a1a2e;border-color:rgba(255,255,255,.06);color:#e0e0e0}

/* ─── Exit Intent Popup ─── */
.exit-overlay{position:fixed;inset:0;background:rgba(0,0,0,.6);backdrop-filter:blur(8px);z-index:10002;display:flex;align-items:center;justify-content:center;padding:16px}
.exit-modal{background:#fff;border-radius:24px;padding:48px 40px;text-align:center;max-width:420px;width:100%;position:relative;box-shadow:0 24px 64px rgba(0,0,0,.2);animation:modalBounce .4s cubic-bezier(.16,1,.3,1)}
@keyframes modalBounce{from{transform:scale(.85);opacity:0}to{transform:scale(1);opacity:1}}
.exit-close{position:absolute;top:16px;right:16px;background:none;border:none;font-size:24px;color:rgba(0,0,0,.3);cursor:pointer;padding:4px;line-height:1}
.rtl .exit-close{right:auto;left:16px}
.exit-ic{font-size:48px;margin-bottom:16px}
.exit-title{font-size:24px;font-weight:900;color:#0C4A6E;margin-bottom:12px}
.exit-desc{font-size:15px;color:rgba(10,10,10,.6);line-height:1.8;margin-bottom:24px}
.exit-btn{display:block;padding:16px 32px;background:linear-gradient(135deg,#0284C7,#0EA5E9);color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s;margin-bottom:12px}.exit-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(14,165,233,.25)}
.exit-skip{background:none;border:none;color:rgba(10,10,10,.4);font-size:14px;font-weight:600;cursor:pointer;padding:4px 8px;font-family:inherit}
.dark .exit-modal{background:#1a1a2e}.dark .exit-title{color:#e0e0e0}.dark .exit-desc{color:rgba(255,255,255,.6)}.dark .exit-close{color:rgba(255,255,255,.3)}
.modal-enter-active,.modal-leave-active{transition:all .3s ease}
.modal-enter-from,.modal-leave-to{opacity:0}
.modal-enter-from .exit-modal,.modal-leave-to .exit-modal{transform:scale(.85)}

@media(max-width:600px){
  .social-proof{bottom:16px;left:12px;right:12px;justify-content:center;font-size:12px;padding:8px 14px}
  .rtl .social-proof{left:12px;right:12px}
  .exit-modal{padding:32px 24px;margin:0 16px}
  .exit-title{font-size:20px}
  .sn-bell{display:none}
  .cur-widget{bottom:70px;right:12px}
  .rtl .cur-widget{right:auto;left:12px}
  .sf-badges{flex-wrap:wrap;justify-content:center}
  .sf-share{justify-content:center}
}

/* ─── Notification Bell ─── */
.sn-bell{background:none;border:none;font-size:18px;cursor:pointer;position:relative;padding:4px 6px;line-height:1}
.bell-dot{position:absolute;top:2px;right:2px;width:8px;height:8px;background:#DC2626;border-radius:50%;animation:pulse-dot 2s infinite}
.notif-dd{position:absolute;top:60px;right:0;width:320px;background:#fff;border-radius:16px;box-shadow:0 8px 32px rgba(0,0,0,.12);z-index:9999;overflow:hidden;border:1px solid rgba(14,165,233,.06)}
.rtl .notif-dd{right:auto;left:0}
.notif-head{padding:14px 18px;font-size:13px;font-weight:800;color:#0C4A6E;border-bottom:1px solid rgba(14,165,233,.06)}
.notif-item{display:flex;align-items:flex-start;gap:10px;padding:12px 18px;border-bottom:1px solid rgba(14,165,233,.03);transition:background .2s}.notif-item:hover{background:rgba(14,165,233,.03)}
.notif-ic{font-size:20px;flex-shrink:0;margin-top:2px}
.notif-body{flex:1;min-width:0}
.notif-title{font-size:13px;font-weight:700;color:#0C4A6E;margin-bottom:2px}
.notif-desc{font-size:12px;color:rgba(10,10,10,.5);line-height:1.5}
.notif-time{font-size:11px;color:rgba(10,10,10,.3);white-space:nowrap;flex-shrink:0}
.dd-enter-active,.dd-leave-active{transition:all .2s ease}
.dd-enter-from,.dd-leave-to{opacity:0;transform:translateY(-8px)}
.dark .notif-dd{background:#1a1a2e;border-color:rgba(255,255,255,.06)}
.dark .notif-head{color:#e0e0e0;border-color:rgba(255,255,255,.06)}
.dark .notif-title{color:#e0e0e0}.dark .notif-desc{color:rgba(255,255,255,.4)}
.dark .notif-item:hover{background:rgba(255,255,255,.03)}

/* ─── SSL Badges ─── */
.sf-badges{display:flex;gap:10px;margin-bottom:16px}
.sf-badge{padding:6px 14px;background:rgba(159,232,112,.1);border:1px solid rgba(159,232,112,.15);border-radius:50px;font-size:11px;font-weight:700;color:rgba(255,255,255,.7)}
.dark .sf-badge{background:rgba(255,255,255,.04);border-color:rgba(255,255,255,.06);color:rgba(255,255,255,.5)}

/* ─── Share Buttons ─── */
.sf-share{display:flex;align-items:center;gap:10px;margin-bottom:16px}
.sf-share-label{font-size:12px;color:rgba(255,255,255,.4);font-weight:600}
.sf-share-btn{display:flex;align-items:center;justify-content:center;width:36px;height:36px;background:rgba(255,255,255,.06);border-radius:50%;font-size:16px;text-decoration:none;transition:all .2s;border:1px solid rgba(255,255,255,.08)}.sf-share-btn:hover{background:rgba(14,165,233,.2);transform:translateY(-2px)}

/* ─── Floating Currency Widget ─── */
.cur-widget{position:fixed;bottom:80px;right:24px;z-index:9996}
.rtl .cur-widget{right:auto;left:24px}
.cur-trigger{display:flex;align-items:center;gap:6px;padding:10px 18px;background:linear-gradient(135deg,#0284C7,#0EA5E9);color:#fff;border:none;border-radius:50px;font-size:13px;font-weight:800;cursor:pointer;box-shadow:0 4px 16px rgba(14,165,233,.25);transition:all .2s;font-family:'Inter',sans-serif}.cur-trigger:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(14,165,233,.3)}
.cur-body{position:absolute;bottom:52px;right:0;width:240px;background:#fff;border-radius:16px;box-shadow:0 8px 32px rgba(0,0,0,.12);padding:12px;border:1px solid rgba(14,165,233,.06);animation:modalBounce .3s cubic-bezier(.16,1,.3,1)}
.rtl .cur-body{right:auto;left:0}
.cur-row{display:flex;align-items:center;gap:8px;padding:8px;border-radius:8px;transition:background .2s}.cur-row:hover{background:rgba(14,165,233,.03)}
.cur-flag{font-size:18px}
.cur-pair{font-size:12px;font-weight:700;color:#0C4A6E;flex:1}
.cur-val{font-size:13px;font-weight:800;color:#0EA5E9}
.cur-link{display:block;text-align:center;padding:8px;font-size:12px;font-weight:700;color:#0EA5E9;text-decoration:none;border-top:1px solid rgba(14,165,233,.06);margin-top:4px}.cur-link:hover{color:#0284C7}
.dark .cur-body{background:#1a1a2e;border-color:rgba(255,255,255,.06)}
.dark .cur-pair{color:#e0e0e0}
.dark .cur-row:hover{background:rgba(255,255,255,.03)}
.dark .cur-trigger{background:linear-gradient(135deg,#1a1a2e,#0C4A6E)}

/* ─── Get the App Modal ─── */
.app-modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,.6);backdrop-filter:blur(12px);z-index:10003;display:flex;align-items:center;justify-content:center;padding:24px}
.app-modal-card{background:#fff;border-radius:28px;padding:48px 40px;text-align:center;max-width:420px;width:100%;position:relative;box-shadow:0 32px 80px rgba(0,0,0,.2);animation:modalBounce .4s cubic-bezier(.16,1,.3,1)}
.app-modal-close{position:absolute;top:16px;right:16px;background:none;border:none;font-size:28px;color:#aaa;cursor:pointer;padding:4px;line-height:1;transition:color .2s}.app-modal-close:hover{color:#333}
.rtl .app-modal-close{right:auto;left:16px}
.app-modal-logo{height:48px;margin-bottom:20px}
.app-modal-title{font-size:24px;font-weight:900;color:#163300;margin-bottom:10px;letter-spacing:-.02em}
.app-modal-desc{font-size:15px;color:#666;line-height:1.7;margin-bottom:28px}
.app-modal-stores{display:flex;gap:12px;justify-content:center;margin-bottom:24px}
.app-store-btn{display:flex;align-items:center;gap:10px;padding:12px 20px;background:#163300;border-radius:12px;color:#fff;text-decoration:none;transition:all .2s}.app-store-btn:hover{background:#1e4400;transform:translateY(-2px);box-shadow:0 4px 16px rgba(22,51,0,.2)}
.app-store-btn small{display:block;font-size:9px;color:rgba(255,255,255,.6);font-weight:400}
.app-store-btn strong{display:block;font-size:14px;font-weight:800}
.app-modal-hint{font-size:12px;color:#999;margin-bottom:16px}
.app-modal-biz-link{background:none;border:none;color:#2D6A00;font-size:13px;font-weight:700;cursor:pointer;font-family:inherit;transition:color .2s;padding:0}.app-modal-biz-link:hover{color:#163300;text-decoration:underline}
.dark .app-modal-card{background:#1a1a2e}.dark .app-modal-title{color:#e0e0e0}.dark .app-modal-desc{color:rgba(255,255,255,.5)}
@media(max-width:600px){.app-modal-card{padding:36px 24px}.app-modal-stores{flex-direction:column}.app-store-btn{justify-content:center}}
</style>
