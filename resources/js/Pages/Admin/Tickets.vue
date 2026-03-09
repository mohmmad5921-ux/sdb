<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ tickets: Object, filters: Object, stats: Object });
const flash = computed(() => usePage().props.flash || {});
const search = ref(props.filters?.search || '');
const statusFilter = ref(props.filters?.status || '');

const applyFilter = (status) => { statusFilter.value = status; router.get(route('admin.tickets'), { status, search: search.value }, { preserveState: true }); };
const doSearch = () => router.get(route('admin.tickets'), { search: search.value, status: statusFilter.value }, { preserveState: true });

const priorityLabels = { low: 'منخفض', normal: 'عادي', high: 'مهم', urgent: 'عاجل' };
const priorityColors = { low: '#94a3b8', normal: '#3b82f6', high: '#f59e0b', urgent: '#ef4444' };
const priorityIcons = { low: '🔵', normal: '🟡', high: '🟠', urgent: '🔴' };
const statusLabels = { open: 'مفتوحة', in_progress: 'قيد المعالجة', waiting: 'بانتظار الرد', resolved: 'محلولة', closed: 'مغلقة' };
const statusColors = { open: '#f59e0b', in_progress: '#3b82f6', waiting: '#8b5cf6', resolved: '#10b981', closed: '#64748b' };
const catLabels = { general: 'عام', account: 'حسابات', card: 'بطاقات', transfer: 'تحويلات', kyc: 'KYC', technical: 'تقني' };
const fmtDate = (d) => new Date(d).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' });
</script>

<template>
  <Head title="التذاكر" />
  <AdminLayout title="🎫 تذاكر الدعم" subtitle="إدارة طلبات العملاء">

    <div v-if="flash.success" class="tk-success">✓ {{ flash.success }}</div>

    <!-- Stats -->
    <div class="tk-stats">
      <button v-for="(label, key) in { open: 'مفتوحة', in_progress: 'قيد المعالجة', waiting: 'بانتظار', resolved: 'محلولة' }"
        :key="key" @click="applyFilter(key)" :class="['tk-stat', statusFilter === key ? 'tk-stat-active' : '']">
        <div class="tk-stat-val" :style="{color: statusColors[key]}">{{ stats[key] || 0 }}</div>
        <div class="tk-stat-label">{{ label }}</div>
      </button>
      <div class="tk-stat">
        <div class="tk-stat-val" style="color:#0f172a">{{ stats.total || 0 }}</div>
        <div class="tk-stat-label">الإجمالي</div>
      </div>
    </div>

    <!-- Search -->
    <div class="tk-search-bar">
      <input v-model="search" @keyup.enter="doSearch" type="text" placeholder="بحث بالموضوع أو رقم التذكرة..." class="tk-search-input" />
      <button @click="doSearch" class="tk-search-btn">🔍</button>
    </div>

    <!-- Tickets List -->
    <div class="tk-card">
      <div v-for="t in tickets.data" :key="t.id" class="tk-item">
        <div class="tk-item-right">
          <span class="tk-priority-dot" :style="{background: priorityColors[t.priority]}"></span>
          <div>
            <div class="tk-item-subject">
              <Link :href="route('admin.tickets.show', t.id)" class="tk-link">{{ t.subject }}</Link>
              <span class="tk-ticket-num">{{ t.ticket_number }}</span>
            </div>
            <div class="tk-item-meta">
              <span>{{ t.user?.full_name }}</span>
              <span>·</span>
              <span>{{ fmtDate(t.created_at) }}</span>
              <span>·</span>
              <span>{{ t.replies_count }} ردود</span>
            </div>
          </div>
        </div>
        <div class="tk-item-left">
          <span class="tk-cat-badge">{{ catLabels[t.category] || t.category }}</span>
          <span class="tk-priority-badge" :style="{color: priorityColors[t.priority], background: priorityColors[t.priority] + '15'}">{{ priorityIcons[t.priority] }} {{ priorityLabels[t.priority] }}</span>
          <span class="tk-status-badge" :style="{color: statusColors[t.status], background: statusColors[t.status] + '15'}">{{ statusLabels[t.status] }}</span>
        </div>
      </div>
      <div v-if="!tickets.data?.length" class="tk-empty">🎫 لا توجد تذاكر</div>
    </div>

  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
.tk-success{background:#ecfdf5;color:#059669;padding:12px 16px;border-radius:12px;font-size:14px;font-weight:600;border:1px solid #a7f3d0;margin-bottom:16px}
.tk-stats{display:flex;gap:10px;margin-bottom:16px}
.tk-stat{background:#fff;border:1px solid #e2e8f0;border-radius:14px;padding:14px 20px;text-align:center;flex:1;cursor:pointer;transition:all .15s}
.tk-stat:hover{border-color:#10b981}
.tk-stat-active{border-color:#10b981!important;box-shadow:0 0 0 3px rgba(16,185,129,.12)}
.tk-stat-val{font-size:28px;font-weight:800}
.tk-stat-label{font-size:12px;color:#64748b;margin-top:2px;font-weight:600}
.tk-search-bar{display:flex;gap:8px;margin-bottom:16px}
.tk-search-input{flex:1;padding:10px 14px;border:1px solid #e2e8f0;border-radius:12px;font-size:14px;color:#0f172a;outline:none;background:#fff}.tk-search-input:focus{border-color:#10b981}
.tk-search-btn{padding:10px 16px;border-radius:12px;border:1px solid #e2e8f0;background:#fff;cursor:pointer;font-size:16px}.tk-search-btn:hover{border-color:#10b981}
.tk-card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;overflow:hidden}
.tk-item{display:flex;justify-content:space-between;align-items:center;padding:16px 20px;border-bottom:1px solid #f1f5f9;transition:background .15s}
.tk-item:hover{background:#fafbfc}
.tk-item:last-child{border-bottom:none}
.tk-item-right{display:flex;align-items:center;gap:12px;flex:1}
.tk-priority-dot{width:8px;height:8px;border-radius:50%;flex-shrink:0}
.tk-item-subject{display:flex;align-items:center;gap:8px}
.tk-link{font-size:14px;font-weight:600;color:#0f172a;text-decoration:none}.tk-link:hover{color:#10b981}
.tk-ticket-num{font-size:11px;color:#94a3b8;font-family:monospace}
.tk-item-meta{display:flex;gap:6px;font-size:12px;color:#64748b;margin-top:4px}
.tk-item-left{display:flex;align-items:center;gap:8px;flex-shrink:0}
.tk-cat-badge{font-size:11px;background:#f1f5f9;color:#334155;padding:3px 8px;border-radius:6px;font-weight:600}
.tk-priority-badge,.tk-status-badge{font-size:11px;font-weight:600;padding:3px 10px;border-radius:8px}
.tk-empty{padding:40px;text-align:center;color:#94a3b8;font-size:14px}
</style>
