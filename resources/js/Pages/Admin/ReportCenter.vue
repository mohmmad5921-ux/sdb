<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: AdminLayout });
const p = defineProps({ reports: Object });
const f = n => Number(n||0).toLocaleString('en');
const fc = n => '€'+Number(n||0).toLocaleString('en',{minimumFractionDigits:2});
</script>
<template>
<Head title="مركز التقارير" />
<div class="rc">
  <h1 class="rc-h">📑 مركز التقارير الاحترافية</h1>
  <div class="rc-grid">
    <!-- Profit -->
    <div class="rc-card"><div class="rc-ct">💹 الأرباح</div>
      <div class="rc-row"><span>إجمالي الرسوم المحصّلة</span><strong>{{ fc(p.reports.profit.total_fees) }}</strong></div>
      <div class="rc-row"><span>رسوم هذا الشهر</span><strong style="color:#059669">{{ fc(p.reports.profit.monthly_fees) }}</strong></div>
    </div>
    <!-- Transactions -->
    <div class="rc-card"><div class="rc-ct">💸 المعاملات</div>
      <div class="rc-row"><span>إجمالي المعاملات</span><strong>{{ f(p.reports.transactions.total) }}</strong></div>
      <div class="rc-row"><span>المكتملة</span><strong style="color:#10b981">{{ f(p.reports.transactions.completed) }}</strong></div>
      <div class="rc-row"><span>الحجم الكلي</span><strong>{{ fc(p.reports.transactions.volume) }}</strong></div>
    </div>
    <!-- Users -->
    <div class="rc-card"><div class="rc-ct">👥 المستخدمين</div>
      <div class="rc-row"><span>إجمالي المستخدمين</span><strong>{{ f(p.reports.users.total) }}</strong></div>
      <div class="rc-row"><span>موثّقين (KYC)</span><strong style="color:#10b981">{{ f(p.reports.users.verified) }}</strong></div>
      <div class="rc-row"><span>جدد هذا الشهر</span><strong style="color:#2563eb">{{ f(p.reports.users.new_month) }}</strong></div>
    </div>
    <!-- Cards -->
    <div class="rc-card"><div class="rc-ct">💳 البطاقات</div>
      <div class="rc-row"><span>إجمالي البطاقات</span><strong>{{ f(p.reports.cards.total) }}</strong></div>
      <div class="rc-row"><span>نشطة</span><strong style="color:#10b981">{{ f(p.reports.cards.active) }}</strong></div>
    </div>
    <!-- Fraud -->
    <div class="rc-card"><div class="rc-ct">🛡️ الاحتيال</div>
      <div class="rc-row"><span>إجمالي الحوادث</span><strong>{{ f(p.reports.fraud.total_incidents) }}</strong></div>
      <div class="rc-row"><span>مفتوحة</span><strong style="color:#ef4444">{{ f(p.reports.fraud.open) }}</strong></div>
    </div>
    <!-- AML -->
    <div class="rc-card"><div class="rc-ct">🏛️ مكافحة غسيل الأموال</div>
      <div class="rc-row"><span>إجمالي التقارير</span><strong>{{ f(p.reports.aml.total_reports) }}</strong></div>
      <div class="rc-row"><span>معلّقة</span><strong style="color:#f59e0b">{{ f(p.reports.aml.pending) }}</strong></div>
    </div>
    <!-- Support -->
    <div class="rc-card"><div class="rc-ct">🎧 الدعم الفني</div>
      <div class="rc-row"><span>إجمالي التذاكر</span><strong>{{ f(p.reports.support.total_tickets) }}</strong></div>
      <div class="rc-row"><span>مفتوحة</span><strong style="color:#f59e0b">{{ f(p.reports.support.open) }}</strong></div>
    </div>
    <!-- Fees by Type -->
    <div class="rc-card"><div class="rc-ct">🧾 الرسوم حسب النوع</div>
      <div v-for="f in p.reports.fees_by_type" :key="f.type" class="rc-row">
        <span class="rc-tag">{{ f.type }}</span><span><strong>{{ Number(f.count).toLocaleString('en') }}</strong> عملية — {{ fc(f.fees) }}</span>
      </div>
    </div>
  </div>
</div>
</template>
<style scoped>
.rc{padding:24px;direction:rtl}.rc-h{font-size:22px;font-weight:900;color:#0f172a;margin-bottom:20px}
.rc-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:14px}
.rc-card{background:#fff;border-radius:16px;padding:20px;border:1px solid #f1f5f9}
.rc-ct{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:12px;padding-bottom:8px;border-bottom:1px solid #f1f5f9}
.rc-row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid #f8fafc;font-size:13px;color:#475569}
.rc-row:last-child{border:none}.rc-row strong{color:#0f172a}
.rc-tag{font-size:10px;background:#f1f5f9;padding:2px 6px;border-radius:4px;color:#64748b;font-weight:600}
</style>
