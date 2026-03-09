<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ sessions: Array });
const kill = id => { if(confirm('إنهاء الجلسة؟')) router.delete(route('admin.sessions.destroy', id)); };
</script>
<template>
<Head title="مراقبة الجلسات" />
<div class="ss"><h1 class="ss-h">🔍 مراقبة الجلسات النشطة</h1>
  <div class="ss-cnt">{{ p.sessions.length }} جلسة نشطة</div>
  <table class="ss-tbl"><thead><tr><th>المستخدم</th><th>البريد</th><th>الدور</th><th>IP</th><th>آخر نشاط</th><th>إجراء</th></tr></thead>
    <tbody><tr v-for="s in p.sessions" :key="s.id">
      <td class="ss-bold">{{ s.user_name||'—' }}</td><td>{{ s.user_email||'—' }}</td>
      <td><span class="ss-role" :class="s.role==='admin'?'ss-admin':'ss-user'">{{ s.role==='admin'?'أدمن':'عميل' }}</span></td>
      <td class="ss-ip">{{ s.ip_address }}</td><td class="ss-time">{{ s.last_active }}</td>
      <td><button @click="kill(s.id)" class="ss-kill">إنهاء</button></td>
    </tr></tbody>
  </table>
</div>
</template>
<style scoped>
.ss{padding:24px;direction:rtl}.ss-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:8px}.ss-cnt{font-size:13px;color:#64748b;margin-bottom:20px}
.ss-tbl{width:100%;background:#fff;border-radius:16px;border-collapse:collapse}
.ss-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:12px 16px;border-bottom:1px solid #f1f5f9}
.ss-tbl td{font-size:13px;color:#334155;padding:12px 16px;border-bottom:1px solid #f8fafc}.ss-bold{font-weight:700}
.ss-role{font-size:10px;font-weight:700;padding:2px 8px;border-radius:5px}.ss-admin{background:#fef2f2;color:#dc2626}.ss-user{background:#ecfdf5;color:#059669}
.ss-ip{font-family:monospace;font-size:12px;color:#64748b}.ss-time{font-size:12px;color:#94a3b8}
.ss-kill{padding:4px 12px;background:#fef2f2;color:#dc2626;border:1px solid #fecaca;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer}
</style>
