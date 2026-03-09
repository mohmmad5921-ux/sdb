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
    <div class="wl-root">
        <!-- Sidebar -->
        <aside class="wl-sidebar">
            <div class="wl-logo"><div class="wl-logo-icon">SDB</div><span class="wl-logo-text">لوحة الإدارة</span></div>
            <nav class="wl-nav">
                <Link v-for="l in sideLinks" :key="l.route + l.label" :href="route(l.route)" :class="['wl-nav-item', l.active ? 'wl-nav-active' : '']">
                    <span class="wl-nav-icon">{{ l.icon }}</span><span>{{ l.label }}</span>
                </Link>
            </nav>
        </aside>

        <!-- Main -->
        <main class="wl-main">
            <header class="wl-topbar">
                <div>
                    <h1 class="wl-title">📩 إدارة قائمة الانتظار والتسجيلات</h1>
                    <p class="wl-subtitle">إدارة طلبات الانتظار والتسجيلات المبكرة</p>
                </div>
            </header>

            <div v-if="flash.success" class="mx-7 mt-4"><div class="wl-flash-success">✓ {{ flash.success }}</div></div>

            <div class="wl-content">
                <!-- Stats Row -->
                <div class="grid grid-cols-6 gap-4">
                    <div class="wl-stat"><div class="wl-stat-label">إجمالي الانتظار</div><div class="wl-stat-value">{{ stats.waitlist_total }}</div></div>
                    <div class="wl-stat"><div class="wl-stat-label">اليوم</div><div class="wl-stat-value" style="color:#34d399">+{{ stats.waitlist_today }}</div></div>
                    <div class="wl-stat"><div class="wl-stat-label">هذا الأسبوع</div><div class="wl-stat-value" style="color:#60a5fa">{{ stats.waitlist_week }}</div></div>
                    <div class="wl-stat"><div class="wl-stat-label">إجمالي التسجيل المبكر</div><div class="wl-stat-value">{{ stats.prereg_total }}</div></div>
                    <div class="wl-stat"><div class="wl-stat-label">اليوم</div><div class="wl-stat-value" style="color:#34d399">+{{ stats.prereg_today }}</div></div>
                    <div class="wl-stat"><div class="wl-stat-label">هذا الأسبوع</div><div class="wl-stat-value" style="color:#60a5fa">{{ stats.prereg_week }}</div></div>
                </div>

                <!-- Tabs + Actions -->
                <div class="flex gap-3 items-center flex-wrap">
                    <button @click="switchTab('waitlist')" :class="activeTab === 'waitlist' ? 'wl-tab-active' : 'wl-tab'" class="wl-tab-btn">📩 قائمة الانتظار ({{ stats.waitlist_total }})</button>
                    <button @click="switchTab('prereg')" :class="activeTab === 'prereg' ? 'wl-tab-active-blue' : 'wl-tab'" class="wl-tab-btn">📝 التسجيل المبكر ({{ stats.prereg_total }})</button>
                    <div class="flex-1"></div>
                    <a :href="route(activeTab === 'waitlist' ? 'export.waitlist' : 'export.preregistrations')" class="wl-export-btn">📥 تصدير CSV</a>
                    <button v-if="selected.length" @click="bulkDelete" class="wl-delete-btn">🗑 حذف ({{ selected.length }})</button>
                </div>

                <!-- Filters -->
                <div class="flex gap-4 items-end flex-wrap">
                    <div class="flex-1 min-w-[200px]"><label class="wl-filter-label">بحث</label><input v-model="search" @keyup.enter="applyFilters" type="text" placeholder="بريد، اسم، هاتف..." class="wl-input" /></div>
                    <div><label class="wl-filter-label">من تاريخ</label><input v-model="dateFrom" @change="applyFilters" type="date" class="wl-input" /></div>
                    <div><label class="wl-filter-label">إلى تاريخ</label><input v-model="dateTo" @change="applyFilters" type="date" class="wl-input" /></div>
                    <div v-if="activeTab === 'waitlist'"><label class="wl-filter-label">المصدر</label><select v-model="source" @change="applyFilters" class="wl-input"><option value="">الكل</option><option v-for="s in sources" :key="s" :value="s">{{ s }}</option></select></div>
                    <button @click="applyFilters" class="wl-search-btn">🔍 بحث</button>
                    <button @click="search=''; dateFrom=''; dateTo=''; source=''; applyFilters()" class="wl-clear-btn">↻ مسح</button>
                </div>

                <!-- Waitlist Table -->
                <div v-if="activeTab === 'waitlist'" class="wl-table-wrap">
                    <table class="wl-table">
                        <thead><tr>
                            <th class="w-10"><input type="checkbox" v-model="selectAll" @change="toggleAll" /></th>
                            <th>البريد الإلكتروني</th><th>المصدر</th><th>عنوان IP</th><th>تاريخ التسجيل</th><th class="w-16"></th>
                        </tr></thead>
                        <tbody>
                            <tr v-for="w in waitlist.data" :key="w.id">
                                <td><input type="checkbox" :value="w.id" v-model="selected" /></td>
                                <td class="wl-cell-email">{{ w.email }}</td>
                                <td><span class="wl-badge">{{ w.source || '—' }}</span></td>
                                <td class="wl-cell-mono">{{ w.ip_address || '—' }}</td>
                                <td class="wl-cell-date">{{ formatDate(w.created_at) }}</td>
                                <td><button @click="deleteOne('waitlist', w.id)" class="wl-del-btn">🗑</button></td>
                            </tr>
                            <tr v-if="!waitlist.data.length"><td colspan="6" class="wl-empty">لا توجد نتائج</td></tr>
                        </tbody>
                    </table>
                    <div v-if="waitlist.last_page > 1" class="wl-pagination">
                        <Link v-for="link in waitlist.links" :key="link.label" :href="link.url || '#'" v-html="link.label" :class="link.active ? 'wl-page-active' : 'wl-page'" />
                    </div>
                </div>

                <!-- Preregistrations Table -->
                <div v-if="activeTab === 'prereg'" class="wl-table-wrap">
                    <table class="wl-table">
                        <thead><tr>
                            <th class="w-10"><input type="checkbox" v-model="selectAll" @change="toggleAll" /></th>
                            <th>الاسم الكامل</th><th>البريد الإلكتروني</th><th>الهاتف</th><th>البلد</th><th>المحافظة</th><th>تاريخ التسجيل</th><th class="w-16"></th>
                        </tr></thead>
                        <tbody>
                            <tr v-for="p in preregistrations.data" :key="p.id">
                                <td><input type="checkbox" :value="p.id" v-model="selected" /></td>
                                <td class="wl-cell-name">{{ p.full_name }}</td>
                                <td class="wl-cell-email">{{ p.email }}</td>
                                <td class="wl-cell-mono" dir="ltr">{{ p.phone || '—' }}</td>
                                <td class="wl-cell-text">{{ p.country || '—' }}</td>
                                <td class="wl-cell-text">{{ p.governorate || '—' }}</td>
                                <td class="wl-cell-date">{{ formatDate(p.created_at) }}</td>
                                <td><button @click="deleteOne('prereg', p.id)" class="wl-del-btn">🗑</button></td>
                            </tr>
                            <tr v-if="!preregistrations.data.length"><td colspan="8" class="wl-empty">لا توجد نتائج</td></tr>
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

