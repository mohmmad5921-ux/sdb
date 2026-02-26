<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref } from 'vue';

const props = defineProps({ logs: Object, filters: Object });
const search = ref(props.filters?.search || '');
const applyFilter = () => router.get(route('admin.audit-logs'), { search: search.value }, { preserveState: true });
</script>

<template>
  <Head title="Audit Logs - سجل التدقيق" />
  <AuthenticatedLayout>
    <div class="al-root">
      <div class="al-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <div><h1 class="text-2xl font-bold text-[#1A2B4A]">📋 سجل التدقيق</h1><p class="text-sm text-[#8896AB] mt-1">جميع الإجراءات المسجلة في النظام</p></div>
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
                <td class="text-[#8896AB] text-xs">{{ new Date(log.created_at).toLocaleString('en-GB') }}</td>
                <td class="font-semibold text-[#1A2B4A]">{{ log.user?.full_name || '—' }}</td>
                <td><span class="al-action">{{ log.action }}</span></td>
                <td class="text-[#8896AB]">{{ log.entity_type }} #{{ log.entity_id }}</td>
                <td class="text-xs max-w-[250px]">
                  <span v-if="log.old_values" class="text-red-500">{{ JSON.stringify(log.old_values) }}</span>
                  <span v-if="log.old_values && log.new_values" class="text-[#8896AB]"> → </span>
                  <span v-if="log.new_values" class="text-emerald-600">{{ JSON.stringify(log.new_values) }}</span>
                </td>
                <td class="text-xs text-[#8896AB] font-mono">{{ log.ip_address }}</td>
              </tr>
              <tr v-if="!logs.data?.length"><td colspan="6" class="py-12 text-center text-[#8896AB]">لا توجد سجلات</td></tr>
            </tbody>
          </table>
        </div>
        <div class="flex justify-center gap-2 mt-6" v-if="logs.last_page > 1">
          <Link v-for="link in logs.links" :key="link.label" :href="link.url || '#'" :class="['al-pg', link.active ? 'al-pg-act' : '']" v-html="link.label" />
        </div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.al-root{min-height:100vh;background:#F0F2F5;direction:rtl}
.al-header{background:linear-gradient(135deg,#fff,#F8FAFC);border-bottom:1px solid #E8ECF1}
.al-back{padding:8px 18px;background:#F0F4FF;color:#1E5EFF;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(30,94,255,0.12)}.al-back:hover{background:#1E5EFF;color:#fff}
.al-search{width:320px;padding:10px 16px;border:1px solid #E8ECF1;border-radius:12px;background:#fff;font-size:13px;color:#1A2B4A;outline:none}.al-search:focus{border-color:#1E5EFF}.al-search::placeholder{color:#8896AB}
.al-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px}
.al-table{width:100%;border-collapse:collapse;font-size:13px}
.al-table th{text-align:right;padding:12px 16px;background:#FAFBFC;color:#8896AB;font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #E8ECF1}
.al-table td{padding:12px 16px;border-bottom:1px solid #F0F2F5;vertical-align:middle}
.al-table tr:hover td{background:#FAFBFC}
.al-action{font-size:12px;font-weight:600;color:#1E5EFF;background:rgba(30,94,255,0.08);padding:2px 8px;border-radius:6px}
.al-pg{padding:6px 14px;border-radius:8px;font-size:13px;background:#fff;color:#5A6B82;border:1px solid #E8ECF1;text-decoration:none}.al-pg:hover{border-color:#1E5EFF;color:#1E5EFF}
.al-pg-act{background:#1E5EFF!important;color:#fff!important;border-color:#1E5EFF!important}
</style>
