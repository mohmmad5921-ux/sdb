<script setup>
import { Head, Link, useForm, usePage, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ user: Object, accounts: Array, cards: Array, kycDocuments: Array, transactions: Array, cardTransactions: Array, totalBalance: Number, loginHistory: Array });
const flash = computed(() => usePage().props.flash || {});

const fmt = (a, s = '€') => new Intl.NumberFormat('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(a) + ' ' + s;
const fmtDate = (d) => new Date(d).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
const fmtShort = (d) => new Date(d).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', year: 'numeric' });

// Status & KYC forms
const statusForm = useForm({ status: props.user.status });
const kycForm = useForm({ kyc_status: props.user.kyc_status });
const updateStatus = () => statusForm.patch(route('admin.users.status', props.user.id));
const updateKyc = () => kycForm.patch(route('admin.users.kyc', props.user.id));

// Profile edit form
const showEditProfile = ref(false);
const profileForm = useForm({ full_name: props.user.full_name, email: props.user.email, phone: props.user.phone || '', nationality: props.user.nationality || '', address: props.user.address || '', city: props.user.city || '', country: props.user.country || '' });
const saveProfile = () => profileForm.patch(route('admin.users.update-profile', props.user.id), { onSuccess: () => showEditProfile.value = false });

// Admin actions
const resetPassword = () => { if (confirm('هل أنت متأكد من إعادة تعيين كلمة المرور؟')) router.post(route('admin.users.reset-password', props.user.id)); };
const freezeAll = () => { if (confirm('تجميد جميع الحسابات والبطاقات؟')) router.post(route('admin.users.freeze-all', props.user.id)); };
const unfreezeAll = () => router.post(route('admin.users.unfreeze-all', props.user.id));

// Send notification
const showSendNote = ref(false);
const noteForm = useForm({ note: '' });
const sendNote = () => noteForm.post(route('admin.users.send-note', props.user.id), { onSuccess: () => { showSendNote.value = false; noteForm.reset(); } });

const activeTab = ref('overview');
const tabs = [
  { id: 'overview', label: 'نظرة عامة', icon: '📊' },
  { id: 'accounts', label: 'الحسابات', icon: '🏦' },
  { id: 'cards', label: 'البطاقات', icon: '💳' },
  { id: 'transactions', label: 'المعاملات', icon: '💸' },
  { id: 'purchases', label: 'المشتريات', icon: '🛒' },
  { id: 'kyc', label: 'KYC', icon: '🪪' },
  { id: 'security', label: 'الأمان', icon: '🔒' },
  { id: 'actions', label: 'تحكم إداري', icon: '⚡' },
];

const statusBadge = { active: 'ud-badge-green', pending: 'ud-badge-yellow', suspended: 'ud-badge-red', blocked: 'ud-badge-red', verified: 'ud-badge-green', submitted: 'ud-badge-yellow', rejected: 'ud-badge-red', completed: 'ud-badge-green', failed: 'ud-badge-red', frozen: 'ud-badge-blue' };
const typeLabels = { transfer: 'تحويل', deposit: 'إيداع', withdrawal: 'سحب', exchange: 'صرف عملات', card_payment: 'دفع بالبطاقة', fee: 'رسوم', refund: 'استرداد' };
const typeIcons = { transfer: '↗️', deposit: '💰', withdrawal: '📤', exchange: '💱', card_payment: '💳', fee: '📋', refund: '↩️' };

const totalIn = computed(() => props.transactions.filter(t => props.accounts.some(a => a.id === t.to_account_id)).reduce((s, t) => s + parseFloat(t.amount || 0), 0));
const totalOut = computed(() => props.transactions.filter(t => props.accounts.some(a => a.id === t.from_account_id)).reduce((s, t) => s + parseFloat(t.amount || 0), 0));
</script>

<template>
  <Head :title="`${user.full_name} - تفاصيل العميل`" />
  <AuthenticatedLayout>
    <div class="ud-root">
      <!-- HEADER -->
      <div class="ud-header">
        <div class="max-w-7xl mx-auto px-6 py-6">
          <div class="flex items-center gap-3 mb-4">
            <Link :href="route('admin.users')" class="ud-back">← العودة للعملاء</Link>
          </div>
          <div class="flex items-start justify-between flex-wrap gap-4">
            <div class="flex items-center gap-5">
              <div class="ud-avatar-lg">{{ user.full_name?.charAt(0) }}</div>
              <div>
                <h1 class="text-2xl font-bold text-[#1A2B4A]">{{ user.full_name }}</h1>
                <div class="flex items-center gap-3 mt-1 text-sm text-[#8896AB] flex-wrap">
                  <span class="font-mono bg-[#F0F4FF] text-[#1E5EFF] px-3 py-0.5 rounded-lg text-xs font-bold border border-[#1E5EFF]/10">رقم العميل: {{ user.customer_number }}</span>
                  <span>📧 {{ user.email }}</span>
                  <span>📱 {{ user.phone }}</span>
                </div>
                <div class="flex items-center gap-2 mt-2">
                  <span :class="statusBadge[user.status]" class="ud-badge">{{ user.status }}</span>
                  <span :class="statusBadge[user.kyc_status]" class="ud-badge">KYC: {{ user.kyc_status }}</span>
                  <span class="ud-badge ud-badge-gray">انضم {{ fmtShort(user.created_at) }}</span>
                </div>
              </div>
            </div>
            <div class="ud-balance-card">
              <div class="text-xs text-[#8896AB]">الرصيد الإجمالي (EUR)</div>
              <div class="text-3xl font-black text-[#1E5EFF]">{{ fmt(totalBalance) }}</div>
              <div class="flex gap-3 mt-2 text-xs">
                <span class="text-emerald-600">↓ وارد: {{ fmt(totalIn) }}</span>
                <span class="text-red-500">↑ صادر: {{ fmt(totalOut) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- FLASH -->
      <div v-if="flash.success" class="max-w-7xl mx-auto px-6 mt-4">
        <div class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-3 text-emerald-700 text-sm">✓ {{ flash.success }}</div>
      </div>

      <!-- TABS -->
      <div class="max-w-7xl mx-auto px-6 mt-6">
        <div class="ud-tabs">
          <button v-for="tab in tabs" :key="tab.id" @click="activeTab = tab.id" class="ud-tab" :class="{ 'ud-tab-active': activeTab === tab.id }">
            <span>{{ tab.icon }}</span> {{ tab.label }}
          </button>
        </div>
      </div>

      <!-- CONTENT -->
      <div class="max-w-7xl mx-auto px-6 py-6 space-y-6">

        <!-- OVERVIEW TAB -->
        <template v-if="activeTab === 'overview'">
          <div class="grid lg:grid-cols-3 gap-4">
            <div class="ud-card"><h3 class="ud-card-title mb-4">إحصائيات العميل</h3><div class="space-y-3"><div class="ud-info-row"><span>الحسابات</span><span class="font-bold text-[#1A2B4A]">{{ accounts.length }}</span></div><div class="ud-info-row"><span>البطاقات</span><span class="font-bold text-[#1A2B4A]">{{ cards.length }}</span></div><div class="ud-info-row"><span>المعاملات</span><span class="font-bold text-[#1A2B4A]">{{ transactions.length }}</span></div><div class="ud-info-row"><span>إجمالي الوارد</span><span class="font-bold text-emerald-600">{{ fmt(totalIn) }}</span></div><div class="ud-info-row"><span>إجمالي الصادر</span><span class="font-bold text-red-500">{{ fmt(totalOut) }}</span></div></div></div>
            <div class="ud-card"><h3 class="ud-card-title mb-4">المعلومات الشخصية</h3><div class="space-y-3"><div class="ud-info-row"><span>الاسم</span><span class="text-[#1A2B4A]">{{ user.full_name }}</span></div><div class="ud-info-row"><span>البريد</span><span class="text-[#1A2B4A]">{{ user.email }}</span></div><div class="ud-info-row"><span>الهاتف</span><span class="text-[#1A2B4A]">{{ user.phone }}</span></div><div class="ud-info-row"><span>الجنسية</span><span class="text-[#1A2B4A]">{{ user.nationality || '—' }}</span></div><div class="ud-info-row"><span>تاريخ الميلاد</span><span class="text-[#1A2B4A]">{{ user.date_of_birth || '—' }}</span></div><div class="ud-info-row"><span>المدينة</span><span class="text-[#1A2B4A]">{{ user.city || '—' }}, {{ user.country || '—' }}</span></div><div class="ud-info-row"><span>العنوان</span><span class="text-[#1A2B4A]">{{ user.address || '—' }}</span></div></div></div>
            <!-- Quick Admin Actions -->
            <div class="ud-card">
              <h3 class="ud-card-title mb-4">⚡ تحكم سريع</h3>
              <div class="space-y-3">
                <div><label class="text-xs text-[#8896AB] font-medium block mb-1">حالة الحساب</label><div class="flex gap-2"><select v-model="statusForm.status" class="ud-select flex-1"><option value="pending">معلّق</option><option value="active">نشط</option><option value="suspended">موقوف</option><option value="blocked">محظور</option></select><button @click="updateStatus" :disabled="statusForm.processing" class="ud-btn-blue">حفظ</button></div></div>
                <div><label class="text-xs text-[#8896AB] font-medium block mb-1">حالة KYC</label><div class="flex gap-2"><select v-model="kycForm.kyc_status" class="ud-select flex-1"><option value="pending">معلّق</option><option value="submitted">مقدّم</option><option value="verified">مُوثّق</option><option value="rejected">مرفوض</option></select><button @click="updateKyc" :disabled="kycForm.processing" class="ud-btn-green">حفظ</button></div></div>
                <hr class="border-[#E8ECF1]">
                <button @click="showEditProfile = true" class="ud-action-btn w-full">✏️ تعديل بيانات العميل</button>
                <button @click="resetPassword" class="ud-action-btn ud-action-warn w-full">🔑 إعادة تعيين كلمة المرور</button>
                <button @click="showSendNote = true" class="ud-action-btn ud-action-info w-full">📩 إرسال إشعار للعميل</button>
                <div class="flex gap-2">
                  <button @click="freezeAll" class="ud-action-btn ud-action-danger flex-1">❄️ تجميد الكل</button>
                  <button @click="unfreezeAll" class="ud-action-btn ud-action-success flex-1">✅ إلغاء التجميد</button>
                </div>
              </div>
            </div>
          </div>
          <!-- Recent activity -->
          <div class="ud-card">
            <h3 class="ud-card-title mb-4">آخر 5 معاملات</h3>
            <div class="ud-table">
              <div v-for="t in transactions.slice(0, 5)" :key="t.id" class="ud-table-row">
                <div class="flex items-center gap-3"><div class="ud-tx-icon">{{ typeIcons[t.type] || '📄' }}</div><div><div class="text-sm font-semibold text-[#1A2B4A]">{{ typeLabels[t.type] || t.type }}</div><div class="text-xs text-[#8896AB]">{{ t.reference_number }}</div></div></div>
                <div class="text-sm text-[#8896AB]">{{ fmtDate(t.created_at) }}</div>
                <div class="text-sm font-bold text-[#1A2B4A]">{{ fmt(t.amount, t.currency?.symbol) }}</div>
                <span :class="statusBadge[t.status]" class="ud-badge">{{ t.status }}</span>
              </div>
              <div v-if="!transactions.length" class="py-8 text-center text-[#8896AB]">لا توجد معاملات</div>
            </div>
          </div>
        </template>

        <!-- ACCOUNTS TAB -->
        <template v-if="activeTab === 'accounts'">
          <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div v-for="acc in accounts" :key="acc.id" class="ud-card ud-account-card">
              <div class="flex items-center justify-between mb-3"><div class="text-3xl">{{ acc.currency?.symbol }}</div><span :class="statusBadge[acc.status]" class="ud-badge">{{ acc.status }}</span></div>
              <div class="text-2xl font-black text-[#1A2B4A] mb-1">{{ fmt(acc.balance, acc.currency?.symbol) }}</div>
              <div class="text-xs text-[#8896AB] font-mono mb-1">{{ acc.iban }}</div>
              <div class="text-xs text-[#8896AB]">{{ acc.currency?.code }} — {{ acc.currency?.name_ar }}</div>
              <div class="ud-info-row mt-3"><span>رقم الحساب</span><span class="font-mono">{{ acc.account_number }}</span></div>
              <div class="ud-info-row"><span>تاريخ الإنشاء</span><span>{{ fmtShort(acc.created_at) }}</span></div>
            </div>
          </div>
        </template>

        <!-- CARDS TAB -->
        <template v-if="activeTab === 'cards'">
          <div class="grid md:grid-cols-2 gap-4">
            <div v-for="card in cards" :key="card.id" class="ud-card">
              <div class="flex items-center justify-between mb-4"><div class="flex items-center gap-2"><span class="text-xl">💳</span><span class="font-bold text-[#1A2B4A]">{{ card.card_type || 'Mastercard' }}</span></div><span :class="statusBadge[card.status]" class="ud-badge">{{ card.status }}</span></div>
              <div class="text-xl font-mono text-[#1A2B4A] tracking-wider mb-3">{{ card.card_number_masked }}</div>
              <div class="grid grid-cols-2 gap-3">
                <div class="ud-info-row"><span>حامل البطاقة</span><span>{{ card.card_holder_name }}</span></div>
                <div class="ud-info-row"><span>الصلاحية</span><span>{{ card.formatted_expiry }}</span></div>
                <div class="ud-info-row"><span>الحد اليومي</span><span>{{ fmt(card.daily_limit || 0) }}</span></div>
                <div class="ud-info-row"><span>الحد الشهري</span><span>{{ fmt(card.monthly_limit || 0) }}</span></div>
                <div class="ud-info-row"><span>الدفع أونلاين</span><span>{{ card.online_payment_enabled ? '✅' : '❌' }}</span></div>
                <div class="ud-info-row"><span>اللاتلامسي</span><span>{{ card.contactless_enabled ? '✅' : '❌' }}</span></div>
              </div>
              <div v-if="card.account" class="mt-3 p-3 bg-[#F0F4FF] rounded-xl text-xs">
                <span class="text-[#8896AB]">حساب:</span> <span class="font-bold text-[#1E5EFF]">{{ card.account?.currency?.code }} — {{ fmt(card.account?.balance || 0, card.account?.currency?.symbol) }}</span>
              </div>
            </div>
          </div>
          <div v-if="!cards.length" class="ud-card text-center py-10 text-[#8896AB]">لا توجد بطاقات</div>
        </template>

        <!-- TRANSACTIONS TAB -->
        <template v-if="activeTab === 'transactions'">
          <div class="ud-card"><div class="flex items-center justify-between mb-4"><h3 class="ud-card-title">سجل المعاملات الكامل</h3><span class="text-sm text-[#8896AB]">{{ transactions.length }} معاملة</span></div>
            <div class="ud-table-scroll"><table class="ud-full-table"><thead><tr><th>المرجع</th><th>النوع</th><th>المبلغ</th><th>العملة</th><th>من</th><th>إلى</th><th>الحالة</th><th>التاريخ</th></tr></thead><tbody>
              <tr v-for="t in transactions" :key="t.id"><td class="font-mono text-xs text-[#1E5EFF]">{{ t.reference_number }}</td><td><span class="ud-type-badge">{{ typeIcons[t.type] }} {{ typeLabels[t.type] || t.type }}</span></td><td class="font-bold">{{ fmt(t.amount, t.currency?.symbol) }}</td><td>{{ t.currency?.code }}</td><td class="text-xs">{{ t.from_account?.currency?.code || '—' }}</td><td class="text-xs">{{ t.to_account?.currency?.code || '—' }}</td><td><span :class="statusBadge[t.status]" class="ud-badge">{{ t.status }}</span></td><td class="text-xs">{{ fmtDate(t.created_at) }}</td></tr>
            </tbody></table><div v-if="!transactions.length" class="py-10 text-center text-[#8896AB]">لا توجد معاملات</div></div>
          </div>
        </template>

        <!-- PURCHASES TAB -->
        <template v-if="activeTab === 'purchases'">
          <div class="ud-card"><div class="flex items-center justify-between mb-4"><h3 class="ud-card-title">سجل المشتريات بالبطاقة</h3><span class="text-sm text-[#8896AB]">{{ (cardTransactions || []).length }} عملية</span></div>
            <div class="ud-table-scroll" v-if="cardTransactions && cardTransactions.length"><table class="ud-full-table"><thead><tr><th>التاجر</th><th>المبلغ</th><th>العملة</th><th>البطاقة</th><th>الحالة</th><th>التاريخ</th></tr></thead><tbody>
              <tr v-for="ct in cardTransactions" :key="ct.id"><td class="font-semibold">{{ ct.merchant_name || 'غير محدد' }}</td><td class="font-bold">{{ fmt(ct.amount, ct.currency_code) }}</td><td>{{ ct.currency_code }}</td><td class="font-mono text-xs">****{{ ct.card_id }}</td><td><span :class="statusBadge[ct.status]" class="ud-badge">{{ ct.status }}</span></td><td class="text-xs">{{ fmtDate(ct.created_at) }}</td></tr>
            </tbody></table></div><div v-else class="py-10 text-center text-[#8896AB]"><div class="text-4xl mb-3">🛒</div>لا توجد مشتريات بالبطاقة بعد</div>
          </div>
        </template>

        <!-- KYC TAB -->
        <template v-if="activeTab === 'kyc'">
          <div class="grid md:grid-cols-2 gap-4">
            <div class="ud-card"><h3 class="ud-card-title mb-4">حالة التحقق</h3><div class="space-y-3"><div class="ud-info-row"><span>الحالة</span><span :class="statusBadge[user.kyc_status]" class="ud-badge">{{ user.kyc_status }}</span></div><div class="ud-info-row"><span>الجنسية</span><span>{{ user.nationality || 'غير محدد' }}</span></div><div class="ud-info-row"><span>الدولة</span><span>{{ user.country || 'غير محدد' }}</span></div><div class="ud-info-row"><span>تاريخ التسجيل</span><span>{{ fmtShort(user.created_at) }}</span></div></div></div>
            <div class="ud-card"><h3 class="ud-card-title mb-4">المستندات</h3>
              <div v-if="kycDocuments && kycDocuments.length" class="space-y-3">
                <div v-for="doc in kycDocuments" :key="doc.id" class="flex items-center justify-between p-3 bg-[#FAFBFC] rounded-xl border border-[#E8ECF1]">
                  <div class="flex items-center gap-3"><span class="text-xl">📄</span><div><div class="text-sm font-semibold text-[#1A2B4A]">{{ doc.document_type }}</div><div class="text-xs text-[#8896AB]">{{ fmtShort(doc.created_at) }}</div></div></div>
                  <div class="flex items-center gap-2"><span :class="statusBadge[doc.status]" class="ud-badge">{{ doc.status }}</span><a :href="route('admin.kyc.view', doc.id)" target="_blank" class="ud-btn-sm">عرض</a></div>
                </div>
              </div><div v-else class="py-6 text-center text-[#8896AB]">لم يرفع أي مستندات</div>
            </div>
          </div>
        </template>

        <!-- SECURITY TAB -->
        <template v-if="activeTab === 'security'">
          <div class="grid md:grid-cols-2 gap-4">
            <div class="ud-card"><h3 class="ud-card-title mb-4">🔒 معلومات الأمان</h3>
              <div class="space-y-3">
                <div class="ud-info-row"><span>آخر تسجيل دخول</span><span>{{ user.last_login_at ? fmtDate(user.last_login_at) : 'لم يسجل دخول بعد' }}</span></div>
                <div class="ud-info-row"><span>آخر IP</span><span class="font-mono">{{ user.last_login_ip || '—' }}</span></div>
                <div class="ud-info-row"><span>تأكيد البريد</span><span>{{ user.email_verified_at ? '✅ مؤكد' : '❌ غير مؤكد' }}</span></div>
                <div class="ud-info-row"><span>كود الإحالة</span><span class="font-mono">{{ user.referral_code || '—' }}</span></div>
              </div>
            </div>
            <div class="ud-card"><h3 class="ud-card-title mb-4">📋 سجل تسجيل الدخول</h3>
              <div v-if="loginHistory && loginHistory.length" class="space-y-2">
                <div v-for="log in loginHistory" :key="log.id" class="flex items-center justify-between p-2 bg-[#FAFBFC] rounded-lg border border-[#E8ECF1] text-xs">
                  <div><span class="font-mono text-[#1E5EFF]">{{ log.ip_address }}</span><span class="text-[#8896AB] mx-2">·</span><span class="text-[#8896AB]">{{ log.user_agent?.substring(0, 40) }}...</span></div>
                  <span class="text-[#8896AB]">{{ fmtDate(log.created_at) }}</span>
                </div>
              </div><div v-else class="py-6 text-center text-[#8896AB]">لا توجد سجلات</div>
            </div>
          </div>
        </template>

        <!-- ADMIN ACTIONS TAB -->
        <template v-if="activeTab === 'actions'">
          <div class="grid lg:grid-cols-3 gap-4">
            <!-- Status Control -->
            <div class="ud-card">
              <h3 class="ud-card-title mb-4">🔧 تحكم بحالة العميل</h3>
              <div class="space-y-4">
                <div><label class="text-xs text-[#8896AB] font-medium block mb-1">حالة الحساب</label><div class="flex gap-2"><select v-model="statusForm.status" class="ud-select flex-1"><option value="pending">معلّق</option><option value="active">نشط</option><option value="suspended">موقوف</option><option value="blocked">محظور</option></select><button @click="updateStatus" :disabled="statusForm.processing" class="ud-btn-blue">حفظ</button></div></div>
                <div><label class="text-xs text-[#8896AB] font-medium block mb-1">حالة KYC</label><div class="flex gap-2"><select v-model="kycForm.kyc_status" class="ud-select flex-1"><option value="pending">معلّق</option><option value="submitted">مقدّم</option><option value="verified">مُوثّق</option><option value="rejected">مرفوض</option></select><button @click="updateKyc" :disabled="kycForm.processing" class="ud-btn-green">حفظ</button></div></div>
              </div>
            </div>
            <!-- Account Actions -->
            <div class="ud-card">
              <h3 class="ud-card-title mb-4">🏦 إجراءات الحساب</h3>
              <div class="space-y-3">
                <button @click="freezeAll" class="ud-action-btn ud-action-danger w-full">❄️ تجميد جميع الحسابات والبطاقات</button>
                <button @click="unfreezeAll" class="ud-action-btn ud-action-success w-full">✅ إلغاء تجميد الكل</button>
                <button @click="resetPassword" class="ud-action-btn ud-action-warn w-full">🔑 إعادة تعيين كلمة المرور</button>
                <div class="p-3 bg-amber-50 border border-amber-200 rounded-xl text-xs text-amber-700">⚠️ إعادة تعيين كلمة المرور ستولّد كلمة مرور جديدة وتظهر لك مباشرة</div>
              </div>
            </div>
            <!-- Communication -->
            <div class="ud-card">
              <h3 class="ud-card-title mb-4">📨 التواصل والبيانات</h3>
              <div class="space-y-3">
                <button @click="showSendNote = true" class="ud-action-btn ud-action-info w-full">📩 إرسال إشعار للعميل</button>
                <button @click="showEditProfile = true" class="ud-action-btn w-full">✏️ تعديل بيانات العميل</button>
                <div class="p-3 bg-blue-50 border border-blue-200 rounded-xl text-xs text-blue-700">ℹ️ الإشعارات تظهر للعميل في صفحة الإشعارات داخل تطبيقه</div>
              </div>
            </div>
          </div>
        </template>
      </div>

      <!-- Edit Profile Modal -->
      <Teleport to="body">
        <div v-if="showEditProfile" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm" @click.self="showEditProfile = false">
          <div class="bg-white rounded-2xl w-full max-w-lg p-6 shadow-2xl border border-[#E8ECF1]" style="direction:rtl">
            <h3 class="text-xl font-bold text-[#1A2B4A] mb-5">✏️ تعديل بيانات العميل</h3>
            <form @submit.prevent="saveProfile" class="space-y-4">
              <div class="grid grid-cols-2 gap-4"><div><label class="block text-xs text-[#8896AB] mb-1">الاسم الكامل</label><input v-model="profileForm.full_name" class="ud-modal-input" required /></div><div><label class="block text-xs text-[#8896AB] mb-1">البريد</label><input v-model="profileForm.email" type="email" class="ud-modal-input" required /></div></div>
              <div class="grid grid-cols-2 gap-4"><div><label class="block text-xs text-[#8896AB] mb-1">الهاتف</label><input v-model="profileForm.phone" class="ud-modal-input" /></div><div><label class="block text-xs text-[#8896AB] mb-1">الجنسية</label><input v-model="profileForm.nationality" class="ud-modal-input" /></div></div>
              <div><label class="block text-xs text-[#8896AB] mb-1">العنوان</label><input v-model="profileForm.address" class="ud-modal-input" /></div>
              <div class="grid grid-cols-2 gap-4"><div><label class="block text-xs text-[#8896AB] mb-1">المدينة</label><input v-model="profileForm.city" class="ud-modal-input" /></div><div><label class="block text-xs text-[#8896AB] mb-1">الدولة</label><input v-model="profileForm.country" class="ud-modal-input" /></div></div>
              <div v-if="profileForm.errors" class="text-xs text-red-500"><div v-for="(e, k) in profileForm.errors" :key="k">{{ e }}</div></div>
              <div class="flex gap-3"><button type="submit" :disabled="profileForm.processing" class="flex-1 bg-[#1E5EFF] hover:bg-[#1047b8] text-white py-3 rounded-xl font-semibold disabled:opacity-50">حفظ التغييرات</button><button type="button" @click="showEditProfile = false" class="flex-1 bg-[#F0F2F5] text-[#5A6B82] py-3 rounded-xl">إلغاء</button></div>
            </form>
          </div>
        </div>
      </Teleport>

      <!-- Send Notification Modal -->
      <Teleport to="body">
        <div v-if="showSendNote" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm" @click.self="showSendNote = false">
          <div class="bg-white rounded-2xl w-full max-w-md p-6 shadow-2xl border border-[#E8ECF1]" style="direction:rtl">
            <h3 class="text-xl font-bold text-[#1A2B4A] mb-1">📩 إرسال إشعار</h3>
            <p class="text-[#8896AB] text-sm mb-4">إلى: {{ user.full_name }}</p>
            <form @submit.prevent="sendNote" class="space-y-4">
              <textarea v-model="noteForm.note" placeholder="اكتب رسالة الإشعار..." rows="4" class="w-full border border-[#E8ECF1] rounded-xl px-4 py-3 text-[#1A2B4A] outline-none focus:border-[#1E5EFF] text-sm resize-none" required></textarea>
              <div class="flex gap-3"><button type="submit" :disabled="noteForm.processing || !noteForm.note" class="flex-1 bg-[#1E5EFF] hover:bg-[#1047b8] text-white py-3 rounded-xl font-semibold disabled:opacity-50">إرسال</button><button type="button" @click="showSendNote = false" class="flex-1 bg-[#F0F2F5] text-[#5A6B82] py-3 rounded-xl">إلغاء</button></div>
            </form>
          </div>
        </div>
      </Teleport>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.ud-root{min-height:100vh;background:#F0F2F5;direction:rtl}
.ud-header{background:linear-gradient(135deg,#fff 0%,#F8FAFC 100%);border-bottom:1px solid #E8ECF1}
.ud-back{font-size:13px;color:#1E5EFF;font-weight:600;text-decoration:none}.ud-back:hover{color:#1047b8}
.ud-avatar-lg{width:64px;height:64px;border-radius:18px;background:linear-gradient(135deg,#1E5EFF,#3B82F6);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:24px;flex-shrink:0}
.ud-balance-card{background:linear-gradient(135deg,rgba(30,94,255,0.04),rgba(30,94,255,0.02));border:1px solid rgba(30,94,255,0.12);border-radius:16px;padding:16px 24px;text-align:right}
.ud-tabs{display:flex;gap:4px;border-bottom:2px solid #E8ECF1;overflow-x:auto}
.ud-tab{padding:10px 16px;font-size:13px;font-weight:500;color:#8896AB;border-bottom:2px solid transparent;margin-bottom:-2px;transition:all .2s;cursor:pointer;background:none;border-top:none;border-left:none;border-right:none;display:flex;align-items:center;gap:6px;white-space:nowrap}.ud-tab:hover{color:#1E5EFF}
.ud-tab-active{color:#1E5EFF;border-bottom-color:#1E5EFF;font-weight:700}
.ud-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px;padding:24px;transition:box-shadow .3s}.ud-card:hover{box-shadow:0 4px 15px rgba(0,0,0,0.04)}
.ud-card-title{font-size:16px;font-weight:700;color:#1A2B4A}
.ud-account-card{border-right:4px solid #1E5EFF}
.ud-info-row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid #F0F2F5;font-size:13px;color:#8896AB}.ud-info-row:last-child{border-bottom:none}
.ud-table-row{display:flex;align-items:center;justify-content:space-between;padding:12px 0;border-bottom:1px solid #F0F2F5;flex-wrap:wrap;gap:8px}.ud-table-row:last-child{border-bottom:none}
.ud-tx-icon{width:36px;height:36px;border-radius:10px;background:#F0F4FF;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}
.ud-table-scroll{overflow-x:auto;max-height:500px;overflow-y:auto}
.ud-full-table{width:100%;border-collapse:collapse;font-size:13px}
.ud-full-table th{text-align:right;padding:10px 12px;background:#FAFBFC;color:#8896AB;font-weight:600;border-bottom:2px solid #E8ECF1;position:sticky;top:0;z-index:1}
.ud-full-table td{padding:10px 12px;border-bottom:1px solid #F0F2F5;color:#1A2B4A;vertical-align:middle}
.ud-full-table tr:hover td{background:#FAFBFC}
.ud-badge{font-size:11px;padding:2px 10px;border-radius:100px;font-weight:600}
.ud-badge-green{background:rgba(16,185,129,0.1);color:#059669}.ud-badge-yellow{background:rgba(245,158,11,0.1);color:#d97706}.ud-badge-red{background:rgba(239,68,68,0.1);color:#dc2626}.ud-badge-blue{background:rgba(30,94,255,0.1);color:#1E5EFF}.ud-badge-gray{background:#F0F2F5;color:#8896AB}
.ud-type-badge{display:inline-flex;align-items:center;gap:4px;font-size:12px}
.ud-btn-blue{padding:8px 16px;background:#1E5EFF;color:#fff;border-radius:10px;font-size:13px;font-weight:600;border:none;cursor:pointer}.ud-btn-blue:hover{background:#1047b8}.ud-btn-blue:disabled{opacity:.5}
.ud-btn-green{padding:8px 16px;background:#10b981;color:#fff;border-radius:10px;font-size:13px;font-weight:600;border:none;cursor:pointer}.ud-btn-green:hover{background:#059669}.ud-btn-green:disabled{opacity:.5}
.ud-btn-sm{padding:4px 12px;background:#F0F4FF;color:#1E5EFF;border-radius:8px;font-size:12px;font-weight:600;text-decoration:none;border:1px solid rgba(30,94,255,0.15)}.ud-btn-sm:hover{background:#1E5EFF;color:#fff}
.ud-select{padding:8px 12px;border:1px solid #E8ECF1;border-radius:10px;background:#FAFBFC;font-size:13px;color:#1A2B4A;outline:none}.ud-select:focus{border-color:#1E5EFF}
.ud-action-btn{padding:10px 16px;border-radius:12px;font-size:13px;font-weight:600;cursor:pointer;border:1px solid #E8ECF1;background:#FAFBFC;color:#5A6B82;transition:all .2s;text-align:center}.ud-action-btn:hover{background:#F0F4FF;border-color:#1E5EFF;color:#1E5EFF}
.ud-action-warn{border-color:rgba(245,158,11,0.2);color:#d97706}.ud-action-warn:hover{background:rgba(245,158,11,0.05);border-color:#f59e0b;color:#d97706}
.ud-action-danger{border-color:rgba(239,68,68,0.2);color:#dc2626}.ud-action-danger:hover{background:rgba(239,68,68,0.05);border-color:#ef4444;color:#dc2626}
.ud-action-success{border-color:rgba(16,185,129,0.2);color:#059669}.ud-action-success:hover{background:rgba(16,185,129,0.05);border-color:#10b981;color:#059669}
.ud-action-info{border-color:rgba(30,94,255,0.2);color:#1E5EFF}.ud-action-info:hover{background:rgba(30,94,255,0.05);border-color:#1E5EFF}
.ud-modal-input{width:100%;border:1px solid #E8ECF1;border-radius:12px;padding:10px 14px;font-size:13px;color:#1A2B4A;outline:none}.ud-modal-input:focus{border-color:#1E5EFF}
.ud-table-scroll::-webkit-scrollbar{width:4px;height:4px}.ud-table-scroll::-webkit-scrollbar-track{background:transparent}.ud-table-scroll::-webkit-scrollbar-thumb{background:#E2E8F0;border-radius:4px}
</style>
