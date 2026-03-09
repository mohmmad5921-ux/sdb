<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

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

const sideLinks = [
  { label: 'لوحة التحكم', icon: '📊', route: 'admin.dashboard' },
  { label: 'قائمة الانتظار', icon: '📩', route: 'admin.waitlist', active: true },
  { label: 'التقارير', icon: '📈', route: 'admin.reports' },
  { label: 'المخاطر', icon: '🛡️', route: 'admin.risk' },
  { label: 'العملاء', icon: '👥', route: 'admin.users' },
  { label: 'الحسابات', icon: '🏦', route: 'admin.accounts' },
  { label: 'البطاقات', icon: '💳', route: 'admin.cards' },
  { label: 'المعاملات', icon: '💸', route: 'admin.transactions' },
  { label: 'KYC', icon: '🪪', route: 'admin.kyc' },
  { label: 'العملات', icon: '💱', route: 'admin.currencies' },
  { label: 'التجار', icon: '🔌', route: 'admin.merchants' },
  { label: 'الدعم', icon: '🎧', route: 'admin.support' },
  { label: 'التدقيق', icon: '📋', route: 'admin.audit-logs' },
  { label: 'الإعدادات', icon: '⚙️', route: 'admin.settings' },
];
</script>

<template>
    <Head title="إدارة قائمة الانتظار — Admin" />
    <div class="ad-root">
        <aside class="ad-sidebar">
            <div class="ad-logo"><div class="ad-logo-icon">SDB</div><span class="ad-logo-text">لوحة الإدارة</span></div>
            <nav class="ad-nav">
                <Link v-for="l in sideLinks" :key="l.route + l.label" :href="route(l.route)" :class="['ad-nav-item', l.active ? 'ad-nav-active' : '']">
                    <span class="ad-nav-icon">{{ l.icon }}</span><span class="ad-nav-label">{{ l.label }}</span>
                </Link>
            </nav>
        </aside>

        <main class="ad-main">
            <header class="ad-topbar">
                <div>
                    <h1 class="ad-title">📩 إدارة قائمة الانتظار والتسجيلات</h1>
                    <p class="ad-subtitle">إدارة طلبات الانتظار والتسجيلات المبكرة</p>
                </div>
            </header>

            <div v-if="flash.success" class="mx-7 mt-4"><div class="wl-flash">✓ {{ flash.success }}</div></div>

            <div class="ad-content">
                <!-- Stats Row -->
                <div class="grid grid-cols-6 gap-4">
                    <div class="ad-stat" style="text-align:center"><div class="ad-stat-label" style="text-align:center">إجمالي الانتظار</div><div class="ad-stat-value">{{ stats.waitlist_total }}</div></div>
                    <div class="ad-stat" style="text-align:center"><div class="ad-stat-label" style="text-align:center">اليوم</div><div class="ad-stat-value ad-sub-green">+{{ stats.waitlist_today }}</div></div>
                    <div class="ad-stat" style="text-align:center"><div class="ad-stat-label" style="text-align:center">هذا الأسبوع</div><div class="ad-stat-value ad-sub-blue">{{ stats.waitlist_week }}</div></div>
                    <div class="ad-stat" style="text-align:center"><div class="ad-stat-label" style="text-align:center">إجمالي التسجيل المبكر</div><div class="ad-stat-value">{{ stats.prereg_total }}</div></div>
                    <div class="ad-stat" style="text-align:center"><div class="ad-stat-label" style="text-align:center">اليوم</div><div class="ad-stat-value ad-sub-green">+{{ stats.prereg_today }}</div></div>
                    <div class="ad-stat" style="text-align:center"><div class="ad-stat-label" style="text-align:center">هذا الأسبوع</div><div class="ad-stat-value ad-sub-blue">{{ stats.prereg_week }}</div></div>
                </div>

                <!-- Tabs + Actions -->
                <div class="flex gap-3 items-center flex-wrap">
                    <button @click="switchTab('waitlist')" :class="activeTab === 'waitlist' ? 'wl-tab-active' : 'wl-tab'" class="wl-tab-btn">📩 قائمة الانتظار ({{ stats.waitlist_total }})</button>
                    <button @click="switchTab('prereg')" :class="activeTab === 'prereg' ? 'wl-tab-active-blue' : 'wl-tab'" class="wl-tab-btn">📝 التسجيل المبكر ({{ stats.prereg_total }})</button>
                    <div class="flex-1"></div>
                    <a :href="route(activeTab === 'waitlist' ? 'admin.export.waitlist' : 'admin.export.preregistrations')" class="ad-export-btn">📥 تصدير CSV</a>
                    <button v-if="selected.length" @click="bulkDelete" class="wl-del-bulk">🗑 حذف ({{ selected.length }})</button>
                </div>

                <!-- Filters -->
                <div class="flex gap-4 items-end flex-wrap">
                    <div class="flex-1 min-w-[200px]"><label class="wl-label">بحث</label><input v-model="search" @keyup.enter="applyFilters" type="text" placeholder="بريد، اسم، هاتف..." class="wl-input" /></div>
                    <div><label class="wl-label">من تاريخ</label><input v-model="dateFrom" @change="applyFilters" type="date" class="wl-input" /></div>
                    <div><label class="wl-label">إلى تاريخ</label><input v-model="dateTo" @change="applyFilters" type="date" class="wl-input" /></div>
                    <div v-if="activeTab === 'waitlist'"><label class="wl-label">المصدر</label><select v-model="source" @change="applyFilters" class="wl-input"><option value="">الكل</option><option v-for="s in sources" :key="s" :value="s">{{ s }}</option></select></div>
                    <button @click="applyFilters" class="wl-search-btn">🔍 بحث</button>
                    <button @click="search=''; dateFrom=''; dateTo=''; source=''; applyFilters()" class="wl-clear-btn">↻ مسح</button>
                </div>

                <!-- Waitlist Table -->
                <div v-if="activeTab === 'waitlist'" class="wl-table-wrap">
                    <table class="ad-table">
                        <thead><tr>
                            <th class="w-10"><input type="checkbox" v-model="selectAll" @change="toggleAll" /></th>
                            <th>البريد الإلكتروني</th><th>المصدر</th><th>عنوان IP</th><th>تاريخ التسجيل</th><th class="w-16"></th>
                        </tr></thead>
                        <tbody>
                            <tr v-for="w in waitlist.data" :key="w.id">
                                <td><input type="checkbox" :value="w.id" v-model="selected" /></td>
                                <td class="ad-table-mono">{{ w.email }}</td>
                                <td><span class="ad-badge ad-badge-green">{{ w.source || '—' }}</span></td>
                                <td style="font-family:monospace;color:#94a3b8;font-size:14px">{{ w.ip_address || '—' }}</td>
                                <td style="color:#94a3b8;font-size:14px">{{ formatDate(w.created_at) }}</td>
                                <td><button @click="deleteOne('waitlist', w.id)" class="wl-del-one">🗑</button></td>
                            </tr>
                            <tr v-if="!waitlist.data.length"><td colspan="6" class="ad-empty">لا توجد نتائج</td></tr>
                        </tbody>
                    </table>
                    <div v-if="waitlist.last_page > 1" class="wl-pagination">
                        <Link v-for="link in waitlist.links" :key="link.label" :href="link.url || '#'" v-html="link.label" :class="link.active ? 'wl-page-active' : 'wl-page'" />
                    </div>
                </div>

                <!-- Preregistrations Table -->
                <div v-if="activeTab === 'prereg'" class="wl-table-wrap">
                    <table class="ad-table">
                        <thead><tr>
                            <th class="w-10"><input type="checkbox" v-model="selectAll" @change="toggleAll" /></th>
                            <th>الاسم الكامل</th><th>البريد الإلكتروني</th><th>الهاتف</th><th>البلد</th><th>المحافظة</th><th>تاريخ التسجيل</th><th class="w-16"></th>
                        </tr></thead>
                        <tbody>
                            <tr v-for="p in preregistrations.data" :key="p.id">
                                <td><input type="checkbox" :value="p.id" v-model="selected" /></td>
                                <td class="ad-table-name">{{ p.full_name }}</td>
                                <td class="ad-table-mono">{{ p.email }}</td>
                                <td style="font-family:monospace;font-size:14px;color:#94a3b8" dir="ltr">{{ p.phone || '—' }}</td>
                                <td>{{ p.country || '—' }}</td>
                                <td>{{ p.governorate || '—' }}</td>
                                <td style="color:#94a3b8;font-size:14px">{{ formatDate(p.created_at) }}</td>
                                <td><button @click="deleteOne('prereg', p.id)" class="wl-del-one">🗑</button></td>
                            </tr>
                            <tr v-if="!preregistrations.data.length"><td colspan="8" class="ad-empty">لا توجد نتائج</td></tr>
                        </tbody>
                    </table>
                    <div v-if="preregistrations.last_page > 1" class="wl-pagination">
                        <Link v-for="link in preregistrations.links" :key="link.label" :href="link.url || '#'" v-html="link.label" :class="link.active ? 'wl-page-active-blue' : 'wl-page'" />
                    </div>
                </div>
            </div>
        </main>
    </div>
