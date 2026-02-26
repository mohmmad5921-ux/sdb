<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ transactions: Object, filters: Object, stats: Object });
const page = usePage();
const flash = computed(() => page.props.flash || {});

const search = ref(props.filters?.search || '');
const type = ref(props.filters?.type || 'all');
const period = ref(props.filters?.period || '');

const applyFilters = () => router.get(route('banking.transactions'), { search: search.value, type: type.value, period: period.value }, { preserveState: true });

const typeLabels = { transfer: 'تحويل', deposit: 'إيداع', withdrawal: 'سحب', exchange: 'صرف عملات', card_payment: 'دفع بالبطاقة', fee: 'رسوم', refund: 'استرداد' };
const typeIcons = { transfer: '↗️', deposit: '💰', withdrawal: '🏧', exchange: '💱', card_payment: '💳', fee: '📄', refund: '↩️' };
const statusColors = { completed: 'text-emerald-400', pending: 'text-amber-400', failed: 'text-rose-400' };
const statusBg = { completed: 'bg-emerald-500/10', pending: 'bg-amber-500/10', failed: 'bg-rose-500/10' };
const fmt = (a) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2 });

const navItems = [
    { label: 'الرئيسية', icon: '🏦', route: 'dashboard' },
    { label: 'المعاملات', icon: '📊', route: 'banking.transactions' },
    { label: 'التحليلات', icon: '📈', route: 'banking.analytics' },
    { label: 'المستفيدون', icon: '👥', route: 'banking.beneficiaries' },
    { label: 'الدعم', icon: '🎧', route: 'banking.support' },
    { label: 'الأمان', icon: '🔒', route: 'banking.security' },
    { label: 'الإحالة', icon: '🎁', route: 'banking.referral' },
];
</script>

