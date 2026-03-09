<script setup>
import { Head } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { computed } from 'vue';

const props = defineProps({ monthly: Array, conversion: Object, peakHours: Array, typeBreakdown: Array, userStatus: Array, kycStatus: Array });

const fmtM = (a) => { if (a >= 1000000) return (a/1000000).toFixed(1) + 'M'; if (a >= 1000) return (a/1000).toFixed(1) + 'K'; return Number(a).toLocaleString(); };

const maxMonthlyUsers = computed(() => Math.max(...(props.monthly || []).map(m => m.users), 1));
const maxMonthlyTx = computed(() => Math.max(...(props.monthly || []).map(m => m.transactions), 1));
const maxMonthlyVol = computed(() => Math.max(...(props.monthly || []).map(m => m.volume), 1));
const maxPeakHour = computed(() => Math.max(...(props.peakHours || []).map(h => h.count), 1));

const typeLabels = { transfer: 'تحويل', deposit: 'إيداع', withdrawal: 'سحب', exchange: 'صرف', card_payment: 'بطاقة', fee: 'رسوم' };
const statusLabels = { active: 'نشط', pending: 'معلّق', suspended: 'موقوف', blocked: 'محظور' };
const kycLabels = { pending: 'معلّق', submitted: 'مُقدّم', verified: 'موثّق', rejected: 'مرفوض' };
const statusColors = { active: '#10b981', pending: '#f59e0b', suspended: '#ef4444', blocked: '#dc2626', verified: '#10b981', submitted: '#3b82f6', rejected: '#ef4444' };
</script>

