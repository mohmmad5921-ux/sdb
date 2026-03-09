<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router, Link } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ business:Object, employees:Array, transactions:Array, invoices:Array, dailySales:Array, incomingPayments:Number, todaySales:Number });
const b = p.business;
const fc = n => (b.currency_symbol||'ل.س')+Number(n||0).toLocaleString('en',{minimumFractionDigits:2});
const f = n => Number(n||0).toLocaleString('en');
const stColor = s => ({active:'#10b981',pending:'#f59e0b',suspended:'#ef4444',rejected:'#94a3b8',completed:'#10b981',failed:'#ef4444',paid:'#10b981',draft:'#94a3b8',sent:'#3b82f6',cancelled:'#ef4444',overdue:'#dc2626'}[s]||'#64748b');
const stLabel = s => ({active:'نشط',pending:'معلّق',suspended:'موقوف',rejected:'مرفوض',completed:'ناجح',failed:'فشل',paid:'مدفوعة',draft:'مسودة',sent:'مرسلة',cancelled:'ملغية',overdue:'متأخرة'}[s]||s);
const roleLabel = r => ({owner:'مالك',admin:'مسؤول',manager:'مدير',accountant:'محاسب',employee:'موظف'}[r]||r);

// Limits form
const limits = ref({
  transfer_limit_daily: b.transfer_limit_daily,
  transfer_limit_monthly: b.transfer_limit_monthly,
  fee_percentage: b.fee_percentage,
  fee_fixed: b.fee_fixed
});
const saveLimits = () => router.post(route('admin.businesses.updateLimits', b.id), limits.value);

// Actions
const activate = () => { if(confirm('تفعيل الشركة؟')) router.post(route('admin.businesses.activate', b.id)); };
const suspend = () => { const r=prompt('سبب التعليق:'); if(r) router.post(route('admin.businesses.suspend', b.id), {reason:r}); };
const reject = () => { if(confirm('رفض الشركة؟')) router.post(route('admin.businesses.reject', b.id)); };
const freeze = () => { if(confirm('تجميد حساب الشركة؟')) router.post(route('admin.businesses.freeze', b.id)); };
const unfreeze = () => { if(confirm('إلغاء تجميد الحساب؟')) router.post(route('admin.businesses.unfreeze', b.id)); };
const notify = () => { const m=prompt('نص الإشعار:'); if(m) router.post(route('admin.businesses.notify', b.id), {message:m}); };
const removeEmp = id => { if(confirm('إزالة الموظف؟')) router.post(route('admin.businesses.removeEmployee', {business:b.id, employee:id})); };

