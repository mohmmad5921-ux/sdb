<script setup>
import { Head, Link, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { computed } from 'vue';

const props = defineProps({ tickets: Object, filters: Object, stats: Object });
const flash = computed(() => usePage().props.flash || {});
const statusBadge = { open: 'sp-badge-blue', in_progress: 'sp-badge-yellow', waiting_customer: 'sp-badge-orange', resolved: 'sp-badge-green', closed: 'sp-badge-gray' };
const statusLabels = { open: 'مفتوحة', in_progress: 'قيد المعالجة', waiting_customer: 'بانتظار العميل', resolved: 'تم الحل', closed: 'مغلقة' };
const catLabels = { general: 'عام', account: 'حساب', card: 'بطاقة', transaction: 'معاملة', technical: 'تقني' };
</script>

<template>
  <Head title="Support Admin - إدارة الدعم" />
  <AdminLayout title="🎧 تذاكر الدعم">
    <div class="sp-root">
      <div class="sp-header">
        <div class="max-w-6xl mx-auto px-6 py-6 flex justify-between items-center">
          <div><h1 class="text-2xl font-bold text-[#f1f5f9]">🎧 إدارة تذاكر الدعم</h1><p class="text-sm text-[#94a3b8] mt-1">Support Ticket Management</p></div>
          <Link :href="route('admin.dashboard')" class="sp-back">← لوحة التحكم</Link>
        </div>
      </div>
      <div v-if="flash.success" class="max-w-6xl mx-auto px-6 mt-4"><div class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-3 text-emerald-700 text-sm">✓ {{ flash.success }}</div></div>
      <div class="max-w-6xl mx-auto px-6 py-6 space-y-6">
        <div class="grid grid-cols-4 gap-4">
          <div class="sp-stat sp-stat-blue"><div class="text-2xl font-black text-blue-600">{{ stats.open }}</div><div class="text-xs text-[#94a3b8]">مفتوحة</div></div>
          <div class="sp-stat sp-stat-yellow"><div class="text-2xl font-black text-amber-600">{{ stats.in_progress }}</div><div class="text-xs text-[#94a3b8]">قيد المعالجة</div></div>
          <div class="sp-stat sp-stat-orange"><div class="text-2xl font-black text-orange-600">{{ stats.waiting }}</div><div class="text-xs text-[#94a3b8]">بانتظار العميل</div></div>
          <div class="sp-stat sp-stat-green"><div class="text-2xl font-black text-emerald-600">{{ stats.resolved }}</div><div class="text-xs text-[#94a3b8]">تم الحل</div></div>
        </div>
        <div v-if="tickets.data?.length" class="space-y-3">
          <Link v-for="t in tickets.data" :key="t.id" :href="route('admin.support.show', t.id)" class="sp-ticket">
            <div class="flex justify-between items-start">
              <div>
                <div class="font-semibold text-[#f1f5f9] text-sm">{{ t.subject }}</div>
                <div class="text-xs text-[#94a3b8] mt-1 flex items-center gap-2">
                  <span class="font-mono text-[#1E5EFF]">{{ t.ticket_number }}</span><span>·</span><span>{{ t.user?.full_name }}</span><span>·</span><span>{{ catLabels[t.category] }}</span><span>·</span><span>{{ t.messages_count }} رسالة</span>
                </div>
              </div>
              <span :class="statusBadge[t.status]" class="sp-badge">{{ statusLabels[t.status] }}</span>
            </div>
          </Link>
        </div>
        <div v-else class="text-center text-[#94a3b8] py-16"><div class="text-4xl mb-3">📭</div><p>لا توجد تذاكر</p></div>
      </div>
    </div>
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
@import '../../../css/admin.css';
.sp-root{min-height:100vh;background:#f1f5f9;direction:rtl}
.sp-header{background:#ffffff;border-bottom:1px solid #e2e8f0}
.sp-back{padding:8px 18px;background:#ffffff;color:#3b82f6;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(16,185,129,0.2)}.sp-back:hover{background:#10b981;color:#fff}
.sp-stat{background:#ffffff;border:1px solid #e2e8f0;border-radius:16px;padding:20px;text-align:center}
.sp-ticket{display:block;background:#ffffff;border:1px solid #e2e8f0;border-radius:16px;padding:18px 20px;transition:all .2s;text-decoration:none}.sp-ticket:hover{border-color:#10b981;box-shadow:0 4px 12px rgba(30,94,255,0.06);transform:translateY(-1px)}
.sp-badge{font-size:11px;padding:3px 10px;border-radius:100px;font-weight:600}
.sp-badge-blue{background:rgba(59,130,246,0.15);color:#3b82f6}.sp-badge-yellow{background:rgba(245,158,11,0.1);color:#d97706}.sp-badge-orange{background:rgba(249,115,22,0.1);color:#ea580c}.sp-badge-green{background:rgba(16,185,129,0.1);color:#059669}.sp-badge-gray{background:#f1f5f9;color:#64748b}
</style>
