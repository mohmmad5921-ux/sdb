<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed, ref } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));

const showToast = inject('showToast', () => {});
const comingSoonMsg = computed(() => isAr.value ? '📱 التطبيق سيكون متاحاً قريباً في المتجر!' : '📱 The app will be available soon in the store!');
function handleBadgeClick(e) {
  e.preventDefault();
  showToast(comingSoonMsg.value, 'success');
}

const t = computed(() => isAr.value ? {
  title: 'تطبيق SDB Bank', tag: 'التطبيق الرسمي',
  heroH: 'كل خدماتك البنكية', heroEm: 'في جيبك.',
  heroP: 'تطبيق SDB Bank — أول بنك رقمي سوري بمعايير أوروبية. واجهة عربية كاملة، تجربة سلسة، وأمان بمستوى عالمي.',
  heroBtn: 'حمّل مجاناً',
  features: [
    { icon: '🏦', title: 'لوحة تحكم ذكية', desc: 'نظرة شاملة على أرصدتك وعملياتك الأخيرة وإحصائيات مصاريفك — كلها بنظرة واحدة.' },
    { icon: '💳', title: 'بطاقات رقمية', desc: 'أصدر بطاقتك الرقمية فوراً. تجميد وإلغاء تجميد بلمسة. حدود إنفاق قابلة للتخصيص.' },
    { icon: '💸', title: 'تحويلات فورية', desc: 'أرسل واستقبل بأي عملة. دفع بـ QR Code، جهات اتصال محفوظة، تحويلات مجدولة.' },
    { icon: '💱', title: 'صرف عملات', desc: '30+ عملة بأسعار السوق الحقيقية. رسوم بيانية حية وتنبيهات أسعار تلقائية.' },
    { icon: '📊', title: 'تحليلات مالية', desc: 'تصنيف تلقائي للمصاريف، ميزانيات شهرية، أهداف ادخار وتقارير مفصّلة.' },
    { icon: '🪪', title: 'هوية رقمية', desc: 'تحقق من هويتك بمسح الجواز أو الهوية. مصادقة بيومترية بالبصمة أو الوجه.' },
    { icon: '🤖', title: 'مساعد AI ذكي', desc: 'دردش مع SDB AI للحصول على مساعدة فورية بأي سؤال عن حسابك أو خدماتنا.' },
    { icon: '🔐', title: 'أمان عسكري', desc: 'تشفير AES-256 من طرف لطرف. مصادقة ثنائية، إشعارات أمنية فورية لكل عملية.' },
  ],
  statsTitle: 'أرقام تتحدث',
  stats: [
    { val: '30+', label: 'عملة مدعومة' },
    { val: '24/7', label: 'دعم متواصل' },
    { val: 'AES-256', label: 'تشفير' },
    { val: '< 3s', label: 'سرعة التحويل' },
  ],
  specTitle: 'المواصفات التقنية',
  specs: [
    { icon: '', label: 'iOS', val: '15.0+', sub: 'iPhone 8 وأحدث' },
    { icon: '🤖', label: 'Android', val: '8.0+', sub: 'معظم الأجهزة' },
    { icon: '📦', label: 'الحجم', val: '~65 MB', sub: 'تحميل سريع' },
    { icon: '🌐', label: 'اللغات', val: 'عربي + English', sub: 'تبديل فوري' },
    { icon: '🔄', label: 'التحديثات', val: 'أسبوعية', sub: 'ميزات جديدة' },
    { icon: '🛡️', label: 'الأمان', val: 'AES-256', sub: 'تشفير عسكري' },
  ],
  highlights: [
    'واجهة عربية RTL كاملة', 'وضع داكن / فاتح', 'مصادقة بيومترية',
    'إشعارات فورية', 'دعم QR Code', 'NFC للدفع',
    'بحث ذكي', 'كشف حساب PDF', 'مشاركة تفاصيل الدفع',
    'Apple Wallet', 'تداول العملات الرقمية', 'شات دعم مباشر',
  ],
  ctaH: 'جاهز تبدأ؟', ctaP: 'حمّل التطبيق مجاناً وافتح حسابك خلال دقائق.',
} : {
  title: 'SDB Bank App', tag: 'Official App',
  heroH: 'All your banking', heroEm: 'in your pocket.',
  heroP: 'SDB Bank app — the first Syrian digital bank with European standards. Full Arabic interface, seamless experience, and world-class security.',
  heroBtn: 'Download Free',
  features: [
    { icon: '🏦', title: 'Smart Dashboard', desc: 'Complete overview of your balances, recent transactions, and spending analytics — all at a glance.' },
    { icon: '💳', title: 'Digital Cards', desc: 'Issue your digital card instantly. Freeze and unfreeze with one tap. Customizable spending limits.' },
    { icon: '💸', title: 'Instant Transfers', desc: 'Send and receive in any currency. QR Code payments, saved contacts, scheduled transfers.' },
    { icon: '💱', title: 'Currency Exchange', desc: '30+ currencies at real market rates. Live charts and automatic rate alerts.' },
    { icon: '📊', title: 'Financial Analytics', desc: 'Auto-categorized expenses, monthly budgets, savings goals and detailed reports.' },
    { icon: '🪪', title: 'Digital Identity', desc: 'Verify your identity by scanning your passport or ID. Biometric authentication via fingerprint or face.' },
    { icon: '🤖', title: 'AI Assistant', desc: 'Chat with SDB AI for instant help with any question about your account or our services.' },
    { icon: '🔐', title: 'Military Security', desc: 'End-to-end AES-256 encryption. Two-factor auth, instant security alerts for every transaction.' },
  ],
  statsTitle: 'Numbers that speak',
  stats: [
    { val: '30+', label: 'Currencies' },
    { val: '24/7', label: 'Support' },
    { val: 'AES-256', label: 'Encryption' },
    { val: '< 3s', label: 'Transfer Speed' },
  ],
  specTitle: 'Technical Specs',
  specs: [
    { icon: '', label: 'iOS', val: '15.0+', sub: 'iPhone 8 and newer' },
    { icon: '🤖', label: 'Android', val: '8.0+', sub: 'Most devices' },
    { icon: '📦', label: 'Size', val: '~65 MB', sub: 'Quick download' },
    { icon: '🌐', label: 'Languages', val: 'Arabic + English', sub: 'Instant switch' },
    { icon: '🔄', label: 'Updates', val: 'Weekly', sub: 'New features' },
    { icon: '🛡️', label: 'Security', val: 'AES-256', sub: 'Military-grade' },
  ],
  highlights: [
    'Full Arabic RTL interface', 'Dark / Light mode', 'Biometric authentication',
    'Instant notifications', 'QR Code support', 'NFC payments',
    'Smart search', 'PDF statements', 'Payment detail sharing',
    'Apple Wallet', 'Crypto trading', 'Live support chat',
  ],
  ctaH: 'Ready to start?', ctaP: 'Download the app for free and open your account in minutes.',
});
</script>
<template>
<Head :title="t.title" />

