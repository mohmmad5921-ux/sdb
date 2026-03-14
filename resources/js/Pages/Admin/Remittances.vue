<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ remittances: Array, stats: Object });
const f = n => Number(n||0).toLocaleString('en');
const filter = ref('all');
const search = ref('');
const detail = ref(null);

const filtered = computed(() => {
  let list = p.remittances || [];
  if (filter.value !== 'all') list = list.filter(r => r.status === filter.value);
  if (search.value) {
    const q = search.value.toLowerCase();
    list = list.filter(r => r.notification_code?.includes(q) || r.recipient_name?.toLowerCase().includes(q) || r.sender_name?.toLowerCase().includes(q) || r.recipient_phone?.includes(q));
  }
  return list;
});

const statusBadge = s => ({
  ready: {bg:'#ecfdf5',color:'#059669',label:'جاهزة للاستلام'},
  collected: {bg:'#dbeafe',color:'#2563eb',label:'تم الاستلام'},
  expired: {bg:'#fef2f2',color:'#dc2626',label:'منتهية'},
  cancelled: {bg:'#f1f5f9',color:'#64748b',label:'ملغاة'},
  pending: {bg:'#fffbeb',color:'#d97706',label:'معلقة'},
}[s] || {bg:'#f1f5f9',color:'#64748b',label:s});

const collectRemittance = (id) => { if (confirm('تأكيد: تسليم هذه الحوالة للمستلم؟')) router.post(route('admin.remittances.collect', id)); };
const cancelRemittance = (id) => { if (confirm('تأكيد: إلغاء هذه الحوالة؟ سيتم إشعار العميل.')) router.post(route('admin.remittances.cancel', id)); };

