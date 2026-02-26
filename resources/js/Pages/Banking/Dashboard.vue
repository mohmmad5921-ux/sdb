<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed, watch } from 'vue';

const props = defineProps({ accounts: Array, cards: Array, recentTransactions: Array, totalBalanceEur: Number, currencies: Array });
const page = usePage();
const flash = computed(() => page.props.flash || {});

// Modals
const showTransfer = ref(false);
const showExchange = ref(false);
const showCardIssue = ref(false);
const showDeposit = ref(false);

// Transfer
const transferForm = useForm({ from_account_id: props.accounts?.[0]?.id || '', to_iban: '', amount: '', description: '' });
const submitTransfer = () => transferForm.post(route('banking.transfer'), { onSuccess: () => { showTransfer.value = false; transferForm.reset(); }});

// Exchange
const exchangeForm = useForm({ from_account_id: '', to_account_id: '', amount: '' });
const submitExchange = () => exchangeForm.post(route('banking.exchange'), { onSuccess: () => { showExchange.value = false; exchangeForm.reset(); }});

// Card Issue
const cardForm = useForm({ account_id: '' });
const submitCard = () => cardForm.post(route('banking.cards.issue'), { onSuccess: () => { showCardIssue.value = false; }});

// Deposit
const depositForm = useForm({
    account_id: props.accounts?.[0]?.id || '',
    amount: '',
    payment_method: 'card',
    card_number: '',
    card_holder: '',
    card_expiry: '',
    card_cvv: '',
});
const submitDeposit = () => depositForm.post(route('banking.deposit'), { onSuccess: () => { showDeposit.value = false; depositForm.reset(); depositForm.payment_method = 'card'; }});

// Fee calculator
const depositFee = computed(() => {
    const amt = parseFloat(depositForm.amount) || 0;
    return Math.round(((amt * 1.5 / 100) + 0.50) * 100) / 100;
});
const depositNet = computed(() => Math.max(0, (parseFloat(depositForm.amount) || 0) - depositFee.value));

// Card number formatting
const formatCardNumber = (e) => {
    let v = e.target.value.replace(/\D/g, '').substring(0, 16);
    depositForm.card_number = v.replace(/(.{4})/g, '$1 ').trim();
};
const formatExpiry = (e) => {
    let v = e.target.value.replace(/\D/g, '').substring(0, 4);
    if (v.length > 2) v = v.substring(0, 2) + '/' + v.substring(2);
    depositForm.card_expiry = v;
};

const formatAmount = (a, s) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2 }) + ' ' + s;

const typeLabels = { transfer: 'تحويل', deposit: 'إيداع', withdrawal: 'سحب', exchange: 'صرف', card_payment: 'دفع بالبطاقة', fee: 'رسوم', refund: 'استرداد' };
const statusColors = { completed: 'text-emerald-400', pending: 'text-yellow-400', failed: 'text-red-400', cancelled: 'text-gray-500' };
</script>

