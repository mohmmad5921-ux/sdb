<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ ips: Array, currentIp: String });
const show = ref(false);
const form = useForm({ip_address:'',label:''});
const save = () => form.post(route('admin.ip-whitelist.store'), {onSuccess:()=>{show.value=false;form.reset()}});
const del = id => { if(confirm('حذف؟')) router.delete(route('admin.ip-whitelist.destroy', id)); };
</script>
<template>
<Head title="IP Whitelist" />
<div class="ip"><div class="ip-top"><h1 class="ip-h">📱 قائمة IP المسموح بها</h1><button @click="show=!show" class="ip-add">+ إضافة IP</button></div>
  <div class="ip-curr">عنوان IP الحالي: <code>{{ p.currentIp }}</code></div>
  <div v-if="show" class="ip-form">
    <input v-model="form.ip_address" placeholder="192.168.1.1" class="ip-inp"/>
    <input v-model="form.label" placeholder="الوصف (اختياري)" class="ip-inp"/>
    <button @click="save" class="ip-sv">حفظ</button>
  </div>
  <table class="ip-tbl"><thead><tr><th>IP</th><th>الوصف</th><th>أضافه</th><th>التاريخ</th><th>إجراء</th></tr></thead>
    <tbody><tr v-for="ip in p.ips" :key="ip.id">
      <td class="ip-addr">{{ ip.ip_address }}</td><td>{{ ip.label||'—' }}</td><td>{{ ip.admin_name }}</td>
      <td class="ip-date">{{ new Date(ip.created_at).toLocaleDateString('ar') }}</td>
      <td><button @click="del(ip.id)" class="ip-del">حذف</button></td>
    </tr><tr v-if="!p.ips.length"><td colspan="5" class="ip-empty">لا توجد عناوين</td></tr></tbody>
  </table>
</div>
</template>
<style scoped>
.ip{padding:24px;direction:rtl}.ip-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px}
.ip-h{font-size:22px;font-weight:800;color:#1e293b}.ip-add{padding:10px 20px;background:#0f172a;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.ip-curr{font-size:13px;color:#64748b;margin-bottom:16px}.ip-curr code{background:#f1f5f9;padding:2px 8px;border-radius:6px;color:#2563eb}
.ip-form{display:flex;gap:10px;background:#fff;border-radius:14px;padding:16px;border:1px solid #f1f5f9;margin-bottom:16px}
.ip-inp{padding:10px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;outline:none;flex:1}
.ip-sv{padding:10px 18px;background:#10b981;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.ip-tbl{width:100%;background:#fff;border-radius:16px;border-collapse:collapse}
.ip-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:12px 16px;border-bottom:1px solid #f1f5f9}
.ip-tbl td{font-size:13px;color:#334155;padding:12px 16px;border-bottom:1px solid #f8fafc}.ip-addr{font-family:monospace;font-weight:700;color:#0f172a}.ip-date{color:#94a3b8;font-size:12px}
.ip-del{padding:4px 12px;background:#fef2f2;color:#dc2626;border:1px solid #fecaca;border-radius:6px;font-size:11px;font-weight:600;cursor:pointer}
.ip-empty{text-align:center;color:#cbd5e1;font-style:italic}
</style>
