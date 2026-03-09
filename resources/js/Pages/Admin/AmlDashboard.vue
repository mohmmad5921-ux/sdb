<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ reports: Array, stats: Object, largeTransfers: Array });
const f = n => Number(n||0).toLocaleString('en');
const fc = n => '€'+Number(n||0).toLocaleString('en',{minimumFractionDigits:2});
const review = (id, status) => router.patch(route('admin.aml.review', id), {status});
const rkColor = l => ({low:'#10b981',medium:'#f59e0b',high:'#f97316',critical:'#ef4444'}[l]||'#64748b');
const stLabel = s => ({pending:'معلّق',under_review:'قيد المراجعة',escalated:'مصعّد',cleared:'تم التصفية',reported:'مبلّغ'}[s]||s);
</script>
<template>
<Head title="مكافحة غسيل الأموال" />
<div class="am">
  <h1 class="am-h">🏛️ نظام مكافحة غسيل الأموال (AML)</h1>
  <div class="am-stats">
    <div class="am-s" v-for="s in [{l:'إجمالي التقارير',v:p.stats.total,ic:'📊'},{l:'معلّقة',v:p.stats.pending,ic:'⏳',c:'#f59e0b'},{l:'قيد المراجعة',v:p.stats.under_review,ic:'🔍',c:'#2563eb'},{l:'مصعّدة',v:p.stats.escalated,ic:'🔴',c:'#ef4444'},{l:'نظيفة',v:p.stats.cleared,ic:'✅',c:'#10b981'},{l:'مبلّغة',v:p.stats.reported,ic:'📤',c:'#8b5cf6'},{l:'تحويلات كبيرة اليوم',v:p.stats.large_transfers_today,ic:'💰'},{l:'مستخدمين عالي خطورة',v:p.stats.high_risk_users,ic:'⚠️',c:'#ef4444'}]" :key="s.l">
      <span class="am-ic">{{ s.ic }}</span><div><div class="am-v" :style="{color:s.c||'#0f172a'}">{{ f(s.v) }}</div><div class="am-l">{{ s.l }}</div></div>
    </div>
  </div>
  <!-- Reports Table -->
  <div class="am-card"><div class="am-ct">📋 تقارير AML</div>
    <table class="am-tbl"><thead><tr><th>المستخدم</th><th>النوع</th><th>المبلغ</th><th>المخاطر</th><th>الحالة</th><th>التاريخ</th><th>إجراء</th></tr></thead>
      <tbody><tr v-for="r in p.reports" :key="r.id">
        <td class="am-bold">{{ r.user_name }}</td><td><span class="am-tag">{{ r.type }}</span></td><td>{{ fc(r.amount) }}</td>
        <td><span :style="{color:rkColor(r.risk_level),fontWeight:700}">{{ r.risk_level }}</span></td>
        <td><span class="am-st">{{ stLabel(r.status) }}</span></td>
        <td class="am-date">{{ new Date(r.created_at).toLocaleString('ar') }}</td>
        <td class="am-acts">
          <button v-if="r.status==='pending'" @click="review(r.id,'under_review')" class="am-btn">مراجعة</button>
          <button v-if="r.status==='under_review'" @click="review(r.id,'cleared')" class="am-btn am-btn-g">تصفية</button>
          <button v-if="r.status==='under_review'" @click="review(r.id,'escalated')" class="am-btn am-btn-r">تصعيد</button>
          <button v-if="r.status==='escalated'" @click="review(r.id,'reported')" class="am-btn am-btn-p">تبليغ</button>
        </td>
      </tr><tr v-if="!p.reports?.length"><td colspan="7" class="am-empty">لا توجد تقارير</td></tr></tbody>
    </table>
  </div>
  <!-- Large Transfers -->
  <div class="am-card"><div class="am-ct">💰 التحويلات الكبيرة (أكثر من €5,000)</div>
    <table class="am-tbl"><thead><tr><th>المستخدم</th><th>المبلغ</th><th>النوع</th><th>الحالة</th><th>التاريخ</th></tr></thead>
      <tbody><tr v-for="t in p.largeTransfers" :key="t.id">
        <td class="am-bold">{{ t.user_name||'—' }}</td><td class="am-bold">{{ fc(t.amount) }}</td>
        <td><span class="am-tag">{{ t.type }}</span></td><td>{{ t.status }}</td>
        <td class="am-date">{{ new Date(t.created_at).toLocaleString('ar') }}</td>
      </tr></tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.am{padding:24px;direction:rtl}.am-h{font-size:22px;font-weight:900;color:#0f172a;margin-bottom:20px}
.am-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin-bottom:20px}
.am-s{display:flex;align-items:center;gap:10px;padding:14px;background:#fff;border-radius:12px;border:1px solid #f1f5f9}
.am-ic{font-size:22px}.am-v{font-size:18px;font-weight:900}.am-l{font-size:10px;color:#94a3b8}
.am-card{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9;margin-bottom:16px}.am-ct{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:12px}
.am-tbl{width:100%;border-collapse:collapse}.am-tbl th{font-size:10px;font-weight:700;color:#94a3b8;text-align:right;padding:10px 12px;border-bottom:1px solid #f1f5f9}
.am-tbl td{font-size:12px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}.am-bold{font-weight:700}.am-date{font-size:10px;color:#94a3b8}
.am-tag{font-size:9px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b;font-weight:600}.am-st{font-size:11px;font-weight:600}
.am-acts{display:flex;gap:3px}.am-btn{padding:4px 10px;background:#eff6ff;color:#2563eb;border:1px solid #bfdbfe;border-radius:6px;font-size:10px;font-weight:600;cursor:pointer}
.am-btn-g{background:#ecfdf5;color:#059669;border-color:#a7f3d0}.am-btn-r{background:#fef2f2;color:#dc2626;border-color:#fecaca}.am-btn-p{background:#f5f3ff;color:#7c3aed;border-color:#c4b5fd}
.am-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px}
</style>
