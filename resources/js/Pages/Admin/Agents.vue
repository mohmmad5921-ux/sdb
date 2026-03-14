<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ agents: Array, governorates: Array, districts: Array, stats: Object, remittanceCounts: Object });

const search = ref('');
const govFilter = ref('all');
const statusFilter = ref('all');
const showAdd = ref(false);
const editAgent = ref(null);

const filtered = computed(() => {
  let list = p.agents || [];
  if (govFilter.value !== 'all') list = list.filter(a => a.governorate_id == govFilter.value);
  if (statusFilter.value !== 'all') list = list.filter(a => statusFilter.value === 'active' ? a.is_active : !a.is_active);
  if (search.value) {
    const q = search.value.toLowerCase();
    list = list.filter(a => a.name_ar?.toLowerCase().includes(q) || a.name_en?.toLowerCase().includes(q) || a.phone?.includes(q) || a.governorate_ar?.includes(q) || a.district_ar?.includes(q));
  }
  return list;
});

const govDistricts = computed(() => {
  if (!newAgent.value.governorate_id) return [];
  return (p.districts || []).filter(d => d.governorate_id == newAgent.value.governorate_id);
});

const editGovDistricts = computed(() => {
  if (!editAgent.value?.governorate_id) return [];
  return (p.districts || []).filter(d => d.governorate_id == editAgent.value.governorate_id);
});

const newAgent = ref({ governorate_id: '', district_id: '', name_ar: '', name_en: '', phone: '', address_ar: '', address_en: '', commission_rate: 0 });

const createAgent = () => {
  router.post(route('admin.agents.store'), newAgent.value, {
    onSuccess: () => { showAdd.value = false; newAgent.value = { governorate_id: '', district_id: '', name_ar: '', name_en: '', phone: '', address_ar: '', address_en: '', commission_rate: 0 }; }
  });
};

const toggleAgent = (id) => router.post(route('admin.agents.toggle', id));
const deleteAgent = (id) => { if (confirm('هل أنت متأكد من حذف هذا الوكيل؟')) router.delete(route('admin.agents.delete', id)); };

