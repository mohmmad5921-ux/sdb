<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref } from 'vue';

const props = defineProps({ users: Object, filters: Object });
const search = ref(props.filters?.search || '');
const applyFilter = () => router.get(route('admin.users'), { search: search.value }, { preserveState: true });

const statusBadge = { active: 'ul-badge-green', pending: 'ul-badge-yellow', suspended: 'ul-badge-red', blocked: 'ul-badge-red', verified: 'ul-badge-green', submitted: 'ul-badge-blue', rejected: 'ul-badge-red' };
</script>

<template>
  <Head title="Users Management - إدارة العملاء" />
  <AuthenticatedLayout>
    <div class="ul-root">
      <!-- Header -->
      <div class="ul-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-[#1A2B4A]">إدارة العملاء</h1>
            <p class="text-sm text-[#8896AB] mt-1">{{ users.total }} عميل مسجل</p>
          </div>
          <Link :href="route('admin.dashboard')" class="ul-back">← الرئيسية</Link>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-6 py-6">
        <!-- Search -->
        <div class="mb-6">
          <input v-model="search" @keyup.enter="applyFilter" type="text" placeholder="بحث بالاسم أو البريد أو الهاتف..."
            class="ul-search" />
        </div>

        <!-- Table -->
        <div class="ul-card overflow-hidden">
          <table class="ul-table">
            <thead>
              <tr>
                <th>العميل</th><th>الهاتف</th><th class="text-center">الحالة</th><th class="text-center">KYC</th>
                <th class="text-center">حسابات</th><th class="text-center">بطاقات</th><th>التاريخ</th><th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="user in users.data" :key="user.id">
                <td>
                  <div class="flex items-center gap-3">
                    <div class="ul-avatar">{{ user.full_name?.charAt(0) }}</div>
                    <div>
                      <div class="text-sm font-semibold text-[#1A2B4A]">{{ user.full_name }}</div>
                      <div class="text-xs text-[#8896AB]">{{ user.email }}</div>
                      <div class="text-[10px] font-mono text-[#1E5EFF]" v-if="user.customer_number">رقم: {{ user.customer_number }}</div>
                    </div>
                  </div>
                </td>
                <td class="text-[#5A6B82]">{{ user.phone || '—' }}</td>
                <td class="text-center"><span :class="statusBadge[user.status]" class="ul-badge">{{ user.status }}</span></td>
                <td class="text-center"><span :class="statusBadge[user.kyc_status]" class="ul-badge">{{ user.kyc_status }}</span></td>
                <td class="text-center text-[#5A6B82]">{{ user.accounts_count }}</td>
                <td class="text-center text-[#5A6B82]">{{ user.cards_count }}</td>
                <td class="text-[#8896AB] text-sm">{{ new Date(user.created_at).toLocaleDateString('en-GB') }}</td>
                <td><Link :href="route('admin.users.show', user.id)" class="ul-view-btn">عرض التفاصيل ←</Link></td>
              </tr>
            </tbody>
          </table>
          <div v-if="!users.data?.length" class="py-12 text-center text-[#8896AB]">لا يوجد عملاء</div>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center gap-2 mt-6" v-if="users.last_page > 1">
          <Link v-for="link in users.links" :key="link.label" :href="link.url || '#'"
            :class="['ul-page-btn', link.active ? 'ul-page-active' : '']"
            v-html="link.label" :disabled="!link.url" />
        </div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.ul-root{min-height:100vh;background:#F0F2F5;direction:rtl}
.ul-header{background:linear-gradient(135deg,#fff 0%,#F8FAFC 100%);border-bottom:1px solid #E8ECF1}
.ul-back{padding:8px 18px;background:#F0F4FF;color:#1E5EFF;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(30,94,255,0.12);transition:all .2s}.ul-back:hover{background:#1E5EFF;color:#fff}
.ul-search{width:100%;max-width:440px;padding:12px 18px;border:1px solid #E8ECF1;border-radius:14px;background:#fff;font-size:14px;color:#1A2B4A;outline:none;transition:border-color .2s}.ul-search:focus{border-color:#1E5EFF;box-shadow:0 0 0 3px rgba(30,94,255,0.08)}.ul-search::placeholder{color:#8896AB}
.ul-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px}
.ul-table{width:100%;border-collapse:collapse;font-size:14px}
.ul-table th{text-align:right;padding:14px 18px;background:#FAFBFC;color:#8896AB;font-weight:600;font-size:12px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #E8ECF1}
.ul-table td{padding:14px 18px;border-bottom:1px solid #F0F2F5;vertical-align:middle}
.ul-table tr:hover td{background:#FAFBFC}
.ul-table tr:last-child td{border-bottom:none}
.ul-avatar{width:40px;height:40px;border-radius:12px;background:linear-gradient(135deg,#1E5EFF,#3B82F6);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:14px;flex-shrink:0}
.ul-badge{font-size:11px;padding:3px 10px;border-radius:100px;font-weight:600}
.ul-badge-green{background:rgba(16,185,129,0.1);color:#059669}
.ul-badge-yellow{background:rgba(245,158,11,0.1);color:#d97706}
.ul-badge-red{background:rgba(239,68,68,0.1);color:#dc2626}
.ul-badge-blue{background:rgba(30,94,255,0.1);color:#1E5EFF}
.ul-view-btn{padding:6px 14px;background:#F0F4FF;color:#1E5EFF;border-radius:8px;font-size:12px;font-weight:600;text-decoration:none;border:1px solid rgba(30,94,255,0.12);transition:all .2s}.ul-view-btn:hover{background:#1E5EFF;color:#fff}
.ul-page-btn{padding:6px 14px;border-radius:8px;font-size:13px;background:#fff;color:#5A6B82;border:1px solid #E8ECF1;text-decoration:none;transition:all .2s}.ul-page-btn:hover{border-color:#1E5EFF;color:#1E5EFF}
.ul-page-active{background:#1E5EFF!important;color:#fff!important;border-color:#1E5EFF!important}
</style>
