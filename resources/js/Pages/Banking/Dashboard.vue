<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed, watch } from 'vue';

const props = defineProps({ accounts: Array, cards: Array, recentTransactions: Array, totalBalanceEur: Number, currencies: Array, monthlySpending: Number, monthlyIncome: Number, weeklyData: Array, notifCount: Number, pendingTx: Number, kycStatus: String });
const flash = computed(() => usePage().props.flash || {});
const user = computed(() => usePage().props.auth?.user);

const showTransfer = ref(false);
const showExchange = ref(false);
const showCardIssue = ref(false);
const showDeposit = ref(false);

// Transfer
const transferForm = useForm({ from_account_id: props.accounts?.[0]?.id || '', to_iban: '', amount: '', description: '' });
const submitTransfer = () => transferForm.post(route('banking.transfer'), { onSuccess: () => { showTransfer.value = false; transferForm.reset(); } });

// Exchange
const exchangeForm = useForm({ from_account_id: '', to_account_id: '', amount: '' });
const submitExchange = () => exchangeForm.post(route('banking.exchange'), { onSuccess: () => { showExchange.value = false; exchangeForm.reset(); } });

// Card Issue
const cardForm = useForm({ account_id: '' });
const submitCard = () => cardForm.post(route('banking.cards.issue'), { onSuccess: () => { showCardIssue.value = false; cardForm.reset(); } });

// Deposit
const depositForm = useForm({ account_id: props.accounts?.[0]?.id || '', amount: '', payment_method: 'card', card_number: '', card_holder: '', card_expiry: '', card_cvv: '' });
const submitDeposit = () => depositForm.post(route('banking.deposit'), { onSuccess: () => { showDeposit.value = false; depositForm.reset(); } });
const depositFee = computed(() => { const amt = parseFloat(depositForm.amount) || 0; return Math.round(((amt * 1.5 / 100) + 0.50) * 100) / 100; });
const depositNet = computed(() => Math.max(0, (parseFloat(depositForm.amount) || 0) - depositFee.value));
const formatCardNumber = (e) => { let v = e.target.value.replace(/\s/g, '').replace(/\D/g, ''); v = v.match(/.{1,4}/g)?.join(' ') || v; depositForm.card_number = v; e.target.value = v; };
const formatExpiry = (e) => { let v = e.target.value.replace(/\D/g, ''); if (v.length >= 2) v = v.slice(0,2) + '/' + v.slice(2,4); depositForm.card_expiry = v; e.target.value = v; };

const fmt = (a, s = '€') => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + ' ' + s;
const fmtK = (a) => { if (a >= 1000000) return (a/1000000).toFixed(1) + 'M'; if (a >= 1000) return (a/1000).toFixed(1) + 'K'; return Number(a).toFixed(0); };
const typeLabels = { transfer: 'تحويل', deposit: 'إيداع', withdrawal: 'سحب', exchange: 'صرف', card_payment: 'دفع', fee: 'رسوم', refund: 'استرداد' };
const statusColors = { completed: 'text-emerald-400', pending: 'text-amber-400', failed: 'text-red-400', cancelled: 'text-gray-500' };
const statusLabels = { completed: 'مكتمل', pending: 'معلق', failed: 'فشل' };
const maxChart = computed(() => Math.max(...(props.weeklyData || []).map(d => Math.max(d.in, d.out)), 1));

const greetTime = computed(() => { const h = new Date().getHours(); return h < 12 ? 'صباح الخير' : h < 18 ? 'مساء الخير' : 'مساء الخير'; });

