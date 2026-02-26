<script setup>
import { Head, Link, router, useForm, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ cards: Object, filters: Object, stats: Object });
const flash = computed(() => usePage().props.flash || {});

const search = ref(props.filters?.search || '');
const statusFilter = ref(props.filters?.status || '');
const applyFilter = () => router.get(route('admin.cards'), { search: search.value, status: statusFilter.value || undefined }, { preserveState: true });

const editingCard = ref(null);
const limitForm = useForm({ daily_limit: '', monthly_limit: '', spending_limit: '' });
const openLimits = (card) => { editingCard.value = card; limitForm.daily_limit = card.daily_limit; limitForm.monthly_limit = card.monthly_limit; limitForm.spending_limit = card.spending_limit; };
const updateLimits = () => limitForm.patch(route('admin.cards.limits', editingCard.value.id), { onSuccess: () => editingCard.value = null });
const updateStatus = (card, status) => { if (status === 'cancelled' && !confirm('هل أنت متأكد من إلغاء هذه البطاقة نهائياً؟')) return; router.patch(route('admin.cards.status', card.id), { status }); };

// Expanded card
const expandedId = ref(null);
const toggleExpand = (id) => expandedId.value = expandedId.value === id ? null : id;

const statusBadge = { active: 'ac-badge-green', frozen: 'ac-badge-blue', expired: 'ac-badge-gray', cancelled: 'ac-badge-red' };
const fmt = (a) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
</script>

