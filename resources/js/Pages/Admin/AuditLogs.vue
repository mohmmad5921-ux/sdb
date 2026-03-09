<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref } from 'vue';

const props = defineProps({ logs: Object, filters: Object, actionLabels: Object, actions: Array });
const search = ref(props.filters?.search || '');
const actionFilter = ref(props.filters?.action || '');
const fromDate = ref(props.filters?.from || '');
const toDate = ref(props.filters?.to || '');

const applyFilter = () => router.get(route('admin.audit-logs'), {
  search: search.value || undefined,
  action: actionFilter.value || undefined,
  from: fromDate.value || undefined,
  to: toDate.value || undefined,
}, { preserveState: true });

const resetFilters = () => {
  search.value = ''; actionFilter.value = ''; fromDate.value = ''; toDate.value = '';
  router.get(route('admin.audit-logs'));
};

const fmtDate = (d) => new Date(d).toLocaleString('ar-EG', { day:'numeric', month:'short', year:'numeric', hour:'2-digit', minute:'2-digit' });

const actionIcons = {
  'user.status_change': '🔄', 'user.kyc_update': '🪪', 'user.password_reset': '🔑',
  'user.profile_update': '✏️', 'user.freeze_all': '❄️', 'user.unfreeze_all': '✅',
  'user.send_note': '📩', 'account.status_change': '🏦', 'account.balance_adjust': '💰',
  'card.status_change': '💳', 'card.limits_update': '📊', 'broadcast.notification': '📢',
};

const formatDetails = (details) => {
  if (!details) return '—';
  const parts = [];
  if (details.user_name) parts.push(details.user_name);
  if (details.old && details.new) parts.push(`${details.old} → ${details.new}`);
  if (details.type && details.amount) parts.push(`${details.type === 'credit' ? '+' : '-'}${details.amount}`);
  if (details.reason) parts.push(details.reason);
  if (details.note_preview) parts.push(`"${details.note_preview}"`);
  return parts.join(' • ') || JSON.stringify(details);
};
</script>

