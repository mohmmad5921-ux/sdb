<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ stats: Object, usersByCountry: Array, topActiveUsers: Array, recentTransactions: Array, monthlyTrend: Array, userGrowth: Array });
const f = n => Number(n||0).toLocaleString('en');
const fc = n => '€' + Number(n||0).toLocaleString('en', {minimumFractionDigits:2});
const maxVol = () => Math.max(...(p.monthlyTrend||[]).map(m=>m.volume), 1);
const maxGr = () => Math.max(...(p.userGrowth||[]).map(m=>m.count), 1);
const statusColor = s => ({completed:'#10b981',failed:'#ef4444',pending:'#f59e0b'}[s]||'#64748b');
const statusLabel = s => ({completed:'ناجح',failed:'فشل',pending:'معلّق',cancelled:'ملغي'}[s]||s);
</script>
<template>
<Head title="لوحة التحكم" />
<div class="db">
  <!-- HEADER -->
  <div class="db-header"><h1 class="db-h">📊 لوحة التحكم الرئيسية</h1><div class="db-time">{{ new Date().toLocaleDateString('ar', {weekday:'long',year:'numeric',month:'long',day:'numeric'}) }}</div></div>

  <!-- ═══════════════════════ KPI GRID ═══════════════════════ -->
  <div class="db-section-title">👥 المستخدمين</div>
  <div class="db-kpi-row">
    <div class="db-k"><div class="db-k-ic" style="background:#eff6ff">👥</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.totalUsers) }}</div><div class="db-k-l">إجمالي المستخدمين</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#ecfdf5">📝</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.newToday) }}</div><div class="db-k-l">جدد اليوم</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#fef3c7">⚡</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.activeUsers) }}</div><div class="db-k-l">نشطين (30 يوم)</div></div></div>
  </div>

  <div class="db-section-title">🏦 الحسابات والأرصدة</div>
  <div class="db-kpi-row">
    <div class="db-k"><div class="db-k-ic" style="background:#ecfdf5">🏦</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.activeAccounts) }}</div><div class="db-k-l">حسابات نشطة</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#fef2f2">🧊</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.frozenAccounts) }}</div><div class="db-k-l">حسابات مجمّدة</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#f0fdf4">💰</div><div class="db-k-b"><div class="db-k-v db-k-big">{{ fc(p.stats.totalBalance) }}</div><div class="db-k-l">إجمالي الأرصدة</div></div></div>
  </div>

  <div class="db-section-title">💸 المعاملات</div>
  <div class="db-kpi-row db-kpi-5">
    <div class="db-k"><div class="db-k-ic" style="background:#fef3c7">📅</div><div class="db-k-b"><div class="db-k-v">{{ fc(p.stats.dailyVolume) }}</div><div class="db-k-l">حجم اليوم</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#eff6ff">📆</div><div class="db-k-b"><div class="db-k-v">{{ fc(p.stats.monthlyVolume) }}</div><div class="db-k-l">حجم الشهر</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#f5f3ff">📊</div><div class="db-k-b"><div class="db-k-v">{{ fc(p.stats.yearlyVolume) }}</div><div class="db-k-l">حجم السنة</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#ecfdf5">✅</div><div class="db-k-b"><div class="db-k-v" style="color:#10b981">{{ f(p.stats.successTx) }}</div><div class="db-k-l">ناجحة</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#fef2f2">❌</div><div class="db-k-b"><div class="db-k-v" style="color:#ef4444">{{ f(p.stats.failedTx) }}</div><div class="db-k-l">فاشلة</div></div></div>
  </div>
  <div class="db-kpi-row">
    <div class="db-k"><div class="db-k-ic" style="background:#fefce8">⏳</div><div class="db-k-b"><div class="db-k-v" style="color:#ca8a04">{{ f(p.stats.pendingTx) }}</div><div class="db-k-l">معلّقة</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#eff6ff">🌍</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.internationalTx) }}</div><div class="db-k-l">دولية</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#ecfdf5">🏠</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.localTx) }}</div><div class="db-k-l">محلية</div></div></div>
  </div>

  <div class="db-section-title">💹 الإيرادات والبطاقات</div>
  <div class="db-kpi-row db-kpi-5">
    <div class="db-k"><div class="db-k-ic" style="background:#ecfdf5">💹</div><div class="db-k-b"><div class="db-k-v" style="color:#059669">{{ fc(p.stats.systemProfit) }}</div><div class="db-k-l">أرباح النظام</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#f0fdf4">🧾</div><div class="db-k-b"><div class="db-k-v">{{ fc(p.stats.feesCollected) }}</div><div class="db-k-l">رسوم الشهر</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#eff6ff">💳</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.totalCards) }}</div><div class="db-k-l">بطاقات صادرة</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#ecfdf5">✅</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.activeCards) }}</div><div class="db-k-l">بطاقات نشطة</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#fef2f2">🧊</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.frozenCards) }}</div><div class="db-k-l">بطاقات مجمّدة</div></div></div>
  </div>

  <div class="db-section-title">🛡️ الأمان والمعلّقات</div>
  <div class="db-kpi-row db-kpi-5">
    <div class="db-k"><div class="db-k-ic" style="background:#fef2f2">🚨</div><div class="db-k-b"><div class="db-k-v" style="color:#ef4444">{{ f(p.stats.securityAlerts) }}</div><div class="db-k-l">إنذارات أمنية</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#fef2f2">🔍</div><div class="db-k-b"><div class="db-k-v" style="color:#dc2626">{{ f(p.stats.suspiciousTx) }}</div><div class="db-k-l">عمليات مشبوهة</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#fefce8">🪪</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.pendingKyc) }}</div><div class="db-k-l">KYC معلّق</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#fef3c7">✅</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.pendingApprovals) }}</div><div class="db-k-l">موافقات معلّقة</div></div></div>
    <div class="db-k"><div class="db-k-ic" style="background:#eff6ff">🎫</div><div class="db-k-b"><div class="db-k-v">{{ f(p.stats.openTickets) }}</div><div class="db-k-l">تذاكر مفتوحة</div></div></div>
  </div>

  <!-- ═══════════════════════ CHARTS ═══════════════════════ -->
  <div class="db-grid-2">
    <!-- Monthly Transaction Volume -->
    <div class="db-card">
      <div class="db-card-title">📈 حجم المعاملات الشهري</div>
      <div class="db-chart">
        <div v-for="m in p.monthlyTrend" :key="m.month" class="db-bar-w">
          <div class="db-bar" :style="{height: (m.volume/maxVol()*100)+'%'}"><span class="db-bar-tip">{{ fc(m.volume) }}</span></div>
          <div class="db-bar-l">{{ m.month.slice(5) }}</div>
        </div>
        <div v-if="!p.monthlyTrend?.length" class="db-empty">لا توجد بيانات</div>
      </div>
    </div>
    <!-- User Growth -->
    <div class="db-card">
      <div class="db-card-title">👥 نمو المستخدمين</div>
      <div class="db-chart">
        <div v-for="m in p.userGrowth" :key="m.month" class="db-bar-w">
          <div class="db-bar db-bar-green" :style="{height: (m.count/maxGr()*100)+'%'}"><span class="db-bar-tip">{{ m.count }}</span></div>
          <div class="db-bar-l">{{ m.month.slice(5) }}</div>
        </div>
        <div v-if="!p.userGrowth?.length" class="db-empty">لا توجد بيانات</div>
      </div>
    </div>
  </div>

  <!-- ═══════════════════════ TABLES ═══════════════════════ -->
  <div class="db-grid-2">
    <!-- Recent Transactions -->
    <div class="db-card">
      <div class="db-card-title">💸 آخر المعاملات</div>
      <table class="db-tbl"><thead><tr><th>المستخدم</th><th>المبلغ</th><th>النوع</th><th>الحالة</th><th>التاريخ</th></tr></thead>
        <tbody><tr v-for="t in p.recentTransactions" :key="t.id">
          <td class="db-bold">{{ t.user_name||'—' }}</td>
          <td>{{ fc(t.amount) }}</td>
          <td><span class="db-tag">{{ t.type }}</span></td>
          <td><span class="db-st" :style="{color:statusColor(t.status)}">{{ statusLabel(t.status) }}</span></td>
          <td class="db-date">{{ new Date(t.created_at).toLocaleString('ar') }}</td>
        </tr><tr v-if="!p.recentTransactions?.length"><td colspan="5" class="db-empty">لا توجد معاملات</td></tr></tbody>
      </table>
    </div>

    <!-- Top Active Users + Countries -->
    <div class="db-card">
      <div class="db-card-title">🏆 أكثر المستخدمين نشاطاً</div>
      <table class="db-tbl"><thead><tr><th>#</th><th>المستخدم</th><th>العمليات</th><th>الحجم</th></tr></thead>
        <tbody><tr v-for="(u,i) in p.topActiveUsers" :key="u.id">
          <td>{{ i+1 }}</td><td class="db-bold">{{ u.full_name }}</td><td>{{ f(u.tx_count) }}</td><td>{{ fc(u.total_volume) }}</td>
        </tr><tr v-if="!p.topActiveUsers?.length"><td colspan="4" class="db-empty">لا توجد بيانات</td></tr></tbody>
      </table>

      <div class="db-card-title" style="margin-top:20px">🌍 المستخدمين حسب الدولة</div>
      <div class="db-country-list">
        <div v-for="c in p.usersByCountry" :key="c.country" class="db-country"><span>{{ c.country }}</span><span class="db-country-n">{{ f(c.count) }}</span></div>
        <div v-if="!p.usersByCountry?.length" class="db-empty">لا توجد بيانات</div>
      </div>
    </div>
  </div>