<!-- Hero Section -->
<section class="ap-hero">
  <div class="ap-hero-bg"></div>
  <div class="ap-w">
    <div class="ap-hero-content">
      <div class="ap-hero-text">
        <div class="ap-tag">{{ t.tag }}</div>
        <h1 class="ap-h1">{{ t.heroH }}<br><span class="ap-h1-em">{{ t.heroEm }}</span></h1>
        <p class="ap-hero-p">{{ t.heroP }}</p>
        <div class="ap-badges">
          <a href="#" class="ap-badge" @click="handleBadgeClick">
            <img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83" alt="Download on the App Store" />
          </a>
          <a href="#" class="ap-badge" @click="handleBadgeClick">
            <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get it on Google Play" />
          </a>
        </div>
      </div>
      <div class="ap-hero-mockup">
        <div class="iphone17">
          <!-- iPhone Frame -->
          <div class="iphone17-notch">
            <div class="iphone17-di"></div>
          </div>
          <div class="iphone17-screen">
            <!-- Status Bar -->
            <div class="ip-status">
              <span class="ip-time">9:41</span>
              <div class="ip-status-r">
                <span class="ip-signal">●●●●○</span>
                <span class="ip-wifi">📶</span>
                <span class="ip-bat">🔋</span>
              </div>
            </div>
            <!-- App Header -->
            <div class="ip-app-header">
              <div class="ip-avatar">أ ح</div>
              <div class="ip-greeting">
                <div class="ip-hello">{{ isAr ? 'مرحباً،' : 'Hello,' }}</div>
                <div class="ip-name">{{ isAr ? 'أحمد الحسن' : 'Ahmad Al-Hasan' }}</div>
              </div>
              <div class="ip-notif">🔔<span class="ip-notif-dot"></span></div>
            </div>
            <!-- Balance Card -->
            <div class="ip-balance-card">
              <div class="ip-bal-top">
                <span class="ip-bal-label">{{ isAr ? 'الرصيد الإجمالي' : 'Total Balance' }}</span>
                <span class="ip-eye">👁</span>
              </div>
              <div class="ip-bal-amount">€24,850<small>.75</small></div>
              <div class="ip-bal-change">{{ isAr ? '↑ +3.2% هذا الشهر' : '↑ +3.2% this month' }}</div>
            </div>
            <!-- Quick Actions -->
            <div class="ip-actions">
              <div class="ip-action"><span class="ip-action-ic">↗</span><span class="ip-action-l">{{ isAr ? 'إرسال' : 'Send' }}</span></div>
              <div class="ip-action"><span class="ip-action-ic">↙</span><span class="ip-action-l">{{ isAr ? 'استلام' : 'Receive' }}</span></div>
              <div class="ip-action"><span class="ip-action-ic">⇄</span><span class="ip-action-l">{{ isAr ? 'صرف' : 'Exchange' }}</span></div>
              <div class="ip-action"><span class="ip-action-ic">⊞</span><span class="ip-action-l">{{ isAr ? 'المزيد' : 'More' }}</span></div>
            </div>
            <!-- Virtual Card -->
            <div class="ip-vcard">
              <div class="ip-vcard-top"><span class="ip-vcard-logo">SDB</span><span class="ip-vcard-type">Premium</span></div>
              <div class="ip-vcard-num">•••• •••• •••• 4821</div>
              <div class="ip-vcard-bot"><span>AHMAD AL-HASAN</span><span>09/28</span></div>
            </div>
            <!-- Transactions -->
            <div class="ip-tx-header">
              <span class="ip-tx-title">{{ isAr ? 'آخر العمليات' : 'Recent' }}</span>
              <span class="ip-tx-all">{{ isAr ? 'الكل' : 'All' }} →</span>
            </div>
            <div class="ip-tx-list">
              <div class="ip-tx"><div class="ip-tx-ic" style="background:rgba(16,185,129,.1);color:#10b981">↙</div><div class="ip-tx-info"><span class="ip-tx-name">{{ isAr ? 'راتب — شركة TechSyr' : 'Salary — TechSyr Co.' }}</span><span class="ip-tx-date">{{ isAr ? 'اليوم، 10:30' : 'Today, 10:30 AM' }}</span></div><span class="ip-tx-plus">+€3,200</span></div>
              <div class="ip-tx"><div class="ip-tx-ic" style="background:rgba(239,68,68,.1);color:#ef4444">↗</div><div class="ip-tx-info"><span class="ip-tx-name">{{ isAr ? 'تحويل — ليلى أحمد' : 'Transfer — Layla Ahmad' }}</span><span class="ip-tx-date">{{ isAr ? 'أمس، 14:22' : 'Yesterday, 2:22 PM' }}</span></div><span class="ip-tx-minus">-€150</span></div>
              <div class="ip-tx"><div class="ip-tx-ic" style="background:rgba(99,102,241,.1);color:#6366f1">🛒</div><div class="ip-tx-info"><span class="ip-tx-name">{{ isAr ? 'أمازون' : 'Amazon' }}</span><span class="ip-tx-date">{{ isAr ? 'أمس، 09:15' : 'Yesterday, 9:15 AM' }}</span></div><span class="ip-tx-minus">-€89.99</span></div>
            </div>
            <!-- Bottom Tab Bar -->
            <div class="ip-tabs">
              <div class="ip-tab ip-tab-active"><span>🏠</span><small>{{ isAr ? 'الرئيسية' : 'Home' }}</small></div>
              <div class="ip-tab"><span>💳</span><small>{{ isAr ? 'البطاقات' : 'Cards' }}</small></div>
              <div class="ip-tab"><span>📊</span><small>{{ isAr ? 'تحليلات' : 'Analytics' }}</small></div>
              <div class="ip-tab"><span>⋯</span><small>{{ isAr ? 'المزيد' : 'More' }}</small></div>
            </div>
          </div>
          <!-- Home Indicator -->
          <div class="iphone17-home"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Stats -->
