<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ stats: Object, monthly: Array, userGrowth: Array, feeRevenue: Array });
const fmt = n => Number(n).toLocaleString('en', {maximumFractionDigits:0});
</script>
<template>
<Head title="التقارير" />
<div class="rp">
  <h1 class="rp-h">📑 التقارير والإحصائيات</h1>

  <div class="rp-stats">
    <div class="rp-s" v-for="s in [{l:'العملاء',v:p.stats.users,ic:'👥'},{l:'الحسابات',v:p.stats.accounts,ic:'🏦'},{l:'المعاملات',v:p.stats.transactions,ic:'💸'},{l:'إجمالي الحجم',v:'€'+fmt(p.stats.volume),ic:'📊'}]" :key="s.l">
      <span class="rp-s-ic">{{ s.ic }}</span>
      <div><div class="rp-s-v">{{ typeof s.v==='number'?fmt(s.v):s.v }}</div><div class="rp-s-l">{{ s.l }}</div></div>
    </div>
  </div>

  <div class="rp-grid">
    <div class="rp-card">
      <h3>📈 حجم المعاملات الشهري</h3>
      <table class="rp-tbl"><thead><tr><th>الشهر</th><th>العدد</th><th>الحجم</th></tr></thead>
        <tbody><tr v-for="m in p.monthly" :key="m.month"><td>{{ m.month }}</td><td>{{ fmt(m.count) }}</td><td>€{{ fmt(m.volume) }}</td></tr>
        <tr v-if="!p.monthly.length"><td colspan="3" class="rp-empty">لا توجد بيانات</td></tr></tbody>
      </table>
    </div>

    <div class="rp-card">
      <h3>👥 نمو المستخدمين</h3>
      <table class="rp-tbl"><thead><tr><th>الشهر</th><th>مستخدمين جدد</th></tr></thead>
        <tbody><tr v-for="u in p.userGrowth" :key="u.month"><td>{{ u.month }}</td><td>{{ u.count }}</td></tr>
        <tr v-if="!p.userGrowth.length"><td colspan="2" class="rp-empty">لا توجد بيانات</td></tr></tbody>
      </table>
    </div>
  </div>

  <div class="rp-card" style="margin-top:20px">
    <h3>💰 هيكل الرسوم</h3>
    <table class="rp-tbl"><thead><tr><th>الرسم</th><th>النوع</th><th>النسبة</th><th>ثابت</th></tr></thead>
      <tbody><tr v-for="f in p.feeRevenue" :key="f.name"><td>{{ f.name }}</td><td>{{ f.fee_type }}</td><td>{{ f.percentage }}%</td><td>€{{ f.fixed_amount }}</td></tr>
      <tr v-if="!p.feeRevenue.length"><td colspan="4" class="rp-empty">لا توجد رسوم</td></tr></tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.rp{padding:24px;direction:rtl}.rp-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:24px}
.rp-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px}
.rp-s{display:flex;align-items:center;gap:14px;padding:20px;background:#fff;border-radius:16px;border:1px solid #f1f5f9}
.rp-s-ic{font-size:28px}.rp-s-v{font-size:22px;font-weight:800;color:#0f172a}.rp-s-l{font-size:12px;color:#94a3b8;margin-top:2px}
.rp-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px}
.rp-card{background:#fff;border-radius:16px;padding:24px;border:1px solid #f1f5f9}
.rp-card h3{font-size:15px;font-weight:700;color:#334155;margin-bottom:16px}
.rp-tbl{width:100%;border-collapse:collapse}.rp-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:8px 12px;border-bottom:1px solid #f1f5f9}
.rp-tbl td{font-size:13px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}
.rp-empty{text-align:center;color:#cbd5e1;font-style:italic}
</style>