const fmtDate = d => d ? new Date(d).toLocaleDateString('ar', { year:'numeric', month:'short', day:'numeric', hour:'2-digit', minute:'2-digit' }) : '';
</script>
<template>
<Head title="الحوالات — الأدمن" />
<div class="rm">
  <div class="rm-header"><h1 class="rm-h">💸 إدارة الحوالات</h1></div>

  <!-- KPIs -->
  <div class="rm-kpis">
    <div class="rm-kpi"><div class="rm-kpi-ic" style="background:#eff6ff">💸</div><div><div class="rm-kpi-v">{{ f(p.stats?.total) }}</div><div class="rm-kpi-l">إجمالي الحوالات</div></div></div>
    <div class="rm-kpi"><div class="rm-kpi-ic" style="background:#ecfdf5">✅</div><div><div class="rm-kpi-v">{{ f(p.stats?.collected) }}</div><div class="rm-kpi-l">تم استلامها</div></div></div>
    <div class="rm-kpi"><div class="rm-kpi-ic" style="background:#fef3c7">⏳</div><div><div class="rm-kpi-v">{{ f(p.stats?.pending) }}</div><div class="rm-kpi-l">بانتظار الاستلام</div></div></div>
    <div class="rm-kpi"><div class="rm-kpi-ic" style="background:#dbeafe">💰</div><div><div class="rm-kpi-v">€{{ f(p.stats?.totalAmount) }}</div><div class="rm-kpi-l">إجمالي المبالغ</div></div></div>
    <div class="rm-kpi"><div class="rm-kpi-ic" style="background:#fce7f3">📅</div><div><div class="rm-kpi-v">{{ f(p.stats?.today) }}</div><div class="rm-kpi-l">اليوم</div></div></div>
    <div class="rm-kpi"><div class="rm-kpi-ic" style="background:#e0e7ff">📊</div><div><div class="rm-kpi-v">€{{ f(p.stats?.thisWeek) }}</div><div class="rm-kpi-l">هذا الأسبوع</div></div></div>
  </div>

  <!-- Search + Filters -->
  <div class="rm-toolbar">
    <input v-model="search" placeholder="🔍 بحث بالكود أو اسم المستلم أو المرسل أو الهاتف..." class="rm-search" />
    <div class="rm-filters">
      <button v-for="f2 in [{k:'all',l:'الكل'},{k:'ready',l:'جاهزة'},{k:'collected',l:'تم الاستلام'},{k:'cancelled',l:'ملغاة'},{k:'expired',l:'منتهية'}]" :key="f2.k" :class="['rm-fbtn', filter===f2.k?'rm-fbtn-active':'']" @click="filter=f2.k">{{ f2.l }}</button>
    </div>
  </div>

  <!-- Table -->
  <div class="rm-card">
    <table class="rm-tbl">
      <thead><tr><th>#</th><th>المرسل</th><th>المستلم</th><th>المبلغ</th><th>يستلم</th><th>الوكيل</th><th>المحافظة</th><th>الحالة</th><th>الكود</th><th>التاريخ</th><th>إجراءات</th></tr></thead>
      <tbody>
        <tr v-for="r in filtered" :key="r.id">
          <td>{{ r.id }}</td>
          <td class="rm-bold">{{ r.sender_name }}<br><span class="rm-sub">{{ r.sender_email }}</span></td>
          <td>{{ r.recipient_name }}<br><span class="rm-sub">{{ r.recipient_phone }}</span></td>
          <td class="rm-amount">€{{ f(r.amount) }}</td>
          <td class="rm-syp">{{ f(r.receive_amount) }} ل.س</td>
          <td>{{ r.agent_name_ar }}</td>
          <td>{{ r.governorate_ar }}<br><span class="rm-sub">{{ r.district_ar }}</span></td>
          <td><span class="rm-badge" :style="{background:statusBadge(r.status).bg,color:statusBadge(r.status).color}">{{ statusBadge(r.status).label }}</span></td>
          <td class="rm-code">{{ r.notification_code }}</td>
          <td class="rm-date">{{ fmtDate(r.created_at) }}</td>
          <td class="rm-actions">
            <button class="rm-act-btn rm-act-view" @click="detail = r" title="تفاصيل">👁️</button>
            <button v-if="r.status === 'ready'" class="rm-act-btn rm-act-collect" @click="collectRemittance(r.id)" title="تسليم">✅</button>
            <button v-if="r.status !== 'collected' && r.status !== 'cancelled'" class="rm-act-btn rm-act-cancel" @click="cancelRemittance(r.id)" title="إلغاء">❌</button>
          </td>
        </tr>
        <tr v-if="!filtered.length"><td colspan="11" class="rm-empty">لا توجد حوالات</td></tr>
      </tbody>
    </table>
  </div>

  <!-- Detail Modal -->
  <div v-if="detail" class="rm-modal-overlay" @click.self="detail = null">
    <div class="rm-modal">
      <div class="rm-modal-h">
        <h3>📋 تفاصيل الحوالة #{{ detail.id }}</h3>
        <button @click="detail = null" class="rm-modal-close">✕</button>
      </div>
      <div class="rm-detail-badge"><span class="rm-badge" :style="{background:statusBadge(detail.status).bg,color:statusBadge(detail.status).color}">{{ statusBadge(detail.status).label }}</span></div>
      <div class="rm-detail-grid">
        <div class="rm-detail-item"><span class="rm-detail-label">المرسل</span><span class="rm-detail-val">{{ detail.sender_name }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">البريد</span><span class="rm-detail-val">{{ detail.sender_email }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">المستلم</span><span class="rm-detail-val">{{ detail.recipient_name }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">هاتف المستلم</span><span class="rm-detail-val">{{ detail.recipient_phone }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">المبلغ المرسل</span><span class="rm-detail-val rm-detail-amount">€{{ f(detail.amount) }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">المبلغ المستلم</span><span class="rm-detail-val rm-detail-syp">{{ f(detail.receive_amount) }} ل.س</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">سعر الصرف</span><span class="rm-detail-val">{{ f(detail.exchange_rate) }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">الرسوم</span><span class="rm-detail-val">€{{ detail.fee }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">الوكيل</span><span class="rm-detail-val">{{ detail.agent_name_ar }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">هاتف الوكيل</span><span class="rm-detail-val">{{ detail.agent_phone }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">العنوان</span><span class="rm-detail-val">{{ detail.agent_address }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">المحافظة</span><span class="rm-detail-val">{{ detail.governorate_ar }} — {{ detail.district_ar }}</span></div>
        <div class="rm-detail-item rm-detail-full"><span class="rm-detail-label">كود الإشعار</span><span class="rm-detail-val rm-detail-code">{{ detail.notification_code }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">التاريخ</span><span class="rm-detail-val">{{ fmtDate(detail.created_at) }}</span></div>
        <div class="rm-detail-item"><span class="rm-detail-label">ينتهي</span><span class="rm-detail-val">{{ fmtDate(detail.expires_at) }}</span></div>
        <div v-if="detail.collected_at" class="rm-detail-item"><span class="rm-detail-label">تاريخ الاستلام</span><span class="rm-detail-val">{{ fmtDate(detail.collected_at) }}</span></div>
        <div v-if="detail.notes" class="rm-detail-item rm-detail-full"><span class="rm-detail-label">ملاحظات</span><span class="rm-detail-val">{{ detail.notes }}</span></div>
      </div>
      <div class="rm-detail-actions" v-if="detail.status === 'ready'">
        <button class="rm-detail-btn rm-detail-btn-collect" @click="collectRemittance(detail.id); detail = null;">✅ تسليم الحوالة</button>
        <button class="rm-detail-btn rm-detail-btn-cancel" @click="cancelRemittance(detail.id); detail = null;">❌ إلغاء الحوالة</button>
      </div>
    </div>
  </div>
</div>
</template>
<style scoped>
.rm{direction:rtl;max-width:1500px;margin:0 auto}
.rm-header{margin-bottom:16px}.rm-h{font-size:22px;font-weight:900;color:#0f172a}
.rm-kpis{display:grid;grid-template-columns:repeat(6,1fr);gap:10px;margin-bottom:16px}
.rm-kpi{display:flex;align-items:center;gap:10px;background:#fff;border-radius:14px;padding:14px;border:1px solid #f1f5f9}
.rm-kpi-ic{width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0}
.rm-kpi-v{font-size:20px;font-weight:900;color:#0f172a}.rm-kpi-l{font-size:10px;color:#94a3b8;font-weight:600}
.rm-toolbar{display:flex;gap:10px;margin-bottom:14px;align-items:center;flex-wrap:wrap}
.rm-search{flex:1;min-width:250px;padding:10px 14px;border:1px solid #e2e8f0;border-radius:10px;font-size:13px;outline:none;direction:rtl}
.rm-search:focus{border-color:#10b981;box-shadow:0 0 0 2px rgba(16,185,129,0.1)}
.rm-filters{display:flex;gap:6px}
.rm-fbtn{padding:6px 14px;border-radius:8px;font-size:11px;font-weight:700;border:1px solid #e2e8f0;background:#fff;color:#64748b;cursor:pointer;transition:all .15s}
.rm-fbtn:hover{background:#f8fafc}.rm-fbtn-active{background:#10b981;color:#fff;border-color:#10b981}
.rm-card{background:#fff;border:1px solid #f1f5f9;border-radius:16px;padding:16px;overflow-x:auto}
.rm-tbl{width:100%;border-collapse:collapse;min-width:1200px}
.rm-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:10px;border-bottom:2px solid #f1f5f9}
.rm-tbl td{font-size:12px;color:#334155;padding:8px 10px;border-bottom:1px solid #f8fafc}
.rm-bold{font-weight:700;color:#0f172a}
.rm-sub{font-size:10px;color:#94a3b8}
.rm-amount{font-weight:800;color:#059669;font-size:13px}
.rm-syp{font-weight:700;color:#d97706;font-size:12px}
.rm-badge{font-size:10px;font-weight:700;padding:3px 10px;border-radius:8px;white-space:nowrap}
.rm-code{font-family:monospace;font-weight:700;color:#2563eb;letter-spacing:1px;font-size:13px}
.rm-date{font-size:10px;color:#94a3b8;white-space:nowrap}
.rm-empty{text-align:center;color:#cbd5e1;padding:30px}
.rm-actions{display:flex;gap:4px}
.rm-act-btn{width:28px;height:28px;border-radius:8px;border:1px solid #e2e8f0;background:#fff;font-size:12px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .15s}
.rm-act-btn:hover{transform:scale(1.1)}
.rm-act-view:hover{background:#eff6ff;border-color:#3b82f6}
.rm-act-collect:hover{background:#ecfdf5;border-color:#10b981}
.rm-act-cancel:hover{background:#fef2f2;border-color:#ef4444}
/* Modal */
.rm-modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,0.4);display:flex;align-items:center;justify-content:center;z-index:999}
.rm-modal{background:#fff;border-radius:20px;padding:24px;width:620px;max-width:95%;max-height:85vh;overflow-y:auto;box-shadow:0 20px 60px rgba(0,0,0,0.2);animation:mIn .25s ease}
@keyframes mIn{from{opacity:0;transform:scale(0.95) translateY(10px)}to{opacity:1;transform:scale(1) translateY(0)}}
.rm-modal-h{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px}
.rm-modal-h h3{font-size:18px;font-weight:800;color:#0f172a}
.rm-modal-close{background:none;border:none;font-size:18px;cursor:pointer;color:#94a3b8}
.rm-detail-badge{margin-bottom:16px}
.rm-detail-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px;margin-bottom:16px}
.rm-detail-item{background:#f8fafc;border-radius:10px;padding:10px 14px}
.rm-detail-full{grid-column:1/-1}
.rm-detail-label{display:block;font-size:10px;font-weight:600;color:#94a3b8;margin-bottom:2px}
.rm-detail-val{font-size:13px;font-weight:700;color:#0f172a}
.rm-detail-amount{color:#059669;font-size:18px}
.rm-detail-syp{color:#d97706;font-size:16px}
.rm-detail-code{font-family:monospace;color:#2563eb;font-size:22px;letter-spacing:3px}
.rm-detail-actions{display:flex;gap:10px}
.rm-detail-btn{flex:1;padding:12px;border-radius:12px;font-size:14px;font-weight:700;border:none;cursor:pointer;transition:all .2s}
.rm-detail-btn-collect{background:#10b981;color:#fff}.rm-detail-btn-collect:hover{background:#059669}
.rm-detail-btn-cancel{background:#fef2f2;color:#dc2626;border:1px solid #fecaca}.rm-detail-btn-cancel:hover{background:#fee2e2}
@media(max-width:768px){.rm-kpis{grid-template-columns:repeat(2,1fr)}.rm-detail-grid{grid-template-columns:1fr}}
</style>