<section class="ap-stats-section">
  <div class="ap-w">
    <div class="ap-stats-grid">
      <div v-for="s in t.stats" :key="s.val" class="ap-stat">
        <div class="ap-stat-val">{{ s.val }}</div>
        <div class="ap-stat-label">{{ s.label }}</div>
      </div>
    </div>
  </div>
</section>

<!-- Features -->
<section class="ap-features">
  <div class="ap-w">
    <h2 class="ap-section-h">{{ isAr ? 'مميزات التطبيق' : 'App Features' }}</h2>
    <p class="ap-section-sub">{{ isAr ? 'كل ما تحتاجه في تطبيق واحد — مصمم ليكون بسيطاً وقوياً' : 'Everything you need in one app — designed to be simple and powerful' }}</p>
    <div class="ap-feat-grid">
      <div v-for="f in t.features" :key="f.title" class="ap-feat-card">
        <div class="ap-feat-icon">{{ f.icon }}</div>
        <h3 class="ap-feat-title">{{ f.title }}</h3>
        <p class="ap-feat-desc">{{ f.desc }}</p>
      </div>
    </div>
  </div>
</section>

<!-- Highlights Pills -->
<section class="ap-highlights">
  <div class="ap-w">
    <h2 class="ap-section-h">{{ isAr ? 'كل شيء تحتاجه' : 'Everything You Need' }}</h2>
    <div class="ap-pill-grid">
      <span v-for="h in t.highlights" :key="h" class="ap-pill">✓ {{ h }}</span>
    </div>
  </div>
