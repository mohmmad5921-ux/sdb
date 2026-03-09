<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ logs: Array, categories: Array, filter: String });
const catLabel = c => ({settings:'الإعدادات',fees:'الرسوم',limits:'الحدود',rates:'الأسعار',cms:'المحتوى'}[c]||c);
</script>
<template>
<Head title="سجل التغييرات" />
<div class="cl">
  <h1 class="cl-h">📜 سجل تغييرات النظام</h1>
  <div class="cl-filters">
    <a :href="route('admin.changelog')" class="cl-f" :class="{'cl-f-on':p.filter==='all'}">الكل</a>
    <a v-for="c in p.categories" :key="c" :href="route('admin.changelog',{category:c})" class="cl-f" :class="{'cl-f-on':p.filter===c}">{{ catLabel(c) }}</a>
  </div>
  <div class="cl-list">
    <div v-for="log in p.logs" :key="log.id" class="cl-entry">
      <div class="cl-meta"><span class="cl-admin">{{ log.admin_name }}</span><span class="cl-cat">{{ catLabel(log.category) }}</span><span class="cl-act" :class="'cl-'+log.action">{{ {create:'إنشاء',update:'تعديل',delete:'حذف'}[log.action]||log.action }}</span><span class="cl-time">{{ new Date(log.created_at).toLocaleString('ar') }}</span></div>
      <div class="cl-target">{{ log.target }}</div>
    </div>
    <div v-if="!p.logs.length" class="cl-empty">لا يوجد سجل</div>
  </div>
</div>
</template>
<style scoped>
.cl{padding:24px;direction:rtl}.cl-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:20px}
.cl-filters{display:flex;gap:8px;margin-bottom:20px}.cl-f{padding:8px 16px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;font-size:12px;font-weight:600;color:#64748b;text-decoration:none}.cl-f-on{background:#0f172a;color:#fff;border-color:#0f172a}
.cl-entry{background:#fff;border-radius:14px;padding:16px 20px;border:1px solid #f1f5f9;margin-bottom:10px}
.cl-meta{display:flex;align-items:center;gap:8px;margin-bottom:4px}.cl-admin{font-size:13px;font-weight:700;color:#0f172a}
.cl-cat{font-size:10px;font-weight:700;background:#eff6ff;color:#2563eb;padding:2px 8px;border-radius:5px}
.cl-act{font-size:10px;font-weight:700;padding:2px 8px;border-radius:5px}.cl-create{background:#ecfdf5;color:#059669}.cl-update{background:#fefce8;color:#ca8a04}.cl-delete{background:#fef2f2;color:#dc2626}
.cl-time{font-size:11px;color:#94a3b8;margin-right:auto}.cl-target{font-size:14px;font-weight:600;color:#334155}
.cl-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:40px}
</style>
