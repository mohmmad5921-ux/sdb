<script setup>
import { Head, Link, useForm, usePage, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ beneficiaries: Array });
const page = usePage();
const flash = computed(() => page.props.flash || {});

const showAdd = ref(false);
const editId = ref(null);
const form = useForm({ name: '', iban: '', bank_name: '', swift_code: '', country: '' });

const navItems = [
    { label: 'الرئيسية', icon: '🏦', route: 'dashboard' },
    { label: 'المعاملات', icon: '📊', route: 'banking.transactions' },
    { label: 'التحليلات', icon: '📈', route: 'banking.analytics' },
    { label: 'المستفيدون', icon: '👥', route: 'banking.beneficiaries' },
    { label: 'الدعم', icon: '🎧', route: 'banking.support' },
    { label: 'الأمان', icon: '🔒', route: 'banking.security' },
    { label: 'الإحالة', icon: '🎁', route: 'banking.referral' },
];

const avatarColors = ['from-emerald-600/30 to-cyan-600/10', 'from-blue-600/30 to-indigo-600/10', 'from-violet-600/30 to-pink-600/10', 'from-amber-600/30 to-orange-600/10', 'from-rose-600/30 to-red-600/10', 'from-cyan-600/30 to-teal-600/10'];
const getColor = (i) => avatarColors[i % avatarColors.length];

const startAdd = () => { form.reset(); editId.value = null; showAdd.value = true; };
const startEdit = (b) => { form.name = b.name; form.iban = b.iban; form.bank_name = b.bank_name; form.swift_code = b.swift_code; form.country = b.country; editId.value = b.id; showAdd.value = true; };
const save = () => {
    if (editId.value) { form.patch(route('banking.beneficiaries.update', editId.value), { onSuccess: () => { showAdd.value = false; form.reset(); }}); }
    else { form.post(route('banking.beneficiaries.store'), { onSuccess: () => { showAdd.value = false; form.reset(); }}); }
};
const remove = (id) => router.delete(route('banking.beneficiaries.destroy', id));
const toggleFav = (id) => router.post(route('banking.beneficiaries.favorite', id));
</script>