</section>

<!-- Specs -->
<section class="ap-specs">
  <div class="ap-w">
    <h2 class="ap-section-h ap-section-h-w">{{ t.specTitle }}</h2>
    <div class="ap-spec-grid">
      <div v-for="s in t.specs" :key="s.label" class="ap-spec-card">
        <div class="ap-spec-icon">{{ s.icon }}</div>
        <div class="ap-spec-label">{{ s.label }}</div>
        <div class="ap-spec-val">{{ s.val }}</div>
        <div class="ap-spec-sub">{{ s.sub }}</div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="ap-cta">
  <div class="ap-w tc">
    <h2 class="ap-cta-h">{{ t.ctaH }}</h2>
    <p class="ap-cta-p">{{ t.ctaP }}</p>
    <div class="ap-badges ap-badges-center">
      <a href="#" class="ap-badge" @click="handleBadgeClick">
        <img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83" alt="App Store" />
      </a>
      <a href="#" class="ap-badge" @click="handleBadgeClick">
        <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Google Play" />
      </a>
    </div>
  </div>
</section>
</template>

<style scoped>
/* Layout */
.ap-w { max-width: 1200px; margin: 0 auto; padding: 0 24px; }
.tc { text-align: center; }

/* Hero */
.ap-hero { position: relative; padding: 140px 0 80px; background: #0a1a00; overflow: hidden; }
.ap-hero-bg { position: absolute; inset: 0; background: radial-gradient(ellipse at 70% 30%, rgba(159,232,112,.12) 0%, transparent 60%), radial-gradient(ellipse at 20% 80%, rgba(159,232,112,.06) 0%, transparent 50%); }
.ap-hero-content { display: flex; align-items: center; gap: 60px; position: relative; z-index: 1; }
.ap-hero-text { flex: 1; }
.ap-hero-mockup { flex: 0 0 340px; }
.ap-tag { font-size: 11px; font-weight: 800; letter-spacing: 3px; text-transform: uppercase; color: #9FE870; margin-bottom: 20px; display: inline-block; background: rgba(159,232,112,.1); padding: 6px 16px; border-radius: 20px; border: 1px solid rgba(159,232,112,.15); }
.ap-h1 { font-size: clamp(2.4rem, 5vw, 3.6rem); font-weight: 900; color: #fff; line-height: 1.1; margin-bottom: 20px; }
.ap-h1-em { color: #9FE870; }
.ap-hero-p { font-size: 17px; color: rgba(255,255,255,.5); line-height: 1.9; max-width: 520px; margin-bottom: 32px; }
.ap-badges { display: flex; gap: 12px; flex-wrap: wrap; }
.ap-badges-center { justify-content: center; }
.ap-badge { display: inline-block; transition: all .25s; border-radius: 10px; overflow: hidden; cursor: pointer; }
.ap-badge img { height: 54px; width: auto; display: block; }
.ap-badge:last-child img { height: 72px; margin: -9px 0; }
.ap-badge:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(0,0,0,.3); }

/* iPhone 17 Pro Frame */
.iphone17 { position: relative; width: 320px; background: linear-gradient(145deg, #3a3a3c, #1c1c1e); border-radius: 48px; padding: 10px; box-shadow: 0 40px 80px rgba(0,0,0,.6), 0 0 0 2px rgba(255,255,255,.08), inset 0 0 0 1px rgba(255,255,255,.04); }
.iphone17-notch { position: absolute; top: 18px; left: 50%; transform: translateX(-50%); z-index: 10; }
.iphone17-di { width: 100px; height: 28px; background: #000; border-radius: 20px; box-shadow: 0 0 0 2px rgba(255,255,255,.04); }
.iphone17-screen { background: linear-gradient(160deg, #0a1a00, #122800); border-radius: 40px; overflow: hidden; padding: 14px 16px 0; display: flex; flex-direction: column; min-height: 640px; }
.iphone17-home { width: 120px; height: 4px; background: rgba(255,255,255,.25); border-radius: 4px; margin: 8px auto 6px; }
/* Status Bar */
.ip-status { display: flex; justify-content: space-between; align-items: center; padding: 8px 8px 6px; margin-top: 20px; }
.ip-time { font-size: 13px; font-weight: 700; color: #fff; }
.ip-status-r { display: flex; gap: 4px; font-size: 10px; color: rgba(255,255,255,.6); }
/* App Header */
.ip-app-header { display: flex; align-items: center; gap: 10px; padding: 10px 4px 8px; }
.ip-avatar { width: 38px; height: 38px; border-radius: 50%; background: linear-gradient(135deg, #9FE870, #4ade80); display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 800; color: #0a1a00; }
.ip-greeting { flex: 1; }
.ip-hello { font-size: 11px; color: rgba(255,255,255,.4); }
.ip-name { font-size: 15px; font-weight: 800; color: #fff; }
.ip-notif { position: relative; font-size: 18px; }
.ip-notif-dot { position: absolute; top: -2px; right: -2px; width: 7px; height: 7px; background: #ef4444; border-radius: 50%; border: 1.5px solid #0a1a00; }
/* Balance Card */
.ip-balance-card { background: linear-gradient(135deg, rgba(159,232,112,.12), rgba(159,232,112,.04)); border: 1px solid rgba(159,232,112,.12); border-radius: 18px; padding: 16px; margin: 6px 0 10px; }
.ip-bal-top { display: flex; justify-content: space-between; align-items: center; }
.ip-bal-label { font-size: 11px; color: rgba(255,255,255,.45); font-weight: 600; }
.ip-eye { font-size: 14px; opacity: .4; }
.ip-bal-amount { font-size: 30px; font-weight: 900; color: #fff; margin: 6px 0 4px; letter-spacing: -1px; }
.ip-bal-amount small { font-size: 18px; color: rgba(255,255,255,.4); }
.ip-bal-change { font-size: 11px; color: #9FE870; font-weight: 700; }
/* Quick Actions */
.ip-actions { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; margin-bottom: 10px; }
.ip-action { text-align: center; padding: 10px 4px 8px; background: rgba(255,255,255,.04); border-radius: 14px; border: 1px solid rgba(255,255,255,.05); }
.ip-action-ic { display: block; font-size: 18px; color: #9FE870; margin-bottom: 4px; }
.ip-action-l { font-size: 9px; font-weight: 700; color: rgba(255,255,255,.5); }
/* Virtual Card */
.ip-vcard { background: linear-gradient(135deg, #163300, #1e4400, #163300); border-radius: 14px; padding: 14px 16px 12px; margin-bottom: 10px; position: relative; overflow: hidden; border: 1px solid rgba(159,232,112,.1); }
.ip-vcard::after { content: ''; position: absolute; top: -30px; right: -30px; width: 100px; height: 100px; background: radial-gradient(circle, rgba(159,232,112,.08), transparent); }
.ip-vcard-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.ip-vcard-logo { font-size: 16px; font-weight: 900; color: #9FE870; letter-spacing: 2px; }
.ip-vcard-type { font-size: 9px; font-weight: 700; color: rgba(255,255,255,.3); text-transform: uppercase; letter-spacing: 1px; background: rgba(255,255,255,.06); padding: 3px 8px; border-radius: 6px; }
.ip-vcard-num { font-size: 14px; font-weight: 600; color: rgba(255,255,255,.6); letter-spacing: 2px; margin-bottom: 8px; font-family: 'Courier New', monospace; }
.ip-vcard-bot { display: flex; justify-content: space-between; font-size: 9px; font-weight: 700; color: rgba(255,255,255,.35); text-transform: uppercase; letter-spacing: 1px; }
/* Transactions */
.ip-tx-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; padding: 0 2px; }
.ip-tx-title { font-size: 13px; font-weight: 800; color: #fff; }
.ip-tx-all { font-size: 10px; color: #9FE870; font-weight: 700; }
.ip-tx-list { display: flex; flex-direction: column; gap: 5px; margin-bottom: 10px; }
.ip-tx { display: flex; align-items: center; gap: 8px; padding: 8px 10px; background: rgba(255,255,255,.03); border-radius: 12px; }
.ip-tx-ic { width: 30px; height: 30px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; flex-shrink: 0; }
.ip-tx-info { flex: 1; min-width: 0; }
.ip-tx-name { display: block; font-size: 11px; font-weight: 700; color: rgba(255,255,255,.8); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.ip-tx-date { display: block; font-size: 9px; color: rgba(255,255,255,.3); margin-top: 1px; }
.ip-tx-plus { font-size: 12px; font-weight: 800; color: #10b981; flex-shrink: 0; }
.ip-tx-minus { font-size: 12px; font-weight: 800; color: #ef4444; flex-shrink: 0; }
/* Tab Bar */
.ip-tabs { display: grid; grid-template-columns: repeat(4, 1fr); margin-top: auto; padding: 6px 0 10px; border-top: 1px solid rgba(255,255,255,.06); }
.ip-tab { text-align: center; padding: 4px 0; }
.ip-tab span { font-size: 16px; display: block; }
.ip-tab small { font-size: 8px; color: rgba(255,255,255,.3); font-weight: 600; display: block; margin-top: 1px; }
.ip-tab-active small { color: #9FE870; }

/* Stats */
.ap-stats-section { padding: 0; margin-top: -40px; position: relative; z-index: 2; }
.ap-stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; background: #fff; border-radius: 20px; padding: 32px; box-shadow: 0 16px 48px rgba(0,0,0,.06); border: 1px solid rgba(0,0,0,.04); }
.ap-stat { text-align: center; }
.ap-stat-val { font-size: 28px; font-weight: 900; color: #163300; margin-bottom: 4px; }
.ap-stat-label { font-size: 13px; color: rgba(0,0,0,.4); font-weight: 600; }

/* Features */
.ap-features { padding: 100px 0 80px; }
.ap-section-h { font-size: clamp(1.8rem, 4vw, 2.6rem); font-weight: 900; color: #0f172a; text-align: center; margin-bottom: 12px; }
.ap-section-h-w { color: #fff; }
.ap-section-sub { font-size: 16px; color: rgba(0,0,0,.4); text-align: center; max-width: 500px; margin: 0 auto 48px; line-height: 1.8; }
.ap-feat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; }
.ap-feat-card { padding: 28px 24px; background: #fff; border: 1px solid rgba(0,0,0,.04); border-radius: 20px; transition: all .3s; }
.ap-feat-card:hover { transform: translateY(-4px); box-shadow: 0 16px 40px rgba(159,232,112,.08); border-color: rgba(159,232,112,.2); }
.ap-feat-icon { font-size: 32px; margin-bottom: 14px; }
.ap-feat-title { font-size: 15px; font-weight: 800; color: #163300; margin-bottom: 8px; }
.ap-feat-desc { font-size: 13px; color: rgba(0,0,0,.4); line-height: 1.8; }

/* Highlights Pills */
.ap-highlights { padding: 60px 0 80px; background: #f8faf5; }
.ap-pill-grid { display: flex; flex-wrap: wrap; gap: 10px; justify-content: center; max-width: 800px; margin: 32px auto 0; }
.ap-pill { font-size: 13px; font-weight: 600; color: #163300; background: #fff; padding: 10px 20px; border-radius: 12px; border: 1px solid rgba(159,232,112,.12); transition: all .2s; }
.ap-pill:hover { background: rgba(159,232,112,.06); border-color: rgba(159,232,112,.3); transform: translateY(-1px); }

/* Specs */
.ap-specs { padding: 80px 0; background: linear-gradient(135deg, #0a1a00, #163300); }
.ap-spec-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 12px; }
.ap-spec-card { text-align: center; padding: 24px 16px; background: rgba(255,255,255,.04); border: 1px solid rgba(255,255,255,.06); border-radius: 16px; transition: all .3s; }
.ap-spec-card:hover { background: rgba(255,255,255,.08); border-color: rgba(159,232,112,.2); }
.ap-spec-icon { font-size: 24px; margin-bottom: 8px; }
.ap-spec-label { font-size: 11px; font-weight: 700; color: #9FE870; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 6px; }
.ap-spec-val { font-size: 22px; font-weight: 900; color: #fff; margin-bottom: 4px; }
.ap-spec-sub { font-size: 11px; color: rgba(255,255,255,.35); }

/* CTA */
.ap-cta { padding: 80px 0; background: #f8faf5; }
.ap-cta-h { font-size: clamp(2rem, 4vw, 3rem); font-weight: 900; color: #163300; margin-bottom: 12px; }
.ap-cta-p { font-size: 17px; color: rgba(0,0,0,.4); max-width: 460px; margin: 0 auto 32px; line-height: 1.8; }

/* Responsive */
@media (max-width: 900px) {
  .ap-hero-content { flex-direction: column; text-align: center; }
  .ap-hero-text { order: 1; }
  .ap-hero-mockup { order: 0; flex: 0 0 auto; }
  .ap-badges { justify-content: center; }
  .ap-hero-p { margin: 0 auto 32px; }
  .ap-feat-grid { grid-template-columns: repeat(2, 1fr); }
  .ap-spec-grid { grid-template-columns: repeat(3, 1fr); }
  .ap-stats-grid { grid-template-columns: repeat(2, 1fr); gap: 20px; }
  .iphone17 { width: 280px; }
  .iphone17-screen { min-height: 560px; }
}
@media (max-width: 480px) {
  .ap-feat-grid { grid-template-columns: 1fr; }
  .ap-spec-grid { grid-template-columns: repeat(2, 1fr); }
  .ap-stats-grid { grid-template-columns: repeat(2, 1fr); }
  .iphone17 { width: 260px; }
  .iphone17-screen { min-height: 520px; }
}
</style>
