<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ campaigns: Array });
const show = ref(false);
const form = useForm({name:'',subject:'',body:'',target_segment:'all',scheduled_at:''});
const save = () => form.post(route('admin.campaigns.store'), {onSuccess:()=>{show.value=false;form.reset()}});
const stLabel = s => ({draft:'مسودة',scheduled:'مجدول',sending:'يُرسل',sent:'تم الإرسال'}[s]||s);
</script>
<template>
<Head title="حملات البريد" />
<div class="cp"><div class="cp-top"><h1 class="cp-h">📧 حملات البريد الإلكتروني</h1><button @click="show=!show" class="cp-add">+ حملة جديدة</button></div>
  <div v-if="show" class="cp-form">
    <div class="cp-row"><input v-model="form.name" placeholder="اسم الحملة" class="cp-inp"/><input v-model="form.subject" placeholder="عنوان الإيميل" class="cp-inp"/>
      <select v-model="form.target_segment" class="cp-inp"><option value="all">كل العملاء</option><option value="vip">VIP</option><option value="new">جدد</option><option value="dormant">خاملين</option></select></div>
    <textarea v-model="form.body" placeholder="محتوى الرسالة..." class="cp-ta" rows="4"></textarea>
    <button @click="save" class="cp-sv" :disabled="form.processing">إنشاء الحملة</button>
  </div>
  <table class="cp-tbl"><thead><tr><th>الحملة</th><th>العنوان</th><th>الشريحة</th><th>المستلمين</th><th>الحالة</th><th>التاريخ</th></tr></thead>
    <tbody><tr v-for="c in p.campaigns" :key="c.id">
      <td class="cp-bold">{{ c.name }}</td><td>{{ c.subject }}</td>
      <td><span class="cp-seg">{{ c.target_segment }}</span></td><td>{{ c.recipients_count }}</td>
      <td><span class="cp-st" :class="'cp-'+c.status">{{ stLabel(c.status) }}</span></td>
      <td class="cp-date">{{ new Date(c.created_at).toLocaleDateString('ar') }}</td>
    </tr><tr v-if="!p.campaigns.length"><td colspan="6" class="cp-empty">لا توجد حملات</td></tr></tbody>
  </table>
</div>
</template>
<style scoped>
.cp{padding:24px;direction:rtl}.cp-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}
.cp-h{font-size:22px;font-weight:800;color:#1e293b}.cp-add{padding:10px 20px;background:#0f172a;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.cp-form{background:#fff;border-radius:14px;padding:20px;border:1px solid #f1f5f9;margin-bottom:20px}
.cp-row{display:flex;gap:10px;margin-bottom:10px}.cp-inp{padding:10px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;outline:none;flex:1}
.cp-ta{width:100%;padding:10px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;resize:vertical;outline:none;margin-bottom:10px;box-sizing:border-box}
.cp-sv{padding:10px 24px;background:#2563eb;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.cp-tbl{width:100%;background:#fff;border-radius:16px;border-collapse:collapse}
.cp-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:12px 16px;border-bottom:1px solid #f1f5f9}
.cp-tbl td{font-size:13px;color:#334155;padding:12px 16px;border-bottom:1px solid #f8fafc}.cp-bold{font-weight:700}
.cp-seg{font-size:10px;font-weight:700;background:#f1f5f9;padding:2px 8px;border-radius:5px;color:#64748b}
.cp-st{font-size:10px;font-weight:700;padding:2px 8px;border-radius:5px}.cp-draft{background:#f1f5f9;color:#64748b}.cp-scheduled{background:#fefce8;color:#ca8a04}.cp-sending{background:#eff6ff;color:#2563eb}.cp-sent{background:#ecfdf5;color:#059669}
.cp-date{color:#94a3b8;font-size:12px}.cp-empty{text-align:center;color:#cbd5e1;font-style:italic}
</style>
