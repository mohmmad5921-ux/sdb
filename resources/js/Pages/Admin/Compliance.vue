<script setup>
import { Head, Link } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';

const props = defineProps({ largeTransactions: Array, highFrequency: Array, rapidTransactions: Array, unverifiedWithTx: Array, stats: Object });

const fmt = (a) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
const fmtDate = (d) => new Date(d).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' });
</script>

<template>
  <Head title="الامتثال ومكافحة غسل الأموال" />
  <AdminLayout title="🛡️ الامتثال — AML" subtitle="تنبيهات مكافحة غسل الأموال والمعاملات المشبوهة">

    <!-- Stats -->
    <div class="com-stats">
      <div class="com-stat" style="border-right:3px solid #ef4444"><div class="com-stat-val" style="color:#ef4444">{{ stats?.large_tx_count || 0 }}</div><div class="com-stat-label">معاملات كبيرة +€10K</div></div>
      <div class="com-stat" style="border-right:3px solid #f59e0b"><div class="com-stat-val" style="color:#f59e0b">{{ stats?.high_freq_count || 0 }}</div><div class="com-stat-label">تكرار عالي +10/يوم</div></div>
      <div class="com-stat" style="border-right:3px solid #8b5cf6"><div class="com-stat-val" style="color:#8b5cf6">{{ stats?.rapid_count || 0 }}</div><div class="com-stat-label">معاملات متتالية &lt;1 دقيقة</div></div>
      <div class="com-stat" style="border-right:3px solid #3b82f6"><div class="com-stat-val" style="color:#3b82f6">{{ stats?.unverified_with_tx || 0 }}</div><div class="com-stat-label">غير موثقين مع نشاط</div></div>
    </div>

    <!-- Large Transactions -->
    <div class="com-card">
      <h3 class="com-title">🚨 معاملات كبيرة — آخر 30 يوم (أكثر من €10,000)</h3>
      <table class="com-table">
        <thead><tr><th>العميل</th><th>النوع</th><th>المبلغ</th><th>التاريخ</th><th>الحالة</th></tr></thead>
        <tbody>
          <tr v-for="t in largeTransactions" :key="t.id">
            <td><Link :href="route('admin.users.show', t.user?.id)" class="com-link">{{ t.user?.full_name }}</Link></td>
            <td>{{ t.type }}</td>
            <td class="font-bold text-red-600">€{{ fmt(t.amount_in_eur) }}</td>
            <td>{{ fmtDate(t.created_at) }}</td>
            <td><span :class="['com-badge', t.status === 'completed' ? 'com-b-green' : t.status === 'failed' ? 'com-b-red' : 'com-b-yellow']">{{ t.status }}</span></td>
          </tr>
          <tr v-if="!largeTransactions?.length"><td colspan="5" class="text-center py-6 text-[#94a3b8]">✅ لا توجد معاملات كبيرة</td></tr>
        </tbody>
      </table>
    </div>

    <!-- High Frequency -->
    <div class="com-card">
      <h3 class="com-title">📊 تكرار عالي — أكثر من 10 معاملات/يوم (آخر 7 أيام)</h3>
      <table class="com-table">
        <thead><tr><th>العميل</th><th>اليوم</th><th>عدد المعاملات</th><th>الحجم الإجمالي</th></tr></thead>
        <tbody>
          <tr v-for="(h, i) in highFrequency" :key="i">
            <td><Link v-if="h.user" :href="route('admin.users.show', h.user_id)" class="com-link">{{ h.user?.full_name }}</Link></td>
            <td>{{ h.day }}</td>
            <td class="font-bold text-amber-600">{{ h.tx_count }}</td>
            <td>€{{ fmt(h.total_volume) }}</td>
          </tr>
          <tr v-if="!highFrequency?.length"><td colspan="4" class="text-center py-6 text-[#94a3b8]">✅ لا توجد حالات</td></tr>
        </tbody>
      </table>
    </div>

    <!-- Unverified with transactions -->
    <div class="com-card">
      <h3 class="com-title">⚠️ عملاء غير موثقين مع نشاط</h3>
      <table class="com-table">
        <thead><tr><th>العميل</th><th>البريد</th><th>حالة KYC</th><th>إجراء</th></tr></thead>
        <tbody>
          <tr v-for="u in unverifiedWithTx" :key="u.id">
            <td class="font-semibold">{{ u.full_name }}</td>
            <td class="text-[#64748b]">{{ u.email }}</td>
            <td><span class="com-badge com-b-yellow">{{ u.kyc_status }}</span></td>
            <td><Link :href="route('admin.users.show', u.id)" class="com-link">عرض الملف</Link></td>
          </tr>
          <tr v-if="!unverifiedWithTx?.length"><td colspan="4" class="text-center py-6 text-[#94a3b8]">✅ جميع العملاء النشطين موثقين</td></tr>
        </tbody>
      </table>
    </div>
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
.com-stats{display:flex;gap:12px;margin-bottom:20px}
.com-stat{background:#fff;border:1px solid #e2e8f0;border-radius:14px;padding:16px 20px;flex:1}
.com-stat-val{font-size:28px;font-weight:800}
.com-stat-label{font-size:12px;color:#64748b;margin-top:2px;font-weight:600}
.com-card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;padding:20px;margin-bottom:16px}
.com-title{font-size:15px;font-weight:700;color:#0f172a;margin-bottom:14px}
.com-table{width:100%;border-collapse:separate;border-spacing:0}
.com-table th{background:#f8fafc;padding:10px 14px;font-size:12px;font-weight:700;color:#334155;border-bottom:1px solid #e2e8f0;text-align:right}
.com-table td{padding:10px 14px;border-bottom:1px solid #f1f5f9;font-size:13px;color:#334155}
.com-link{color:#10b981;text-decoration:none;font-weight:600}.com-link:hover{text-decoration:underline}
.com-badge{font-size:11px;font-weight:600;padding:3px 10px;border-radius:8px}
.com-b-green{background:#ecfdf5;color:#059669}
.com-b-yellow{background:#fffbeb;color:#d97706}
.com-b-red{background:#fef2f2;color:#dc2626}
</style>
