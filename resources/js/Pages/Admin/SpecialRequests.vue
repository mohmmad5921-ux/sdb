<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ requests: Array });
const notes = ref({});
const handle = (id, status) => router.post(route('admin.special-requests.handle', id), {status, admin_notes: notes.value[id]||''});
const typeLabel = t => ({limit_raise:'رفع حدود',close_account:'إغلاق حساب',name_change:'تغيير اسم',currency_add:'إضافة عملة'}[t]||t);
</script>
<template>
<Head title="طلبات خاصة" />
<div class="sr"><h1 class="sr-h">📋 الطلبات الخاصة</h1>
  <div v-for="r in p.requests" :key="r.id" class="sr-item">
    <div class="sr-top"><span class="sr-user">{{ r.user_name }}</span><span class="sr-email">{{ r.user_email }}</span><span class="sr-type">{{ typeLabel(r.type) }}</span>
      <span class="sr-st" :class="'sr-'+r.status">{{ {pending:'معلّق',approved:'مقبول',rejected:'مرفوض'}[r.status] }}</span></div>
    <div class="sr-desc">{{ r.description }}</div>
    <template v-if="r.status==='pending'">
      <textarea v-model="notes[r.id]" placeholder="ملاحظات..." class="sr-ta" rows="2"></textarea>
      <div class="sr-acts"><button @click="handle(r.id,'approved')" class="sr-btn sr-g">✓ قبول</button><button @click="handle(r.id,'rejected')" class="sr-btn sr-r">✗ رفض</button></div>
    </template>
  </div>
  <div v-if="!p.requests.length" class="sr-empty">لا توجد طلبات</div>
</div>
</template>
<style scoped>
.sr{padding:24px;direction:rtl}.sr-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:20px}
.sr-item{background:#fff;border-radius:14px;padding:20px;border:1px solid #f1f5f9;margin-bottom:12px}
.sr-top{display:flex;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:8px}.sr-user{font-weight:700;color:#0f172a}.sr-email{font-size:12px;color:#94a3b8}
.sr-type{font-size:10px;font-weight:700;background:#eff6ff;color:#2563eb;padding:2px 8px;border-radius:5px}
.sr-st{font-size:10px;font-weight:700;padding:2px 8px;border-radius:5px;margin-right:auto}.sr-pending{background:#fefce8;color:#ca8a04}.sr-approved{background:#ecfdf5;color:#059669}.sr-rejected{background:#fef2f2;color:#dc2626}
.sr-desc{font-size:13px;color:#475569;margin-bottom:10px}
.sr-ta{width:100%;padding:10px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;resize:none;outline:none;margin-bottom:8px;box-sizing:border-box}
.sr-acts{display:flex;gap:8px}.sr-btn{padding:8px 18px;border:none;border-radius:8px;font-weight:700;cursor:pointer;font-size:12px;color:#fff}.sr-g{background:#10b981}.sr-r{background:#ef4444}
.sr-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:40px}
</style>
