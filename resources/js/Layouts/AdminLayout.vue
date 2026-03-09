<script setup>
import { Link, usePage } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

const sidebarOpen = ref(true);
const page = usePage();
const currentRoute = computed(() => page.url);

const sideLinks = [
  { label: 'لوحة التحكم', icon: '📊', route: 'admin.dashboard' },
  { label: 'قائمة الانتظار', icon: '📩', route: 'admin.waitlist' },
  { label: 'التقارير', icon: '📈', route: 'admin.reports' },
  { label: 'المخاطر', icon: '🛡️', route: 'admin.risk' },
  { label: 'العملاء', icon: '👥', route: 'admin.users' },
  { label: 'الحسابات', icon: '🏦', route: 'admin.accounts' },
  { label: 'البطاقات', icon: '💳', route: 'admin.cards' },
  { label: 'المعاملات', icon: '💸', route: 'admin.transactions' },
  { label: 'KYC', icon: '🪪', route: 'admin.kyc' },
  { label: 'العملات', icon: '💱', route: 'admin.currencies' },
  { label: 'التجار', icon: '🔌', route: 'admin.merchants' },
  { label: 'الدعم', icon: '🎧', route: 'admin.support' },
  { label: 'التدقيق', icon: '📋', route: 'admin.audit-logs' },
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
        <div class="adl-topbar-left">
          <slot name="actions" />
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
  background: #0f172a; color: #f1f5f9;
  direction: rtl; font-family: 'Inter', 'Segoe UI', Tahoma, sans-serif;
  -webkit-font-smoothing: antialiased;
}

/* SIDEBAR */
.adl-sidebar {
  width: 250px; background: #1e293b;
  border-left: 1px solid #334155;
  display: flex; flex-direction: column; flex-shrink: 0;
  transition: width .25s ease;
}
.adl-collapsed { width: 68px; overflow: hidden; }

.adl-logo {
  display: flex; align-items: center; gap: 12px;
  padding: 22px 18px;
  border-bottom: 1px solid #334155;
}
.adl-logo-icon {
  width: 42px; height: 42px;
  background: linear-gradient(135deg, #10b981, #059669);
  border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  color: #fff; font-weight: 900; font-size: 13px;
  flex-shrink: 0; letter-spacing: 1px;
}
.adl-logo-text { font-size: 17px; font-weight: 800; color: #f1f5f9; }

.adl-nav {
  padding: 14px 10px; display: flex; flex-direction: column; gap: 3px;
  flex: 1; overflow-y: auto;
}
.adl-nav-item {
  display: flex; align-items: center; gap: 14px;
  padding: 12px 16px; border-radius: 12px;
  font-size: 15px; color: #94a3b8;
  text-decoration: none; font-weight: 600;
  transition: all .15s; border: none; background: none;
  cursor: pointer; width: 100%; text-align: right;
}
.adl-nav-item:hover { background: #334155; color: #e2e8f0; }
.adl-nav-active {
  background: #10b981 !important;
  color: #fff !important; font-weight: 700;
}
.adl-nav-icon { font-size: 20px; width: 26px; text-align: center; flex-shrink: 0; }
.adl-nav-label { white-space: nowrap; }
.adl-nav-bottom { padding: 10px; border-top: 1px solid #334155; }
.adl-logout { color: #f87171 !important; }
.adl-logout:hover { background: #450a0a !important; }

/* MAIN */
.adl-main { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }

.adl-topbar {
  display: flex; justify-content: space-between; align-items: center;
  padding: 18px 32px;
  background: #1e293b; border-bottom: 1px solid #334155;
  flex-shrink: 0;
}
.adl-topbar-right { display: flex; align-items: center; gap: 16px; }
.adl-topbar-left { display: flex; align-items: center; gap: 16px; }
.adl-title { font-size: 22px; font-weight: 800; color: #f1f5f9; margin: 0; }
.adl-subtitle { font-size: 14px; color: #94a3b8; margin-top: 4px; }
.adl-toggle {
  font-size: 20px; color: #94a3b8; background: none; border: none;
  cursor: pointer; padding: 6px 10px; border-radius: 8px;
}
.adl-toggle:hover { background: #334155; color: #f1f5f9; }
.adl-date { font-size: 14px; color: #64748b; }

.adl-content { padding: 28px 32px; display: flex; flex-direction: column; gap: 24px; }

/* Override AuthenticatedLayout if present */
.adl-root .min-h-screen { min-height: auto !important; background: transparent !important; }

@media (max-width: 1100px) {
  .adl-sidebar { width: 68px; overflow: hidden; }
  .adl-nav-label, .adl-logo-text { display: none; }
}
</style>
