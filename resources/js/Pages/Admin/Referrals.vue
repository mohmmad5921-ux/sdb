<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ referrals: Array, stats: Object });
const fmt = n => Number(n||0).toLocaleString('en');
</script>
<template>
<Head title="الإحالات" />
<div class="rf"><h1 class="rf-h">🔗 تتبع الإحالات</h1>
  <div class="rf-stats">
    <div class="rf-s" v-for="s in [{l:'الإجمالي',v:p.stats.total,ic:'📊'},{l:'مكتملة',v:p.stats.completed,ic:'✅'},{l:'مكافآت',v:p.stats.rewarded,ic:'🎁'},{l:'إجمالي المكافآت',v:'€'+fmt(p.stats.total_rewards),ic:'💰'}]" :key="s.l">
      <span class="rf-ic">{{ s.ic }}</span><div><div class="rf-v">{{ typeof s.v==='number'?fmt(s.v):s.v }}</div><div class="rf-l">{{ s.l }}</div></div>
    </div>
  </div>
  <table class="rf-tbl"><thead><tr><th>المُحيل</th><th>المُحال</th><th>الكود</th><th>الحالة</th><th>المكافأة</th><th>التاريخ</th></tr></thead>
    <tbody><tr v-for="r in p.referrals" :key="r.id">
      <td class="rf-bold">{{ r.referrer_name }}</td><td>{{ r.referred_name }}</td>
      <td><code class="rf-code">{{ r.code }}</code></td>
      <td><span class="rf-st" :class="'rf-'+r.status">{{ {pending:'معلّق',completed:'مكتمل',rewarded:'مكافأ'}[r.status] }}</span></td>
      <td>€{{ r.reward_amount }}</td><td class="rf-date">{{ new Date(r.created_at).toLocaleDateString('ar') }}</td>
    </tr><tr v-if="!p.referrals.length"><td colspan="6" class="rf-empty">لا توجد إحالات</td></tr></tbody>
  </table>
</div>
</template>
<style scoped>
.rf{padding:24px;direction:rtl}.rf-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:20px}
.rf-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:20px}
.rf-s{display:flex;align-items:center;gap:12px;padding:18px;background:#fff;border-radius:14px;border:1px solid #f1f5f9}
.rf-ic{font-size:26px}.rf-v{font-size:20px;font-weight:800;color:#0f172a}.rf-l{font-size:11px;color:#94a3b8;margin-top:2px}
.rf-tbl{width:100%;background:#fff;border-radius:16px;border-collapse:collapse}
.rf-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:12px 16px;border-bottom:1px solid #f1f5f9}
.rf-tbl td{font-size:13px;color:#334155;padding:12px 16px;border-bottom:1px solid #f8fafc}.rf-bold{font-weight:700}
.rf-code{background:#f1f5f9;padding:2px 8px;border-radius:5px;font-size:11px;color:#2563eb}
.rf-st{font-size:10px;font-weight:700;padding:2px 8px;border-radius:5px}.rf-pending{background:#fefce8;color:#ca8a04}.rf-completed{background:#ecfdf5;color:#059669}.rf-rewarded{background:#eff6ff;color:#2563eb}
.rf-date{color:#94a3b8;font-size:12px}.rf-empty{text-align:center;color:#cbd5e1;font-style:italic}
</style>