<style scoped>
/* ROOT */
.wl-root{display:flex;min-height:100vh;background:#080d1c;color:#e2e8f0;direction:rtl;font-family:'Inter','Segoe UI',sans-serif}

/* SIDEBAR */
.wl-sidebar{width:240px;background:#0c1225;border-left:1px solid rgba(255,255,255,0.06);flex-shrink:0;display:flex;flex-direction:column}
.wl-logo{display:flex;align-items:center;gap:12px;padding:20px 16px;border-bottom:1px solid rgba(255,255,255,0.06)}
.wl-logo-icon{width:36px;height:36px;background:linear-gradient(135deg,#10b981,#059669);border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:900;font-size:11px;flex-shrink:0}
.wl-logo-text{font-size:15px;font-weight:800;color:#e2e8f0}
.wl-nav{padding:12px 8px;flex:1;display:flex;flex-direction:column;gap:3px;overflow-y:auto}
.wl-nav-item{display:flex;align-items:center;gap:12px;padding:11px 14px;border-radius:12px;font-size:14px;color:rgba(226,232,240,0.5);text-decoration:none;font-weight:500;transition:all .15s}
.wl-nav-item:hover{background:rgba(255,255,255,0.04);color:rgba(226,232,240,0.8)}
.wl-nav-active{background:rgba(16,185,129,0.1)!important;color:#10b981!important;font-weight:700}
.wl-nav-icon{font-size:18px;width:24px;text-align:center}

/* MAIN */
.wl-main{flex:1;display:flex;flex-direction:column;overflow-y:auto}
.wl-topbar{display:flex;justify-content:space-between;align-items:center;padding:18px 28px;background:#0c1225;border-bottom:1px solid rgba(255,255,255,0.06)}
.wl-title{font-size:20px;font-weight:800;color:#e2e8f0;margin:0}
.wl-subtitle{font-size:13px;color:rgba(226,232,240,0.4);margin-top:2px}
.wl-content{padding:24px 28px;display:flex;flex-direction:column;gap:20px}

/* FLASH */
.wl-flash-success{background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.15);border-radius:14px;padding:14px 20px;color:#34d399;font-size:14px;font-weight:600}

/* STATS */
.wl-stat{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:16px;padding:18px;text-align:center}
.wl-stat-label{font-size:13px;color:rgba(226,232,240,0.4);font-weight:600;margin-bottom:6px}
.wl-stat-value{font-size:28px;font-weight:900;color:#e2e8f0}

/* TABS */
.wl-tab-btn{padding:10px 20px;border-radius:12px;font-size:14px;font-weight:700;border:1px solid rgba(255,255,255,0.06);cursor:pointer;transition:all .15s}
.wl-tab{background:transparent;color:rgba(226,232,240,0.4)}.wl-tab:hover{background:rgba(255,255,255,0.03);color:#e2e8f0}
.wl-tab-active{background:rgba(16,185,129,0.1)!important;color:#34d399!important;border-color:rgba(16,185,129,0.2)!important}
.wl-tab-active-blue{background:rgba(59,130,246,0.1)!important;color:#60a5fa!important;border-color:rgba(59,130,246,0.2)!important}
.wl-export-btn{padding:10px 18px;border-radius:12px;font-size:13px;font-weight:700;text-decoration:none;background:rgba(16,185,129,0.1);color:#34d399;border:1px solid rgba(16,185,129,0.2);transition:all .15s}.wl-export-btn:hover{background:rgba(16,185,129,0.15)}
.wl-delete-btn{padding:10px 18px;border-radius:12px;font-size:13px;font-weight:700;background:rgba(239,68,68,0.1);color:#f87171;border:1px solid rgba(239,68,68,0.2);cursor:pointer;transition:all .15s}.wl-delete-btn:hover{background:rgba(239,68,68,0.15)}

/* FILTERS */
.wl-filter-label{display:block;font-size:12px;color:rgba(226,232,240,0.4);font-weight:600;margin-bottom:6px}
.wl-input{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:12px;padding:10px 14px;color:#e2e8f0;font-size:14px;outline:none;width:100%;transition:border-color .15s}.wl-input:focus{border-color:#10b981}.wl-input::placeholder{color:rgba(226,232,240,0.25)}
.wl-search-btn{padding:10px 18px;background:#3b82f6;color:#fff;border-radius:12px;font-size:13px;font-weight:700;border:none;cursor:pointer;transition:all .15s}.wl-search-btn:hover{filter:brightness(1.1)}
.wl-clear-btn{padding:10px 18px;background:rgba(255,255,255,0.04);color:rgba(226,232,240,0.5);border-radius:12px;font-size:13px;font-weight:500;border:1px solid rgba(255,255,255,0.06);cursor:pointer}.wl-clear-btn:hover{color:#e2e8f0}

/* TABLE */
.wl-table-wrap{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:18px;overflow:hidden}
.wl-table{width:100%;border-collapse:collapse}
.wl-table th{text-align:right;font-size:13px;color:rgba(226,232,240,0.4);padding:14px 16px;border-bottom:2px solid rgba(255,255,255,0.06);font-weight:700;background:rgba(255,255,255,0.02)}
.wl-table td{padding:14px 16px;border-bottom:1px solid rgba(255,255,255,0.04);font-size:14px;color:rgba(226,232,240,0.7)}
.wl-table tr:hover td{background:rgba(255,255,255,0.02)}
.wl-cell-email{font-family:monospace;font-size:14px;color:#60a5fa}
.wl-cell-name{font-weight:700;color:#e2e8f0;font-size:14px}
.wl-cell-mono{font-family:monospace;font-size:13px;color:rgba(226,232,240,0.4)}
.wl-cell-text{color:rgba(226,232,240,0.6);font-size:14px}
.wl-cell-date{font-size:13px;color:rgba(226,232,240,0.4)}
.wl-del-btn{color:#f87171;background:none;border:none;cursor:pointer;font-size:14px;padding:4px 8px;border-radius:6px;transition:all .15s}.wl-del-btn:hover{background:rgba(239,68,68,0.1)}
.wl-badge{font-size:12px;padding:4px 12px;border-radius:100px;background:rgba(59,130,246,0.1);color:#60a5fa;font-weight:700}
.wl-empty{text-align:center;color:rgba(226,232,240,0.25);padding:28px;font-size:14px}

/* PAGINATION */
.wl-pagination{display:flex;gap:6px;justify-content:center;padding:16px}
.wl-page,.wl-page-active,.wl-page-active-blue{padding:6px 14px;border-radius:10px;font-size:13px;font-weight:700;text-decoration:none}
.wl-page{background:rgba(255,255,255,0.04);color:rgba(226,232,240,0.4)}
.wl-page-active{background:#10b981;color:#fff}
.wl-page-active-blue{background:#3b82f6;color:#fff}
</style>
