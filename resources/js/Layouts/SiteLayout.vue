<script setup>
import { Link } from '@inertiajs/vue3';
import { ref, computed, provide } from 'vue';

const props = defineProps({ page: { type: String, default: '' } });

/* ─── Language System ─── */
const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');
function toggleLang() { lang.value = lang.value === 'ar' ? 'en' : 'ar'; }
provide('lang', lang);
provide('isAr', isAr);

/* ─── Mobile Menu ─── */
const mobileOpen = ref(false);

/* ─── Nav Links ─── */
const navLinks = computed(() => isAr.value ? [
  { href: '/', label: 'الرئيسية', id: 'home' },
  { href: '/salary', label: 'المعاشات', id: 'salary' },
  { href: '/cards-info', label: 'البطاقات', id: 'cards' },
  { href: '/currencies', label: 'العملات', id: 'currencies' },
  { href: '/transfers-info', label: 'التحويلات', id: 'transfers' },
  { href: '/about', label: 'عنّا', id: 'about' },
] : [
  { href: '/', label: 'Home', id: 'home' },
  { href: '/salary', label: 'Salary', id: 'salary' },
  { href: '/cards-info', label: 'Cards', id: 'cards' },
  { href: '/currencies', label: 'Currencies', id: 'currencies' },
  { href: '/transfers-info', label: 'Transfers', id: 'transfers' },
  { href: '/about', label: 'About', id: 'about' },
]);

/* ─── Footer ─── */
const t = computed(() => isAr.value ? {
  cta: 'افتح حسابك',
  // Footer columns
  col1h: 'الخدمات',
  col1: [
    { label: 'المعاشات', href: '/salary' },
    { label: 'البطاقات', href: '/cards-info' },
    { label: 'التحويلات', href: '/transfers-info' },
    { label: 'العملات', href: '/currencies' },
    { label: 'دفع الفواتير (قريباً)', href: '#' },
  ],
  col2h: 'الحسابات',
  col2: [
    { label: 'حساب شخصي', href: '/preregister' },
    { label: 'حساب عائلي', href: '/preregister' },
    { label: 'حساب تجاري', href: '/preregister' },
    { label: 'حساب توفير', href: '/preregister' },
  ],
  col3h: 'المساعدة',
  col3: [
    { label: 'تواصل معنا', href: '/support' },
    { label: 'مركز المساعدة', href: '/faq' },
    { label: 'الأسئلة الشائعة', href: '/faq' },
  ],
  col4h: 'الأمان والحماية',
  col4: [
    { label: 'كيف نحمي أموالك', href: '/about' },
    { label: 'إبلاغ عن احتيال', href: '/support' },
    { label: 'أمان البطاقات', href: '/cards-info' },
  ],
  col5h: 'الشركة',
  col5: [
    { label: 'عنّا', href: '/about' },
    { label: 'الشروط والأحكام', href: '/terms' },
    { label: 'سياسة الخصوصية', href: '/privacy' },
    { label: 'الامتثال والتراخيص', href: '/about' },
  ],
  col6h: 'تواصل معنا',
  ftDesc: 'أول بنك إلكتروني سوري — مرخّص في الدنمارك بمعايير أوروبية.\nمصمم لخدمة كل سوري بالعالم.',
  ftCopy: '© 2026 SDB Bank ApS. جميع الحقوق محفوظة.',
  ftReg: 'SDB Bank ApS مسجّلة في الدنمارك. خاضعة لرقابة الجهات المالية الأوروبية. جميع الأموال محمية وفقاً لمعايير الاتحاد الأوروبي.',
} : {
  cta: 'Open Account',
  col1h: 'Services',
  col1: [
    { label: 'Salary Deposits', href: '/salary' },
    { label: 'Cards', href: '/cards-info' },
    { label: 'Transfers', href: '/transfers-info' },
    { label: 'Currencies', href: '/currencies' },
    { label: 'Bill Payments (Soon)', href: '#' },
  ],
  col2h: 'Accounts',
  col2: [
    { label: 'Personal Account', href: '/preregister' },
    { label: 'Family Account', href: '/preregister' },
    { label: 'Business Account', href: '/preregister' },
    { label: 'Savings Account', href: '/preregister' },
  ],
  col3h: 'Help',
  col3: [
    { label: 'Contact Us', href: '/support' },
    { label: 'Help Centre', href: '/faq' },
    { label: 'FAQ', href: '/faq' },
  ],
  col4h: 'Security & Protection',
  col4: [
    { label: 'How We Protect You', href: '/about' },
    { label: 'Report Fraud', href: '/support' },
    { label: 'Card Security', href: '/cards-info' },
  ],
  col5h: 'Company',
  col5: [
    { label: 'About Us', href: '/about' },
    { label: 'Terms of Service', href: '/terms' },
    { label: 'Privacy Policy', href: '/privacy' },
    { label: 'Compliance', href: '/about' },
  ],
  col6h: 'Contact',
  ftDesc: 'The first Syrian digital bank — licensed in Denmark with European standards.\nDesigned to serve every Syrian worldwide.',
  ftCopy: '© 2026 SDB Bank ApS. All rights reserved.',
  ftReg: 'SDB Bank ApS is registered in Denmark. Subject to European financial regulations. All funds are protected under EU standards.',
});
</script>

