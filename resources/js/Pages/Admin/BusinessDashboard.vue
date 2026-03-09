<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ stats:Object, bySize:Array, byCategory:Array, totalBalance:Number, todayVolume:Number, monthlyVolume:Number, invoiceStats:Object, totalEmployees:Number, recent:Array });
const f = n => Number(n||0).toLocaleString('en');
const fc = n => 'ل.س'+Number(n||0).toLocaleString('en',{minimumFractionDigits:2});
const stColor = s => ({active:'#10b981',pending:'#f59e0b',suspended:'#ef4444',rejected:'#94a3b8'}[s]||'#64748b');
const stLabel = s => ({active:'نشط',pending:'معلّق',suspended:'موقوف',rejected:'مرفوض'}[s]||s);
const szLabel = s => ({small:'صغيرة',medium:'متوسطة',large:'كبيرة',enterprise:'عملاقة'}[s]||s);
</script>
<template>
<Head title="لوحة الشركات" />
<div class="bd">
  <h1 class="bd-h">🏢 لوحة مراقبة الشركات</h1>

  <!-- Stats -->
  <div class="bd-kpis">
    <div class="bd-k"><div class="bd-k-ic" style="background:#eff6ff">🏢</div><div class="bd-k-b"><div class="bd-k-v">{{ f(p.stats.total) }}</div><div class="bd-k-l">إجمالي الشركات</div></div></div>
    <div class="bd-k"><div class="bd-k-ic" style="background:#ecfdf5">✅</div><div class="bd-k-b"><div class="bd-k-v" style="color:#10b981">{{ f(p.stats.active) }}</div><div class="bd-k-l">شركات نشطة</div></div></div>
    <div class="bd-k"><div class="bd-k-ic" style="background:#fefce8">⏳</div><div class="bd-k-b"><div class="bd-k-v" style="color:#ca8a04">{{ f(p.stats.pending) }}</div><div class="bd-k-l">بانتظار التفعيل</div></div></div>
    <div class="bd-k"><div class="bd-k-ic" style="background:#fef2f2">🚫</div><div class="bd-k-b"><div class="bd-k-v" style="color:#ef4444">{{ f(p.stats.suspended) }}</div><div class="bd-k-l">موقوفة</div></div></div>
    <div class="bd-k"><div class="bd-k-ic" style="background:#f0fdf4">💰</div><div class="bd-k-b"><div class="bd-k-v">{{ fc(p.totalBalance) }}</div><div class="bd-k-l">إجمالي أرصدة الشركات</div></div></div>
    <div class="bd-k"><div class="bd-k-ic" style="background:#fef3c7">📅</div><div class="bd-k-b"><div class="bd-k-v">{{ fc(p.todayVolume) }}</div><div class="bd-k-l">حجم معاملات اليوم</div></div></div>
    <div class="bd-k"><div class="bd-k-ic" style="background:#eff6ff">📆</div><div class="bd-k-b"><div class="bd-k-v">{{ fc(p.monthlyVolume) }}</div><div class="bd-k-l">حجم معاملات الشهر</div></div></div>
    <div class="bd-k"><div class="bd-k-ic" style="background:#f5f3ff">👥</div><div class="bd-k-b"><div class="bd-k-v">{{ f(p.totalEmployees) }}</div><div class="bd-k-l">إجمالي الموظفين</div></div></div>
  </div>

  <div class="bd-grid">
    <!-- By Size -->
    <div class="bd-card">
      <div class="bd-card-t">📊 حسب الحجم</div>
      <div class="bd-list">
        <div v-for="s in p.bySize" :key="s.size" class="bd-li">
          <span>{{ szLabel(s.size) }}</span><span class="bd-li-n">{{ f(s.count) }}</span>
        </div>
        <div v-if="!p.bySize?.length" class="bd-empty">لا توجد بيانات</div>
      </div>
    </div>

    <!-- By Category -->
    <div class="bd-card">
      <div class="bd-card-t">🏷️ حسب النشاط</div>
      <div class="bd-list">
        <div v-for="c in p.byCategory" :key="c.category" class="bd-li">
          <span>{{ c.category }}</span><span class="bd-li-n">{{ f(c.count) }}</span>
        </div>
        <div v-if="!p.byCategory?.length" class="bd-empty">لا توجد بيانات</div>
      </div>
    </div>

    <!-- Invoices -->
    <div class="bd-card">
      <div class="bd-card-t">🧾 الفواتير</div>
      <div class="bd-list">
        <div class="bd-li"><span>إجمالي الفواتير</span><span class="bd-li-n">{{ f(p.invoiceStats.total) }}</span></div>
        <div class="bd-li"><span>مدفوعة</span><span class="bd-li-n" style="color:#10b981">{{ f(p.invoiceStats.paid) }}</span></div>
        <div class="bd-li"><span>معلقة</span><span class="bd-li-n" style="color:#f59e0b">{{ f(p.invoiceStats.pending) }}</span></div>
        <div class="bd-li"><span>المبلغ المحصّل</span><span class="bd-li-n" style="color:#059669">{{ fc(p.invoiceStats.total_amount) }}</span></div>
      </div>
    </div>
  </div>

  <!-- Recent Businesses -->
  <div class="bd-card" style="margin-top:16px">
    <div class="bd-card-t">🆕 آخر الشركات المسجلة <Link :href="route('admin.businesses.index')" class="bd-link">عرض الكل ←</Link></div>
    <table class="bd-tbl"><thead><tr><th>الشركة</th><th>المالك</th><th>النشاط</th><th>الحجم</th><th>الحالة</th><th>التاريخ</th></tr></thead>
      <tbody><tr v-for="b in p.recent" :key="b.id">
        <td class="bd-bold"><Link :href="route('admin.businesses.show', b.id)">{{ b.business_name }}</Link></td>
        <td>{{ b.owner_full_name||b.owner_name }}</td>
        <td><span class="bd-tag">{{ b.category }}</span></td>
        <td>{{ szLabel(b.size) }}</td>
        <td><span class="bd-st" :style="{color:stColor(b.status)}">{{ stLabel(b.status) }}</span></td>
        <td class="bd-date">{{ new Date(b.created_at).toLocaleDateString('ar') }}</td>
      </tr><tr v-if="!p.recent?.length"><td colspan="6" class="bd-empty">لا توجد شركات</td></tr></tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.bd{padding:24px;direction:rtl;max-width:1400px;margin:0 auto}
