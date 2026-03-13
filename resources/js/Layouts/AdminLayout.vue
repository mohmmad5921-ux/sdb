<script setup>
import { Link, usePage, router } from '@inertiajs/vue3';
import { ref, computed, watch, nextTick } from 'vue';

const sidebarOpen = ref(true);
const page = usePage();
const currentRoute = computed(() => page.url);

// Global Search
const searchQuery = ref('');
const searchResults = ref([]);
const searchOpen = ref(false);
let searchTimeout = null;

watch(searchQuery, (val) => {
  clearTimeout(searchTimeout);
  if (val.length < 2) { searchResults.value = []; searchOpen.value = false; return; }
  searchTimeout = setTimeout(async () => {
    try {
      const res = await fetch(route('admin.search') + '?q=' + encodeURIComponent(val));
      const data = await res.json();
      searchResults.value = data.results || [];
      searchOpen.value = searchResults.value.length > 0;
    } catch (e) { searchResults.value = []; }
  }, 300);
});

const goToResult = (r) => {
  searchOpen.value = false;
  searchQuery.value = '';
  router.visit(r.url);
};

const closeSearch = () => { searchOpen.value = false; };

// Notifications badge
const pendingKyc = computed(() => page.props.auth?.admin_stats?.pending_kyc || 0);
const newUsersToday = computed(() => page.props.auth?.admin_stats?.new_users_today || 0);

// AI Chat
const aiOpen = ref(false);
const aiMsg = ref('');
const aiMessages = ref([]);
const aiLoading = ref(false);
const aiChatBody = ref(null);

const sendAiMsg = async () => {
  const msg = aiMsg.value.trim();
  if (!msg || aiLoading.value) return;
  aiMessages.value.push({ role: 'user', content: msg });
  aiMsg.value = '';
  aiLoading.value = true;
  nextTick(() => { if (aiChatBody.value) aiChatBody.value.scrollTop = aiChatBody.value.scrollHeight; });
  try {
    const history = aiMessages.value.slice(0, -1).map(m => ({ role: m.role === 'user' ? 'user' : 'assistant', content: m.content }));
    const res = await fetch(route('admin.ai-chat'), {
      method: 'POST', headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': document.querySelector('meta[name=csrf-token]')?.content },
      body: JSON.stringify({ message: msg, history }),
    });
    const data = await res.json();
    aiMessages.value.push({ role: 'assistant', content: data.reply || 'خطأ' });
  } catch (e) { aiMessages.value.push({ role: 'assistant', content: '❌ خطأ في الاتصال' }); }
  aiLoading.value = false;
  nextTick(() => { if (aiChatBody.value) aiChatBody.value.scrollTop = aiChatBody.value.scrollHeight; });
};
const notifCount = computed(() => pendingKyc.value + newUsersToday.value);

