<script setup>
import { Head, Link, useForm, router, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ accounts: Object, filters: Object, stats: Object, currencies: Array });
const flash = computed(() => usePage().props.flash || {});

const search = ref(props.filters?.search || '');
const statusFilter = ref(props.filters?.status || '');
const currencyFilter = ref(props.filters?.currency || '');
const applyFilter = () => router.get(route('admin.accounts'), { search: search.value, status: statusFilter.value || undefined, currency: currencyFilter.value || undefined }, { preserveState: true });

const adjustForm = useForm({ amount: '', type: 'credit', reason: '' });
const adjustingAccount = ref(null);
const openAdjust = (account) => { adjustingAccount.value = account; adjustForm.reset(); };
const submitAdjust = () => adjustForm.post(route('admin.accounts.adjust', adjustingAccount.value.id), { onSuccess: () => { adjustingAccount.value = null; adjustForm.reset(); } });
const updateStatus = (account, status) => { if (status === 'closed' && !confirm('هل أنت متأكد من إغلاق هذا الحساب نهائياً؟')) return; router.patch(route('admin.accounts.status', account.id), { status }); };

// Expandable detail
const expandedId = ref(null);
const toggleExpand = (id) => expandedId.value = expandedId.value === id ? null : id;

const statusBadge = { active: 'aa-badge-green', frozen: 'aa-badge-blue', closed: 'aa-badge-red' };
const fmt = (a, s = '€') => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + ' ' + s;
const fmtM = (a) => { if (a >= 1000000) return (a/1000000).toFixed(1) + 'M'; if (a >= 1000) return (a/1000).toFixed(1) + 'K'; return Number(a).toLocaleString('en-US',{minimumFractionDigits:2,maximumFractionDigits:2}); };
</script>

