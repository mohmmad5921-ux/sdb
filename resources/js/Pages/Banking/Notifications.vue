<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { computed } from 'vue';

const props = defineProps({ notifications: Object, unreadCount: Number });
const page = usePage();
const flash = computed(() => page.props.flash || {});

const markRead = (id) => router.post(route('banking.notifications.read', id));
const markAllRead = () => router.post(route('banking.notifications.read-all'));

const icons = { transaction: '💸', deposit: '💰', card: '💳', kyc: '📋', security: '🔒', system: '⚙️', welcome: '🎉' };
const timeAgo = (date) => {
    const diff = (Date.now() - new Date(date)) / 1000;
    if (diff < 60) return 'الآن';
    if (diff < 3600) return Math.floor(diff / 60) + ' دقيقة';
    if (diff < 86400) return Math.floor(diff / 3600) + ' ساعة';
    return Math.floor(diff / 86400) + ' يوم';
};
</script>

<template>
    <Head title="Notifications - الإشعارات" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#0a0f1c] text-white">
            <div class="px-6 py-6 border-b border-white/5">
                <div class="max-w-3xl mx-auto flex justify-between items-center">
                    <div>
                        <h1 class="text-2xl font-bold">الإشعارات</h1>
                        <p class="text-gray-400 text-sm mt-1" v-if="unreadCount">{{ unreadCount }} غير مقروء</p>
                    </div>
                    <div class="flex gap-2">
                        <button v-if="unreadCount" @click="markAllRead" class="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 rounded-xl text-sm">تعليم الكل كمقروء</button>
                        <Link :href="route('dashboard')" class="px-4 py-2 bg-white/5 hover:bg-white/10 rounded-xl text-sm">← حسابي</Link>
                    </div>
                </div>
            </div>

            <div class="max-w-3xl mx-auto px-6 py-8">
                <div class="divide-y divide-white/5">
                    <div v-for="n in notifications.data" :key="n.id" @click="!n.is_read && markRead(n.id)"
                        :class="n.is_read ? 'opacity-60' : 'bg-white/[0.02]'"
                        class="px-5 py-4 flex items-start gap-4 hover:bg-white/[0.03] transition-colors cursor-pointer rounded-lg">
                        <div class="text-2xl mt-0.5">{{ icons[n.type] || '🔔' }}</div>
                        <div class="flex-1 min-w-0">
                            <div class="flex items-baseline justify-between gap-2">
                                <h4 class="text-sm font-semibold">{{ n.title }}</h4>
                                <span class="text-xs text-gray-500 shrink-0">{{ timeAgo(n.created_at) }}</span>
                            </div>
                            <p class="text-sm text-gray-400 mt-0.5">{{ n.message }}</p>
                        </div>
                        <div v-if="!n.is_read" class="w-2 h-2 bg-emerald-400 rounded-full shrink-0 mt-2"></div>
                    </div>
                    <div v-if="!notifications.data?.length" class="py-16 text-center text-gray-500">
                        <div class="text-4xl mb-3">🔔</div>
                        <p>لا توجد إشعارات</p>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
