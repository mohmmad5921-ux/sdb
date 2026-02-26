<script setup>
import { Head, Link, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ referralCode: String, referralLink: String, referrals: Array, stats: Object });
const copied = ref(false);
const copiedCode = ref(false);

const copyLink = () => { navigator.clipboard.writeText(props.referralLink); copied.value = true; setTimeout(() => copied.value = false, 2000); };
const copyCode = () => { navigator.clipboard.writeText(props.referralCode); copiedCode.value = true; setTimeout(() => copiedCode.value = false, 2000); };

const statusLabels = { pending: 'بانتظار التسجيل', completed: 'مسجّل', rewarded: 'تم المكافأة ✨' };
const statusColors = { pending: 'text-amber-400 bg-amber-500/10', completed: 'text-blue-400 bg-blue-500/10', rewarded: 'text-emerald-400 bg-emerald-500/10' };

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
    <Head title="Referral - برنامج الإحالة" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#060b18] text-white relative overflow-hidden">
            <div class="fixed inset-0 pointer-events-none">
                <div class="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[600px] bg-gradient-to-b from-amber-600/8 via-emerald-600/4 to-transparent rounded-full blur-[180px]"></div>
                <div class="absolute bottom-0 right-0 w-[500px] h-[400px] bg-violet-600/5 rounded-full blur-[150px]"></div>
            </div>

            <div class="relative z-10 px-6 pt-6 pb-4">
                <div class="max-w-6xl mx-auto">
                    <div class="mb-5">
                        <h1 class="text-2xl font-black tracking-tight bg-gradient-to-r from-white via-white to-gray-400 bg-clip-text text-transparent">برنامج الإحالة</h1>
                        <p class="text-gray-500 text-xs mt-1 tracking-wide">REFERRAL PROGRAM</p>
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
                <!-- Hero -->
                <div class="relative overflow-hidden rounded-3xl border border-amber-500/10 p-10 text-center"
                    style="background: linear-gradient(135deg, rgba(180,120,20,0.12), rgba(16,185,129,0.08), rgba(99,102,241,0.08))">
                    <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-amber-500/10 via-transparent to-transparent"></div>
                    <div class="absolute top-10 left-1/4 w-24 h-24 bg-amber-400/20 rounded-full blur-3xl animate-pulse" style="animation-duration:4s"></div>
                    <div class="absolute bottom-10 right-1/4 w-20 h-20 bg-emerald-400/20 rounded-full blur-3xl animate-pulse" style="animation-duration:6s"></div>

                    <div class="relative">
                        <div class="w-20 h-20 mx-auto rounded-3xl bg-gradient-to-br from-amber-500/30 to-amber-500/5 flex items-center justify-center text-5xl mb-6 shadow-xl shadow-amber-500/10 border border-amber-500/10" style="animation: float 3s ease-in-out infinite">🎁</div>
                        <h2 class="text-3xl font-black mb-3 bg-gradient-to-r from-amber-300 via-white to-emerald-300 bg-clip-text text-transparent">ادعُ أصدقاءك واحصل على مكافآت!</h2>
                        <p class="text-gray-400 text-sm max-w-md mx-auto mb-8">شارك رابط الإحالة مع أصدقائك. عندما يسجلون ويفعلون حسابهم، كلاكما يحصل على <span class="text-emerald-400 font-bold">10€</span> مكافأة!</p>

                        <div class="bg-black/30 border border-white/[0.06] rounded-2xl p-6 max-w-lg mx-auto space-y-4 backdrop-blur-xl">
                            <div>
                                <label class="text-[10px] text-gray-500 uppercase tracking-widest font-bold block text-right mb-2">كود الإحالة الخاص بك</label>
                                <div class="flex gap-2">
                                    <div class="flex-1 bg-white/[0.04] border border-white/[0.08] rounded-2xl px-6 py-3.5 font-mono text-2xl tracking-[0.3em] text-center bg-gradient-to-r from-amber-400 to-emerald-400 bg-clip-text text-transparent font-black select-all">{{ referralCode }}</div>
                                    <button @click="copyCode" class="w-14 bg-white/[0.04] hover:bg-white/[0.08] border border-white/[0.06] rounded-2xl transition-all duration-300 text-lg"
                                        :class="copiedCode ? 'border-emerald-500/30 text-emerald-400' : ''">{{ copiedCode ? '✓' : '📋' }}</button>
                                </div>
                            </div>
                            <div>
                                <label class="text-[10px] text-gray-500 uppercase tracking-widest font-bold block text-right mb-2">رابط المشاركة</label>
                                <div class="flex gap-2">
                                    <input :value="referralLink" readonly class="flex-1 bg-white/[0.03] border border-white/[0.06] rounded-2xl px-4 py-3 text-xs text-gray-500 font-mono outline-none" />
                                    <button @click="copyLink" class="px-6 rounded-2xl font-bold text-sm transition-all duration-300"
                                        :class="copied ? 'bg-emerald-600 shadow-lg shadow-emerald-500/20' : 'bg-gradient-to-r from-emerald-600 to-cyan-600 shadow-lg shadow-emerald-500/15 hover:shadow-emerald-500/25'">
                                        {{ copied ? '✓ تم' : 'نسخ' }}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Stats -->
                <div class="grid grid-cols-3 gap-4">
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-blue-950/60 to-blue-900/20 border border-blue-500/10 p-6 text-center">
                        <div class="absolute top-0 right-0 w-16 h-16 bg-blue-500/10 rounded-full blur-2xl"></div>
                        <div class="relative">
                            <div class="text-4xl font-black bg-gradient-to-b from-blue-400 to-blue-500 bg-clip-text text-transparent">{{ stats.total_referrals }}</div>
                            <div class="text-xs text-blue-400/50 mt-2 font-bold tracking-wide">إجمالي الدعوات</div>
                        </div>
                    </div>
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-emerald-950/60 to-emerald-900/20 border border-emerald-500/10 p-6 text-center">
                        <div class="absolute top-0 right-0 w-16 h-16 bg-emerald-500/10 rounded-full blur-2xl"></div>
                        <div class="relative">
                            <div class="text-4xl font-black bg-gradient-to-b from-emerald-400 to-emerald-500 bg-clip-text text-transparent">{{ stats.completed }}</div>
                            <div class="text-xs text-emerald-400/50 mt-2 font-bold tracking-wide">أصدقاء مسجّلين</div>
                        </div>
                    </div>
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-amber-950/60 to-amber-900/20 border border-amber-500/10 p-6 text-center">
                        <div class="absolute top-0 right-0 w-16 h-16 bg-amber-500/10 rounded-full blur-2xl"></div>
                        <div class="relative">
                            <div class="text-4xl font-black bg-gradient-to-b from-amber-400 to-amber-500 bg-clip-text text-transparent">{{ stats.total_earned }} €</div>
                            <div class="text-xs text-amber-400/50 mt-2 font-bold tracking-wide">إجمالي المكافآت</div>
                        </div>
                    </div>
                </div>

                <!-- Referrals List -->
                <div v-if="referrals.length" class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-6 backdrop-blur-sm">
                    <div class="flex items-center gap-2 mb-5">
                        <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-violet-500/20 to-violet-500/5 flex items-center justify-center text-sm">👥</div>
                        <h3 class="font-bold text-sm">المدعوّون</h3>
                    </div>
                    <div class="space-y-2">
                        <div v-for="r in referrals" :key="r.id" class="flex justify-between items-center bg-white/[0.02] hover:bg-white/[0.04] border border-white/[0.03] rounded-xl px-5 py-3.5 transition-all duration-200 group">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-emerald-600/20 to-cyan-600/10 flex items-center justify-center font-bold text-sm group-hover:scale-110 transition-transform">{{ r.referred?.full_name?.charAt(0) || '?' }}</div>
                                <div><div class="text-sm font-medium">{{ r.referred?.full_name || 'بانتظار التسجيل' }}</div><div class="text-xs text-gray-600 font-mono">{{ r.referral_code }}</div></div>
                            </div>
                            <div class="text-right flex items-center gap-3">
                                <span :class="statusColors[r.status]" class="text-[11px] px-3 py-1 rounded-full font-medium">{{ statusLabels[r.status] }}</span>
                                <div v-if="r.reward_amount > 0" class="text-sm font-black text-emerald-400">+{{ r.reward_amount }} €</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<style scoped>
@keyframes float { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-10px); } }
</style>
