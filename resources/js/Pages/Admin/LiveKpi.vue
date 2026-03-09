<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ kpis: Object });
const cards = [
  {l:'إجمالي العملاء',k:'total_users',ic:'👥',c:'#2563eb'},
  {l:'تسجيل اليوم',k:'today_registrations',ic:'📝',c:'#10b981'},
  {l:'نشطين اليوم',k:'active_today',ic:'⚡',c:'#f59e0b'},
  {l:'الحسابات',k:'total_accounts',ic:'🏦',c:'#8b5cf6'},
  {l:'إجمالي المعاملات',k:'total_transactions',ic:'💸',c:'#0ea5e9'},
  {l:'معاملات اليوم',k:'today_transactions',ic:'📊',c:'#10b981'},
  {l:'حجم اليوم',k:'today_volume',ic:'💰',c:'#f97316',prefix:'€'},
  {l:'KYC معلّق',k:'pending_kyc',ic:'🪪',c:'#f59e0b'},
  {l:'موافقات معلّقة',k:'pending_approvals',ic:'✅',c:'#ef4444'},
  {l:'تذاكر مفتوحة',k:'open_tickets',ic:'🎫',c:'#dc2626'},
  {l:'حسابات مجمّدة',k:'frozen_accounts',ic:'🧊',c:'#64748b'},
  {l:'تنبيهات',k:'unread_alerts',ic:'🚨',c:'#ef4444'},
  {l:'تسجيل مسبق',k:'preregistrations',ic:'📋',c:'#2563eb'},
  {l:'قائمة الانتظار',k:'waitlist',ic:'📩',c:'#8b5cf6'},
];
</script>
<template>
<Head title="KPIs حية" />
<div class="kp"><h1 class="kp-h">📊 لوحة KPIs الحية</h1>
  <div class="kp-grid">
    <div v-for="c in cards" :key="c.k" class="kp-card">
      <div class="kp-ic">{{ c.ic }}</div>
      <div class="kp-val" :style="{color:c.c}">{{ c.prefix||'' }}{{ Number(p.kpis[c.k]||0).toLocaleString('en') }}</div>
      <div class="kp-label">{{ c.l }}</div>
    </div>
  </div>
  <div class="kp-note">⏱ يتم تحديث البيانات عند كل زيارة</div>
</div>
</template>
<style scoped>
.kp{padding:24px;direction:rtl}.kp-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:24px}
.kp-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px}
.kp-card{background:#fff;border-radius:16px;padding:24px;border:1px solid #f1f5f9;text-align:center;transition:transform .2s}.kp-card:hover{transform:translateY(-2px)}
.kp-ic{font-size:32px;margin-bottom:8px}.kp-val{font-size:28px;font-weight:900;margin-bottom:4px}.kp-label{font-size:12px;color:#94a3b8;font-weight:600}
.kp-note{text-align:center;margin-top:24px;font-size:12px;color:#94a3b8}
</style>
