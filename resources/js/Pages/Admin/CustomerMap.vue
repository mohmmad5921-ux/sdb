<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ countries: Array, cities: Array, recentByCountry: Array, totalUsers: Number });
const pct = (count) => p.totalUsers > 0 ? (count / p.totalUsers * 100).toFixed(1) : 0;
</script>
<template>
<Head title="خريطة العملاء" />
<div class="mp">
  <h1 class="mp-h">🗺️ خريطة العملاء</h1>
  <div class="mp-total">إجمالي العملاء: <strong>{{ p.totalUsers }}</strong></div>

  <div class="mp-grid">
    <div class="mp-card">
      <h3>🌍 التوزيع حسب الدولة</h3>
      <div v-for="c in p.countries" :key="c.country" class="mp-bar-row">
        <div class="mp-bar-label">{{ c.country }}</div>
        <div class="mp-bar-wrap"><div class="mp-bar" :style="{width: pct(c.count)+'%'}"></div></div>
        <div class="mp-bar-val">{{ c.count }} <span class="mp-pct">({{ pct(c.count) }}%)</span></div>
      </div>
      <div v-if="!p.countries.length" class="mp-empty">لا توجد بيانات</div>
    </div>

    <div class="mp-card">
      <h3>🏙️ أعلى 20 مدينة</h3>
      <table class="mp-tbl"><thead><tr><th>المدينة</th><th>الدولة</th><th>العدد</th></tr></thead>
        <tbody><tr v-for="c in p.cities" :key="c.city"><td class="mp-bold">{{ c.city }}</td><td>{{ c.country }}</td><td>{{ c.count }}</td></tr>
        <tr v-if="!p.cities.length"><td colspan="3" class="mp-empty">لا توجد بيانات</td></tr></tbody>
      </table>
    </div>
  </div>

  <div class="mp-card" style="margin-top:20px">
    <h3>📈 تسجيلات آخر 30 يوم حسب الدولة</h3>
    <div class="mp-recent">
      <div v-for="r in p.recentByCountry" :key="r.country" class="mp-rpill">{{ r.country }} <strong>{{ r.count }}</strong></div>
      <div v-if="!p.recentByCountry.length" class="mp-empty">لا توجد بيانات</div>
    </div>
  </div>
</div>
</template>
<style scoped>
.mp{padding:24px;direction:rtl}.mp-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:8px}
.mp-total{font-size:14px;color:#64748b;margin-bottom:24px}
.mp-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px}
.mp-card{background:#fff;border-radius:16px;padding:24px;border:1px solid #f1f5f9}
.mp-card h3{font-size:15px;font-weight:700;color:#334155;margin-bottom:16px}
.mp-bar-row{display:flex;align-items:center;gap:10px;margin-bottom:8px}
.mp-bar-label{width:80px;font-size:12px;font-weight:600;color:#475569;flex-shrink:0}
.mp-bar-wrap{flex:1;height:20px;background:#f1f5f9;border-radius:6px;overflow:hidden}
.mp-bar{height:100%;background:linear-gradient(90deg,#2563eb,#10b981);border-radius:6px;min-width:2px;transition:width .5s}
.mp-bar-val{font-size:12px;font-weight:600;color:#334155;white-space:nowrap}.mp-pct{color:#94a3b8}
.mp-tbl{width:100%;border-collapse:collapse}.mp-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:8px 12px;border-bottom:1px solid #f1f5f9}
.mp-tbl td{font-size:13px;color:#334155;padding:8px 12px;border-bottom:1px solid #f8fafc}.mp-bold{font-weight:700}
.mp-recent{display:flex;flex-wrap:wrap;gap:8px}
.mp-rpill{font-size:12px;background:#f1f5f9;padding:8px 14px;border-radius:8px;color:#475569}.mp-rpill strong{color:#0f172a;margin-right:4px}
.mp-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px}
</style>