.bd-h{font-size:24px;font-weight:900;color:#0f172a;margin-bottom:20px}
.bd-kpis{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:20px}
.bd-k{display:flex;align-items:center;gap:12px;background:#fff;border-radius:14px;padding:16px;border:1px solid #f1f5f9;transition:transform .15s}.bd-k:hover{transform:translateY(-2px);box-shadow:0 4px 12px rgba(0,0,0,.04)}
.bd-k-ic{width:42px;height:42px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
.bd-k-b{flex:1}.bd-k-v{font-size:20px;font-weight:900;color:#0f172a;line-height:1.2}.bd-k-l{font-size:11px;color:#94a3b8;font-weight:600;margin-top:2px}
.bd-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.bd-card{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9}
.bd-card-t{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:14px;display:flex;justify-content:space-between;align-items:center}
.bd-link{font-size:12px;color:#2563eb;text-decoration:none;font-weight:600}
.bd-list{display:flex;flex-direction:column;gap:6px}
.bd-li{display:flex;justify-content:space-between;padding:8px 12px;border-radius:8px;font-size:13px;color:#475569}.bd-li:hover{background:#f8fafc}
.bd-li-n{font-weight:700;color:#2563eb}
.bd-tbl{width:100%;border-collapse:collapse}.bd-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:10px 12px;border-bottom:1px solid #f1f5f9}
.bd-tbl td{font-size:12px;color:#334155;padding:10px 12px;border-bottom:1px solid #f8fafc}
.bd-bold{font-weight:700}.bd-bold a{color:#2563eb;text-decoration:none}
.bd-tag{font-size:10px;background:#f1f5f9;padding:2px 8px;border-radius:5px;color:#64748b}
.bd-st{font-size:11px;font-weight:700}
.bd-date{font-size:10px;color:#94a3b8}
.bd-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:20px}
</style>
