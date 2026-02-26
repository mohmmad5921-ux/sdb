<script setup>
import { Head, useForm, usePage } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({ session: Object, accounts: Array, isAuthenticated: Boolean });
const page = usePage();

const form = useForm({ account_id: props.accounts?.[0]?.id || '' });
const submit = () => form.post(route('checkout.process', props.session.session_id));

const timeLeft = ref('');
let timer;

onMounted(() => {
    timer = setInterval(() => {
        const diff = new Date(props.session.expires_at) - new Date();
        if (diff <= 0) { timeLeft.value = 'منتهية الصلاحية'; clearInterval(timer); return; }
        const m = Math.floor(diff / 60000); const s = Math.floor((diff % 60000) / 1000);
        timeLeft.value = `${m}:${s.toString().padStart(2, '0')}`;
    }, 1000);
});
onUnmounted(() => clearInterval(timer));

const formatAmount = (a, s) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2 }) + ' ' + s;
const isPaid = computed(() => props.session.status === 'paid');
const isExpired = computed(() => props.session.status === 'expired' || new Date(props.session.expires_at) < new Date());
</script>

<template>
    <Head :title="`Pay ${session.merchant.name}`" />
    <div class="min-h-screen bg-[#0a0f1c] flex items-center justify-center p-6">
        <div class="w-full max-w-md">
            <!-- Header -->
            <div class="text-center mb-8">
                <div class="w-16 h-16 bg-emerald-500/20 rounded-2xl flex items-center justify-center text-emerald-400 text-2xl font-bold mx-auto mb-4">
                    {{ session.merchant.name.charAt(0) }}
                </div>
                <h1 class="text-white text-xl font-bold">{{ session.merchant.name }}</h1>
                <p class="text-gray-400 text-sm" v-if="session.merchant.name_ar">{{ session.merchant.name_ar }}</p>
            </div>

            <!-- Payment Card -->
            <div class="bg-white/[0.03] border border-white/10 rounded-2xl overflow-hidden">
                <!-- Amount -->
                <div class="p-6 text-center border-b border-white/5">
                    <div class="text-gray-400 text-sm mb-2">المبلغ المطلوب</div>
                    <div class="text-4xl font-black text-white">{{ formatAmount(session.amount, session.currency_code) }}</div>
                    <div class="text-sm text-gray-500 mt-2" v-if="session.description">{{ session.description }}</div>
                    <div class="text-xs text-gray-600 mt-1" v-if="session.order_id">طلب: {{ session.order_id }}</div>
                </div>

                <!-- Status -->
                <div v-if="isPaid" class="p-8 text-center">
                    <div class="text-5xl mb-4">✅</div>
                    <div class="text-emerald-400 text-xl font-bold">تم الدفع بنجاح!</div>
                    <div class="text-gray-400 text-sm mt-2">Payment completed</div>
                </div>

                <div v-else-if="isExpired" class="p-8 text-center">
                    <div class="text-5xl mb-4">⏰</div>
                    <div class="text-red-400 text-xl font-bold">انتهت صلاحية الجلسة</div>
                    <div class="text-gray-400 text-sm mt-2">Session expired</div>
                </div>

                <!-- Payment Form -->
                <div v-else class="p-6">
                    <div class="flex justify-between items-center mb-6">
                        <span class="text-gray-400 text-sm">الوقت المتبقي</span>
                        <span class="text-yellow-400 font-mono font-bold">{{ timeLeft }}</span>
                    </div>

                    <div v-if="!isAuthenticated" class="text-center py-6">
                        <p class="text-gray-400 mb-4">يرجى تسجيل الدخول للدفع</p>
                        <a :href="route('login')" class="inline-block px-6 py-3 bg-emerald-600 hover:bg-emerald-500 rounded-xl text-white font-semibold transition-colors">تسجيل الدخول</a>
                    </div>

                    <form v-else @submit.prevent="submit" class="space-y-4">
                        <div>
                            <label class="block text-sm text-gray-400 mb-2">ادفع من حساب</label>
                            <select v-model="form.account_id" class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white outline-none focus:border-emerald-500">
                                <option v-for="a in accounts" :key="a.id" :value="a.id">
                                    {{ a.currency?.code }} — {{ Number(a.balance).toLocaleString() }} {{ a.currency?.symbol }}
                                </option>
                            </select>
                        </div>

                        <div v-if="form.errors.payment" class="bg-red-500/10 border border-red-500/20 rounded-xl px-4 py-3 text-red-400 text-sm">{{ form.errors.payment }}</div>

                        <button type="submit" :disabled="form.processing"
                            class="w-full py-4 bg-emerald-600 hover:bg-emerald-500 rounded-xl text-white font-bold text-lg transition-all shadow-lg shadow-emerald-500/20 disabled:opacity-50">
                            {{ form.processing ? 'جاري الدفع...' : 'ادفع الآن' }}
                        </button>

                        <div class="text-center">
                            <div class="flex items-center justify-center gap-2 text-gray-500 text-xs">
                                <span>🔒</span>
                                <span>مؤمّن بواسطة سوريا ديجيتال بنك</span>
                                <span>Secured by Syria Digital Bank</span>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Footer -->
            <div class="text-center mt-6 text-gray-600 text-xs">Syria Digital Bank Payment Gateway v1.0</div>
        </div>
    </div>
</template>
