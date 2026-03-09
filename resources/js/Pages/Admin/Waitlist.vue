<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { ref, computed, watch } from 'vue';

const props = defineProps({ tab: String, filters: Object, waitlist: Object, preregistrations: Object, stats: Object, sources: Array });
const flash = computed(() => usePage().props.flash || {});

const activeTab = ref(props.tab || 'waitlist');
const search = ref(props.filters?.search || '');
const dateFrom = ref(props.filters?.from || '');
const dateTo = ref(props.filters?.to || '');
const source = ref(props.filters?.source || '');
const selected = ref([]);
const selectAll = ref(false);

const applyFilters = () => {
    router.get(route('admin.waitlist'), { tab: activeTab.value, search: search.value, from: dateFrom.value, to: dateTo.value, source: source.value }, { preserveState: true });
};

const switchTab = (t) => { activeTab.value = t; selected.value = []; selectAll.value = false; applyFilters(); };

const toggleAll = () => {
    const items = activeTab.value === 'waitlist' ? props.waitlist.data : props.preregistrations.data;
    selected.value = selectAll.value ? items.map(i => i.id) : [];
};

const deleteOne = (type, id) => { if (confirm('حذف هذا السجل؟')) router.delete(route('admin.waitlist.delete', { type, id })); };

const bulkDelete = () => {
    if (!selected.value.length || !confirm(`حذف ${selected.value.length} سجل؟`)) return;
    router.post(route('admin.waitlist.bulk-delete'), { ids: selected.value, type: activeTab.value === 'waitlist' ? 'waitlist' : 'prereg' }, { onSuccess: () => { selected.value = []; selectAll.value = false; } });
};

const formatDate = (d) => new Date(d).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
</script>

