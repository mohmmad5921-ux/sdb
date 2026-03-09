<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref } from 'vue';

const props = defineProps({ logs: Object, filters: Object });
const search = ref(props.filters?.search || '');
const applyFilter = () => router.get(route('admin.audit-logs'), { search: search.value }, { preserveState: true });
</script>

<template>
  <Head title="Audit Logs - سجل التدقيق" />
  <AdminLayout title="📋 سجلات التدقيق">
    <div class="al-root">
      <div class="al-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <div><h1 class="text-2xl font-bold text-[#0f172a]">📋 سجل التدقيق</h1><p class="text-sm text-[#475569] mt-1">جميع الإجراءات المسجلة في النظام</p></div>
          <Link :href="route('admin.dashboard')" class="al-back">← الرئيسية</Link>
        </div>
      </div>
      <div class="max-w-7xl mx-auto px-6 py-6">
        <div class="mb-6"><input v-model="search" @keyup.enter="applyFilter" type="text" placeholder="بحث..." class="al-search" /></div>
        <div class="al-card overflow-hidden">
          <table class="al-table">
            <thead><tr><th>التاريخ</th><th>المستخدم</th><th>الإجراء</th><th>الكيان</th><th>التفاصيل</th><th>IP</th></tr></thead>
            <tbody>
              <tr v-for="log in logs.data" :key="log.id">
                <td class="text-[#475569] text-xs">{{ new Date(log.created_at).toLocaleString('en-GB') }}</td>
                <td class="font-semibold text-[#0f172a]">{{ log.user?.full_name || '—' }}</td>
                <td><span class="al-action">{{ log.action }}</span></td>
                <td class="text-[#475569]">{{ log.entity_type }} #{{ log.entity_id }}</td>
                <td class="text-xs max-w-[250px]">
                  <span v-if="log.old_values" class="text-red-500">{{ JSON.stringify(log.old_values) }}</span>
                  <span v-if="log.old_values && log.new_values" class="text-[#475569]"> → </span>
                  <span v-if="log.new_values" class="text-emerald-600">{{ JSON.stringify(log.new_values) }}</span>
                </td>
                <td class="text-xs text-[#475569] font-mono">{{ log.ip_address }}</td>
              </tr>
              <tr v-if="!logs.data?.length"><td colspan="6" class="py-12 text-center text-[#475569]">لا توجد سجلات</td></tr>
            </tbody>
          </table>
        </div>
        <div class="flex justify-center gap-2 mt-6" v-if="logs.last_page > 1">
          <Link v-for="link in logs.links" :key="link.label" :href="link.url || '#'" :class="['al-pg', link.active ? 'al-pg-act' : '']" v-html="link.label" />
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
@import '../../../css/admin.css';
.al-root{min-height:100vh;background:#f1f5f9;direction:rtl}
.al-header{background:#ffffff;border-bottom:1px solid #e2e8f0}
.al-back{padding:8px 18px;background:#ffffff;color:#3b82f6;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(16,185,129,0.2)}.al-back:hover{background:#10b981;color:#fff}
.al-search{width:320px;padding:10px 16px;border:1px solid #e2e8f0;border-radius:12px;background:#ffffff;font-size:13px;color:#0f172a;outline:none}.al-search:focus{border-color:#10b981}.al-search::placeholder{color:#64748b}
.al-card{background:#ffffff;border:1px solid #e2e8f0;border-radius:16px}
.al-table{width:100%;border-collapse:collapse;font-size:13px}
.al-table th{text-align:right;padding:12px 16px;background:#ffffff;color:#64748b;font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #e2e8f0}
.al-table td{padding:12px 16px;border-bottom:1px solid #f1f5f9;vertical-align:middle}
.al-table tr:hover td{background:#ffffff}
.al-action{font-size:12px;font-weight:600;color:#3b82f6;background:rgba(16,185,129,0.1);padding:2px 8px;border-radius:6px}
.al-pg{padding:6px 14px;border-radius:8px;font-size:13px;background:#ffffff;color:#334155;border:1px solid #e2e8f0;text-decoration:none}.al-pg:hover{border-color:#10b981;color:#3b82f6}
.al-pg-act{background:#10b981!important;color:#fff!important;border-color:#10b981!important}
</style>