const openEdit = (a) => { editAgent.value = { ...a }; };
const saveEdit = () => {
  router.patch(route('admin.agents.update', editAgent.value.id), editAgent.value, {
    onSuccess: () => { editAgent.value = null; }
  });
};
</script>
<template>
<Head title="الوكلاء — الأدمن" />
<div class="ag">
  <div class="ag-header">
    <h1 class="ag-h">🏪 إدارة الوكلاء</h1>
    <button class="ag-add-btn" @click="showAdd = !showAdd">{{ showAdd ? '✕ إغلاق' : '+ إضافة وكيل' }}</button>
  </div>

  <!-- KPIs -->
  <div class="ag-kpis">
    <div class="ag-kpi"><div class="ag-kpi-ic" style="background:#eff6ff">🏪</div><div><div class="ag-kpi-v">{{ p.stats?.total }}</div><div class="ag-kpi-l">إجمالي الوكلاء</div></div></div>
    <div class="ag-kpi"><div class="ag-kpi-ic" style="background:#ecfdf5">✅</div><div><div class="ag-kpi-v">{{ p.stats?.active }}</div><div class="ag-kpi-l">نشط</div></div></div>
    <div class="ag-kpi"><div class="ag-kpi-ic" style="background:#fef2f2">⛔</div><div><div class="ag-kpi-v">{{ p.stats?.inactive }}</div><div class="ag-kpi-l">معطّل</div></div></div>
    <div class="ag-kpi"><div class="ag-kpi-ic" style="background:#fef3c7">🗺️</div><div><div class="ag-kpi-v">{{ p.stats?.governorates }}</div><div class="ag-kpi-l">محافظة</div></div></div>
  </div>

  <!-- Add Form -->
  <div v-if="showAdd" class="ag-form">
    <h3 class="ag-form-h">إضافة وكيل جديد</h3>
    <div class="ag-form-grid">
      <select v-model="newAgent.governorate_id" class="ag-input"><option value="">اختر المحافظة</option><option v-for="g in p.governorates" :key="g.id" :value="g.id">{{ g.name_ar }}</option></select>
      <select v-model="newAgent.district_id" class="ag-input"><option value="">اختر المنطقة</option><option v-for="d in govDistricts" :key="d.id" :value="d.id">{{ d.name_ar }}</option></select>
      <input v-model="newAgent.name_ar" placeholder="اسم الوكيل (عربي)" class="ag-input" />
      <input v-model="newAgent.name_en" placeholder="Agent Name (English)" class="ag-input" />
      <input v-model="newAgent.phone" placeholder="رقم الهاتف" class="ag-input" />
      <input v-model="newAgent.address_ar" placeholder="العنوان (عربي)" class="ag-input" />
      <input v-model="newAgent.address_en" placeholder="Address (English)" class="ag-input" />
      <input v-model.number="newAgent.commission_rate" type="number" step="0.1" placeholder="نسبة العمولة %" class="ag-input" />
    </div>
    <button class="ag-save-btn" @click="createAgent">💾 حفظ الوكيل</button>
  </div>

  <!-- Filters -->
  <div class="ag-filters">
    <input v-model="search" placeholder="🔍 بحث بالاسم أو الهاتف أو المحافظة..." class="ag-search" />
    <select v-model="govFilter" class="ag-select"><option value="all">كل المحافظات</option><option v-for="g in p.governorates" :key="g.id" :value="g.id">{{ g.name_ar }}</option></select>
    <select v-model="statusFilter" class="ag-select"><option value="all">الكل</option><option value="active">نشط</option><option value="inactive">معطّل</option></select>
  </div>

  <!-- Table -->
  <div class="ag-card">
    <table class="ag-tbl">
      <thead><tr><th>#</th><th>الاسم</th><th>الهاتف</th><th>المحافظة</th><th>المنطقة</th><th>العنوان</th><th>العمولة</th><th>الحالة</th><th>إجراءات</th></tr></thead>
      <tbody>
        <tr v-for="a in filtered" :key="a.id" :class="{'ag-inactive': !a.is_active}">
          <td>{{ a.id }}</td>
          <td class="ag-bold">{{ a.name_ar }}<br><span class="ag-sub">{{ a.name_en }}</span></td>
          <td>{{ a.phone || '—' }}</td>
          <td>{{ a.governorate_ar }}</td>
          <td>{{ a.district_ar }}</td>
          <td class="ag-addr">{{ a.address_ar || '—' }}</td>
          <td>{{ a.commission_rate }}%</td>
          <td><span class="ag-badge" :class="a.is_active ? 'ag-badge-active' : 'ag-badge-inactive'">{{ a.is_active ? 'نشط' : 'معطّل' }}</span></td>
          <td class="ag-actions">
            <button class="ag-btn ag-btn-edit" @click="openEdit(a)" title="تعديل">✏️</button>
            <button class="ag-btn" :class="a.is_active ? 'ag-btn-disable' : 'ag-btn-enable'" @click="toggleAgent(a.id)" :title="a.is_active ? 'تعطيل' : 'تفعيل'">{{ a.is_active ? '⛔' : '✅' }}</button>
            <button class="ag-btn ag-btn-delete" @click="deleteAgent(a.id)" title="حذف">🗑️</button>
          </td>
        </tr>
        <tr v-if="!filtered.length"><td colspan="9" class="ag-empty">لا يوجد وكلاء</td></tr>
      </tbody>
    </table>
  </div>

  <!-- Edit Modal -->
  <div v-if="editAgent" class="ag-modal-overlay" @click.self="editAgent = null">
    <div class="ag-modal">
      <div class="ag-modal-h"><h3>✏️ تعديل الوكيل</h3><button @click="editAgent = null" class="ag-modal-close">✕</button></div>
      <div class="ag-form-grid">
        <input v-model="editAgent.name_ar" placeholder="الاسم (عربي)" class="ag-input" />
        <input v-model="editAgent.name_en" placeholder="Name (English)" class="ag-input" />
        <input v-model="editAgent.phone" placeholder="الهاتف" class="ag-input" />
        <input v-model="editAgent.address_ar" placeholder="العنوان (عربي)" class="ag-input" />
        <input v-model="editAgent.address_en" placeholder="Address (English)" class="ag-input" />
        <input v-model.number="editAgent.commission_rate" type="number" step="0.1" placeholder="العمولة %" class="ag-input" />
      </div>
      <button class="ag-save-btn" @click="saveEdit">💾 حفظ التعديلات</button>
    </div>
  </div>
