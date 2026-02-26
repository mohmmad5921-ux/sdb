<script setup>
import { Head, Link, usePage, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { computed } from 'vue';

const props = defineProps({ loginHistory: Array, activeSessions: Array, user: Object });
const page = usePage();
const flash = computed(() => page.props.flash || {});

const revokeSession = (id) => router.delete(route('banking.security.revoke', id));
const revokeAll = () => router.delete(route('banking.security.revoke-all'));
const timeAgo = (d) => { if (!d) return '-'; const s = Math.floor((Date.now() - new Date(d)) / 1000); if (s < 60) return 'الآن'; if (s < 3600) return Math.floor(s/60) + ' دقيقة'; if (s < 86400) return Math.floor(s/3600) + ' ساعة'; return Math.floor(s/86400) + ' يوم'; };
const deviceIcon = (t) => t === 'mobile' ? '📱' : t === 'tablet' ? '📲' : '💻';

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
    <Head title="Security - الأمان" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#060b18] text-white relative overflow-hidden">
            <div class="fixed inset-0 pointer-events-none">
                <div class="absolute top-0 right-1/3 w-[600px] h-[600px] bg-blue-600/5 rounded-full blur-[180px]"></div>
                <div class="absolute bottom-0 left-1/4 w-[400px] h-[400px] bg-rose-600/4 rounded-full blur-[150px]"></div>
            </div>

            <div class="relative z-10 px-6 pt-6 pb-4">
                <div class="max-w-6xl mx-auto">
                    <div class="mb-5">
                        <h1 class="text-2xl font-black tracking-tight bg-gradient-to-r from-white via-white to-gray-400 bg-clip-text text-transparent">الأمان والنشاط</h1>
                        <p class="text-gray-500 text-xs mt-1 tracking-wide">SECURITY & ACTIVITY</p>
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

            <div v-if="flash.success" class="relative z-10 max-w-6xl mx-auto px-6 mt-2">
                <div class="bg-emerald-500/10 border border-emerald-500/20 rounded-2xl px-4 py-3 text-emerald-400 text-sm flex items-center gap-2 backdrop-blur-sm">
                    <span class="w-5 h-5 rounded-full bg-emerald-500/20 flex items-center justify-center text-xs">✓</span>
                    {{ flash.success }}
                </div>
            </div>

            <div class="relative z-10 max-w-6xl mx-auto px-6 py-6 space-y-6">
                <!-- Security Cards -->
                <div class="grid md:grid-cols-3 gap-4">
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-blue-950/60 to-blue-900/20 border border-blue-500/10 p-6 group hover:border-blue-500/20 transition-all duration-300">
                        <div class="absolute top-0 right-0 w-20 h-20 bg-blue-500/10 rounded-full blur-2xl"></div>
                        <div class="relative">
                            <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-blue-500/20 to-blue-500/5 flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">🔐</div>
                            <div class="text-sm font-bold mb-1">كلمة المرور</div>
                            <div class="text-xs text-gray-500">محمية ومشفرة</div>
                            <Link :href="route('profile.edit')" class="inline-flex items-center gap-1 mt-4 text-xs text-blue-400 hover:text-blue-300 font-medium group/link">
                                تغيير <span class="group-hover/link:translate-x-1 transition-transform">←</span>
                            </Link>
                        </div>
                    </div>
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-indigo-950/60 to-indigo-900/20 border border-indigo-500/10 p-6 group hover:border-indigo-500/20 transition-all duration-300">
                        <div class="absolute top-0 right-0 w-20 h-20 bg-indigo-500/10 rounded-full blur-2xl"></div>
                        <div class="relative">
                            <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-indigo-500/20 to-indigo-500/5 flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">📧</div>
                            <div class="text-sm font-bold mb-1">البريد الإلكتروني</div>
                            <div class="text-xs text-gray-500 font-mono">{{ user.email }}</div>
                            <div class="mt-4 flex items-center gap-1.5">
                                <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                                <span class="text-[10px] text-emerald-400/70 font-medium">مُتحقق</span>
                            </div>
                        </div>
                    </div>
                    <div class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-violet-950/60 to-violet-900/20 border border-violet-500/10 p-6 group hover:border-violet-500/20 transition-all duration-300">
                        <div class="absolute top-0 right-0 w-20 h-20 bg-violet-500/10 rounded-full blur-2xl"></div>
                        <div class="relative">
                            <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-violet-500/20 to-violet-500/5 flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">🛡</div>
                            <div class="text-sm font-bold mb-1">التحقق بخطوتين</div>
                            <div class="text-xs text-gray-500">غير مفعّل</div>
                            <div class="mt-4 px-3 py-1 bg-amber-500/10 border border-amber-500/10 rounded-lg text-[10px] text-amber-400/80 font-medium inline-block">قريباً ⏳</div>
                        </div>
                    </div>
                </div>

                <!-- Active Sessions -->
                <div class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-6 backdrop-blur-sm">
                    <div class="flex justify-between items-center mb-5">
                        <div class="flex items-center gap-2">
                            <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-cyan-500/20 to-cyan-500/5 flex items-center justify-center text-sm">🔗</div>
                            <h3 class="font-bold text-sm">الجلسات النشطة (API)</h3>
                        </div>
                        <button v-if="activeSessions.length" @click="revokeAll" class="text-xs text-rose-400 hover:text-rose-300 px-3 py-1.5 bg-rose-500/5 hover:bg-rose-500/10 rounded-lg transition-all font-medium">إلغاء الكل</button>
                    </div>
                    <div v-if="activeSessions.length" class="space-y-2">
                        <div v-for="s in activeSessions" :key="s.id" class="flex justify-between items-center bg-white/[0.02] hover:bg-white/[0.04] border border-white/[0.03] rounded-xl px-5 py-3.5 transition-all duration-200 group">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-cyan-500/15 to-cyan-500/5 flex items-center justify-center text-lg group-hover:scale-110 transition-transform">📱</div>
                                <div>
                                    <div class="text-sm font-medium">{{ s.name }}</div>
                                    <div class="text-[10px] text-gray-600">آخر استخدام: <span class="text-gray-400">{{ s.last_used || 'أبداً' }}</span> · أنشئ: {{ s.created }}</div>
                                </div>
                            </div>
                            <button @click="revokeSession(s.id)" class="text-xs text-rose-400 hover:text-white px-3 py-1.5 bg-rose-500/5 hover:bg-rose-600 rounded-lg transition-all duration-300 font-medium">إلغاء</button>
                        </div>
                    </div>
                    <div v-else class="text-center py-8">
                        <div class="text-3xl opacity-20 mb-2">🔗</div>
                        <p class="text-gray-600 text-sm">لا توجد جلسات API نشطة</p>
                    </div>
                </div>

                <!-- Login History -->
                <div class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-6 backdrop-blur-sm">
                    <div class="flex items-center gap-2 mb-5">
                        <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-amber-500/20 to-amber-500/5 flex items-center justify-center text-sm">📋</div>
                        <h3 class="font-bold text-sm">سجل تسجيل الدخول</h3>
                    </div>
                    <div v-if="loginHistory.length" class="divide-y divide-white/[0.02]">
                        <div v-for="(l, i) in loginHistory" :key="l.id" class="flex items-center justify-between py-3.5 px-3 rounded-xl hover:bg-white/[0.02] transition-all group" :style="{animationDelay: (i * 30) + 'ms'}">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl flex items-center justify-center text-xl transition-transform group-hover:scale-110"
                                    :class="l.is_successful ? 'bg-gradient-to-br from-emerald-500/15 to-emerald-500/5' : 'bg-gradient-to-br from-rose-500/15 to-rose-500/5'">
                                    {{ deviceIcon(l.device_type) }}
                                </div>
                                <div>
                                    <div class="text-sm font-medium"><span class="text-gray-200">{{ l.browser }}</span> <span class="text-gray-600">·</span> <span class="text-gray-400">{{ l.os }}</span></div>
                                    <div class="text-[10px] text-gray-600 font-mono mt-0.5">{{ l.ip_address }}</div>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="flex items-center gap-1.5 justify-end">
                                    <span class="w-1.5 h-1.5 rounded-full" :class="l.is_successful ? 'bg-emerald-500' : 'bg-rose-500'"></span>
                                    <span :class="l.is_successful ? 'text-emerald-400/70' : 'text-rose-400/70'" class="text-[10px] font-medium">{{ l.is_successful ? 'ناجح' : 'فاشل' }}</span>
                                </div>
                                <div class="text-[10px] text-gray-600 mt-0.5">{{ timeAgo(l.created_at) }}</div>
                            </div>
                        </div>
                    </div>
                    <div v-else class="text-center py-10">
                        <div class="text-3xl opacity-20 mb-2">📋</div>
                        <p class="text-gray-600 text-sm">لا يوجد سجل بعد</p>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