<template>
    <Head title="My Banking - حسابي" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#0a0f1c] text-white">

            <!-- Header -->
            <div class="px-6 py-6 border-b border-white/5">
                <div class="max-w-7xl mx-auto flex justify-between items-center">
                    <div>
                        <h1 class="text-2xl font-bold">حسابي المصرفي</h1>
                        <p class="text-gray-400 text-sm mt-1">الرصيد الإجمالي: <span class="text-emerald-400 font-bold text-lg">{{ formatAmount(totalBalanceEur, '€') }}</span></p>
                    </div>
                    <div v-if="$page.props.auth?.user?.customer_number" class="text-right">
                        <div class="text-xs text-gray-500">رقم العميل</div>
                        <div class="text-sm font-mono font-bold text-emerald-400 bg-emerald-500/10 px-3 py-1 rounded-lg border border-emerald-500/20 mt-0.5">{{ $page.props.auth.user.customer_number }}</div>
                    </div>
                </div>
            </div>

            <!-- Flash Messages -->
            <div v-if="flash.success" class="max-w-7xl mx-auto px-6 mt-4">
                <div class="bg-emerald-500/10 border border-emerald-500/20 rounded-xl px-4 py-3 text-emerald-400 text-sm">✓ {{ flash.success }}</div>
            </div>

            <div class="max-w-7xl mx-auto px-6 py-8 space-y-8">

                <!-- Quick Actions -->
                <div class="flex flex-wrap gap-2 mb-2">
                    <button @click="showDeposit = true" class="px-4 py-2.5 bg-gradient-to-r from-emerald-600 to-emerald-500 hover:from-emerald-500 hover:to-emerald-400 rounded-xl font-semibold text-sm shadow-lg shadow-emerald-500/20 transition-all">💳 إيداع</button>
                    <button @click="showTransfer = true" class="px-3 py-2.5 bg-white/5 hover:bg-white/10 border border-white/5 rounded-xl text-sm transition-all">↗ تحويل</button>
                    <button @click="showExchange = true" class="px-3 py-2.5 bg-white/5 hover:bg-white/10 border border-white/5 rounded-xl text-sm transition-all">💱 صرف</button>
                    <button @click="showCardIssue = true" class="px-3 py-2.5 bg-white/5 hover:bg-white/10 border border-white/5 rounded-xl text-sm transition-all">💳 بطاقة</button>
                </div>
                <div class="flex flex-wrap gap-2">
                    <Link :href="route('banking.transactions')" class="px-3 py-2 bg-white/5 hover:bg-emerald-500/10 border border-white/5 rounded-lg text-xs transition-all">📊 المعاملات</Link>
                    <Link :href="route('banking.analytics')" class="px-3 py-2 bg-white/5 hover:bg-emerald-500/10 border border-white/5 rounded-lg text-xs transition-all">📈 التحليلات</Link>
                    <Link :href="route('banking.beneficiaries')" class="px-3 py-2 bg-white/5 hover:bg-emerald-500/10 border border-white/5 rounded-lg text-xs transition-all">👥 المستفيدون</Link>
                    <Link :href="route('banking.support')" class="px-3 py-2 bg-white/5 hover:bg-emerald-500/10 border border-white/5 rounded-lg text-xs transition-all">🎧 الدعم</Link>
                    <Link :href="route('banking.security')" class="px-3 py-2 bg-white/5 hover:bg-emerald-500/10 border border-white/5 rounded-lg text-xs transition-all">🔒 الأمان</Link>
                    <Link :href="route('banking.referral')" class="px-3 py-2 bg-white/5 hover:bg-emerald-500/10 border border-white/5 rounded-lg text-xs transition-all">🎁 الإحالة</Link>
                    <Link :href="route('banking.kyc')" class="px-3 py-2 bg-white/5 hover:bg-emerald-500/10 border border-white/5 rounded-lg text-xs transition-all">🪪 KYC</Link>
                    <Link :href="route('banking.notifications')" class="px-3 py-2 bg-white/5 hover:bg-emerald-500/10 border border-white/5 rounded-lg text-xs transition-all">🔔 الإشعارات</Link>
                    <Link href="/profile" class="px-3 py-2 bg-white/5 hover:bg-emerald-500/10 border border-white/5 rounded-lg text-xs transition-all">👤 الملف</Link>
                </div>

                <!-- Accounts -->
                <div>
                    <h2 class="text-lg font-semibold mb-4">حساباتي</h2>
                    <div class="grid md:grid-cols-3 gap-4">
                        <div v-for="acc in accounts" :key="acc.id" class="bg-gradient-to-br from-white/[0.04] to-white/[0.01] border border-white/5 rounded-2xl p-5 hover:border-emerald-500/20 transition-all">
                            <div class="flex justify-between items-start mb-4">
                                <span class="text-3xl">{{ acc.currency?.symbol }}</span>
                                <span class="text-xs bg-emerald-500/10 text-emerald-400 px-2 py-0.5 rounded-full">{{ acc.status }}</span>
                            </div>
                            <div class="text-2xl font-bold mb-1">{{ formatAmount(acc.balance, acc.currency?.symbol) }}</div>
                            <div class="text-xs text-gray-500 font-mono">{{ acc.iban }}</div>
                            <div class="text-xs text-gray-600 mt-1">{{ acc.currency?.code }} - {{ acc.currency?.name_ar }}</div>
                        </div>
                    </div>
                </div>

                <!-- Cards -->
                <div v-if="cards.length">
                    <h2 class="text-lg font-semibold mb-4">بطاقاتي</h2>
                    <div class="grid md:grid-cols-2 gap-4">
                        <div v-for="card in cards" :key="card.id" class="bg-gradient-to-br from-blue-900/40 to-purple-900/30 border border-white/10 rounded-2xl p-6 relative overflow-hidden">
                            <div class="absolute top-0 right-0 w-32 h-32 bg-white/5 rounded-full -translate-y-8 translate-x-8"></div>
                            <div class="relative z-10">
                                <div class="flex justify-between items-start mb-6">
                                    <span class="text-lg font-bold">Mastercard</span>
                                    <span :class="card.status === 'active' ? 'bg-emerald-500/10 text-emerald-400' : 'bg-red-500/10 text-red-400'" class="text-xs px-2 py-0.5 rounded-full">{{ card.status }}</span>
                                </div>
                                <div class="text-xl font-mono tracking-wider mb-4 text-gray-300">{{ card.card_number_masked }}</div>
                                <div class="flex justify-between text-sm text-gray-400">
                                    <span>{{ card.card_holder_name }}</span>
                                    <span>{{ card.formatted_expiry }}</span>
                                </div>
                                <Link :href="route('banking.cards.toggle-freeze', card.id)" method="post" as="button"
                                    class="mt-4 text-xs px-3 py-1.5 bg-white/5 rounded-lg hover:bg-white/10 transition-colors">
                                    {{ card.status === 'active' ? '❄️ تجميد' : '🔓 تفعيل' }}
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Transactions -->
                <div class="bg-white/[0.02] border border-white/5 rounded-2xl overflow-hidden">
                    <div class="px-6 py-4 border-b border-white/5"><h3 class="font-semibold">آخر المعاملات</h3></div>
                    <div class="divide-y divide-white/5">
                        <div v-for="t in recentTransactions" :key="t.id" class="px-6 py-3 flex items-center justify-between hover:bg-white/[0.01]">
                            <div>
                                <div class="text-sm font-medium">{{ typeLabels[t.type] || t.type }}</div>
                                <div class="text-xs text-gray-500">{{ t.reference_number }} · {{ new Date(t.created_at).toLocaleDateString('en-GB') }}</div>
                            </div>
                            <div class="text-right">
                                <div class="text-sm font-semibold" :class="statusColors[t.status]">{{ formatAmount(t.amount, t.currency?.symbol || '€') }}</div>
                            </div>
                        </div>
                        <div v-if="!recentTransactions.length" class="px-6 py-8 text-center text-gray-500">لا توجد معاملات بعد</div>
                    </div>
                </div>
            </div>

            <!-- =================== DEPOSIT / TOP-UP MODAL =================== -->
            <Teleport to="body">
                <div v-if="showDeposit" class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm" @click.self="showDeposit = false">
                    <div class="bg-[#0f1629] border border-white/10 rounded-2xl w-full max-w-lg p-6 shadow-2xl max-h-[90vh] overflow-y-auto">
                        <div class="flex items-center gap-3 mb-6">
                            <div class="w-10 h-10 bg-emerald-500/20 rounded-xl flex items-center justify-center text-xl">💳</div>
                            <div>
                                <h3 class="text-xl font-bold">إيداع / شحن حسابك</h3>
                                <p class="text-gray-400 text-xs">Top up your account</p>
                            </div>
                        </div>

                        <form @submit.prevent="submitDeposit" class="space-y-5">
                            <!-- Account Selection -->
                            <div>
                                <label class="block text-sm text-gray-400 mb-1.5">إيداع إلى حساب</label>
                                <select v-model="depositForm.account_id" class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white outline-none focus:border-emerald-500">
                                    <option v-for="acc in accounts" :key="acc.id" :value="acc.id">{{ acc.currency?.code }} — {{ formatAmount(acc.balance, acc.currency?.symbol) }}</option>
                                </select>
                            </div>

                            <!-- Amount -->
                            <div>
                                <label class="block text-sm text-gray-400 mb-1.5">المبلغ</label>
                                <input v-model="depositForm.amount" type="number" step="0.01" min="1" max="50000" placeholder="0.00"
                                    class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white text-xl font-bold outline-none focus:border-emerald-500 placeholder-gray-600" />
                                <div class="flex justify-between mt-2 text-xs text-gray-500">
                                    <span>الرسوم: {{ depositFee.toFixed(2) }}</span>
                                    <span>سيضاف لحسابك: <span class="text-emerald-400 font-semibold">{{ depositNet.toFixed(2) }}</span></span>
                                </div>
                            </div>

                            <!-- Payment Method Selection -->
                            <div>
                                <label class="block text-sm text-gray-400 mb-2">طريقة الدفع</label>
                                <div class="grid grid-cols-3 gap-2">
                                    <button type="button" @click="depositForm.payment_method = 'card'"
                                        :class="depositForm.payment_method === 'card' ? 'border-emerald-500 bg-emerald-500/10' : 'border-white/10 bg-white/[0.02]'"
                                        class="border rounded-xl p-3 text-center transition-all hover:bg-white/5">
                                        <div class="text-2xl mb-1">💳</div>
                                        <div class="text-xs font-medium">Visa / MC</div>
                                    </button>
                                    <button type="button" @click="depositForm.payment_method = 'apple_pay'"
                                        :class="depositForm.payment_method === 'apple_pay' ? 'border-emerald-500 bg-emerald-500/10' : 'border-white/10 bg-white/[0.02]'"
                                        class="border rounded-xl p-3 text-center transition-all hover:bg-white/5">
                                        <div class="text-2xl mb-1"></div>
                                        <div class="text-xs font-medium">Apple Pay</div>
                                    </button>
                                    <button type="button" @click="depositForm.payment_method = 'google_pay'"
                                        :class="depositForm.payment_method === 'google_pay' ? 'border-emerald-500 bg-emerald-500/10' : 'border-white/10 bg-white/[0.02]'"
                                        class="border rounded-xl p-3 text-center transition-all hover:bg-white/5">
                                        <div class="text-2xl mb-1">G</div>
                                        <div class="text-xs font-medium">Google Pay</div>
                                    </button>
                                </div>
                            </div>

                            <!-- Card Details (shown for card method) -->
                            <div v-if="depositForm.payment_method === 'card'" class="space-y-3 bg-white/[0.02] border border-white/5 rounded-xl p-4">
                                <div class="text-xs text-gray-400 font-medium mb-2">تفاصيل البطاقة الخارجية</div>
                                <div>
                                    <input :value="depositForm.card_number" @input="formatCardNumber" type="text" maxlength="19" placeholder="0000 0000 0000 0000"
                                        class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500 font-mono tracking-wider placeholder-gray-600" />
                                </div>
                                <div>
                                    <input v-model="depositForm.card_holder" type="text" placeholder="اسم حامل البطاقة / Cardholder Name"
                                        class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500 placeholder-gray-600" />
                                </div>
                                <div class="grid grid-cols-2 gap-3">
                                    <input :value="depositForm.card_expiry" @input="formatExpiry" type="text" maxlength="5" placeholder="MM/YY"
                                        class="bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500 font-mono placeholder-gray-600" />
                                    <input v-model="depositForm.card_cvv" type="password" maxlength="4" placeholder="CVV"
                                        class="bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500 font-mono placeholder-gray-600" />
                                </div>
                                <div class="flex items-center gap-2 text-xs text-gray-500 mt-1">
                                    <span>🔒</span><span>بياناتك مؤمنة ومشفرة بالكامل</span>
                                </div>
                            </div>

                            <!-- Apple Pay / Google Pay info -->
                            <div v-if="depositForm.payment_method === 'apple_pay'" class="bg-white/[0.02] border border-white/5 rounded-xl p-5 text-center">
                                <div class="text-4xl mb-3"></div>
                                <div class="text-sm font-medium mb-1">Apple Pay</div>
                                <div class="text-xs text-gray-400 mb-3">ادفع بأمان باستخدام Apple Pay</div>
                                <input v-model="depositForm.card_holder" type="text" placeholder="اسمك / Your Name"
                                    class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500 placeholder-gray-600 text-center" />
                            </div>

                            <div v-if="depositForm.payment_method === 'google_pay'" class="bg-white/[0.02] border border-white/5 rounded-xl p-5 text-center">
                                <div class="text-4xl mb-3 font-bold bg-gradient-to-r from-blue-400 via-red-400 via-yellow-400 to-green-400 text-transparent bg-clip-text">G Pay</div>
                                <div class="text-sm font-medium mb-1">Google Pay</div>
                                <div class="text-xs text-gray-400 mb-3">ادفع بأمان باستخدام Google Pay</div>
                                <input v-model="depositForm.card_holder" type="text" placeholder="اسمك / Your Name"
                                    class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500 placeholder-gray-600 text-center" />
                            </div>

                            <!-- Errors -->
                            <div v-if="depositForm.errors.deposit" class="bg-red-500/10 border border-red-500/20 rounded-xl px-4 py-3 text-red-400 text-sm">{{ depositForm.errors.deposit }}</div>

                            <!-- Submit -->
                            <div class="flex gap-3 pt-1">
                                <button type="submit" :disabled="depositForm.processing"
                                    :class="depositForm.payment_method === 'apple_pay' ? 'bg-black' : depositForm.payment_method === 'google_pay' ? 'bg-white text-black' : 'bg-emerald-600 hover:bg-emerald-500'"
                                    class="flex-1 py-3.5 rounded-xl font-bold text-sm disabled:opacity-50 transition-all shadow-lg">
                                    <span v-if="depositForm.processing">جاري المعالجة...</span>
                                    <span v-else-if="depositForm.payment_method === 'apple_pay'"> Pay {{ depositForm.amount || '0.00' }}</span>
                                    <span v-else-if="depositForm.payment_method === 'google_pay'">G Pay {{ depositForm.amount || '0.00' }}</span>
                                    <span v-else>إيداع {{ depositForm.amount || '0.00' }}</span>
                                </button>
                                <button type="button" @click="showDeposit = false" class="flex-1 bg-white/5 hover:bg-white/10 py-3.5 rounded-xl text-sm">إلغاء</button>
                            </div>

                            <div class="text-center text-xs text-gray-600 flex items-center justify-center gap-2">
                                <span>Visa</span><span>•</span><span>Mastercard</span><span>•</span>
                                <span>Apple Pay</span><span>•</span><span>Google Pay</span>
                            </div>
                        </form>
                    </div>
                </div>
            </Teleport>

            <!-- Transfer Modal -->
            <Teleport to="body">
                <div v-if="showTransfer" class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm" @click.self="showTransfer = false">
                    <div class="bg-[#0f1629] border border-white/10 rounded-2xl w-full max-w-md p-6 shadow-2xl">
                        <h3 class="text-xl font-bold mb-6">تحويل أموال</h3>
                        <form @submit.prevent="submitTransfer" class="space-y-4">
                            <div><label class="block text-sm text-gray-400 mb-1">من حساب</label><select v-model="transferForm.from_account_id" class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500"><option v-for="acc in accounts" :key="acc.id" :value="acc.id">{{ acc.currency?.code }} — {{ formatAmount(acc.balance, acc.currency?.symbol) }}</option></select></div>
                            <div><label class="block text-sm text-gray-400 mb-1">IBAN المستفيد</label><input v-model="transferForm.to_iban" type="text" placeholder="SY..." class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500 font-mono" /></div>
                            <div><label class="block text-sm text-gray-400 mb-1">المبلغ</label><input v-model="transferForm.amount" type="number" step="0.01" class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500" /></div>
                            <div><label class="block text-sm text-gray-400 mb-1">الوصف</label><input v-model="transferForm.description" type="text" class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500" /></div>
                            <p v-if="transferForm.errors.to_iban" class="text-red-400 text-xs">{{ transferForm.errors.to_iban }}</p>
                            <p v-if="transferForm.errors.amount" class="text-red-400 text-xs">{{ transferForm.errors.amount }}</p>
                            <div class="flex gap-3"><button type="submit" :disabled="transferForm.processing" class="flex-1 bg-emerald-600 hover:bg-emerald-500 py-3 rounded-xl font-semibold disabled:opacity-50">تحويل</button><button type="button" @click="showTransfer = false" class="flex-1 bg-white/5 hover:bg-white/10 py-3 rounded-xl">إلغاء</button></div>
                        </form>
                    </div>
                </div>
            </Teleport>

            <!-- Exchange Modal -->
            <Teleport to="body">
                <div v-if="showExchange" class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm" @click.self="showExchange = false">
                    <div class="bg-[#0f1629] border border-white/10 rounded-2xl w-full max-w-md p-6 shadow-2xl">
                        <h3 class="text-xl font-bold mb-6">صرف عملات</h3>
                        <form @submit.prevent="submitExchange" class="space-y-4">
                            <div><label class="block text-sm text-gray-400 mb-1">من حساب</label><select v-model="exchangeForm.from_account_id" class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500"><option v-for="acc in accounts" :key="acc.id" :value="acc.id">{{ acc.currency?.code }} — {{ formatAmount(acc.balance, acc.currency?.symbol) }}</option></select></div>
                            <div><label class="block text-sm text-gray-400 mb-1">إلى حساب</label><select v-model="exchangeForm.to_account_id" class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500"><option v-for="acc in accounts" :key="acc.id" :value="acc.id">{{ acc.currency?.code }} — {{ formatAmount(acc.balance, acc.currency?.symbol) }}</option></select></div>
                            <div><label class="block text-sm text-gray-400 mb-1">المبلغ</label><input v-model="exchangeForm.amount" type="number" step="0.01" class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500" /></div>
                            <p v-if="exchangeForm.errors.amount" class="text-red-400 text-xs">{{ exchangeForm.errors.amount }}</p>
                            <div class="flex gap-3"><button type="submit" :disabled="exchangeForm.processing" class="flex-1 bg-blue-600 hover:bg-blue-500 py-3 rounded-xl font-semibold disabled:opacity-50">صرف</button><button type="button" @click="showExchange = false" class="flex-1 bg-white/5 hover:bg-white/10 py-3 rounded-xl">إلغاء</button></div>
                        </form>
                    </div>
                </div>
            </Teleport>

            <!-- Card Issue Modal -->
            <Teleport to="body">
                <div v-if="showCardIssue" class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm" @click.self="showCardIssue = false">
                    <div class="bg-[#0f1629] border border-white/10 rounded-2xl w-full max-w-md p-6 shadow-2xl">
                        <h3 class="text-xl font-bold mb-6">إصدار بطاقة ماستركارد افتراضية</h3>
                        <form @submit.prevent="submitCard" class="space-y-4">
                            <div><label class="block text-sm text-gray-400 mb-1">ربط بحساب</label><select v-model="cardForm.account_id" class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 text-white outline-none focus:border-emerald-500"><option v-for="acc in accounts" :key="acc.id" :value="acc.id">{{ acc.currency?.code }} — {{ formatAmount(acc.balance, acc.currency?.symbol) }}</option></select></div>
                            <p v-if="cardForm.errors.account_id" class="text-red-400 text-xs">{{ cardForm.errors.account_id }}</p>
                            <div class="flex gap-3"><button type="submit" :disabled="cardForm.processing" class="flex-1 bg-emerald-600 hover:bg-emerald-500 py-3 rounded-xl font-semibold disabled:opacity-50">إصدار</button><button type="button" @click="showCardIssue = false" class="flex-1 bg-white/5 hover:bg-white/10 py-3 rounded-xl">إلغاء</button></div>
                        </form>
                    </div>
                </div>
            </Teleport>

        </div>
    </AuthenticatedLayout>
</template>