</div>
</template>
<style scoped>
.ag{direction:rtl;max-width:1400px;margin:0 auto}
.ag-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px}
.ag-h{font-size:22px;font-weight:900;color:#0f172a}
.ag-add-btn{padding:8px 20px;border-radius:10px;font-size:13px;font-weight:700;border:none;background:#10b981;color:#fff;cursor:pointer;transition:all .2s}
.ag-add-btn:hover{background:#059669}
.ag-kpis{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:16px}
.ag-kpi{display:flex;align-items:center;gap:12px;background:#fff;border-radius:14px;padding:16px;border:1px solid #f1f5f9}
.ag-kpi-ic{width:42px;height:42px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
.ag-kpi-v{font-size:22px;font-weight:900;color:#0f172a}.ag-kpi-l{font-size:11px;color:#94a3b8;font-weight:600}
.ag-form{background:#fff;border:1px solid #e2e8f0;border-radius:16px;padding:20px;margin-bottom:16px}
.ag-form-h{font-size:16px;font-weight:800;color:#0f172a;margin-bottom:14px}
.ag-form-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px;margin-bottom:14px}
.ag-input{padding:10px 14px;border:1px solid #e2e8f0;border-radius:10px;font-size:13px;outline:none;transition:border .2s;direction:rtl}
.ag-input:focus{border-color:#10b981;box-shadow:0 0 0 2px rgba(16,185,129,0.1)}
.ag-save-btn{padding:10px 24px;border-radius:10px;font-size:13px;font-weight:700;border:none;background:#10b981;color:#fff;cursor:pointer}
.ag-save-btn:hover{background:#059669}
.ag-filters{display:flex;gap:10px;margin-bottom:14px}
.ag-search{flex:1;padding:10px 14px;border:1px solid #e2e8f0;border-radius:10px;font-size:13px;outline:none;direction:rtl}
.ag-search:focus{border-color:#10b981}
.ag-select{padding:8px 14px;border:1px solid #e2e8f0;border-radius:10px;font-size:12px;outline:none;direction:rtl;min-width:140px}
.ag-card{background:#fff;border:1px solid #f1f5f9;border-radius:16px;padding:16px;overflow-x:auto}
.ag-tbl{width:100%;border-collapse:collapse;min-width:1000px}
.ag-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:10px;border-bottom:2px solid #f1f5f9}
.ag-tbl td{font-size:13px;color:#334155;padding:10px;border-bottom:1px solid #f8fafc}
.ag-bold{font-weight:700;color:#0f172a}
.ag-sub{font-size:11px;color:#94a3b8}
.ag-addr{font-size:11px;max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ag-inactive{opacity:0.5}
.ag-badge{font-size:10px;font-weight:700;padding:3px 10px;border-radius:8px}
.ag-badge-active{background:#ecfdf5;color:#059669}
.ag-badge-inactive{background:#fef2f2;color:#dc2626}
.ag-actions{display:flex;gap:4px}
.ag-btn{width:30px;height:30px;border-radius:8px;border:1px solid #e2e8f0;background:#fff;font-size:13px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .15s}
.ag-btn:hover{transform:scale(1.1)}
.ag-btn-edit:hover{background:#eff6ff;border-color:#3b82f6}
.ag-btn-disable:hover{background:#fef2f2;border-color:#ef4444}
.ag-btn-enable:hover{background:#ecfdf5;border-color:#10b981}
.ag-btn-delete:hover{background:#fef2f2;border-color:#ef4444}
.ag-empty{text-align:center;color:#cbd5e1;padding:30px}
.ag-modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,0.4);display:flex;align-items:center;justify-content:center;z-index:999}
.ag-modal{background:#fff;border-radius:20px;padding:24px;width:500px;max-width:90%;box-shadow:0 20px 60px rgba(0,0,0,0.2);animation:modalIn .25s ease}
@keyframes modalIn{from{opacity:0;transform:scale(0.95) translateY(10px)}to{opacity:1;transform:scale(1) translateY(0)}}
.ag-modal-h{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px}
.ag-modal-h h3{font-size:18px;font-weight:800;color:#0f172a}
.ag-modal-close{background:none;border:none;font-size:18px;cursor:pointer;color:#94a3b8}
@media(max-width:768px){.ag-kpis{grid-template-columns:repeat(2,1fr)}.ag-form-grid{grid-template-columns:1fr}.ag-filters{flex-direction:column}}
</style>
