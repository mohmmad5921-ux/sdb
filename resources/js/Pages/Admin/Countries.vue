<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ usersByCountry: Array, countryDetails: Object });
const f = n => Number(n||0).toLocaleString('en');

const flags = {
  'Denmark': '🇩🇰', 'Syria': '🇸🇾', 'UAE': '🇦🇪', 'Germany': '🇩🇪', 'Sweden': '🇸🇪',
  'Turkey': '🇹🇷', 'Lebanon': '🇱🇧', 'Jordan': '🇯🇴', 'Iraq': '🇮🇶', 'Egypt': '🇪🇬',
  'Saudi Arabia': '🇸🇦', 'Kuwait': '🇰🇼', 'Netherlands': '🇳🇱', 'France': '🇫🇷',
  'UK': '🇬🇧', 'United Kingdom': '🇬🇧', 'USA': '🇺🇸', 'United States': '🇺🇸',
  'Norway': '🇳🇴', 'Finland': '🇫🇮', 'Austria': '🇦🇹', 'Belgium': '🇧🇪',
  'Canada': '🇨🇦', 'Australia': '🇦🇺', 'Unknown': '🌍', 'null': '🌍', '': '🌍'
};
const getFlag = c => flags[c] || '🏳️';
const total = () => (p.usersByCountry||[]).reduce((s,c) => s + c.count, 0);
const topCountry = () => (p.usersByCountry||[])[0]?.country || '—';
const uniqueCountries = () => (p.usersByCountry||[]).length;
</script>
<template>
<Head title="الدول — الأدمن" />
<div class="ct">
  <div class="ct-header"><h1 class="ct-h">🌍 العملاء حسب الدولة</h1><div class="ct-sum">{{ f(total()) }} عميل · {{ uniqueCountries() }} دولة</div></div>

  <!-- KPI Cards -->
  <div class="ct-kpis">
    <div class="ct-kpi"><div class="ct-kpi-ic" style="background:#eff6ff">🌍</div><div><div class="ct-kpi-v">{{ uniqueCountries() }}</div><div class="ct-kpi-l">دول مختلفة</div></div></div>
    <div class="ct-kpi"><div class="ct-kpi-ic" style="background:#ecfdf5">👥</div><div><div class="ct-kpi-v">{{ f(total()) }}</div><div class="ct-kpi-l">إجمالي العملاء</div></div></div>
    <div class="ct-kpi"><div class="ct-kpi-ic" style="background:#fef3c7">🏆</div><div><div class="ct-kpi-v">{{ topCountry() }}</div><div class="ct-kpi-l">أكثر دولة</div></div></div>
  </div>

  <!-- Country Cards Grid -->
  <div class="ct-grid">
    <div v-for="c in p.usersByCountry" :key="c.country" class="ct-card">
      <div class="ct-card-flag">{{ getFlag(c.country) }}</div>
      <div class="ct-card-name">{{ c.country || 'غير محدد' }}</div>
      <div class="ct-card-count">{{ f(c.count) }}</div>
      <div class="ct-card-label">عميل</div>
      <div class="ct-card-bar"><div class="ct-card-fill" :style="{width: (c.count/((p.usersByCountry||[])[0]?.count||1)*100)+'%'}"></div></div>
    </div>
    <div v-if="!p.usersByCountry?.length" class="ct-empty">لا توجد بيانات</div>
  </div>

  <!-- Full Table -->
  <div class="ct-table-card">
    <div class="ct-table-header">📊 التفاصيل الكاملة</div>
    <table class="ct-tbl">
      <thead><tr><th>#</th><th>الدولة</th><th>العلم</th><th>العملاء</th><th>النسبة</th></tr></thead>
      <tbody>
        <tr v-for="(c,i) in p.usersByCountry" :key="c.country">
          <td>{{ i+1 }}</td>
          <td class="ct-bold">{{ c.country || 'غير محدد' }}</td>
          <td>{{ getFlag(c.country) }}</td>
          <td>{{ f(c.count) }}</td>
          <td><span class="ct-pct">{{ total() > 0 ? ((c.count/total())*100).toFixed(1) : 0 }}%</span></td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.ct{direction:rtl;max-width:1400px;margin:0 auto}
.ct-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}.ct-h{font-size:22px;font-weight:900;color:#0f172a}.ct-sum{font-size:13px;color:#94a3b8}
.ct-kpis{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:20px}
.ct-kpi{display:flex;align-items:center;gap:12px;background:#fff;border-radius:14px;padding:16px;border:1px solid #f1f5f9}
.ct-kpi-ic{width:42px;height:42px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
.ct-kpi-v{font-size:22px;font-weight:900;color:#0f172a}.ct-kpi-l{font-size:11px;color:#94a3b8;font-weight:600}
.ct-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:12px;margin-bottom:20px}
.ct-card{background:#fff;border:1px solid #f1f5f9;border-radius:16px;padding:20px;text-align:center;transition:all .2s}
.ct-card:hover{transform:translateY(-2px);box-shadow:0 6px 16px rgba(0,0,0,.06)}
.ct-card-flag{font-size:36px;margin-bottom:8px}
.ct-card-name{font-size:14px;font-weight:700;color:#0f172a;margin-bottom:4px}
.ct-card-count{font-size:28px;font-weight:900;color:#10b981}
.ct-card-label{font-size:11px;color:#94a3b8;margin-bottom:8px}
.ct-card-bar{height:4px;background:#f1f5f9;border-radius:4px;overflow:hidden}.ct-card-fill{height:100%;background:linear-gradient(90deg,#10b981,#059669);border-radius:4px;transition:width .5s}
.ct-table-card{background:#fff;border:1px solid #f1f5f9;border-radius:16px;padding:20px}
.ct-table-header{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:14px}
.ct-tbl{width:100%;border-collapse:collapse}
.ct-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:10px;border-bottom:2px solid #f1f5f9}
.ct-tbl td{font-size:13px;color:#334155;padding:10px;border-bottom:1px solid #f8fafc}
.ct-bold{font-weight:700;color:#0f172a}
.ct-pct{font-size:12px;font-weight:700;color:#2563eb;background:#eff6ff;padding:2px 8px;border-radius:6px}
.ct-empty{text-align:center;color:#cbd5e1;padding:40px;font-size:14px}
@media(max-width:768px){.ct-kpis,.ct-grid{grid-template-columns:1fr}}
</style>