const maxSales = () => Math.max(...(p.dailySales||[]).map(d=>d.total), 1);
</script>
<template>
<Head :title="b.business_name" />
<div class="bz">
  <div class="bz-top">
    <Link :href="route('admin.businesses.index')" class="bz-back">→ العودة</Link>
    <h1 class="bz-h">🏢 {{ b.business_name }}</h1>
    <span class="bz-st" :style="{color:stColor(b.status)}">{{ stLabel(b.status) }}</span>
  </div>

  <!-- Actions -->
  <div class="bz-actions">
    <button v-if="b.status!=='active'" @click="activate" class="bz-act bz-act-ok">✅ تفعيل</button>
    <button v-if="b.status==='active'" @click="suspend" class="bz-act bz-act-warn">⚠️ تعليق</button>
    <button v-if="b.status==='pending'" @click="reject" class="bz-act bz-act-danger">❌ رفض</button>
    <button v-if="b.status==='active'" @click="freeze" class="bz-act bz-act-danger">🧊 تجميد</button>
    <button v-if="b.status==='suspended'" @click="unfreeze" class="bz-act bz-act-ok">🔓 إلغاء التجميد</button>
    <button @click="notify" class="bz-act bz-act-info">📩 إشعار</button>
  </div>

  <div class="bz-grid">
    <!-- Company Info -->
    <div class="bz-card">
      <div class="bz-card-t">📋 معلومات الشركة</div>
      <div class="bz-info">
        <div class="bz-row"><span>الاسم العربي</span><strong>{{ b.business_name_ar||b.business_name }}</strong></div>
        <div class="bz-row"><span>السجل التجاري</span><strong>{{ b.commercial_register||'—' }}</strong></div>
        <div class="bz-row"><span>الرقم الضريبي</span><strong>{{ b.tax_number||'—' }}</strong></div>
        <div class="bz-row"><span>النشاط</span><strong>{{ b.category }}</strong></div>
        <div class="bz-row"><span>الحجم</span><strong>{{ ({small:'صغيرة',medium:'متوسطة',large:'كبيرة',enterprise:'عملاقة'}[b.size])||b.size }}</strong></div>
        <div class="bz-row"><span>المالك</span><strong>{{ b.owner_full_name||b.owner_name }}</strong></div>
        <div class="bz-row"><span>البريد</span><strong>{{ b.email }}</strong></div>
        <div class="bz-row"><span>الهاتف</span><strong>{{ b.phone||'—' }}</strong></div>
        <div class="bz-row"><span>العنوان</span><strong>{{ b.address||'—' }}, {{ b.city||'' }} - {{ b.country }}</strong></div>
        <div class="bz-row"><span>الموقع</span><strong><a v-if="b.website" :href="b.website" target="_blank">{{ b.website }}</a><span v-else>—</span></strong></div>
        <div class="bz-row" v-if="b.suspension_reason"><span>سبب التعليق</span><strong style="color:#ef4444">{{ b.suspension_reason }}</strong></div>
      </div>
    </div>

    <!-- Account & Balance -->
    <div class="bz-card">
      <div class="bz-card-t">💰 الحساب المصرفي</div>
      <div class="bz-info">
        <div class="bz-row"><span>رقم الحساب</span><strong class="bz-mono">{{ b.account_number||'—' }}</strong></div>
        <div class="bz-row"><span>IBAN</span><strong class="bz-mono">{{ b.iban||'—' }}</strong></div>
        <div class="bz-row"><span>العملة</span><strong>{{ b.currency_code||'SYP' }}</strong></div>
        <div class="bz-row"><span>حالة الحساب</span><strong :style="{color:stColor(b.account_status||'active')}">{{ stLabel(b.account_status||'active') }}</strong></div>
        <div class="bz-big"><div class="bz-big-l">الرصيد</div><div class="bz-big-v">{{ fc(b.balance||0) }}</div></div>
        <div class="bz-big"><div class="bz-big-l">الرصيد المتاح</div><div class="bz-big-v" style="color:#10b981">{{ fc(b.available_balance||0) }}</div></div>
        <div class="bz-big"><div class="bz-big-l">مبيعات اليوم</div><div class="bz-big-v" style="color:#2563eb">{{ fc(p.todaySales) }}</div></div>
        <div class="bz-big"><div class="bz-big-l">إجمالي المدفوعات المستلمة</div><div class="bz-big-v" style="color:#059669">{{ fc(p.incomingPayments) }}</div></div>
      </div>
    </div>
  </div>

  <!-- Limits & Fees -->
  <div class="bz-card" style="margin-top:16px">
    <div class="bz-card-t">⚙️ حدود التحويل والرسوم</div>
    <div class="bz-limits">
      <div class="bz-lim"><label>الحد اليومي</label><input v-model="limits.transfer_limit_daily" type="number" class="bz-linp"/></div>
      <div class="bz-lim"><label>الحد الشهري</label><input v-model="limits.transfer_limit_monthly" type="number" class="bz-linp"/></div>
      <div class="bz-lim"><label>نسبة الرسم %</label><input v-model="limits.fee_percentage" type="number" step="0.01" class="bz-linp"/></div>
      <div class="bz-lim"><label>رسم ثابت</label><input v-model="limits.fee_fixed" type="number" step="0.01" class="bz-linp"/></div>
      <button @click="saveLimits" class="bz-save">💾 حفظ</button>
    </div>
  </div>

  <!-- Daily Sales Chart -->
  <div class="bz-card" style="margin-top:16px" v-if="p.dailySales?.length">
    <div class="bz-card-t">📊 المبيعات اليومية (آخر 30 يوم)</div>
    <div class="bz-chart">
      <div v-for="d in p.dailySales" :key="d.day" class="bz-bar-w">
        <div class="bz-bar" :style="{height:(d.total/maxSales()*100)+'%'}"><span class="bz-bar-tip">{{ fc(d.total) }}</span></div>
        <div class="bz-bar-l">{{ d.day.slice(5) }}</div>
      </div>
    </div>
  </div>

  <!-- Employees -->
  <div class="bz-card" style="margin-top:16px">
    <div class="bz-card-t">👥 موظفو الشركة ({{ p.employees?.length||0 }})</div>
    <table class="bz-tbl"><thead><tr><th>الموظف</th><th>البريد</th><th>الهاتف</th><th>الدور</th><th>المنصب</th><th>الحالة</th><th>إجراء</th></tr></thead>
      <tbody><tr v-for="e in p.employees" :key="e.id">
        <td class="bz-bold">{{ e.full_name }}</td>
        <td>{{ e.email }}</td>
        <td>{{ e.phone_number||'—' }}</td>
        <td><span class="bz-tag">{{ roleLabel(e.role) }}</span></td>
        <td>{{ e.position||'—' }}</td>
        <td><span class="bz-st" :style="{color:stColor(e.status)}">{{ stLabel(e.status) }}</span></td>
        <td><button v-if="e.role!=='owner'" @click="removeEmp(e.id)" class="bz-act bz-act-danger" style="padding:4px 8px;font-size:10px">إزالة</button></td>
      </tr><tr v-if="!p.employees?.length"><td colspan="7" class="bz-empty">لا يوجد موظفين</td></tr></tbody>
    </table>
  </div>

  <!-- Invoices -->
  <div class="bz-card" style="margin-top:16px">
    <div class="bz-card-t">🧾 الفواتير ({{ p.invoices?.length||0 }})</div>
    <table class="bz-tbl"><thead><tr><th>رقم الفاتورة</th><th>العميل</th><th>المبلغ</th><th>الضريبة</th><th>الإجمالي</th><th>العملة</th><th>الحالة</th><th>التاريخ</th></tr></thead>
      <tbody><tr v-for="inv in p.invoices" :key="inv.id">
        <td class="bz-mono">{{ inv.invoice_number }}</td>
        <td>{{ inv.customer_name }}</td>
        <td>{{ f(inv.amount) }}</td>
        <td>{{ f(inv.tax_amount) }}</td>
        <td class="bz-bold">{{ f(inv.total_amount) }}</td>
        <td><span class="bz-tag">{{ inv.currency }}</span></td>
        <td><span class="bz-st" :style="{color:stColor(inv.status)}">{{ stLabel(inv.status) }}</span></td>
        <td class="bz-date">{{ new Date(inv.created_at).toLocaleDateString('ar') }}</td>
      </tr><tr v-if="!p.invoices?.length"><td colspan="8" class="bz-empty">لا توجد فواتير</td></tr></tbody>
    </table>
  </div>

  <!-- Transactions -->
  <div class="bz-card" style="margin-top:16px">
    <div class="bz-card-t">💸 آخر المعاملات ({{ p.transactions?.length||0 }})</div>
    <table class="bz-tbl"><thead><tr><th>#</th><th>النوع</th><th>المبلغ</th><th>الحالة</th><th>الوصف</th><th>التاريخ</th></tr></thead>
      <tbody><tr v-for="t in p.transactions" :key="t.id">
        <td class="bz-mono">{{ t.reference_number||t.id }}</td>
        <td><span class="bz-tag">{{ t.type }}</span></td>
        <td class="bz-bold">{{ fc(t.amount) }}</td>
        <td><span class="bz-st" :style="{color:stColor(t.status)}">{{ stLabel(t.status) }}</span></td>
        <td>{{ t.description||'—' }}</td>
        <td class="bz-date">{{ new Date(t.created_at).toLocaleDateString('ar') }}</td>
      </tr><tr v-if="!p.transactions?.length"><td colspan="6" class="bz-empty">لا توجد معاملات</td></tr></tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.bz{padding:24px;direction:rtl;max-width:1400px;margin:0 auto}