const navItems = [
  { label: 'الرئيسية', icon: '🏦', route: 'dashboard', active: true },
  { label: 'المعاملات', icon: '💸', route: 'banking.transactions' },
  { label: 'التحليلات', icon: '📊', route: 'banking.analytics' },
  { label: 'البطاقات', icon: '💳', route: 'banking.cards.show', needsCard: true },
  { label: 'المستفيدون', icon: '👥', route: 'banking.beneficiaries' },
  { label: 'KYC', icon: '🪪', route: 'banking.kyc' },
  { label: 'الإشعارات', icon: '🔔', route: 'banking.notifications', badge: props.notifCount },
  { label: 'الأمان', icon: '🔒', route: 'banking.security' },
  { label: 'الدعم', icon: '🎧', route: 'banking.support' },
  { label: 'الإحالة', icon: '🎁', route: 'banking.referral' },
];
</script>

<template>
    <Head title="My Banking - حسابي" />
    <AuthenticatedLayout>
        <div class="bd-root">
            <!-- Sidebar -->
            <aside class="bd-sidebar">
                <div class="bd-logo"><div class="text-lg font-black">SDB</div><div class="text-[10px] text-gray-500">Net Banking</div></div>
                <nav class="bd-nav">
                    <template v-for="n in navItems" :key="n.route">
                        <Link v-if="!n.needsCard || cards.length" :href="n.needsCard ? route(n.route, cards[0]?.id) : route(n.route)" :class="['bd-nav-item', n.active ? 'bd-nav-active' : '']">
                            <span>{{ n.icon }}</span><span class="flex-1">{{ n.label }}</span>
                            <span v-if="n.badge" class="bd-badge">{{ n.badge }}</span>
                        </Link>
                    </template>
                </nav>
                <div class="bd-sidebar-footer">
                    <Link href="/profile" class="bd-nav-item"><span>👤</span><span>الملف الشخصي</span></Link>
                </div>
            </aside>

            <!-- Main -->
            <main class="bd-main">
                <!-- Top Bar -->
                <header class="bd-topbar">
                    <div>
                        <h1 class="text-lg font-bold text-white">{{ greetTime }}، {{ user?.full_name?.split(' ')[0] }} 👋</h1>
                        <p class="text-xs text-gray-500">{{ new Date().toLocaleDateString('ar-EG', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }) }}</p>
                    </div>
                    <div class="flex items-center gap-3">
                        <div v-if="user?.customer_number" class="text-xs font-mono text-emerald-400 bg-emerald-500/10 px-3 py-1.5 rounded-lg border border-emerald-500/20">{{ user.customer_number }}</div>
                        <Link :href="route('banking.notifications')" class="bd-notif-btn">
                            🔔 <span v-if="notifCount" class="bd-notif-dot">{{ notifCount }}</span>
                        </Link>
                    </div>
                </header>

                <div v-if="flash.success" class="mx-6 mt-4"><div class="bg-emerald-500/10 border border-emerald-500/20 rounded-xl px-4 py-3 text-emerald-400 text-sm">✓ {{ flash.success }}</div></div>

                <!-- KYC Banner -->
                <div v-if="kycStatus !== 'verified'" class="mx-6 mt-4">
                    <Link :href="route('banking.kyc')" class="block bg-amber-500/10 border border-amber-500/20 rounded-xl px-4 py-3 text-amber-400 text-sm hover:bg-amber-500/15 transition-colors">
                        ⚠️ {{ kycStatus === 'submitted' ? 'مراجعة الهوية جارية...' : 'يرجى إكمال التحقق من الهوية KYC لتفعيل جميع الميزات' }}
                    </Link>
                </div>

                <div class="bd-content">
                    <!-- Quick Actions -->
                    <div class="flex flex-wrap gap-2">
                        <button @click="showDeposit = true" class="bd-qa-primary">💳 إيداع</button>
                        <button @click="showTransfer = true" class="bd-qa">↗ تحويل</button>
                        <button @click="showExchange = true" class="bd-qa">💱 صرف عملات</button>
                        <button @click="showCardIssue = true" class="bd-qa">💳 إصدار بطاقة</button>
                    </div>

                    <!-- Balance + Summary Row -->
                    <div class="grid grid-cols-4 gap-4">
                        <div class="bd-stat-card col-span-1">
                            <div class="text-xs text-gray-500 mb-1">الرصيد الإجمالي</div>
                            <div class="text-2xl font-black text-white">{{ fmt(totalBalanceEur) }}</div>
                            <div class="text-[10px] text-gray-600 mt-1">{{ accounts.length }} حسابات · {{ cards.length }} بطاقات</div>
                        </div>
                        <div class="bd-stat-card">
                            <div class="text-xs text-gray-500 mb-1">الوارد هذا الشهر</div>
                            <div class="text-2xl font-black text-emerald-400">+{{ fmtK(monthlyIncome) }}</div>
                            <div class="text-[10px] text-emerald-500/40 mt-1">📈 دخل</div>
                        </div>
                        <div class="bd-stat-card">
                            <div class="text-xs text-gray-500 mb-1">المنفق هذا الشهر</div>
                            <div class="text-2xl font-black text-rose-400">-{{ fmtK(monthlySpending) }}</div>
                            <div class="text-[10px] text-rose-500/40 mt-1">📉 مصروف</div>
                        </div>
                        <div class="bd-stat-card">
                            <div class="text-xs text-gray-500 mb-1">معاملات معلقة</div>
                            <div class="text-2xl font-black" :class="pendingTx > 0 ? 'text-amber-400' : 'text-gray-600'">{{ pendingTx }}</div>
                            <div class="text-[10px] text-gray-600 mt-1">{{ pendingTx > 0 ? '⏳ قيد المعالجة' : '✅ لا شيء معلق' }}</div>
                        </div>
                    </div>

                    <!-- Accounts + Chart Row -->
                    <div class="grid grid-cols-3 gap-4">
                        <!-- Accounts -->
                        <div class="col-span-2 space-y-3">
                            <h2 class="text-sm font-bold text-white">💰 حساباتي</h2>
                            <div class="grid grid-cols-2 gap-3">
                                <div v-for="acc in accounts" :key="acc.id" class="bd-account-card">
                                    <div class="flex justify-between items-start mb-3">
                                        <span class="text-2xl">{{ acc.currency?.symbol }}</span>
                                        <span :class="acc.status === 'active' ? 'bd-status-green' : acc.status === 'frozen' ? 'bd-status-blue' : 'bd-status-red'" class="bd-status-pill">{{ acc.status === 'active' ? 'نشط' : acc.status === 'frozen' ? 'مجمّد' : 'مغلق' }}</span>
                                    </div>
                                    <div class="text-xl font-black text-white mb-1">{{ fmt(acc.balance, acc.currency?.symbol) }}</div>
                                    <div class="text-[10px] text-gray-500 font-mono mb-0.5">{{ acc.iban }}</div>
                                    <div class="text-[10px] text-gray-600">{{ acc.currency?.code }} · {{ acc.currency?.name_ar }}</div>
                                </div>
                            </div>
                        </div>
                        <!-- Weekly Chart -->
                        <div class="bd-chart-card">
                            <h3 class="text-xs font-bold text-white mb-3">📊 نشاط آخر 7 أيام</h3>
                            <div class="bd-mini-chart">
                                <div v-for="d in weeklyData" :key="d.day" class="bd-chart-col">
                                    <div class="bd-chart-bars">
                                        <div class="bd-bar bd-bar-in" :style="{height: Math.max((d.in / maxChart) * 100, 3) + '%'}" :title="'وارد: ' + d.in"></div>
                                        <div class="bd-bar bd-bar-out" :style="{height: Math.max((d.out / maxChart) * 100, 3) + '%'}" :title="'صادر: ' + d.out"></div>
                                    </div>
                                    <div class="text-[9px] text-gray-600 mt-1">{{ d.day }}</div>
                                </div>
                            </div>
                            <div class="flex gap-4 mt-3 text-[10px] text-gray-500">
                                <span class="flex items-center gap-1"><span class="w-2 h-2 rounded-full bg-emerald-500"></span> وارد</span>
                                <span class="flex items-center gap-1"><span class="w-2 h-2 rounded-full bg-rose-500"></span> صادر</span>
                            </div>
                        </div>
                    </div>

                    <!-- Cards -->
                    <div v-if="cards.length">
                        <h2 class="text-sm font-bold text-white mb-3">💳 بطاقاتي</h2>
                        <div class="grid grid-cols-2 gap-4">
                            <div v-for="card in cards" :key="card.id" class="bd-card-visual" :class="card.card_type === 'virtual' ? 'bd-card-virtual' : 'bd-card-physical'">
                                <div v-if="card.status === 'frozen'" class="absolute inset-0 bg-blue-950/90 backdrop-blur-sm flex items-center justify-center rounded-2xl z-20"><div class="text-center"><div class="text-3xl mb-1">❄️</div><div class="font-bold text-blue-300 text-sm">البطاقة مجمّدة</div></div></div>
                                <div class="relative z-10">
                                    <div class="flex justify-between items-start mb-6">
                                        <span class="text-sm font-bold text-white/80">{{ card.card_type === 'virtual' ? 'Virtual' : 'Physical' }}</span>
                                        <span class="text-xs font-bold text-white/60">SDB</span>
                                    </div>
                                    <div class="text-lg font-mono tracking-[3px] text-white/90 mb-4">{{ card.card_number_masked }}</div>
                                    <div class="flex justify-between items-end">
                                        <div><div class="text-[8px] text-white/40 uppercase mb-0.5">HOLDER</div><div class="text-xs text-white/80 font-semibold">{{ card.card_holder_name }}</div></div>
                                        <div class="text-left"><div class="text-[8px] text-white/40 uppercase mb-0.5">EXPIRES</div><div class="text-xs text-white/80 font-semibold">{{ card.formatted_expiry }}</div></div>
                                    </div>
                                    <div class="mt-3 flex gap-2">
                                        <Link :href="route('banking.cards.toggle-freeze', card.id)" method="post" as="button" class="text-[10px] px-3 py-1 bg-white/10 rounded-lg hover:bg-white/20 transition text-white/70">{{ card.status === 'active' ? '❄️ تجميد' : '🔓 تفعيل' }}</Link>
                                        <Link :href="route('banking.cards.show', card.id)" class="text-[10px] px-3 py-1 bg-white/10 rounded-lg hover:bg-white/20 transition text-white/70">⚙️ إدارة</Link>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Transactions -->
                    <div class="bd-card rounded-2xl overflow-hidden">
                        <div class="flex justify-between items-center px-5 py-3 border-b border-white/5">
                            <h3 class="text-sm font-bold text-white">📋 آخر المعاملات</h3>
                            <Link :href="route('banking.transactions')" class="text-xs text-emerald-400 hover:underline">عرض الكل ←</Link>
                        </div>
                        <div class="divide-y divide-white/5">
                            <div v-for="t in recentTransactions" :key="t.id" class="px-5 py-3 flex items-center justify-between hover:bg-white/[0.02] transition">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 rounded-lg bg-white/5 flex items-center justify-center text-sm">{{ t.type === 'transfer' ? '↗' : t.type === 'deposit' ? '💳' : t.type === 'exchange' ? '💱' : '💸' }}</div>
                                    <div>
                                        <div class="text-sm font-medium text-white">{{ typeLabels[t.type] || t.type }}</div>
                                        <div class="text-[10px] text-gray-600">{{ t.reference_number }} · {{ new Date(t.created_at).toLocaleDateString('ar-EG',{day:'numeric',month:'short'}) }}</div>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <div class="text-sm font-bold" :class="statusColors[t.status]">{{ fmt(t.amount, t.currency?.symbol || '€') }}</div>
                                    <div class="text-[10px]" :class="statusColors[t.status]">{{ statusLabels[t.status] || t.status }}</div>
                                </div>
                            </div>
                            <div v-if="!recentTransactions.length" class="px-6 py-10 text-center text-gray-600">لا توجد معاملات بعد</div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- =================== MODALS =================== -->
        <!-- Deposit Modal -->
        <Teleport to="body">
            <div v-if="showDeposit" class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm" @click.self="showDeposit = false">
                <div class="bg-[#0f1629] border border-white/10 rounded-2xl w-full max-w-lg p-6 shadow-2xl max-h-[90vh] overflow-y-auto">
                    <div class="flex items-center gap-3 mb-6"><div class="w-10 h-10 bg-emerald-500/20 rounded-xl flex items-center justify-center text-xl">💳</div><div><h3 class="text-xl font-bold text-white">إيداع / شحن حسابك</h3><p class="text-gray-400 text-xs">Top up your account</p></div></div>
                    <form @submit.prevent="submitDeposit" class="space-y-5">
                        <div><label class="block text-sm text-gray-400 mb-1.5">إيداع إلى حساب</label><select v-model="depositForm.account_id" class="bd-select"><option v-for="acc in accounts" :key="acc.id" :value="acc.id">{{ acc.currency?.code }} — {{ fmt(acc.balance, acc.currency?.symbol) }}</option></select></div>
                        <div><label class="block text-sm text-gray-400 mb-1.5">المبلغ</label><input v-model="depositForm.amount" type="number" step="0.01" min="1" max="50000" placeholder="0.00" class="bd-input text-xl font-bold" /><div class="flex justify-between mt-2 text-xs text-gray-500"><span>الرسوم: {{ depositFee.toFixed(2) }}</span><span>سيضاف: <span class="text-emerald-400 font-semibold">{{ depositNet.toFixed(2) }}</span></span></div></div>
                        <div><label class="block text-sm text-gray-400 mb-2">طريقة الدفع</label>
                            <div class="grid grid-cols-3 gap-2">
                                <button type="button" @click="depositForm.payment_method = 'card'" :class="depositForm.payment_method === 'card' ? 'border-emerald-500 bg-emerald-500/10' : 'border-white/10'" class="border rounded-xl p-3 text-center transition text-white"><div class="text-2xl mb-1">💳</div><div class="text-xs">Visa / MC</div></button>
                                <button type="button" @click="depositForm.payment_method = 'apple_pay'" :class="depositForm.payment_method === 'apple_pay' ? 'border-emerald-500 bg-emerald-500/10' : 'border-white/10'" class="border rounded-xl p-3 text-center transition text-white"><div class="text-2xl mb-1"></div><div class="text-xs">Apple Pay</div></button>
                                <button type="button" @click="depositForm.payment_method = 'google_pay'" :class="depositForm.payment_method === 'google_pay' ? 'border-emerald-500 bg-emerald-500/10' : 'border-white/10'" class="border rounded-xl p-3 text-center transition text-white"><div class="text-2xl mb-1 font-bold bg-gradient-to-r from-blue-400 via-red-400 to-green-400 text-transparent bg-clip-text">G</div><div class="text-xs">Google Pay</div></button>
                            </div>
                        </div>
                        <div v-if="depositForm.payment_method === 'card'" class="space-y-3 bg-white/[0.02] border border-white/5 rounded-xl p-4">
                            <div class="text-xs text-gray-400 font-medium mb-2">تفاصيل البطاقة</div>
                            <input :value="depositForm.card_number" @input="formatCardNumber" type="text" maxlength="19" placeholder="0000 0000 0000 0000" class="bd-input font-mono tracking-wider" />
                            <input v-model="depositForm.card_holder" type="text" placeholder="اسم حامل البطاقة" class="bd-input" />
                            <div class="grid grid-cols-2 gap-3">
                                <input :value="depositForm.card_expiry" @input="formatExpiry" type="text" maxlength="5" placeholder="MM/YY" class="bd-input font-mono" />
                                <input v-model="depositForm.card_cvv" type="password" maxlength="4" placeholder="CVV" class="bd-input font-mono" />
                            </div>
                            <div class="flex items-center gap-2 text-xs text-gray-500"><span>🔒</span><span>بياناتك مؤمنة ومشفرة</span></div>
                        </div>
                        <div v-if="depositForm.payment_method === 'apple_pay'" class="bg-white/[0.02] border border-white/5 rounded-xl p-5 text-center text-white"><div class="text-4xl mb-3"></div><div class="text-sm font-medium mb-3">Apple Pay</div><input v-model="depositForm.card_holder" placeholder="اسمك" class="bd-input text-center" /></div>
                        <div v-if="depositForm.payment_method === 'google_pay'" class="bg-white/[0.02] border border-white/5 rounded-xl p-5 text-center text-white"><div class="text-2xl font-bold mb-3 bg-gradient-to-r from-blue-400 via-red-400 to-green-400 text-transparent bg-clip-text">G Pay</div><input v-model="depositForm.card_holder" placeholder="اسمك" class="bd-input text-center" /></div>
                        <div v-if="depositForm.errors.deposit" class="bg-red-500/10 border border-red-500/20 rounded-xl px-4 py-3 text-red-400 text-sm">{{ depositForm.errors.deposit }}</div>
                        <div class="flex gap-3"><button type="submit" :disabled="depositForm.processing" class="flex-1 bg-emerald-600 hover:bg-emerald-500 py-3.5 rounded-xl font-bold text-sm text-white disabled:opacity-50">{{ depositForm.processing ? 'جاري...' : 'إيداع ' + (depositForm.amount || '0.00') }}</button><button type="button" @click="showDeposit = false" class="flex-1 bg-white/5 hover:bg-white/10 py-3.5 rounded-xl text-sm text-white">إلغاء</button></div>
                    </form>
                </div>
            </div>
        </Teleport>

        <!-- Transfer Modal -->
        <Teleport to="body">
            <div v-if="showTransfer" class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm" @click.self="showTransfer = false">
                <div class="bg-[#0f1629] border border-white/10 rounded-2xl w-full max-w-md p-6 shadow-2xl">
                    <h3 class="text-xl font-bold mb-6 text-white">↗ تحويل أموال</h3>
                    <form @submit.prevent="submitTransfer" class="space-y-4">
                        <div><label class="block text-sm text-gray-400 mb-1">من حساب</label><select v-model="transferForm.from_account_id" class="bd-select"><option v-for="acc in accounts" :key="acc.id" :value="acc.id">{{ acc.currency?.code }} — {{ fmt(acc.balance, acc.currency?.symbol) }}</option></select></div>
                        <div><label class="block text-sm text-gray-400 mb-1">IBAN المستفيد</label><input v-model="transferForm.to_iban" type="text" placeholder="SY..." class="bd-input font-mono" /></div>
                        <div><label class="block text-sm text-gray-400 mb-1">المبلغ</label><input v-model="transferForm.amount" type="number" step="0.01" class="bd-input" /></div>
                        <div><label class="block text-sm text-gray-400 mb-1">الوصف</label><input v-model="transferForm.description" type="text" class="bd-input" /></div>
                        <p v-if="transferForm.errors.to_iban" class="text-red-400 text-xs">{{ transferForm.errors.to_iban }}</p>
                        <p v-if="transferForm.errors.amount" class="text-red-400 text-xs">{{ transferForm.errors.amount }}</p>
                        <div class="flex gap-3"><button type="submit" :disabled="transferForm.processing" class="flex-1 bg-emerald-600 hover:bg-emerald-500 py-3 rounded-xl font-semibold text-white disabled:opacity-50">تحويل</button><button type="button" @click="showTransfer = false" class="flex-1 bg-white/5 hover:bg-white/10 py-3 rounded-xl text-white">إلغاء</button></div>
                    </form>
                </div>
            </div>
        </Teleport>

        <!-- Exchange Modal -->
        <Teleport to="body">
            <div v-if="showExchange" class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm" @click.self="showExchange = false">
                <div class="bg-[#0f1629] border border-white/10 rounded-2xl w-full max-w-md p-6 shadow-2xl">
                    <h3 class="text-xl font-bold mb-6 text-white">💱 صرف عملات</h3>
                    <form @submit.prevent="submitExchange" class="space-y-4">
                        <div><label class="block text-sm text-gray-400 mb-1">من حساب</label><select v-model="exchangeForm.from_account_id" class="bd-select"><option v-for="acc in accounts" :key="acc.id" :value="acc.id">{{ acc.currency?.code }} — {{ fmt(acc.balance, acc.currency?.symbol) }}</option></select></div>
                        <div><label class="block text-sm text-gray-400 mb-1">إلى حساب</label><select v-model="exchangeForm.to_account_id" class="bd-select"><option v-for="acc in accounts" :key="acc.id" :value="acc.id">{{ acc.currency?.code }} — {{ fmt(acc.balance, acc.currency?.symbol) }}</option></select></div>
                        <div><label class="block text-sm text-gray-400 mb-1">المبلغ</label><input v-model="exchangeForm.amount" type="number" step="0.01" class="bd-input" /></div>
                        <p v-if="exchangeForm.errors.amount" class="text-red-400 text-xs">{{ exchangeForm.errors.amount }}</p>
                        <div class="flex gap-3"><button type="submit" :disabled="exchangeForm.processing" class="flex-1 bg-blue-600 hover:bg-blue-500 py-3 rounded-xl font-semibold text-white disabled:opacity-50">صرف</button><button type="button" @click="showExchange = false" class="flex-1 bg-white/5 hover:bg-white/10 py-3 rounded-xl text-white">إلغاء</button></div>
                    </form>
                </div>
            </div>
        </Teleport>

        <!-- Card Issue Modal -->
        <Teleport to="body">
            <div v-if="showCardIssue" class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm" @click.self="showCardIssue = false">
                <div class="bg-[#0f1629] border border-white/10 rounded-2xl w-full max-w-md p-6 shadow-2xl">
                    <h3 class="text-xl font-bold mb-6 text-white">💳 إصدار بطاقة ماستركارد افتراضية</h3>
                    <form @submit.prevent="submitCard" class="space-y-4">
                        <div><label class="block text-sm text-gray-400 mb-1">ربط بحساب</label><select v-model="cardForm.account_id" class="bd-select"><option v-for="acc in accounts" :key="acc.id" :value="acc.id">{{ acc.currency?.code }} — {{ fmt(acc.balance, acc.currency?.symbol) }}</option></select></div>
                        <p v-if="cardForm.errors.account_id" class="text-red-400 text-xs">{{ cardForm.errors.account_id }}</p>
                        <div class="flex gap-3"><button type="submit" :disabled="cardForm.processing" class="flex-1 bg-emerald-600 hover:bg-emerald-500 py-3 rounded-xl font-semibold text-white disabled:opacity-50">إصدار</button><button type="button" @click="showCardIssue = false" class="flex-1 bg-white/5 hover:bg-white/10 py-3 rounded-xl text-white">إلغاء</button></div>
                    </form>
                </div>
            </div>
        </Teleport>
    </AuthenticatedLayout>
