<script setup>
import { Head, router } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref } from 'vue';
const props = defineProps({ logs: Object, filters: Object, stats: Object, templates: Array });
const search = ref(props.filters?.search || '');
const chan = ref(props.filters?.channel || '');
const filter = () => router.get(route('admin.communications'), { channel: chan.value, search: search.value }, { preserveState: true });
const chanIcons = { email: '📧', sms: '📱', push: '🔔', system: '⚙️' };
const fmtDate = (d) => new Date(d).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' });
</script>
<template>
<Head title="سجل التواصل" />
<AdminLayout title="📧 سجل التواصل" subtitle="سجل جميع الرسائل المرسلة للعملاء">
  <div class="flex gap-3 mb-4">
    <div v-for="(label,key) in {email:'📧 بريد',sms:'📱 SMS',push:'🔔 دفع',system:'⚙️ نظام'}" :key="key"
      @click="chan = chan===key?'':key; filter()"
      :class="['px-4 py-2 rounded-xl text-sm font-semibold border cursor-pointer transition',chan===key?'bg-emerald-500 text-white border-emerald-500':'bg-white text-gray-600 border-gray-200']">
      {{ label }} ({{ stats[key] || 0 }})
    </div>
    <input v-model="search" @keyup.enter="filter" placeholder="بحث..." class="flex-1 px-3 py-2 border border-gray-200 rounded-xl text-sm" />
  </div>
  <div class="bg-white border border-gray-200 rounded-2xl overflow-hidden">
    <table class="w-full">
      <thead><tr class="bg-gray-50"><th class="text-right p-3 text-xs font-bold text-gray-500">القناة</th><th class="text-right p-3 text-xs font-bold text-gray-500">العميل</th><th class="text-right p-3 text-xs font-bold text-gray-500">الموضوع</th><th class="text-right p-3 text-xs font-bold text-gray-500">الحالة</th><th class="text-right p-3 text-xs font-bold text-gray-500">التاريخ</th></tr></thead>
      <tbody>
        <tr v-for="l in logs.data" :key="l.id" class="border-b border-gray-50 hover:bg-gray-50">
          <td class="p-3 text-lg">{{ chanIcons[l.channel] }}</td>
          <td class="p-3"><div class="font-semibold text-sm">{{ l.full_name }}</div><div class="text-xs text-gray-400">{{ l.email }}</div></td>
          <td class="p-3 text-sm text-gray-700">{{ l.subject }}</td>
          <td class="p-3"><span :class="['text-xs font-semibold px-2 py-1 rounded-md',l.status==='sent'?'bg-emerald-50 text-emerald-600':'bg-red-50 text-red-600']">{{ l.status }}</span></td>
          <td class="p-3 text-xs text-gray-400">{{ fmtDate(l.created_at) }}</td>
        </tr>
        <tr v-if="!logs.data?.length"><td colspan="5" class="py-12 text-center text-gray-400">لا توجد سجلات</td></tr>
      </tbody>
    </table>
  </div>
  <div class="bg-white border border-gray-200 rounded-2xl p-5 mt-4">
    <h3 class="text-base font-bold text-gray-900 mb-3">📋 قوالب البريد الإلكتروني</h3>
    <div class="grid grid-cols-3 gap-3">
      <div v-for="t in templates" :key="t.key" class="border border-gray-100 rounded-xl p-3 hover:border-emerald-300 transition">
        <div class="font-semibold text-sm text-gray-900">{{ t.name }}</div>
        <div class="text-xs text-gray-500 mt-1">{{ t.subject }}</div>
      </div>
    </div>
  </div>
</AdminLayout>
</template>