const sideGroups = [
  { label: 'نظرة عامة', links: [
    { label: 'لوحة التحكم', icon: '📊', route: 'admin.dashboard' },
    { label: 'KPIs حية', icon: '⚡', route: 'admin.live-kpi' },
    { label: 'التنبيهات', icon: '🚨', route: 'admin.alerts' },
  ]},
  { label: 'إدارة العملاء', links: [
    { label: 'العملاء', icon: '👥', route: 'admin.users' },
    { label: 'الحسابات', icon: '🏦', route: 'admin.accounts' },
    { label: 'البطاقات', icon: '💳', route: 'admin.cards' },
    { label: 'المعاملات', icon: '💸', route: 'admin.transactions' },
    { label: 'KYC', icon: '🪪', route: 'admin.kyc' },
    { label: 'تصنيف العملاء', icon: '🏷️', route: 'admin.tags' },
    { label: 'الحسابات المجمّدة', icon: '🧊', route: 'admin.frozen' },
  ]},
  { label: 'الأعمال والشركات', links: [
    { label: 'لوحة الشركات', icon: '🏢', route: 'admin.businesses.dashboard' },
    { label: 'حسابات الشركات', icon: '🏗️', route: 'admin.businesses.index' },
    { label: 'التجار', icon: '🔌', route: 'admin.merchants' },
    { label: 'الموافقات', icon: '✅', route: 'admin.approvals' },
  ]},
  { label: 'الدعم والتواصل', links: [
    { label: 'تذاكر الدعم', icon: '🎫', route: 'admin.tickets' },
    { label: 'الدعم', icon: '🎧', route: 'admin.support' },
    { label: 'محادثات الدعم', icon: '💬', route: 'admin.chat' },
    { label: 'إشعارات جماعية', icon: '📢', route: 'admin.broadcast' },
    { label: 'سجل التواصل', icon: '📧', route: 'admin.communications' },
    { label: 'طلبات خاصة', icon: '📋', route: 'admin.special-requests' },
  ]},
  { label: 'المالية والتحليلات', links: [
    { label: 'العملات', icon: '💱', route: 'admin.currencies' },
    { label: 'أسعار الصرف', icon: '📈', route: 'admin.rates' },
    { label: 'الرسوم', icon: '💰', route: 'admin.fees' },
    { label: 'حدود الحسابات', icon: '🔒', route: 'admin.limits' },
    { label: 'العروض والكوبونات', icon: '🎁', route: 'admin.promotions' },
    { label: 'التحليلات', icon: '📊', route: 'admin.analytics' },
    { label: 'تحليل الإيرادات', icon: '💹', route: 'admin.revenue' },
    { label: 'تحليل المستخدمين', icon: '🧑‍💻', route: 'admin.user-analytics' },
    { label: 'الاحتفاظ بالعملاء', icon: '🔄', route: 'admin.retention' },
    { label: 'خريطة العملاء', icon: '🗺️', route: 'admin.customer-map' },
  ]},
  { label: 'التقارير', links: [
    { label: 'تقارير PDF', icon: '📄', route: 'admin.pdf-reports' },
    { label: 'مركز التقارير', icon: '📑', route: 'admin.report-center' },
    { label: 'التقارير', icon: '📋', route: 'admin.reports' },
  ]},
  { label: 'الأمان والامتثال', links: [
    { label: 'كشف الاحتيال AI', icon: '🛡️', route: 'admin.fraud' },
    { label: 'مكافحة غسيل الأموال', icon: '🏛️', route: 'admin.aml' },
    { label: 'مراقبة المعاملات', icon: '📡', route: 'admin.transaction-monitor' },
    { label: 'إدارة المخاطر', icon: '⚠️', route: 'admin.risk-dashboard' },
    { label: 'سجل التحقق', icon: '🔐', route: 'admin.verification-logs' },
    { label: 'التدقيق', icon: '📋', route: 'admin.audit-logs' },
    { label: 'الامتثال', icon: '🛡️', route: 'admin.compliance' },
    { label: 'المخاطر', icon: '⚠️', route: 'admin.risk' },
  ]},
  { label: 'التسويق', links: [
    { label: 'الإحالات', icon: '🔗', route: 'admin.referrals' },
    { label: 'حملات البريد', icon: '📨', route: 'admin.campaigns' },
    { label: 'قوالب البريد', icon: '✉️', route: 'admin.email-templates' },
    { label: 'قائمة الانتظار', icon: '📩', route: 'admin.waitlist' },
  ]},
  { label: 'النظام', links: [
    { label: 'إدارة المحتوى', icon: '📝', route: 'admin.cms' },
    { label: 'إدارة التطبيق', icon: '📱', route: 'admin.app-management' },
    { label: 'حالة API', icon: '🌐', route: 'admin.api-status' },
    { label: 'التكاملات', icon: '🔌', route: 'admin.integrations' },
    { label: 'إدارة البيانات', icon: '🗄️', route: 'admin.data-management' },
    { label: 'جدولة المهام', icon: '📅', route: 'admin.tasks' },
    { label: 'أمان الأدمن', icon: '🔐', route: 'admin.security' },
    { label: 'الجلسات النشطة', icon: '🔍', route: 'admin.sessions' },
    { label: 'IP Whitelist', icon: '🛡️', route: 'admin.ip-whitelist' },
    { label: 'سجل التغييرات', icon: '📜', route: 'admin.changelog' },
    { label: 'الإعدادات', icon: '⚙️', route: 'admin.settings' },
  ]},
];