<template>
  <Head title="Audit Logs - سجل الأنشطة" />
  <AdminLayout title="📋 سجل أنشطة الإدارة">
    <div class="al-root">
      <div class="al-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <div><h1 class="text-2xl font-bold text-[#0f172a]">📋 سجل أنشطة الإدارة</h1><p class="text-sm text-[#475569] mt-1">تتبّع جميع إجراءات المديرين في النظام</p></div>
          <div class="flex items-center gap-3">
            <span class="text-sm text-[#475569]">{{ logs.total }} سجل</span>
            <Link :href="route('admin.dashboard')" class="al-back">← الرئيسية</Link>
          </div>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-6 py-6">
        <!-- Filters -->
        <div class="al-filters mb-6">
          <input v-model="search" @keyup.enter="applyFilter" type="text" placeholder="بحث بالاسم أو النوع..." class="al-search" />
          <select v-model="actionFilter" @change="applyFilter" class="al-filter-select">
            <option value="">كل الإجراءات</option>
            <option v-for="a in actions" :key="a" :value="a">{{ actionIcons[a] || '📄' }} {{ actionLabels[a] || a }}</option>
          </select>
          <input v-model="fromDate" @change="applyFilter" type="date" class="al-filter-date" />
          <input v-model="toDate" @change="applyFilter" type="date" class="al-filter-date" />
          <button @click="resetFilters" class="al-reset-btn">إعادة تعيين</button>
        </div>

        <!-- Logs Table -->
        <div class="al-card overflow-hidden">
          <table class="al-table">
            <thead><tr><th>التاريخ</th><th>المدير</th><th>الإجراء</th><th>الهدف</th><th>التفاصيل</th><th>IP</th></tr></thead>
            <tbody>
              <tr v-for="log in logs.data" :key="log.id">
                <td class="text-[#475569] text-xs whitespace-nowrap">{{ fmtDate(log.created_at) }}</td>
                <td class="font-semibold text-[#0f172a] whitespace-nowrap">{{ log.admin?.full_name || '—' }}</td>
                <td>
                  <span class="al-action-badge">
                    <span>{{ actionIcons[log.action] || '📄' }}</span>
                    {{ actionLabels[log.action] || log.action }}
                  </span>
                </td>
                <td class="text-[#475569] text-sm">
                  <span v-if="log.target_type" class="al-target">{{ log.target_type }} #{{ log.target_id }}</span>
                  <span v-else class="text-[#94a3b8]">—</span>
                </td>
                <td class="text-xs max-w-[300px]">
                  <span class="text-[#334155]">{{ formatDetails(log.details) }}</span>
                </td>
                <td class="text-xs text-[#475569] font-mono">{{ log.ip_address }}</td>
              </tr>
              <tr v-if="!logs.data?.length"><td colspan="6" class="py-12 text-center text-[#475569]"><div class="text-4xl mb-2">📋</div>لا توجد سجلات</td></tr>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center gap-2 mt-6" v-if="logs.last_page > 1">
          <Link v-for="link in logs.links" :key="link.label" :href="link.url || '#'" :class="['al-pg', link.active ? 'al-pg-act' : '']" v-html="link.label" />
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
.al-root{min-height:100vh;background:#f1f5f9;direction:rtl}
.al-header{background:#ffffff;border-bottom:1px solid #e2e8f0}
.al-back{padding:8px 18px;background:#ffffff;color:#3b82f6;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(16,185,129,0.2)}.al-back:hover{background:#10b981;color:#fff}
.al-filters{display:flex;gap:10px;flex-wrap:wrap;align-items:center}
.al-search{width:280px;padding:10px 16px;border:1px solid #e2e8f0;border-radius:12px;background:#ffffff;font-size:13px;color:#0f172a;outline:none}.al-search:focus{border-color:#10b981}.al-search::placeholder{color:#64748b}
.al-filter-select{padding:10px 14px;border:1px solid #e2e8f0;border-radius:12px;background:#ffffff;font-size:13px;color:#0f172a;outline:none;min-width:180px}.al-filter-select:focus{border-color:#10b981}
.al-filter-date{padding:10px 14px;border:1px solid #e2e8f0;border-radius:12px;background:#ffffff;font-size:13px;color:#0f172a;outline:none;width:150px}.al-filter-date:focus{border-color:#10b981}
.al-reset-btn{padding:10px 16px;border:1px solid #e2e8f0;border-radius:12px;background:#ffffff;color:#64748b;font-size:13px;cursor:pointer}.al-reset-btn:hover{border-color:#ef4444;color:#ef4444}
.al-card{background:#ffffff;border:1px solid #e2e8f0;border-radius:16px}
.al-table{width:100%;border-collapse:collapse;font-size:13px}
.al-table th{text-align:right;padding:12px 16px;background:#f8fafc;color:#64748b;font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #e2e8f0}
.al-table td{padding:12px 16px;border-bottom:1px solid #f1f5f9;vertical-align:middle}
.al-table tr:hover td{background:#f8fafc}
.al-action-badge{display:inline-flex;align-items:center;gap:4px;font-size:12px;font-weight:600;color:#1d4ed8;background:rgba(59,130,246,0.08);padding:4px 10px;border-radius:8px;white-space:nowrap}
.al-target{font-size:12px;font-weight:500;color:#475569;background:#f1f5f9;padding:2px 8px;border-radius:6px}
.al-pg{padding:6px 14px;border-radius:8px;font-size:13px;background:#ffffff;color:#334155;border:1px solid #e2e8f0;text-decoration:none}.al-pg:hover{border-color:#10b981;color:#3b82f6}
.al-pg-act{background:#10b981!important;color:#fff!important;border-color:#10b981!important}
</style>