<template>
    <Head title="إدارة قائمة الانتظار — Admin" />
    <div class="wl-root">
        <!-- Sidebar -->
        <aside class="wl-sidebar">
            <div class="wl-logo"><Link :href="route('admin.dashboard')" class="text-lg font-black text-white hover:text-emerald-400 transition">SDB Admin</Link></div>
            <nav class="wl-nav">
                <Link :href="route('admin.dashboard')" class="wl-nav-item">📊 لوحة التحكم</Link>
                <Link :href="route('admin.waitlist')" class="wl-nav-item wl-nav-active">📩 قائمة الانتظار</Link>
                <Link :href="route('admin.users')" class="wl-nav-item">👥 العملاء</Link>
            </nav>
        </aside>

        <!-- Main -->
        <main class="wl-main">
            <header class="wl-topbar">
                <h1 class="text-xl font-black text-white">📩 إدارة قائمة الانتظار والتسجيلات</h1>
            </header>

            <div v-if="flash.success" class="mx-6 mt-4"><div class="bg-emerald-500/10 border border-emerald-500/20 rounded-xl px-4 py-3 text-emerald-400 text-sm">✓ {{ flash.success }}</div></div>

            <div class="wl-content">
                <!-- Stats Row -->
                <div class="grid grid-cols-6 gap-3">
                    <div class="wl-stat"><div class="text-[10px] text-gray-500 mb-1">إجمالي الانتظار</div><div class="text-2xl font-black text-white">{{ stats.waitlist_total }}</div></div>
                    <div class="wl-stat"><div class="text-[10px] text-gray-500 mb-1">اليوم</div><div class="text-2xl font-black text-emerald-400">+{{ stats.waitlist_today }}</div></div>
                    <div class="wl-stat"><div class="text-[10px] text-gray-500 mb-1">هذا الأسبوع</div><div class="text-2xl font-black text-blue-400">{{ stats.waitlist_week }}</div></div>
                    <div class="wl-stat"><div class="text-[10px] text-gray-500 mb-1">إجمالي التسجيل</div><div class="text-2xl font-black text-white">{{ stats.prereg_total }}</div></div>
                    <div class="wl-stat"><div class="text-[10px] text-gray-500 mb-1">اليوم</div><div class="text-2xl font-black text-emerald-400">+{{ stats.prereg_today }}</div></div>
                    <div class="wl-stat"><div class="text-[10px] text-gray-500 mb-1">هذا الأسبوع</div><div class="text-2xl font-black text-blue-400">{{ stats.prereg_week }}</div></div>
                </div>

                <!-- Tabs -->
                <div class="flex gap-2">
                    <button @click="switchTab('waitlist')" :class="activeTab === 'waitlist' ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/30' : 'bg-white/[0.02] text-gray-500 border-white/5'" class="px-5 py-2.5 rounded-xl text-sm font-bold border transition">📩 قائمة الانتظار ({{ stats.waitlist_total }})</button>
                    <button @click="switchTab('prereg')" :class="activeTab === 'prereg' ? 'bg-blue-500/10 text-blue-400 border-blue-500/30' : 'bg-white/[0.02] text-gray-500 border-white/5'" class="px-5 py-2.5 rounded-xl text-sm font-bold border transition">📝 التسجيل المبكر ({{ stats.prereg_total }})</button>
                    <div class="flex-1"></div>
                    <a :href="route(activeTab === 'waitlist' ? 'export.waitlist' : 'export.preregistrations')" class="px-4 py-2.5 bg-emerald-600/20 text-emerald-400 rounded-xl text-xs font-bold border border-emerald-500/20 hover:bg-emerald-600/30 transition">📥 تصدير CSV</a>
                    <button v-if="selected.length" @click="bulkDelete" class="px-4 py-2.5 bg-red-600/20 text-red-400 rounded-xl text-xs font-bold border border-red-500/20 hover:bg-red-600/30 transition">🗑 حذف ({{ selected.length }})</button>
                </div>

                <!-- Filters -->
                <div class="flex gap-3 items-end">
                    <div class="flex-1"><label class="text-[10px] text-gray-600 block mb-1">بحث</label><input v-model="search" @keyup.enter="applyFilters" type="text" placeholder="بريد، اسم، هاتف..." class="wl-input" /></div>
                    <div><label class="text-[10px] text-gray-600 block mb-1">من</label><input v-model="dateFrom" @change="applyFilters" type="date" class="wl-input" /></div>
                    <div><label class="text-[10px] text-gray-600 block mb-1">إلى</label><input v-model="dateTo" @change="applyFilters" type="date" class="wl-input" /></div>
                    <div v-if="activeTab === 'waitlist'"><label class="text-[10px] text-gray-600 block mb-1">المصدر</label><select v-model="source" @change="applyFilters" class="wl-input"><option value="">الكل</option><option v-for="s in sources" :key="s" :value="s">{{ s }}</option></select></div>
                    <button @click="applyFilters" class="px-4 py-2.5 bg-blue-600 text-white rounded-xl text-xs font-bold">🔍 بحث</button>
                    <button @click="search=''; dateFrom=''; dateTo=''; source=''; applyFilters()" class="px-4 py-2.5 bg-white/5 text-gray-400 rounded-xl text-xs">↻ مسح</button>
                </div>

                <!-- Waitlist Table -->
                <div v-if="activeTab === 'waitlist'" class="wl-table-wrap">
                    <table class="wl-table">
                        <thead><tr>
                            <th class="w-8"><input type="checkbox" v-model="selectAll" @change="toggleAll" /></th>
                            <th>البريد</th><th>المصدر</th><th>IP</th><th>التاريخ</th><th class="w-16"></th>
                        </tr></thead>
                        <tbody>
                            <tr v-for="w in waitlist.data" :key="w.id">
                                <td><input type="checkbox" :value="w.id" v-model="selected" /></td>
                                <td class="font-mono text-sm">{{ w.email }}</td>
                                <td><span class="wl-badge">{{ w.source || '—' }}</span></td>
                                <td class="text-xs text-gray-600 font-mono">{{ w.ip_address || '—' }}</td>
                                <td class="text-xs text-gray-500">{{ formatDate(w.created_at) }}</td>
                                <td><button @click="deleteOne('waitlist', w.id)" class="text-red-500 hover:text-red-400 text-xs">🗑</button></td>
                            </tr>
                            <tr v-if="!waitlist.data.length"><td colspan="6" class="text-center text-gray-600 py-8">لا توجد نتائج</td></tr>
                        </tbody>
                    </table>
                    <!-- Pagination -->
                    <div v-if="waitlist.last_page > 1" class="flex gap-2 justify-center mt-4">
                        <Link v-for="link in waitlist.links" :key="link.label" :href="link.url || '#'" v-html="link.label" :class="link.active ? 'bg-emerald-600 text-white' : 'bg-white/5 text-gray-400'" class="px-3 py-1.5 rounded-lg text-xs font-bold" />
                    </div>
                </div>

                <!-- Preregistrations Table -->
                <div v-if="activeTab === 'prereg'" class="wl-table-wrap">
                    <table class="wl-table">
                        <thead><tr>
                            <th class="w-8"><input type="checkbox" v-model="selectAll" @change="toggleAll" /></th>
                            <th>الاسم</th><th>البريد</th><th>الهاتف</th><th>البلد</th><th>المحافظة</th><th>التاريخ</th><th class="w-16"></th>
                        </tr></thead>
                        <tbody>
                            <tr v-for="p in preregistrations.data" :key="p.id">
                                <td><input type="checkbox" :value="p.id" v-model="selected" /></td>
                                <td class="font-semibold text-white">{{ p.full_name }}</td>
                                <td class="font-mono text-sm">{{ p.email }}</td>
                                <td class="font-mono text-sm" dir="ltr">{{ p.phone || '—' }}</td>
                                <td>{{ p.country || '—' }}</td>
                                <td>{{ p.governorate || '—' }}</td>
                                <td class="text-xs text-gray-500">{{ formatDate(p.created_at) }}</td>
                                <td><button @click="deleteOne('prereg', p.id)" class="text-red-500 hover:text-red-400 text-xs">🗑</button></td>
                            </tr>
                            <tr v-if="!preregistrations.data.length"><td colspan="8" class="text-center text-gray-600 py-8">لا توجد نتائج</td></tr>
                        </tbody>
                    </table>
                    <div v-if="preregistrations.last_page > 1" class="flex gap-2 justify-center mt-4">
                        <Link v-for="link in preregistrations.links" :key="link.label" :href="link.url || '#'" v-html="link.label" :class="link.active ? 'bg-blue-600 text-white' : 'bg-white/5 text-gray-400'" class="px-3 py-1.5 rounded-lg text-xs font-bold" />
                    </div>
                </div>
            </div>
        </main>
    </div>