// Keep flat list for backward compatibility
const sideLinks = sideGroups.flatMap(g => g.links);

const isActive = (r) => {
  try {
    const url = route(r);
    return currentRoute.value.startsWith(url.replace(window.location.origin, ''));
  } catch { return false; }
};

defineProps({ title: { type: String, default: '' }, subtitle: { type: String, default: '' } });
</script>

<template>
  <div class="adl-root">
    <!-- SIDEBAR -->
    <aside class="adl-sidebar" :class="{'adl-collapsed': !sidebarOpen}">
      <div class="adl-logo">
        <div class="adl-logo-icon">SDB</div>
        <span v-if="sidebarOpen" class="adl-logo-text">لوحة الإدارة</span>
      </div>
      <nav class="adl-nav">
        <template v-for="(g, gi) in sideGroups" :key="gi">
          <div v-if="sidebarOpen" class="adl-nav-group">{{ g.label }}</div>
          <div v-else class="adl-nav-sep"></div>
          <Link v-for="l in g.links" :key="l.route" :href="route(l.route)"
            :class="['adl-nav-item', isActive(l.route) ? 'adl-nav-active' : '']">
            <span class="adl-nav-icon">{{ l.icon }}</span>
            <span v-if="sidebarOpen" class="adl-nav-label">{{ l.label }}</span>
            <span v-if="sidebarOpen && l.route === 'admin.kyc' && pendingKyc > 0" class="adl-nav-badge">{{ pendingKyc }}</span>
          </Link>
        </template>
      </nav>
      <!-- Logout -->
      <div class="adl-nav-bottom">
        <Link :href="route('logout')" method="post" as="button" class="adl-nav-item adl-logout">
          <span class="adl-nav-icon">🚪</span>
          <span v-if="sidebarOpen" class="adl-nav-label">تسجيل الخروج</span>
        </Link>
      </div>
    </aside>

    <!-- MAIN AREA -->
    <main class="adl-main">
      <header class="adl-topbar">
        <div class="adl-topbar-right">
          <button @click="sidebarOpen = !sidebarOpen" class="adl-toggle">☰</button>
          <div>
            <h1 class="adl-title">{{ title }}</h1>
            <p v-if="subtitle" class="adl-subtitle">{{ subtitle }}</p>
          </div>
        </div>

        <div class="adl-topbar-center">
          <!-- Global Search -->
          <div class="adl-search-wrap" @click.stop>
            <div class="adl-search-box">
              <span class="adl-search-icon">🔍</span>
              <input v-model="searchQuery" type="text" placeholder="بحث سريع — عملاء، حسابات، معاملات..." class="adl-search-input" @focus="searchOpen = searchResults.length > 0" @blur="setTimeout(closeSearch, 200)" />
              <kbd v-if="!searchQuery" class="adl-kbd">⌘K</kbd>
            </div>
            <!-- Search Results Dropdown -->
            <div v-if="searchOpen" class="adl-search-dropdown">
              <div v-for="(r, i) in searchResults" :key="i" class="adl-search-result" @mousedown.prevent="goToResult(r)">
                <span class="adl-sr-icon">{{ r.icon }}</span>
                <div class="adl-sr-info">
                  <div class="adl-sr-title">{{ r.title }}</div>
                  <div class="adl-sr-sub">{{ r.subtitle }}</div>
                </div>
                <span :class="['adl-sr-status', 'adl-sr-' + r.status]">{{ r.status }}</span>
              </div>
              <div v-if="!searchResults.length" class="adl-search-empty">لا توجد نتائج</div>
            </div>
          </div>
        </div>

        <div class="adl-topbar-left">
          <slot name="actions" />
          <!-- Notification Bell -->
          <Link :href="route('admin.kyc')" class="adl-notif-btn" v-if="notifCount > 0" title="إشعارات">
            <span>🔔</span>
            <span class="adl-notif-badge">{{ notifCount }}</span>
          </Link>
          <span class="adl-date">{{ new Date().toLocaleDateString('ar-EG', { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric' }) }}</span>
        </div>
      </header>

      <div class="adl-content">
        <slot />
      </div>
    </main>

    <!-- AI Chat Floating Button -->
    <button class="ai-fab" @click="aiOpen = !aiOpen" :class="{active: aiOpen}" title="مساعد SDB الذكي">
      <span v-if="!aiOpen">🤖</span>
      <span v-else>✕</span>
    </button>

    <!-- AI Chat Panel -->
    <div class="ai-panel" v-if="aiOpen">
      <div class="ai-header">
        <div class="ai-header-info">
          <span class="ai-avatar">🤖</span>
          <div>
            <div class="ai-name">مساعد SDB</div>
            <div class="ai-status">Gemini AI · متصل</div>
          </div>
        </div>
        <button class="ai-close" @click="aiOpen = false">✕</button>
      </div>
      <div class="ai-body" ref="aiChatBody">
        <div v-if="!aiMessages.length" class="ai-welcome">
          <div class="ai-welcome-icon">🤖</div>
          <div class="ai-welcome-title">مرحباً! أنا مساعد SDB</div>
          <div class="ai-welcome-text">أقدر أساعدك بكل شي بالأدمن — KYC، العملاء، المعاملات، والمزيد</div>
          <div class="ai-suggestions">
            <button @click="aiMsg = 'كيف أتحقق من هوية عميل جديد؟'; sendAiMsg()">🪪 كيف أتحقق من هوية عميل؟</button>
            <button @click="aiMsg = 'ما هي إحصائيات اليوم؟'; sendAiMsg()">📊 إحصائيات اليوم</button>
            <button @click="aiMsg = 'كيف أجمّد حساب مشبوه؟'; sendAiMsg()">🧊 تجميد حساب مشبوه</button>
          </div>
        </div>
        <div v-for="(m, i) in aiMessages" :key="i" :class="['ai-msg', m.role === 'user' ? 'ai-msg-user' : 'ai-msg-bot']">
          <div class="ai-msg-bubble" v-html="m.content.replace(/\n/g, '<br>')"></div>
        </div>
        <div v-if="aiLoading" class="ai-msg ai-msg-bot">
          <div class="ai-msg-bubble ai-typing"><span></span><span></span><span></span></div>
        </div>
      </div>
      <div class="ai-input-wrap">
        <input v-model="aiMsg" @keyup.enter="sendAiMsg" placeholder="اكتب سؤالك..." class="ai-input" :disabled="aiLoading" />
        <button @click="sendAiMsg" class="ai-send" :disabled="aiLoading || !aiMsg.trim()">➤</button>
      </div>
    </div>
  </div>
</template>

<style>
@import '../../css/admin.css';

.adl-root {
  display: flex; min-height: 100vh;
  background: #f1f5f9; color: #0f172a;
  direction: rtl; font-family: 'Inter', 'Segoe UI', Tahoma, sans-serif;
  -webkit-font-smoothing: antialiased;
}

/* SIDEBAR — Light */
.adl-sidebar {
  width: 250px; background: #ffffff;
  border-left: 1px solid #e2e8f0;
  display: flex; flex-direction: column; flex-shrink: 0;
  transition: width .25s ease;
  box-shadow: -2px 0 8px rgba(0,0,0,0.04);
}
.adl-collapsed { width: 68px; overflow: hidden; }

.adl-logo {
  display: flex; align-items: center; gap: 12px;
  padding: 22px 18px;
  border-bottom: 1px solid #e2e8f0;
}
.adl-logo-icon {
  width: 42px; height: 42px;
  background: linear-gradient(135deg, #10b981, #059669);
  border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  color: #fff; font-weight: 900; font-size: 13px;
  flex-shrink: 0; letter-spacing: 1px;
}
.adl-logo-text { font-size: 17px; font-weight: 800; color: #0f172a; }

.adl-nav {
  padding: 8px 8px; display: flex; flex-direction: column; gap: 1px;
  flex: 1; overflow-y: auto;
}
.adl-nav-item {
  display: flex; align-items: center; gap: 8px;
  padding: 7px 12px; border-radius: 8px;
  font-size: 12.5px; color: #64748b;
  text-decoration: none; font-weight: 600;
  transition: all .15s; border: none; background: none;
  cursor: pointer; width: 100%; text-align: right;
}
.adl-nav-item:hover { background: #f1f5f9; color: #0f172a; }
.adl-nav-active {
  background: #10b981 !important;
  color: #fff !important; font-weight: 700;
}
.adl-nav-icon { font-size: 15px; width: 20px; text-align: center; flex-shrink: 0; }
.adl-nav-label { white-space: nowrap; }
.adl-nav-badge { background: #ef4444; color: #fff; font-size: 11px; font-weight: 700; padding: 2px 7px; border-radius: 10px; margin-right: auto; }
.adl-nav-group {
  font-size: 10px; font-weight: 800; color: #94a3b8;
  text-transform: uppercase; letter-spacing: 1px;
  padding: 16px 14px 6px;
  margin-top: 4px;
  border-top: 1px solid #f1f5f9;
}
.adl-nav-group:first-child { border-top: none; margin-top: 0; padding-top: 8px; }
.adl-nav-sep { height: 1px; background: #f1f5f9; margin: 6px 8px; }
.adl-nav-bottom { padding: 10px; border-top: 1px solid #e2e8f0; }
.adl-logout { color: #dc2626 !important; }
.adl-logout:hover { background: #fef2f2 !important; }

/* MAIN */
.adl-main { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }

.adl-topbar {
  display: flex; justify-content: space-between; align-items: center;
  padding: 18px 32px;
  background: #ffffff; border-bottom: 1px solid #e2e8f0;
  flex-shrink: 0;
  box-shadow: 0 1px 3px rgba(0,0,0,0.04);
  gap: 16px;
}
.adl-topbar-right { display: flex; align-items: center; gap: 16px; flex-shrink: 0; }
.adl-topbar-center { flex: 1; display: flex; justify-content: center; max-width: 500px; margin: 0 auto; }
.adl-topbar-left { display: flex; align-items: center; gap: 16px; flex-shrink: 0; }
.adl-title { font-size: 22px; font-weight: 800; color: #0f172a; margin: 0; }
.adl-subtitle { font-size: 14px; color: #64748b; margin-top: 4px; }
.adl-toggle {
  font-size: 20px; color: #64748b; background: none; border: none;
  cursor: pointer; padding: 6px 10px; border-radius: 8px;
}
.adl-toggle:hover { background: #f1f5f9; color: #0f172a; }
.adl-date { font-size: 14px; color: #94a3b8; white-space: nowrap; }

/* Global Search */
.adl-search-wrap { position: relative; width: 100%; }
.adl-search-box { display: flex; align-items: center; background: #f1f5f9; border: 1px solid #e2e8f0; border-radius: 12px; padding: 0 14px; transition: all .2s; }
.adl-search-box:focus-within { background: #ffffff; border-color: #10b981; box-shadow: 0 0 0 3px rgba(16,185,129,0.1); }
.adl-search-icon { font-size: 16px; margin-left: 8px; }
.adl-search-input { flex: 1; border: none; background: transparent; padding: 10px 8px; font-size: 14px; color: #0f172a; outline: none; direction: rtl; }
.adl-search-input::placeholder { color: #94a3b8; font-size: 13px; }
.adl-kbd { font-size: 11px; background: #e2e8f0; color: #64748b; padding: 2px 6px; border-radius: 4px; font-family: monospace; }

.adl-search-dropdown { position: absolute; top: 100%; right: 0; left: 0; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 14px; margin-top: 6px; box-shadow: 0 8px 30px rgba(0,0,0,0.12); z-index: 999; max-height: 360px; overflow-y: auto; }
.adl-search-result { display: flex; align-items: center; gap: 12px; padding: 12px 16px; cursor: pointer; transition: background .15s; border-bottom: 1px solid #f8fafc; }
.adl-search-result:hover { background: #f8fafc; }
.adl-search-result:last-child { border-bottom: none; }
.adl-sr-icon { font-size: 22px; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; background: #f1f5f9; border-radius: 10px; flex-shrink: 0; }
.adl-sr-info { flex: 1; min-width: 0; }
.adl-sr-title { font-size: 14px; font-weight: 600; color: #0f172a; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.adl-sr-sub { font-size: 12px; color: #64748b; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.adl-sr-status { font-size: 11px; font-weight: 600; padding: 2px 8px; border-radius: 6px; flex-shrink: 0; }
.adl-sr-active { color: #059669; background: #ecfdf5; }
.adl-sr-pending { color: #d97706; background: #fffbeb; }
.adl-sr-frozen { color: #3b82f6; background: #eff6ff; }
.adl-sr-completed { color: #059669; background: #ecfdf5; }
.adl-sr-failed { color: #dc2626; background: #fef2f2; }
.adl-sr-suspended,.adl-sr-blocked,.adl-sr-cancelled { color: #dc2626; background: #fef2f2; }
.adl-search-empty { padding: 20px; text-align: center; color: #94a3b8; font-size: 14px; }

/* Notification bell */
.adl-notif-btn { position: relative; font-size: 20px; text-decoration: none; padding: 6px; border-radius: 10px; transition: background .15s; }
.adl-notif-btn:hover { background: #f1f5f9; }
.adl-notif-badge { position: absolute; top: -2px; right: -4px; background: #ef4444; color: #fff; font-size: 10px; font-weight: 700; padding: 1px 5px; border-radius: 8px; min-width: 16px; text-align: center; }

.adl-content { padding: 28px 32px; display: flex; flex-direction: column; gap: 24px; }

/* Override AuthenticatedLayout if present */
.adl-root .min-h-screen { min-height: auto !important; background: transparent !important; }

@media (max-width: 1100px) {
  .adl-sidebar { width: 68px; overflow: hidden; }
  .adl-nav-label, .adl-logo-text, .adl-nav-badge { display: none; }
  .adl-topbar-center { display: none; }
}

/* ═══ AI Chat Widget ═══ */
.ai-fab { position: fixed; bottom: 24px; left: 24px; width: 56px; height: 56px; border-radius: 50%; background: linear-gradient(135deg, #10b981, #059669); color: white; font-size: 26px; border: none; cursor: pointer; box-shadow: 0 6px 24px rgba(16,185,129,0.4); z-index: 9999; transition: all .3s; display: flex; align-items: center; justify-content: center; }
.ai-fab:hover { transform: scale(1.1); box-shadow: 0 8px 32px rgba(16,185,129,0.5); }
.ai-fab.active { background: #64748b; box-shadow: 0 4px 16px rgba(100,116,139,0.4); }
.ai-fab::before { content: ''; position: absolute; width: 100%; height: 100%; border-radius: 50%; background: inherit; opacity: 0; animation: ai-pulse 2s ease infinite; }
@keyframes ai-pulse { 0%,100% { opacity: 0; transform: scale(1); } 50% { opacity: 0.2; transform: scale(1.4); } }

.ai-panel { position: fixed; bottom: 90px; left: 24px; width: 380px; max-height: 520px; background: #fff; border-radius: 20px; box-shadow: 0 12px 48px rgba(0,0,0,0.15); z-index: 9999; display: flex; flex-direction: column; overflow: hidden; animation: ai-slideUp .3s ease; }
@keyframes ai-slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

.ai-header { display: flex; align-items: center; justify-content: space-between; padding: 16px 18px; background: linear-gradient(135deg, #10b981, #059669); color: white; }
.ai-header-info { display: flex; align-items: center; gap: 12px; }
.ai-avatar { font-size: 28px; width: 40px; height: 40px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; }
.ai-name { font-weight: 700; font-size: 15px; }
.ai-status { font-size: 11px; opacity: 0.85; }
.ai-close { background: none; border: none; color: white; font-size: 18px; cursor: pointer; opacity: 0.7; transition: opacity .2s; }
.ai-close:hover { opacity: 1; }

.ai-body { flex: 1; overflow-y: auto; padding: 16px; display: flex; flex-direction: column; gap: 10px; max-height: 340px; direction: rtl; }
.ai-body::-webkit-scrollbar { width: 4px; }
.ai-body::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 4px; }

.ai-welcome { text-align: center; padding: 20px 10px; }
.ai-welcome-icon { font-size: 48px; margin-bottom: 12px; }
.ai-welcome-title { font-size: 16px; font-weight: 700; color: #0f172a; margin-bottom: 6px; }
.ai-welcome-text { font-size: 13px; color: #64748b; margin-bottom: 16px; line-height: 1.5; }
.ai-suggestions { display: flex; flex-direction: column; gap: 6px; }
.ai-suggestions button { background: #f1f5f9; border: 1px solid #e2e8f0; border-radius: 10px; padding: 8px 14px; font-size: 13px; cursor: pointer; transition: all .2s; text-align: right; color: #334155; }
.ai-suggestions button:hover { background: #e2e8f0; border-color: #10b981; color: #059669; }

.ai-msg { display: flex; }
.ai-msg-user { justify-content: flex-end; }
.ai-msg-bot { justify-content: flex-start; }
.ai-msg-bubble { max-width: 85%; padding: 10px 14px; border-radius: 14px; font-size: 13px; line-height: 1.6; word-wrap: break-word; }
.ai-msg-user .ai-msg-bubble { background: #10b981; color: white; border-bottom-left-radius: 4px; }
.ai-msg-bot .ai-msg-bubble { background: #f1f5f9; color: #0f172a; border-bottom-right-radius: 4px; }

.ai-typing { display: flex; align-items: center; gap: 4px; padding: 12px 18px; }
.ai-typing span { width: 7px; height: 7px; background: #94a3b8; border-radius: 50%; animation: ai-dot 1.4s ease infinite; }
.ai-typing span:nth-child(2) { animation-delay: .2s; }
.ai-typing span:nth-child(3) { animation-delay: .4s; }
@keyframes ai-dot { 0%,100% { transform: translateY(0); opacity: .4; } 50% { transform: translateY(-6px); opacity: 1; } }

.ai-input-wrap { display: flex; gap: 8px; padding: 12px 16px; border-top: 1px solid #e2e8f0; background: #fafafa; }
.ai-input { flex: 1; border: 1px solid #e2e8f0; border-radius: 12px; padding: 10px 14px; font-size: 13px; direction: rtl; outline: none; transition: border .2s; }
.ai-input:focus { border-color: #10b981; box-shadow: 0 0 0 2px rgba(16,185,129,0.1); }
.ai-send { width: 40px; height: 40px; border-radius: 12px; background: #10b981; color: white; border: none; font-size: 16px; cursor: pointer; transition: all .2s; display: flex; align-items: center; justify-content: center; }
.ai-send:hover:not(:disabled) { background: #059669; }
.ai-send:disabled { opacity: 0.4; cursor: not-allowed; }

@media (max-width: 768px) {
  .ai-panel { left: 8px; right: 8px; width: auto; bottom: 80px; max-height: 70vh; }
  .ai-fab { bottom: 16px; left: 16px; width: 50px; height: 50px; font-size: 22px; }
}
</style>