<template>
  <Head title="التحليلات المتقدمة" />
  <AdminLayout title="📊 التحليلات المتقدمة" subtitle="تحليل شامل للأداء والاتجاهات">

    <!-- Conversion Rate -->
    <div class="grid grid-cols-3 gap-4">
      <div class="an-card an-conversion">
        <div class="an-conv-title">🎯 معدّل التحويل</div>
        <div class="an-conv-rate">{{ conversion?.rate || 0 }}%</div>
        <div class="an-conv-desc">من التسجيل المبكر إلى حساب فعلي</div>
        <div class="an-conv-detail">
          <span>{{ conversion?.total_prereg }} تسجيل مبكر</span>
          <span>→</span>
          <span>{{ conversion?.converted }} حساب فعلي</span>
        </div>
      </div>

      <!-- User Status Donut -->
      <div class="an-card">
        <h3 class="an-title">👥 توزيع حالة العملاء</h3>
        <div class="an-donut-list">
          <div v-for="s in userStatus" :key="s.status" class="an-donut-row">
            <div class="an-donut-dot" :style="{background: statusColors[s.status]}"></div>
            <span class="an-donut-label">{{ statusLabels[s.status] || s.status }}</span>
            <span class="an-donut-count">{{ s.count }}</span>
          </div>
        </div>
      </div>

      <!-- KYC Status -->
      <div class="an-card">
        <h3 class="an-title">🪪 توزيع حالة KYC</h3>
        <div class="an-donut-list">
          <div v-for="s in kycStatus" :key="s.kyc_status" class="an-donut-row">
            <div class="an-donut-dot" :style="{background: statusColors[s.kyc_status]}"></div>
            <span class="an-donut-label">{{ kycLabels[s.kyc_status] || s.kyc_status }}</span>
            <span class="an-donut-count">{{ s.count }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Monthly Charts -->
    <div class="grid grid-cols-3 gap-4">
      <div class="an-card">
        <h3 class="an-title">👥 العملاء الجدد — 6 أشهر</h3>
        <div class="an-bar-chart">
          <div v-for="m in monthly" :key="m.month" class="an-bar-col">
            <div class="an-bar-wrap"><div class="an-bar" style="background:#6366f1" :style="{height: Math.max((m.users / maxMonthlyUsers) * 100, 4) + '%'}"></div></div>
            <div class="an-bar-label">{{ m.label }}</div>
            <div class="an-bar-val" style="color:#6366f1">{{ m.users }}</div>
          </div>
        </div>
      </div>
      <div class="an-card">
        <h3 class="an-title">💸 عدد المعاملات — 6 أشهر</h3>
        <div class="an-bar-chart">
          <div v-for="m in monthly" :key="m.month" class="an-bar-col">
            <div class="an-bar-wrap"><div class="an-bar" style="background:#10b981" :style="{height: Math.max((m.transactions / maxMonthlyTx) * 100, 4) + '%'}"></div></div>
            <div class="an-bar-label">{{ m.label }}</div>
            <div class="an-bar-val" style="color:#10b981">{{ m.transactions }}</div>
          </div>
        </div>
      </div>
      <div class="an-card">
        <h3 class="an-title">💰 حجم المعاملات — 6 أشهر</h3>
        <div class="an-bar-chart">
          <div v-for="m in monthly" :key="m.month" class="an-bar-col">
            <div class="an-bar-wrap"><div class="an-bar" style="background:#3b82f6" :style="{height: Math.max((m.volume / maxMonthlyVol) * 100, 4) + '%'}"></div></div>
            <div class="an-bar-label">{{ m.label }}</div>
            <div class="an-bar-val" style="color:#3b82f6">€{{ fmtM(m.volume) }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Peak Hours + Transaction Types -->
    <div class="grid grid-cols-2 gap-4">
      <div class="an-card">
        <h3 class="an-title">⏰ أوقات الذروة — آخر 30 يوم</h3>
        <div class="an-heatmap">
          <div v-for="h in peakHours" :key="h.hour" class="an-heat-cell" :title="h.label + ': ' + h.count + ' معاملة'" :style="{background: `rgba(16, 185, 129, ${Math.max(h.count / maxPeakHour * 0.8, 0.05)})`}">
            <span class="an-heat-hour">{{ h.label }}</span>
            <span class="an-heat-count">{{ h.count }}</span>
          </div>
        </div>
      </div>

      <div class="an-card">
        <h3 class="an-title">📊 أنواع المعاملات — آخر 30 يوم</h3>
        <div class="an-type-list">
          <div v-for="t in typeBreakdown" :key="t.type" class="an-type-row">
            <span class="an-type-label">{{ typeLabels[t.type] || t.type }}</span>
            <div class="an-type-bar-wrap">
              <div class="an-type-bar" :style="{width: (t.count / (typeBreakdown[0]?.count || 1)) * 100 + '%'}"></div>
            </div>
            <span class="an-type-count">{{ t.count }}</span>
            <span class="an-type-vol">€{{ fmtM(t.volume) }}</span>
          </div>
          <div v-if="!typeBreakdown?.length" class="text-center text-[#94a3b8] py-4">لا يوجد بيانات</div>
        </div>
      </div>
    </div>

  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
.an-card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;padding:20px}
.an-title{font-size:15px;font-weight:700;color:#0f172a;margin-bottom:16px}
.an-conversion{background:linear-gradient(135deg,#ecfdf5,#f0fdf4);border-color:#a7f3d0;text-align:center;padding:28px}
.an-conv-title{font-size:14px;color:#059669;font-weight:600;margin-bottom:4px}
.an-conv-rate{font-size:48px;font-weight:800;color:#10b981;line-height:1}
.an-conv-desc{font-size:13px;color:#64748b;margin-top:8px}
.an-conv-detail{display:flex;justify-content:center;gap:8px;margin-top:12px;font-size:13px;color:#334155;font-weight:600}

.an-donut-list{display:flex;flex-direction:column;gap:10px}
.an-donut-row{display:flex;align-items:center;gap:10px}
.an-donut-dot{width:12px;height:12px;border-radius:50%;flex-shrink:0}
.an-donut-label{font-size:14px;color:#334155;flex:1}
.an-donut-count{font-size:14px;font-weight:700;color:#0f172a}

.an-bar-chart{display:flex;gap:4px;align-items:flex-end;height:140px}
.an-bar-col{flex:1;display:flex;flex-direction:column;align-items:center;gap:4px}
.an-bar-wrap{flex:1;width:100%;display:flex;align-items:flex-end}
.an-bar{width:100%;border-radius:4px 4px 0 0;min-height:3px;transition:height .3s}
.an-bar-label{font-size:10px;color:#94a3b8;white-space:nowrap}
.an-bar-val{font-size:11px;font-weight:700}

.an-heatmap{display:grid;grid-template-columns:repeat(8,1fr);gap:4px}
.an-heat-cell{border-radius:8px;padding:8px 4px;text-align:center;display:flex;flex-direction:column;align-items:center;gap:2px}
.an-heat-hour{font-size:10px;color:#334155;font-weight:600}
.an-heat-count{font-size:12px;font-weight:700;color:#0f172a}

.an-type-list{display:flex;flex-direction:column;gap:8px}
.an-type-row{display:flex;align-items:center;gap:10px}
.an-type-label{font-size:13px;font-weight:600;color:#334155;min-width:70px}
.an-type-bar-wrap{flex:1;height:8px;background:#f1f5f9;border-radius:4px;overflow:hidden}
.an-type-bar{height:100%;background:linear-gradient(90deg,#10b981,#3b82f6);border-radius:4px;transition:width .3s}
.an-type-count{font-size:13px;font-weight:700;color:#0f172a;min-width:40px;text-align:left}
.an-type-vol{font-size:12px;color:#64748b;min-width:70px;text-align:left}
</style>
