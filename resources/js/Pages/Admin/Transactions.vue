<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router, Link } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ transactions: Object, filters: Object, stats: Object });
const f = ref({...p.filters});
const apply = () => router.get(route('admin.transactions'), f.value, {preserveState:true});
const reset = () => { f.value={search:'',type:'',status:'',from_date:'',to_date:'',min_amount:'',max_amount:''}; apply(); };
const cancelTx = id => { if(confirm('إلغاء المعاملة؟')) router.post(route('admin.transactions.cancel', id)); };
const refundTx = id => { if(confirm('استرجاع المبلغ؟')) router.post(route('admin.transactions.refund', id)); };
const fc = n => '€'+Number(n||0).toLocaleString('en',{minimumFractionDigits:2});
const stColor = s => ({completed:'#10b981',failed:'#ef4444',pending:'#f59e0b',cancelled:'#94a3b8',refunded:'#8b5cf6'}[s]||'#64748b');
const stLabel = s => ({completed:'ناجح',failed:'فشل',pending:'معلّق',cancelled:'ملغي',refunded:'مسترجع'}[s]||s);
</script>
<template>
<Head title="المعاملات" />
<div class="tx">
  <h1 class="tx-h">💸 إدارة المعاملات</h1>

  <!-- Stats -->
  <div class="tx-stats">
    <div class="tx-s"><strong>{{ p.stats.total }}</strong> إجمالي</div>
    <div class="tx-s" style="color:#10b981"><strong>{{ p.stats.completed }}</strong> ناجحة</div>
    <div class="tx-s" style="color:#f59e0b"><strong>{{ p.stats.pending }}</strong> معلقة</div>
    <div class="tx-s" style="color:#ef4444"><strong>{{ p.stats.failed }}</strong> فاشلة</div>
    <div class="tx-s" style="color:#94a3b8"><strong>{{ p.stats.cancelled }}</strong> ملغية</div>
    <div class="tx-s" style="color:#059669"><strong>{{ fc(p.stats.totalVolume) }}</strong> الحجم الكلي</div>
    <div class="tx-s" style="color:#2563eb"><strong>{{ fc(p.stats.todayVolume) }}</strong> حجم اليوم</div>
  </div>

  <!-- Filters -->
  <div class="tx-filters">
    <input v-model="f.search" placeholder="🔍 بحث بالرقم المرجعي أو الوصف" class="tx-inp" style="flex:2"/>
    <select v-model="f.type" class="tx-inp"><option value="">كل الأنواع</option><option value="transfer">تحويل</option><option value="deposit">إيداع</option><option value="withdrawal">سحب</option><option value="internal">داخلي</option><option value="international">دولي</option><option value="exchange">صرف</option></select>
    <select v-model="f.status" class="tx-inp"><option value="">كل الحالات</option><option value="completed">ناجح</option><option value="pending">معلّق</option><option value="failed">فشل</option><option value="cancelled">ملغي</option><option value="refunded">مسترجع</option></select>
    <input v-model="f.from_date" type="date" class="tx-inp" placeholder="من"/>
    <input v-model="f.to_date" type="date" class="tx-inp" placeholder="إلى"/>
    <button @click="apply" class="tx-btn-f">بحث</button>
    <button @click="reset" class="tx-btn-r">مسح</button>
  </div>

  <!-- Exports -->
  <div class="tx-exports">
    <a :href="route('admin.export.transactions')+'?'+new URLSearchParams(f).toString()" class="tx-exp">📥 Excel</a>
  </div>

  <!-- Table -->
  <div class="tx-tbl-wrap">
  <table class="tx-tbl"><thead><tr><th>#</th><th>المرسل</th><th>المستلم</th><th>النوع</th><th>المبلغ</th><th>الحالة</th><th>التاريخ</th><th>إجراءات</th></tr></thead>
    <tbody><tr v-for="t in p.transactions.data" :key="t.id">
      <td class="tx-ref">{{ t.reference_number||t.id }}</td>
      <td>{{ t.from_account?.user?.name||'—' }}</td>
      <td>{{ t.to_account?.user?.name||'—' }}</td>
      <td><span class="tx-tag">{{ t.type }}</span></td>
      <td class="tx-bold">{{ fc(t.amount) }}</td>
      <td><span class="tx-st" :style="{color:stColor(t.status)}">{{ stLabel(t.status) }}</span></td>
      <td class="tx-date">{{ new Date(t.created_at).toLocaleString('ar') }}</td>
      <td class="tx-acts">
        <button v-if="t.status==='pending'" @click="cancelTx(t.id)" class="tx-act tx-act-r" title="إلغاء">✗</button>
        <button v-if="t.status==='completed'" @click="refundTx(t.id)" class="tx-act tx-act-p" title="استرجاع">↩</button>
      </td>
    </tr><tr v-if="!p.transactions.data?.length"><td colspan="8" class="tx-empty">لا توجد معاملات</td></tr></tbody>
  </table>
  </div>

  <!-- Pagination -->
  <div class="tx-pag" v-if="p.transactions.last_page>1">
    <Link v-for="link in p.transactions.links" :key="link.label" :href="link.url||''" class="tx-pag-l" :class="{active:link.active}" v-html="link.label" :preserveState="true"/>
  </div>
</div>
</template>
<style scoped>
.tx{padding:24px;direction:rtl}.tx-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:16px}
.tx-stats{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px}.tx-s{padding:8px 14px;background:#fff;border-radius:10px;border:1px solid #f1f5f9;font-size:12px;color:#64748b}.tx-s strong{font-size:16px;margin-left:4px}
.tx-filters{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px}.tx-inp{padding:9px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:12px;outline:none;flex:1;min-width:100px}
.tx-btn-f{padding:9px 16px;background:#2563eb;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:12px}.tx-btn-r{padding:9px 16px;background:#f1f5f9;color:#64748b;border:none;border-radius:10px;cursor:pointer;font-size:12px}
.tx-exports{margin-bottom:12px}.tx-exp{padding:6px 14px;background:#ecfdf5;color:#059669;border-radius:8px;font-size:11px;font-weight:600;text-decoration:none}
.tx-tbl-wrap{overflow-x:auto}.tx-tbl{width:100%;background:#fff;border-radius:16px;border-collapse:collapse;min-width:800px}
.tx-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:12px 12px;border-bottom:1px solid #f1f5f9}
.tx-tbl td{font-size:12px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}.tx-bold{font-weight:700;color:#0f172a}.tx-ref{font-family:monospace;font-size:10px;color:#64748b}
.tx-tag{font-size:10px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b}.tx-st{font-size:11px;font-weight:700}.tx-date{font-size:10px;color:#94a3b8}
.tx-acts{display:flex;gap:4px}.tx-act{width:28px;height:28px;border:1px solid #e2e8f0;border-radius:6px;background:#fff;cursor:pointer;font-size:12px;display:flex;align-items:center;justify-content:center}.tx-act-r{color:#ef4444;border-color:#fecaca}.tx-act-p{color:#8b5cf6;border-color:#c4b5fd}
.tx-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:30px}
.tx-pag{display:flex;gap:4px;margin-top:16px;justify-content:center}.tx-pag-l{padding:6px 12px;background:#fff;border:1px solid #e2e8f0;border-radius:8px;font-size:12px;color:#64748b;text-decoration:none}.tx-pag-l.active{background:#2563eb;color:#fff;border-color:#2563eb}
</style>
