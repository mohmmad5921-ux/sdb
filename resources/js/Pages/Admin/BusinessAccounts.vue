<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router, Link } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ businesses: Object, filters: Object });
const f = ref({...p.filters});
const apply = () => router.get(route('admin.businesses.index'), f.value, {preserveState:true});
const reset = () => { f.value={search:'',status:'',size:'',category:''}; apply(); };
const fc = n => 'ل.س'+Number(n||0).toLocaleString('en',{minimumFractionDigits:2});
const stColor = s => ({active:'#10b981',pending:'#f59e0b',suspended:'#ef4444',rejected:'#94a3b8'}[s]||'#64748b');
const stLabel = s => ({active:'نشط',pending:'معلّق',suspended:'موقوف',rejected:'مرفوض'}[s]||s);
const szLabel = s => ({small:'صغيرة',medium:'متوسطة',large:'كبيرة',enterprise:'عملاقة'}[s]||s);
</script>
<template>
<Head title="حسابات الشركات" />
<div class="ba">
  <div class="ba-top"><h1 class="ba-h">🏢 إدارة حسابات الشركات</h1><Link :href="route('admin.businesses.dashboard')" class="ba-link">📊 لوحة المراقبة</Link></div>

  <!-- Filters -->
  <div class="ba-filters">
    <input v-model="f.search" placeholder="🔍 بحث بالاسم أو السجل التجاري أو البريد" class="ba-inp" style="flex:2"/>
    <select v-model="f.status" class="ba-inp">
      <option value="">كل الحالات</option>
      <option value="active">نشط</option>
      <option value="pending">معلّق</option>
      <option value="suspended">موقوف</option>
      <option value="rejected">مرفوض</option>
    </select>
    <select v-model="f.size" class="ba-inp">
      <option value="">كل الأحجام</option>
      <option value="small">صغيرة</option>
      <option value="medium">متوسطة</option>
      <option value="large">كبيرة</option>
      <option value="enterprise">عملاقة</option>
    </select>
    <select v-model="f.category" class="ba-inp">
      <option value="">كل التصنيفات</option>
      <option value="تجارة إلكترونية">تجارة إلكترونية</option>
      <option value="خدمات">خدمات</option>
      <option value="مطاعم وتموين">مطاعم وتموين</option>
      <option value="بيع بالتجزئة">بيع بالتجزئة</option>
      <option value="تقنية معلومات">تقنية معلومات</option>
      <option value="بناء وعقارات">بناء وعقارات</option>
      <option value="نقل وشحن">نقل وشحن</option>
      <option value="أخرى">أخرى</option>
    </select>
    <button @click="apply" class="ba-btn-f">بحث</button>
    <button @click="reset" class="ba-btn-r">مسح</button>
  </div>

  <!-- Table -->
  <div class="ba-tbl-wrap">
  <table class="ba-tbl"><thead><tr><th>الشركة</th><th>المالك</th><th>النشاط</th><th>الحجم</th><th>الرصيد</th><th>الحالة</th><th>رقم الحساب</th><th>التاريخ</th></tr></thead>
    <tbody><tr v-for="b in p.businesses.data" :key="b.id">
      <td class="ba-bold"><Link :href="route('admin.businesses.show', b.id)">{{ b.business_name }}</Link></td>
      <td>{{ b.owner_full_name||b.owner_name }}</td>
      <td><span class="ba-tag">{{ b.category }}</span></td>
      <td>{{ szLabel(b.size) }}</td>
      <td class="ba-bold">{{ fc(b.balance||0) }}</td>
      <td><span class="ba-st" :style="{color:stColor(b.status)}">{{ stLabel(b.status) }}</span></td>
      <td class="ba-mono">{{ b.account_number||'—' }}</td>
      <td class="ba-date">{{ new Date(b.created_at).toLocaleDateString('ar') }}</td>
    </tr><tr v-if="!p.businesses.data?.length"><td colspan="8" class="ba-empty">لا توجد شركات</td></tr></tbody>
  </table>
  </div>

  <!-- Pagination -->
  <div class="ba-pag" v-if="p.businesses.last_page>1">
    <Link v-for="link in p.businesses.links" :key="link.label" :href="link.url||''" class="ba-pag-l" :class="{active:link.active}" v-html="link.label" :preserveState="true"/>
  </div>
</div>
</template>
<style scoped>
.ba{padding:24px;direction:rtl}.ba-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px}
.ba-h{font-size:22px;font-weight:800;color:#1e293b}.ba-link{font-size:12px;color:#2563eb;text-decoration:none;font-weight:600;padding:8px 16px;background:#eff6ff;border-radius:8px}
.ba-filters{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.ba-inp{padding:9px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:12px;outline:none;flex:1;min-width:100px}
.ba-btn-f{padding:9px 16px;background:#2563eb;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:12px}
.ba-btn-r{padding:9px 16px;background:#f1f5f9;color:#64748b;border:none;border-radius:10px;cursor:pointer;font-size:12px}
.ba-tbl-wrap{overflow-x:auto}.ba-tbl{width:100%;background:#fff;border-radius:16px;border-collapse:collapse;min-width:900px}
.ba-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:12px 12px;border-bottom:1px solid #f1f5f9}
.ba-tbl td{font-size:12px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}
.ba-bold{font-weight:700}.ba-bold a{color:#2563eb;text-decoration:none}
.ba-tag{font-size:10px;background:#f1f5f9;padding:2px 8px;border-radius:5px;color:#64748b}
.ba-st{font-size:11px;font-weight:700}.ba-mono{font-family:monospace;font-size:10px;color:#64748b}
.ba-date{font-size:10px;color:#94a3b8}
.ba-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:30px}
.ba-pag{display:flex;gap:4px;margin-top:16px;justify-content:center}.ba-pag-l{padding:6px 12px;background:#fff;border:1px solid #e2e8f0;border-radius:8px;font-size:12px;color:#64748b;text-decoration:none}.ba-pag-l.active{background:#2563eb;color:#fff;border-color:#2563eb}
</style>
