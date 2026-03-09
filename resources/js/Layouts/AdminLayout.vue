<script setup>
import { Link, usePage, router } from '@inertiajs/vue3';
import { ref, computed, watch } from 'vue';

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
const notifCount = computed(() => pendingKyc.value + newUsersToday.value);

const sideLinks = [
  { label: 'لوحة التحكم', icon: '📊', route: 'admin.dashboard' },
  { label: 'KPIs حية', icon: '⚡', route: 'admin.live-kpi' },
  // Core Banking
  { label: 'العملاء', icon: '👥', route: 'admin.users' },
  { label: 'الحسابات', icon: '🏦', route: 'admin.accounts' },
  { label: 'البطاقات', icon: '💳', route: 'admin.cards' },
  { label: 'المعاملات', icon: '💸', route: 'admin.transactions' },
  { label: 'KYC', icon: '🪪', route: 'admin.kyc' },
  { label: 'العملات', icon: '💱', route: 'admin.currencies' },
  { label: 'تصنيف العملاء', icon: '🏷️', route: 'admin.tags' },
  // Operations
  { label: 'التجار', icon: '🔌', route: 'admin.merchants' },
  // Business Accounts
  { label: 'لوحة الشركات', icon: '🏢', route: 'admin.businesses.dashboard' },
  { label: 'حسابات الشركات', icon: '🏗️', route: 'admin.businesses.index' },
  { label: 'الموافقات', icon: '✅', route: 'admin.approvals' },
  { label: 'تذاكر الدعم', icon: '🎫', route: 'admin.tickets' },
  { label: 'الدعم', icon: '🎧', route: 'admin.support' },
  { label: 'إشعارات جماعية', icon: '📢', route: 'admin.broadcast' },
  { label: 'سجل التواصل', icon: '📧', route: 'admin.communications' },
  { label: 'الحسابات المجمّدة', icon: '🧊', route: 'admin.frozen' },
  { label: 'طلبات خاصة', icon: '📋', route: 'admin.special-requests' },
  { label: 'جدولة المهام', icon: '📅', route: 'admin.tasks' },
  // Finance
  { label: 'الرسوم', icon: '💰', route: 'admin.fees' },
  { label: 'أسعار الصرف', icon: '📈', route: 'admin.rates' },
  { label: 'العروض والكوبونات', icon: '🎁', route: 'admin.promotions' },
  { label: 'حدود الحسابات', icon: '🔒', route: 'admin.limits' },
  // Analytics & Compliance
  { label: 'التحليلات', icon: '📊', route: 'admin.analytics' },
  { label: 'تقارير PDF', icon: '📄', route: 'admin.pdf-reports' },
  { label: 'مركز التقارير', icon: '📑', route: 'admin.report-center' },
  { label: 'تحليل الإيرادات', icon: '💹', route: 'admin.revenue' },
  { label: 'تحليل المستخدمين', icon: '🧑‍💻', route: 'admin.user-analytics' },
  { label: 'الاحتفاظ بالعملاء', icon: '🔄', route: 'admin.retention' },
  { label: 'خريطة العملاء', icon: '🗺️', route: 'admin.customer-map' },
  // Security & Compliance
  { label: 'كشف الاحتيال AI', icon: '🛡️', route: 'admin.fraud' },
  { label: 'مكافحة غسيل الأموال', icon: '🏛️', route: 'admin.aml' },
  { label: 'مراقبة المعاملات', icon: '📡', route: 'admin.transaction-monitor' },
  { label: 'إدارة المخاطر', icon: '⚠️', route: 'admin.risk-dashboard' },
  { label: 'سجل التحقق', icon: '🔐', route: 'admin.verification-logs' },
  { label: 'التدقيق', icon: '📋', route: 'admin.audit-logs' },
  { label: 'الامتثال', icon: '🛡️', route: 'admin.compliance' },
  { label: 'المخاطر', icon: '⚠️', route: 'admin.risk' },
  // Marketing
  { label: 'الإحالات', icon: '🔗', route: 'admin.referrals' },
  { label: 'حملات البريد', icon: '📨', route: 'admin.campaigns' },
  { label: 'قوالب البريد', icon: '✉️', route: 'admin.email-templates' },
  // System & Data
  { label: 'إدارة المحتوى', icon: '📝', route: 'admin.cms' },
  { label: 'إدارة التطبيق', icon: '📱', route: 'admin.app-management' },
  { label: 'حالة API', icon: '🌐', route: 'admin.api-status' },
  { label: 'التكاملات الخارجية', icon: '🔌', route: 'admin.integrations' },
  { label: 'إدارة البيانات', icon: '🗄️', route: 'admin.data-management' },
  { label: 'أمان الأدمن', icon: '🔐', route: 'admin.security' },
  { label: 'الجلسات النشطة', icon: '🔍', route: 'admin.sessions' },
  { label: 'IP Whitelist', icon: '🛡️', route: 'admin.ip-whitelist' },
  { label: 'سجل التغييرات', icon: '📜', route: 'admin.changelog' },
  { label: 'التنبيهات الذكية', icon: '🚨', route: 'admin.alerts' },
  { label: 'قائمة الانتظار', icon: '📩', route: 'admin.waitlist' },
  { label: 'الإعدادات', icon: '⚙️', route: 'admin.settings' },
];

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
        <Link v-for="l in sideLinks" :key="l.route" :href="route(l.route)"
          :class="['adl-nav-item', isActive(l.route) ? 'adl-nav-active' : '']">
          <span class="adl-nav-icon">{{ l.icon }}</span>
          <span v-if="sidebarOpen" class="adl-nav-label">{{ l.label }}</span>
          <span v-if="sidebarOpen && l.route === 'admin.kyc' && pendingKyc > 0" class="adl-nav-badge">{{ pendingKyc }}</span>
        </Link>
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
  padding: 14px 10px; display: flex; flex-direction: column; gap: 3px;
  flex: 1; overflow-y: auto;
}
.adl-nav-item {
  display: flex; align-items: center; gap: 14px;
  padding: 12px 16px; border-radius: 12px;
  font-size: 15px; color: #64748b;
  text-decoration: none; font-weight: 600;
  transition: all .15s; border: none; background: none;
  cursor: pointer; width: 100%; text-align: right;
}
.adl-nav-item:hover { background: #f1f5f9; color: #0f172a; }
.adl-nav-active {
  background: #10b981 !important;
  color: #fff !important; font-weight: 700;
}
.adl-nav-icon { font-size: 20px; width: 26px; text-align: center; flex-shrink: 0; }
.adl-nav-label { white-space: nowrap; }
.adl-nav-badge { background: #ef4444; color: #fff; font-size: 11px; font-weight: 700; padding: 2px 7px; border-radius: 10px; margin-right: auto; }
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
</style>
