<script setup>
import { Head } from '@inertiajs/vue3';

const props = defineProps({ session: Object });
</script>

<template>
    <Head title="Payment Successful" />
    <div class="min-h-screen bg-[#0a0f1c] flex items-center justify-center p-6">
        <div class="w-full max-w-md text-center">
            <div class="text-6xl mb-6">✅</div>
            <h1 class="text-white text-2xl font-bold mb-2">تم الدفع بنجاح!</h1>
            <p class="text-gray-400 mb-6">Payment completed successfully</p>

            <div class="bg-white/[0.03] border border-white/10 rounded-2xl p-6 mb-6">
                <div class="text-3xl font-black text-emerald-400 mb-2">{{ Number(session.amount).toLocaleString() }} {{ session.currency_code }}</div>
                <div class="text-gray-500 text-sm">{{ session.merchant?.business_name }}</div>
                <div class="text-gray-600 text-xs mt-1">{{ session.session_id }}</div>
            </div>

            <a href="/" class="inline-block px-6 py-3 bg-white/5 hover:bg-white/10 rounded-xl text-white transition-colors">العودة للرئيسية</a>
        </div>
    </div>
</template>
