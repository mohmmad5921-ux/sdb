<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ limits: Array, grouped: Object });
const editLimits = ref(JSON.parse(JSON.stringify(p.limits)));
const form = useForm({limits:[]});
const save = () => { form.limits = editLimits.value; form.post(route('admin.limits.update')); };
const fmt = n => Number(n).toLocaleString('en');
const typeLabel = t => ({daily_transfer:'تحويل يومي',monthly_transfer:'تحويل شهري',daily_withdrawal:'سحب يومي',single_transaction:'عملية واحدة'}[t]||t);
const levelLabel = l => ({basic:'أساسي',verified:'موثّق',premium:'بريميوم'}[l]||l);
const levelColor = l => ({basic:'#f59e0b',verified:'#10b981',premium:'#8b5cf6'}[l]||'#64748b');
</script>
<template>
<Head title="إدارة الحدود" />
<div class="lm">
  <div class="lm-top"><h1 class="lm-h">💵 إدارة الحدود</h1><button @click="save" class="lm-sv" :disabled="form.processing">حفظ التعديلات</button></div>

  <div v-for="(items, level) in p.grouped" :key="level" class="lm-group">
    <div class="lm-lvl"><span class="lm-lvl-dot" :style="{background:levelColor(level)}"></span>{{ levelLabel(level) }}</div>
    <div class="lm-cards">
      <div v-for="(lim, i) in editLimits.filter(l=>l.kyc_level===level)" :key="lim.id" class="lm-card">
        <div class="lm-type">{{ typeLabel(lim.limit_type) }}</div>
        <div class="lm-inp-wrap">
          <span class="lm-cur">€</span>
          <input v-model.number="lim.amount" type="number" class="lm-inp" />
        </div>
      </div>
    </div>
  </div>
</div>
</template>
<style scoped>
.lm{padding:24px;direction:rtl}.lm-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:24px}
.lm-h{font-size:22px;font-weight:800;color:#1e293b}
.lm-sv{padding:10px 24px;background:#10b981;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.lm-group{margin-bottom:24px}
.lm-lvl{font-size:16px;font-weight:700;color:#1e293b;margin-bottom:12px;display:flex;align-items:center;gap:8px}
.lm-lvl-dot{width:10px;height:10px;border-radius:50%}
.lm-cards{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.lm-card{background:#fff;border-radius:14px;padding:20px;border:1px solid #f1f5f9}
.lm-type{font-size:13px;font-weight:600;color:#64748b;margin-bottom:10px}
.lm-inp-wrap{display:flex;align-items:center;gap:6px}
.lm-cur{font-size:16px;font-weight:700;color:#94a3b8}
.lm-inp{width:100%;padding:10px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:16px;font-weight:700;color:#0f172a;outline:none}.lm-inp:focus{border-color:#10b981}
</style>
