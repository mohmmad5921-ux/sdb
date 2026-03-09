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

/* ─── Mobile Menu ─── */
const mobileOpen = ref(false);

/* ─── Mega Menu ─── */
const activeMenu = ref(null);
let closeTimer = null;
function openMenu(id) { clearTimeout(closeTimer); activeMenu.value = id; }
function startClose() { closeTimer = setTimeout(() => { activeMenu.value = null; }, 200); }
function cancelClose() { clearTimeout(closeTimer); }
function closeAll() { activeMenu.value = null; }

/* Close on scroll */
function onScroll() { activeMenu.value = null; }
onMounted(() => window.addEventListener('scroll', onScroll));
onBeforeUnmount(() => window.removeEventListener('scroll', onScroll));

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
<div class="site" :class="{ rtl: isAr }" :dir="isAr ? 'rtl' : 'ltr'">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />

  <!-- Nav -->
  <nav class="sn">
    <div class="sw">
      <Link href="/" class="sn-logo">SDB<span class="sn-dot">.</span></Link>
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
        <button @click="toggleLang" class="sn-lang">{{ isAr ? 'EN' : 'عربي' }}</button>
        <Link href="/preregister" class="sn-cta">{{ t.cta }}</Link>
        <button @click="mobileOpen=!mobileOpen" class="sn-hamburger">
          <span></span><span></span><span></span>
        </button>
      </div>
    </div>
    <!-- Mobile mega menu -->
    <div v-if="mobileOpen" class="sn-mobile">
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
    </div>
  </nav>

  <!-- Page Content -->
  <main>
    <slot />
  </main>

  <!-- Mega Footer -->
  <footer class="sf">
    <div class="sw">
      <div class="sf-top">
        <div class="sf-brand">
          <a href="/" class="sn-logo sn-logo-ft">SDB<span class="sn-dot">.</span></a>
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
          <span class="sf-contact-item">📞 +45 42 80 55 94</span>
          <span class="sf-contact-item">📍 Denmark 🇩🇰</span>
        </div>
      </div>

      <div class="sf-bottom">
        <p class="sf-reg">{{ t.ftReg }}</p>
        <span class="sf-copy">{{ t.ftCopy }}</span>
      </div>
    </div>
  </footer>
</div>
</template>

