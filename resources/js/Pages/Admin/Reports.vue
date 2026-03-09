<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ period: String, txByType: Object, txByStatus: Object, dailyVolume: Array, dailyUsers: Array, totalFees: Number, totalVolume: Number, topUsers: Array, currencyDist: Array });

const currentPeriod = ref(props.period || '30');
const changePeriod = (p) => { currentPeriod.value = p; router.get(route('admin.reports'), { period: p }, { preserveState: true }); };

const fmt = (a) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
const fmtM = (a) => { if (a >= 1000000) return (a/1000000).toFixed(1) + 'M'; if (a >= 1000) return (a/1000).toFixed(1) + 'K'; return Number(a).toLocaleString(); };

const typeLabels = { transfer: 'تحويلات', deposit: 'إيداعات', withdrawal: 'سحوبات', exchange: 'صرف عملات', card_payment: 'بطاقات', fee: 'رسوم' };
const statusLabels = { completed: 'مكتملة', pending: 'معلقة', failed: 'فاشلة', reversed: 'مرتجعة' };

const maxVol = computed(() => Math.max(...(props.dailyVolume || []).map(d => d.volume), 1));
const maxCount = computed(() => Math.max(...(props.dailyVolume || []).map(d => d.count), 1));
const maxUsers = computed(() => Math.max(...(props.dailyUsers || []).map(d => d.count), 1));
const totalTxCount = computed(() => Object.values(props.txByType || {}).reduce((s, t) => s + (t.count || 0), 0));
const totalTxAmount = computed(() => Object.values(props.txByType || {}).reduce((s, t) => s + parseFloat(t.total_amount || 0), 0));

