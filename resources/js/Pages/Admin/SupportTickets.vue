<script setup>
import { Head, Link, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { computed } from 'vue';

const props = defineProps({ tickets: Object, filters: Object, stats: Object });
const flash = computed(() => usePage().props.flash || {});
const statusBadge = { open: 'sp-badge-blue', in_progress: 'sp-badge-yellow', waiting_customer: 'sp-badge-orange', resolved: 'sp-badge-green', closed: 'sp-badge-gray' };
const statusLabels = { open: 'مفتوحة', in_progress: 'قيد المعالجة', waiting_customer: 'بانتظار العميل', resolved: 'تم الحل', closed: 'مغلقة' };
const catLabels = { general: 'عام', account: 'حساب', card: 'بطاقة', transaction: 'معاملة', technical: 'تقني' };
</script>

<template>
  <Head title="Support Admin - إدارة الدعم" />
  <AuthenticatedLayout>
    <div class="sp-root">
      <div class="sp-header">
        <div class="max-w-6xl mx-auto px-6 py-6 flex justify-between items-center">
          <div><h1 class="text-2xl font-bold text-[#1A2B4A]">🎧 إدارة تذاكر الدعم</h1><p class="text-sm text-[#8896AB] mt-1">Support Ticket Management</p></div>
          <Link :href="route('admin.dashboard')" class="sp-back">← لوحة التحكم</Link>
        </div>
      </div>
      <div v-if="flash.success" class="max-w-6xl mx-auto px-6 mt-4"><div class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-3 text-emerald-700 text-sm">✓ {{ flash.success }}</div></div>
      <div class="max-w-6xl mx-auto px-6 py-6 space-y-6">
        <div class="grid grid-cols-4 gap-4">
          <div class="sp-stat sp-stat-blue"><div class="text-2xl font-black text-blue-600">{{ stats.open }}</div><div class="text-xs text-[#8896AB]">مفتوحة</div></div>
          <div class="sp-stat sp-stat-yellow"><div class="text-2xl font-black text-amber-600">{{ stats.in_progress }}</div><div class="text-xs text-[#8896AB]">قيد المعالجة</div></div>
          <div class="sp-stat sp-stat-orange"><div class="text-2xl font-black text-orange-600">{{ stats.waiting }}</div><div class="text-xs text-[#8896AB]">بانتظار العميل</div></div>
          <div class="sp-stat sp-stat-green"><div class="text-2xl font-black text-emerald-600">{{ stats.resolved }}</div><div class="text-xs text-[#8896AB]">تم الحل</div></div>
        </div>
        <div v-if="tickets.data?.length" class="space-y-3">
          <Link v-for="t in tickets.data" :key="t.id" :href="route('admin.support.show', t.id)" class="sp-ticket">
            <div class="flex justify-between items-start">
              <div>
                <div class="font-semibold text-[#1A2B4A] text-sm">{{ t.subject }}</div>
                <div class="text-xs text-[#8896AB] mt-1 flex items-center gap-2">
                  <span class="font-mono text-[#1E5EFF]">{{ t.ticket_number }}</span><span>·</span><span>{{ t.user?.full_name }}</span><span>·</span><span>{{ catLabels[t.category] }}</span><span>·</span><span>{{ t.messages_count }} رسالة</span>
                </div>
              </div>
              <span :class="statusBadge[t.status]" class="sp-badge">{{ statusLabels[t.status] }}</span>
            </div>
          </Link>
        </div>
        <div v-else class="text-center text-[#8896AB] py-16"><div class="text-4xl mb-3">📭</div><p>لا توجد تذاكر</p></div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.sp-root{min-height:100vh;background:#F0F2F5;direction:rtl}
.sp-header{background:linear-gradient(135deg,#fff,#F8FAFC);border-bottom:1px solid #E8ECF1}
.sp-back{padding:8px 18px;background:#F0F4FF;color:#1E5EFF;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(30,94,255,0.12)}.sp-back:hover{background:#1E5EFF;color:#fff}
.sp-stat{background:#fff;border:1px solid #E8ECF1;border-radius:16px;padding:20px;text-align:center}
.sp-ticket{display:block;background:#fff;border:1px solid #E8ECF1;border-radius:16px;padding:18px 20px;transition:all .2s;text-decoration:none}.sp-ticket:hover{border-color:#1E5EFF;box-shadow:0 4px 12px rgba(30,94,255,0.06);transform:translateY(-1px)}
.sp-badge{font-size:11px;padding:3px 10px;border-radius:100px;font-weight:600}
.sp-badge-blue{background:rgba(30,94,255,0.1);color:#1E5EFF}.sp-badge-yellow{background:rgba(245,158,11,0.1);color:#d97706}.sp-badge-orange{background:rgba(249,115,22,0.1);color:#ea580c}.sp-badge-green{background:rgba(16,185,129,0.1);color:#059669}.sp-badge-gray{background:#F0F2F5;color:#8896AB}
</style>
