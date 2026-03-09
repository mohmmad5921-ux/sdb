<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ totalUsers:Number, active30:Number, active7:Number, dormant:Number, withTx:Number, withoutTx:Number, churned:Number, monthlyReg:Array, activityRate:Number, churnRate:Number });
</script>
<template>
<Head title="تحليل الاحتفاظ" />
<div class="rt">
  <h1 class="rt-h">🔄 تحليل الاحتفاظ بالعملاء</h1>

  <div class="rt-stats">
    <div class="rt-s" v-for="s in [
      {l:'نشطين (30 يوم)',v:p.active30,ic:'✅',color:'#10b981'},
      {l:'نشطين (7 أيام)',v:p.active7,ic:'⚡',color:'#2563eb'},
      {l:'خاملين (90+ يوم)',v:p.dormant,ic:'😴',color:'#f59e0b'},
      {l:'معدل الخمول',v:p.churnRate+'%',ic:'📉',color:'#ef4444'},
      {l:'معدل النشاط',v:p.activityRate+'%',ic:'📈',color:'#10b981'},
      {l:'مع معاملات',v:p.withTx,ic:'💸',color:'#8b5cf6'}
    ]" :key="s.l">
      <span class="rt-s-ic">{{ s.ic }}</span>
      <div><div class="rt-s-v" :style="{color:s.color}">{{ s.v }}</div><div class="rt-s-l">{{ s.l }}</div></div>
    </div>
  </div>

  <div class="rt-grid">
    <div class="rt-card">
      <h3>📊 معدل المشاركة</h3>
      <div class="rt-rings">
        <div class="rt-ring"><div class="rt-ring-c" :style="{'--p':p.activityRate,'--c':'#10b981'}"><span>{{ p.activityRate }}%</span></div><div class="rt-ring-l">نشطين</div></div>
        <div class="rt-ring"><div class="rt-ring-c" :style="{'--p':(p.totalUsers>0?(p.withTx/p.totalUsers*100).toFixed(1):0),'--c':'#8b5cf6'}"><span>{{ p.totalUsers>0?(p.withTx/p.totalUsers*100).toFixed(1):0 }}%</span></div><div class="rt-ring-l">لديهم معاملات</div></div>
        <div class="rt-ring"><div class="rt-ring-c" :style="{'--p':p.churnRate,'--c':'#ef4444'}"><span>{{ p.churnRate }}%</span></div><div class="rt-ring-l">خمول</div></div>
      </div>
    </div>

    <div class="rt-card">
      <h3>📅 التسجيلات الشهرية</h3>
      <table class="rt-tbl"><thead><tr><th>الشهر</th><th>مسجلين جدد</th></tr></thead>
        <tbody><tr v-for="m in p.monthlyReg" :key="m.month"><td>{{ m.month }}</td><td>{{ m.count }}</td></tr>
        <tr v-if="!p.monthlyReg.length"><td colspan="2" class="rt-empty">لا توجد</td></tr></tbody>
      </table>
    </div>
  </div>
</div>
</template>
<style scoped>
.rt{padding:24px;direction:rtl}.rt-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:24px}
.rt-stats{display:grid;grid-template-columns:repeat(6,1fr);gap:12px;margin-bottom:24px}
.rt-s{display:flex;align-items:center;gap:10px;padding:16px;background:#fff;border-radius:14px;border:1px solid #f1f5f9}
.rt-s-ic{font-size:24px}.rt-s-v{font-size:20px;font-weight:800}.rt-s-l{font-size:11px;color:#94a3b8;margin-top:2px}
.rt-grid{display:grid;grid-template-columns:1.2fr 1fr;gap:20px}
.rt-card{background:#fff;border-radius:16px;padding:24px;border:1px solid #f1f5f9}
.rt-card h3{font-size:15px;font-weight:700;color:#334155;margin-bottom:16px}
.rt-rings{display:flex;justify-content:center;gap:32px;padding:20px 0}
.rt-ring{text-align:center}
.rt-ring-c{width:100px;height:100px;border-radius:50%;background:conic-gradient(var(--c) calc(var(--p) * 1%), #f1f5f9 0);display:flex;align-items:center;justify-content:center;position:relative}
.rt-ring-c::before{content:'';width:70px;height:70px;border-radius:50%;background:#fff;position:absolute}
.rt-ring-c span{position:relative;font-size:16px;font-weight:800;color:#0f172a}
.rt-ring-l{font-size:12px;color:#64748b;margin-top:8px;font-weight:600}
.rt-tbl{width:100%;border-collapse:collapse}.rt-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:8px 12px;border-bottom:1px solid #f1f5f9}
.rt-tbl td{font-size:13px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}
.rt-empty{text-align:center;color:#cbd5e1;font-style:italic}
</style>