<style>
/* ─── Global Reset ─── */
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth}
.site{font-family:'Inter',system-ui,-apple-system,sans-serif;color:#0a0a0a;overflow-x:hidden;min-height:100vh;display:flex;flex-direction:column}
.site>main{flex:1}
.sw{max-width:1200px;margin:0 auto;padding:0 24px}
.rtl{direction:rtl;text-align:right}
.rtl .text-center{text-align:center}

/* ─── Nav — Vibrant Sky Blue ─── */
.sn{position:fixed;top:0;left:0;right:0;z-index:99;height:68px;display:flex;align-items:center;background:linear-gradient(135deg,#0284C7 0%,#0EA5E9 50%,#38BDF8 100%);backdrop-filter:blur(20px);box-shadow:0 4px 20px rgba(2,132,199,.25)}
.sn .sw{display:flex;align-items:center;justify-content:space-between;width:100%}
.sn-logo{font-size:28px;font-weight:900;color:#fff;text-decoration:none;letter-spacing:-1.5px;flex-shrink:0;text-shadow:0 2px 8px rgba(0,0,0,.15)}
.sn-dot{color:#E0F2FE;font-size:32px;line-height:0}
.sn-links{display:flex;gap:4px;margin:0 auto}
.sn-dd{position:relative}
.sn-link{font-size:15px;font-weight:600;color:rgba(255,255,255,.9);text-decoration:none;transition:all .2s;letter-spacing:.2px;cursor:pointer;padding:8px 14px;border-radius:8px;display:flex;align-items:center;gap:4px;user-select:none}
.sn-link:hover,.sn-active{color:#fff!important;background:rgba(255,255,255,.15)}
.sn-arr{font-size:10px;opacity:.7;transition:transform .2s}
.sn-active .sn-arr{transform:rotate(180deg);opacity:.8}
.sn-right{display:flex;align-items:center;gap:10px}
.sn-lang{font-size:14px;font-weight:700;color:#fff;background:rgba(255,255,255,.2);border:1.5px solid rgba(255,255,255,.35);padding:8px 18px;border-radius:8px;cursor:pointer;transition:all .2s;font-family:inherit;backdrop-filter:blur(8px)}.sn-lang:hover{background:rgba(255,255,255,.3);border-color:rgba(255,255,255,.5)}
.sn-cta{font-size:14px;font-weight:800;color:#0284C7;background:#fff;padding:10px 24px;border-radius:10px;text-decoration:none;transition:all .2s;border:none;white-space:nowrap;box-shadow:0 2px 8px rgba(0,0,0,.1)}.sn-cta:hover{background:#F0F9FF;transform:translateY(-1px);box-shadow:0 4px 12px rgba(0,0,0,.15)}
.sn-hamburger{display:none;flex-direction:column;gap:5px;background:none;border:none;cursor:pointer;padding:4px}
.sn-hamburger span{width:22px;height:2px;background:#fff;border-radius:2px;transition:all .2s}

/* ─── Mega Menu Dropdown ─── */
.mm{position:absolute;top:calc(100% + 12px);left:50%;transform:translateX(-50%);min-width:480px;z-index:100}
.rtl .mm{left:auto;right:50%;transform:translateX(50%)}
.mm-inner{background:#fff;border-radius:16px;box-shadow:0 16px 48px rgba(0,0,0,.12),0 0 0 1px rgba(14,165,233,.06);padding:24px;display:grid;grid-template-columns:repeat(2,1fr);gap:24px}
.mm::before{content:'';position:absolute;top:-6px;left:50%;margin-left:-6px;border-left:6px solid transparent;border-right:6px solid transparent;border-bottom:6px solid #fff}
.rtl .mm::before{left:auto;right:50%;margin-left:0;margin-right:-6px}
.mm-col-h{font-size:10px;font-weight:800;letter-spacing:1.5px;text-transform:uppercase;color:rgba(14,165,233,.5);margin-bottom:10px;padding-bottom:6px;border-bottom:1px solid rgba(14,165,233,.06)}
.rtl .mm-col-h{letter-spacing:0}
.mm-item{display:flex;flex-direction:column;gap:2px;padding:10px 12px;border-radius:10px;text-decoration:none;transition:all .15s}.mm-item:hover{background:rgba(14,165,233,.04)}
.mm-item-l{font-size:13.5px;font-weight:700;color:#0C4A6E}
.mm-item-d{font-size:11px;color:rgba(10,10,10,.3)}

/* Mega menu transition */
.mm-enter-active{animation:mmIn .2s ease}.mm-leave-active{animation:mmIn .15s ease reverse}
@keyframes mmIn{from{opacity:0;transform:translateX(-50%) translateY(8px)}to{opacity:1;transform:translateX(-50%) translateY(0)}}

/* Mobile nav */
.sn-mobile{position:fixed;top:68px;left:0;right:0;bottom:0;background:linear-gradient(180deg,#0284C7,#0369A1);padding:20px 24px;display:flex;flex-direction:column;gap:2px;border-top:1px solid rgba(255,255,255,.15);z-index:98;box-shadow:0 8px 24px rgba(0,0,0,.2);overflow-y:auto}
.sn-mob-link{font-size:15px;color:rgba(255,255,255,.8);text-decoration:none;padding:12px 0;border-bottom:1px solid rgba(255,255,255,.08);font-weight:500}
.sn-mob-cta{text-align:center;margin-top:12px}
.mob-sec{border-bottom:1px solid rgba(255,255,255,.08)}
.mob-sec-btn{width:100%;text-align:start;padding:12px 0;background:none;border:none;font-size:15px;font-weight:600;color:rgba(255,255,255,.8);cursor:pointer;font-family:inherit;display:flex;justify-content:space-between;align-items:center}
.rtl .mob-sec-btn{text-align:right}
.mob-arr{font-size:12px;transition:transform .2s;color:rgba(255,255,255,.4)}.mob-arr-open{transform:rotate(90deg)}
.mob-sec-body{padding-bottom:8px}
.mob-col-h{font-size:10px;font-weight:800;letter-spacing:1px;text-transform:uppercase;color:rgba(255,255,255,.3);padding:6px 12px 4px}
.mob-sub{padding:8px 16px;font-size:13px;color:rgba(255,255,255,.6);border:none}

/* ─── Mega Footer — Deep Navy Blue ─── */
.sf{background:linear-gradient(180deg,#0C1B2E 0%,#0A1628 100%);padding:80px 0 0;color:#fff;margin-top:auto}
.sf-top{display:grid;grid-template-columns:1.8fr repeat(5,1fr);gap:32px;padding-bottom:48px;border-bottom:1px solid rgba(56,189,248,.08)}
.sf-brand{display:flex;flex-direction:column;gap:12px}
.sn-logo-ft{font-size:22px;display:inline-block;margin-bottom:4px}
.sf-desc{font-size:15px;font-weight:400;color:rgba(255,255,255,.6);line-height:1.8;white-space:pre-line;max-width:300px}
.sf-social{display:flex;gap:8px;margin-top:4px}
.sf-soc-icon{width:36px;height:36px;display:flex;align-items:center;justify-content:center;border:1px solid rgba(255,255,255,.25);border-radius:8px;font-size:13px;font-weight:800;color:rgba(255,255,255,.6);cursor:pointer;transition:all .2s}.sf-soc-icon:hover{border-color:rgba(255,255,255,.5);color:#fff;background:rgba(255,255,255,.1)}
.sf-col{display:flex;flex-direction:column;gap:10px}
.sf-col-h{font-size:14px;font-weight:800;letter-spacing:1.2px;text-transform:uppercase;color:#fff;margin-bottom:10px}
.rtl .sf-col-h{letter-spacing:0}
.sf-link{font-size:15px;font-weight:500;color:rgba(255,255,255,.7);text-decoration:none;transition:color .2s;line-height:1.7}.sf-link:hover{color:#fff}
.sf-contact{padding:28px 0;border-bottom:1px solid rgba(56,189,248,.08)}
.sf-contact-row{display:flex;gap:32px;flex-wrap:wrap}
.sf-contact-item{font-size:15px;font-weight:600;color:rgba(255,255,255,.75)}
.sf-bottom{padding:24px 0;display:flex;flex-direction:column;gap:12px}
.sf-reg{font-size:13px;font-weight:400;color:rgba(255,255,255,.4);line-height:1.7;max-width:700px}
.sf-copy{font-size:13px;font-weight:600;color:rgba(255,255,255,.5)}

/* ─── Responsive ─── */
@media(max-width:900px){
  .sn-links{display:none}
  .sn-hamburger{display:flex}
  .sf-top{grid-template-columns:1fr 1fr;gap:28px}
  .sf-brand{grid-column:1/-1}
}
@media(max-width:600px){
  .sf-top{grid-template-columns:1fr}
  .sf-contact-row{flex-direction:column;gap:8px}
}
</style>
