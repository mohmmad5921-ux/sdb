<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ riskDistribution: Array, highRiskUsers: Array, recentIncidents: Array, stats: Object });
const f = n => Number(n||0).toLocaleString('en');
const rkColor = l => ({low:'#10b981',medium:'#f59e0b',high:'#f97316',critical:'#ef4444'}[l]||'#64748b');
const editId = ref(null); const editScore = ref(0);
const saveRisk = id => { router.patch(route('admin.risk.update', id), {risk_score:editScore.value}); editId.value=null; };
</script>
<template>
<Head title="إدارة المخاطر" />
<div class="rk">
  <h1 class="rk-h">⚠️ لوحة تحكم المخاطر</h1>
  <div class="rk-stats">
    <div class="rk-s"><span class="rk-ic">🔴</span><div><div class="rk-v" style="color:#ef4444">{{ f(p.stats.total_high_risk) }}</div><div class="rk-l">مستخدمين عالي الخطورة</div></div></div>
    <div class="rk-s"><span class="rk-ic">🚨</span><div><div class="rk-v" style="color:#f59e0b">{{ f(p.stats.open_incidents) }}</div><div class="rk-l">حوادث مفتوحة</div></div></div>
    <div class="rk-s"><span class="rk-ic">🏛️</span><div><div class="rk-v" style="color:#2563eb">{{ f(p.stats.aml_pending) }}</div><div class="rk-l">AML معلّق</div></div></div>
    <div class="rk-s"><span class="rk-ic">🧊</span><div><div class="rk-v" style="color:#dc2626">{{ f(p.stats.frozen_accounts) }}</div><div class="rk-l">حسابات مجمّدة</div></div></div>
  </div>
  <!-- Risk Distribution -->
  <div class="rk-card"><div class="rk-ct">📊 توزيع المخاطر</div>
    <div class="rk-dist">
      <div v-for="r in p.riskDistribution" :key="r.risk_level" class="rk-dr"><span class="rk-dot" :style="{background:rkColor(r.risk_level)}"></span><span>{{ r.risk_level }}</span><strong>{{ f(r.count) }}</strong></div>
    </div>
  </div>
  <!-- High Risk Users -->
  <div class="rk-card"><div class="rk-ct">🔴 مستخدمين عالي المخاطر</div>
    <table class="rk-tbl"><thead><tr><th>المستخدم</th><th>البريد</th><th>النقاط</th><th>المستوى</th><th>الحالة</th><th>تعديل</th></tr></thead>
      <tbody><tr v-for="u in p.highRiskUsers" :key="u.id">
        <td class="rk-bold">{{ u.name }}</td><td>{{ u.email }}</td>
        <td><div class="rk-bar-w"><div class="rk-bar-f" :style="{width:u.risk_score+'%',background:rkColor(u.risk_level)}"></div><span>{{ u.risk_score }}/100</span></div></td>
        <td><span :style="{color:rkColor(u.risk_level),fontWeight:700}">{{ u.risk_level }}</span></td>
        <td>{{ u.status }}</td>
        <td>
          <span v-if="editId!==u.id" @click="editId=u.id;editScore=u.risk_score" class="rk-edit">✏️</span>
          <span v-else class="rk-edit-row"><input v-model.number="editScore" type="number" min="0" max="100" class="rk-sc-inp"/><button @click="saveRisk(u.id)" class="rk-sv-btn">✓</button></span>
        </td>
      </tr><tr v-if="!p.highRiskUsers?.length"><td colspan="6" class="rk-empty">لا يوجد</td></tr></tbody>
    </table>
  </div>
  <!-- Recent Incidents -->
  <div class="rk-card"><div class="rk-ct">🚨 حوادث مفتوحة</div>
    <table class="rk-tbl"><thead><tr><th>المستخدم</th><th>النوع</th><th>الخطورة</th><th>الوصف</th><th>التاريخ</th></tr></thead>
      <tbody><tr v-for="i in p.recentIncidents" :key="i.id">
        <td class="rk-bold">{{ i.user_name||'—' }}</td><td><span class="rk-tag">{{ i.type }}</span></td>
        <td><span :style="{color:rkColor(i.severity),fontWeight:700}">{{ i.severity }}</span></td>
        <td class="rk-desc">{{ i.description?.slice(0,80) }}</td>
        <td class="rk-date">{{ new Date(i.created_at).toLocaleString('ar') }}</td>
      </tr></tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.rk{padding:24px;direction:rtl}.rk-h{font-size:22px;font-weight:900;color:#0f172a;margin-bottom:20px}
.rk-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin-bottom:16px}
.rk-s{display:flex;align-items:center;gap:10px;padding:16px;background:#fff;border-radius:12px;border:1px solid #f1f5f9}
.rk-ic{font-size:24px}.rk-v{font-size:20px;font-weight:900}.rk-l{font-size:10px;color:#94a3b8}
.rk-card{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9;margin-bottom:16px}.rk-ct{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:12px}
.rk-dist{display:flex;gap:20px}.rk-dr{display:flex;align-items:center;gap:6px;font-size:13px;color:#475569}.rk-dot{width:10px;height:10px;border-radius:50%}
.rk-tbl{width:100%;border-collapse:collapse}.rk-tbl th{font-size:10px;font-weight:700;color:#94a3b8;text-align:right;padding:10px 12px;border-bottom:1px solid #f1f5f9}
.rk-tbl td{font-size:12px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}.rk-bold{font-weight:700}.rk-date{font-size:10px;color:#94a3b8}
.rk-tag{font-size:9px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b;font-weight:600}.rk-desc{max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.rk-bar-w{display:flex;align-items:center;gap:6px;min-width:100px}.rk-bar-f{height:6px;border-radius:3px;min-width:4px}
.rk-edit{cursor:pointer;font-size:14px}.rk-edit-row{display:flex;gap:4px;align-items:center}
.rk-sc-inp{width:50px;padding:2px 6px;border:1px solid #e2e8f0;border-radius:6px;font-size:11px;outline:none}
.rk-sv-btn{padding:2px 8px;background:#10b981;color:#fff;border:none;border-radius:4px;cursor:pointer;font-size:11px}
.rk-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px}
</style>
