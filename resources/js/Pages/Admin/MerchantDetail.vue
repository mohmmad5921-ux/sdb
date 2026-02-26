<script setup>
import { Head, Link, usePage, router, useForm } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref } from 'vue';

const props = defineProps({ merchant: Object, apiKeys: Array, sessions: Object });
const flash = usePage().props.flash || {};

const editForm = useForm({
  business_name: props.merchant.business_name, business_name_ar: props.merchant.business_name_ar || '',
  business_email: props.merchant.business_email, business_phone: props.merchant.business_phone || '',
  website_url: props.merchant.website_url || '', fee_percentage: props.merchant.fee_percentage,
  fee_fixed: props.merchant.fee_fixed || 0, status: props.merchant.status,
});
const saveChanges = () => editForm.patch(route('admin.merchants.update', props.merchant.id));
const generateKey = () => router.post(route('admin.merchants.api-key', props.merchant.id));
const revokeKey = (keyId) => router.delete(route('admin.api-keys.revoke', keyId));

const statusBadge = { active: 'md-badge-green', pending: 'md-badge-yellow', suspended: 'md-badge-red', rejected: 'md-badge-red' };
const sessionBadge = { pending: 'md-badge-yellow', paid: 'md-badge-green', failed: 'md-badge-red', expired: 'md-badge-gray', refunded: 'md-badge-orange' };
</script>

