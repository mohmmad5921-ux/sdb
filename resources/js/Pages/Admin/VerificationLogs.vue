<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ logs: Array, stats: Object });
const f = n => Number(n||0).toLocaleString('en');
const stColor = s => ({success:'#10b981',failed:'#ef4444',pending:'#f59e0b'}[s]||'#64748b');
const typeLabel = t => ({biometric:'بيومتري',otp:'OTP',email:'بريد',phone:'هاتف',document:'وثيقة',device:'جهاز',geo:'موقع'}[t]||t);
</script>
<template>
<Head title="سجل التحقق" />
<div class="vl">
  <h1 class="vl-h">🔐 سجل عمليات التحقق</h1>
  <div class="vl-stats">
    <div class="vl-s" v-for="s in [{l:'إجمالي',v:p.stats.total,ic:'📊'},{l:'ناجحة',v:p.stats.success,ic:'✅',c:'#10b981'},{l:'فاشلة',v:p.stats.failed,ic:'❌',c:'#ef4444'},{l:'بيومتري',v:p.stats.biometric,ic:'🔐'},{l:'OTP',v:p.stats.otp,ic:'📱'},{l:'جهاز',v:p.stats.device,ic:'💻'}]" :key="s.l">
      <span class="vl-ic">{{ s.ic }}</span><div><div class="vl-v" :style="{color:s.c||'#0f172a'}">{{ f(s.v) }}</div><div class="vl-l">{{ s.l }}</div></div>
    </div>
  </div>
  <div class="vl-card">
    <table class="vl-tbl"><thead><tr><th>المستخدم</th><th>النوع</th><th>الحالة</th><th>IP</th><th>الجهاز</th><th>الموقع</th><th>التاريخ</th></tr></thead>
      <tbody><tr v-for="l in p.logs" :key="l.id">
        <td class="vl-bold">{{ l.user_name }}</td>
        <td><span class="vl-tag">{{ typeLabel(l.type) }}</span></td>
        <td><span :style="{color:stColor(l.status),fontWeight:700}">{{ l.status }}</span></td>
        <td class="vl-mono">{{ l.ip_address||'—' }}</td>
        <td>{{ l.device||'—' }}</td>
        <td>{{ l.location||'—' }}</td>
        <td class="vl-date">{{ new Date(l.created_at).toLocaleString('ar') }}</td>
      </tr><tr v-if="!p.logs?.length"><td colspan="7" class="vl-empty">لا توجد سجلات</td></tr></tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.vl{padding:24px;direction:rtl}.vl-h{font-size:22px;font-weight:900;color:#0f172a;margin-bottom:20px}
.vl-stats{display:grid;grid-template-columns:repeat(6,1fr);gap:10px;margin-bottom:16px}
.vl-s{display:flex;align-items:center;gap:10px;padding:14px;background:#fff;border-radius:12px;border:1px solid #f1f5f9}
.vl-ic{font-size:22px}.vl-v{font-size:16px;font-weight:900}.vl-l{font-size:10px;color:#94a3b8}
.vl-card{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9}
.vl-tbl{width:100%;border-collapse:collapse}.vl-tbl th{font-size:10px;font-weight:700;color:#94a3b8;text-align:right;padding:10px 12px;border-bottom:1px solid #f1f5f9}
.vl-tbl td{font-size:12px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}.vl-bold{font-weight:700}.vl-mono{font-family:monospace;font-size:10px}.vl-date{font-size:10px;color:#94a3b8}
.vl-tag{font-size:9px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b;font-weight:600}
.vl-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px}
</style>