<template>
    <Head title="Transactions - المعاملات" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#060b18] text-white relative overflow-hidden">
            <!-- Ambient Background -->
            <div class="fixed inset-0 pointer-events-none">
                <div class="absolute top-0 left-1/4 w-[600px] h-[600px] bg-indigo-600/8 rounded-full blur-[150px]"></div>
                <div class="absolute bottom-0 right-1/4 w-[500px] h-[500px] bg-cyan-600/6 rounded-full blur-[150px]"></div>
            </div>

            <!-- Header -->
            <div class="relative z-10 px-6 pt-6 pb-4">
                <div class="max-w-6xl mx-auto">
                    <div class="flex justify-between items-start mb-5">
                        <div>
                            <h1 class="text-2xl font-black tracking-tight bg-gradient-to-r from-white via-white to-gray-400 bg-clip-text text-transparent">سجل المعاملات</h1>
                            <p class="text-gray-500 text-xs mt-1 tracking-wide">TRANSACTION HISTORY</p>
                        </div>
                        <a :href="route('banking.transactions.export')" class="group flex items-center gap-2 px-5 py-2.5 bg-white/[0.04] hover:bg-white/[0.08] border border-white/[0.06] hover:border-emerald-500/30 rounded-2xl text-sm transition-all duration-300 backdrop-blur-sm">
                            <span class="group-hover:scale-110 transition-transform">📥</span>
                            <span>تصدير CSV</span>
                        </a>
                    </div>

                    <!-- Nav Pills -->
                    <div class="flex flex-wrap gap-1.5">
                        <Link v-for="n in navItems" :key="n.route" :href="route(n.route)"
                            :class="route().current(n.route) ? 'bg-gradient-to-r from-emerald-600/20 to-cyan-600/20 border-emerald-500/30 text-emerald-300 shadow-lg shadow-emerald-500/5' : 'bg-white/[0.02] border-white/[0.04] text-gray-400 hover:text-white hover:bg-white/[0.06] hover:border-white/[0.08]'"
                            class="px-3.5 py-2 border rounded-xl text-xs font-medium transition-all duration-300 flex items-center gap-1.5 backdrop-blur-sm">
                            <span class="text-sm">{{ n.icon }}</span><span>{{ n.label }}</span>
                        </Link>
                    </div>
                </div>
            </div>

            <!-- Content -->
            <div class="relative z-10 max-w-6xl mx-auto px-6 py-6 space-y-6">
                <!-- Stats Cards -->
                <div class="grid grid-cols-3 gap-4">
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-emerald-950/60 to-emerald-900/20 border border-emerald-500/10 p-5">
                        <div class="absolute top-0 right-0 w-20 h-20 bg-emerald-500/10 rounded-full blur-2xl"></div>
                        <div class="relative">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/15 flex items-center justify-center text-lg mb-3">📥</div>
                            <div class="text-2xl font-black text-emerald-400 tracking-tight">{{ fmt(stats.totalIn) }} <span class="text-base font-medium text-emerald-500/60">€</span></div>
                            <div class="text-xs text-emerald-500/50 mt-1 font-medium tracking-wide">إجمالي الوارد</div>
                        </div>
                    </div>
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-rose-950/60 to-rose-900/20 border border-rose-500/10 p-5">
                        <div class="absolute top-0 right-0 w-20 h-20 bg-rose-500/10 rounded-full blur-2xl"></div>
                        <div class="relative">
                            <div class="w-10 h-10 rounded-xl bg-rose-500/15 flex items-center justify-center text-lg mb-3">📤</div>
                            <div class="text-2xl font-black text-rose-400 tracking-tight">{{ fmt(stats.totalOut) }} <span class="text-base font-medium text-rose-500/60">€</span></div>
                            <div class="text-xs text-rose-500/50 mt-1 font-medium tracking-wide">إجمالي الصادر</div>
                        </div>
                    </div>
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-indigo-950/60 to-indigo-900/20 border border-indigo-500/10 p-5">
                        <div class="absolute top-0 right-0 w-20 h-20 bg-indigo-500/10 rounded-full blur-2xl"></div>
                        <div class="relative">
                            <div class="w-10 h-10 rounded-xl bg-indigo-500/15 flex items-center justify-center text-lg mb-3">📊</div>
                            <div class="text-2xl font-black text-indigo-400 tracking-tight">{{ stats.count }}</div>
                            <div class="text-xs text-indigo-500/50 mt-1 font-medium tracking-wide">عدد المعاملات</div>
                        </div>
                    </div>
                </div>

                <!-- Filters -->
                <div class="flex flex-wrap gap-3 items-center bg-white/[0.02] border border-white/[0.05] rounded-2xl p-3 backdrop-blur-sm">
                    <div class="flex-1 min-w-[200px] relative">
                        <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-600">🔍</span>
                        <input v-model="search" @keydown.enter="applyFilters" placeholder="بحث بالمرجع أو الوصف..."
                            class="w-full bg-white/[0.03] border border-white/[0.06] rounded-xl pl-10 pr-4 py-2.5 text-sm text-white outline-none focus:border-emerald-500/40 focus:bg-white/[0.05] focus:ring-1 focus:ring-emerald-500/20 placeholder-gray-600 transition-all duration-300" />
                    </div>
                    <select v-model="type" @change="applyFilters" class="bg-white/[0.03] border border-white/[0.06] rounded-xl px-4 py-2.5 text-sm text-white outline-none focus:border-emerald-500/40 transition-all duration-300 cursor-pointer">
                        <option value="all">كل الأنواع</option>
                        <option value="transfer">تحويل</option><option value="deposit">إيداع</option>
                        <option value="exchange">صرف</option><option value="fee">رسوم</option>
                    </select>
                    <div class="flex gap-1 bg-white/[0.02] rounded-xl p-1 border border-white/[0.04]">
                        <button v-for="p in [{v:'', l:'الكل'},{v:'today', l:'اليوم'},{v:'7d', l:'7 أيام'},{v:'30d', l:'شهر'}]" :key="p.v"
                            @click="period = p.v; applyFilters()"
                            :class="period === p.v ? 'bg-gradient-to-r from-emerald-600/30 to-cyan-600/30 text-emerald-300 shadow-sm' : 'text-gray-500 hover:text-white'"
                            class="px-3 py-1.5 rounded-lg text-xs font-medium transition-all duration-300">{{ p.l }}</button>
                    </div>
                </div>

                <!-- Transaction List -->
                <div class="bg-white/[0.015] border border-white/[0.05] rounded-2xl overflow-hidden backdrop-blur-sm">
                    <div class="divide-y divide-white/[0.03]">
                        <div v-for="(t, i) in transactions.data" :key="t.id"
                            class="px-5 py-4 flex items-center justify-between hover:bg-white/[0.02] transition-all duration-200 group"
                            :style="{animationDelay: (i * 50) + 'ms'}">
                            <div class="flex items-center gap-4">
                                <div class="w-11 h-11 rounded-2xl flex items-center justify-center text-xl shadow-lg transition-transform duration-300 group-hover:scale-110"
                                    :class="t.type === 'deposit' ? 'bg-gradient-to-br from-emerald-600/20 to-emerald-500/5 shadow-emerald-500/10' : t.type === 'exchange' ? 'bg-gradient-to-br from-indigo-600/20 to-indigo-500/5 shadow-indigo-500/10' : 'bg-gradient-to-br from-white/[0.06] to-white/[0.02]'">
                                    {{ typeIcons[t.type] || '💸' }}
                                </div>
                                <div>
                                    <div class="text-sm font-semibold text-gray-100 group-hover:text-white transition-colors">{{ typeLabels[t.type] || t.type }}</div>
                                    <div class="text-xs text-gray-600 mt-0.5 flex items-center gap-1.5">
                                        <span class="font-mono text-[10px] bg-white/[0.04] px-1.5 py-0.5 rounded">{{ t.reference_number }}</span>
                                        <span>{{ new Date(t.created_at).toLocaleDateString('en-GB') }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="text-sm font-bold tracking-tight" :class="statusColors[t.status]">
                                    {{ fmt(t.amount) }} <span class="text-xs opacity-60">{{ t.currency?.symbol || '€' }}</span>
                                </div>
                                <div class="mt-0.5">
                                    <span :class="[statusBg[t.status], statusColors[t.status]]" class="text-[10px] px-2 py-0.5 rounded-full font-medium">{{ t.status === 'completed' ? '✓ مكتمل' : t.status }}</span>
                                </div>
                            </div>
                        </div>
                        <div v-if="!transactions.data?.length" class="px-6 py-16 text-center">
                            <div class="text-4xl mb-3 opacity-30">📊</div>
                            <p class="text-gray-500">لا توجد معاملات</p>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <div v-if="transactions.last_page > 1" class="flex justify-center gap-1.5">
                    <Link v-for="link in transactions.links" :key="link.label" :href="link.url || '#'"
                        :class="link.active ? 'bg-gradient-to-r from-emerald-600 to-cyan-600 text-white shadow-lg shadow-emerald-500/20' : 'bg-white/[0.03] text-gray-500 hover:bg-white/[0.06] hover:text-white'"
                        class="px-3.5 py-2 rounded-xl text-xs font-medium transition-all duration-300 border border-white/[0.04]" v-html="link.label" />
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
