<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ planCounts: Object, users: Array, preregByPlan: Array });
const f = n => Number(n||0).toLocaleString('en');
const filter = ref('all');

const plans = [
  { key: 'personal', label: 'Personal', icon: '🔵', color: '#3b82f6', price: '€9.99/شهر' },
  { key: 'plus', label: 'Plus', icon: '🟣', color: '#8b5cf6', price: '€19.99/شهر' },
  { key: 'business', label: 'Business', icon: '🩷', color: '#ec4899', price: '€49/شهر' },
  { key: 'enterprise', label: 'Enterprise', icon: '🟡', color: '#f59e0b', price: 'مخصص' },
];

const totalSubs = computed(() => {
  if (!p.planCounts) return 0;
  return Object.values(p.planCounts).reduce((s,v) => s+v, 0);
});

const filteredUsers = computed(() => {
  if (!p.users) return [];
  if (filter.value === 'all') return p.users;
  return p.users.filter(u => u.plan === filter.value);
});

const planBadge = plan => {
  const m = { personal: { bg: '#eff6ff', color: '#3b82f6' }, plus: { bg: '#f5f3ff', color: '#8b5cf6' },
    business: { bg: '#fdf2f8', color: '#ec4899' }, enterprise: { bg: '#fffbeb', color: '#f59e0b' } };
  return m[plan] || { bg: '#f1f5f9', color: '#64748b' };
};
</script>
<template>
<Head title="الاشتراكات — الأدمن" />
<div class="sp">
  <div class="sp-header"><h1 class="sp-h">💎 الاشتراكات والباقات</h1><div class="sp-sum">{{ f(totalSubs) }} مشترك</div></div>

  <!-- Plan KPIs -->
  <div class="sp-plans">
    <div v-for="plan in plans" :key="plan.key" class="sp-plan"
      :class="{'sp-plan-active': filter === plan.key}"
      @click="filter = filter === plan.key ? 'all' : plan.key">
      <div class="sp-plan-icon">{{ plan.icon }}</div>
      <div class="sp-plan-name">{{ plan.label }}</div>
      <div class="sp-plan-count" :style="{color: plan.color}">{{ f(p.planCounts?.[plan.key] || 0) }}</div>
      <div class="sp-plan-price">{{ plan.price }}</div>
    </div>
  </div>

  <!-- Pre-registration by plan -->
  <div v-if="p.preregByPlan?.length" class="sp-card">
    <div class="sp-card-title">📋 التسجيل المسبق حسب الباقة</div>
    <div class="sp-prereg-grid">
      <div v-for="pr in p.preregByPlan" :key="pr.plan" class="sp-prereg">
        <div class="sp-prereg-label">{{ pr.plan || 'غير محدد' }}</div>
        <div class="sp-prereg-count">{{ f(pr.count) }}</div>
      </div>
    </div>
  </div>

  <!-- Users Table -->
  <div class="sp-card">
    <div class="sp-card-header">
      <div class="sp-card-title">👥 المشتركين {{ filter !== 'all' ? '— ' + filter : '' }}</div>
      <button v-if="filter !== 'all'" @click="filter = 'all'" class="sp-reset">عرض الكل</button>
    </div>
    <table class="sp-tbl">
      <thead><tr><th>#</th><th>الاسم</th><th>البريد</th><th>الدولة</th><th>الباقة</th><th>التاريخ</th></tr></thead>
      <tbody>
        <tr v-for="(u,i) in filteredUsers" :key="u.id">
          <td>{{ i+1 }}</td>
          <td class="sp-bold">{{ u.full_name || u.name || '—' }}</td>
          <td>{{ u.email }}</td>
          <td>{{ u.country || '—' }}</td>
          <td><span class="sp-badge" :style="{background: planBadge(u.plan).bg, color: planBadge(u.plan).color}">{{ u.plan || 'Free' }}</span></td>
          <td class="sp-date">{{ u.created_at ? new Date(u.created_at).toLocaleDateString('ar') : '—' }}</td>
        </tr>
        <tr v-if="!filteredUsers.length"><td colspan="6" class="sp-empty">لا توجد بيانات</td></tr>
      </tbody>
    </table>
  </div>
</div>
</template>
<style scoped>
.sp{direction:rtl;max-width:1400px;margin:0 auto}
.sp-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}.sp-h{font-size:22px;font-weight:900;color:#0f172a}.sp-sum{font-size:13px;color:#94a3b8}
.sp-plans{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:20px}
.sp-plan{background:#fff;border:2px solid #f1f5f9;border-radius:16px;padding:20px;text-align:center;cursor:pointer;transition:all .2s}
.sp-plan:hover{transform:translateY(-2px);box-shadow:0 6px 16px rgba(0,0,0,.06)}
.sp-plan-active{border-color:#10b981;box-shadow:0 0 0 3px rgba(16,185,129,.1)}
.sp-plan-icon{font-size:28px;margin-bottom:6px}
.sp-plan-name{font-size:15px;font-weight:800;color:#0f172a;margin-bottom:4px}
.sp-plan-count{font-size:32px;font-weight:900;margin-bottom:2px}
.sp-plan-price{font-size:12px;color:#94a3b8;font-weight:600}
.sp-card{background:#fff;border:1px solid #f1f5f9;border-radius:16px;padding:20px;margin-bottom:16px}
.sp-card-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px}
.sp-card-title{font-size:14px;font-weight:800;color:#1e293b;margin-bottom:14px}
.sp-reset{font-size:12px;background:#f1f5f9;border:1px solid #e2e8f0;border-radius:8px;padding:4px 12px;cursor:pointer;color:#64748b;font-weight:600}
.sp-prereg-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:10px}
.sp-prereg{background:#f8fafc;border:1px solid #f1f5f9;border-radius:12px;padding:14px;text-align:center}
.sp-prereg-label{font-size:12px;font-weight:700;color:#475569;margin-bottom:4px;text-transform:capitalize}
.sp-prereg-count{font-size:22px;font-weight:900;color:#10b981}
.sp-tbl{width:100%;border-collapse:collapse}
.sp-tbl th{font-size:11px;font-weight:700;color:#94a3b8;text-align:right;padding:10px;border-bottom:2px solid #f1f5f9}
.sp-tbl td{font-size:13px;color:#334155;padding:10px;border-bottom:1px solid #f8fafc}
.sp-bold{font-weight:700;color:#0f172a}
.sp-badge{font-size:11px;font-weight:700;padding:3px 10px;border-radius:8px;text-transform:capitalize}
.sp-date{font-size:11px;color:#94a3b8}
.sp-empty{text-align:center;color:#cbd5e1;padding:30px;font-style:italic}
@media(max-width:768px){.sp-plans{grid-template-columns:repeat(2,1fr)}}
</style>