.bz-top{display:flex;align-items:center;gap:16px;margin-bottom:16px}
.bz-back{font-size:12px;color:#2563eb;text-decoration:none;font-weight:600;padding:6px 12px;background:#eff6ff;border-radius:8px}
.bz-h{font-size:22px;font-weight:900;color:#0f172a;flex:1}.bz-st{font-size:14px;font-weight:700}
.bz-actions{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:16px}
.bz-act{padding:8px 14px;border:none;border-radius:8px;font-size:12px;font-weight:700;cursor:pointer}
.bz-act-ok{background:#ecfdf5;color:#059669}.bz-act-warn{background:#fefce8;color:#ca8a04}.bz-act-danger{background:#fef2f2;color:#dc2626}.bz-act-info{background:#eff6ff;color:#2563eb}
.bz-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}
.bz-card{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9}
.bz-card-t{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:14px}
.bz-info{display:flex;flex-direction:column;gap:8px}
.bz-row{display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid #f8fafc;font-size:13px;color:#64748b}
.bz-row strong{color:#1e293b;font-weight:700}.bz-row strong a{color:#2563eb;text-decoration:none}
.bz-mono{font-family:monospace;font-size:11px;color:#64748b}
.bz-big{text-align:center;padding:12px;background:#f8fafc;border-radius:10px;margin-top:8px}
.bz-big-l{font-size:11px;color:#94a3b8;font-weight:600}.bz-big-v{font-size:22px;font-weight:900;color:#0f172a}
.bz-limits{display:flex;gap:12px;flex-wrap:wrap;align-items:flex-end}
.bz-lim{display:flex;flex-direction:column;gap:4px;flex:1;min-width:120px}
.bz-lim label{font-size:11px;color:#64748b;font-weight:600}
.bz-linp{padding:8px 10px;border:1.5px solid #e2e8f0;border-radius:8px;font-size:13px;outline:none}
.bz-save{padding:8px 20px;background:#2563eb;color:#fff;border:none;border-radius:8px;font-weight:700;cursor:pointer;font-size:12px;align-self:flex-end}
.bz-chart{display:flex;align-items:flex-end;gap:4px;height:160px;padding-top:20px}
.bz-bar-w{flex:1;display:flex;flex-direction:column;align-items:center;height:100%}
.bz-bar{background:linear-gradient(180deg,#3b82f6,#1d4ed8);border-radius:4px 4px 0 0;min-height:4px;width:100%;position:relative;transition:height .3s}
.bz-bar-tip{display:none;position:absolute;top:-22px;left:50%;transform:translateX(-50%);background:#0f172a;color:#fff;padding:2px 6px;border-radius:4px;font-size:8px;white-space:nowrap}.bz-bar:hover .bz-bar-tip{display:block}
.bz-bar-l{font-size:8px;color:#94a3b8;margin-top:3px}
.bz-tbl{width:100%;border-collapse:collapse}.bz-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:10px 10px;border-bottom:1px solid #f1f5f9}
.bz-tbl td{font-size:12px;color:#334155;padding:8px 10px;border-bottom:1px solid #f8fafc}
.bz-bold{font-weight:700;color:#0f172a}
.bz-tag{font-size:10px;background:#f1f5f9;padding:2px 8px;border-radius:5px;color:#64748b}
.bz-date{font-size:10px;color:#94a3b8}.bz-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px}
</style>
