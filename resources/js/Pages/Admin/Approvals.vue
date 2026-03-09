<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref, computed } from 'vue';
const props = defineProps({ approvals: Object, filters: Object, stats: Object });
const flash = computed(() => usePage().props.flash || {});
const filter = ref(props.filters?.status || 'pending');
const applyFilter = (s) => { filter.value = s; router.get(route('admin.approvals'), { status: s }, { preserveState: true }); };
const reviewNote = ref('');
const approve = (id) => router.post(route('admin.approvals.review', id), { action: 'approve', note: reviewNote.value }, { preserveScroll: true });
const reject = (id) => router.post(route('admin.approvals.review', id), { action: 'reject', note: reviewNote.value }, { preserveScroll: true });
const typeLabels = { large_transfer: '💸 تحويل كبير', withdrawal: '🏧 سحب', account_close: '🔒 إغلاق حساب' };
const fmt = (a) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2 });
const fmtDate = (d) => new Date(d).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' });
</script>
<template>
<Head title="الموافقات" />
<AdminLayout title="✅ سير عمل الموافقات" subtitle="مراجعة المعاملات المعلّقة">
  <div v-if="flash.success" class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-3 text-emerald-700 text-sm font-semibold mb-4">✓ {{ flash.success }}</div>
  <div class="flex gap-3 mb-4">
    <button v-for="(l,k) in {pending:'⏳ معلّق ('+stats.pending+')',approved:'✅ موافق ('+stats.approved+')',rejected:'❌ مرفوض ('+stats.rejected+')'}" :key="k" @click="applyFilter(k)" :class="['px-4 py-2 rounded-xl text-sm font-semibold border transition',filter===k?'bg-emerald-500 text-white border-emerald-500':'bg-white text-gray-600 border-gray-200 hover:border-emerald-400']">{{ l }}</button>
  </div>
  <div class="bg-white border border-gray-200 rounded-2xl overflow-hidden">
    <div v-for="a in approvals.data" :key="a.id" class="p-4 border-b border-gray-100 flex justify-between items-center">
      <div>
        <div class="flex items-center gap-2"><span class="text-lg">{{ typeLabels[a.type]?.split(' ')[0] }}</span><span class="font-bold text-gray-900">{{ typeLabels[a.type]?.split(' ').slice(1).join(' ') || a.type }}</span></div>
        <div class="text-sm text-gray-500 mt-1">{{ a.user_name }} · €{{ fmt(a.amount) }} · {{ fmtDate(a.created_at) }}</div>
      </div>
      <div v-if="a.status === 'pending'" class="flex gap-2 items-center">
        <input v-model="reviewNote" placeholder="ملاحظة..." class="px-3 py-1.5 border border-gray-200 rounded-lg text-sm w-40" />
        <button @click="approve(a.id)" class="px-4 py-2 bg-emerald-50 text-emerald-700 rounded-xl text-sm font-semibold hover:bg-emerald-500 hover:text-white transition">✅</button>
        <button @click="reject(a.id)" class="px-4 py-2 bg-red-50 text-red-600 rounded-xl text-sm font-semibold hover:bg-red-500 hover:text-white transition">❌</button>
      </div>
      <div v-else>
        <span :class="['text-xs font-semibold px-3 py-1 rounded-lg',a.status==='approved'?'bg-emerald-50 text-emerald-600':'bg-red-50 text-red-600']">{{ a.status === 'approved' ? '✅ موافق' : '❌ مرفوض' }}</span>
        <div class="text-xs text-gray-400 mt-1">{{ a.reviewer_name }} · {{ fmtDate(a.reviewed_at) }}</div>
      </div>
    </div>
    <div v-if="!approvals.data?.length" class="py-12 text-center text-gray-400">لا توجد طلبات</div>
  </div>
</AdminLayout>
</template>
