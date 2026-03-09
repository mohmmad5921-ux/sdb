<script setup>
import { Head, Link, useForm, router } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref } from 'vue';

const props = defineProps({ currencies: Array, exchangeRates: Array });
const showAddModal = ref(false);
const showRateModal = ref(false);

const form = useForm({ code: '', name: '', name_ar: '', symbol: '', type: 'fiat', exchange_rate_to_eur: 1, is_active: true, decimal_places: 2 });
const rateForm = useForm({ from_currency_id: '', to_currency_id: '', rate: '', buy_rate: '', sell_rate: '', spread: 0.5 });

const addCurrency = () => form.post(route('admin.currencies.store'), { onSuccess: () => { showAddModal.value = false; form.reset(); } });
const updateRate = () => rateForm.post(route('admin.exchange-rates.update'), { onSuccess: () => { showRateModal.value = false; rateForm.reset(); } });
const toggleActive = (c) => router.patch(route('admin.currencies.update', c.id), { is_active: !c.is_active });
</script>

<template>
  <Head title="Currencies - العملات" />
  <AdminLayout title="💱 إدارة العملات">
    <div class="cu-root">
      <div class="cu-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <h1 class="text-2xl font-bold text-[#f1f5f9]">إدارة العملات وأسعار الصرف</h1>
          <div class="flex gap-2">
            <button @click="showAddModal = true" class="cu-btn-blue">+ عملة جديدة</button>
            <button @click="showRateModal = true" class="cu-btn-green">📊 تحديث سعر صرف</button>
            <Link :href="route('admin.dashboard')" class="cu-back">← الرئيسية</Link>
          </div>
        </div>
      </div>
      <div class="max-w-7xl mx-auto px-6 py-6 space-y-6">
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
          <div v-for="c in currencies" :key="c.id" class="cu-currency-card">
            <div class="flex items-center justify-between mb-2">
              <span class="text-3xl">{{ c.symbol }}</span>
              <button @click="toggleActive(c)" :class="c.is_active ? 'cu-active-badge' : 'cu-inactive-badge'">{{ c.is_active ? 'نشطة' : 'معطّلة' }}</button>
            </div>
            <div class="text-lg font-bold text-[#f1f5f9]">{{ c.code }}</div>
            <div class="text-sm text-[#94a3b8]">{{ c.name_ar }}</div>
            <div class="text-xs text-[#94a3b8] mt-1">{{ c.type === 'crypto' ? '🪙 كريبتو' : '🏦 فيات' }}</div>
            <div class="text-xs text-[#94a3b8] mt-0.5">{{ c.accounts_count || 0 }} حساب</div>
            <div class="text-xs text-[#1E5EFF] font-mono mt-1">1 = {{ c.exchange_rate_to_eur }} EUR</div>
          </div>
        </div>
        <div class="cu-card overflow-hidden">
          <div class="px-6 py-4 border-b border-[#334155]"><h3 class="font-bold text-[#f1f5f9]">أسعار الصرف</h3></div>
          <table class="cu-table">
            <thead><tr><th>من</th><th>إلى</th><th>السعر</th><th>شراء</th><th>بيع</th><th>هامش</th></tr></thead>
            <tbody>
              <tr v-for="r in exchangeRates" :key="r.id">
                <td class="font-semibold text-[#f1f5f9]">{{ r.from_currency?.code }}</td>
                <td class="font-semibold text-[#f1f5f9]">{{ r.to_currency?.code }}</td>
                <td class="font-mono text-[#1E5EFF]">{{ Number(r.rate).toFixed(4) }}</td>
                <td class="font-mono">{{ Number(r.buy_rate).toFixed(4) }}</td>
                <td class="font-mono">{{ Number(r.sell_rate).toFixed(4) }}</td>
                <td>{{ r.spread }}%</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Add Currency Modal -->
      <Teleport to="body">
        <div v-if="showAddModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm" @click.self="showAddModal = false">
          <div class="bg-[#1e293b] rounded-2xl w-full max-w-md p-6 shadow-2xl border border-[#334155]" style="direction:rtl">
            <h3 class="text-xl font-bold text-[#f1f5f9] mb-5">إضافة عملة جديدة</h3>
            <form @submit.prevent="addCurrency" class="space-y-4">
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-[#94a3b8] mb-1">الرمز</label><input v-model="form.code" placeholder="BTC" class="cu-input" /></div>
                <div><label class="block text-xs text-[#94a3b8] mb-1">الرمز المالي</label><input v-model="form.symbol" placeholder="₿" class="cu-input" /></div>
              </div>
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-[#94a3b8] mb-1">الاسم (EN)</label><input v-model="form.name" class="cu-input" /></div>
                <div><label class="block text-xs text-[#94a3b8] mb-1">الاسم (AR)</label><input v-model="form.name_ar" class="cu-input" /></div>
              </div>
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-[#94a3b8] mb-1">النوع</label><select v-model="form.type" class="cu-input"><option value="fiat">فيات</option><option value="crypto">كريبتو</option></select></div>
                <div><label class="block text-xs text-[#94a3b8] mb-1">سعر الصرف لليورو</label><input v-model="form.exchange_rate_to_eur" type="number" step="0.00000001" class="cu-input" /></div>
              </div>
              <div class="flex gap-3"><button type="submit" :disabled="form.processing" class="flex-1 bg-[#1E5EFF] hover:bg-[#1047b8] text-white py-3 rounded-xl font-semibold disabled:opacity-50">إضافة</button><button type="button" @click="showAddModal = false" class="flex-1 bg-[#0f172a] text-[#cbd5e1] py-3 rounded-xl">إلغاء</button></div>
            </form>
          </div>
        </div>
      </Teleport>

      <!-- Rate Modal -->
      <Teleport to="body">
        <div v-if="showRateModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm" @click.self="showRateModal = false">
          <div class="bg-[#1e293b] rounded-2xl w-full max-w-md p-6 shadow-2xl border border-[#334155]" style="direction:rtl">
            <h3 class="text-xl font-bold text-[#f1f5f9] mb-5">تحديث سعر الصرف</h3>
            <form @submit.prevent="updateRate" class="space-y-4">
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-[#94a3b8] mb-1">من عملة</label><select v-model="rateForm.from_currency_id" class="cu-input"><option v-for="c in currencies" :key="c.id" :value="c.id">{{ c.code }}</option></select></div>
                <div><label class="block text-xs text-[#94a3b8] mb-1">إلى عملة</label><select v-model="rateForm.to_currency_id" class="cu-input"><option v-for="c in currencies" :key="c.id" :value="c.id">{{ c.code }}</option></select></div>
              </div>
              <div><label class="block text-xs text-[#94a3b8] mb-1">السعر الأساسي</label><input v-model="rateForm.rate" type="number" step="0.0001" class="cu-input" /></div>
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-[#94a3b8] mb-1">سعر الشراء</label><input v-model="rateForm.buy_rate" type="number" step="0.0001" class="cu-input" /></div>
                <div><label class="block text-xs text-[#94a3b8] mb-1">سعر البيع</label><input v-model="rateForm.sell_rate" type="number" step="0.0001" class="cu-input" /></div>
              </div>
              <div class="flex gap-3"><button type="submit" :disabled="rateForm.processing" class="flex-1 bg-[#10b981] hover:bg-[#059669] text-white py-3 rounded-xl font-semibold disabled:opacity-50">تحديث</button><button type="button" @click="showRateModal = false" class="flex-1 bg-[#0f172a] text-[#cbd5e1] py-3 rounded-xl">إلغاء</button></div>
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
.cu-root{min-height:100vh;background:#0f172a;direction:rtl}
.cu-header{background:#1e293b;border-bottom:1px solid #334155}
.cu-back{padding:8px 18px;background:#1e293b;color:#3b82f6;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(16,185,129,0.2)}.cu-back:hover{background:#10b981;color:#fff}
.cu-btn-blue{padding:8px 18px;background:#10b981;color:#fff;border-radius:10px;font-size:13px;font-weight:600;border:none;cursor:pointer}.cu-btn-blue:hover{background:#1047b8}
.cu-btn-green{padding:8px 18px;background:#10b981;color:#fff;border-radius:10px;font-size:13px;font-weight:600;border:none;cursor:pointer}.cu-btn-green:hover{background:#059669}
.cu-currency-card{background:#1e293b;border:1px solid #334155;border-radius:16px;padding:16px;transition:all .25s}.cu-currency-card:hover{border-color:#10b981;transform:translateY(-2px);box-shadow:0 6px 20px rgba(16,185,129,0.1)}
.cu-active-badge{font-size:10px;padding:2px 8px;border-radius:100px;background:rgba(16,185,129,0.1);color:#059669;font-weight:600;border:none;cursor:pointer}
.cu-inactive-badge{font-size:10px;padding:2px 8px;border-radius:100px;background:rgba(239,68,68,0.1);color:#dc2626;font-weight:600;border:none;cursor:pointer}
.cu-card{background:#1e293b;border:1px solid #334155;border-radius:16px}
.cu-table{width:100%;border-collapse:collapse;font-size:13px}
.cu-table th{text-align:right;padding:12px 16px;background:#1e293b;color:#94a3b8;font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #334155}
.cu-table td{padding:12px 16px;border-bottom:1px solid #1e293b;vertical-align:middle;color:#cbd5e1}
.cu-table tr:hover td{background:#1e293b}
.cu-input{width:100%;border:1px solid #334155;border-radius:12px;padding:10px 14px;font-size:13px;color:#f1f5f9;outline:none}.cu-input:focus{border-color:#10b981}
</style>
