<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ transactions: Object, filters: Object });
const search = ref(props.filters?.search || '');
const typeFilter = ref(props.filters?.type || '');
const statusFilter = ref(props.filters?.status || '');
const applyFilter = () => router.get(route('admin.transactions'), { search: search.value, type: typeFilter.value, status: statusFilter.value }, { preserveState: true });

const statusBadge = { completed: 'at-badge-green', pending: 'at-badge-yellow', failed: 'at-badge-red', reversed: 'at-badge-orange' };
const typeLabels = { transfer: 'تحويل', deposit: 'إيداع', withdrawal: 'سحب', exchange: 'صرف عملات', card_payment: 'دفع بطاقة', card_topup: 'شحن بطاقة', fee: 'رسوم', refund: 'استرداد' };
const typeIcons = { transfer: '↗️', deposit: '💰', withdrawal: '📤', exchange: '💱', card_payment: '💳', fee: '📋', refund: '↩️' };
const fmt = (a, s = '€') => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + ' ' + s;

const totalCompleted = computed(() => (props.transactions?.data || []).filter(t => t.status === 'completed').reduce((s, t) => s + parseFloat(t.amount || 0), 0));
</script>

<template>
  <Head title="Transactions - المعاملات" />
  <AuthenticatedLayout>
    <div class="at-root">
      <div class="at-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-[#1A2B4A]">المعاملات المالية</h1>
            <p class="text-sm text-[#8896AB] mt-1">{{ transactions.total }} معاملة مسجلة</p>
          </div>
          <div class="flex gap-2">
            <Link :href="route('admin.dashboard')" class="at-back">← الرئيسية</Link>
          </div>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-6 py-6">
        <!-- Filters -->
        <div class="flex flex-wrap gap-3 mb-6">
          <input v-model="search" @keyup.enter="applyFilter" type="text" placeholder="بحث بالمرجع..." class="at-search" />
          <select v-model="typeFilter" @change="applyFilter" class="at-filter-select">
            <option value="">كل الأنواع</option>
            <option v-for="(label, key) in typeLabels" :key="key" :value="key">{{ label }}</option>
          </select>
          <select v-model="statusFilter" @change="applyFilter" class="at-filter-select">
            <option value="">كل الحالات</option>
            <option value="completed">مكتملة</option>
            <option value="pending">معلّقة</option>
            <option value="failed">فاشلة</option>
          </select>
        </div>

        <!-- Summary -->
        <div class="grid grid-cols-3 gap-4 mb-6">
          <div class="at-summary"><div class="text-xs text-[#8896AB]">إجمالي المعاملات</div><div class="text-2xl font-black text-[#1A2B4A]">{{ transactions.total }}</div></div>
          <div class="at-summary"><div class="text-xs text-[#8896AB]">المعروضة حالياً</div><div class="text-2xl font-black text-[#1E5EFF]">{{ (transactions.data || []).length }}</div></div>
          <div class="at-summary"><div class="text-xs text-[#8896AB]">إجمالي المكتملة (هذه الصفحة)</div><div class="text-2xl font-black text-emerald-600">{{ fmt(totalCompleted) }}</div></div>
        </div>

        <!-- Table -->
        <div class="at-card overflow-hidden">
          <div class="overflow-x-auto">
            <table class="at-table">
              <thead>
                <tr>
                  <th>المرجع</th><th>النوع</th><th>من</th><th>إلى</th><th>المبلغ</th><th class="text-center">الحالة</th><th>التاريخ</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="t in transactions.data" :key="t.id">
                  <td><span class="font-mono text-[#1E5EFF] text-xs">{{ t.reference_number }}</span></td>
                  <td><span class="at-type">{{ typeIcons[t.type] || '📄' }} {{ typeLabels[t.type] || t.type }}</span></td>
                  <td class="text-[#5A6B82]">{{ t.from_account?.user?.full_name || '—' }}</td>
                  <td class="text-[#5A6B82]">{{ t.to_account?.user?.full_name || '—' }}</td>
                  <td class="font-bold text-[#1A2B4A]">{{ fmt(t.amount, t.currency?.symbol) }}</td>
                  <td class="text-center"><span :class="statusBadge[t.status]" class="at-badge">{{ t.status }}</span></td>
                  <td class="text-[#8896AB] text-xs">{{ new Date(t.created_at).toLocaleString('en-GB') }}</td>
                </tr>
              </tbody>
            </table>
            <div v-if="!(transactions.data || []).length" class="py-12 text-center text-[#8896AB]">لا توجد معاملات</div>
          </div>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center gap-2 mt-6" v-if="transactions.last_page > 1">
          <Link v-for="link in transactions.links" :key="link.label" :href="link.url || '#'"
            :class="['at-page', link.active ? 'at-page-active' : '']" v-html="link.label" />
        </div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.at-root{min-height:100vh;background:#F0F2F5;direction:rtl}
.at-header{background:linear-gradient(135deg,#fff,#F8FAFC);border-bottom:1px solid #E8ECF1}
.at-back{padding:8px 18px;background:#F0F4FF;color:#1E5EFF;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(30,94,255,0.12)}.at-back:hover{background:#1E5EFF;color:#fff}
.at-search{width:320px;padding:10px 16px;border:1px solid #E8ECF1;border-radius:12px;background:#fff;font-size:13px;color:#1A2B4A;outline:none}.at-search:focus{border-color:#1E5EFF;box-shadow:0 0 0 3px rgba(30,94,255,0.08)}.at-search::placeholder{color:#8896AB}
.at-filter-select{padding:10px 14px;border:1px solid #E8ECF1;border-radius:12px;background:#fff;font-size:13px;color:#1A2B4A;outline:none;cursor:pointer}.at-filter-select:focus{border-color:#1E5EFF}
.at-summary{background:#fff;border:1px solid #E8ECF1;border-radius:14px;padding:16px 20px}
.at-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px}
.at-table{width:100%;border-collapse:collapse;font-size:13px}
.at-table th{text-align:right;padding:12px 16px;background:#FAFBFC;color:#8896AB;font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #E8ECF1}
.at-table td{padding:12px 16px;border-bottom:1px solid #F0F2F5;vertical-align:middle}
.at-table tr:hover td{background:#FAFBFC}
.at-type{display:inline-flex;align-items:center;gap:4px;font-size:12px;color:#5A6B82}
.at-badge{font-size:11px;padding:2px 10px;border-radius:100px;font-weight:600}
.at-badge-green{background:rgba(16,185,129,0.1);color:#059669}
.at-badge-yellow{background:rgba(245,158,11,0.1);color:#d97706}
.at-badge-red{background:rgba(239,68,68,0.1);color:#dc2626}
.at-badge-orange{background:rgba(249,115,22,0.1);color:#ea580c}
.at-page{padding:6px 14px;border-radius:8px;font-size:13px;background:#fff;color:#5A6B82;border:1px solid #E8ECF1;text-decoration:none}.at-page:hover{border-color:#1E5EFF;color:#1E5EFF}
.at-page-active{background:#1E5EFF!important;color:#fff!important;border-color:#1E5EFF!important}
</style>
