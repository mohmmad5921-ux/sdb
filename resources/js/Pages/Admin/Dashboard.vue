<script setup>
import { Head, Link, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ stats: Object, dailyTransactions: Array, dailyUsers: Array, recentTransactions: Array, recentUsers: Array, currencies: Array, alerts: Array, recentWaitlist: Array, recentPrereg: Array });

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

    <!-- System Alerts -->
    <div v-if="alerts?.length" class="ad-alerts">
      <div v-for="(a, i) in alerts" :key="i" :class="['ad-alert', 'ad-alert-' + a.type]">
        <span v-if="a.type==='warning'">⚠️</span><span v-else-if="a.type==='error'">🚨</span><span v-else>ℹ️</span>
        <span>{{ a.msg }}</span>
      </div>
    </div>

    <!-- Core Stats -->
    <div class="ad-stats-grid">
      <div class="ad-stat">
        <div class="ad-stat-header"><span class="ad-stat-icon">👥</span><span class="ad-stat-label">العملاء</span></div>
        <div class="ad-stat-value">{{ stats.total_users }}</div>
        <div class="ad-stat-sub ad-sub-green">+{{ stats.new_users_today }} اليوم</div>
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
        <div class="ad-card-header"><h3 class="ad-section-title">📝 آخر التسجيلات المبكرة</h3><a href="/admin/export/preregistrations" class="ad-export-btn">📥 تصدير CSV</a></div>
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
</style>