<template>
<div class="site" :class="{ rtl: isAr }" :dir="isAr ? 'rtl' : 'ltr'">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />

  <!-- Nav -->
  <nav class="sn">
    <div class="sw">
      <Link href="/" class="sn-logo">SDB<span class="sn-dot">.</span></Link>
      <div class="sn-links">
        <Link v-for="l in navLinks" :key="l.id" :href="l.href" class="sn-link" :class="{'sn-active': page===l.id}">{{ l.label }}</Link>
      </div>
      <div class="sn-right">
        <button @click="toggleLang" class="sn-lang">{{ isAr ? 'EN' : 'عربي' }}</button>
        <Link href="/preregister" class="sn-cta">{{ t.cta }}</Link>
        <button @click="mobileOpen=!mobileOpen" class="sn-hamburger">
          <span></span><span></span><span></span>
        </button>
      </div>
    </div>
    <!-- Mobile menu -->
    <div v-if="mobileOpen" class="sn-mobile">
      <Link v-for="l in navLinks" :key="l.id" :href="l.href" class="sn-mob-link" @click="mobileOpen=false">{{ l.label }}</Link>
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
      <!-- Top: Logo + description -->
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
        <!-- 5 columns -->
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

      <!-- Contact row -->
      <div class="sf-contact">
        <div class="sf-col-h" style="margin-bottom:12px">{{ t.col6h }}</div>
        <div class="sf-contact-row">
          <span class="sf-contact-item">📧 info@sdb-bank.com</span>
          <span class="sf-contact-item">📞 +45 42 80 55 94</span>
          <span class="sf-contact-item">📍 Denmark 🇩🇰</span>
        </div>
      </div>

      <!-- Bottom bar -->
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

/* ─── Nav ─── */
.sn{position:fixed;top:0;left:0;right:0;z-index:99;height:64px;display:flex;align-items:center;background:rgba(10,10,10,.97);backdrop-filter:blur(20px) saturate(1.8)}
.sn .sw{display:flex;align-items:center;justify-content:space-between;width:100%}
.sn-logo{font-size:26px;font-weight:900;color:#fff;text-decoration:none;letter-spacing:-1.5px;flex-shrink:0}
.sn-dot{color:#2563EB;font-size:30px;line-height:0}
.sn-links{display:flex;gap:28px;margin:0 auto}
.sn-link{font-size:13.5px;font-weight:500;color:rgba(255,255,255,.45);text-decoration:none;transition:color .2s;letter-spacing:.2px}.sn-link:hover{color:rgba(255,255,255,.85)}
.sn-active{color:#fff!important;font-weight:600}
.sn-right{display:flex;align-items:center;gap:10px}
.sn-lang{font-size:13px;font-weight:600;color:rgba(255,255,255,.5);background:transparent;border:1.5px solid rgba(255,255,255,.12);padding:7px 16px;border-radius:8px;cursor:pointer;transition:all .2s;font-family:inherit}.sn-lang:hover{border-color:rgba(255,255,255,.3);color:#fff}
.sn-cta{font-size:13px;font-weight:700;color:#0a0a0a;background:#fff;padding:9px 22px;border-radius:10px;text-decoration:none;transition:all .2s;border:none;white-space:nowrap}.sn-cta:hover{background:rgba(255,255,255,.88);transform:translateY(-1px)}
.sn-hamburger{display:none;flex-direction:column;gap:5px;background:none;border:none;cursor:pointer;padding:4px}
.sn-hamburger span{width:22px;height:2px;background:#fff;border-radius:2px;transition:all .2s}

/* Mobile nav */
.sn-mobile{position:fixed;top:64px;left:0;right:0;background:#0a0a0a;padding:20px 24px;display:flex;flex-direction:column;gap:4px;border-top:1px solid rgba(255,255,255,.06);z-index:98}
.sn-mob-link{font-size:15px;color:rgba(255,255,255,.6);text-decoration:none;padding:12px 0;border-bottom:1px solid rgba(255,255,255,.04);font-weight:500}
.sn-mob-cta{text-align:center;margin-top:8px}

/* ─── Mega Footer ─── */
.sf{background:#0a0a0a;padding:80px 0 0;color:#fff;margin-top:auto}
.sf-top{display:grid;grid-template-columns:1.8fr repeat(5,1fr);gap:32px;padding-bottom:48px;border-bottom:1px solid rgba(255,255,255,.06)}
.sf-brand{display:flex;flex-direction:column;gap:12px}
.sn-logo-ft{font-size:22px;display:inline-block;margin-bottom:4px}
.sf-desc{font-size:12.5px;color:rgba(255,255,255,.25);line-height:1.8;white-space:pre-line;max-width:280px}
.sf-social{display:flex;gap:8px;margin-top:4px}
.sf-soc-icon{width:32px;height:32px;display:flex;align-items:center;justify-content:center;border:1px solid rgba(255,255,255,.08);border-radius:8px;font-size:11px;font-weight:800;color:rgba(255,255,255,.3);cursor:pointer;transition:all .2s}.sf-soc-icon:hover{border-color:rgba(255,255,255,.2);color:#fff}
.sf-col{display:flex;flex-direction:column;gap:10px}
.sf-col-h{font-size:11px;font-weight:800;letter-spacing:1.2px;text-transform:uppercase;color:rgba(255,255,255,.2);margin-bottom:4px}
.rtl .sf-col-h{letter-spacing:0}
.sf-link{font-size:13px;color:rgba(255,255,255,.35);text-decoration:none;transition:color .2s;line-height:1.4}.sf-link:hover{color:rgba(255,255,255,.7)}
.sf-contact{padding:28px 0;border-bottom:1px solid rgba(255,255,255,.06)}
.sf-contact-row{display:flex;gap:32px;flex-wrap:wrap}
.sf-contact-item{font-size:13px;color:rgba(255,255,255,.3)}
.sf-bottom{padding:24px 0;display:flex;flex-direction:column;gap:12px}
.sf-reg{font-size:11px;color:rgba(255,255,255,.12);line-height:1.7;max-width:700px}
.sf-copy{font-size:11px;color:rgba(255,255,255,.15)}

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
