<script setup>
import { Head, Link, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed, onMounted } from 'vue';

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
  { label: 'قائمة الانتظار', icon: '📩', route: 'admin.dashboard' },
];

// Bar chart heights
const maxTxCount = computed(() => Math.max(...(props.dailyTransactions || []).map(d => d.count), 1));
const maxTxVol = computed(() => Math.max(...(props.dailyTransactions || []).map(d => d.volume), 1));

const typeLabels = { transfer: 'تحويل', deposit: 'إيداع', withdrawal: 'سحب', exchange: 'صرف', card_payment: 'بطاقة', fee: 'رسوم' };
const statusBadge = { completed: 'db-badge-green', pending: 'db-badge-yellow', failed: 'db-badge-red' };
</script>

<template>
  <Head title="Admin Dashboard - لوحة التحكم" />
  <AuthenticatedLayout>
    <div class="db-root">
      <!-- SIDEBAR -->
      <aside class="db-sidebar" :class="{'db-sidebar-collapsed': !sidebarOpen}">
        <div class="db-logo">
          <img src="/images/sdb-logo.png" alt="SDB" class="w-8 h-8 rounded-lg" onerror="this.style.display='none'"/>
          <span v-if="sidebarOpen" class="text-lg font-black text-[#1A2B4A]">SDB Admin</span>
        </div>
        <nav class="db-nav">
          <Link v-for="l in sideLinks" :key="l.route" :href="route(l.route)" :class="['db-nav-item', l.active ? 'db-nav-active' : '']">
            <span>{{ l.icon }}</span><span v-if="sidebarOpen">{{ l.label }}</span>
          </Link>
        </nav>
      </aside>

      <!-- MAIN -->
      <main class="db-main">
        <header class="db-topbar">
          <div class="flex items-center gap-3">
            <button @click="sidebarOpen = !sidebarOpen" class="text-[#8896AB] hover:text-[#1A2B4A]">☰</button>
            <h2 class="text-lg font-bold text-[#1A2B4A]">لوحة التحكم الرئيسية</h2>
          </div>
          <div class="flex items-center gap-3">
            <span class="text-xs text-[#8896AB]">{{ new Date().toLocaleDateString('ar-EG', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }) }}</span>
            <div class="w-8 h-8 rounded-lg bg-[#1E5EFF] text-white flex items-center justify-center text-sm font-bold">A</div>
          </div>
        </header>

        <div class="db-content">
          <!-- System Alerts -->
          <div v-if="alerts?.length" class="db-alerts">
            <div v-for="(a, i) in alerts" :key="i" :class="['db-alert', 'db-alert-' + a.type]">
              <span v-if="a.type==='warning'">⚠️</span><span v-else-if="a.type==='error'">🚨</span><span v-else>ℹ️</span>
              {{ a.msg }}
            </div>
          </div>

          <!-- Core Stats -->
          <div class="db-stats-grid">
            <div class="db-stat"><div class="db-stat-icon db-stat-blue">👥</div><div><div class="text-xs text-[#8896AB]">العملاء</div><div class="text-2xl font-black text-[#1A2B4A]">{{ stats.total_users }}</div><div class="text-[10px] text-emerald-500">+{{ stats.new_users_today }} اليوم</div></div></div>
            <div class="db-stat"><div class="db-stat-icon db-stat-green">🏦</div><div><div class="text-xs text-[#8896AB]">الحسابات</div><div class="text-2xl font-black text-[#1A2B4A]">{{ stats.total_accounts }}</div><div class="text-[10px] text-blue-500">{{ stats.active_accounts }} نشط</div></div></div>
            <div class="db-stat"><div class="db-stat-icon db-stat-purple">💳</div><div><div class="text-xs text-[#8896AB]">البطاقات</div><div class="text-2xl font-black text-[#1A2B4A]">{{ stats.total_cards }}</div><div class="text-[10px] text-blue-500">{{ stats.active_cards }} نشط</div></div></div>
            <div class="db-stat"><div class="db-stat-icon db-stat-yellow">💸</div><div><div class="text-xs text-[#8896AB]">المعاملات</div><div class="text-2xl font-black text-[#1A2B4A]">{{ stats.total_transactions }}</div><div class="text-[10px] text-emerald-500">+{{ stats.today_transactions }} اليوم</div></div></div>
            <div class="db-stat"><div class="db-stat-icon db-stat-red">🪪</div><div><div class="text-xs text-[#8896AB]">طلبات KYC</div><div class="text-2xl font-black text-amber-600">{{ stats.pending_kyc }}</div><div class="text-[10px] text-amber-500">بانتظار المراجعة</div></div></div>
            <div class="db-stat"><div class="db-stat-icon db-stat-green">💰</div><div><div class="text-xs text-[#8896AB]">حجم المعاملات (الكلي)</div><div class="text-2xl font-black text-emerald-600">{{ fmtM(stats.total_volume) }}</div><div class="text-[10px] text-emerald-500">{{ fmtM(stats.today_volume) }} اليوم</div></div></div>
            <div class="db-stat"><div class="db-stat-icon" style="background:rgba(99,102,241,.08)">📩</div><div><div class="text-xs text-[#8896AB]">قائمة الانتظار</div><div class="text-2xl font-black text-indigo-600">{{ stats.total_waitlist }}</div><div class="text-[10px] text-indigo-500">+{{ stats.waitlist_today }} اليوم</div></div></div>
            <div class="db-stat"><div class="db-stat-icon" style="background:rgba(236,72,153,.08)">📝</div><div><div class="text-xs text-[#8896AB]">التسجيل المبكر</div><div class="text-2xl font-black text-pink-600">{{ stats.total_preregistrations }}</div><div class="text-[10px] text-pink-500">+{{ stats.prereg_today }} اليوم</div></div></div>
          </div>

          <!-- Volume Stats Row -->
          <div class="grid grid-cols-4 gap-4">
            <div class="db-vol-card"><div class="text-xs text-[#8896AB]">حجم اليوم</div><div class="text-xl font-black text-[#1A2B4A]">{{ fmtM(stats.today_volume) }}</div><div class="text-[10px] text-[#8896AB]">{{ stats.today_transactions }} معاملة</div></div>
            <div class="db-vol-card"><div class="text-xs text-[#8896AB]">حجم الأسبوع</div><div class="text-xl font-black text-[#1E5EFF]">{{ fmtM(stats.week_volume) }}</div><div class="text-[10px] text-[#8896AB]">{{ stats.week_transactions }} معاملة</div></div>
            <div class="db-vol-card"><div class="text-xs text-[#8896AB]">حجم الشهر</div><div class="text-xl font-black text-emerald-600">{{ fmtM(stats.month_volume) }}</div><div class="text-[10px] text-[#8896AB]">{{ stats.month_transactions }} معاملة</div></div>
            <div class="db-vol-card"><div class="text-xs text-[#8896AB]">مستخدمون جدد (هذا الشهر)</div><div class="text-xl font-black text-purple-600">{{ stats.new_users_month }}</div><div class="text-[10px] text-[#8896AB]">{{ stats.new_users_week }} هذا الأسبوع</div></div>
          </div>

          <!-- Charts Row -->
          <div class="grid grid-cols-2 gap-4">
            <!-- Transaction Volume Chart -->
            <div class="db-chart-card">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">📈 حجم المعاملات (7 أيام)</h3>
              <div class="db-bar-chart">
                <div v-for="d in dailyTransactions" :key="d.date" class="db-bar-col">
                  <div class="db-bar-wrapper">
                    <div class="db-bar" :style="{height: Math.max((d.volume / maxTxVol) * 100, 4) + '%'}"></div>
                  </div>
                  <div class="text-[10px] text-[#8896AB] mt-1">{{ d.date }}</div>
                  <div class="text-[9px] text-[#1E5EFF] font-bold">{{ fmtM(d.volume) }}</div>
                </div>
              </div>
            </div>

            <!-- Transaction Count Chart -->
            <div class="db-chart-card">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">📊 عدد المعاملات (7 أيام)</h3>
              <div class="db-bar-chart">
                <div v-for="d in dailyTransactions" :key="d.date" class="db-bar-col">
                  <div class="db-bar-wrapper">
                    <div class="db-bar db-bar-green" :style="{height: Math.max((d.count / maxTxCount) * 100, 4) + '%'}"></div>
                  </div>
                  <div class="text-[10px] text-[#8896AB] mt-1">{{ d.date }}</div>
                  <div class="text-[9px] text-emerald-600 font-bold">{{ d.count }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Actions + System Status -->
          <div class="grid grid-cols-3 gap-4">
            <div class="db-card col-span-1">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-3">⚡ إجراءات سريعة</h3>
              <div class="space-y-2">
                <Link :href="route('admin.users')" class="db-quick-link"><span>👥</span>إدارة العملاء</Link>
                <Link :href="route('admin.kyc')" class="db-quick-link db-quick-warn"><span>🪪</span>مراجعة KYC <span v-if="stats.pending_kyc" class="db-badge-count">{{ stats.pending_kyc }}</span></Link>
                <Link :href="route('admin.transactions')" class="db-quick-link"><span>💸</span>المعاملات</Link>
                <Link :href="route('admin.accounts')" class="db-quick-link"><span>🏦</span>الحسابات</Link>
                <Link :href="route('admin.cards')" class="db-quick-link"><span>💳</span>البطاقات</Link>
                <Link :href="route('admin.currencies')" class="db-quick-link"><span>💱</span>العملات والصرف</Link>
                <Link :href="route('admin.merchants')" class="db-quick-link"><span>🔌</span>بوابة الدفع</Link>
                <Link :href="route('admin.support')" class="db-quick-link"><span>🎧</span>تذاكر الدعم</Link>
                <Link :href="route('admin.settings')" class="db-quick-link"><span>⚙️</span>الإعدادات</Link>
                <Link :href="route('admin.audit-logs')" class="db-quick-link"><span>📋</span>سجل التدقيق</Link>
              </div>
            </div>

            <!-- System Health -->
            <div class="db-card col-span-1">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-3">💊 صحة النظام</h3>
              <div class="space-y-3">
                <div class="db-health-item"><span class="text-xs text-[#5A6B82]">حسابات نشطة</span><div class="db-health-bar"><div class="db-health-fill db-fill-green" :style="{width: (stats.active_accounts / Math.max(stats.total_accounts,1)) * 100 + '%'}"></div></div><span class="text-xs font-mono text-[#1A2B4A]">{{ Math.round((stats.active_accounts / Math.max(stats.total_accounts,1)) * 100) }}%</span></div>
                <div class="db-health-item"><span class="text-xs text-[#5A6B82]">بطاقات نشطة</span><div class="db-health-bar"><div class="db-health-fill db-fill-blue" :style="{width: (stats.active_cards / Math.max(stats.total_cards,1)) * 100 + '%'}"></div></div><span class="text-xs font-mono text-[#1A2B4A]">{{ Math.round((stats.active_cards / Math.max(stats.total_cards,1)) * 100) }}%</span></div>
                <div class="db-health-item"><span class="text-xs text-[#5A6B82]">مستخدمون نشطون</span><div class="db-health-bar"><div class="db-health-fill db-fill-purple" :style="{width: (stats.active_users / Math.max(stats.total_users,1)) * 100 + '%'}"></div></div><span class="text-xs font-mono text-[#1A2B4A]">{{ Math.round((stats.active_users / Math.max(stats.total_users,1)) * 100) }}%</span></div>
                <div class="db-health-item"><span class="text-xs text-[#5A6B82]">حسابات مجمدة</span><div class="db-health-bar"><div class="db-health-fill db-fill-red" :style="{width: (stats.frozen_accounts / Math.max(stats.total_accounts,1)) * 100 + '%'}"></div></div><span class="text-xs font-mono text-red-500">{{ stats.frozen_accounts }}</span></div>
                <div class="db-health-item"><span class="text-xs text-[#5A6B82]">معاملات فاشلة</span><div class="db-health-bar"><div class="db-health-fill db-fill-red" :style="{width: Math.min((stats.failed_transactions / Math.max(stats.total_transactions,1)) * 100, 100) + '%'}"></div></div><span class="text-xs font-mono text-red-500">{{ stats.failed_transactions }}</span></div>
              </div>
            </div>

            <!-- Currencies -->
            <div class="db-card col-span-1">
              <h3 class="text-sm font-bold text-[#1A2B4A] mb-3">💱 العملات المدعومة</h3>
              <div class="space-y-2">
                <div v-for="c in currencies" :key="c.id" class="flex items-center justify-between py-1.5 border-b border-[#F0F2F5] last:border-0">
                  <div class="flex items-center gap-2"><span class="text-lg">{{ c.symbol }}</span><span class="text-sm font-semibold text-[#1A2B4A]">{{ c.code }}</span></div>
                  <span class="text-xs font-mono text-[#8896AB]">{{ c.exchange_rate_to_eur }} EUR</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Data -->
          <div class="grid grid-cols-2 gap-4">
            <!-- Recent Transactions -->
            <div class="db-card overflow-hidden">
              <div class="flex justify-between items-center mb-3">
                <h3 class="text-sm font-bold text-[#1A2B4A]">💸 آخر المعاملات</h3>
                <Link :href="route('admin.transactions')" class="text-xs text-[#1E5EFF] hover:underline">عرض الكل →</Link>
              </div>
              <div class="space-y-2">
                <div v-for="t in recentTransactions" :key="t.id" class="db-tx-row">
                  <div class="flex items-center gap-2">
                    <span :class="statusBadge[t.status]" class="db-badge-sm">{{ t.status === 'completed' ? '✓' : t.status === 'pending' ? '⏳' : '✗' }}</span>
                    <div>
                      <div class="text-xs font-semibold text-[#1A2B4A]">{{ t.from_account?.user?.full_name || '—' }} → {{ t.to_account?.user?.full_name || '—' }}</div>
                      <div class="text-[10px] text-[#8896AB]">{{ typeLabels[t.type] || t.type }} · {{ new Date(t.created_at).toLocaleTimeString('en-GB', {hour:'2-digit', minute:'2-digit'}) }}</div>
                    </div>
                  </div>
                  <span class="text-xs font-bold text-[#1A2B4A]">{{ Number(t.amount).toLocaleString() }} {{ t.currency?.symbol }}</span>
                </div>
              </div>
            </div>

            <!-- Recent Users -->
            <div class="db-card">
              <div class="flex justify-between items-center mb-3">
                <h3 class="text-sm font-bold text-[#1A2B4A]">👥 آخر المسجلين</h3>
                <Link :href="route('admin.users')" class="text-xs text-[#1E5EFF] hover:underline">عرض الكل →</Link>
              </div>
              <div class="space-y-2">
                <Link v-for="u in recentUsers" :key="u.id" :href="route('admin.users.show', u.id)" class="db-user-row">
                  <div class="flex items-center gap-2">
                    <div class="db-user-avatar">{{ u.full_name?.charAt(0) }}</div>
                    <div>
                      <div class="text-sm font-semibold text-[#1A2B4A]">{{ u.full_name }}</div>
                      <div class="text-[10px] text-[#8896AB]">{{ u.email }}</div>
                    </div>
                  </div>
                  <div class="text-left">
                    <span :class="u.status === 'active' ? 'db-badge-green' : 'db-badge-yellow'" class="db-badge-sm">{{ u.status }}</span>
                    <div class="text-[10px] text-[#8896AB] mt-0.5">{{ new Date(u.created_at).toLocaleDateString('en-GB') }}</div>
                  </div>
                </Link>
              </div>
            </div>

            <!-- Recent Waitlist -->
            <div class="db-card">
              <div class="flex justify-between items-center mb-3">
                <h3 class="text-sm font-bold text-[#1A2B4A]">📩 آخر تسجيلات الانتظار</h3>
                <div class="flex gap-2">
                  <a href="/admin/export/waitlist" class="text-xs bg-indigo-50 text-indigo-600 px-3 py-1 rounded-lg font-bold hover:bg-indigo-100">📥 CSV</a>
                </div>
              </div>
              <div class="space-y-2">
                <div v-for="w in recentWaitlist" :key="w.id" class="db-tx-row">
                  <div class="flex items-center gap-2">
                    <span class="db-badge-sm db-badge-green">📧</span>
                    <div>
                      <div class="text-xs font-semibold text-[#1A2B4A]">{{ w.email }}</div>
                      <div class="text-[10px] text-[#8896AB]">{{ w.source }} · {{ new Date(w.created_at).toLocaleDateString('en-GB') }}</div>
                    </div>
                  </div>
                </div>
                <div v-if="!recentWaitlist?.length" class="text-xs text-[#8896AB] text-center py-4">لا يوجد تسجيلات بعد</div>
              </div>
            </div>

            <!-- Recent Preregistrations -->
            <div class="db-card">
              <div class="flex justify-between items-center mb-3">
                <h3 class="text-sm font-bold text-[#1A2B4A]">📝 آخر التسجيلات المبكرة</h3>
                <div class="flex gap-2">
                  <a href="/admin/export/preregistrations" class="text-xs bg-pink-50 text-pink-600 px-3 py-1 rounded-lg font-bold hover:bg-pink-100">📥 CSV</a>
                </div>
              </div>
              <div class="space-y-2">
                <div v-for="p in recentPrereg" :key="p.id" class="db-tx-row">
                  <div class="flex items-center gap-2">
                    <div class="db-user-avatar" style="background:linear-gradient(135deg,#ec4899,#f472b6)">{{ p.full_name?.charAt(0) }}</div>
                    <div>
                      <div class="text-sm font-semibold text-[#1A2B4A]">{{ p.full_name }}</div>
                      <div class="text-[10px] text-[#8896AB]">{{ p.email }} · {{ p.country }}</div>
                    </div>
                  </div>
                  <div class="text-left">
                    <div class="text-[10px] text-[#8896AB]">{{ new Date(p.created_at).toLocaleDateString('en-GB') }}</div>
                  </div>
                </div>
                <div v-if="!recentPrereg?.length" class="text-xs text-[#8896AB] text-center py-4">لا يوجد تسجيلات بعد</div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.db-root{display:flex;min-height:100vh;background:#F0F2F5;direction:rtl}

/* Sidebar */
.db-sidebar{width:220px;background:#fff;border-left:1px solid #E8ECF1;display:flex;flex-direction:column;transition:width .3s;flex-shrink:0}
.db-sidebar-collapsed{width:56px;overflow:hidden}
.db-logo{display:flex;align-items:center;gap:10px;padding:16px;border-bottom:1px solid #E8ECF1}
.db-nav{padding:10px 8px;display:flex;flex-direction:column;gap:2px;flex:1;overflow-y:auto}
.db-nav-item{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;font-size:13px;color:#5A6B82;text-decoration:none;transition:all .15s;font-weight:500}.db-nav-item:hover{background:#F0F4FF;color:#1E5EFF}
.db-nav-active{background:#F0F4FF!important;color:#1E5EFF!important;font-weight:700}

/* Main */
.db-main{flex:1;display:flex;flex-direction:column;overflow-y:auto}
.db-topbar{display:flex;justify-content:space-between;align-items:center;padding:14px 24px;background:#fff;border-bottom:1px solid #E8ECF1}
.db-content{padding:20px 24px;display:flex;flex-direction:column;gap:20px}

/* Alerts */
.db-alerts{display:flex;flex-wrap:wrap;gap:8px}
.db-alert{padding:8px 14px;border-radius:10px;font-size:12px;font-weight:600;display:flex;align-items:center;gap:6px}
.db-alert-warning{background:rgba(245,158,11,0.08);color:#d97706;border:1px solid rgba(245,158,11,0.15)}
.db-alert-error{background:rgba(239,68,68,0.08);color:#dc2626;border:1px solid rgba(239,68,68,0.15)}
.db-alert-info{background:rgba(30,94,255,0.08);color:#1E5EFF;border:1px solid rgba(30,94,255,0.15)}

/* Stats */
.db-stats-grid{display:grid;grid-template-columns:repeat(6,1fr);gap:12px}
.db-stat{background:#fff;border:1px solid #E8ECF1;border-radius:14px;padding:16px;display:flex;align-items:center;gap:12px}
.db-stat-icon{width:40px;height:40px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0}
.db-stat-blue{background:rgba(30,94,255,0.08)}.db-stat-green{background:rgba(16,185,129,0.08)}.db-stat-purple{background:rgba(139,92,246,0.08)}.db-stat-yellow{background:rgba(245,158,11,0.08)}.db-stat-red{background:rgba(239,68,68,0.08)}

/* Volume */
.db-vol-card{background:#fff;border:1px solid #E8ECF1;border-radius:14px;padding:16px}

/* Charts */
.db-chart-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px;padding:20px}
.db-bar-chart{display:flex;align-items:flex-end;gap:8px;height:120px}
.db-bar-col{flex:1;display:flex;flex-direction:column;align-items:center}
.db-bar-wrapper{height:100px;width:100%;display:flex;align-items:flex-end;justify-content:center}
.db-bar{width:70%;border-radius:6px 6px 0 0;background:linear-gradient(180deg,#1E5EFF,#3B82F6);min-height:3px;transition:height .4s ease}
.db-bar-green{background:linear-gradient(180deg,#10b981,#34d399)}

/* Cards */
.db-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px;padding:18px}

/* Quick links */
.db-quick-link{display:flex;align-items:center;gap:8px;padding:8px 12px;border-radius:10px;font-size:12px;font-weight:600;color:#5A6B82;text-decoration:none;transition:all .15s;border:1px solid transparent}.db-quick-link:hover{background:#F0F4FF;color:#1E5EFF;border-color:rgba(30,94,255,0.1)}
.db-quick-warn{color:#d97706}.db-quick-warn:hover{background:rgba(245,158,11,0.05);color:#d97706}
.db-badge-count{background:#ef4444;color:#fff;font-size:10px;padding:1px 6px;border-radius:100px;margin-right:auto}

/* Health */
.db-health-item{display:flex;align-items:center;gap:8px}
.db-health-bar{flex:1;height:6px;background:#F0F2F5;border-radius:100px;overflow:hidden}
.db-health-fill{height:100%;border-radius:100px;transition:width .5s ease}
.db-fill-green{background:#10b981}.db-fill-blue{background:#1E5EFF}.db-fill-purple{background:#8b5cf6}.db-fill-red{background:#ef4444}

/* Transactions */
.db-tx-row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid #F0F2F5}.db-tx-row:last-child{border:0}

/* Users */
.db-user-row{display:flex;justify-content:space-between;align-items:center;padding:8px 10px;border-radius:10px;text-decoration:none;transition:background .15s}.db-user-row:hover{background:#FAFBFC}
.db-user-avatar{width:32px;height:32px;border-radius:10px;background:linear-gradient(135deg,#1E5EFF,#3B82F6);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:12px;flex-shrink:0}

/* Badges */
.db-badge-sm{font-size:10px;padding:2px 8px;border-radius:100px;font-weight:600}
.db-badge-green{background:rgba(16,185,129,0.1);color:#059669}.db-badge-yellow{background:rgba(245,158,11,0.1);color:#d97706}.db-badge-red{background:rgba(239,68,68,0.1);color:#dc2626}

@media(max-width:1200px){.db-stats-grid{grid-template-columns:repeat(3,1fr)}}
</style>
