<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed, nextTick, onMounted } from 'vue';

const props = defineProps({ ticket: Object });
const page = usePage();
const flash = computed(() => page.props.flash || {});

const form = useForm({ message: '' });
const messagesEnd = ref(null);
const reply = () => form.post(route('banking.support.reply', props.ticket.id), { onSuccess: () => { form.reset(); nextTick(() => messagesEnd.value?.scrollIntoView({ behavior: 'smooth' })); }});

const statusLabels = { open: 'مفتوحة', in_progress: 'قيد المعالجة', waiting_customer: 'بانتظار ردك', resolved: 'تم الحل', closed: 'مغلقة' };
const statusColors = { open: 'bg-blue-500/15 text-blue-400 border-blue-500/15', in_progress: 'bg-amber-500/15 text-amber-400 border-amber-500/15', resolved: 'bg-emerald-500/15 text-emerald-400 border-emerald-500/15', closed: 'bg-gray-500/15 text-gray-400 border-gray-500/15' };
const timeAgo = (d) => { if (!d) return '-'; const s = Math.floor((Date.now() - new Date(d)) / 1000); if (s < 60) return 'الآن'; if (s < 3600) return Math.floor(s/60) + ' دقيقة'; if (s < 86400) return Math.floor(s/3600) + ' ساعة'; return Math.floor(s/86400) + ' يوم'; };

onMounted(() => nextTick(() => messagesEnd.value?.scrollIntoView()));
</script>

<template>
    <Head :title="'Support: ' + ticket.ticket_number" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#060b18] text-white flex flex-col relative overflow-hidden">
            <div class="fixed inset-0 pointer-events-none">
                <div class="absolute top-0 left-1/2 w-[600px] h-[400px] bg-blue-600/4 rounded-full blur-[180px]"></div>
            </div>

            <!-- Header -->
            <div class="relative z-10 px-6 py-4 border-b border-white/[0.04] bg-white/[0.01] backdrop-blur-xl">
                <div class="max-w-3xl mx-auto">
                    <div class="flex justify-between items-start">
                        <div>
                            <h1 class="text-lg font-black">{{ ticket.subject }}</h1>
                            <div class="text-[10px] text-gray-600 mt-1 flex items-center gap-2">
                                <span class="font-mono bg-white/[0.04] px-2 py-0.5 rounded-md">{{ ticket.ticket_number }}</span>
                                <span :class="statusColors[ticket.status]" class="px-2.5 py-0.5 rounded-md text-[10px] font-bold border">{{ statusLabels[ticket.status] }}</span>
                            </div>
                        </div>
                        <Link :href="route('banking.support')" class="px-4 py-2 bg-white/[0.04] hover:bg-white/[0.08] border border-white/[0.06] rounded-xl text-sm transition-all">← القائمة</Link>
                    </div>
                </div>
            </div>

            <!-- Messages -->
            <div class="relative z-10 flex-1 max-w-3xl mx-auto w-full px-6 py-6 overflow-y-auto">
                <div class="space-y-4">
                    <div v-for="(msg, i) in ticket.messages" :key="msg.id"
                        :class="msg.is_admin ? 'ml-12' : 'mr-12'"
                        :style="{animationDelay: (i * 80) + 'ms'}"
                        style="animation: fadeIn 0.3s ease-out both">
                        <div :class="msg.is_admin
                            ? 'bg-gradient-to-br from-blue-950/40 to-blue-900/20 border-blue-500/15 shadow-lg shadow-blue-500/5'
                            : 'bg-white/[0.02] border-white/[0.05]'"
                            class="border rounded-2xl p-5 hover:shadow-lg transition-all duration-300">
                            <div class="flex items-center gap-2 mb-3">
                                <div class="w-7 h-7 rounded-lg flex items-center justify-center text-xs font-bold"
                                    :class="msg.is_admin ? 'bg-blue-500/20 text-blue-400' : 'bg-gradient-to-br from-emerald-500/20 to-cyan-500/10 text-emerald-400'">
                                    {{ msg.is_admin ? '🛡' : '👤' }}
                                </div>
                                <span class="text-xs font-bold" :class="msg.is_admin ? 'text-blue-400/80' : 'text-gray-400'">
                                    {{ msg.is_admin ? 'فريق الدعم' : 'أنت' }}
                                </span>
                                <span class="text-[10px] text-gray-600 mr-auto">{{ timeAgo(msg.created_at) }}</span>
                            </div>
                            <p class="text-sm leading-relaxed text-gray-200 whitespace-pre-wrap">{{ msg.message }}</p>
                        </div>
                    </div>
                    <div ref="messagesEnd"></div>
                </div>
            </div>

            <!-- Reply -->
            <div v-if="ticket.status !== 'closed'" class="relative z-10 border-t border-white/[0.04] p-4 bg-white/[0.01] backdrop-blur-xl">
                <form @submit.prevent="reply" class="max-w-3xl mx-auto flex gap-3">
                    <input v-model="form.message" placeholder="اكتب ردك..." autofocus
                        class="flex-1 bg-white/[0.03] border border-white/[0.06] rounded-2xl px-5 py-3.5 text-white outline-none focus:border-blue-500/40 focus:ring-1 focus:ring-blue-500/20 placeholder-gray-600 text-sm transition-all" />
                    <button type="submit" :disabled="!form.message || form.processing"
                        class="px-7 py-3.5 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 rounded-2xl text-sm font-bold shadow-lg shadow-blue-500/20 disabled:opacity-40 transition-all">
                        إرسال ←
                    </button>
                </form>
            </div>
            <div v-else class="relative z-10 border-t border-white/[0.04] p-4 bg-white/[0.01]">
                <div class="max-w-3xl mx-auto text-center text-sm text-gray-600">هذه التذكرة مغلقة</div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<style scoped>
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
</style>
