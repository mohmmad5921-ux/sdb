<script setup>
import { Head, Link } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref } from 'vue';

const props = defineProps({ largeTransactions: Array, suspiciousUsers: Array, frozenAccounts: Array, stats: Object, threshold: Number });

const fmt = (a) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
const fmtDate = (d) => new Date(d).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' });
const activeSection = ref('transactions');

const riskColor = (level) => level === 'high' ? 'rk-risk-high' : level === 'medium' ? 'rk-risk-med' : 'rk-risk-low';
const riskLabel = (level) => level === 'high' ? '🔴 عالي' : level === 'medium' ? '🟡 متوسط' : '🟢 منخفض';

const sideLinks = [
  { label: 'لوحة التحكم', icon: '📊', route: 'admin.dashboard' },
  { label: 'التقارير', icon: '📈', route: 'admin.reports' },
  { label: 'المخاطر', icon: '🛡️', route: 'admin.risk', active: true },
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
  <Head title="Risk & Compliance - المخاطر والامتثال" />
  <AuthenticatedLayout>
    <div class="rk-root">
      <aside class="rk-sidebar">
        <div class="rk-logo"><span class="text-lg font-black text-[#1A2B4A]">SDB Admin</span></div>
        <nav class="rk-nav">
          <Link v-for="l in sideLinks" :key="l.route" :href="route(l.route)" :class="['rk-nav-item', l.active ? 'rk-nav-active' : '']"><span>{{ l.icon }}</span><span>{{ l.label }}</span></Link>
        </nav>
      </aside>

      <main class="rk-main">
        <header class="rk-topbar">
          <h2 class="text-lg font-bold text-[#1A2B4A]">🛡️ المخاطر والامتثال — AML Monitor</h2>
          <span class="text-xs text-[#8896AB]">الحد الأدنى للمراقبة: {{ fmt(threshold) }} €</span>
        </header>

        <div class="rk-content">
          <!-- Alert Stats -->
          <div class="grid grid-cols-4 lg:grid-cols-8 gap-3">
            <div class="rk-stat rk-stat-red"><div class="text-2xl font-black">{{ stats.high_risk_tx }}</div><div class="text-[10px]">🔴 مخاطر عالية</div></div>
            <div class="rk-stat rk-stat-yellow"><div class="text-2xl font-black">{{ stats.medium_risk_tx }}</div><div class="text-[10px]">🟡 مخاطر متوسطة</div></div>
            <div class="rk-stat rk-stat-blue"><div class="text-2xl font-black">{{ stats.large_tx_today }}</div><div class="text-[10px]">💸 كبيرة اليوم</div></div>
            <div class="rk-stat rk-stat-red"><div class="text-2xl font-black">{{ stats.failed_tx_today }}</div><div class="text-[10px]">❌ فاشلة اليوم</div></div>
            <div class="rk-stat rk-stat-orange"><div class="text-2xl font-black">{{ stats.suspended_users }}</div><div class="text-[10px]">⚠️ موقوف</div></div>
            <div class="rk-stat rk-stat-red"><div class="text-2xl font-black">{{ stats.blocked_users }}</div><div class="text-[10px]">🚫 محظور</div></div>
            <div class="rk-stat rk-stat-blue"><div class="text-2xl font-black">{{ stats.frozen_accounts }}</div><div class="text-[10px]">❄️ حساب مجمّد</div></div>
            <div class="rk-stat rk-stat-yellow"><div class="text-2xl font-black">{{ stats.pending_kyc }}</div><div class="text-[10px]">🪪 KYC معلق</div></div>
          </div>

          <!-- Section Tabs -->
          <div class="flex gap-2">
            <button @click="activeSection = 'transactions'" :class="['rk-section-btn', activeSection === 'transactions' ? 'rk-section-active' : '']">🔍 معاملات مشبوهة</button>
            <button @click="activeSection = 'users'" :class="['rk-section-btn', activeSection === 'users' ? 'rk-section-active' : '']">👥 مستخدمون موقوفون</button>
            <button @click="activeSection = 'frozen'" :class="['rk-section-btn', activeSection === 'frozen' ? 'rk-section-active' : '']">❄️ حسابات مجمّدة</button>
          </div>

          <!-- Suspicious Transactions -->
          <div v-if="activeSection === 'transactions'" class="rk-card">
            <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">🔍 المعاملات المشبوهة — تحليل المخاطر</h3>
            <div class="overflow-x-auto">
              <table class="rk-table">
                <thead><tr><th>المرسل</th><th>المستقبل</th><th>المبلغ</th><th>مستوى المخاطر</th><th>تقييم</th><th>الأسباب</th><th>التاريخ</th><th>إجراء</th></tr></thead>
                <tbody>
                  <tr v-for="t in largeTransactions" :key="t.id">
                    <td><div class="flex items-center gap-2"><div class="rk-avatar">{{ t.from_account?.user?.full_name?.charAt(0) || '?' }}</div><div><div class="text-sm font-semibold text-[#1A2B4A]">{{ t.from_account?.user?.full_name || '—' }}</div><div class="text-[10px] text-[#8896AB] font-mono">{{ t.from_account?.user?.customer_number }}</div></div></div></td>
                    <td class="text-sm text-[#5A6B82]">{{ t.to_account?.user?.full_name || '—' }}</td>
                    <td class="text-lg font-black text-[#1A2B4A]">{{ fmt(t.amount) }} {{ t.currency?.symbol }}</td>
                    <td><span :class="riskColor(t.risk_level)" class="rk-risk-badge">{{ riskLabel(t.risk_level) }}</span></td>
                    <td>
                      <div class="rk-score-bar">
                        <div class="rk-score-fill" :class="t.risk_score >= 60 ? 'rk-sf-red' : t.risk_score >= 30 ? 'rk-sf-yellow' : 'rk-sf-green'" :style="{width: t.risk_score + '%'}"></div>
                      </div>
                      <span class="text-[10px] font-mono" :class="t.risk_score >= 60 ? 'text-red-500' : 'text-[#8896AB]'">{{ t.risk_score }}/100</span>
                    </td>
                    <td>
                      <div class="flex flex-wrap gap-1">
                        <span v-for="(f, i) in t.risk_flags" :key="i" class="rk-flag">{{ f }}</span>
                      </div>
                    </td>
                    <td class="text-xs text-[#8896AB]">{{ fmtDate(t.created_at) }}</td>
                    <td><Link v-if="t.from_account?.user" :href="route('admin.users.show', t.from_account.user.id)" class="rk-link">فحص ←</Link></td>
                  </tr>
                </tbody>
              </table>
              <div v-if="!largeTransactions?.length" class="py-10 text-center text-[#8896AB]">✅ لا توجد معاملات مشبوهة حالياً</div>
            </div>
          </div>

          <!-- Suspended/Blocked Users -->
          <div v-if="activeSection === 'users'" class="rk-card">
            <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">👥 المستخدمون الموقوفون والمحظورون</h3>
            <div class="overflow-x-auto">
              <table class="rk-table">
                <thead><tr><th>العميل</th><th>البريد</th><th>رقم العميل</th><th>الحالة</th><th>KYC</th><th>تاريخ التسجيل</th><th>إجراء</th></tr></thead>
                <tbody>
                  <tr v-for="u in suspiciousUsers" :key="u.id">
                    <td><div class="flex items-center gap-2"><div class="rk-avatar rk-avatar-red">{{ u.full_name?.charAt(0) }}</div><span class="font-semibold text-[#1A2B4A]">{{ u.full_name }}</span></div></td>
                    <td class="text-sm text-[#8896AB]">{{ u.email }}</td>
                    <td class="font-mono text-xs text-[#1E5EFF]">{{ u.customer_number }}</td>
                    <td><span :class="u.status === 'suspended' ? 'rk-risk-med' : 'rk-risk-high'" class="rk-risk-badge">{{ u.status === 'suspended' ? '⚠️ موقوف' : '🚫 محظور' }}</span></td>
                    <td><span :class="u.kyc_status === 'verified' ? 'rk-badge-green' : 'rk-badge-yellow'" class="rk-badge-sm">{{ u.kyc_status }}</span></td>
                    <td class="text-xs text-[#8896AB]">{{ fmtDate(u.created_at) }}</td>
                    <td><Link :href="route('admin.users.show', u.id)" class="rk-link">فحص ←</Link></td>
                  </tr>
                </tbody>
              </table>
              <div v-if="!suspiciousUsers?.length" class="py-10 text-center text-[#8896AB]">✅ لا يوجد مستخدمون موقوفون</div>
            </div>
          </div>

          <!-- Frozen Accounts -->
          <div v-if="activeSection === 'frozen'" class="rk-card">
            <h3 class="text-sm font-bold text-[#1A2B4A] mb-4">❄️ الحسابات المجمّدة</h3>
            <div class="overflow-x-auto">
              <table class="rk-table">
                <thead><tr><th>الحساب</th><th>العميل</th><th>IBAN</th><th>العملة</th><th>الرصيد</th><th>إجراء</th></tr></thead>
                <tbody>
                  <tr v-for="a in frozenAccounts" :key="a.id">
                    <td class="font-mono text-xs text-[#1E5EFF]">{{ a.account_number }}</td>
                    <td><div class="flex items-center gap-2"><div class="rk-avatar rk-avatar-blue">{{ a.user?.full_name?.charAt(0) }}</div><span class="font-semibold text-[#1A2B4A]">{{ a.user?.full_name }}</span></div></td>
                    <td class="font-mono text-xs text-[#8896AB]">{{ a.iban }}</td>
                    <td><span class="text-lg">{{ a.currency?.symbol }}</span> {{ a.currency?.code }}</td>
                    <td class="font-bold text-[#1A2B4A]">{{ fmt(a.balance) }} {{ a.currency?.symbol }}</td>
                    <td><Link :href="route('admin.accounts')" class="rk-link">إدارة ←</Link></td>
                  </tr>
                </tbody>
              </table>
              <div v-if="!frozenAccounts?.length" class="py-10 text-center text-[#8896AB]">✅ لا توجد حسابات مجمّدة</div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.rk-root{display:flex;min-height:100vh;background:#F0F2F5;direction:rtl}
.rk-sidebar{width:200px;background:#fff;border-left:1px solid #E8ECF1;flex-shrink:0}
.rk-logo{padding:16px;border-bottom:1px solid #E8ECF1}
.rk-nav{padding:10px 8px;display:flex;flex-direction:column;gap:2px}
.rk-nav-item{display:flex;align-items:center;gap:8px;padding:9px 12px;border-radius:10px;font-size:12px;color:#5A6B82;text-decoration:none;font-weight:500}.rk-nav-item:hover{background:#F0F4FF;color:#1E5EFF}
.rk-nav-active{background:#F0F4FF!important;color:#1E5EFF!important;font-weight:700}
.rk-main{flex:1;display:flex;flex-direction:column;overflow-y:auto}
.rk-topbar{display:flex;justify-content:space-between;align-items:center;padding:14px 24px;background:#fff;border-bottom:1px solid #E8ECF1}
.rk-content{padding:20px 24px;display:flex;flex-direction:column;gap:16px}
.rk-stat{background:#fff;border:2px solid #E8ECF1;border-radius:12px;padding:12px;text-align:center}
.rk-stat-red{border-color:rgba(239,68,68,0.2);background:rgba(239,68,68,0.02)}.rk-stat-yellow{border-color:rgba(245,158,11,0.2);background:rgba(245,158,11,0.02)}.rk-stat-blue{border-color:rgba(30,94,255,0.2);background:rgba(30,94,255,0.02)}.rk-stat-orange{border-color:rgba(249,115,22,0.2);background:rgba(249,115,22,0.02)}
.rk-section-btn{padding:8px 18px;border-radius:10px;font-size:13px;font-weight:600;border:1px solid #E8ECF1;background:#fff;color:#5A6B82;cursor:pointer}.rk-section-btn:hover{border-color:#1E5EFF;color:#1E5EFF}
.rk-section-active{background:#1E5EFF!important;color:#fff!important;border-color:#1E5EFF!important}
.rk-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px;padding:20px}
.rk-table{width:100%;border-collapse:collapse;font-size:13px}
.rk-table th{text-align:right;padding:10px 12px;background:#FAFBFC;color:#8896AB;font-weight:600;font-size:11px;border-bottom:2px solid #E8ECF1}
.rk-table td{padding:10px 12px;border-bottom:1px solid #F0F2F5;color:#1A2B4A;vertical-align:middle}
.rk-table tr:hover td{background:#FAFBFC}
.rk-avatar{width:28px;height:28px;border-radius:8px;background:linear-gradient(135deg,#1E5EFF,#3B82F6);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:11px;flex-shrink:0}
.rk-avatar-red{background:linear-gradient(135deg,#dc2626,#ef4444)}.rk-avatar-blue{background:linear-gradient(135deg,#2563eb,#3b82f6)}
.rk-risk-badge{font-size:11px;padding:3px 10px;border-radius:100px;font-weight:600}
.rk-risk-high{background:rgba(239,68,68,0.1);color:#dc2626}.rk-risk-med{background:rgba(245,158,11,0.1);color:#d97706}.rk-risk-low{background:rgba(16,185,129,0.1);color:#059669}
.rk-score-bar{width:60px;height:6px;background:#F0F2F5;border-radius:100px;overflow:hidden;display:inline-block;vertical-align:middle;margin-left:4px}
.rk-score-fill{height:100%;border-radius:100px;transition:width .5s}
.rk-sf-red{background:#ef4444}.rk-sf-yellow{background:#f59e0b}.rk-sf-green{background:#10b981}
.rk-flag{font-size:10px;padding:2px 8px;border-radius:6px;background:rgba(239,68,68,0.06);color:#dc2626;border:1px solid rgba(239,68,68,0.1);font-weight:500}
.rk-link{font-size:12px;color:#1E5EFF;text-decoration:none;font-weight:600}.rk-link:hover{text-decoration:underline}
.rk-badge-sm{font-size:10px;padding:2px 8px;border-radius:100px;font-weight:600}
.rk-badge-green{background:rgba(16,185,129,0.1);color:#059669}.rk-badge-yellow{background:rgba(245,158,11,0.1);color:#d97706}
</style>
