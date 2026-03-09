<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ feeTypes: Array, monthlyVolume: Object, topUsers: Array, dailyVolume: Array });
const fmt = n => Number(n||0).toLocaleString('en',{maximumFractionDigits:0});
</script>
<template>
<Head title="تحليل الإيرادات" />
<div class="rv">
  <h1 class="rv-h">💰 تحليل الإيرادات</h1>

  <div class="rv-grid">
    <div class="rv-card">
      <h3>📊 الحجم اليومي (آخر 30 يوم)</h3>
      <div class="rv-chart">
        <div v-for="d in p.dailyVolume" :key="d.day" class="rv-bar-col">
          <div class="rv-bar" :style="{height: Math.max(2, (d.volume / Math.max(...p.dailyVolume.map(x=>x.volume||1))) * 100) + '%'}">
            <span class="rv-tip">€{{ fmt(d.volume) }}<br>{{ d.count }} عملية</span>
          </div>
          <div class="rv-day">{{ d.day?.slice(-2) }}</div>
        </div>
        <div v-if="!p.dailyVolume.length" class="rv-empty">لا توجد بيانات</div>
      </div>
    </div>

    <div class="rv-card">
      <h3>🏆 أعلى 10 عملاء</h3>
      <table class="rv-tbl"><thead><tr><th>#</th><th>الاسم</th><th>العمليات</th><th>الحجم</th></tr></thead>
        <tbody><tr v-for="(u,i) in p.topUsers" :key="u.email"><td>{{ i+1 }}</td><td class="rv-bold">{{ u.name }}</td><td>{{ u.tx_count }}</td><td>€{{ fmt(u.total_volume) }}</td></tr>
        <tr v-if="!p.topUsers.length"><td colspan="4" class="rv-empty">لا توجد بيانات</td></tr></tbody>
      </table>
    </div>
  </div>

  <div class="rv-card" style="margin-top:20px">
    <h3>📈 الحجم الشهري حسب النوع</h3>
    <div v-for="(items, month) in p.monthlyVolume" :key="month" class="rv-month">
      <div class="rv-month-h">{{ month }}</div>
      <div class="rv-pills">
        <span v-for="item in items" :key="item.type" class="rv-pill">{{ item.type || 'عام' }}: <strong>{{ item.count }}</strong> عملية — €{{ fmt(item.volume) }}</span>
      </div>
    </div>
    <div v-if="!Object.keys(p.monthlyVolume).length" class="rv-empty">لا توجد بيانات</div>
  </div>
</div>
</template>
<style scoped>
.rv{padding:24px;direction:rtl}.rv-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:24px}
.rv-grid{display:grid;grid-template-columns:1.5fr 1fr;gap:20px}
.rv-card{background:#fff;border-radius:16px;padding:24px;border:1px solid #f1f5f9}
.rv-card h3{font-size:15px;font-weight:700;color:#334155;margin-bottom:16px}
.rv-chart{display:flex;gap:3px;align-items:flex-end;height:180px;padding-top:20px}
.rv-bar-col{flex:1;display:flex;flex-direction:column;align-items:center;height:100%;justify-content:flex-end;position:relative}
.rv-bar{width:100%;background:linear-gradient(to top,#2563eb,#60a5fa);border-radius:4px 4px 0 0;min-height:2px;position:relative;cursor:pointer}
.rv-bar:hover .rv-tip{display:block}
.rv-tip{display:none;position:absolute;bottom:100%;left:50%;transform:translateX(-50%);background:#0f172a;color:#fff;font-size:10px;padding:4px 8px;border-radius:6px;white-space:nowrap;margin-bottom:4px;text-align:center}
.rv-day{font-size:9px;color:#94a3b8;margin-top:4px}
.rv-tbl{width:100%;border-collapse:collapse}.rv-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:8px 12px;border-bottom:1px solid #f1f5f9}
.rv-tbl td{font-size:13px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}.rv-bold{font-weight:700}
.rv-month{margin-bottom:12px}.rv-month-h{font-size:14px;font-weight:700;color:#0f172a;margin-bottom:6px}
.rv-pills{display:flex;flex-wrap:wrap;gap:6px}
.rv-pill{font-size:12px;background:#f1f5f9;padding:6px 12px;border-radius:8px;color:#475569}.rv-pill strong{color:#0f172a}
.rv-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px}
</style>
