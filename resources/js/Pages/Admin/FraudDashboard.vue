<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ rules: Array, incidents: Array, stats: Object, highRiskUsers: Array });
const f = n => Number(n||0).toLocaleString('en');
const showRule = ref(false);
const form = useForm({name:'',rule_type:'amount_threshold',description:'',action:'alert',severity:'medium'});
const saveRule = () => form.post(route('admin.fraud.rules.store'),{onSuccess:()=>{showRule.value=false;form.reset()}});
const toggle = id => router.post(route('admin.fraud.rules.toggle', id));
const updateIncident = (id, status) => router.patch(route('admin.fraud.incidents.update', id), {status});
const svColor = s => ({low:'#10b981',medium:'#f59e0b',high:'#f97316',critical:'#ef4444'}[s]||'#64748b');
const stColor = s => ({open:'#ef4444',investigating:'#f59e0b',resolved:'#10b981',false_positive:'#94a3b8'}[s]||'#64748b');
const stLabel = s => ({open:'مفتوح',investigating:'قيد التحقيق',resolved:'تم الحل',false_positive:'إنذار كاذب'}[s]||s);
</script>
<template>
<Head title="كشف الاحتيال" />
<div class="fd">
  <h1 class="fd-h">🛡️ نظام كشف الاحتيال بالذكاء الاصطناعي</h1>
  <!-- Stats -->
  <div class="fd-stats">
    <div class="fd-s" v-for="s in [{l:'إجمالي الحوادث',v:p.stats.total_incidents,ic:'📊'},{l:'مفتوحة',v:p.stats.open,ic:'🔴',c:'#ef4444'},{l:'قيد التحقيق',v:p.stats.investigating,ic:'🔍',c:'#f59e0b'},{l:'تم الحل',v:p.stats.resolved,ic:'✅',c:'#10b981'},{l:'حرجة مفتوحة',v:p.stats.critical,ic:'🚨',c:'#dc2626'},{l:'محظورة اليوم',v:p.stats.blocked_today,ic:'🛑',c:'#ef4444'},{l:'قواعد نشطة',v:p.stats.rules_active,ic:'⚙️',c:'#2563eb'}]" :key="s.l">
      <span class="fd-ic">{{ s.ic }}</span><div><div class="fd-v" :style="{color:s.c||'#0f172a'}">{{ f(s.v) }}</div><div class="fd-l">{{ s.l }}</div></div>
    </div>
  </div>

  <!-- Incidents -->
  <div class="fd-section"><div class="fd-st">🚨 الحوادث الأخيرة</div>
    <table class="fd-tbl"><thead><tr><th>المستخدم</th><th>النوع</th><th>الخطورة</th><th>الوصف</th><th>الحالة</th><th>التاريخ</th><th>إجراء</th></tr></thead>
      <tbody><tr v-for="i in p.incidents" :key="i.id">
        <td class="fd-bold">{{ i.user_name||'—' }}</td>
        <td><span class="fd-tag">{{ i.type }}</span></td>
        <td><span class="fd-sv" :style="{color:svColor(i.severity)}">● {{ i.severity }}</span></td>
        <td class="fd-desc">{{ i.description?.slice(0,60) }}</td>
        <td><span class="fd-ist" :style="{color:stColor(i.status)}">{{ stLabel(i.status) }}</span></td>
        <td class="fd-date">{{ new Date(i.created_at).toLocaleString('ar') }}</td>
        <td class="fd-acts">
          <button v-if="i.status==='open'" @click="updateIncident(i.id,'investigating')" class="fd-btn-y" title="تحقيق">🔍</button>
          <button v-if="i.status!=='resolved'" @click="updateIncident(i.id,'resolved')" class="fd-btn-g" title="حل">✅</button>
          <button v-if="i.status!=='false_positive'" @click="updateIncident(i.id,'false_positive')" class="fd-btn-x" title="كاذب">✗</button>
        </td>
      </tr><tr v-if="!p.incidents?.length"><td colspan="7" class="fd-empty">لا توجد حوادث</td></tr></tbody>
    </table>
  </div>

  <!-- Rules -->
  <div class="fd-section"><div class="fd-st-row"><span class="fd-st">⚙️ قواعد الكشف</span><button @click="showRule=!showRule" class="fd-add">+ قاعدة جديدة</button></div>
    <div v-if="showRule" class="fd-form">
      <input v-model="form.name" placeholder="اسم القاعدة" class="fd-inp"/>
      <select v-model="form.rule_type" class="fd-inp"><option value="amount_threshold">حد المبلغ</option><option value="velocity">سرعة المعاملات</option><option value="geo_anomaly">شذوذ جغرافي</option><option value="vpn_detected">VPN/Proxy</option><option value="device_change">تغيير جهاز</option><option value="multiple_accounts">حسابات متعددة</option></select>
      <select v-model="form.action" class="fd-inp"><option value="alert">تنبيه</option><option value="block">حظر</option><option value="review">مراجعة</option></select>
      <select v-model="form.severity" class="fd-inp"><option value="low">منخفض</option><option value="medium">متوسط</option><option value="high">عالي</option><option value="critical">حرج</option></select>
      <button @click="saveRule" class="fd-sv">حفظ</button>
    </div>
    <div class="fd-rules">
      <div v-for="r in p.rules" :key="r.id" class="fd-rule">
        <div class="fd-rule-h"><span class="fd-sv" :style="{color:svColor(r.severity)}">● {{ r.severity }}</span><strong>{{ r.name }}</strong><span class="fd-tag">{{ r.rule_type }}</span></div>
        <div class="fd-rule-d">{{ r.description }}</div>
        <div class="fd-rule-f"><span>الإجراء: {{ r.action }}</span><span>التفعيلات: {{ r.triggers_count }}</span><button @click="toggle(r.id)" :class="r.active?'fd-on':'fd-off'">{{ r.active?'✅ نشط':'❌ معطّل' }}</button></div>
      </div>
    </div>
  </div>

  <!-- High Risk Users -->
  <div class="fd-section"><div class="fd-st">⚠️ مستخدمين عالي المخاطر</div>
    <table class="fd-tbl"><thead><tr><th>المستخدم</th><th>البريد</th><th>نقاط المخاطر</th><th>المستوى</th></tr></thead>
      <tbody><tr v-for="u in p.highRiskUsers" :key="u.id">
        <td class="fd-bold">{{ u.name }}</td><td>{{ u.email }}</td>
        <td><div class="fd-bar-w"><div class="fd-bar-fill" :style="{width:u.risk_score+'%',background:svColor(u.risk_level)}"></div><span>{{ u.risk_score }}</span></div></td>
        <td><span class="fd-sv" :style="{color:svColor(u.risk_level)}">{{ u.risk_level }}</span></td>
      </tr><tr v-if="!p.highRiskUsers?.length"><td colspan="4" class="fd-empty">لا يوجد</td></tr></tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.fd{padding:24px;direction:rtl}.fd-h{font-size:22px;font-weight:900;color:#0f172a;margin-bottom:20px}
.fd-stats{display:grid;grid-template-columns:repeat(7,1fr);gap:10px;margin-bottom:20px}
.fd-s{display:flex;align-items:center;gap:10px;padding:14px;background:#fff;border-radius:12px;border:1px solid #f1f5f9}
.fd-ic{font-size:22px}.fd-v{font-size:18px;font-weight:900}.fd-l{font-size:10px;color:#94a3b8}
.fd-section{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9;margin-bottom:16px}
.fd-st{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:12px}.fd-st-row{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px}
.fd-tbl{width:100%;border-collapse:collapse}.fd-tbl th{font-size:10px;font-weight:700;color:#94a3b8;text-align:right;padding:10px 12px;border-bottom:1px solid #f1f5f9}
.fd-tbl td{font-size:12px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}.fd-bold{font-weight:700}.fd-date{font-size:10px;color:#94a3b8}.fd-desc{max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.fd-tag{font-size:9px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b;font-weight:600}
.fd-sv{font-size:11px;font-weight:700}.fd-ist{font-size:11px;font-weight:700}
.fd-acts{display:flex;gap:3px}.fd-btn-y,.fd-btn-g,.fd-btn-x{width:26px;height:26px;border:1px solid #e2e8f0;border-radius:6px;background:#fff;cursor:pointer;font-size:11px}
.fd-add{padding:8px 16px;background:#0f172a;color:#fff;border:none;border-radius:8px;font-weight:700;cursor:pointer;font-size:12px}
.fd-form{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:14px}.fd-inp{padding:8px 12px;border:1.5px solid #e2e8f0;border-radius:8px;font-size:12px;outline:none;flex:1;min-width:120px}
.fd-sv{padding:8px 16px;background:#2563eb;color:#fff;border:none;border-radius:8px;font-weight:700;cursor:pointer;font-size:12px}
.fd-rules{display:grid;grid-template-columns:1fr 1fr;gap:10px}
.fd-rule{padding:14px;border:1px solid #f1f5f9;border-radius:12px}.fd-rule-h{display:flex;gap:8px;align-items:center;margin-bottom:4px}.fd-rule-d{font-size:11px;color:#64748b;margin-bottom:6px}
.fd-rule-f{display:flex;gap:10px;font-size:10px;color:#94a3b8;align-items:center}.fd-on{padding:2px 8px;background:#ecfdf5;color:#059669;border:1px solid #a7f3d0;border-radius:6px;font-size:10px;font-weight:600;cursor:pointer}.fd-off{padding:2px 8px;background:#fef2f2;color:#dc2626;border:1px solid #fecaca;border-radius:6px;font-size:10px;font-weight:600;cursor:pointer}
.fd-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px}
.fd-bar-w{display:flex;align-items:center;gap:6px}.fd-bar-fill{height:6px;border-radius:3px;min-width:4px}
</style>
