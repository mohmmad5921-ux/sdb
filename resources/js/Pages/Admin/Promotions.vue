<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ promotions: Array });
const show = ref(false);
const form = useForm({name:'',code:'',type:'percentage',value:0,applies_to:'all',max_uses:null,starts_at:'',expires_at:''});
const save = () => form.post(route('admin.promotions.store'), {onSuccess:()=>{show.value=false;form.reset()}});
const toggle = id => router.post(route('admin.promotions.toggle', id));
const del = id => { if(confirm('حذف؟')) router.delete(route('admin.promotions.destroy', id)); };
</script>
<template>
<Head title="العروض والكوبونات" />
<div class="pm">
  <div class="pm-top"><h1 class="pm-h">🏷️ العروض والكوبونات</h1><button @click="show=!show" class="pm-add">+ عرض جديد</button></div>

  <div v-if="show" class="pm-form">
    <div class="pm-row">
      <div class="pm-f"><label>الاسم</label><input v-model="form.name" class="pm-inp" placeholder="خصم ترحيبي" /></div>
      <div class="pm-f"><label>الكود</label><input v-model="form.code" class="pm-inp" placeholder="WELCOME50" /></div>
      <div class="pm-f"><label>النوع</label><select v-model="form.type" class="pm-inp"><option value="percentage">نسبة %</option><option value="fixed">مبلغ ثابت</option><option value="free_transfer">تحويل مجاني</option></select></div>
      <div class="pm-f"><label>القيمة</label><input v-model="form.value" type="number" class="pm-inp" /></div>
    </div>
    <div class="pm-row">
      <div class="pm-f"><label>ينطبق على</label><select v-model="form.applies_to" class="pm-inp"><option value="all">الكل</option><option value="transfer">التحويلات</option><option value="exchange">الصرف</option><option value="card">البطاقات</option></select></div>
      <div class="pm-f"><label>أقصى استخدام</label><input v-model="form.max_uses" type="number" class="pm-inp" placeholder="غير محدود" /></div>
      <div class="pm-f"><label>يبدأ</label><input v-model="form.starts_at" type="date" class="pm-inp" /></div>
      <div class="pm-f"><label>ينتهي</label><input v-model="form.expires_at" type="date" class="pm-inp" /></div>
    </div>
    <button @click="save" class="pm-save" :disabled="form.processing">حفظ العرض</button>
  </div>

  <table class="pm-tbl">
    <thead><tr><th>الاسم</th><th>الكود</th><th>النوع</th><th>القيمة</th><th>الاستخدام</th><th>الحالة</th><th>إجراء</th></tr></thead>
    <tbody>
      <tr v-for="pr in p.promotions" :key="pr.id">
        <td class="pm-name">{{ pr.name }}</td>
        <td><code class="pm-code">{{ pr.code }}</code></td>
        <td>{{ {percentage:'نسبة',fixed:'ثابت',free_transfer:'مجاني'}[pr.type] }}</td>
        <td>{{ pr.type==='percentage'?pr.value+'%':'€'+pr.value }}</td>
        <td>{{ pr.used_count }}<span v-if="pr.max_uses">/{{ pr.max_uses }}</span></td>
        <td><span class="pm-badge" :class="pr.active?'pm-on':'pm-off'">{{ pr.active?'فعّال':'معطّل' }}</span></td>
        <td><button @click="toggle(pr.id)" class="pm-btn">{{ pr.active?'تعطيل':'تفعيل' }}</button><button @click="del(pr.id)" class="pm-btn pm-del">حذف</button></td>
      </tr>
      <tr v-if="!p.promotions.length"><td colspan="7" class="pm-empty">لا توجد عروض</td></tr>
    </tbody>
  </table>
</div>
</template>
<style scoped>
.pm{padding:24px;direction:rtl}.pm-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}
.pm-h{font-size:22px;font-weight:800;color:#1e293b}
.pm-add{padding:10px 20px;background:#0f172a;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.pm-form{background:#fff;border-radius:16px;padding:24px;border:1px solid #f1f5f9;margin-bottom:20px}
.pm-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:12px}
.pm-f{display:flex;flex-direction:column;gap:4px}.pm-f label{font-size:12px;font-weight:600;color:#64748b}
.pm-inp{padding:10px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;outline:none}.pm-inp:focus{border-color:#2563eb}
.pm-save{padding:10px 24px;background:#10b981;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.pm-tbl{width:100%;background:#fff;border-radius:16px;border-collapse:collapse;overflow:hidden}
.pm-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:12px 16px;border-bottom:1px solid #f1f5f9}
.pm-tbl td{font-size:13px;color:#334155;padding:12px 16px;border-bottom:1px solid #f8fafc}
.pm-name{font-weight:700}.pm-code{background:#f1f5f9;padding:3px 8px;border-radius:6px;font-size:12px;color:#2563eb}
.pm-badge{font-size:11px;font-weight:700;padding:4px 10px;border-radius:6px}.pm-on{background:#ecfdf5;color:#059669}.pm-off{background:#fef2f2;color:#dc2626}
.pm-btn{font-size:12px;padding:4px 10px;border:1px solid #e2e8f0;border-radius:6px;background:#fff;cursor:pointer;margin-left:4px}.pm-del{color:#dc2626;border-color:#fecaca}
.pm-empty{text-align:center;color:#cbd5e1;font-style:italic}
</style>