<template>
  <Head title="Accounts - الحسابات" />
  <AdminLayout title="🏦 إدارة الحسابات">
    <div class="aa-root">
      <div class="aa-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <div><h1 class="text-2xl font-bold text-[#f1f5f9]">🏦 إدارة الحسابات المصرفية</h1><p class="text-sm text-[#94a3b8] mt-1">{{ accounts.total }} حساب مسجل — تحكم شامل بالأرصدة والحالات</p></div>
          <Link :href="route('admin.dashboard')" class="aa-back">← الرئيسية</Link>
        </div>
      </div>

      <div v-if="flash.success" class="max-w-7xl mx-auto px-6 mt-4"><div class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-3 text-emerald-700 text-sm">✓ {{ flash.success }}</div></div>

      <div class="max-w-7xl mx-auto px-6 py-6 space-y-6">
        <!-- Stats Row -->
        <div class="grid grid-cols-5 gap-3">
          <div class="aa-stat"><div class="text-2xl font-black text-[#f1f5f9]">{{ stats.total }}</div><div class="text-[10px] text-[#94a3b8] mt-1">إجمالي الحسابات</div></div>
          <button @click="statusFilter = statusFilter === 'active' ? '' : 'active'; applyFilter()" :class="{'aa-stat-active': statusFilter === 'active'}" class="aa-stat"><div class="text-2xl font-black text-emerald-600">{{ stats.active }}</div><div class="text-[10px] text-[#94a3b8] mt-1">✅ نشط</div></button>
          <button @click="statusFilter = statusFilter === 'frozen' ? '' : 'frozen'; applyFilter()" :class="{'aa-stat-active-blue': statusFilter === 'frozen'}" class="aa-stat"><div class="text-2xl font-black text-[#1E5EFF]">{{ stats.frozen }}</div><div class="text-[10px] text-[#94a3b8] mt-1">❄️ مجمّد</div></button>
          <button @click="statusFilter = statusFilter === 'closed' ? '' : 'closed'; applyFilter()" :class="{'aa-stat-active-red': statusFilter === 'closed'}" class="aa-stat"><div class="text-2xl font-black text-red-500">{{ stats.closed }}</div><div class="text-[10px] text-[#94a3b8] mt-1">🔒 مغلق</div></button>
          <div class="aa-stat"><div class="text-2xl font-black text-emerald-600">{{ fmtM(stats.total_balance_eur) }}€</div><div class="text-[10px] text-[#94a3b8] mt-1">💰 إجمالي الأرصدة</div></div>
        </div>

        <!-- Filters -->
        <div class="flex items-center gap-3 flex-wrap">
          <input v-model="search" @keyup.enter="applyFilter" type="text" placeholder="بحث بالاسم، IBAN، رقم الحساب، رقم العميل..." class="aa-search" />
          <select v-model="currencyFilter" @change="applyFilter" class="aa-filter-select">
            <option value="">كل العملات</option>
            <option v-for="c in currencies" :key="c" :value="c">{{ c }}</option>
          </select>
          <button v-if="search || statusFilter || currencyFilter" @click="search=''; statusFilter=''; currencyFilter=''; applyFilter()" class="aa-clear-btn">✕ مسح الفلاتر</button>
        </div>

        <!-- Table -->
        <div class="aa-card overflow-hidden">
          <div class="overflow-x-auto">
            <table class="aa-table">
              <thead><tr><th>العميل</th><th>رقم الحساب</th><th>IBAN</th><th>العملة</th><th>الرصيد</th><th class="text-center">الحالة</th><th class="text-center">إجراءات</th></tr></thead>
              <tbody>
                <template v-for="a in accounts.data" :key="a.id">
                  <tr @click="toggleExpand(a.id)" class="cursor-pointer">
                    <td>
                      <div class="flex items-center gap-3">
                        <div class="aa-avatar">{{ a.user?.full_name?.charAt(0) }}</div>
                        <div>
                          <div class="text-sm font-semibold text-[#f1f5f9]">{{ a.user?.full_name }}</div>
                          <div class="text-xs text-[#94a3b8]">{{ a.user?.email }}</div>
                          <div class="text-[10px] font-mono text-[#1E5EFF]">{{ a.user?.customer_number }}</div>
                        </div>
                      </div>
                    </td>
                    <td class="font-mono text-sm text-[#f1f5f9]">{{ a.account_number }}</td>
                    <td class="font-mono text-xs text-[#94a3b8]">{{ a.iban }}</td>
                    <td><span class="text-lg">{{ a.currency?.symbol }}</span> <span class="text-sm text-[#cbd5e1]">{{ a.currency?.code }}</span></td>
                    <td class="font-bold text-[#f1f5f9] text-lg">{{ fmt(a.balance, a.currency?.symbol) }}</td>
                    <td class="text-center"><span :class="statusBadge[a.status]" class="aa-badge">{{ a.status === 'active' ? 'نشط' : a.status === 'frozen' ? 'مجمّد' : 'مغلق' }}</span></td>
                    <td class="text-center" @click.stop>
                      <div class="flex justify-center gap-1">
                        <button @click="openAdjust(a)" class="aa-act aa-act-yellow">💰 تعديل رصيد</button>
                        <button v-if="a.status==='active'" @click="updateStatus(a,'frozen')" class="aa-act aa-act-blue">❄️ تجميد</button>
                        <button v-if="a.status==='frozen'" @click="updateStatus(a,'active')" class="aa-act aa-act-green">✅ تفعيل</button>
                        <button v-if="a.status!=='closed'" @click="updateStatus(a,'closed')" class="aa-act aa-act-red">🔒 إغلاق</button>
                        <Link :href="route('admin.users.show', a.user?.id)" class="aa-act aa-act-purple">👤 العميل</Link>
                      </div>
                    </td>
                  </tr>
                  <!-- Expanded Detail Row -->
                  <tr v-if="expandedId === a.id" class="aa-expanded-row">
                    <td colspan="7">
                      <div class="p-4 bg-[#1e293b] rounded-xl border border-[#334155] mx-2 my-1">
                        <div class="grid grid-cols-4 gap-4 text-sm">
                          <div><span class="text-[#94a3b8] block text-xs mb-1">رقم الحساب</span><span class="font-mono font-bold text-[#f1f5f9]">{{ a.account_number }}</span></div>
                          <div><span class="text-[#94a3b8] block text-xs mb-1">IBAN</span><span class="font-mono text-[#f1f5f9] text-xs">{{ a.iban }}</span></div>
                          <div><span class="text-[#94a3b8] block text-xs mb-1">العملة</span><span class="text-[#f1f5f9]">{{ a.currency?.name_ar || a.currency?.name }} ({{ a.currency?.code }})</span></div>
                          <div><span class="text-[#94a3b8] block text-xs mb-1">تاريخ الإنشاء</span><span class="text-[#f1f5f9]">{{ new Date(a.created_at).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', year: 'numeric' }) }}</span></div>
                          <div><span class="text-[#94a3b8] block text-xs mb-1">الرصيد بالعملة الأصلية</span><span class="font-bold text-lg text-[#f1f5f9]">{{ fmt(a.balance, a.currency?.symbol) }}</span></div>
                          <div><span class="text-[#94a3b8] block text-xs mb-1">الرصيد تقريباً (EUR)</span><span class="font-bold text-lg text-emerald-600">{{ fmt(a.balance * (a.currency?.exchange_rate_to_eur || 1)) }}</span></div>
                          <div><span class="text-[#94a3b8] block text-xs mb-1">سعر الصرف للعميل</span><span class="text-[#f1f5f9] font-mono">1 {{ a.currency?.code }} = {{ a.currency?.exchange_rate_to_eur || 1 }} EUR</span></div>
                          <div><span class="text-[#94a3b8] block text-xs mb-1">الحالة</span><span :class="statusBadge[a.status]" class="aa-badge">{{ a.status }}</span></div>
                        </div>
                      </div>
                    </td>
                  </tr>
                </template>
              </tbody>
            </table>
          </div>
        </div>

        <div class="flex justify-center gap-2 mt-6" v-if="accounts.last_page > 1">
          <Link v-for="link in accounts.links" :key="link.label" :href="link.url || '#'" :class="['aa-pg', link.active ? 'aa-pg-act' : '']" v-html="link.label" />
        </div>
      </div>

      <!-- Adjust Modal -->
      <Teleport to="body">
        <div v-if="adjustingAccount" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm" @click.self="adjustingAccount = null">
          <div class="bg-[#1e293b] rounded-2xl w-full max-w-md p-6 shadow-2xl border border-[#334155]" style="direction:rtl">
            <h3 class="text-xl font-bold text-[#f1f5f9] mb-1">💰 تعديل رصيد</h3>
            <p class="text-[#94a3b8] text-sm mb-2">{{ adjustingAccount.user?.full_name }} — {{ adjustingAccount.currency?.code }}</p>
            <div class="p-3 bg-[#F0F4FF] rounded-xl mb-4 text-sm"><span class="text-[#94a3b8]">الرصيد الحالي: </span><span class="font-bold text-[#1E5EFF]">{{ fmt(adjustingAccount.balance, adjustingAccount.currency?.symbol) }}</span></div>
            <form @submit.prevent="submitAdjust" class="space-y-4">
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-[#94a3b8] mb-1">النوع</label><select v-model="adjustForm.type" class="aa-modal-input"><option value="credit">➕ إضافة (Credit)</option><option value="debit">➖ خصم (Debit)</option></select></div>
                <div><label class="block text-xs text-[#94a3b8] mb-1">المبلغ</label><input v-model="adjustForm.amount" type="number" step="0.01" min="0.01" class="aa-modal-input" required /></div>
              </div>
              <div><label class="block text-xs text-[#94a3b8] mb-1">السبب</label><input v-model="adjustForm.reason" required placeholder="سبب التعديل (مطلوب)..." class="aa-modal-input" /></div>
              <div v-if="adjustForm.type === 'debit' && adjustForm.amount > adjustingAccount.balance" class="p-2 bg-red-50 border border-red-200 rounded-lg text-xs text-red-600">⚠️ المبلغ أكبر من الرصيد الحالي!</div>
              <p v-if="adjustForm.errors.amount" class="text-red-500 text-xs">{{ adjustForm.errors.amount }}</p>
              <div class="flex gap-3"><button type="submit" :disabled="adjustForm.processing" class="flex-1 bg-[#1E5EFF] hover:bg-[#1047b8] text-white py-3 rounded-xl font-semibold disabled:opacity-50">تطبيق</button><button type="button" @click="adjustingAccount = null" class="flex-1 bg-[#0f172a] text-[#cbd5e1] py-3 rounded-xl">إلغاء</button></div>
            </form>
          </div>
        </div>
      </Teleport>
    </div>
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
@import '../../../css/admin.css';
.aa-root{min-height:100vh;background:#0f172a;direction:rtl}
.aa-header{background:#1e293b;border-bottom:1px solid #334155}
.aa-back{padding:8px 18px;background:#1e293b;color:#3b82f6;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(16,185,129,0.2)}.aa-back:hover{background:#10b981;color:#fff}
.aa-stat{background:#1e293b;border:2px solid #E8ECF1;border-radius:14px;padding:16px;text-align:center;cursor:pointer;transition:all .2s}.aa-stat:hover{border-color:#10b981}
.aa-stat-active{border-color:#10b981!important;background:rgba(16,185,129,0.03)}.aa-stat-active-blue{border-color:#10b981!important;background:rgba(30,94,255,0.03)}.aa-stat-active-red{border-color:#ef4444!important;background:rgba(239,68,68,0.03)}
.aa-search{width:380px;padding:10px 16px;border:1px solid #334155;border-radius:12px;background:#1e293b;font-size:13px;color:#f1f5f9;outline:none}.aa-search:focus{border-color:#10b981;box-shadow:0 0 0 3px rgba(16,185,129,0.1)}.aa-search::placeholder{color:#94a3b8}
.aa-filter-select{padding:10px 16px;border:1px solid #334155;border-radius:12px;background:#1e293b;font-size:13px;color:#f1f5f9;outline:none;min-width:140px}.aa-filter-select:focus{border-color:#10b981}
.aa-clear-btn{padding:8px 14px;border:1px solid rgba(239,68,68,0.2);border-radius:10px;font-size:12px;font-weight:600;color:#dc2626;background:rgba(239,68,68,0.05);cursor:pointer}.aa-clear-btn:hover{background:rgba(239,68,68,0.1)}
.aa-card{background:#1e293b;border:1px solid #334155;border-radius:16px}
.aa-table{width:100%;border-collapse:collapse;font-size:13px}
.aa-table th{text-align:right;padding:12px 16px;background:#1e293b;color:#94a3b8;font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #334155}
.aa-table td{padding:14px 16px;border-bottom:1px solid #1e293b;vertical-align:middle}
.aa-table tr:hover td{background:#1e293b}
.aa-expanded-row td{background:#1e293b!important;padding:0!important;border:none!important}
.aa-avatar{width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,#3b82f6,#1d4ed8);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:13px;flex-shrink:0}
.aa-badge{font-size:11px;padding:2px 10px;border-radius:100px;font-weight:600}
.aa-badge-green{background:rgba(16,185,129,0.1);color:#059669}.aa-badge-blue{background:rgba(59,130,246,0.15);color:#3b82f6}.aa-badge-red{background:rgba(239,68,68,0.1);color:#dc2626}
.aa-act{font-size:11px;padding:4px 10px;border-radius:8px;font-weight:600;cursor:pointer;border:1px solid transparent;transition:all .2s;text-decoration:none}
.aa-act-yellow{background:rgba(245,158,11,0.08);color:#d97706;border-color:rgba(245,158,11,0.15)}.aa-act-yellow:hover{background:rgba(245,158,11,0.15)}
.aa-act-blue{background:rgba(16,185,129,0.1);color:#3b82f6;border-color:rgba(30,94,255,0.15)}.aa-act-blue:hover{background:rgba(30,94,255,0.15)}
.aa-act-green{background:rgba(16,185,129,0.08);color:#059669;border-color:rgba(16,185,129,0.15)}.aa-act-green:hover{background:rgba(16,185,129,0.15)}
.aa-act-red{background:rgba(239,68,68,0.08);color:#dc2626;border-color:rgba(239,68,68,0.15)}.aa-act-red:hover{background:rgba(239,68,68,0.15)}
.aa-act-purple{background:rgba(139,92,246,0.08);color:#8b5cf6;border-color:rgba(139,92,246,0.15)}.aa-act-purple:hover{background:rgba(139,92,246,0.15)}
.aa-modal-input{width:100%;border:1px solid #334155;border-radius:12px;padding:10px 14px;font-size:13px;color:#f1f5f9;outline:none}.aa-modal-input:focus{border-color:#10b981}
.aa-pg{padding:6px 14px;border-radius:8px;font-size:13px;background:#1e293b;color:#cbd5e1;border:1px solid #334155;text-decoration:none}.aa-pg:hover{border-color:#10b981;color:#3b82f6}
.aa-pg-act{background:#10b981!important;color:#fff!important;border-color:#10b981!important}
</style>
