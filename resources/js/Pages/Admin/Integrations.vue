<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ integrations: Array, stats: Object });
const stColor = s => ({active:'#10b981',inactive:'#94a3b8',error:'#ef4444',maintenance:'#f59e0b'}[s]||'#64748b');
const stLabel = s => ({active:'نشط',inactive:'غير نشط',error:'خطأ',maintenance:'صيانة'}[s]||s);
const toggle = (id, current) => { const next = current==='active'?'inactive':'active'; router.patch(route('admin.integrations.update', id), {status:next}); };
</script>
<template>
<Head title="التكاملات الخارجية" />
<div class="ig">
  <h1 class="ig-h">🔌 مركز التكاملات الخارجية</h1>
  <div class="ig-stats">
    <div class="ig-s"><span class="ig-ic">✅</span><div><div class="ig-v" style="color:#10b981">{{ p.stats.active }}</div><div class="ig-l">نشط</div></div></div>
    <div class="ig-s"><span class="ig-ic">⏸️</span><div><div class="ig-v" style="color:#94a3b8">{{ p.stats.inactive }}</div><div class="ig-l">غير نشط</div></div></div>
    <div class="ig-s"><span class="ig-ic">❌</span><div><div class="ig-v" style="color:#ef4444">{{ p.stats.error }}</div><div class="ig-l">خطأ</div></div></div>
  </div>
  <div class="ig-grid">
    <div v-for="i in p.integrations" :key="i.id" class="ig-card" :class="'ig-st-'+i.status">
      <div class="ig-card-h"><span class="ig-type">{{ ({payment:'💳',kyc:'🪪',aml:'🏛️',bank:'🏦',cards:'💳',sms:'📱',email:'📧',analytics:'📊'})[i.type]||'🔌' }}</span><strong>{{ i.name }}</strong></div>
      <div class="ig-card-info"><span class="ig-tag">{{ i.type }}</span><span class="ig-prov">{{ i.provider }}</span></div>
      <div class="ig-card-status"><span class="ig-dot" :style="{background:stColor(i.status)}"></span><span :style="{color:stColor(i.status),fontWeight:700}">{{ stLabel(i.status) }}</span></div>
      <div class="ig-card-meta" v-if="i.last_checked_at">آخر فحص: {{ new Date(i.last_checked_at).toLocaleString('ar') }}</div>
      <div class="ig-card-err" v-if="i.last_error">{{ i.last_error }}</div>
      <button @click="toggle(i.id, i.status)" class="ig-toggle">{{ i.status==='active'?'إيقاف':'تفعيل' }}</button>
    </div>
  </div>
</div>
</template>
<style scoped>
.ig{padding:24px;direction:rtl}.ig-h{font-size:22px;font-weight:900;color:#0f172a;margin-bottom:20px}
.ig-stats{display:flex;gap:12px;margin-bottom:20px}
.ig-s{display:flex;align-items:center;gap:10px;padding:14px 20px;background:#fff;border-radius:12px;border:1px solid #f1f5f9}
.ig-ic{font-size:22px}.ig-v{font-size:20px;font-weight:900}.ig-l{font-size:10px;color:#94a3b8}
.ig-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
.ig-card{background:#fff;border-radius:16px;padding:18px;border:2px solid #f1f5f9;transition:all .2s}.ig-card:hover{border-color:#e2e8f0;transform:translateY(-2px)}
.ig-st-active{border-color:#d1fae5}.ig-st-error{border-color:#fecaca}.ig-st-maintenance{border-color:#fef3c7}
.ig-card-h{display:flex;align-items:center;gap:8px;font-size:14px;margin-bottom:8px}.ig-type{font-size:24px}
.ig-card-info{display:flex;gap:6px;margin-bottom:6px}.ig-tag{font-size:9px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b;font-weight:600}.ig-prov{font-size:11px;color:#94a3b8}
.ig-card-status{display:flex;align-items:center;gap:4px;margin-bottom:4px}.ig-dot{width:8px;height:8px;border-radius:50%}
.ig-card-meta{font-size:10px;color:#94a3b8;margin-bottom:4px}.ig-card-err{font-size:10px;color:#ef4444;margin-bottom:6px}
.ig-toggle{padding:6px 14px;background:#f1f5f9;color:#64748b;border:none;border-radius:8px;font-size:11px;font-weight:600;cursor:pointer;width:100%}.ig-toggle:hover{background:#e2e8f0}
</style>
