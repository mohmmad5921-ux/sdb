<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
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
</script>

<template>
  <Head title="Reports - التقارير المالية" />
  <AdminLayout title="📈 التقارير والتحليلات المالية" subtitle="تحليل شامل لأداء البنك والمعاملات">
    <template #actions>
      <div class="ad-period-group">
        <button v-for="p in [{v:'7',l:'7 أيام'},{v:'14',l:'14 يوم'},{v:'30',l:'شهر'},{v:'90',l:'3 أشهر'}]" :key="p.v" @click="changePeriod(p.v)" :class="['ad-period', currentPeriod == p.v ? 'ad-period-active' : '']">{{ p.l }}</button>
      </div>
    </template>

    <!-- Summary Cards -->
    <div class="ad-stats-grid">
      <div class="ad-sum"><div class="ad-sum-icon" style="background:#eff6ff">💸</div><div><div class="ad-sum-label">إجمالي الحجم</div><div class="ad-sum-value" style="color:#2563eb">{{ fmtM(totalVolume) }} €</div></div></div>
      <div class="ad-sum"><div class="ad-sum-icon" style="background:#d1fae5">💰</div><div><div class="ad-sum-label">إيرادات الرسوم</div><div class="ad-sum-value" style="color:#059669">{{ fmtM(totalFees) }} €</div></div></div>
      <div class="ad-sum"><div class="ad-sum-icon" style="background:#f5f3ff">📊</div><div><div class="ad-sum-label">إجمالي المعاملات</div><div class="ad-sum-value" style="color:#7c3aed">{{ fmt(totalTxCount) }}</div></div></div>
      <div class="ad-sum"><div class="ad-sum-icon" style="background:#fef3c7">📉</div><div><div class="ad-sum-label">متوسط المعاملة</div><div class="ad-sum-value" style="color:#d97706">{{ totalTxCount > 0 ? fmtM(totalTxAmount / totalTxCount) : '0' }} €</div></div></div>
    </div>

    <!-- Charts -->
    <div class="grid grid-cols-2 gap-4">
      <div class="ad-chart-card">
        <h3 class="ad-section-title">📈 حجم المعاملات اليومي</h3>
        <div class="ad-bar-chart">
          <div v-for="d in dailyVolume" :key="d.date" class="ad-bar-col" :title="'الحجم: ' + fmtM(d.volume)">
            <div class="ad-bar-wrapper"><div class="ad-bar ad-bar-blue" :style="{height: Math.max((d.volume / maxVol) * 100, 4) + '%'}"></div></div>
            <div class="ad-bar-date">{{ d.date }}</div>
            <div class="ad-bar-val" style="color:#2563eb">{{ fmtM(d.volume) }}</div>
          </div>
        </div>
      </div>
      <div class="ad-chart-card">
        <h3 class="ad-section-title">📊 عدد المعاملات اليومي</h3>
        <div class="ad-bar-chart">
          <div v-for="d in dailyVolume" :key="d.date" class="ad-bar-col" :title="'العدد: ' + d.count">
            <div class="ad-bar-wrapper"><div class="ad-bar ad-bar-green" :style="{height: Math.max((d.count / maxCount) * 100, 4) + '%'}"></div></div>
            <div class="ad-bar-date">{{ d.date }}</div>
            <div class="ad-bar-val" style="color:#059669">{{ d.count }}</div>
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
            <div class="ad-bar-val" style="color:#7c3aed">+{{ d.count }}</div>
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
            <div class="ad-bar-val" style="color:#d97706">{{ fmtM(d.fees) }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Breakdowns -->
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
            <div class="flex items-center gap-3"><span style="font-size:20px">{{ c.symbol }}</span><span class="ad-breakdown-label">{{ c.currency }}</span></div>
            <div class="ad-breakdown-right"><span class="ad-breakdown-count">{{ c.accounts }} حساب</span><span class="ad-breakdown-amount" style="color:#059669">{{ fmtM(c.balance) }}</span></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Top Users -->
    <div class="ad-card">
      <h3 class="ad-section-title">🏆 أعلى العملاء حسب حجم المعاملات</h3>
      <div style="overflow-x:auto">
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
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
</style>