<template>
  <Head title="Cards - البطاقات" />
  <AuthenticatedLayout>
    <div class="ac-root">
      <div class="ac-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <div><h1 class="text-2xl font-bold text-[#1A2B4A]">💳 إدارة البطاقات</h1><p class="text-sm text-[#8896AB] mt-1">{{ cards.total }} بطاقة — تحكم بالحدود والحالات والتفاصيل</p></div>
          <Link :href="route('admin.dashboard')" class="ac-back">← الرئيسية</Link>
        </div>
      </div>

      <div v-if="flash.success" class="max-w-7xl mx-auto px-6 mt-4"><div class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-3 text-emerald-700 text-sm">✓ {{ flash.success }}</div></div>

      <div class="max-w-7xl mx-auto px-6 py-6 space-y-6">
        <!-- Stats -->
        <div class="grid grid-cols-4 lg:grid-cols-8 gap-3">
          <div class="ac-stat lg:col-span-1"><div class="text-2xl font-black text-[#1A2B4A]">{{ stats.total }}</div><div class="text-[10px] text-[#8896AB]">الكل</div></div>
          <button @click="statusFilter = statusFilter === 'active' ? '' : 'active'; applyFilter()" :class="{'ac-stat-active-g': statusFilter === 'active'}" class="ac-stat"><div class="text-2xl font-black text-emerald-600">{{ stats.active }}</div><div class="text-[10px] text-[#8896AB]">✅ نشط</div></button>
          <button @click="statusFilter = statusFilter === 'frozen' ? '' : 'frozen'; applyFilter()" :class="{'ac-stat-active-b': statusFilter === 'frozen'}" class="ac-stat"><div class="text-2xl font-black text-[#1E5EFF]">{{ stats.frozen }}</div><div class="text-[10px] text-[#8896AB]">❄️ مجمّد</div></button>
          <button @click="statusFilter = statusFilter === 'cancelled' ? '' : 'cancelled'; applyFilter()" :class="{'ac-stat-active-r': statusFilter === 'cancelled'}" class="ac-stat"><div class="text-2xl font-black text-red-500">{{ stats.cancelled }}</div><div class="text-[10px] text-[#8896AB]">🚫 ملغي</div></button>
          <button @click="statusFilter = statusFilter === 'expired' ? '' : 'expired'; applyFilter()" :class="{'ac-stat-active-g': statusFilter === 'expired'}" class="ac-stat"><div class="text-2xl font-black text-gray-400">{{ stats.expired }}</div><div class="text-[10px] text-[#8896AB]">⏰ منتهي</div></button>
          <div class="ac-stat"><div class="text-2xl font-black text-purple-600">{{ stats.virtual }}</div><div class="text-[10px] text-[#8896AB]">🌐 افتراضي</div></div>
          <div class="ac-stat"><div class="text-2xl font-black text-amber-600">{{ stats.physical }}</div><div class="text-[10px] text-[#8896AB]">📦 فعلي</div></div>
          <div class="ac-stat"><div class="text-xl font-black text-emerald-600">{{ fmt(stats.total_daily_limit) }}</div><div class="text-[10px] text-[#8896AB]">حدود يومية</div></div>
        </div>

        <!-- Search + Clear -->
        <div class="flex items-center gap-3">
          <input v-model="search" @keyup.enter="applyFilter" type="text" placeholder="بحث بالاسم، رقم البطاقة، رقم العميل..." class="ac-search" />
          <button v-if="search || statusFilter" @click="search=''; statusFilter=''; applyFilter()" class="ac-clear-btn">✕ مسح</button>
        </div>

        <!-- Table -->
        <div class="ac-card overflow-hidden">
          <div class="overflow-x-auto">
            <table class="ac-table">
              <thead><tr><th>حامل البطاقة</th><th>رقم البطاقة</th><th>النوع</th><th>العملة</th><th class="text-center">الحالة</th><th>الحد اليومي</th><th>الحد الشهري</th><th>الصلاحية</th><th class="text-center">إجراءات</th></tr></thead>
              <tbody>
                <template v-for="c in cards.data" :key="c.id">
                  <tr @click="toggleExpand(c.id)" class="cursor-pointer">
                    <td>
                      <div class="flex items-center gap-3">
                        <div class="ac-avatar">💳</div>
                        <div>
                          <div class="text-sm font-semibold text-[#1A2B4A]">{{ c.user?.full_name }}</div>
                          <div class="text-[10px] font-mono text-[#1E5EFF]">{{ c.user?.customer_number }}</div>
                        </div>
                      </div>
                    </td>
                    <td class="font-mono text-xs text-[#8896AB]">{{ c.card_number_masked }}</td>
                    <td><span class="ac-type-badge" :class="c.card_type === 'virtual' ? 'ac-type-virtual' : 'ac-type-physical'">{{ c.card_type === 'virtual' ? '🌐 افتراضي' : '📦 فعلي' }}</span></td>
                    <td><span class="text-lg">{{ c.account?.currency?.symbol }}</span> {{ c.account?.currency?.code }}</td>
                    <td class="text-center"><span :class="statusBadge[c.status]" class="ac-badge">{{ c.status === 'active' ? 'نشط' : c.status === 'frozen' ? 'مجمّد' : c.status === 'cancelled' ? 'ملغي' : 'منتهي' }}</span></td>
                    <td class="text-[#1A2B4A] font-semibold">{{ fmt(c.daily_limit) }}</td>
                    <td class="text-[#1A2B4A] font-semibold">{{ fmt(c.monthly_limit) }}</td>
                    <td class="text-[#8896AB] text-sm">{{ c.formatted_expiry || new Date(c.expiry_date).toLocaleDateString('en', { month: '2-digit', year: '2-digit' }) }}</td>
                    <td class="text-center" @click.stop>
                      <div class="flex justify-center gap-1">
                        <button @click="openLimits(c)" class="ac-act ac-act-yellow">📝 حدود</button>
                        <button v-if="c.status==='active'" @click="updateStatus(c,'frozen')" class="ac-act ac-act-blue">❄️</button>
                        <button v-if="c.status==='frozen'" @click="updateStatus(c,'active')" class="ac-act ac-act-green">✅</button>
                        <button v-if="c.status !=='cancelled'" @click="updateStatus(c,'cancelled')" class="ac-act ac-act-red">🚫</button>
                        <Link :href="route('admin.users.show', c.user?.id)" class="ac-act ac-act-purple">👤</Link>
                      </div>
                    </td>
                  </tr>
                  <!-- Expanded Card Detail -->
                  <tr v-if="expandedId === c.id" class="ac-expanded-row">
                    <td colspan="9">
                      <div class="p-4 mx-2 my-1">
                        <div class="grid grid-cols-2 gap-4">
                          <!-- Card Visual -->
                          <div class="ac-visual-card" :class="c.card_type === 'virtual' ? 'ac-visual-virtual' : 'ac-visual-physical'">
                            <div class="flex justify-between items-start mb-6">
                              <span class="text-white/80 text-xs font-semibold">{{ c.card_type === 'virtual' ? 'VIRTUAL CARD' : 'PHYSICAL CARD' }}</span>
                              <span class="text-white font-bold text-sm">SDB</span>
                            </div>
                            <div class="text-white text-xl font-mono tracking-[4px] mb-4">{{ c.card_number_masked }}</div>
                            <div class="flex justify-between items-end">
                              <div><div class="text-white/60 text-[10px]">CARD HOLDER</div><div class="text-white font-semibold text-sm">{{ c.card_holder_name }}</div></div>
                              <div class="text-left"><div class="text-white/60 text-[10px]">EXPIRES</div><div class="text-white font-semibold text-sm">{{ c.formatted_expiry || '—' }}</div></div>
                            </div>
                          </div>
                          <!-- Card Details -->
                          <div class="space-y-2">
                            <div class="ac-detail-row"><span>حامل البطاقة</span><span class="font-semibold text-[#1A2B4A]">{{ c.card_holder_name }}</span></div>
                            <div class="ac-detail-row"><span>نوع البطاقة</span><span>{{ c.card_type === 'virtual' ? 'افتراضية' : 'فعلية' }}</span></div>
                            <div class="ac-detail-row"><span>الحساب المربوط</span><span class="font-mono text-[#1E5EFF]">{{ c.account?.iban || '—' }}</span></div>
                            <div class="ac-detail-row"><span>رصيد الحساب</span><span class="font-bold text-emerald-600">{{ fmt(c.account?.balance || 0) }} {{ c.account?.currency?.symbol }}</span></div>
                            <div class="ac-detail-row"><span>الدفع أونلاين</span><span>{{ c.online_payment_enabled ? '✅ مفعّل' : '❌ معطّل' }}</span></div>
                            <div class="ac-detail-row"><span>سحب ATM</span><span>{{ c.atm_withdrawal_enabled ? '✅ مفعّل' : '❌ معطّل' }}</span></div>
                            <div class="ac-detail-row"><span>لاتلامسي NFC</span><span>{{ c.contactless_enabled ? '✅ مفعّل' : '❌ معطّل' }}</span></div>
                            <div class="ac-detail-row"><span>حد الإنفاق</span><span class="font-bold">{{ fmt(c.spending_limit || 0) }}</span></div>
                            <div class="ac-detail-row"><span>تاريخ الإصدار</span><span>{{ new Date(c.created_at).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', year: 'numeric' }) }}</span></div>
                          </div>
                        </div>
                      </div>
                    </td>
                  </tr>
                </template>
              </tbody>
            </table>
          </div>
        </div>

        <div class="flex justify-center gap-2 mt-6" v-if="cards.last_page > 1">
          <Link v-for="link in cards.links" :key="link.label" :href="link.url || '#'" :class="['ac-pg', link.active ? 'ac-pg-act' : '']" v-html="link.label" />
        </div>
      </div>

      <!-- Limits Modal -->
      <Teleport to="body">
        <div v-if="editingCard" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm" @click.self="editingCard = null">
          <div class="bg-white rounded-2xl w-full max-w-md p-6 shadow-2xl border border-[#E8ECF1]" style="direction:rtl">
            <h3 class="text-xl font-bold text-[#1A2B4A] mb-1">📝 تعديل حدود البطاقة</h3>
            <p class="text-[#8896AB] text-sm mb-2">{{ editingCard.user?.full_name }} — {{ editingCard.card_number_masked }}</p>
            <div class="p-3 bg-[#F0F4FF] rounded-xl mb-4 text-sm grid grid-cols-3 gap-2">
              <div><span class="text-[#8896AB] text-xs block">يومي حالي</span><span class="font-bold text-[#1A2B4A]">{{ fmt(editingCard.daily_limit) }}</span></div>
              <div><span class="text-[#8896AB] text-xs block">شهري حالي</span><span class="font-bold text-[#1A2B4A]">{{ fmt(editingCard.monthly_limit) }}</span></div>
              <div><span class="text-[#8896AB] text-xs block">إنفاق حالي</span><span class="font-bold text-[#1A2B4A]">{{ fmt(editingCard.spending_limit) }}</span></div>
            </div>
            <form @submit.prevent="updateLimits" class="space-y-4">
              <div><label class="block text-xs text-[#8896AB] mb-1">الحد اليومي الجديد</label><input v-model="limitForm.daily_limit" type="number" step="0.01" class="ac-modal-input" /></div>
              <div><label class="block text-xs text-[#8896AB] mb-1">الحد الشهري الجديد</label><input v-model="limitForm.monthly_limit" type="number" step="0.01" class="ac-modal-input" /></div>
              <div><label class="block text-xs text-[#8896AB] mb-1">حد الإنفاق الجديد</label><input v-model="limitForm.spending_limit" type="number" step="0.01" class="ac-modal-input" /></div>
              <div class="flex gap-3"><button type="submit" :disabled="limitForm.processing" class="flex-1 bg-[#1E5EFF] hover:bg-[#1047b8] text-white py-3 rounded-xl font-semibold disabled:opacity-50">حفظ</button><button type="button" @click="editingCard = null" class="flex-1 bg-[#F0F2F5] text-[#5A6B82] py-3 rounded-xl">إلغاء</button></div>
            </form>
          </div>
        </div>
      </Teleport>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.ac-root{min-height:100vh;background:#F0F2F5;direction:rtl}
.ac-header{background:linear-gradient(135deg,#fff,#F8FAFC);border-bottom:1px solid #E8ECF1}
.ac-back{padding:8px 18px;background:#F0F4FF;color:#1E5EFF;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(30,94,255,0.12)}.ac-back:hover{background:#1E5EFF;color:#fff}
.ac-stat{background:#fff;border:2px solid #E8ECF1;border-radius:14px;padding:14px;text-align:center;cursor:pointer;transition:all .2s}.ac-stat:hover{border-color:#1E5EFF}
.ac-stat-active-g{border-color:#10b981!important;background:rgba(16,185,129,0.03)}.ac-stat-active-b{border-color:#1E5EFF!important;background:rgba(30,94,255,0.03)}.ac-stat-active-r{border-color:#ef4444!important;background:rgba(239,68,68,0.03)}
.ac-search{width:380px;padding:10px 16px;border:1px solid #E8ECF1;border-radius:12px;background:#fff;font-size:13px;color:#1A2B4A;outline:none}.ac-search:focus{border-color:#1E5EFF}.ac-search::placeholder{color:#8896AB}
.ac-clear-btn{padding:8px 14px;border:1px solid rgba(239,68,68,0.2);border-radius:10px;font-size:12px;font-weight:600;color:#dc2626;background:rgba(239,68,68,0.05);cursor:pointer}.ac-clear-btn:hover{background:rgba(239,68,68,0.1)}
.ac-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px}
.ac-table{width:100%;border-collapse:collapse;font-size:13px}
.ac-table th{text-align:right;padding:12px 14px;background:#FAFBFC;color:#8896AB;font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #E8ECF1}
.ac-table td{padding:12px 14px;border-bottom:1px solid #F0F2F5;vertical-align:middle}
.ac-table tr:hover td{background:#FAFBFC}
.ac-expanded-row td{background:#fff!important;padding:0!important;border:none!important}
.ac-avatar{width:36px;height:36px;border-radius:10px;background:#F0F4FF;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}
.ac-badge{font-size:11px;padding:2px 10px;border-radius:100px;font-weight:600}
.ac-badge-green{background:rgba(16,185,129,0.1);color:#059669}.ac-badge-blue{background:rgba(30,94,255,0.1);color:#1E5EFF}.ac-badge-gray{background:#F0F2F5;color:#8896AB}.ac-badge-red{background:rgba(239,68,68,0.1);color:#dc2626}
.ac-type-badge{font-size:11px;padding:3px 10px;border-radius:8px;font-weight:600}
.ac-type-virtual{background:rgba(139,92,246,0.08);color:#8b5cf6}.ac-type-physical{background:rgba(245,158,11,0.08);color:#d97706}
.ac-act{font-size:11px;padding:4px 8px;border-radius:8px;font-weight:600;cursor:pointer;border:1px solid transparent;transition:all .2s;text-decoration:none}
.ac-act-yellow{background:rgba(245,158,11,0.08);color:#d97706;border-color:rgba(245,158,11,0.15)}.ac-act-yellow:hover{background:rgba(245,158,11,0.15)}
.ac-act-blue{background:rgba(30,94,255,0.08);color:#1E5EFF;border-color:rgba(30,94,255,0.15)}.ac-act-blue:hover{background:rgba(30,94,255,0.15)}
.ac-act-green{background:rgba(16,185,129,0.08);color:#059669;border-color:rgba(16,185,129,0.15)}.ac-act-green:hover{background:rgba(16,185,129,0.15)}
.ac-act-red{background:rgba(239,68,68,0.08);color:#dc2626;border-color:rgba(239,68,68,0.15)}.ac-act-red:hover{background:rgba(239,68,68,0.15)}
.ac-act-purple{background:rgba(139,92,246,0.08);color:#8b5cf6;border-color:rgba(139,92,246,0.15)}.ac-act-purple:hover{background:rgba(139,92,246,0.15)}
.ac-modal-input{width:100%;border:1px solid #E8ECF1;border-radius:12px;padding:10px 14px;font-size:13px;color:#1A2B4A;outline:none}.ac-modal-input:focus{border-color:#1E5EFF}
.ac-detail-row{display:flex;justify-content:space-between;align-items:center;padding:6px 10px;font-size:12px;color:#8896AB;border-bottom:1px solid #F0F2F5}.ac-detail-row:last-child{border:none}
/* Visual Card */
.ac-visual-card{border-radius:16px;padding:24px;aspect-ratio:1.586;display:flex;flex-direction:column;justify-content:space-between;position:relative;overflow:hidden}
.ac-visual-card::before{content:'';position:absolute;inset:0;background:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 200'%3E%3Ccircle cx='150' cy='50' r='80' fill='rgba(255,255,255,0.05)'/%3E%3Ccircle cx='50' cy='150' r='60' fill='rgba(255,255,255,0.03)'/%3E%3C/svg%3E") no-repeat}
.ac-visual-virtual{background:linear-gradient(135deg,#6d28d9,#8b5cf6,#a78bfa)}
.ac-visual-physical{background:linear-gradient(135deg,#1A2B4A,#1E5EFF,#3B82F6)}
.ac-pg{padding:6px 14px;border-radius:8px;font-size:13px;background:#fff;color:#5A6B82;border:1px solid #E8ECF1;text-decoration:none}.ac-pg:hover{border-color:#1E5EFF;color:#1E5EFF}
.ac-pg-act{background:#1E5EFF!important;color:#fff!important;border-color:#1E5EFF!important}
</style>
