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
  { label: 'التقارير', icon: '📈', route: 'admin.reports', active: true },
  { label: 'قائمة الانتظار', icon: '📩', route: 'admin.waitlist' },
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
    <div class="rp-root">
      <!-- Sidebar -->
      <aside class="rp-sidebar">
        <div class="rp-logo"><span class="text-lg font-black text-[#1A2B4A]">SDB Admin</span></div>
        <nav class="rp-nav">
          <Link v-for="l in sideLinks" :key="l.route" :href="route(l.route)" :class="['rp-nav-item', l.active ? 'rp-nav-active' : '']"><span>{{ l.icon }}</span><span>{{ l.label }}</span></Link>
        </nav>
      </aside>

      <main class="rp-main">
        <header class="rp-topbar">
          <h2 class="text-lg font-bold text-[#1A2B4A]">📈 التقارير والتحليلات المالية</h2>
          <div class="flex items-center gap-2">
            <button v-for="p in [{v:'7',l:'7 أيام'},{v:'14',l:'14 يوم'},{v:'30',l:'شهر'},{v:'90',l:'3 أشهر'}]" :key="p.v" @click="changePeriod(p.v)" :class="['rp-period', currentPeriod == p.v ? 'rp-period-active' : '']">{{ p.l }}</button>
          </div>
        </header>

        <div class="rp-content">
          <!-- Summary Cards -->
          <div class="grid grid-cols-4 gap-4">
            <div class="rp-sum-card"><div class="rp-sum-icon" style="background:rgba(30,94,255,0.08)">💸</div><div><div class="text-xs text-[#8896AB]">إجمالي الحجم</div><div class="text-2xl font-black text-[#1A2B4A]">{{ fmtM(totalVolume) }} €</div></div></div>
            <div class="rp-sum-card"><div class="rp-sum-icon" style="background:rgba(16,185,129,0.08)">💰</div><div><div class="text-xs text-[#8896AB]">إيرادات الرسوم</div><div class="text-2xl font-black text-emerald-600">{{ fmtM(totalFees) }} €</div></div></div>
            <div class="rp-sum-card"><div class="rp-sum-icon" style="background:rgba(139,92,246,0.08)">📊</div><div><div class="text-xs text-[#8896AB]">إجمالي المعاملات</div><div class="text-2xl font-black text-purple-600">{{ fmt(totalTxCount) }}</div></div></div>
            <div class="rp-sum-card"><div class="rp-sum-icon" style="background:rgba(245,158,11,0.08)">📉</div><div><div class="text-xs text-[#8896AB]">متوسط المعاملة</div><div class="text-2xl font-black text-amber-600">{{ totalTxCount > 0 ? fmtM(totalTxAmount / totalTxCount) : '0' }} €</div></div></div>
          </div>

          <!-- Charts Row -->
          <div class="grid grid-cols-2 gap-4">
            <!-- Volume Chart -->
            <div class="rp-chart-card">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">📈 حجم المعاملات اليومي</h3>
              <div class="rp-bar-chart">
                <div v-for="d in dailyVolume" :key="d.date" class="rp-bar-col">
                  <div class="rp-bar-wrapper"><div class="rp-bar" :style="{height: Math.max((d.volume / maxVol) * 100, 3) + '%'}"></div></div>
                  <div class="text-[9px] text-[#8896AB] mt-1">{{ d.date }}</div>
                  <div class="text-[8px] text-[#1E5EFF] font-bold">{{ fmtM(d.volume) }}</div>
                </div>
              </div>
            </div>
            <!-- Count Chart -->
            <div class="rp-chart-card">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">📊 عدد المعاملات اليومي</h3>
              <div class="rp-bar-chart">
                <div v-for="d in dailyVolume" :key="d.date" class="rp-bar-col">
                  <div class="rp-bar-wrapper"><div class="rp-bar rp-bar-green" :style="{height: Math.max((d.count / maxCount) * 100, 3) + '%'}"></div></div>
                  <div class="text-[9px] text-[#8896AB] mt-1">{{ d.date }}</div>
                  <div class="text-[8px] text-emerald-600 font-bold">{{ d.count }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- User Growth + Fee Revenue -->
          <div class="grid grid-cols-2 gap-4">
            <div class="rp-chart-card">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">👥 نمو المستخدمين اليومي</h3>
              <div class="rp-bar-chart">
                <div v-for="d in dailyUsers" :key="d.date" class="rp-bar-col" :title="'جديد: ' + d.count + ' · إجمالي: ' + d.cumulative">
                  <div class="rp-bar-wrapper"><div class="rp-bar rp-bar-purple" :style="{height: Math.max((d.count / Math.max(maxUsers, 1)) * 100, 3) + '%'}"></div></div>
                  <div class="text-[9px] text-[#8896AB] mt-1">{{ d.date }}</div>
                  <div class="text-[8px] text-purple-600 font-bold">+{{ d.count }}</div>
                  <div class="text-[7px] text-[#8896AB]">Σ{{ d.cumulative }}</div>
                </div>
              </div>
            </div>
            <div class="rp-chart-card">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">💰 إيرادات الرسوم اليومية</h3>
              <div class="rp-bar-chart">
                <div v-for="d in dailyVolume" :key="d.date" class="rp-bar-col">
                  <div class="rp-bar-wrapper"><div class="rp-bar rp-bar-amber" :style="{height: Math.max((d.fees / Math.max(...dailyVolume.map(x=>x.fees), 1)) * 100, 3) + '%'}"></div></div>
                  <div class="text-[9px] text-[#8896AB] mt-1">{{ d.date }}</div>
                  <div class="text-[8px] text-amber-600 font-bold">{{ fmtM(d.fees) }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Breakdown Row -->
          <div class="grid grid-cols-3 gap-4">
            <!-- By Type -->
            <div class="rp-card">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">📋 تقسيم حسب النوع</h3>
              <div class="space-y-2">
                <div v-for="(val, type) in txByType" :key="type" class="rp-breakdown-row">
                  <div class="flex items-center gap-2"><span class="font-semibold text-[#1A2B4A] text-sm">{{ typeLabels[type] || type }}</span></div>
                  <div class="flex items-center gap-3"><span class="text-xs text-[#8896AB]">{{ val.count }} عملية</span><span class="font-bold text-sm text-[#1A2B4A]">{{ fmtM(val.total_amount) }} €</span></div>
                </div>
                <div v-if="!Object.keys(txByType || {}).length" class="text-center text-sm text-[#8896AB] py-4">لا توجد بيانات</div>
              </div>
            </div>
            <!-- By Status -->
            <div class="rp-card">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">📊 تقسيم حسب الحالة</h3>
              <div class="space-y-2">
                <div v-for="(val, status) in txByStatus" :key="status" class="rp-breakdown-row">
                  <span :class="['rp-status-badge', status === 'completed' ? 'rp-s-green' : status === 'pending' ? 'rp-s-yellow' : 'rp-s-red']">{{ statusLabels[status] || status }}</span>
                  <div class="flex items-center gap-3"><span class="text-xs text-[#8896AB]">{{ val.count }}</span><span class="font-bold text-sm text-[#1A2B4A]">{{ fmtM(val.total_amount) }} €</span></div>
                </div>
              </div>
            </div>
            <!-- Currency Distribution -->
            <div class="rp-card">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">💱 توزيع العملات</h3>
              <div class="space-y-2">
                <div v-for="c in currencyDist" :key="c.currency" class="rp-breakdown-row">
                  <div class="flex items-center gap-2"><span class="text-lg">{{ c.symbol }}</span><span class="font-semibold text-sm text-[#1A2B4A]">{{ c.currency }}</span></div>
                  <div class="flex items-center gap-3"><span class="text-xs text-[#8896AB]">{{ c.accounts }} حساب</span><span class="font-bold text-sm text-emerald-600">{{ fmtM(c.balance) }}</span></div>
                </div>
              </div>
            </div>
          </div>

          <!-- Top Users -->
          <div class="rp-card">
            <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">🏆 أعلى العملاء حسب حجم المعاملات</h3>
            <div class="overflow-x-auto">
              <table class="rp-table">
                <thead><tr><th>#</th><th>العميل</th><th>رقم العميل</th><th>عدد المعاملات</th><th>حجم المعاملات</th><th>الحسابات</th><th>إجراء</th></tr></thead>
                <tbody>
                  <tr v-for="(u, i) in topUsers" :key="u.id">
                    <td><span class="rp-rank" :class="i < 3 ? 'rp-rank-top' : ''">{{ i + 1 }}</span></td>
                    <td><div class="flex items-center gap-2"><div class="rp-avatar">{{ u.full_name?.charAt(0) }}</div><span class="font-semibold text-[#1A2B4A]">{{ u.full_name }}</span></div></td>
                    <td class="font-mono text-xs text-[#1E5EFF]">{{ u.customer_number }}</td>
                    <td class="font-semibold">{{ u.tx_count }}</td>
                    <td class="font-bold text-emerald-600">{{ fmtM(u.tx_volume) }} €</td>
                    <td>{{ u.accounts_count }}</td>
                    <td><Link :href="route('admin.users.show', u.id)" class="rp-link">عرض ←</Link></td>
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

<style scoped>
.rp-root{display:flex;min-height:100vh;background:#F0F2F5;direction:rtl}
.rp-sidebar{width:200px;background:#fff;border-left:1px solid #E8ECF1;flex-shrink:0}
.rp-logo{padding:16px;border-bottom:1px solid #E8ECF1}
.rp-nav{padding:10px 8px;display:flex;flex-direction:column;gap:2px}
.rp-nav-item{display:flex;align-items:center;gap:8px;padding:9px 12px;border-radius:10px;font-size:12px;color:#5A6B82;text-decoration:none;font-weight:500}.rp-nav-item:hover{background:#F0F4FF;color:#1E5EFF}
.rp-nav-active{background:#F0F4FF!important;color:#1E5EFF!important;font-weight:700}
.rp-main{flex:1;display:flex;flex-direction:column;overflow-y:auto}
.rp-topbar{display:flex;justify-content:space-between;align-items:center;padding:14px 24px;background:#fff;border-bottom:1px solid #E8ECF1}
.rp-content{padding:20px 24px;display:flex;flex-direction:column;gap:16px}
.rp-period{padding:6px 14px;border-radius:8px;font-size:12px;font-weight:600;border:1px solid #E8ECF1;background:#fff;color:#5A6B82;cursor:pointer}.rp-period:hover{border-color:#1E5EFF;color:#1E5EFF}
.rp-period-active{background:#1E5EFF!important;color:#fff!important;border-color:#1E5EFF!important}
.rp-sum-card{background:#fff;border:1px solid #E8ECF1;border-radius:14px;padding:16px;display:flex;align-items:center;gap:12px}
.rp-sum-icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
.rp-chart-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px;padding:20px}
.rp-bar-chart{display:flex;align-items:flex-end;gap:4px;height:110px}
.rp-bar-col{flex:1;display:flex;flex-direction:column;align-items:center;cursor:pointer;transition:transform .2s}.rp-bar-col:hover{transform:translateY(-2px)}.rp-bar-col:hover .rp-bar{filter:brightness(1.2)}
.rp-bar-wrapper{height:90px;width:100%;display:flex;align-items:flex-end;justify-content:center}
.rp-bar{width:65%;border-radius:4px 4px 0 0;background:linear-gradient(180deg,#1E5EFF,#3B82F6);min-height:2px;transition:height .4s}
.rp-bar-green{background:linear-gradient(180deg,#10b981,#34d399)}.rp-bar-purple{background:linear-gradient(180deg,#8b5cf6,#a78bfa)}.rp-bar-amber{background:linear-gradient(180deg,#f59e0b,#fbbf24)}
.rp-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px;padding:18px}
.rp-breakdown-row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid #F0F2F5}.rp-breakdown-row:last-child{border:none}
.rp-status-badge{font-size:11px;padding:2px 10px;border-radius:100px;font-weight:600}
.rp-s-green{background:rgba(16,185,129,0.1);color:#059669}.rp-s-yellow{background:rgba(245,158,11,0.1);color:#d97706}.rp-s-red{background:rgba(239,68,68,0.1);color:#dc2626}
.rp-table{width:100%;border-collapse:collapse;font-size:13px}
.rp-table th{text-align:right;padding:10px 12px;background:#FAFBFC;color:#8896AB;font-weight:600;font-size:11px;border-bottom:2px solid #E8ECF1}
.rp-table td{padding:10px 12px;border-bottom:1px solid #F0F2F5;color:#1A2B4A}
.rp-table tr:hover td{background:#FAFBFC}
.rp-avatar{width:28px;height:28px;border-radius:8px;background:linear-gradient(135deg,#1E5EFF,#3B82F6);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:11px;flex-shrink:0}
.rp-rank{width:24px;height:24px;border-radius:6px;background:#F0F2F5;display:inline-flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:#5A6B82}
.rp-rank-top{background:linear-gradient(135deg,#f59e0b,#fbbf24);color:#fff}
.rp-link{font-size:12px;color:#1E5EFF;text-decoration:none;font-weight:600}.rp-link:hover{text-decoration:underline}
</style>