</div>
</template>
<style scoped>
.db{padding:24px;direction:rtl;max-width:1400px;margin:0 auto}
.db-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:24px}.db-h{font-size:24px;font-weight:900;color:#0f172a}.db-time{font-size:13px;color:#94a3b8}
.db-section-title{font-size:14px;font-weight:800;color:#475569;margin:20px 0 10px;padding-bottom:6px;border-bottom:1px solid #f1f5f9}

/* KPI Cards */
.db-kpi-row{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:8px}.db-kpi-5{grid-template-columns:repeat(5,1fr)}
.db-k{display:flex;align-items:center;gap:12px;background:#fff;border-radius:14px;padding:16px;border:1px solid #f1f5f9;transition:transform .15s}.db-k:hover{transform:translateY(-2px);box-shadow:0 4px 12px rgba(0,0,0,.04)}
.db-k-ic{width:42px;height:42px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
.db-k-b{flex:1;min-width:0}.db-k-v{font-size:20px;font-weight:900;color:#0f172a;line-height:1.2}.db-k-big{font-size:17px}.db-k-l{font-size:11px;color:#94a3b8;font-weight:600;margin-top:2px}

/* Charts */
.db-grid-2{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-top:16px}
.db-card{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9}
.db-card-title{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:14px}
.db-chart{display:flex;align-items:flex-end;gap:6px;height:180px;padding-top:20px}
.db-bar-w{flex:1;display:flex;flex-direction:column;align-items:center;height:100%}.db-bar{background:linear-gradient(180deg,#3b82f6,#1d4ed8);border-radius:6px 6px 0 0;min-height:4px;width:100%;position:relative;transition:height .3s}.db-bar-green{background:linear-gradient(180deg,#10b981,#059669)}
.db-bar-tip{display:none;position:absolute;top:-24px;left:50%;transform:translateX(-50%);background:#0f172a;color:#fff;padding:2px 6px;border-radius:4px;font-size:9px;white-space:nowrap}.db-bar:hover .db-bar-tip{display:block}
.db-bar-l{font-size:9px;color:#94a3b8;margin-top:4px;text-align:center}

/* Tables */
.db-tbl{width:100%;border-collapse:collapse}.db-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:8px 10px;border-bottom:1px solid #f1f5f9}
.db-tbl td{font-size:12px;color:#334155;padding:8px 10px;border-bottom:1px solid #f8fafc}.db-bold{font-weight:700}
.db-tag{font-size:10px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b}.db-st{font-size:11px;font-weight:700}.db-date{font-size:10px;color:#94a3b8}
.db-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px}

/* Countries */
.db-country-list{display:flex;flex-direction:column;gap:4px}.db-country{display:flex;justify-content:space-between;padding:6px 10px;border-radius:8px;font-size:12px;color:#475569}.db-country:hover{background:#f8fafc}.db-country-n{font-weight:700;color:#2563eb}
</style>
