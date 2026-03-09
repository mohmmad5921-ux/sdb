<script setup>
import { Head, Link, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ stats: Object, dailyTransactions: Array, dailyUsers: Array, recentTransactions: Array, recentUsers: Array, currencies: Array, alerts: Array, recentWaitlist: Array, recentPrereg: Array });
const sidebarOpen = ref(true);
const fmt = (a, s='€') => Number(a).toLocaleString('en-US',{minimumFractionDigits:0,maximumFractionDigits:0}) + ' ' + s;
const fmtM = (a) => {
  if (a >= 1000000) return (a/1000000).toFixed(1) + 'M';
  if (a >= 1000) return (a/1000).toFixed(1) + 'K';
  return Number(a).toLocaleString();
};

const sideLinks = [
  { label: 'لوحة التحكم', icon: '📊', route: 'admin.dashboard', active: true },
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

const maxTxCount = computed(() => Math.max(...(props.dailyTransactions || []).map(d => d.count), 1));
const maxTxVol = computed(() => Math.max(...(props.dailyTransactions || []).map(d => d.volume), 1));

const typeLabels = { transfer: 'تحويل', deposit: 'إيداع', withdrawal: 'سحب', exchange: 'صرف', card_payment: 'بطاقة', fee: 'رسوم' };
const statusBadge = { completed: 'ad-badge-green', pending: 'ad-badge-yellow', failed: 'ad-badge-red' };
</script>

<template>
  <Head title="Admin Dashboard - لوحة التحكم" />
  <AuthenticatedLayout>
    <div class="ad-root">
      <!-- SIDEBAR -->
      <aside class="ad-sidebar" :class="{'ad-sidebar-collapsed': !sidebarOpen}">
        <div class="ad-logo">
          <div class="ad-logo-icon">SDB</div>
          <span v-if="sidebarOpen" class="ad-logo-text">لوحة الإدارة</span>
        </div>
        <nav class="ad-nav">
          <Link v-for="l in sideLinks" :key="l.route + l.label" :href="route(l.route)" :class="['ad-nav-item', l.active ? 'ad-nav-active' : '']">
            <span class="ad-nav-icon">{{ l.icon }}</span><span v-if="sidebarOpen" class="ad-nav-label">{{ l.label }}</span>
          </Link>
        </nav>
      </aside>

      <!-- MAIN -->
      <main class="ad-main">
        <header class="ad-topbar">
          <div class="flex items-center gap-4">
            <button @click="sidebarOpen = !sidebarOpen" class="ad-toggle">☰</button>
            <div>
              <h1 class="ad-title">لوحة التحكم الرئيسية</h1>
              <p class="ad-subtitle">نظرة عامة على أداء النظام والبيانات الحية</p>
            </div>
          </div>
          <div class="flex items-center gap-4">
            <span class="ad-date">{{ new Date().toLocaleDateString('ar-EG', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }) }}</span>
            <div class="ad-avatar">A</div>
          </div>
        </header>

        <div class="ad-content">
          <!-- System Alerts -->
          <div v-if="alerts?.length" class="ad-alerts">
            <div v-for="(a, i) in alerts" :key="i" :class="['ad-alert', 'ad-alert-' + a.type]">
              <span v-if="a.type==='warning'">⚠️</span><span v-else-if="a.type==='error'">🚨</span><span v-else>ℹ️</span>
              <span>{{ a.msg }}</span>
            </div>
          </div>

          <!-- Core Stats -->
          <div class="ad-stats-grid">
            <div class="ad-stat ad-stat-glow-blue">
              <div class="ad-stat-header"><span class="ad-stat-icon">👥</span><span class="ad-stat-label">العملاء</span></div>
              <div class="ad-stat-value">{{ stats.total_users }}</div>
              <div class="ad-stat-sub ad-sub-green">+{{ stats.new_users_today }} اليوم</div>
            </div>
            <div class="ad-stat ad-stat-glow-green">
              <div class="ad-stat-header"><span class="ad-stat-icon">🏦</span><span class="ad-stat-label">الحسابات</span></div>
              <div class="ad-stat-value">{{ stats.total_accounts }}</div>
              <div class="ad-stat-sub ad-sub-blue">{{ stats.active_accounts }} نشط</div>
            </div>
            <div class="ad-stat ad-stat-glow-purple">
              <div class="ad-stat-header"><span class="ad-stat-icon">💳</span><span class="ad-stat-label">البطاقات</span></div>
              <div class="ad-stat-value">{{ stats.total_cards }}</div>
              <div class="ad-stat-sub ad-sub-blue">{{ stats.active_cards }} نشط</div>
            </div>
            <div class="ad-stat ad-stat-glow-amber">
              <div class="ad-stat-header"><span class="ad-stat-icon">💸</span><span class="ad-stat-label">المعاملات</span></div>
              <div class="ad-stat-value">{{ stats.total_transactions }}</div>
              <div class="ad-stat-sub ad-sub-green">+{{ stats.today_transactions }} اليوم</div>
            </div>
            <div class="ad-stat">
              <div class="ad-stat-header"><span class="ad-stat-icon">🪪</span><span class="ad-stat-label">طلبات KYC معلّقة</span></div>
              <div class="ad-stat-value" style="color:#f59e0b">{{ stats.pending_kyc }}</div>
              <div class="ad-stat-sub" style="color:#d97706">بانتظار المراجعة</div>
            </div>
            <div class="ad-stat">
              <div class="ad-stat-header"><span class="ad-stat-icon">💰</span><span class="ad-stat-label">حجم المعاملات الكلي</span></div>
              <div class="ad-stat-value" style="color:#10b981">{{ fmtM(stats.total_volume) }}</div>
              <div class="ad-stat-sub ad-sub-green">{{ fmtM(stats.today_volume) }} اليوم</div>
            </div>
            <div class="ad-stat">
              <div class="ad-stat-header"><span class="ad-stat-icon">📩</span><span class="ad-stat-label">قائمة الانتظار</span></div>
              <div class="ad-stat-value" style="color:#6366f1">{{ stats.total_waitlist }}</div>
              <div class="ad-stat-sub" style="color:#818cf8">+{{ stats.waitlist_today }} اليوم</div>
            </div>
            <div class="ad-stat">
              <div class="ad-stat-header"><span class="ad-stat-icon">📝</span><span class="ad-stat-label">التسجيل المبكر</span></div>
              <div class="ad-stat-value" style="color:#ec4899">{{ stats.total_preregistrations }}</div>
              <div class="ad-stat-sub" style="color:#f472b6">+{{ stats.prereg_today }} اليوم</div>
            </div>
          </div>

          <!-- Volume Summary Row -->
          <div class="grid grid-cols-4 gap-4">
            <div class="ad-vol-card"><div class="ad-vol-label">حجم اليوم</div><div class="ad-vol-value">{{ fmtM(stats.today_volume) }}</div><div class="ad-vol-sub">{{ stats.today_transactions }} معاملة</div></div>
            <div class="ad-vol-card"><div class="ad-vol-label">حجم الأسبوع</div><div class="ad-vol-value" style="color:#3b82f6">{{ fmtM(stats.week_volume) }}</div><div class="ad-vol-sub">{{ stats.week_transactions }} معاملة</div></div>
            <div class="ad-vol-card"><div class="ad-vol-label">حجم الشهر</div><div class="ad-vol-value" style="color:#10b981">{{ fmtM(stats.month_volume) }}</div><div class="ad-vol-sub">{{ stats.month_transactions }} معاملة</div></div>
            <div class="ad-vol-card"><div class="ad-vol-label">مستخدمون جدد (هذا الشهر)</div><div class="ad-vol-value" style="color:#8b5cf6">{{ stats.new_users_month }}</div><div class="ad-vol-sub">{{ stats.new_users_week }} هذا الأسبوع</div></div>
          </div>

          <!-- Charts Row -->
          <div class="grid grid-cols-2 gap-4">
            <div class="ad-chart-card">
              <h3 class="ad-section-title">📈 حجم المعاملات — آخر 7 أيام</h3>
              <div class="ad-bar-chart">
                <div v-for="d in dailyTransactions" :key="d.date" class="ad-bar-col" :title="'الحجم: ' + fmtM(d.volume)">
                  <div class="ad-bar-wrapper"><div class="ad-bar ad-bar-blue" :style="{height: Math.max((d.volume / maxTxVol) * 100, 4) + '%'}"></div></div>
                  <div class="ad-bar-date">{{ d.date }}</div>
                  <div class="ad-bar-val" style="color:#3b82f6">{{ fmtM(d.volume) }}</div>
                </div>
              </div>
            </div>
            <div class="ad-chart-card">
              <h3 class="ad-section-title">📊 عدد المعاملات — آخر 7 أيام</h3>
              <div class="ad-bar-chart">
                <div v-for="d in dailyTransactions" :key="d.date" class="ad-bar-col" :title="'العدد: ' + d.count">
                  <div class="ad-bar-wrapper"><div class="ad-bar ad-bar-green" :style="{height: Math.max((d.count / maxTxCount) * 100, 4) + '%'}"></div></div>
                  <div class="ad-bar-date">{{ d.date }}</div>
                  <div class="ad-bar-val" style="color:#10b981">{{ d.count }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Actions + Health + Currencies -->
          <div class="grid grid-cols-3 gap-4">
            <div class="ad-card">
              <h3 class="ad-section-title">⚡ إجراءات سريعة</h3>
              <div class="ad-quick-grid">
                <Link :href="route('admin.users')" class="ad-quick-btn"><span>👥</span>العملاء</Link>
                <Link :href="route('admin.kyc')" class="ad-quick-btn ad-quick-warn"><span>🪪</span>KYC<span v-if="stats.pending_kyc" class="ad-badge-count">{{ stats.pending_kyc }}</span></Link>
                <Link :href="route('admin.transactions')" class="ad-quick-btn"><span>💸</span>المعاملات</Link>
                <Link :href="route('admin.accounts')" class="ad-quick-btn"><span>🏦</span>الحسابات</Link>
                <Link :href="route('admin.cards')" class="ad-quick-btn"><span>💳</span>البطاقات</Link>
                <Link :href="route('admin.currencies')" class="ad-quick-btn"><span>💱</span>العملات</Link>
                <Link :href="route('admin.merchants')" class="ad-quick-btn"><span>🔌</span>بوابة الدفع</Link>
                <Link :href="route('admin.support')" class="ad-quick-btn"><span>🎧</span>الدعم</Link>
                <Link :href="route('admin.settings')" class="ad-quick-btn"><span>⚙️</span>الإعدادات</Link>
                <Link :href="route('admin.audit-logs')" class="ad-quick-btn"><span>📋</span>التدقيق</Link>
              </div>
            </div>

            <div class="ad-card">
              <h3 class="ad-section-title">💊 صحة النظام</h3>
              <div class="ad-health-list">
                <div class="ad-health-row"><span class="ad-health-label">حسابات نشطة</span><div class="ad-health-bar"><div class="ad-health-fill" style="background:#10b981" :style="{width: (stats.active_accounts / Math.max(stats.total_accounts,1)) * 100 + '%'}"></div></div><span class="ad-health-pct">{{ Math.round((stats.active_accounts / Math.max(stats.total_accounts,1)) * 100) }}%</span></div>
                <div class="ad-health-row"><span class="ad-health-label">بطاقات نشطة</span><div class="ad-health-bar"><div class="ad-health-fill" style="background:#3b82f6" :style="{width: (stats.active_cards / Math.max(stats.total_cards,1)) * 100 + '%'}"></div></div><span class="ad-health-pct">{{ Math.round((stats.active_cards / Math.max(stats.total_cards,1)) * 100) }}%</span></div>
                <div class="ad-health-row"><span class="ad-health-label">مستخدمون نشطون</span><div class="ad-health-bar"><div class="ad-health-fill" style="background:#8b5cf6" :style="{width: (stats.active_users / Math.max(stats.total_users,1)) * 100 + '%'}"></div></div><span class="ad-health-pct">{{ Math.round((stats.active_users / Math.max(stats.total_users,1)) * 100) }}%</span></div>
                <div class="ad-health-row"><span class="ad-health-label">حسابات مجمدة</span><div class="ad-health-bar"><div class="ad-health-fill" style="background:#ef4444" :style="{width: (stats.frozen_accounts / Math.max(stats.total_accounts,1)) * 100 + '%'}"></div></div><span class="ad-health-pct ad-text-red">{{ stats.frozen_accounts }}</span></div>
                <div class="ad-health-row"><span class="ad-health-label">معاملات فاشلة</span><div class="ad-health-bar"><div class="ad-health-fill" style="background:#ef4444" :style="{width: Math.min((stats.failed_transactions / Math.max(stats.total_transactions,1)) * 100, 100) + '%'}"></div></div><span class="ad-health-pct ad-text-red">{{ stats.failed_transactions }}</span></div>
              </div>
            </div>

            <div class="ad-card">
              <h3 class="ad-section-title">💱 العملات المدعومة</h3>
              <div class="ad-currency-list">
                <div v-for="c in currencies" :key="c.id" class="ad-currency-row">
                  <div class="ad-currency-info"><span class="ad-currency-sym">{{ c.symbol }}</span><span class="ad-currency-code">{{ c.code }}</span></div>
                  <span class="ad-currency-rate">{{ c.exchange_rate_to_eur }} EUR</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Data -->
          <div class="grid grid-cols-2 gap-4">
            <div class="ad-card">
              <div class="ad-card-header"><h3 class="ad-section-title">💸 آخر المعاملات</h3><Link :href="route('admin.transactions')" class="ad-link">عرض الكل ←</Link></div>
              <div class="ad-list">
                <div v-for="t in recentTransactions" :key="t.id" class="ad-list-row">
                  <div class="flex items-center gap-3">
                    <span :class="statusBadge[t.status]" class="ad-badge">{{ t.status === 'completed' ? '✓' : t.status === 'pending' ? '⏳' : '✗' }}</span>
                    <div><div class="ad-list-primary">{{ t.from_account?.user?.full_name || '—' }} → {{ t.to_account?.user?.full_name || '—' }}</div><div class="ad-list-secondary">{{ typeLabels[t.type] || t.type }} · {{ new Date(t.created_at).toLocaleTimeString('en-GB', {hour:'2-digit', minute:'2-digit'}) }}</div></div>
                  </div>
                  <span class="ad-list-amount">{{ Number(t.amount).toLocaleString() }} {{ t.currency?.symbol }}</span>
                </div>
              </div>
            </div>

            <div class="ad-card">
              <div class="ad-card-header"><h3 class="ad-section-title">👥 آخر المسجلين</h3><Link :href="route('admin.users')" class="ad-link">عرض الكل ←</Link></div>
              <div class="ad-list">
                <Link v-for="u in recentUsers" :key="u.id" :href="route('admin.users.show', u.id)" class="ad-list-row ad-list-link">
                  <div class="flex items-center gap-3">
                    <div class="ad-user-avatar">{{ u.full_name?.charAt(0) }}</div>
                    <div><div class="ad-list-primary">{{ u.full_name }}</div><div class="ad-list-secondary">{{ u.email }}</div></div>
                  </div>
                  <div class="text-left">
                    <span :class="u.status === 'active' ? 'ad-badge-green' : 'ad-badge-yellow'" class="ad-badge">{{ u.status }}</span>
                    <div class="ad-list-secondary mt-1">{{ new Date(u.created_at).toLocaleDateString('en-GB') }}</div>
                  </div>
                </Link>
              </div>
            </div>

            <div class="ad-card">
              <div class="ad-card-header"><h3 class="ad-section-title">📩 آخر تسجيلات الانتظار</h3><a href="/admin/export/waitlist" class="ad-export-btn">📥 تصدير CSV</a></div>
              <div class="ad-list">
                <div v-for="w in recentWaitlist" :key="w.id" class="ad-list-row">
                  <div class="flex items-center gap-3">
                    <span class="ad-badge ad-badge-green">📧</span>
                    <div><div class="ad-list-primary">{{ w.email }}</div><div class="ad-list-secondary">{{ w.source }} · {{ new Date(w.created_at).toLocaleDateString('en-GB') }}</div></div>
                  </div>
                </div>
                <div v-if="!recentWaitlist?.length" class="ad-empty">لا يوجد تسجيلات بعد</div>
              </div>
            </div>

            <div class="ad-card">
              <div class="ad-card-header"><h3 class="ad-section-title">📝 آخر التسجيلات المبكرة</h3><a href="/admin/export/preregistrations" class="ad-export-btn" style="background:rgba(236,72,153,0.1);color:#ec4899;border-color:rgba(236,72,153,0.2)">📥 تصدير CSV</a></div>
              <div class="ad-list">
                <div v-for="p in recentPrereg" :key="p.id" class="ad-list-row">
                  <div class="flex items-center gap-3">
                    <div class="ad-user-avatar" style="background:linear-gradient(135deg,#ec4899,#f472b6)">{{ p.full_name?.charAt(0) }}</div>
                    <div><div class="ad-list-primary">{{ p.full_name }}</div><div class="ad-list-secondary">{{ p.email }} · {{ p.country }}</div></div>
                  </div>
                  <div class="ad-list-secondary">{{ new Date(p.created_at).toLocaleDateString('en-GB') }}</div>
                </div>
                <div v-if="!recentPrereg?.length" class="ad-empty">لا يوجد تسجيلات بعد</div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
/* RESET & ROOT */
.ad-root{display:flex;min-height:100vh;background:#080d1c;color:#e2e8f0;direction:rtl;font-family:'Inter','Segoe UI',sans-serif}

/* SIDEBAR */
.ad-sidebar{width:240px;background:#0c1225;border-left:1px solid rgba(255,255,255,0.06);display:flex;flex-direction:column;transition:width .3s;flex-shrink:0}
.ad-sidebar-collapsed{width:60px;overflow:hidden}
.ad-logo{display:flex;align-items:center;gap:12px;padding:20px 16px;border-bottom:1px solid rgba(255,255,255,0.06)}
.ad-logo-icon{width:36px;height:36px;background:linear-gradient(135deg,#10b981,#059669);border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:900;font-size:11px;flex-shrink:0;letter-spacing:0.5px}
.ad-logo-text{font-size:15px;font-weight:800;color:#e2e8f0}
.ad-nav{padding:12px 8px;display:flex;flex-direction:column;gap:3px;flex:1;overflow-y:auto}
.ad-nav-item{display:flex;align-items:center;gap:12px;padding:11px 14px;border-radius:12px;font-size:14px;color:rgba(226,232,240,0.5);text-decoration:none;transition:all .15s;font-weight:500}
.ad-nav-item:hover{background:rgba(255,255,255,0.04);color:rgba(226,232,240,0.8)}
.ad-nav-active{background:rgba(16,185,129,0.1)!important;color:#10b981!important;font-weight:700}
.ad-nav-icon{font-size:18px;width:24px;text-align:center;flex-shrink:0}
.ad-nav-label{white-space:nowrap}

/* MAIN */
.ad-main{flex:1;display:flex;flex-direction:column;overflow-y:auto}
.ad-topbar{display:flex;justify-content:space-between;align-items:center;padding:18px 28px;background:#0c1225;border-bottom:1px solid rgba(255,255,255,0.06)}
.ad-title{font-size:20px;font-weight:800;color:#e2e8f0;margin:0}
.ad-subtitle{font-size:13px;color:rgba(226,232,240,0.4);margin-top:2px}
.ad-toggle{font-size:18px;color:rgba(226,232,240,0.4);background:none;border:none;cursor:pointer;padding:4px 8px;border-radius:8px}.ad-toggle:hover{background:rgba(255,255,255,0.05);color:#e2e8f0}
.ad-date{font-size:13px;color:rgba(226,232,240,0.4)}
.ad-avatar{width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,#3b82f6,#1d4ed8);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:14px}
.ad-content{padding:24px 28px;display:flex;flex-direction:column;gap:24px}

/* ALERTS */
.ad-alerts{display:flex;flex-wrap:wrap;gap:10px}
.ad-alert{padding:12px 18px;border-radius:12px;font-size:14px;font-weight:600;display:flex;align-items:center;gap:10px}
.ad-alert-warning{background:rgba(245,158,11,0.08);color:#fbbf24;border:1px solid rgba(245,158,11,0.15)}
.ad-alert-error{background:rgba(239,68,68,0.08);color:#f87171;border:1px solid rgba(239,68,68,0.15)}
.ad-alert-info{background:rgba(59,130,246,0.08);color:#60a5fa;border:1px solid rgba(59,130,246,0.15)}

/* STATS */
.ad-stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.ad-stat{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:18px;padding:20px;transition:all .2s}
.ad-stat:hover{border-color:rgba(255,255,255,0.12);background:rgba(255,255,255,0.04)}
.ad-stat-glow-blue{box-shadow:0 0 0 1px rgba(59,130,246,0.08) inset}
.ad-stat-glow-green{box-shadow:0 0 0 1px rgba(16,185,129,0.08) inset}
.ad-stat-glow-purple{box-shadow:0 0 0 1px rgba(139,92,246,0.08) inset}
.ad-stat-glow-amber{box-shadow:0 0 0 1px rgba(245,158,11,0.08) inset}
.ad-stat-header{display:flex;align-items:center;gap:8px;margin-bottom:10px}
.ad-stat-icon{font-size:20px}
.ad-stat-label{font-size:14px;color:rgba(226,232,240,0.5);font-weight:600}
.ad-stat-value{font-size:32px;font-weight:900;color:#e2e8f0;line-height:1.1}
.ad-stat-sub{font-size:13px;margin-top:6px;font-weight:600}
.ad-sub-green{color:#10b981}.ad-sub-blue{color:#3b82f6}

/* VOLUME */
.ad-vol-card{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:16px;padding:20px}
.ad-vol-label{font-size:13px;color:rgba(226,232,240,0.4);font-weight:600;margin-bottom:6px}
.ad-vol-value{font-size:26px;font-weight:900;color:#e2e8f0}
.ad-vol-sub{font-size:13px;color:rgba(226,232,240,0.35);margin-top:4px}

/* CHARTS */
.ad-chart-card{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:18px;padding:24px}
.ad-section-title{font-size:16px;font-weight:700;color:#e2e8f0;margin-bottom:18px}
.ad-bar-chart{display:flex;align-items:flex-end;gap:10px;height:140px}
.ad-bar-col{flex:1;display:flex;flex-direction:column;align-items:center;cursor:pointer;transition:transform .2s}.ad-bar-col:hover{transform:translateY(-3px)}
.ad-bar-wrapper{height:110px;width:100%;display:flex;align-items:flex-end;justify-content:center}
.ad-bar{width:65%;border-radius:6px 6px 0 0;min-height:3px;transition:height .5s ease}
.ad-bar-blue{background:linear-gradient(180deg,#3b82f6,#1d4ed8)}
.ad-bar-green{background:linear-gradient(180deg,#10b981,#059669)}
.ad-bar-date{font-size:12px;color:rgba(226,232,240,0.35);margin-top:6px}
.ad-bar-val{font-size:12px;font-weight:700;margin-top:2px}

/* CARDS */
.ad-card{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:18px;padding:22px}
.ad-card-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px}

/* QUICK ACTIONS */
.ad-quick-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:8px}
.ad-quick-btn{display:flex;align-items:center;gap:10px;padding:12px 14px;border-radius:12px;font-size:14px;font-weight:600;color:rgba(226,232,240,0.6);text-decoration:none;border:1px solid rgba(255,255,255,0.05);transition:all .15s}
.ad-quick-btn:hover{background:rgba(255,255,255,0.05);color:#e2e8f0;border-color:rgba(255,255,255,0.1)}
.ad-quick-warn{color:#fbbf24;border-color:rgba(245,158,11,0.15)}.ad-quick-warn:hover{background:rgba(245,158,11,0.05)}
.ad-badge-count{background:#ef4444;color:#fff;font-size:11px;padding:2px 8px;border-radius:100px;margin-right:auto;font-weight:700}

/* HEALTH */
.ad-health-list{display:flex;flex-direction:column;gap:14px}
.ad-health-row{display:flex;align-items:center;gap:12px}
.ad-health-label{font-size:13px;color:rgba(226,232,240,0.5);font-weight:500;width:120px;flex-shrink:0}
.ad-health-bar{flex:1;height:8px;background:rgba(255,255,255,0.06);border-radius:100px;overflow:hidden}
.ad-health-fill{height:100%;border-radius:100px;transition:width .5s ease}
.ad-health-pct{font-size:14px;font-weight:700;color:#e2e8f0;width:40px;text-align:left}
.ad-text-red{color:#f87171!important}

/* CURRENCIES */
.ad-currency-list{display:flex;flex-direction:column;gap:4px}
.ad-currency-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid rgba(255,255,255,0.04)}.ad-currency-row:last-child{border:0}
.ad-currency-info{display:flex;align-items:center;gap:10px}
.ad-currency-sym{font-size:22px}
.ad-currency-code{font-size:15px;font-weight:700;color:#e2e8f0}
.ad-currency-rate{font-size:13px;font-family:monospace;color:rgba(226,232,240,0.4)}

/* LISTS */
.ad-list{display:flex;flex-direction:column;gap:2px}
.ad-list-row{display:flex;justify-content:space-between;align-items:center;padding:12px 6px;border-bottom:1px solid rgba(255,255,255,0.04);transition:background .15s}.ad-list-row:last-child{border:0}
.ad-list-link{text-decoration:none;border-radius:10px;padding:12px 10px}.ad-list-link:hover{background:rgba(255,255,255,0.03)}
.ad-list-primary{font-size:14px;font-weight:600;color:#e2e8f0}
.ad-list-secondary{font-size:12px;color:rgba(226,232,240,0.35);margin-top:2px}
.ad-list-amount{font-size:14px;font-weight:700;color:#e2e8f0}
.ad-empty{text-align:center;padding:20px;font-size:14px;color:rgba(226,232,240,0.3)}

/* USER AVATAR */
.ad-user-avatar{width:38px;height:38px;border-radius:12px;background:linear-gradient(135deg,#3b82f6,#1d4ed8);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:14px;flex-shrink:0}

/* BADGES */
.ad-badge{font-size:12px;padding:4px 10px;border-radius:100px;font-weight:600}
.ad-badge-green{background:rgba(16,185,129,0.12);color:#34d399}
.ad-badge-yellow{background:rgba(245,158,11,0.12);color:#fbbf24}
.ad-badge-red{background:rgba(239,68,68,0.12);color:#f87171}

/* LINKS */
.ad-link{font-size:13px;color:#60a5fa;text-decoration:none;font-weight:600}.ad-link:hover{text-decoration:underline}
.ad-export-btn{font-size:12px;padding:6px 14px;border-radius:10px;font-weight:700;text-decoration:none;background:rgba(99,102,241,0.1);color:#818cf8;border:1px solid rgba(99,102,241,0.2);transition:all .15s}.ad-export-btn:hover{background:rgba(99,102,241,0.15)}

/* RESPONSIVE */
@media(max-width:1400px){.ad-stats-grid{grid-template-columns:repeat(4,1fr)}}
@media(max-width:1100px){.ad-stats-grid{grid-template-columns:repeat(2,1fr)}}
</style>
