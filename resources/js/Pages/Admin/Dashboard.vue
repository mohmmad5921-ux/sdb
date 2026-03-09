<script setup>
import { Head, Link, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ stats: Object, growth: Object, dailyTransactions: Array, dailyUsers: Array, recentTransactions: Array, recentUsers: Array, currencies: Array, alerts: Array, recentWaitlist: Array, recentPrereg: Array, topClients: Array, countryBreakdown: Array });

const fmt = (a, s='€') => Number(a).toLocaleString('en-US',{minimumFractionDigits:0,maximumFractionDigits:0}) + ' ' + s;
const fmtM = (a) => {
  if (a >= 1000000) return (a/1000000).toFixed(1) + 'M';
  if (a >= 1000) return (a/1000).toFixed(1) + 'K';
  return Number(a).toLocaleString();
};

const maxTxCount = computed(() => Math.max(...(props.dailyTransactions || []).map(d => d.count), 1));
const maxTxVol = computed(() => Math.max(...(props.dailyTransactions || []).map(d => d.volume), 1));

const typeLabels = { transfer: 'تحويل', deposit: 'إيداع', withdrawal: 'سحب', exchange: 'صرف', card_payment: 'بطاقة', fee: 'رسوم' };
const statusBadge = { completed: 'ad-badge-green', pending: 'ad-badge-yellow', failed: 'ad-badge-red' };
</script>

<template>
  <Head title="Admin Dashboard - لوحة التحكم" />
  <AdminLayout title="لوحة التحكم الرئيسية" subtitle="نظرة عامة على أداء النظام والبيانات الحية">

    <!-- System Alerts (clickable) -->
    <div v-if="alerts?.length" class="ad-alerts">
      <component :is="a.link ? 'a' : 'div'" v-for="(a, i) in alerts" :key="i" :href="a.link ? route(a.link) : undefined" :class="['ad-alert', 'ad-alert-' + a.type, a.link ? 'ad-alert-clickable' : '']">
        <span v-if="a.type==='warning'">⚠️</span><span v-else-if="a.type==='error'">🚨</span><span v-else>ℹ️</span>
        <span>{{ a.msg }}</span>
        <span v-if="a.link" class="ad-alert-arrow">←</span>
      </component>
    </div>

    <!-- Core Stats with Growth -->
    <div class="ad-stats-grid">
      <div class="ad-stat">
        <div class="ad-stat-header"><span class="ad-stat-icon">👥</span><span class="ad-stat-label">العملاء</span></div>
        <div class="ad-stat-value">{{ stats.total_users }}</div>
        <div class="ad-stat-sub ad-sub-green">+{{ stats.new_users_today }} اليوم</div>
        <div v-if="growth?.users" :class="['ad-growth', 'ad-growth-' + growth.users.direction]">
          <span v-if="growth.users.direction === 'up'">↑</span><span v-else-if="growth.users.direction === 'down'">↓</span><span v-else>→</span>
          {{ growth.users.pct }}% هذا الأسبوع
        </div>
      </div>
      <div class="ad-stat">
        <div class="ad-stat-header"><span class="ad-stat-icon">🏦</span><span class="ad-stat-label">الحسابات</span></div>
        <div class="ad-stat-value">{{ stats.total_accounts }}</div>
        <div class="ad-stat-sub ad-sub-blue">{{ stats.active_accounts }} نشط</div>
      </div>
      <div class="ad-stat">
        <div class="ad-stat-header"><span class="ad-stat-icon">💳</span><span class="ad-stat-label">البطاقات</span></div>
        <div class="ad-stat-value">{{ stats.total_cards }}</div>
        <div class="ad-stat-sub ad-sub-blue">{{ stats.active_cards }} نشط</div>
      </div>
      <div class="ad-stat">
        <div class="ad-stat-header"><span class="ad-stat-icon">💸</span><span class="ad-stat-label">المعاملات</span></div>
        <div class="ad-stat-value">{{ stats.total_transactions }}</div>
        <div class="ad-stat-sub ad-sub-green">+{{ stats.today_transactions }} اليوم</div>
        <div v-if="growth?.transactions" :class="['ad-growth', 'ad-growth-' + growth.transactions.direction]">
          <span v-if="growth.transactions.direction === 'up'">↑</span><span v-else-if="growth.transactions.direction === 'down'">↓</span><span v-else>→</span>
          {{ growth.transactions.pct }}% هذا الأسبوع
        </div>
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
        <div v-if="growth?.volume" :class="['ad-growth', 'ad-growth-' + growth.volume.direction]">
          <span v-if="growth.volume.direction === 'up'">↑</span><span v-else-if="growth.volume.direction === 'down'">↓</span><span v-else>→</span>
          {{ growth.volume.pct }}% هذا الأسبوع
        </div>
      </div>
      <div class="ad-stat">
        <div class="ad-stat-header"><span class="ad-stat-icon">📩</span><span class="ad-stat-label">قائمة الانتظار</span></div>
        <div class="ad-stat-value" style="color:#6366f1">{{ stats.total_waitlist }}</div>
        <div class="ad-stat-sub" style="color:#6366f1">+{{ stats.waitlist_today }} اليوم</div>
      </div>
      <div class="ad-stat">
        <div class="ad-stat-header"><span class="ad-stat-icon">📝</span><span class="ad-stat-label">التسجيل المبكر</span></div>
        <div class="ad-stat-value" style="color:#ec4899">{{ stats.total_preregistrations }}</div>
        <div class="ad-stat-sub" style="color:#db2777">+{{ stats.prereg_today }} اليوم</div>
      </div>
    </div>

    <!-- Volume Summary -->
    <div class="grid grid-cols-4 gap-4">
      <div class="ad-vol-card"><div class="ad-vol-label">حجم اليوم</div><div class="ad-vol-value">{{ fmtM(stats.today_volume) }}</div><div class="ad-vol-sub">{{ stats.today_transactions }} معاملة</div></div>
      <div class="ad-vol-card"><div class="ad-vol-label">حجم الأسبوع</div><div class="ad-vol-value" style="color:#3b82f6">{{ fmtM(stats.week_volume) }}</div><div class="ad-vol-sub">{{ stats.week_transactions }} معاملة</div></div>
      <div class="ad-vol-card"><div class="ad-vol-label">حجم الشهر</div><div class="ad-vol-value" style="color:#10b981">{{ fmtM(stats.month_volume) }}</div><div class="ad-vol-sub">{{ stats.month_transactions }} معاملة</div></div>
      <div class="ad-vol-card"><div class="ad-vol-label">مستخدمون جدد (هذا الشهر)</div><div class="ad-vol-value" style="color:#8b5cf6">{{ stats.new_users_month }}</div><div class="ad-vol-sub">{{ stats.new_users_week }} هذا الأسبوع</div></div>
    </div>

    <!-- Charts -->
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

    <!-- Quick Actions + Health + Top Clients -->
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
          <Link :href="route('admin.audit-logs')" class="ad-quick-btn"><span>📋</span>سجل الأنشطة</Link>
        </div>
      </div>

      <div class="ad-card">
        <h3 class="ad-section-title">🏆 أعلى العملاء رصيداً</h3>
        <div class="ad-list" v-if="topClients?.length">
          <Link v-for="(c, i) in topClients" :key="c.id" :href="route('admin.users.show', c.id)" class="ad-list-row ad-list-link">
            <div class="flex items-center gap-3">
              <div class="ad-rank" :class="i === 0 ? 'ad-rank-gold' : i === 1 ? 'ad-rank-silver' : i === 2 ? 'ad-rank-bronze' : ''">{{ i + 1 }}</div>
              <div><div class="ad-list-primary">{{ c.name }}</div><div class="ad-list-secondary">{{ c.accounts_count }} حسابات</div></div>
            </div>
            <span class="ad-list-amount" style="color:#10b981">€{{ Number(c.balance).toLocaleString() }}</span>
          </Link>
        </div>
        <div v-else class="ad-empty">لا يوجد عملاء نشطون</div>
      </div>

      <div class="ad-card">
        <h3 class="ad-section-title">🌍 التسجيل حسب الدولة</h3>
        <div class="ad-list" v-if="countryBreakdown?.length">
          <div v-for="c in countryBreakdown" :key="c.country" class="ad-list-row">
            <span class="ad-list-primary">{{ c.country || 'غير محدد' }}</span>
            <div class="flex items-center gap-2">
              <div class="ad-country-bar"><div class="ad-country-fill" :style="{width: (c.total / countryBreakdown[0].total) * 100 + '%'}"></div></div>
              <span class="ad-list-secondary" style="min-width:30px;text-align:left">{{ c.total }}</span>
            </div>
          </div>
        </div>
        <div v-else class="ad-empty">لا يوجد بيانات</div>
      </div>
    </div>

    <!-- System Health + Currencies -->
    <div class="grid grid-cols-2 gap-4">
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
        <div class="ad-card-header"><h3 class="ad-section-title">📩 آخر تسجيلات الانتظار</h3><a :href="route('admin.export.waitlist')" class="ad-export-btn">📥 تصدير CSV</a></div>
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
        <div class="ad-card-header"><h3 class="ad-section-title">📝 آخر التسجيلات المبكرة</h3><a :href="route('admin.export.preregistrations')" class="ad-export-btn">📥 تصدير CSV</a></div>
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

  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
