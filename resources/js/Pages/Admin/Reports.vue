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
    <div class="ar-root">
      <!-- Sidebar -->
      <aside class="ar-sidebar">
        <div class="ar-logo"><div class="ar-logo-icon">SDB</div><span class="ar-logo-text">لوحة الإدارة</span></div>
        <nav class="ar-nav">
          <Link v-for="l in sideLinks" :key="l.route + l.label" :href="route(l.route)" :class="['ar-nav-item', l.active ? 'ar-nav-active' : '']">
            <span class="ar-nav-icon">{{ l.icon }}</span><span>{{ l.label }}</span>
          </Link>
        </nav>
      </aside>

      <main class="ar-main">
        <header class="ar-topbar">
          <div><h1 class="ar-title">📈 التقارير والتحليلات المالية</h1><p class="ar-subtitle">تحليل شامل لأداء البنك والمعاملات</p></div>
          <div class="ar-period-group">
            <button v-for="p in [{v:'7',l:'7 أيام'},{v:'14',l:'14 يوم'},{v:'30',l:'شهر'},{v:'90',l:'3 أشهر'}]" :key="p.v" @click="changePeriod(p.v)" :class="['ar-period', currentPeriod == p.v ? 'ar-period-active' : '']">{{ p.l }}</button>
          </div>
        </header>

        <div class="ar-content">
          <!-- Summary Cards -->
          <div class="grid grid-cols-4 gap-4">
            <div class="ar-sum"><div class="ar-sum-icon" style="background:rgba(59,130,246,0.1)">💸</div><div><div class="ar-sum-label">إجمالي الحجم</div><div class="ar-sum-value" style="color:#60a5fa">{{ fmtM(totalVolume) }} €</div></div></div>
            <div class="ar-sum"><div class="ar-sum-icon" style="background:rgba(16,185,129,0.1)">💰</div><div><div class="ar-sum-label">إيرادات الرسوم</div><div class="ar-sum-value" style="color:#34d399">{{ fmtM(totalFees) }} €</div></div></div>
            <div class="ar-sum"><div class="ar-sum-icon" style="background:rgba(139,92,246,0.1)">📊</div><div><div class="ar-sum-label">إجمالي المعاملات</div><div class="ar-sum-value" style="color:#a78bfa">{{ fmt(totalTxCount) }}</div></div></div>
            <div class="ar-sum"><div class="ar-sum-icon" style="background:rgba(245,158,11,0.1)">📉</div><div><div class="ar-sum-label">متوسط المعاملة</div><div class="ar-sum-value" style="color:#fbbf24">{{ totalTxCount > 0 ? fmtM(totalTxAmount / totalTxCount) : '0' }} €</div></div></div>
          </div>

          <!-- Charts Row -->
          <div class="grid grid-cols-2 gap-4">
            <div class="ar-card">
              <h3 class="ar-section-title">📈 حجم المعاملات اليومي</h3>
              <div class="ar-bar-chart">
                <div v-for="d in dailyVolume" :key="d.date" class="ar-bar-col" :title="'الحجم: ' + fmtM(d.volume)">
                  <div class="ar-bar-wrapper"><div class="ar-bar" style="background:linear-gradient(180deg,#3b82f6,#1d4ed8)" :style="{height: Math.max((d.volume / maxVol) * 100, 3) + '%'}"></div></div>
                  <div class="ar-bar-date">{{ d.date }}</div>
                  <div class="ar-bar-val" style="color:#60a5fa">{{ fmtM(d.volume) }}</div>
                </div>
              </div>
            </div>
            <div class="ar-card">
              <h3 class="ar-section-title">📊 عدد المعاملات اليومي</h3>
              <div class="ar-bar-chart">
                <div v-for="d in dailyVolume" :key="d.date" class="ar-bar-col" :title="'العدد: ' + d.count">
                  <div class="ar-bar-wrapper"><div class="ar-bar" style="background:linear-gradient(180deg,#10b981,#059669)" :style="{height: Math.max((d.count / maxCount) * 100, 3) + '%'}"></div></div>
                  <div class="ar-bar-date">{{ d.date }}</div>
                  <div class="ar-bar-val" style="color:#34d399">{{ d.count }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- User Growth + Fee Revenue -->
          <div class="grid grid-cols-2 gap-4">
            <div class="ar-card">
              <h3 class="ar-section-title">👥 نمو المستخدمين اليومي</h3>
              <div class="ar-bar-chart">
                <div v-for="d in dailyUsers" :key="d.date" class="ar-bar-col" :title="'جديد: ' + d.count + ' · إجمالي: ' + d.cumulative">
                  <div class="ar-bar-wrapper"><div class="ar-bar" style="background:linear-gradient(180deg,#8b5cf6,#6d28d9)" :style="{height: Math.max((d.count / Math.max(maxUsers, 1)) * 100, 3) + '%'}"></div></div>
                  <div class="ar-bar-date">{{ d.date }}</div>
                  <div class="ar-bar-val" style="color:#a78bfa">+{{ d.count }}</div>
                  <div class="ar-bar-sub">Σ{{ d.cumulative }}</div>
                </div>
              </div>
            </div>
            <div class="ar-card">
              <h3 class="ar-section-title">💰 إيرادات الرسوم اليومية</h3>
              <div class="ar-bar-chart">
                <div v-for="d in dailyVolume" :key="d.date" class="ar-bar-col" :title="'الرسوم: ' + fmtM(d.fees)">
                  <div class="ar-bar-wrapper"><div class="ar-bar" style="background:linear-gradient(180deg,#f59e0b,#d97706)" :style="{height: Math.max((d.fees / Math.max(...dailyVolume.map(x=>x.fees), 1)) * 100, 3) + '%'}"></div></div>
                  <div class="ar-bar-date">{{ d.date }}</div>
                  <div class="ar-bar-val" style="color:#fbbf24">{{ fmtM(d.fees) }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Breakdown Row -->
          <div class="grid grid-cols-3 gap-4">
            <div class="ar-card">
              <h3 class="ar-section-title">📋 تقسيم حسب النوع</h3>
              <div class="ar-breakdown-list">
                <div v-for="(val, type) in txByType" :key="type" class="ar-breakdown-row">
                  <span class="ar-breakdown-label">{{ typeLabels[type] || type }}</span>
                  <div class="ar-breakdown-right"><span class="ar-breakdown-count">{{ val.count }} عملية</span><span class="ar-breakdown-amount">{{ fmtM(val.total_amount) }} €</span></div>
                </div>
                <div v-if="!Object.keys(txByType || {}).length" class="ar-empty">لا توجد بيانات</div>
              </div>
            </div>
            <div class="ar-card">
              <h3 class="ar-section-title">📊 تقسيم حسب الحالة</h3>
              <div class="ar-breakdown-list">
                <div v-for="(val, status) in txByStatus" :key="status" class="ar-breakdown-row">
                  <span :class="['ar-status-badge', status === 'completed' ? 'ar-s-green' : status === 'pending' ? 'ar-s-yellow' : 'ar-s-red']">{{ statusLabels[status] || status }}</span>
                  <div class="ar-breakdown-right"><span class="ar-breakdown-count">{{ val.count }}</span><span class="ar-breakdown-amount">{{ fmtM(val.total_amount) }} €</span></div>
                </div>
              </div>
            </div>
            <div class="ar-card">
              <h3 class="ar-section-title">💱 توزيع العملات</h3>
              <div class="ar-breakdown-list">
                <div v-for="c in currencyDist" :key="c.currency" class="ar-breakdown-row">
                  <div class="flex items-center gap-3"><span class="text-xl">{{ c.symbol }}</span><span class="ar-breakdown-label">{{ c.currency }}</span></div>
                  <div class="ar-breakdown-right"><span class="ar-breakdown-count">{{ c.accounts }} حساب</span><span class="ar-breakdown-amount" style="color:#34d399">{{ fmtM(c.balance) }}</span></div>
                </div>
              </div>
            </div>
          </div>

          <!-- Top Users -->
          <div class="ar-card">
            <h3 class="ar-section-title">🏆 أعلى العملاء حسب حجم المعاملات</h3>
            <div class="overflow-x-auto">
              <table class="ar-table">
                <thead><tr><th>#</th><th>العميل</th><th>رقم العميل</th><th>عدد المعاملات</th><th>حجم المعاملات</th><th>الحسابات</th><th>إجراء</th></tr></thead>
                <tbody>
                  <tr v-for="(u, i) in topUsers" :key="u.id">
                    <td><span :class="['ar-rank', i < 3 ? 'ar-rank-top' : '']">{{ i + 1 }}</span></td>
                    <td><div class="flex items-center gap-3"><div class="ar-user-avatar">{{ u.full_name?.charAt(0) }}</div><span class="ar-table-name">{{ u.full_name }}</span></div></td>
                    <td class="ar-table-mono">{{ u.customer_number }}</td>
                    <td class="ar-table-bold">{{ u.tx_count }}</td>
                    <td class="ar-table-amount">{{ fmtM(u.tx_volume) }} €</td>
                    <td>{{ u.accounts_count }}</td>
                    <td><Link :href="route('admin.users.show', u.id)" class="ar-link">عرض ←</Link></td>
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
.ar-root{display:flex;min-height:100vh;background:#080d1c;color:#e2e8f0;direction:rtl;font-family:'Inter','Segoe UI',sans-serif}

/* Sidebar */
.ar-sidebar{width:240px;background:#0c1225;border-left:1px solid rgba(255,255,255,0.06);flex-shrink:0}
.ar-logo{display:flex;align-items:center;gap:12px;padding:20px 16px;border-bottom:1px solid rgba(255,255,255,0.06)}
.ar-logo-icon{width:36px;height:36px;background:linear-gradient(135deg,#10b981,#059669);border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:900;font-size:11px;flex-shrink:0}
.ar-logo-text{font-size:15px;font-weight:800;color:#e2e8f0}
.ar-nav{padding:12px 8px;display:flex;flex-direction:column;gap:3px}
.ar-nav-item{display:flex;align-items:center;gap:12px;padding:11px 14px;border-radius:12px;font-size:14px;color:rgba(226,232,240,0.5);text-decoration:none;transition:all .15s;font-weight:500}
.ar-nav-item:hover{background:rgba(255,255,255,0.04);color:rgba(226,232,240,0.8)}
.ar-nav-active{background:rgba(16,185,129,0.1)!important;color:#10b981!important;font-weight:700}
.ar-nav-icon{font-size:18px;width:24px;text-align:center}

/* Main */
.ar-main{flex:1;display:flex;flex-direction:column;overflow-y:auto}
.ar-topbar{display:flex;justify-content:space-between;align-items:center;padding:18px 28px;background:#0c1225;border-bottom:1px solid rgba(255,255,255,0.06)}
.ar-title{font-size:20px;font-weight:800;color:#e2e8f0;margin:0}
.ar-subtitle{font-size:13px;color:rgba(226,232,240,0.4);margin-top:2px}
.ar-content{padding:24px 28px;display:flex;flex-direction:column;gap:20px}

/* Period */
.ar-period-group{display:flex;gap:6px}
.ar-period{padding:8px 18px;border-radius:10px;font-size:13px;font-weight:700;border:1px solid rgba(255,255,255,0.08);background:transparent;color:rgba(226,232,240,0.5);cursor:pointer;transition:all .15s}
.ar-period:hover{border-color:rgba(255,255,255,0.15);color:#e2e8f0}
.ar-period-active{background:#10b981!important;color:#fff!important;border-color:#10b981!important}

/* Summary */
.ar-sum{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:18px;padding:20px;display:flex;align-items:center;gap:16px}
.ar-sum-icon{width:50px;height:50px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:22px;flex-shrink:0}
.ar-sum-label{font-size:13px;color:rgba(226,232,240,0.4);font-weight:600;margin-bottom:4px}
.ar-sum-value{font-size:28px;font-weight:900}

/* Charts */
.ar-card{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:18px;padding:24px}
.ar-section-title{font-size:16px;font-weight:700;color:#e2e8f0;margin-bottom:18px}
.ar-bar-chart{display:flex;align-items:flex-end;gap:8px;height:140px}
.ar-bar-col{flex:1;display:flex;flex-direction:column;align-items:center;cursor:pointer;transition:transform .2s}.ar-bar-col:hover{transform:translateY(-3px)}.ar-bar-col:hover .ar-bar{filter:brightness(1.3)}
.ar-bar-wrapper{height:110px;width:100%;display:flex;align-items:flex-end;justify-content:center}
.ar-bar{width:65%;border-radius:6px 6px 0 0;min-height:2px;transition:height .5s ease,filter .2s}
.ar-bar-date{font-size:12px;color:rgba(226,232,240,0.35);margin-top:6px}
.ar-bar-val{font-size:12px;font-weight:700;margin-top:2px}
.ar-bar-sub{font-size:10px;color:rgba(226,232,240,0.25);margin-top:1px}

/* Breakdown */
.ar-breakdown-list{display:flex;flex-direction:column;gap:2px}
.ar-breakdown-row{display:flex;justify-content:space-between;align-items:center;padding:12px 0;border-bottom:1px solid rgba(255,255,255,0.04)}.ar-breakdown-row:last-child{border:0}
.ar-breakdown-label{font-size:15px;font-weight:600;color:#e2e8f0}
.ar-breakdown-right{display:flex;align-items:center;gap:16px}
.ar-breakdown-count{font-size:13px;color:rgba(226,232,240,0.4)}
.ar-breakdown-amount{font-size:15px;font-weight:700;color:#e2e8f0}
.ar-empty{text-align:center;padding:20px;font-size:14px;color:rgba(226,232,240,0.3)}

/* Status */
.ar-status-badge{font-size:13px;padding:4px 14px;border-radius:100px;font-weight:700}
.ar-s-green{background:rgba(16,185,129,0.12);color:#34d399}
.ar-s-yellow{background:rgba(245,158,11,0.12);color:#fbbf24}
.ar-s-red{background:rgba(239,68,68,0.12);color:#f87171}

/* Table */
.ar-table{width:100%;border-collapse:collapse;font-size:14px}
.ar-table th{text-align:right;padding:12px 14px;color:rgba(226,232,240,0.4);font-weight:700;font-size:13px;border-bottom:2px solid rgba(255,255,255,0.06);background:rgba(255,255,255,0.02)}
.ar-table td{padding:12px 14px;border-bottom:1px solid rgba(255,255,255,0.04);color:#e2e8f0}
.ar-table tr:hover td{background:rgba(255,255,255,0.02)}
.ar-table-name{font-weight:600;color:#e2e8f0;font-size:14px}
.ar-table-mono{font-family:monospace;color:#60a5fa;font-size:13px}
.ar-table-bold{font-weight:700;font-size:14px}
.ar-table-amount{font-weight:700;color:#34d399;font-size:14px}
.ar-user-avatar{width:34px;height:34px;border-radius:10px;background:linear-gradient(135deg,#3b82f6,#1d4ed8);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:13px;flex-shrink:0}
.ar-rank{width:28px;height:28px;border-radius:8px;background:rgba(255,255,255,0.06);display:inline-flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;color:rgba(226,232,240,0.5)}
.ar-rank-top{background:linear-gradient(135deg,#f59e0b,#d97706);color:#fff}
.ar-link{font-size:13px;color:#60a5fa;text-decoration:none;font-weight:700}.ar-link:hover{text-decoration:underline}
</style>
