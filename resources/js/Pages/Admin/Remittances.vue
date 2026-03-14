<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ remittances: Array, stats: Object });
const f = n => Number(n||0).toLocaleString('en');
const filter = ref('all');
const filtered = computed(() => {
  if (!p.remittances) return [];
  if (filter.value === 'all') return p.remittances;
  return p.remittances.filter(r => r.status === filter.value);
});
const statusBadge = s => ({
  ready: {bg:'#ecfdf5',color:'#059669',label:'جاهزة'},
  collected: {bg:'#dbeafe',color:'#2563eb',label:'تم الاستلام'},
  expired: {bg:'#fef2f2',color:'#dc2626',label:'منتهية'},
  cancelled: {bg:'#f1f5f9',color:'#64748b',label:'ملغاة'},
  pending: {bg:'#fffbeb',color:'#d97706',label:'معلقة'},
}[s] || {bg:'#f1f5f9',color:'#64748b',label:s});
</script>
<template>
<Head title="الحوالات — الأدمن" />
<div class="rm">
  <div class="rm-header"><h1 class="rm-h">💸 إدارة الحوالات</h1></div>
  <div class="rm-kpis">
    <div class="rm-kpi"><div class="rm-kpi-ic" style="background:#eff6ff">💸</div><div><div class="rm-kpi-v">{{ f(p.stats?.total) }}</div><div class="rm-kpi-l">إجمالي الحوالات</div></div></div>
    <div class="rm-kpi"><div class="rm-kpi-ic" style="background:#ecfdf5">✅</div><div><div class="rm-kpi-v">{{ f(p.stats?.collected) }}</div><div class="rm-kpi-l">تم استلامها</div></div></div>
    <div class="rm-kpi"><div class="rm-kpi-ic" style="background:#fef3c7">⏳</div><div><div class="rm-kpi-v">{{ f(p.stats?.pending) }}</div><div class="rm-kpi-l">بانتظار الاستلام</div></div></div>
    <div class="rm-kpi"><div class="rm-kpi-ic" style="background:#dbeafe">💰</div><div><div class="rm-kpi-v">€{{ f(p.stats?.totalAmount) }}</div><div class="rm-kpi-l">إجمالي المبالغ</div></div></div>
  </div>
  <div class="rm-filters">
    <button v-for="f2 in [{k:'all',l:'الكل'},{k:'ready',l:'جاهزة'},{k:'collected',l:'تم الاستلام'},{k:'expired',l:'منتهية'}]" :key="f2.k" :class="['rm-fbtn', filter===f2.k?'rm-fbtn-active':'']" @click="filter=f2.k">{{ f2.l }}</button>
  </div>
  <div class="rm-card">
    <table class="rm-tbl">
      <thead><tr><th>#</th><th>المرسل</th><th>المستلم</th><th>المبلغ</th><th>الوكيل</th><th>المحافظة</th><th>الحالة</th><th>الكود</th><th>التاريخ</th></tr></thead>
      <tbody>
        <tr v-for="r in filtered" :key="r.id">
          <td>{{ r.id }}</td>
          <td class="rm-bold">{{ r.sender_name }}</td>
          <td>{{ r.recipient_name }}<br><span class="rm-sub">{{ r.recipient_phone }}</span></td>
          <td class="rm-amount">€{{ f(r.amount) }}</td>
          <td>{{ r.agent_name_ar }}</td>
          <td>{{ r.governorate_ar }}</td>
          <td><span class="rm-badge" :style="{background:statusBadge(r.status).bg,color:statusBadge(r.status).color}">{{ statusBadge(r.status).label }}</span></td>
          <td class="rm-code">{{ r.notification_code }}</td>
          <td class="rm-date">{{ r.created_at ? new Date(r.created_at).toLocaleDateString('ar') : '' }}</td>
        </tr>
        <tr v-if="!filtered.length"><td colspan="9" class="rm-empty">لا توجد حوالات</td></tr>
      </tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.rm{direction:rtl;max-width:1400px;margin:0 auto}
.rm-header{margin-bottom:16px}.rm-h{font-size:22px;font-weight:900;color:#0f172a}
.rm-kpis{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:16px}
.rm-kpi{display:flex;align-items:center;gap:12px;background:#fff;border-radius:14px;padding:16px;border:1px solid #f1f5f9}
.rm-kpi-ic{width:42px;height:42px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
.rm-kpi-v{font-size:22px;font-weight:900;color:#0f172a}.rm-kpi-l{font-size:11px;color:#94a3b8;font-weight:600}
.rm-filters{display:flex;gap:8px;margin-bottom:14px}
.rm-fbtn{padding:6px 16px;border-radius:8px;font-size:12px;font-weight:700;border:1px solid #e2e8f0;background:#fff;color:#64748b;cursor:pointer}
.rm-fbtn-active{background:#10b981;color:#fff;border-color:#10b981}
.rm-card{background:#fff;border:1px solid #f1f5f9;border-radius:16px;padding:16px;overflow-x:auto}
.rm-tbl{width:100%;border-collapse:collapse;min-width:900px}
.rm-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:10px;border-bottom:2px solid #f1f5f9}
.rm-tbl td{font-size:13px;color:#334155;padding:10px;border-bottom:1px solid #f8fafc}
.rm-bold{font-weight:700;color:#0f172a}
.rm-sub{font-size:11px;color:#94a3b8}
.rm-amount{font-weight:800;color:#059669}
.rm-badge{font-size:10px;font-weight:700;padding:3px 10px;border-radius:8px}
.rm-code{font-family:monospace;font-weight:700;color:#2563eb;letter-spacing:1px}
.rm-date{font-size:11px;color:#94a3b8}
.rm-empty{text-align:center;color:#cbd5e1;padding:30px}
@media(max-width:768px){.rm-kpis{grid-template-columns:repeat(2,1fr)}}
</style>