const sideLinks = [
  { label: 'لوحة التحكم', icon: '📊', route: 'admin.dashboard' },
  { label: 'قائمة الانتظار', icon: '📩', route: 'admin.waitlist' },
  { label: 'التقارير', icon: '📈', route: 'admin.reports', active: true },
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
</script>

<template>
  <Head title="Reports - التقارير المالية" />
  <AuthenticatedLayout>
    <div class="ad-root">
      <aside class="ad-sidebar">
        <div class="ad-logo"><div class="ad-logo-icon">SDB</div><span class="ad-logo-text">لوحة الإدارة</span></div>
        <nav class="ad-nav">
          <Link v-for="l in sideLinks" :key="l.route + l.label" :href="route(l.route)" :class="['ad-nav-item', l.active ? 'ad-nav-active' : '']">
            <span class="ad-nav-icon">{{ l.icon }}</span><span class="ad-nav-label">{{ l.label }}</span>
          </Link>
        </nav>
      </aside>

      <main class="ad-main">
        <header class="ad-topbar">
          <div><h1 class="ad-title">📈 التقارير والتحليلات المالية</h1><p class="ad-subtitle">تحليل شامل لأداء البنك والمعاملات</p></div>
          <div class="ad-period-group">
            <button v-for="p in [{v:'7',l:'7 أيام'},{v:'14',l:'14 يوم'},{v:'30',l:'شهر'},{v:'90',l:'3 أشهر'}]" :key="p.v" @click="changePeriod(p.v)" :class="['ad-period', currentPeriod == p.v ? 'ad-period-active' : '']">{{ p.l }}</button>
          </div>
        </header>

        <div class="ad-content">
          <!-- Summary Cards -->
          <div class="ad-stats-grid">
            <div class="ad-sum"><div class="ad-sum-icon" style="background:#172554">💸</div><div><div class="ad-sum-label">إجمالي الحجم</div><div class="ad-sum-value" style="color:#60a5fa">{{ fmtM(totalVolume) }} €</div></div></div>
            <div class="ad-sum"><div class="ad-sum-icon" style="background:#064e3b">💰</div><div><div class="ad-sum-label">إيرادات الرسوم</div><div class="ad-sum-value" style="color:#34d399">{{ fmtM(totalFees) }} €</div></div></div>
            <div class="ad-sum"><div class="ad-sum-icon" style="background:#2e1065">📊</div><div><div class="ad-sum-label">إجمالي المعاملات</div><div class="ad-sum-value" style="color:#a78bfa">{{ fmt(totalTxCount) }}</div></div></div>
            <div class="ad-sum"><div class="ad-sum-icon" style="background:#422006">📉</div><div><div class="ad-sum-label">متوسط المعاملة</div><div class="ad-sum-value" style="color:#fbbf24">{{ totalTxCount > 0 ? fmtM(totalTxAmount / totalTxCount) : '0' }} €</div></div></div>
          </div>

          <!-- Charts Row -->
          <div class="grid grid-cols-2 gap-4">
            <div class="ad-chart-card">
              <h3 class="ad-section-title">📈 حجم المعاملات اليومي</h3>
              <div class="ad-bar-chart">
                <div v-for="d in dailyVolume" :key="d.date" class="ad-bar-col" :title="'الحجم: ' + fmtM(d.volume)">
                  <div class="ad-bar-wrapper"><div class="ad-bar ad-bar-blue" :style="{height: Math.max((d.volume / maxVol) * 100, 4) + '%'}"></div></div>
                  <div class="ad-bar-date">{{ d.date }}</div>
                  <div class="ad-bar-val" style="color:#60a5fa">{{ fmtM(d.volume) }}</div>
                </div>
              </div>
            </div>
            <div class="ad-chart-card">
              <h3 class="ad-section-title">📊 عدد المعاملات اليومي</h3>
              <div class="ad-bar-chart">
                <div v-for="d in dailyVolume" :key="d.date" class="ad-bar-col" :title="'العدد: ' + d.count">
                  <div class="ad-bar-wrapper"><div class="ad-bar ad-bar-green" :style="{height: Math.max((d.count / maxCount) * 100, 4) + '%'}"></div></div>
                  <div class="ad-bar-date">{{ d.date }}</div>
                  <div class="ad-bar-val" style="color:#34d399">{{ d.count }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- User Growth + Fee Revenue -->
          <div class="grid grid-cols-2 gap-4">
            <div class="ad-chart-card">
              <h3 class="ad-section-title">👥 نمو المستخدمين اليومي</h3>
              <div class="ad-bar-chart">
                <div v-for="d in dailyUsers" :key="d.date" class="ad-bar-col" :title="'جديد: ' + d.count + ' · إجمالي: ' + d.cumulative">
                  <div class="ad-bar-wrapper"><div class="ad-bar ad-bar-purple" :style="{height: Math.max((d.count / Math.max(maxUsers, 1)) * 100, 4) + '%'}"></div></div>
                  <div class="ad-bar-date">{{ d.date }}</div>
                  <div class="ad-bar-val" style="color:#a78bfa">+{{ d.count }}</div>
                  <div class="ad-bar-sub">Σ{{ d.cumulative }}</div>
                </div>
              </div>
            </div>
            <div class="ad-chart-card">
              <h3 class="ad-section-title">💰 إيرادات الرسوم اليومية</h3>
              <div class="ad-bar-chart">
                <div v-for="d in dailyVolume" :key="d.date" class="ad-bar-col" :title="'الرسوم: ' + fmtM(d.fees)">
                  <div class="ad-bar-wrapper"><div class="ad-bar ad-bar-amber" :style="{height: Math.max((d.fees / Math.max(...dailyVolume.map(x=>x.fees), 1)) * 100, 4) + '%'}"></div></div>
                  <div class="ad-bar-date">{{ d.date }}</div>
                  <div class="ad-bar-val" style="color:#fbbf24">{{ fmtM(d.fees) }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Breakdown Row -->
          <div class="grid grid-cols-3 gap-4">
            <div class="ad-card">
              <h3 class="ad-section-title">📋 تقسيم حسب النوع</h3>
              <div class="ad-breakdown-list">
                <div v-for="(val, type) in txByType" :key="type" class="ad-breakdown-row">
                  <span class="ad-breakdown-label">{{ typeLabels[type] || type }}</span>
                  <div class="ad-breakdown-right"><span class="ad-breakdown-count">{{ val.count }} عملية</span><span class="ad-breakdown-amount">{{ fmtM(val.total_amount) }} €</span></div>
                </div>
                <div v-if="!Object.keys(txByType || {}).length" class="ad-empty">لا توجد بيانات</div>
              </div>
            </div>
            <div class="ad-card">
              <h3 class="ad-section-title">📊 تقسيم حسب الحالة</h3>
              <div class="ad-breakdown-list">
                <div v-for="(val, status) in txByStatus" :key="status" class="ad-breakdown-row">
                  <span :class="['ad-status-badge', status === 'completed' ? 'ad-s-green' : status === 'pending' ? 'ad-s-yellow' : 'ad-s-red']">{{ statusLabels[status] || status }}</span>
                  <div class="ad-breakdown-right"><span class="ad-breakdown-count">{{ val.count }}</span><span class="ad-breakdown-amount">{{ fmtM(val.total_amount) }} €</span></div>
                </div>
              </div>
            </div>
            <div class="ad-card">
              <h3 class="ad-section-title">💱 توزيع العملات</h3>
              <div class="ad-breakdown-list">
                <div v-for="c in currencyDist" :key="c.currency" class="ad-breakdown-row">
                  <div class="flex items-center gap-3"><span class="text-xl">{{ c.symbol }}</span><span class="ad-breakdown-label">{{ c.currency }}</span></div>
                  <div class="ad-breakdown-right"><span class="ad-breakdown-count">{{ c.accounts }} حساب</span><span class="ad-breakdown-amount" style="color:#34d399">{{ fmtM(c.balance) }}</span></div>
                </div>
              </div>
            </div>
          </div>

          <!-- Top Users -->
          <div class="ad-card">
            <h3 class="ad-section-title">🏆 أعلى العملاء حسب حجم المعاملات</h3>
            <div class="overflow-x-auto">
              <table class="ad-table">
                <thead><tr><th>#</th><th>العميل</th><th>رقم العميل</th><th>عدد المعاملات</th><th>حجم المعاملات</th><th>الحسابات</th><th>إجراء</th></tr></thead>
                <tbody>
                  <tr v-for="(u, i) in topUsers" :key="u.id">
                    <td><span :class="['ad-rank', i < 3 ? 'ad-rank-top' : '']">{{ i + 1 }}</span></td>
                    <td><div class="flex items-center gap-3"><div class="ad-user-avatar">{{ u.full_name?.charAt(0) }}</div><span class="ad-table-name">{{ u.full_name }}</span></div></td>
                    <td class="ad-table-mono">{{ u.customer_number }}</td>
                    <td class="ad-table-bold">{{ u.tx_count }}</td>
                    <td class="ad-table-amount">{{ fmtM(u.tx_volume) }} €</td>
                    <td>{{ u.accounts_count }}</td>
                    <td><Link :href="route('admin.users.show', u.id)" class="ad-link">عرض ←</Link></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </main>
    </div>
  </AuthenticatedLayout>
</template>

<style>
@import '../../../css/admin.css';
</style>
