<script setup>
import { Head, useForm, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { computed } from 'vue';
const props = defineProps({ liveRates: Array, overrides: Object, spread: [String, Number] });
const flash = computed(() => usePage().props.flash || {});
const spreadForm = useForm({ spread: props.spread });
const updateSpread = () => spreadForm.post(route('admin.rates.spread'), { preserveScroll: true });
</script>
<template>
<Head title="إدارة الأسعار" />
<AdminLayout title="💱 إدارة أسعار الصرف" subtitle="أسعار مباشرة وهامش الربح">
  <div v-if="flash.success" class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-3 text-emerald-700 text-sm font-semibold mb-4">✓ {{ flash.success }}</div>
  <div class="grid grid-cols-3 gap-4 mb-4">
    <div class="bg-white border border-gray-200 rounded-2xl p-5">
      <h3 class="text-base font-bold text-gray-900 mb-3">📊 هامش الصرف (Spread)</h3>
      <div class="flex gap-3 items-center">
        <input v-model.number="spreadForm.spread" type="number" step="0.1" min="0" max="10" class="flex-1 px-3 py-2 border border-gray-200 rounded-xl text-center font-bold text-lg" />
        <span class="text-lg font-bold text-gray-500">%</span>
        <button @click="updateSpread" class="px-4 py-2 bg-emerald-500 text-white rounded-xl text-sm font-semibold">💾</button>
      </div>
      <p class="text-xs text-gray-400 mt-2">هامش الربح المضاف على سعر الصرف الحقيقي</p>
    </div>
    <div class="bg-white border border-gray-200 rounded-2xl p-5 col-span-2">
      <h3 class="text-base font-bold text-gray-900 mb-1">ℹ️ كيف يعمل</h3>
      <p class="text-sm text-gray-500">عند تحويل العملات، يتم إضافة هامش {{ spread }}% على السعر الحقيقي. مثلاً: إذا كان سعر EUR/USD = 1.10، سيكون السعر المعروض للعميل = {{ (1.10 * (1 + Number(spread)/100)).toFixed(4) }}</p>
    </div>
  </div>
  <div class="bg-white border border-gray-200 rounded-2xl overflow-hidden">
    <h3 class="text-base font-bold text-gray-900 p-5">🌐 أسعار مباشرة (CoinGecko)</h3>
    <table class="w-full">
      <thead><tr class="bg-gray-50"><th class="text-right p-3 text-xs font-bold text-gray-500">العملة</th><th class="text-right p-3 text-xs font-bold text-gray-500">الاسم</th><th class="text-right p-3 text-xs font-bold text-gray-500">القيمة / BTC</th><th class="text-right p-3 text-xs font-bold text-gray-500">النوع</th></tr></thead>
      <tbody>
        <tr v-for="r in liveRates" :key="r.code" class="border-b border-gray-50">
          <td class="p-3 font-bold text-sm">{{ r.code }}</td>
          <td class="p-3 text-sm text-gray-600">{{ r.name }}</td>
          <td class="p-3 font-mono text-sm">{{ Number(r.value).toLocaleString() }}</td>
          <td class="p-3"><span :class="['text-xs font-semibold px-2 py-1 rounded-md',r.type==='fiat'?'bg-blue-50 text-blue-600':r.type==='crypto'?'bg-purple-50 text-purple-600':'bg-gray-50 text-gray-600']">{{ r.type }}</span></td>
        </tr>
        <tr v-if="!liveRates?.length"><td colspan="4" class="py-8 text-center text-gray-400">تعذر تحميل الأسعار</td></tr>
      </tbody>
    </table>
  </div>
</AdminLayout>
</template>