/* Growth indicators */
.ad-growth{font-size:11px;font-weight:600;padding:2px 8px;border-radius:6px;margin-top:4px;display:inline-block}
.ad-growth-up{color:#059669;background:rgba(16,185,129,0.1)}
.ad-growth-down{color:#dc2626;background:rgba(239,68,68,0.1)}
.ad-growth-flat{color:#64748b;background:#f1f5f9}
/* Alert clickable */
.ad-alert-clickable{cursor:pointer;text-decoration:none;display:flex;align-items:center;gap:8px}.ad-alert-clickable:hover{opacity:0.85}
.ad-alert-arrow{margin-right:auto;font-weight:700;opacity:0.5}
/* Top clients rank */
.ad-rank{width:28px;height:28px;border-radius:50%;background:#f1f5f9;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;color:#334155;flex-shrink:0}
.ad-rank-gold{background:linear-gradient(135deg,#fbbf24,#f59e0b);color:#fff}
.ad-rank-silver{background:linear-gradient(135deg,#94a3b8,#64748b);color:#fff}
.ad-rank-bronze{background:linear-gradient(135deg,#d97706,#b45309);color:#fff}
/* Country breakdown bar */
.ad-country-bar{width:80px;height:8px;background:#f1f5f9;border-radius:4px;overflow:hidden}
.ad-country-fill{height:100%;background:linear-gradient(90deg,#3b82f6,#6366f1);border-radius:4px;transition:width .3s}
</style>
