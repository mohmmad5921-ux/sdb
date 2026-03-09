<script setup>
import { Head } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
const props = defineProps({ loginHistory: Array, failedLogins: Number, uniqueIps: Number });
const fmtDate = (d) => new Date(d).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' });
</script>
<template>
<Head title="أمان الأدمن" />
<AdminLayout title="🔐 أمان الإدارة" subtitle="سجل تسجيلات الدخول والجلسات">
  <div class="flex gap-4 mb-4">
    <div class="bg-white border border-gray-200 rounded-2xl p-5 flex-1 text-center"><div class="text-3xl font-extrabold text-red-500">{{ failedLogins }}</div><div class="text-sm text-gray-500 mt-1">محاولات فاشلة (7 أيام)</div></div>
    <div class="bg-white border border-gray-200 rounded-2xl p-5 flex-1 text-center"><div class="text-3xl font-extrabold text-blue-500">{{ uniqueIps }}</div><div class="text-sm text-gray-500 mt-1">عناوين IP فريدة (30 يوم)</div></div>
    <div class="bg-white border border-gray-200 rounded-2xl p-5 flex-1 text-center"><div class="text-3xl font-extrabold text-gray-900">{{ (loginHistory || []).length }}</div><div class="text-sm text-gray-500 mt-1">إجمالي السجلات</div></div>
  </div>
  <div class="bg-white border border-gray-200 rounded-2xl overflow-hidden">
    <table class="w-full">
      <thead><tr class="bg-gray-50"><th class="text-right p-3 text-xs font-bold text-gray-500">المستخدم</th><th class="text-right p-3 text-xs font-bold text-gray-500">IP</th><th class="text-right p-3 text-xs font-bold text-gray-500">الجهاز</th><th class="text-right p-3 text-xs font-bold text-gray-500">الحالة</th><th class="text-right p-3 text-xs font-bold text-gray-500">التاريخ</th></tr></thead>
      <tbody>
        <tr v-for="l in loginHistory" :key="l.id" class="border-b border-gray-50">
          <td class="p-3"><div class="font-semibold text-sm">{{ l.full_name }}</div><div class="text-xs text-gray-400">{{ l.email }}</div></td>
          <td class="p-3 font-mono text-sm">{{ l.ip_address }}</td>
          <td class="p-3 text-xs text-gray-500 max-w-[200px] truncate">{{ l.device || l.user_agent?.substring(0, 50) || '—' }}</td>
          <td class="p-3"><span :class="['text-xs font-semibold px-2 py-1 rounded-md',l.status==='success'?'bg-emerald-50 text-emerald-600':'bg-red-50 text-red-600']">{{ l.status === 'success' ? '✅ ناجح' : '❌ فاشل' }}</span></td>
          <td class="p-3 text-xs text-gray-400">{{ fmtDate(l.created_at) }}</td>
        </tr>
        <tr v-if="!(loginHistory || []).length"><td colspan="5" class="py-12 text-center text-gray-400">لا توجد سجلات بعد</td></tr>
      </tbody>
    </table>
  </div>
</AdminLayout>
</template>
