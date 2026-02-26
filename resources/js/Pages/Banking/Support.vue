<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ tickets: Object });
const page = usePage();
const flash = computed(() => page.props.flash || {});

const showNew = ref(false);
const form = useForm({ subject: '', category: 'general', message: '' });
const submit = () => form.post(route('banking.support.store'), { onSuccess: () => { showNew.value = false; form.reset(); }});

const statusColors = { open: 'bg-blue-500/10 text-blue-400 border-blue-500/10', in_progress: 'bg-amber-500/10 text-amber-400 border-amber-500/10', waiting_customer: 'bg-orange-500/10 text-orange-400 border-orange-500/10', resolved: 'bg-emerald-500/10 text-emerald-400 border-emerald-500/10', closed: 'bg-gray-500/10 text-gray-400 border-gray-500/10' };
const statusLabels = { open: 'مفتوحة', in_progress: 'قيد المعالجة', waiting_customer: 'بانتظار ردك', resolved: 'تم الحل ✅', closed: 'مغلقة' };
const catIcons = { general: '📝', account: '🏦', card: '💳', transaction: '💸', technical: '⚙️' };
const catLabels = { general: 'عام', account: 'حساب', card: 'بطاقة', transaction: 'معاملة', technical: 'تقني' };
const timeAgo = (d) => { const s = Math.floor((Date.now() - new Date(d)) / 1000); if (s < 60) return 'الآن'; if (s < 3600) return Math.floor(s/60) + ' د'; if (s < 86400) return Math.floor(s/3600) + ' س'; return Math.floor(s/86400) + ' يوم'; };

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
    <Head title="Support - مركز الدعم" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#060b18] text-white relative overflow-hidden">
            <div class="fixed inset-0 pointer-events-none">
                <div class="absolute top-1/3 left-1/3 w-[500px] h-[500px] bg-blue-600/5 rounded-full blur-[180px]"></div>
            </div>

            <div class="relative z-10 px-6 pt-6 pb-4">
                <div class="max-w-6xl mx-auto">
                    <div class="flex justify-between items-start mb-5">
                        <div>
                            <h1 class="text-2xl font-black tracking-tight bg-gradient-to-r from-white via-white to-gray-400 bg-clip-text text-transparent">مركز الدعم</h1>
                            <p class="text-gray-500 text-xs mt-1 tracking-wide">SUPPORT CENTER</p>
                        </div>
                        <button @click="showNew = true" class="group flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 rounded-2xl text-sm font-bold shadow-lg shadow-blue-500/20 hover:shadow-blue-500/30 transition-all duration-300">
                            <span class="group-hover:rotate-90 transition-transform duration-300">+</span>
                            <span>تذكرة جديدة</span>
                        </button>
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

            <div class="relative z-10 max-w-6xl mx-auto px-6 py-6">
                <div v-if="tickets.data?.length" class="space-y-3">
                    <Link v-for="(t, i) in tickets.data" :key="t.id" :href="route('banking.support.show', t.id)"
                        class="block bg-white/[0.015] border border-white/[0.05] rounded-2xl p-5 hover:border-blue-500/20 hover:bg-white/[0.025] hover:shadow-xl hover:shadow-blue-500/5 transition-all duration-300 group"
                        :style="{animationDelay: (i * 50) + 'ms'}">
                        <div class="flex justify-between items-start">
                            <div class="flex items-start gap-3">
                                <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500/15 to-blue-500/5 flex items-center justify-center text-lg group-hover:scale-110 transition-transform">{{ catIcons[t.category] }}</div>
                                <div>
                                    <div class="font-bold text-sm group-hover:text-blue-300 transition-colors">{{ t.subject }}</div>
                                    <div class="text-[10px] text-gray-600 mt-1.5 flex items-center gap-2">
                                        <span class="font-mono bg-white/[0.04] px-1.5 py-0.5 rounded">{{ t.ticket_number }}</span>
                                        <span>{{ catLabels[t.category] }}</span>
                                        <span>·</span>
                                        <span>{{ t.messages_count }} رسالة</span>
                                        <span>·</span>
                                        <span>{{ timeAgo(t.updated_at) }}</span>
                                    </div>
                                </div>
                            </div>
                            <span :class="statusColors[t.status]" class="px-3 py-1.5 rounded-xl text-[10px] font-bold border">{{ statusLabels[t.status] }}</span>
                        </div>
                    </Link>
                </div>
                <div v-else class="text-center py-20">
                    <div class="w-20 h-20 mx-auto rounded-3xl bg-gradient-to-br from-blue-500/20 to-indigo-500/10 flex items-center justify-center text-4xl mb-5 shadow-lg shadow-blue-500/10">🎧</div>
                    <p class="text-lg font-bold text-gray-300 mb-2">لا توجد تذاكر دعم</p>
                    <p class="text-sm text-gray-600 mb-6">تحتاج مساعدة؟ نحن هنا من أجلك</p>
                    <button @click="showNew = true" class="px-8 py-3 bg-gradient-to-r from-blue-600 to-indigo-600 rounded-2xl text-sm font-bold shadow-lg shadow-blue-500/20 transition-all">+ إنشاء تذكرة</button>
                </div>
            </div>

            <!-- New Ticket Modal -->
            <Teleport to="body">
                <Transition enter-active-class="transition-all duration-300" enter-from-class="opacity-0" enter-to-class="opacity-100"
                    leave-active-class="transition-all duration-200" leave-from-class="opacity-100" leave-to-class="opacity-0">
                    <div v-if="showNew" class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-md" @click.self="showNew = false">
                        <div class="bg-[#0c1225] border border-white/[0.08] rounded-3xl w-full max-w-lg p-7 shadow-2xl relative overflow-hidden" style="animation: slideUp 0.3s ease-out">
                            <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-blue-500 via-indigo-500 to-violet-500"></div>
                            <h3 class="text-lg font-black mb-5">تذكرة دعم جديدة</h3>
                            <form @submit.prevent="submit" class="space-y-3">
                                <input v-model="form.subject" placeholder="الموضوع" class="w-full bg-white/[0.03] border border-white/[0.06] rounded-2xl px-4 py-3 text-white outline-none focus:border-blue-500/40 focus:ring-1 focus:ring-blue-500/20 placeholder-gray-600 transition-all" />
                                <select v-model="form.category" class="w-full bg-white/[0.03] border border-white/[0.06] rounded-2xl px-4 py-3 text-white outline-none focus:border-blue-500/40 transition-all cursor-pointer">
                                    <option value="general">📝 عام</option><option value="account">🏦 حساب</option>
                                    <option value="card">💳 بطاقة</option><option value="transaction">💸 معاملة</option>
                                    <option value="technical">⚙️ تقني</option>
                                </select>
                                <textarea v-model="form.message" placeholder="اكتب رسالتك بالتفصيل..." rows="4" class="w-full bg-white/[0.03] border border-white/[0.06] rounded-2xl px-4 py-3 text-white outline-none focus:border-blue-500/40 focus:ring-1 focus:ring-blue-500/20 placeholder-gray-600 resize-none transition-all"></textarea>
                                <div class="flex gap-3 pt-3">
                                    <button type="submit" :disabled="form.processing" class="flex-1 py-3.5 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 rounded-2xl font-bold text-sm shadow-lg shadow-blue-500/20 disabled:opacity-50 transition-all">إرسال</button>
                                    <button type="button" @click="showNew = false" class="flex-1 py-3.5 bg-white/[0.04] hover:bg-white/[0.08] border border-white/[0.06] rounded-2xl text-sm transition-all">إلغاء</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </Transition>
            </Teleport>
        </div>
    </AuthenticatedLayout>
</template>

<style scoped>
@keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
</style>
