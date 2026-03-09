<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ stats: Object, hourly: Array, byCountry: Array, anomalies: Array });
const f = n => Number(n||0).toLocaleString('en');
const fc = n => '€'+Number(n||0).toLocaleString('en',{minimumFractionDigits:2});
const maxH = () => Math.max(...(p.hourly||[]).map(h=>h.count), 1);
</script>
<template>
<Head title="مراقبة المعاملات" />
<div class="tm">
  <h1 class="tm-h">📡 مراقبة المعاملات المتقدمة — لحظياً</h1>
  <div class="tm-stats">
    <div class="tm-s" v-for="s in [{l:'معاملات اليوم',v:f(p.stats.today_count),ic:'📊'},{l:'حجم اليوم',v:fc(p.stats.today_volume),ic:'💰'},{l:'معلّقة',v:f(p.stats.pending),ic:'⏳',c:'#f59e0b'},{l:'كبيرة (>€5K)',v:f(p.stats.large_today),ic:'🔴',c:'#ef4444'},{l:'دولية',v:f(p.stats.international),ic:'🌍',c:'#2563eb'},{l:'فاشلة اليوم',v:f(p.stats.failed_today),ic:'❌',c:'#ef4444'}]" :key="s.l">
      <span class="tm-ic">{{ s.ic }}</span><div><div class="tm-v" :style="{color:s.c||'#0f172a'}">{{ s.v }}</div><div class="tm-l">{{ s.l }}</div></div>
    </div>
  </div>
  <div class="tm-grid">
    <!-- Hourly Chart -->
    <div class="tm-card"><div class="tm-ct">⏰ حجم المعاملات بالساعة (24 ساعة)</div>
      <div class="tm-chart">
        <div v-for="h in p.hourly" :key="h.hour" class="tm-bar-w">
          <div class="tm-bar" :style="{height:(h.count/maxH()*100)+'%'}"><span class="tm-tip">{{ h.count }} ({{ fc(h.volume) }})</span></div>
          <div class="tm-bl">{{ h.hour }}:00</div>
        </div>
        <div v-if="!p.hourly?.length" class="tm-empty">لا توجد بيانات</div>
      </div>
    </div>
    <!-- By Country -->
    <div class="tm-card"><div class="tm-ct">🌍 المعاملات حسب الدولة (30 يوم)</div>
      <div v-for="c in p.byCountry" :key="c.country" class="tm-cr"><span>{{ c.country }}</span><span><strong>{{ f(c.count) }}</strong> ({{ fc(c.volume) }})</span></div>
      <div v-if="!p.byCountry?.length" class="tm-empty">لا توجد بيانات</div>
    </div>
  </div>
  <!-- Anomalies -->
  <div class="tm-card"><div class="tm-ct">🔴 معاملات غير طبيعية (> €10,000 — آخر 7 أيام)</div>
    <table class="tm-tbl"><thead><tr><th>المستخدم</th><th>المبلغ</th><th>النوع</th><th>الحالة</th><th>التاريخ</th></tr></thead>
      <tbody><tr v-for="a in p.anomalies" :key="a.id">
        <td class="tm-bold">{{ a.user_name||'—' }}</td><td class="tm-bold" style="color:#ef4444">{{ fc(a.amount) }}</td>
        <td><span class="tm-tag">{{ a.type }}</span></td><td>{{ a.status }}</td>
        <td class="tm-date">{{ new Date(a.created_at).toLocaleString('ar') }}</td>
      </tr><tr v-if="!p.anomalies?.length"><td colspan="5" class="tm-empty">لا توجد</td></tr></tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.tm{padding:24px;direction:rtl}.tm-h{font-size:22px;font-weight:900;color:#0f172a;margin-bottom:20px}
.tm-stats{display:grid;grid-template-columns:repeat(6,1fr);gap:10px;margin-bottom:16px}
.tm-s{display:flex;align-items:center;gap:10px;padding:14px;background:#fff;border-radius:12px;border:1px solid #f1f5f9}
.tm-ic{font-size:22px}.tm-v{font-size:16px;font-weight:900}.tm-l{font-size:10px;color:#94a3b8}
.tm-grid{display:grid;grid-template-columns:2fr 1fr;gap:16px;margin-bottom:16px}
.tm-card{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9;margin-bottom:16px}.tm-ct{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:12px}
.tm-chart{display:flex;align-items:flex-end;gap:4px;height:160px}.tm-bar-w{flex:1;display:flex;flex-direction:column;align-items:center;height:100%}
.tm-bar{background:linear-gradient(180deg,#f59e0b,#d97706);border-radius:4px 4px 0 0;min-height:2px;width:100%;position:relative;transition:height .3s}
.tm-tip{display:none;position:absolute;top:-22px;left:50%;transform:translateX(-50%);background:#0f172a;color:#fff;padding:2px 6px;border-radius:4px;font-size:8px;white-space:nowrap}.tm-bar:hover .tm-tip{display:block}
.tm-bl{font-size:8px;color:#94a3b8;margin-top:3px}
.tm-cr{display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid #f8fafc;font-size:12px;color:#475569}
.tm-tbl{width:100%;border-collapse:collapse}.tm-tbl th{font-size:10px;font-weight:700;color:#94a3b8;text-align:right;padding:10px 12px;border-bottom:1px solid #f1f5f9}
.tm-tbl td{font-size:12px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}.tm-bold{font-weight:700}.tm-date{font-size:10px;color:#94a3b8}
.tm-tag{font-size:9px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b;font-weight:600}
.tm-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px;width:100%}
</style>
