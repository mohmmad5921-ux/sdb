<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ alerts: Array, stats: Object });
const mark = id => router.post(route('admin.alerts.read', id));
const resolve = id => router.post(route('admin.alerts.resolve', id));
const sevColor = s => ({low:'#10b981',medium:'#f59e0b',high:'#f97316',critical:'#ef4444'}[s]||'#64748b');
const sevLabel = s => ({low:'منخفض',medium:'متوسط',high:'عالي',critical:'حرج'}[s]||s);
</script>
<template>
<Head title="التنبيهات الذكية" />
<div class="al">
  <h1 class="al-h">🚨 التنبيهات الذكية</h1>
  <div class="al-stats">
    <div class="al-s">📬 الكل <strong>{{ p.stats.total }}</strong></div>
    <div class="al-s al-s-warn">⚠️ غير مقروء <strong>{{ p.stats.unread }}</strong></div>
    <div class="al-s al-s-crit">🔴 حرج <strong>{{ p.stats.critical }}</strong></div>
    <div class="al-s">📅 اليوم <strong>{{ p.stats.today }}</strong></div>
  </div>
  <div class="al-list">
    <div v-for="a in p.alerts" :key="a.id" class="al-item" :class="{'al-unread':!a.read}">
      <div class="al-sev" :style="{background:sevColor(a.severity)}">{{ sevLabel(a.severity) }}</div>
      <div class="al-body"><div class="al-title">{{ a.title }}</div><div class="al-desc">{{ a.description }}</div><div class="al-time">{{ new Date(a.created_at).toLocaleString('ar') }}</div></div>
      <div class="al-acts">
        <button v-if="!a.read" @click="mark(a.id)" class="al-btn">✓ قراءة</button>
        <button v-if="!a.resolved_at" @click="resolve(a.id)" class="al-btn al-btn-g">✔ حل</button>
        <span v-if="a.resolved_at" class="al-done">✅ تم الحل</span>
      </div>
    </div>
    <div v-if="!p.alerts.length" class="al-empty">لا توجد تنبيهات</div>
  </div>
</div>
</template>
<style scoped>
.al{padding:24px;direction:rtl}.al-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:20px}
.al-stats{display:flex;gap:12px;margin-bottom:20px}.al-s{padding:10px 18px;background:#fff;border-radius:10px;border:1px solid #f1f5f9;font-size:13px;color:#64748b}.al-s strong{color:#0f172a;margin-right:4px}
.al-s-warn{border-color:#fde68a;background:#fffbeb}.al-s-crit{border-color:#fecaca;background:#fef2f2}
.al-list{display:flex;flex-direction:column;gap:10px}
.al-item{display:flex;align-items:center;gap:14px;background:#fff;border-radius:14px;padding:16px 20px;border:1px solid #f1f5f9}.al-unread{border-color:#bfdbfe;background:#eff6ff}
.al-sev{font-size:10px;font-weight:700;color:#fff;padding:4px 10px;border-radius:6px;white-space:nowrap}
.al-body{flex:1}.al-title{font-size:14px;font-weight:700;color:#0f172a;margin-bottom:2px}.al-desc{font-size:12px;color:#64748b}.al-time{font-size:11px;color:#94a3b8;margin-top:4px}
.al-acts{display:flex;gap:6px;flex-shrink:0}.al-btn{padding:6px 12px;border:1px solid #e2e8f0;border-radius:8px;font-size:11px;font-weight:600;cursor:pointer;background:#fff}.al-btn-g{background:#ecfdf5;color:#059669;border-color:#a7f3d0}
.al-done{font-size:11px;color:#10b981;font-weight:600}
.al-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:40px}
</style>
