<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ stats: Object, topByTx: Array, countries: Array, monthlyReg: Array, spendingByType: Array });
const f = n => Number(n||0).toLocaleString('en');
const fc = n => '€'+Number(n||0).toLocaleString('en',{minimumFractionDigits:2});
const maxReg = () => Math.max(...(p.monthlyReg||[]).map(m=>m.count),1);
</script>
<template>
<Head title="تحليل المستخدمين" />
<div class="ua">
  <h1 class="ua-h">📊 تحليل المستخدمين المتقدم</h1>
  <div class="ua-stats">
    <div class="ua-s" v-for="s in [{l:'إجمالي',v:f(p.stats.total),ic:'👥'},{l:'نشطين (30 يوم)',v:f(p.stats.active_30d),ic:'⚡'},{l:'نشطين (7 أيام)',v:f(p.stats.active_7d),ic:'🔥'},{l:'خاملين',v:f(p.stats.dormant),ic:'💤',c:'#f59e0b'},{l:'جدد هذا الشهر',v:f(p.stats.new_this_month),ic:'📝',c:'#10b981'},{l:'موثّقين',v:f(p.stats.verified),ic:'✅',c:'#059669'}]" :key="s.l">
      <span class="ua-ic">{{ s.ic }}</span><div><div class="ua-v" :style="{color:s.c||'#0f172a'}">{{ s.v }}</div><div class="ua-l">{{ s.l }}</div></div>
    </div>
  </div>
  <div class="ua-grid">
    <!-- Monthly Registration Chart -->
    <div class="ua-card"><div class="ua-ct">📈 نمو التسجيل الشهري</div>
      <div class="ua-chart"><div v-for="m in p.monthlyReg" :key="m.month" class="ua-bar-w">
        <div class="ua-bar" :style="{height:(m.count/maxReg()*100)+'%'}"><span class="ua-tip">{{ m.count }}</span></div>
        <div class="ua-bl">{{ m.month.slice(5) }}</div>
      </div></div>
    </div>
    <!-- Spending by Type -->
    <div class="ua-card"><div class="ua-ct">💸 الإنفاق حسب النوع</div>
      <div v-for="s in p.spendingByType" :key="s.type" class="ua-sp"><span class="ua-tag">{{ s.type }}</span><span><strong>{{ f(s.count) }}</strong> عملية — {{ fc(s.volume) }}</span></div>
    </div>
  </div>
  <div class="ua-grid">
    <!-- Top Users -->
    <div class="ua-card"><div class="ua-ct">🏆 أنشط المستخدمين</div>
      <table class="ua-tbl"><thead><tr><th>#</th><th>المستخدم</th><th>العمليات</th><th>الحجم</th></tr></thead>
        <tbody><tr v-for="(u,i) in p.topByTx" :key="u.id"><td>{{ i+1 }}</td><td class="ua-bold">{{ u.name }}</td><td>{{ f(u.tx_count) }}</td><td>{{ fc(u.volume) }}</td></tr></tbody>
      </table>
    </div>
    <!-- Countries -->
    <div class="ua-card"><div class="ua-ct">🌍 المستخدمين حسب الدولة</div>
      <div v-for="c in p.countries" :key="c.country" class="ua-cr"><span>{{ c.country }}</span><strong>{{ f(c.count) }}</strong></div>
    </div>
  </div>
</div>
</template>
<style scoped>
.ua{padding:24px;direction:rtl}.ua-h{font-size:22px;font-weight:900;color:#0f172a;margin-bottom:20px}
.ua-stats{display:grid;grid-template-columns:repeat(6,1fr);gap:10px;margin-bottom:16px}
.ua-s{display:flex;align-items:center;gap:10px;padding:14px;background:#fff;border-radius:12px;border:1px solid #f1f5f9}
.ua-ic{font-size:22px}.ua-v{font-size:16px;font-weight:900}.ua-l{font-size:10px;color:#94a3b8}
.ua-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:16px}
.ua-card{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9}.ua-ct{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:12px}
.ua-chart{display:flex;align-items:flex-end;gap:6px;height:150px}.ua-bar-w{flex:1;display:flex;flex-direction:column;align-items:center;height:100%}
.ua-bar{background:linear-gradient(180deg,#10b981,#059669);border-radius:4px 4px 0 0;min-height:2px;width:100%;position:relative;transition:height .3s}
.ua-tip{display:none;position:absolute;top:-20px;left:50%;transform:translateX(-50%);background:#0f172a;color:#fff;padding:2px 5px;border-radius:4px;font-size:8px;white-space:nowrap}.ua-bar:hover .ua-tip{display:block}
.ua-bl{font-size:8px;color:#94a3b8;margin-top:3px}
.ua-sp{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #f8fafc;font-size:12px;color:#475569}
.ua-tag{font-size:10px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b;font-weight:600}
.ua-tbl{width:100%;border-collapse:collapse}.ua-tbl th{font-size:10px;font-weight:700;color:#94a3b8;text-align:right;padding:8px 10px;border-bottom:1px solid #f1f5f9}
.ua-tbl td{font-size:12px;color:#334155;padding:8px 10px;border-bottom:1px solid #f8fafc}.ua-bold{font-weight:700}
.ua-cr{display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid #f8fafc;font-size:12px;color:#475569}
</style>