<template>
  <Head :title="`Merchant: ${merchant.business_name}`" />
  <AuthenticatedLayout>
    <div class="md-root">
      <div class="md-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <div><h1 class="text-2xl font-bold text-[#1A2B4A]">🏪 {{ merchant.business_name }}</h1><p class="text-sm text-[#8896AB] mt-1">{{ merchant.business_name_ar || merchant.business_email }}</p></div>
          <Link :href="route('admin.merchants')" class="md-back">← التجار</Link>
        </div>
      </div>
      <div v-if="flash.success" class="max-w-7xl mx-auto px-6 mt-4"><div class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-3 text-emerald-700 text-sm">✓ {{ flash.success }}</div></div>
      <div class="max-w-7xl mx-auto px-6 py-6 space-y-6">
        <!-- Stats -->
        <div class="grid grid-cols-3 gap-4">
          <div class="md-stat"><div class="text-xs text-[#8896AB]">إجمالي الحجم</div><div class="text-2xl font-black text-emerald-600 mt-1">{{ Number(merchant.total_volume).toLocaleString() }}</div></div>
          <div class="md-stat"><div class="text-xs text-[#8896AB]">عدد المعاملات</div><div class="text-2xl font-black text-[#1E5EFF] mt-1">{{ merchant.total_transactions }}</div></div>
          <div class="md-stat"><div class="text-xs text-[#8896AB]">عملة التسوية</div><div class="text-2xl font-black text-[#1A2B4A] mt-1">{{ merchant.settlement_currency }}</div></div>
        </div>
        <div class="grid md:grid-cols-2 gap-6">
          <!-- Edit -->
          <div class="md-card">
            <div class="md-card-header"><h3 class="font-bold text-[#1A2B4A]">بيانات التاجر</h3></div>
            <div class="p-5">
              <form @submit.prevent="saveChanges" class="space-y-3">
                <div class="grid grid-cols-2 gap-3">
                  <div><label class="block text-xs text-[#8896AB] mb-1">الاسم EN</label><input v-model="editForm.business_name" class="md-input" /></div>
                  <div><label class="block text-xs text-[#8896AB] mb-1">الاسم AR</label><input v-model="editForm.business_name_ar" class="md-input" /></div>
                </div>
                <div class="grid grid-cols-2 gap-3">
                  <div><label class="block text-xs text-[#8896AB] mb-1">البريد</label><input v-model="editForm.business_email" class="md-input" /></div>
                  <div><label class="block text-xs text-[#8896AB] mb-1">الحالة</label><select v-model="editForm.status" class="md-input"><option value="active">نشط</option><option value="pending">معلّق</option><option value="suspended">موقوف</option><option value="rejected">مرفوض</option></select></div>
                </div>
                <div class="grid grid-cols-2 gap-3">
                  <div><label class="block text-xs text-[#8896AB] mb-1">العمولة %</label><input v-model="editForm.fee_percentage" type="number" step="0.01" class="md-input" /></div>
                  <div><label class="block text-xs text-[#8896AB] mb-1">رسوم ثابتة</label><input v-model="editForm.fee_fixed" type="number" step="0.01" class="md-input" /></div>
                </div>
                <button type="submit" :disabled="editForm.processing" class="mt-2 px-6 py-2 bg-[#1E5EFF] hover:bg-[#1047b8] text-white rounded-xl text-sm font-semibold disabled:opacity-50">حفظ</button>
              </form>
            </div>
          </div>
          <!-- API Keys -->
          <div class="md-card">
            <div class="md-card-header flex justify-between items-center"><h3 class="font-bold text-[#1A2B4A]">🔑 مفاتيح API</h3><button @click="generateKey" class="text-xs px-3 py-1.5 bg-[#1E5EFF] text-white rounded-lg">+ مفتاح جديد</button></div>
            <div class="p-5 space-y-3">
              <div v-for="key in apiKeys" :key="key.id" class="bg-[#FAFBFC] border border-[#E8ECF1] rounded-xl p-4">
                <div class="flex justify-between items-start mb-2"><span class="text-sm font-semibold text-[#1A2B4A]">{{ key.name }}</span><span :class="key.is_active ? 'md-badge-green' : 'md-badge-red'" class="md-badge">{{ key.is_active ? 'نشط' : 'ملغي' }}</span></div>
                <div class="text-xs font-mono text-[#8896AB] mb-1">PK: {{ key.public_key }}</div>
                <div class="text-xs font-mono text-[#8896AB] mb-2">SK: {{ key.secret_key_prefix }}•••</div>
                <div class="flex justify-between items-center text-xs"><span class="text-[#8896AB]">{{ key.environment }}</span><button v-if="key.is_active" @click="revokeKey(key.id)" class="text-red-500 hover:text-red-600 font-semibold">إلغاء</button></div>
              </div>
              <div v-if="!apiKeys.length" class="text-[#8896AB] text-sm text-center py-4">لا توجد مفاتيح</div>
            </div>
          </div>
        </div>
        <!-- Sessions -->
        <div class="md-card overflow-hidden">
          <div class="md-card-header"><h3 class="font-bold text-[#1A2B4A]">جلسات الدفع</h3></div>
          <table class="md-table">
            <thead><tr><th>الجلسة</th><th>المبلغ</th><th class="text-center">الحالة</th><th>العميل</th><th>التاريخ</th></tr></thead>
            <tbody>
              <tr v-for="s in sessions.data" :key="s.id">
                <td class="font-mono text-xs text-[#1E5EFF]">{{ s.session_id?.substring(0, 20) }}…</td>
                <td class="font-bold text-[#1A2B4A]">{{ Number(s.amount).toLocaleString() }} {{ s.currency_code }}</td>
                <td class="text-center"><span :class="sessionBadge[s.status]" class="md-badge">{{ s.status }}</span></td>
                <td class="text-[#5A6B82]">{{ s.paid_by_user?.full_name || s.customer_email || '—' }}</td>
                <td class="text-[#8896AB] text-xs">{{ new Date(s.created_at).toLocaleString('en-GB') }}</td>
              </tr>
              <tr v-if="!sessions.data?.length"><td colspan="5" class="py-8 text-center text-[#8896AB]">لا توجد جلسات</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.md-root{min-height:100vh;background:#F0F2F5;direction:rtl}
.md-header{background:linear-gradient(135deg,#fff,#F8FAFC);border-bottom:1px solid #E8ECF1}
.md-back{padding:8px 18px;background:#F0F4FF;color:#1E5EFF;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(30,94,255,0.12)}.md-back:hover{background:#1E5EFF;color:#fff}
.md-stat{background:#fff;border:1px solid #E8ECF1;border-radius:14px;padding:16px 20px}
.md-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px;overflow:hidden}
.md-card-header{padding:14px 20px;border-bottom:1px solid #E8ECF1;background:#FAFBFC}
.md-input{width:100%;border:1px solid #E8ECF1;border-radius:10px;padding:8px 12px;font-size:13px;color:#1A2B4A;outline:none}.md-input:focus{border-color:#1E5EFF}
.md-table{width:100%;border-collapse:collapse;font-size:13px}
.md-table th{text-align:right;padding:12px 16px;background:#FAFBFC;color:#8896AB;font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #E8ECF1}
.md-table td{padding:12px 16px;border-bottom:1px solid #F0F2F5;vertical-align:middle}
.md-table tr:hover td{background:#FAFBFC}
.md-badge{font-size:11px;padding:2px 10px;border-radius:100px;font-weight:600}
.md-badge-green{background:rgba(16,185,129,0.1);color:#059669}.md-badge-yellow{background:rgba(245,158,11,0.1);color:#d97706}.md-badge-red{background:rgba(239,68,68,0.1);color:#dc2626}.md-badge-gray{background:#F0F2F5;color:#8896AB}.md-badge-orange{background:rgba(249,115,22,0.1);color:#ea580c}
</style>