</template>

<style scoped>
.wl-root{display:flex;min-height:100vh;background:#060b18;color:#fff;direction:rtl}
.wl-sidebar{width:200px;background:#0a0f1f;border-left:1px solid rgba(255,255,255,0.05);flex-shrink:0;display:flex;flex-direction:column}
.wl-logo{padding:16px;border-bottom:1px solid rgba(255,255,255,0.05);text-align:center}
.wl-nav{padding:10px 8px;flex:1;display:flex;flex-direction:column;gap:2px}
.wl-nav-item{display:flex;align-items:center;gap:8px;padding:9px 12px;border-radius:10px;font-size:12px;color:rgba(255,255,255,0.4);text-decoration:none;font-weight:500;transition:all .2s}.wl-nav-item:hover{background:rgba(255,255,255,0.03);color:rgba(255,255,255,0.7)}
.wl-nav-active{background:rgba(16,185,129,0.1)!important;color:#10b981!important;font-weight:700}
.wl-main{flex:1;display:flex;flex-direction:column;overflow-y:auto}
.wl-topbar{display:flex;justify-content:space-between;align-items:center;padding:14px 24px;border-bottom:1px solid rgba(255,255,255,0.05)}
.wl-content{padding:20px 24px;display:flex;flex-direction:column;gap:16px}
.wl-stat{background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.05);border-radius:14px;padding:14px;text-align:center}
.wl-input{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:10px;padding:8px 12px;color:#fff;font-size:12px;outline:none;width:100%}.wl-input:focus{border-color:#10b981}
.wl-table-wrap{background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.05);border-radius:16px;overflow:hidden}
.wl-table{width:100%;border-collapse:collapse}
.wl-table th{text-align:right;font-size:11px;color:rgba(255,255,255,0.3);padding:10px 14px;border-bottom:1px solid rgba(255,255,255,0.05);font-weight:600}
.wl-table td{padding:10px 14px;border-bottom:1px solid rgba(255,255,255,0.03);font-size:13px;color:rgba(255,255,255,0.6)}
.wl-table tr:hover td{background:rgba(255,255,255,0.02)}
.wl-badge{font-size:10px;padding:2px 8px;border-radius:100px;background:rgba(59,130,246,0.1);color:#3b82f6;font-weight:600}
</style>