</template>

<style scoped>
.bd-root{display:flex;min-height:100vh;background:#060b18;color:#fff}
.bd-sidebar{width:200px;background:#0a0f1f;border-left:1px solid rgba(255,255,255,0.05);flex-shrink:0;display:flex;flex-direction:column}
.bd-logo{padding:16px;border-bottom:1px solid rgba(255,255,255,0.05);text-align:center}
.bd-nav{padding:10px 8px;flex:1;display:flex;flex-direction:column;gap:2px}
.bd-nav-item{display:flex;align-items:center;gap:8px;padding:9px 12px;border-radius:10px;font-size:12px;color:rgba(255,255,255,0.4);text-decoration:none;font-weight:500;transition:all .2s}.bd-nav-item:hover{background:rgba(255,255,255,0.03);color:rgba(255,255,255,0.7)}
.bd-nav-active{background:rgba(16,185,129,0.1)!important;color:#10b981!important;font-weight:700}
.bd-badge{font-size:10px;background:#ef4444;color:#fff;padding:1px 6px;border-radius:100px;font-weight:700;min-width:18px;text-align:center}
.bd-sidebar-footer{padding:8px;border-top:1px solid rgba(255,255,255,0.05)}
.bd-main{flex:1;display:flex;flex-direction:column;overflow-y:auto}
.bd-topbar{display:flex;justify-content:space-between;align-items:center;padding:14px 24px;border-bottom:1px solid rgba(255,255,255,0.05)}
.bd-notif-btn{position:relative;padding:6px 10px;border:1px solid rgba(255,255,255,0.05);border-radius:10px;font-size:16px;text-decoration:none}
.bd-notif-dot{position:absolute;top:-4px;right:-4px;font-size:9px;background:#ef4444;color:#fff;padding:1px 5px;border-radius:100px;font-weight:700}
.bd-content{padding:20px 24px;display:flex;flex-direction:column;gap:16px}
.bd-qa-primary{padding:10px 20px;background:linear-gradient(135deg,#10b981,#059669);border-radius:12px;font-size:13px;font-weight:700;color:#fff;border:none;cursor:pointer;box-shadow:0 4px 15px rgba(16,185,129,0.3)}.bd-qa-primary:hover{filter:brightness(1.1)}
.bd-qa{padding:10px 16px;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.06);border-radius:12px;font-size:13px;color:rgba(255,255,255,0.7);cursor:pointer}.bd-qa:hover{background:rgba(255,255,255,0.08);color:#fff}
.bd-stat-card{background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.05);border-radius:14px;padding:16px}
.bd-account-card{background:linear-gradient(135deg,rgba(255,255,255,0.03),rgba(255,255,255,0.01));border:1px solid rgba(255,255,255,0.06);border-radius:16px;padding:16px;transition:all .2s}.bd-account-card:hover{border-color:rgba(16,185,129,0.2)}
.bd-status-pill{font-size:10px;padding:2px 8px;border-radius:100px;font-weight:600}
.bd-status-green{background:rgba(16,185,129,0.1);color:#10b981}.bd-status-blue{background:rgba(59,130,246,0.1);color:#3b82f6}.bd-status-red{background:rgba(239,68,68,0.1);color:#ef4444}
.bd-chart-card{background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.05);border-radius:16px;padding:16px}
.bd-mini-chart{display:flex;gap:6px;height:80px;align-items:flex-end}
.bd-chart-col{flex:1;display:flex;flex-direction:column;align-items:center}
.bd-chart-bars{height:65px;display:flex;gap:2px;align-items:flex-end;width:100%}
.bd-bar{flex:1;border-radius:3px 3px 0 0;min-height:2px;transition:height .4s}
.bd-bar-in{background:linear-gradient(180deg,#10b981,#059669)}.bd-bar-out{background:linear-gradient(180deg,#f43f5e,#e11d48)}
.bd-card-visual{position:relative;border-radius:16px;padding:20px;overflow:hidden;aspect-ratio:1.7;border:1px solid rgba(255,255,255,0.08)}
.bd-card-virtual{background:linear-gradient(145deg,#5b21b6,#7c3aed,#8b5cf6)}.bd-card-physical{background:linear-gradient(145deg,#1a1a2e,#0f0f1e,#16162a)}
.bd-card{background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.05)}
.bd-select{width:100%;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:12px;padding:10px 14px;color:#fff;outline:none;font-size:13px}.bd-select:focus{border-color:#10b981}
.bd-input{width:100%;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:12px;padding:10px 14px;color:#fff;outline:none;font-size:13px}.bd-input:focus{border-color:#10b981}.bd-input::placeholder{color:rgba(255,255,255,0.2)}
</style>
