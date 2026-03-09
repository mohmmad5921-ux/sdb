<script setup>
import { Head, useForm, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { reactive, computed } from 'vue';
const props = defineProps({ fees: Array, revenue: Array, totalRevenue: Number });
const flash = computed(() => usePage().props.flash || {});
const formData = reactive({});
(props.fees || []).forEach(f => { formData[f.id] = { fixed_fee: f.fixed_fee, percentage_fee: f.percentage_fee, min_fee: f.min_fee, max_fee: f.max_fee, is_active: !!f.is_active }; });
const save = () => { const form = useForm({ fees: formData }); form.post(route('admin.fees.update'), { preserveScroll: true }); };
const typeIcons = { transfer_internal: '🔄', transfer_external: '📤', exchange: '💱', withdrawal: '🏧', card_payment: '💳', monthly: '📅' };
</script>
<template>
<Head title="إدارة الرسوم" />
<AdminLayout title="💰 إدارة الرسوم" subtitle="تحديد رسوم المعاملات والاشتراكات">
  <div v-if="flash.success" class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-3 text-emerald-700 text-sm font-semibold mb-4">✓ {{ flash.success }}</div>
  <div class="fee-revenue mb-4"><div class="fee-rev-card"><span class="fee-rev-label">💰 إيرادات الرسوم (30 يوم)</span><span class="fee-rev-val">€{{ Number(totalRevenue).toLocaleString() }}</span></div></div>
  <div class="fee-card">
    <table class="fee-table">
      <thead><tr><th>الرسم</th><th>رسم ثابت (€)</th><th>نسبة (%)</th><th>أقل رسم (€)</th><th>أقصى رسم (€)</th><th>الحالة</th></tr></thead>
      <tbody>
        <tr v-for="f in fees" :key="f.id">
          <td class="font-semibold">{{ typeIcons[f.type] }} {{ f.name }}</td>
          <td><input v-model.number="formData[f.id].fixed_fee" type="number" step="0.01" class="fee-input" /></td>
          <td><input v-model.number="formData[f.id].percentage_fee" type="number" step="0.001" class="fee-input" /></td>
          <td><input v-model.number="formData[f.id].min_fee" type="number" step="0.01" class="fee-input" /></td>
          <td><input v-model.number="formData[f.id].max_fee" type="number" step="0.01" class="fee-input" /></td>
          <td><button @click="formData[f.id].is_active = !formData[f.id].is_active" :class="['fee-toggle', formData[f.id].is_active ? 'fee-on' : '']"><span class="fee-dot"></span></button></td>
        </tr>
      </tbody>
    </table>
  </div>
  <div class="flex justify-center mt-4"><button @click="save" class="fee-save">💾 حفظ الرسوم</button></div>
</AdminLayout>
</template>
<style>
@import '../../../css/admin.css';
.fee-revenue{display:flex;gap:12px}.fee-rev-card{background:linear-gradient(135deg,#ecfdf5,#f0fdf4);border:1px solid #a7f3d0;border-radius:14px;padding:20px 28px;flex:1;display:flex;justify-content:space-between;align-items:center}
.fee-rev-label{font-size:14px;font-weight:600;color:#059669}.fee-rev-val{font-size:28px;font-weight:800;color:#10b981}
.fee-card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;overflow:hidden}
.fee-table{width:100%;border-collapse:collapse}.fee-table th{background:#f8fafc;padding:12px 14px;font-size:12px;font-weight:700;color:#334155;border-bottom:1px solid #e2e8f0;text-align:right}
.fee-table td{padding:12px 14px;border-bottom:1px solid #f1f5f9;font-size:13px;color:#334155}
.fee-input{width:100px;padding:6px 10px;border:1px solid #e2e8f0;border-radius:8px;font-size:13px;text-align:center;outline:none}.fee-input:focus{border-color:#10b981}
.fee-toggle{width:40px;height:22px;border-radius:11px;background:#e2e8f0;border:none;cursor:pointer;position:relative;transition:all .2s}
.fee-on{background:#10b981}.fee-dot{position:absolute;top:2px;right:2px;width:18px;height:18px;border-radius:50%;background:#fff;transition:transform .2s}
.fee-on .fee-dot{transform:translateX(-18px)}
.fee-save{padding:12px 36px;border-radius:14px;background:linear-gradient(135deg,#10b981,#059669);color:#fff;border:none;font-size:15px;font-weight:700;cursor:pointer;box-shadow:0 4px 14px rgba(16,185,129,.3)}.fee-save:hover{transform:translateY(-2px)}
</style>
