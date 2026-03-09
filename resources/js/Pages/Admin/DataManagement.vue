<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ dbStats: Object, scheduledReports: Array });
const f = n => Number(n||0).toLocaleString('en');
const show = ref(false);
const form = useForm({name:'',type:'transactions',frequency:'monthly',format:'pdf',email_to:''});
const save = () => form.post(route('admin.data.reports.store'),{onSuccess:()=>{show.value=false;form.reset()}});
const toggleR = id => router.post(route('admin.data.reports.toggle', id));
</script>
<template>
<Head title="إدارة البيانات" />
<div class="dm">
  <h1 class="dm-h">🗄️ إدارة البيانات والنظام</h1>
  <!-- DB Stats Grid -->
  <div class="dm-section-t">📊 إحصائيات قاعدة البيانات</div>
  <div class="dm-db-grid">
    <div v-for="(count, table) in p.dbStats" :key="table" class="dm-db">
      <div class="dm-db-v">{{ f(count) }}</div>
      <div class="dm-db-l">{{ ({users:'مستخدمين',accounts:'حسابات',transactions:'معاملات',cards:'بطاقات',kyc_documents:'وثائق KYC',support_tickets:'تذاكر دعم',audit_logs:'سجلات تدقيق',sessions:'جلسات'})[table]||table }}</div>
    </div>
  </div>
  <!-- Scheduled Reports -->
  <div class="dm-card">
    <div class="dm-card-top"><span class="dm-ct">📅 التقارير المجدولة</span><button @click="show=!show" class="dm-add">+ تقرير جديد</button></div>
    <div v-if="show" class="dm-form">
      <input v-model="form.name" placeholder="اسم التقرير" class="dm-inp"/>
      <select v-model="form.type" class="dm-inp"><option value="transactions">المعاملات</option><option value="users">المستخدمين</option><option value="cards">البطاقات</option><option value="fraud">الاحتيال</option><option value="aml">AML</option><option value="fees">الرسوم</option><option value="profit">الأرباح</option><option value="support">الدعم</option></select>
      <select v-model="form.frequency" class="dm-inp"><option value="daily">يومي</option><option value="weekly">أسبوعي</option><option value="monthly">شهري</option></select>
      <select v-model="form.format" class="dm-inp"><option value="pdf">PDF</option><option value="csv">CSV</option><option value="excel">Excel</option></select>
      <input v-model="form.email_to" placeholder="البريد (اختياري)" class="dm-inp"/>
      <button @click="save" class="dm-sv">حفظ</button>
    </div>
    <table class="dm-tbl"><thead><tr><th>الاسم</th><th>النوع</th><th>التكرار</th><th>الصيغة</th><th>البريد</th><th>آخر إنشاء</th><th>الحالة</th></tr></thead>
      <tbody><tr v-for="r in p.scheduledReports" :key="r.id">
        <td class="dm-bold">{{ r.name }}</td><td><span class="dm-tag">{{ r.type }}</span></td>
        <td>{{ ({daily:'يومي',weekly:'أسبوعي',monthly:'شهري'})[r.frequency] }}</td>
        <td>{{ r.format.toUpperCase() }}</td><td>{{ r.email_to||'—' }}</td>
        <td class="dm-date">{{ r.last_generated_at ? new Date(r.last_generated_at).toLocaleString('ar') : '—' }}</td>
        <td><button @click="toggleR(r.id)" :class="r.active?'dm-on':'dm-off'">{{ r.active?'نشط':'معطّل' }}</button></td>
      </tr><tr v-if="!p.scheduledReports?.length"><td colspan="7" class="dm-empty">لا توجد تقارير</td></tr></tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.dm{padding:24px;direction:rtl}.dm-h{font-size:22px;font-weight:900;color:#0f172a;margin-bottom:20px}
.dm-section-t{font-size:14px;font-weight:800;color:#475569;margin-bottom:10px}
.dm-db-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin-bottom:20px}
.dm-db{background:#fff;border-radius:14px;padding:18px;text-align:center;border:1px solid #f1f5f9}
.dm-db-v{font-size:24px;font-weight:900;color:#0f172a}.dm-db-l{font-size:11px;color:#94a3b8;margin-top:2px}
.dm-card{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9;margin-bottom:16px}
.dm-card-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px}
.dm-ct{font-size:14px;font-weight:800;color:#1e293b}
.dm-add{padding:8px 16px;background:#0f172a;color:#fff;border:none;border-radius:8px;font-weight:700;cursor:pointer;font-size:12px}
.dm-form{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.dm-inp{padding:8px 12px;border:1.5px solid #e2e8f0;border-radius:8px;font-size:12px;outline:none;flex:1;min-width:100px}
.dm-sv{padding:8px 16px;background:#2563eb;color:#fff;border:none;border-radius:8px;font-weight:700;cursor:pointer;font-size:12px}
.dm-tbl{width:100%;border-collapse:collapse}.dm-tbl th{font-size:10px;font-weight:700;color:#94a3b8;text-align:right;padding:10px 12px;border-bottom:1px solid #f1f5f9}
.dm-tbl td{font-size:12px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}.dm-bold{font-weight:700}.dm-date{font-size:10px;color:#94a3b8}
.dm-tag{font-size:9px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b;font-weight:600}
.dm-on{padding:3px 10px;background:#ecfdf5;color:#059669;border:1px solid #a7f3d0;border-radius:6px;font-size:10px;font-weight:600;cursor:pointer}
.dm-off{padding:3px 10px;background:#fef2f2;color:#dc2626;border:1px solid #fecaca;border-radius:6px;font-size:10px;font-weight:600;cursor:pointer}
.dm-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px}
</style>
