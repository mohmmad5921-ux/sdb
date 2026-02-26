<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref } from 'vue';

const props = defineProps({ merchants: Object, filters: Object });
const showCreateModal = ref(false);

const form = useForm({
  business_name: '', business_name_ar: '', business_email: '', business_phone: '',
  website_url: '', description: '', category: 'ecommerce', fee_percentage: 2.5,
  fee_fixed: 0, settlement_currency: 'EUR', status: 'active',
});
const submit = () => form.post(route('admin.merchants.store'), { onSuccess: () => { showCreateModal.value = false; form.reset(); } });

const statusBadge = { active: 'me-badge-green', pending: 'me-badge-yellow', suspended: 'me-badge-red', rejected: 'me-badge-red' };
const categoryLabels = { ecommerce: 'تجارة إلكترونية', retail: 'تجزئة', services: 'خدمات', food: 'طعام', travel: 'سفر', education: 'تعليم', healthcare: 'صحة', other: 'أخرى' };
</script>

<template>
  <Head title="Payment Gateway - بوابة الدفع" />
  <AuthenticatedLayout>
    <div class="me-root">
      <div class="me-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <div><h1 class="text-2xl font-bold text-[#1A2B4A]">🔌 بوابة الدفع — التجار</h1><p class="text-sm text-[#8896AB] mt-1">{{ merchants.total }} تاجر مسجل</p></div>
          <div class="flex gap-2">
            <button @click="showCreateModal = true" class="me-btn-blue">+ تاجر جديد</button>
            <Link :href="route('admin.dashboard')" class="me-back">← الرئيسية</Link>
          </div>
        </div>
      </div>
      <div class="max-w-7xl mx-auto px-6 py-6">
        <div class="me-card overflow-hidden">
          <table class="me-table">
            <thead><tr><th>التاجر</th><th>الفئة</th><th class="text-center">الحالة</th><th>العمولة</th><th>الحجم</th><th class="text-center">معاملات</th><th></th></tr></thead>
            <tbody>
              <tr v-for="m in merchants.data" :key="m.id">
                <td>
                  <div class="flex items-center gap-3">
                    <div class="me-avatar">🏪</div>
                    <div><div class="text-sm font-semibold text-[#1A2B4A]">{{ m.business_name }}</div><div class="text-xs text-[#8896AB]">{{ m.business_email }}</div></div>
                  </div>
                </td>
                <td class="text-[#5A6B82]">{{ categoryLabels[m.category] }}</td>
                <td class="text-center"><span :class="statusBadge[m.status]" class="me-badge">{{ m.status }}</span></td>
                <td class="font-semibold text-[#1A2B4A]">{{ m.fee_percentage }}%</td>
                <td class="font-mono text-[#1E5EFF]">{{ Number(m.total_volume).toLocaleString() }} {{ m.settlement_currency }}</td>
                <td class="text-center text-[#5A6B82]">{{ m.payment_sessions_count }}</td>
                <td><Link :href="route('admin.merchants.show', m.id)" class="me-link">إدارة ←</Link></td>
              </tr>
              <tr v-if="!merchants.data?.length"><td colspan="7" class="py-12 text-center text-[#8896AB]">لا يوجد تجار بعد</td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <Teleport to="body">
        <div v-if="showCreateModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm" @click.self="showCreateModal = false">
          <div class="bg-white rounded-2xl w-full max-w-lg p-6 shadow-2xl border border-[#E8ECF1] max-h-[80vh] overflow-y-auto" style="direction:rtl">
            <h3 class="text-xl font-bold text-[#1A2B4A] mb-5">إضافة تاجر جديد</h3>
            <form @submit.prevent="submit" class="space-y-4">
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-[#8896AB] mb-1">اسم النشاط (EN)</label><input v-model="form.business_name" required class="me-input" /></div>
                <div><label class="block text-xs text-[#8896AB] mb-1">اسم النشاط (AR)</label><input v-model="form.business_name_ar" class="me-input" /></div>
              </div>
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-[#8896AB] mb-1">البريد</label><input v-model="form.business_email" type="email" required class="me-input" /></div>
                <div><label class="block text-xs text-[#8896AB] mb-1">الهاتف</label><input v-model="form.business_phone" class="me-input" /></div>
              </div>
              <div><label class="block text-xs text-[#8896AB] mb-1">الموقع</label><input v-model="form.website_url" type="url" class="me-input" /></div>
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-[#8896AB] mb-1">الفئة</label><select v-model="form.category" class="me-input"><option v-for="(label, key) in categoryLabels" :key="key" :value="key">{{ label }}</option></select></div>
                <div><label class="block text-xs text-[#8896AB] mb-1">عملة التسوية</label><select v-model="form.settlement_currency" class="me-input"><option value="EUR">EUR</option><option value="USD">USD</option><option value="SYP">SYP</option></select></div>
              </div>
              <div class="grid grid-cols-2 gap-4">
                <div><label class="block text-xs text-[#8896AB] mb-1">نسبة العمولة %</label><input v-model="form.fee_percentage" type="number" step="0.01" class="me-input" /></div>
                <div><label class="block text-xs text-[#8896AB] mb-1">رسوم ثابتة</label><input v-model="form.fee_fixed" type="number" step="0.01" class="me-input" /></div>
              </div>
              <div class="flex gap-3"><button type="submit" :disabled="form.processing" class="flex-1 bg-[#1E5EFF] hover:bg-[#1047b8] text-white py-3 rounded-xl font-semibold disabled:opacity-50">إنشاء</button><button type="button" @click="showCreateModal = false" class="flex-1 bg-[#F0F2F5] text-[#5A6B82] py-3 rounded-xl">إلغاء</button></div>
            </form>
          </div>
        </div>
      </Teleport>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.me-root{min-height:100vh;background:#F0F2F5;direction:rtl}
.me-header{background:linear-gradient(135deg,#fff,#F8FAFC);border-bottom:1px solid #E8ECF1}
.me-back{padding:8px 18px;background:#F0F4FF;color:#1E5EFF;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(30,94,255,0.12)}.me-back:hover{background:#1E5EFF;color:#fff}
.me-btn-blue{padding:8px 18px;background:#1E5EFF;color:#fff;border-radius:10px;font-size:13px;font-weight:600;border:none;cursor:pointer}.me-btn-blue:hover{background:#1047b8}
.me-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px}
.me-table{width:100%;border-collapse:collapse;font-size:13px}
.me-table th{text-align:right;padding:12px 16px;background:#FAFBFC;color:#8896AB;font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #E8ECF1}
.me-table td{padding:14px 16px;border-bottom:1px solid #F0F2F5;vertical-align:middle}
.me-table tr:hover td{background:#FAFBFC}
.me-avatar{width:36px;height:36px;border-radius:10px;background:#F0F4FF;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}
.me-badge{font-size:11px;padding:2px 10px;border-radius:100px;font-weight:600}
.me-badge-green{background:rgba(16,185,129,0.1);color:#059669}.me-badge-yellow{background:rgba(245,158,11,0.1);color:#d97706}.me-badge-red{background:rgba(239,68,68,0.1);color:#dc2626}
.me-link{font-size:12px;color:#1E5EFF;font-weight:600;text-decoration:none}.me-link:hover{text-decoration:underline}
.me-input{width:100%;border:1px solid #E8ECF1;border-radius:12px;padding:10px 14px;font-size:13px;color:#1A2B4A;outline:none}.me-input:focus{border-color:#1E5EFF}
</style>
