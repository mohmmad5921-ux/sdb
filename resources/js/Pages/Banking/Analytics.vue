<script setup>
import { Head, Link, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { computed } from 'vue';

const props = defineProps({ monthlyData: Array, spendingByType: Array, topRecipients: Array, currentBalance: Number, accounts: Array });

const typeLabels = { transfer: 'تحويل', deposit: 'إيداع', withdrawal: 'سحب', exchange: 'صرف عملات', card_payment: 'دفع بالبطاقة', fee: 'رسوم خدمات' };
const typeColors = ['#10b981', '#3b82f6', '#8b5cf6', '#f59e0b', '#ef4444', '#ec4899', '#06b6d4'];
const typeGradients = ['from-emerald-600/20 to-emerald-500/5', 'from-blue-600/20 to-blue-500/5', 'from-violet-600/20 to-violet-500/5', 'from-amber-600/20 to-amber-500/5', 'from-rose-600/20 to-rose-500/5', 'from-pink-600/20 to-pink-500/5'];

const maxMonthly = computed(() => Math.max(...props.monthlyData.map(m => Math.max(m.income, m.expenses)), 1));
const totalSpending = computed(() => props.spendingByType.reduce((s, t) => s + t.total, 0));
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
    <Head title="Analytics - التحليلات المالية" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#060b18] text-white relative overflow-hidden">
            <!-- Ambient -->
            <div class="fixed inset-0 pointer-events-none">
                <div class="absolute top-20 left-1/3 w-[700px] h-[700px] bg-violet-600/6 rounded-full blur-[180px] animate-pulse" style="animation-duration:8s"></div>
                <div class="absolute bottom-20 right-1/3 w-[500px] h-[500px] bg-emerald-600/5 rounded-full blur-[150px] animate-pulse" style="animation-duration:12s"></div>
            </div>

            <!-- Header -->
            <div class="relative z-10 px-6 pt-6 pb-4">
                <div class="max-w-6xl mx-auto">
                    <div class="mb-5">
                        <h1 class="text-2xl font-black tracking-tight bg-gradient-to-r from-white via-white to-gray-400 bg-clip-text text-transparent">التحليلات المالية</h1>
                        <p class="text-gray-500 text-xs mt-1 tracking-wide">FINANCIAL ANALYTICS</p>
                    </div>
                    <div class="flex flex-wrap gap-1.5">
                        <Link v-for="n in navItems" :key="n.route" :href="route(n.route)"
                            :class="route().current(n.route) ? 'bg-gradient-to-r from-emerald-600/20 to-cyan-600/20 border-emerald-500/30 text-emerald-300 shadow-lg shadow-emerald-500/5' : 'bg-white/[0.02] border-white/[0.04] text-gray-400 hover:text-white hover:bg-white/[0.06]'"
                            class="px-3.5 py-2 border rounded-xl text-xs font-medium transition-all duration-300 flex items-center gap-1.5 backdrop-blur-sm">
                            <span class="text-sm">{{ n.icon }}</span><span>{{ n.label }}</span>
                        </Link>
                    </div>
                </div>
            </div>

            <div class="relative z-10 max-w-6xl mx-auto px-6 py-6 space-y-6">
                <!-- Balance Hero -->
                <div class="relative overflow-hidden rounded-3xl bg-gradient-to-br from-emerald-950/80 via-[#0a1a2e] to-cyan-950/60 border border-emerald-500/10 p-8">
                    <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_left,_var(--tw-gradient-stops))] from-emerald-500/10 via-transparent to-transparent"></div>
                    <div class="absolute top-0 right-0 w-40 h-40 bg-emerald-500/8 rounded-full blur-3xl"></div>
                    <div class="absolute bottom-0 left-0 w-32 h-32 bg-cyan-500/8 rounded-full blur-3xl"></div>

                    <div class="relative">
                        <div class="text-sm text-emerald-400/60 font-medium tracking-wider uppercase">إجمالي الرصيد</div>
                        <div class="text-5xl font-black text-white mt-3 tracking-tight">{{ fmt(currentBalance) }} <span class="text-2xl font-bold text-emerald-400/40">€</span></div>
                        <div class="flex gap-3 mt-5">
                            <div v-for="acc in accounts" :key="acc.id"
                                class="bg-white/[0.05] backdrop-blur-sm px-4 py-2 rounded-xl text-xs font-medium border border-white/[0.06] hover:border-emerald-500/20 transition-all duration-300">
                                <span class="text-gray-400">{{ acc.currency?.code }}</span>
                                <span class="text-white ml-2 font-bold">{{ fmt(acc.balance) }}</span>
                                <span class="text-gray-500"> {{ acc.currency?.symbol }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="grid md:grid-cols-2 gap-6">
                    <!-- Monthly Chart -->
                    <div class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-6 backdrop-blur-sm">
                        <div class="flex items-center gap-2 mb-6">
                            <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-blue-500/20 to-blue-500/5 flex items-center justify-center text-sm">📊</div>
                            <h3 class="font-bold text-sm">الإيرادات والمصروفات الشهرية</h3>
                        </div>
                        <div class="space-y-4">
                            <div v-for="m in monthlyData" :key="m.key" class="group">
                                <div class="flex justify-between text-xs text-gray-500 mb-1.5">
                                    <span class="font-medium">{{ m.month }}</span>
                                    <span class="opacity-0 group-hover:opacity-100 transition-opacity">{{ fmt(m.income - m.expenses) }}</span>
                                </div>
                                <div class="relative h-7 bg-white/[0.02] rounded-lg overflow-hidden">
                                    <div class="absolute inset-y-0 left-0 bg-gradient-to-r from-emerald-600/50 to-emerald-400/30 rounded-lg transition-all duration-700 ease-out"
                                        :style="{ width: (m.income / maxMonthly * 100) + '%' }">
                                    </div>
                                    <div class="absolute inset-y-0 left-0 bg-gradient-to-r from-rose-600/50 to-rose-400/30 rounded-lg transition-all duration-700 ease-out"
                                        :style="{ width: (m.expenses / maxMonthly * 50) + '%', top: '50%', height: '50%' }">
                                    </div>
                                </div>
                                <div class="flex justify-between text-[11px] mt-1">
                                    <span class="text-emerald-400/70 font-mono">+{{ fmt(m.income) }}</span>
                                    <span class="text-rose-400/70 font-mono">-{{ fmt(m.expenses) }}</span>
                                </div>
                            </div>
                        </div>
                        <div class="flex gap-6 mt-5 pt-4 border-t border-white/[0.04]">
                            <div class="flex items-center gap-2 text-xs text-gray-500">
                                <div class="w-3 h-3 rounded-sm bg-gradient-to-r from-emerald-600/50 to-emerald-400/30"></div> الوارد
                            </div>
                            <div class="flex items-center gap-2 text-xs text-gray-500">
                                <div class="w-3 h-3 rounded-sm bg-gradient-to-r from-rose-600/50 to-rose-400/30"></div> الصادر
                            </div>
                        </div>
                    </div>

                    <!-- Spending by Type -->
                    <div class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-6 backdrop-blur-sm">
                        <div class="flex items-center gap-2 mb-6">
                            <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-violet-500/20 to-violet-500/5 flex items-center justify-center text-sm">🎯</div>
                            <h3 class="font-bold text-sm">المصروفات حسب النوع <span class="text-gray-600 font-normal">(30 يوم)</span></h3>
                        </div>
                        <div v-if="spendingByType.length" class="space-y-4">
                            <div v-for="(s, i) in spendingByType" :key="s.type" class="group">
                                <div class="flex justify-between items-center text-sm mb-1.5">
                                    <div class="flex items-center gap-2">
                                        <div class="w-2 h-2 rounded-full" :style="{ backgroundColor: typeColors[i] }"></div>
                                        <span class="font-medium text-gray-300">{{ typeLabels[s.type] || s.type }}</span>
                                    </div>
                                    <span class="font-bold text-white">{{ fmt(s.total) }} <span class="text-xs text-gray-500">€</span></span>
                                </div>
                                <div class="h-2 bg-white/[0.03] rounded-full overflow-hidden">
                                    <div class="h-full rounded-full transition-all duration-1000 ease-out"
                                        :style="{ width: (s.total / totalSpending * 100) + '%', background: `linear-gradient(90deg, ${typeColors[i]}80, ${typeColors[i]}30)` }">
                                    </div>
                                </div>
                                <div class="text-[10px] text-gray-600 mt-0.5 font-medium">{{ s.count }} معاملة · {{ totalSpending > 0 ? Math.round(s.total / totalSpending * 100) : 0 }}%</div>
                            </div>
                        </div>
                        <div v-else class="text-center py-12">
                            <div class="text-3xl opacity-20 mb-2">📊</div>
                            <p class="text-gray-600 text-sm">لا توجد مصروفات</p>
                        </div>
                    </div>
                </div>

                <!-- Top Recipients -->
                <div class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-6 backdrop-blur-sm">
                    <div class="flex items-center gap-2 mb-6">
                        <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-amber-500/20 to-amber-500/5 flex items-center justify-center text-sm">👥</div>
                        <h3 class="font-bold text-sm">أكثر المستفيدين <span class="text-gray-600 font-normal">(90 يوم)</span></h3>
                    </div>
                    <div v-if="topRecipients.length" class="grid md:grid-cols-5 gap-3">
                        <div v-for="(r, i) in topRecipients" :key="i"
                            class="bg-gradient-to-br from-white/[0.03] to-transparent border border-white/[0.05] rounded-2xl p-5 text-center hover:border-emerald-500/20 hover:shadow-lg hover:shadow-emerald-500/5 transition-all duration-300 group">
                            <div class="w-12 h-12 mx-auto rounded-2xl bg-gradient-to-br flex items-center justify-center text-lg font-black mb-3 group-hover:scale-110 transition-transform duration-300"
                                :class="typeGradients[i]" :style="{color: typeColors[i]}">
                                {{ r.name?.charAt(0) }}
                            </div>
                            <div class="text-sm font-semibold truncate text-gray-200">{{ r.name }}</div>
                            <div class="text-xl font-black mt-2 bg-gradient-to-r from-emerald-400 to-cyan-400 bg-clip-text text-transparent">{{ fmt(r.total) }} €</div>
                            <div class="text-[10px] text-gray-600 mt-1 font-medium">{{ r.count }} تحويل</div>
                        </div>
                    </div>
                    <div v-else class="text-center py-8">
                        <div class="text-3xl opacity-20 mb-2">👥</div>
                        <p class="text-gray-600 text-sm">لا توجد تحويلات</p>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