</template>

<style>
@import '../../../css/admin.css';

/* Waitlist-specific styles */
.wl-flash { background: #064e3b; border: 1px solid #065f46; border-radius: 14px; padding: 14px 20px; color: #34d399; font-size: 15px; font-weight: 600; }
.wl-tab-btn { padding: 10px 22px; border-radius: 12px; font-size: 15px; font-weight: 700; border: 1px solid #334155; cursor: pointer; transition: all .15s; }
.wl-tab { background: transparent; color: #94a3b8; } .wl-tab:hover { background: #334155; color: #f1f5f9; }
.wl-tab-active { background: #10b981 !important; color: #fff !important; border-color: #10b981 !important; }
.wl-tab-active-blue { background: #3b82f6 !important; color: #fff !important; border-color: #3b82f6 !important; }
.wl-del-bulk { padding: 10px 18px; border-radius: 12px; font-size: 14px; font-weight: 700; background: #450a0a; color: #fca5a5; border: 1px solid #991b1b; cursor: pointer; transition: all .15s; } .wl-del-bulk:hover { background: #991b1b; }
.wl-label { display: block; font-size: 13px; color: #94a3b8; font-weight: 600; margin-bottom: 6px; }
.wl-input { background: #1e293b; border: 1px solid #334155; border-radius: 12px; padding: 10px 14px; color: #f1f5f9; font-size: 15px; outline: none; width: 100%; transition: border-color .15s; } .wl-input:focus { border-color: #10b981; } .wl-input::placeholder { color: #64748b; }
.wl-search-btn { padding: 10px 20px; background: #3b82f6; color: #fff; border-radius: 12px; font-size: 14px; font-weight: 700; border: none; cursor: pointer; transition: all .15s; } .wl-search-btn:hover { filter: brightness(1.1); }
.wl-clear-btn { padding: 10px 18px; background: #1e293b; color: #94a3b8; border-radius: 12px; font-size: 14px; font-weight: 500; border: 1px solid #334155; cursor: pointer; } .wl-clear-btn:hover { color: #f1f5f9; }
.wl-table-wrap { background: #1e293b; border: 1px solid #334155; border-radius: 16px; overflow: hidden; }
.wl-del-one { color: #fca5a5; background: none; border: none; cursor: pointer; font-size: 15px; padding: 4px 8px; border-radius: 6px; transition: all .15s; } .wl-del-one:hover { background: #450a0a; }
.wl-pagination { display: flex; gap: 6px; justify-content: center; padding: 16px; }
.wl-page, .wl-page-active, .wl-page-active-blue { padding: 6px 14px; border-radius: 10px; font-size: 14px; font-weight: 700; text-decoration: none; }
.wl-page { background: #334155; color: #94a3b8; }
.wl-page-active { background: #10b981; color: #fff; }
.wl-page-active-blue { background: #3b82f6; color: #fff; }
</style>
