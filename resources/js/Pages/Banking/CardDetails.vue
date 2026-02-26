<script setup>
import { Head, Link, useForm, usePage, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { computed } from 'vue';

const props = defineProps({ card: Object, transactions: Array });
const page = usePage();
const flash = computed(() => page.props.flash || {});

const limitsForm = useForm({ daily_limit: props.card.daily_limit, monthly_limit: props.card.monthly_limit });
const saveLimits = () => limitsForm.patch(route('banking.cards.limits', props.card.id));

const toggleOnline = () => router.post(route('banking.cards.toggle-online', props.card.id));
const toggleAtm = () => router.post(route('banking.cards.toggle-atm', props.card.id));
const toggleContactless = () => router.post(route('banking.cards.toggle-contactless', props.card.id));
const freezeCard = () => router.post(route('banking.cards.freeze', props.card.id));
const unfreezeCard = () => router.post(route('banking.cards.unfreeze', props.card.id));

const formatCardNumber = (masked) => masked || '•••• •••• •••• ••••';
const expiryFormatted = computed(() => { const d = new Date(props.card.expiry_date); return `${String(d.getMonth()+1).padStart(2,'0')}/${String(d.getFullYear()).slice(-2)}`; });
const fmt = (a) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2 });
</script>

<template>
    <Head title="Card Management - إدارة البطاقة" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#060b18] text-white relative overflow-hidden">
            <div class="fixed inset-0 pointer-events-none">
                <div class="absolute top-1/4 left-1/3 w-[600px] h-[600px] bg-violet-600/6 rounded-full blur-[180px]"></div>
                <div class="absolute bottom-1/4 right-1/3 w-[400px] h-[400px] bg-cyan-600/5 rounded-full blur-[150px]"></div>
            </div>

            <div class="relative z-10 px-6 pt-6 pb-4">
                <div class="max-w-4xl mx-auto flex justify-between items-start">
                    <div>
                        <h1 class="text-2xl font-black tracking-tight bg-gradient-to-r from-white via-white to-gray-400 bg-clip-text text-transparent">إدارة البطاقة</h1>
                        <p class="text-gray-500 text-xs mt-1 tracking-wide">CARD MANAGEMENT</p>
                    </div>
                    <Link :href="route('dashboard')" class="px-4 py-2 bg-white/[0.04] hover:bg-white/[0.08] border border-white/[0.06] rounded-xl text-sm transition-all">← الحساب</Link>
                </div>
            </div>

            <div v-if="flash.success" class="relative z-10 max-w-4xl mx-auto px-6 mt-2">
                <div class="bg-emerald-500/10 border border-emerald-500/20 rounded-2xl px-4 py-3 text-emerald-400 text-sm flex items-center gap-2 backdrop-blur-sm">
                    <span class="w-5 h-5 rounded-full bg-emerald-500/20 flex items-center justify-center text-xs">✓</span>
                    {{ flash.success }}
                </div>
            </div>

            <div class="relative z-10 max-w-4xl mx-auto px-6 py-6 space-y-6">
                <!-- Card Visual -->
                <div class="max-w-sm relative">
                    <div class="rounded-3xl p-7 relative overflow-hidden border border-white/[0.08] shadow-2xl shadow-black/40"
                        style="background: linear-gradient(145deg, #1a1a2e, #0f0f1e, #16162a)">
                        <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,_var(--tw-gradient-stops))] from-violet-500/10 via-transparent to-transparent"></div>
                        <div class="absolute top-0 right-0 w-40 h-40 bg-gradient-to-bl from-cyan-500/10 to-transparent rounded-full blur-2xl"></div>
                        <div class="absolute bottom-0 left-0 w-32 h-32 bg-gradient-to-tr from-violet-500/8 to-transparent rounded-full blur-2xl"></div>

                        <div class="relative">
                            <div class="flex justify-between items-center mb-10">
                                <div class="text-[10px] text-gray-400 uppercase tracking-widest font-bold">{{ card.card_type === 'virtual_mastercard' ? 'Virtual Mastercard' : card.card_type }}</div>
                                <div class="flex gap-1">
                                    <div class="w-6 h-6 rounded-full bg-red-500/60"></div>
                                    <div class="w-6 h-6 rounded-full bg-amber-500/50 -ml-3"></div>
                                </div>
                            </div>
                            <div class="text-xl font-mono tracking-[0.25em] font-bold text-white/80 mb-8">{{ formatCardNumber(card.card_number_masked) }}</div>
                            <div class="flex justify-between items-end">
                                <div>
                                    <div class="text-[8px] text-gray-500 uppercase tracking-widest mb-0.5">CARD HOLDER</div>
                                    <div class="text-sm font-bold text-white/90">{{ card.card_holder_name }}</div>
                                </div>
                                <div class="text-right">
                                    <div class="text-[8px] text-gray-500 uppercase tracking-widest mb-0.5">EXPIRES</div>
                                    <div class="text-sm font-bold text-white/90">{{ expiryFormatted }}</div>
                                </div>
                            </div>
                        </div>

                        <!-- Frozen Overlay -->
                        <div v-if="card.status === 'frozen'" class="absolute inset-0 bg-blue-950/90 backdrop-blur-sm flex items-center justify-center rounded-3xl">
                            <div class="text-center">
                                <div class="text-4xl mb-2" style="animation: pulse 2s ease-in-out infinite">❄️</div>
                                <div class="font-black text-blue-300">البطاقة مجمّدة</div>
                            </div>
                        </div>
                    </div>

                    <!-- Freeze/Unfreeze -->
                    <div class="mt-4 flex gap-3">
                        <button v-if="card.status === 'active'" @click="freezeCard" class="flex-1 py-2.5 bg-gradient-to-r from-blue-600/20 to-blue-500/10 hover:from-blue-600/30 hover:to-blue-500/20 border border-blue-500/20 rounded-2xl text-sm font-medium transition-all">❄️ تجميد البطاقة</button>
                        <button v-else-if="card.status === 'frozen'" @click="unfreezeCard" class="flex-1 py-2.5 bg-gradient-to-r from-emerald-600 to-cyan-600 hover:from-emerald-500 hover:to-cyan-500 rounded-2xl text-sm font-bold shadow-lg shadow-emerald-500/20 transition-all">🔓 إلغاء التجميد</button>
                    </div>
                </div>

                <!-- Toggle Controls -->
                <div class="grid md:grid-cols-3 gap-4">
                    <div @click="toggleOnline" class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-5 cursor-pointer hover:border-emerald-500/20 hover:shadow-lg hover:shadow-emerald-500/5 transition-all duration-300 group">
                        <div class="flex justify-between items-center">
                            <div>
                                <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500/15 to-blue-500/5 flex items-center justify-center text-xl mb-2 group-hover:scale-110 transition-transform">🌐</div>
                                <div class="text-sm font-bold">الشراء أونلاين</div>
                                <div class="text-[10px] text-gray-600 mt-0.5">Online payments</div>
                            </div>
                            <div class="w-14 h-7 rounded-full transition-all duration-300 flex items-center px-1"
                                :class="card.online_payment_enabled ? 'bg-gradient-to-r from-emerald-600 to-cyan-600 shadow-lg shadow-emerald-500/20' : 'bg-gray-800'">
                                <div class="w-5 h-5 rounded-full bg-white shadow-lg transition-all duration-300"
                                    :class="card.online_payment_enabled ? 'translate-x-7' : 'translate-x-0'"></div>
                            </div>
                        </div>
                    </div>
                    <div @click="toggleAtm" class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-5 cursor-pointer hover:border-emerald-500/20 hover:shadow-lg hover:shadow-emerald-500/5 transition-all duration-300 group">
                        <div class="flex justify-between items-center">
                            <div>
                                <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-violet-500/15 to-violet-500/5 flex items-center justify-center text-xl mb-2 group-hover:scale-110 transition-transform">🏧</div>
                                <div class="text-sm font-bold">سحب ATM</div>
                                <div class="text-[10px] text-gray-600 mt-0.5">ATM withdrawals</div>
                            </div>
                            <div class="w-14 h-7 rounded-full transition-all duration-300 flex items-center px-1"
                                :class="card.atm_enabled ? 'bg-gradient-to-r from-emerald-600 to-cyan-600 shadow-lg shadow-emerald-500/20' : 'bg-gray-800'">
                                <div class="w-5 h-5 rounded-full bg-white shadow-lg transition-all duration-300"
                                    :class="card.atm_enabled ? 'translate-x-7' : 'translate-x-0'"></div>
                            </div>
                        </div>
                    </div>
                    <div @click="toggleContactless" class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-5 cursor-pointer hover:border-emerald-500/20 hover:shadow-lg hover:shadow-emerald-500/5 transition-all duration-300 group">
                        <div class="flex justify-between items-center">
                            <div>
                                <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-500/15 to-amber-500/5 flex items-center justify-center text-xl mb-2 group-hover:scale-110 transition-transform">📡</div>
                                <div class="text-sm font-bold">بدون تلامس</div>
                                <div class="text-[10px] text-gray-600 mt-0.5">Contactless</div>
                            </div>
                            <div class="w-14 h-7 rounded-full transition-all duration-300 flex items-center px-1"
                                :class="card.contactless_enabled ? 'bg-gradient-to-r from-emerald-600 to-cyan-600 shadow-lg shadow-emerald-500/20' : 'bg-gray-800'">
                                <div class="w-5 h-5 rounded-full bg-white shadow-lg transition-all duration-300"
                                    :class="card.contactless_enabled ? 'translate-x-7' : 'translate-x-0'"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Spending Limits -->
                <div class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-6 backdrop-blur-sm">
                    <div class="flex items-center gap-2 mb-5">
                        <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-amber-500/20 to-amber-500/5 flex items-center justify-center text-sm">⚡</div>
                        <h3 class="font-bold text-sm">حدود الإنفاق</h3>
                    </div>
                    <form @submit.prevent="saveLimits" class="space-y-5">
                        <div>
                            <div class="flex justify-between text-xs mb-2">
                                <label class="text-gray-400 font-medium">الحد اليومي</label>
                                <span class="font-mono font-bold text-emerald-400">€{{ Number(limitsForm.daily_limit).toLocaleString() }}</span>
                            </div>
                            <input v-model="limitsForm.daily_limit" type="range" min="0" max="10000" step="100" class="w-full h-1.5 bg-gray-800 rounded-full appearance-none cursor-pointer accent-emerald-500" />
                            <div class="flex justify-between text-[10px] text-gray-600 mt-1"><span>€0</span><span>€10,000</span></div>
                        </div>
                        <div>
                            <div class="flex justify-between text-xs mb-2">
                                <label class="text-gray-400 font-medium">الحد الشهري</label>
                                <span class="font-mono font-bold text-emerald-400">€{{ Number(limitsForm.monthly_limit).toLocaleString() }}</span>
                            </div>
                            <input v-model="limitsForm.monthly_limit" type="range" min="0" max="50000" step="500" class="w-full h-1.5 bg-gray-800 rounded-full appearance-none cursor-pointer accent-emerald-500" />
                            <div class="flex justify-between text-[10px] text-gray-600 mt-1"><span>€0</span><span>€50,000</span></div>
                        </div>
                        <button type="submit" :disabled="limitsForm.processing" class="px-8 py-2.5 bg-gradient-to-r from-emerald-600 to-cyan-600 hover:from-emerald-500 hover:to-cyan-500 rounded-2xl text-sm font-bold shadow-lg shadow-emerald-500/20 disabled:opacity-50 transition-all">حفظ الحدود</button>
                    </form>
                </div>

                <!-- Card Transactions -->
                <div class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-6 backdrop-blur-sm">
                    <div class="flex items-center gap-2 mb-5">
                        <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-indigo-500/20 to-indigo-500/5 flex items-center justify-center text-sm">💳</div>
                        <h3 class="font-bold text-sm">آخر معاملات البطاقة</h3>
                    </div>
                    <div v-if="transactions.length" class="divide-y divide-white/[0.02]">
                        <div v-for="t in transactions" :key="t.id" class="py-3.5 flex justify-between items-center hover:bg-white/[0.01] rounded-lg px-2 transition-all">
                            <div>
                                <div class="text-sm font-medium">{{ t.merchant_name || 'معاملة' }}</div>
                                <div class="text-[10px] text-gray-600 mt-0.5">{{ t.merchant_category }} · {{ new Date(t.created_at).toLocaleDateString('en-GB') }}</div>
                            </div>
                            <div class="font-bold text-sm" :class="t.status === 'completed' ? 'text-white' : 'text-rose-400'">{{ fmt(t.amount) }} {{ t.currency_code }}</div>
                        </div>
                    </div>
                    <div v-else class="text-center py-10">
                        <div class="text-3xl opacity-20 mb-2">💳</div>
                        <p class="text-gray-600 text-sm">لا توجد معاملات بالبطاقة بعد</p>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