<template>
    <Head title="Beneficiaries - المستفيدون" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#060b18] text-white relative overflow-hidden">
            <div class="fixed inset-0 pointer-events-none">
                <div class="absolute top-1/4 right-1/4 w-[600px] h-[600px] bg-cyan-600/5 rounded-full blur-[180px]"></div>
                <div class="absolute bottom-1/4 left-1/4 w-[500px] h-[500px] bg-violet-600/5 rounded-full blur-[150px]"></div>
            </div>

            <div class="relative z-10 px-6 pt-6 pb-4">
                <div class="max-w-6xl mx-auto">
                    <div class="flex justify-between items-start mb-5">
                        <div>
                            <h1 class="text-2xl font-black tracking-tight bg-gradient-to-r from-white via-white to-gray-400 bg-clip-text text-transparent">المستفيدون</h1>
                            <p class="text-gray-500 text-xs mt-1 tracking-wide">SAVED RECIPIENTS</p>
                        </div>
                        <button @click="startAdd" class="group flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-emerald-600 to-cyan-600 hover:from-emerald-500 hover:to-cyan-500 rounded-2xl text-sm font-bold shadow-lg shadow-emerald-500/20 hover:shadow-emerald-500/30 transition-all duration-300">
                            <span class="group-hover:rotate-90 transition-transform duration-300">+</span>
                            <span>إضافة مستفيد</span>
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
                <div v-if="beneficiaries.length" class="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
                    <div v-for="(b, i) in beneficiaries" :key="b.id"
                        class="bg-white/[0.015] border border-white/[0.05] rounded-2xl p-5 hover:border-emerald-500/20 hover:bg-white/[0.025] hover:shadow-xl hover:shadow-emerald-500/5 transition-all duration-300 group relative overflow-hidden">
                        <div class="absolute top-0 right-0 w-24 h-24 bg-gradient-to-bl rounded-full blur-3xl opacity-0 group-hover:opacity-100 transition-opacity duration-500"
                            :class="getColor(i)"></div>
                        <div class="relative flex justify-between items-start">
                            <div class="flex items-center gap-3">
                                <div class="w-12 h-12 rounded-2xl bg-gradient-to-br flex items-center justify-center font-black text-lg shadow-lg transition-transform duration-300 group-hover:scale-110"
                                    :class="getColor(i)">
                                    {{ b.name?.charAt(0) }}
                                </div>
                                <div>
                                    <div class="font-bold text-sm flex items-center gap-1.5">
                                        {{ b.name }}
                                        <span v-if="b.is_favorite" class="text-amber-400 text-xs animate-pulse">⭐</span>
                                    </div>
                                    <div class="text-xs text-gray-600 font-mono mt-0.5 tracking-wide">{{ b.iban }}</div>
                                </div>
                            </div>
                        </div>
                        <div class="flex gap-1.5 mt-3">
                            <span v-if="b.bank_name" class="bg-white/[0.04] px-2.5 py-1 rounded-lg text-[10px] text-gray-400 font-medium">🏦 {{ b.bank_name }}</span>
                            <span v-if="b.country" class="bg-white/[0.04] px-2.5 py-1 rounded-lg text-[10px] text-gray-400 font-medium">🌍 {{ b.country }}</span>
                            <span v-if="b.swift_code" class="bg-white/[0.04] px-2.5 py-1 rounded-lg text-[10px] text-gray-400 font-mono">{{ b.swift_code }}</span>
                        </div>
                        <div class="flex gap-1.5 mt-3 pt-3 border-t border-white/[0.03] opacity-0 group-hover:opacity-100 transition-all duration-300 translate-y-1 group-hover:translate-y-0">
                            <button @click.stop="toggleFav(b.id)" class="px-2.5 py-1.5 bg-white/[0.04] rounded-lg text-xs hover:bg-amber-500/10 hover:text-amber-400 transition-all">{{ b.is_favorite ? '★' : '☆' }}</button>
                            <button @click.stop="startEdit(b)" class="px-2.5 py-1.5 bg-white/[0.04] rounded-lg text-xs hover:bg-blue-500/10 hover:text-blue-400 transition-all">✏️ تعديل</button>
                            <Link :href="route('dashboard')" class="px-3 py-1.5 bg-gradient-to-r from-emerald-600/20 to-cyan-600/20 border border-emerald-500/20 rounded-lg text-xs text-emerald-400 hover:from-emerald-600/30 hover:to-cyan-600/30 transition-all font-medium">↗ تحويل</Link>
                            <button @click.stop="remove(b.id)" class="px-2.5 py-1.5 bg-white/[0.04] rounded-lg text-xs hover:bg-rose-500/10 hover:text-rose-400 transition-all ml-auto">🗑</button>
                        </div>
                    </div>
                </div>
                <div v-else class="text-center py-20">
                    <div class="w-20 h-20 mx-auto rounded-3xl bg-gradient-to-br from-cyan-500/20 to-violet-500/10 flex items-center justify-center text-4xl mb-5 shadow-lg shadow-cyan-500/10">👥</div>
                    <p class="text-lg font-bold text-gray-300 mb-2">لا يوجد مستفيدون محفوظون</p>
                    <p class="text-sm text-gray-600 mb-6">أضف مستفيدين لتحويل الأموال بسرعة</p>
                    <button @click="startAdd" class="px-8 py-3 bg-gradient-to-r from-emerald-600 to-cyan-600 rounded-2xl text-sm font-bold shadow-lg shadow-emerald-500/20 hover:shadow-emerald-500/30 transition-all duration-300">+ إضافة أول مستفيد</button>
                </div>
            </div>

            <!-- Modal -->
            <Teleport to="body">
                <Transition enter-active-class="transition-all duration-300" enter-from-class="opacity-0" enter-to-class="opacity-100"
                    leave-active-class="transition-all duration-200" leave-from-class="opacity-100" leave-to-class="opacity-0">
                    <div v-if="showAdd" class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-md" @click.self="showAdd = false">
                        <div class="bg-[#0c1225] border border-white/[0.08] rounded-3xl w-full max-w-md p-7 shadow-2xl shadow-black/50 relative overflow-hidden"
                            style="animation: slideUp 0.3s ease-out">
                            <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-emerald-500 via-cyan-500 to-violet-500"></div>
                            <h3 class="text-lg font-black mb-5">{{ editId ? 'تعديل مستفيد' : 'إضافة مستفيد جديد' }}</h3>
                            <form @submit.prevent="save" class="space-y-3">
                                <input v-model="form.name" placeholder="اسم المستفيد" class="w-full bg-white/[0.03] border border-white/[0.06] rounded-2xl px-4 py-3 text-white outline-none focus:border-emerald-500/40 focus:ring-1 focus:ring-emerald-500/20 placeholder-gray-600 transition-all" />
                                <input v-model="form.iban" placeholder="IBAN" class="w-full bg-white/[0.03] border border-white/[0.06] rounded-2xl px-4 py-3 text-white outline-none focus:border-emerald-500/40 focus:ring-1 focus:ring-emerald-500/20 font-mono placeholder-gray-600 transition-all" />
                                <input v-model="form.bank_name" placeholder="اسم البنك (اختياري)" class="w-full bg-white/[0.03] border border-white/[0.06] rounded-2xl px-4 py-3 text-white outline-none focus:border-emerald-500/40 focus:ring-1 focus:ring-emerald-500/20 placeholder-gray-600 transition-all" />
                                <div class="grid grid-cols-2 gap-3">
                                    <input v-model="form.swift_code" placeholder="SWIFT" class="bg-white/[0.03] border border-white/[0.06] rounded-2xl px-4 py-3 text-white outline-none focus:border-emerald-500/40 focus:ring-1 focus:ring-emerald-500/20 font-mono placeholder-gray-600 transition-all" />
                                    <input v-model="form.country" placeholder="الدولة" class="bg-white/[0.03] border border-white/[0.06] rounded-2xl px-4 py-3 text-white outline-none focus:border-emerald-500/40 focus:ring-1 focus:ring-emerald-500/20 placeholder-gray-600 transition-all" />
                                </div>
                                <div class="flex gap-3 pt-3">
                                    <button type="submit" :disabled="form.processing" class="flex-1 py-3.5 bg-gradient-to-r from-emerald-600 to-cyan-600 hover:from-emerald-500 hover:to-cyan-500 rounded-2xl font-bold text-sm shadow-lg shadow-emerald-500/20 disabled:opacity-50 transition-all">{{ editId ? 'تحديث' : 'حفظ' }}</button>
                                    <button type="button" @click="showAdd = false" class="flex-1 py-3.5 bg-white/[0.04] hover:bg-white/[0.08] border border-white/[0.06] rounded-2xl text-sm transition-all">إلغاء</button>
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
