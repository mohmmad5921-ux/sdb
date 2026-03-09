<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ ticket: Object, replies: Array });
const flash = computed(() => usePage().props.flash || {});

const replyForm = useForm({ message: '' });
const sendReply = () => replyForm.post(route('admin.tickets.reply', props.ticket.id), { onSuccess: () => replyForm.reset(), preserveScroll: true });

const statusForm = useForm({ status: props.ticket.status });
const updateStatus = () => statusForm.patch(route('admin.tickets.status', props.ticket.id), { preserveScroll: true });

const priorityForm = useForm({ priority: props.ticket.priority });
const updatePriority = () => priorityForm.patch(route('admin.tickets.priority', props.ticket.id), { preserveScroll: true });

const priorityLabels = { low: 'منخفض', normal: 'عادي', high: 'مهم', urgent: 'عاجل' };
const statusLabels = { open: 'مفتوحة', in_progress: 'قيد المعالجة', waiting: 'بانتظار', resolved: 'محلولة', closed: 'مغلقة' };
const fmtDate = (d) => new Date(d).toLocaleDateString('ar-EG', { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
</script>

<template>
  <Head :title="'تذكرة ' + ticket.ticket_number" />
  <AdminLayout :title="'🎫 ' + ticket.subject" :subtitle="ticket.ticket_number">

    <div v-if="flash.success" class="td-success">✓ {{ flash.success }}</div>

    <div class="td-layout">
      <!-- Chat Column -->
      <div class="td-chat-col">
        <div class="td-card">
          <div class="td-desc">
            <strong>{{ ticket.user?.full_name }}</strong> — {{ fmtDate(ticket.created_at) }}
            <p class="mt-2">{{ ticket.description }}</p>
          </div>

          <div class="td-replies">
            <div v-for="r in replies" :key="r.id" :class="['td-reply', r.is_admin ? 'td-reply-admin' : 'td-reply-user']">
              <div class="td-reply-head">
                <span class="td-reply-name">{{ r.is_admin ? '🛡️ ' : '👤 ' }}{{ r.user?.full_name }}</span>
                <span class="td-reply-date">{{ fmtDate(r.created_at) }}</span>
              </div>
              <div class="td-reply-body">{{ r.message }}</div>
            </div>
          </div>

          <!-- Reply Form -->
          <div v-if="ticket.status !== 'closed'" class="td-reply-form">
            <textarea v-model="replyForm.message" rows="3" class="td-input" placeholder="اكتب ردّك هنا..."></textarea>
            <button @click="sendReply" :disabled="!replyForm.message || replyForm.processing" class="td-send-btn">📩 إرسال الرد</button>
          </div>
        </div>
      </div>

      <!-- Info Sidebar -->
      <div class="td-info-col">
        <div class="td-card">
          <h4 class="td-info-title">ℹ️ تفاصيل التذكرة</h4>
          <div class="td-info-row"><span>العميل:</span><Link :href="route('admin.users.show', ticket.user?.id)" class="td-link">{{ ticket.user?.full_name }}</Link></div>
          <div class="td-info-row"><span>البريد:</span><span>{{ ticket.user?.email }}</span></div>
          <div class="td-info-row"><span>التاريخ:</span><span>{{ fmtDate(ticket.created_at) }}</span></div>
          <div class="td-info-row"><span>المعالج:</span><span>{{ ticket.assignee?.full_name || '— لم يُعيّن' }}</span></div>

          <div class="td-divider"></div>

          <h4 class="td-info-title">🔧 تحديث الحالة</h4>
          <select v-model="statusForm.status" @change="updateStatus" class="td-select">
            <option v-for="(l, k) in statusLabels" :key="k" :value="k">{{ l }}</option>
          </select>

          <h4 class="td-info-title mt-3">⚡ الأولوية</h4>
          <select v-model="priorityForm.priority" @change="updatePriority" class="td-select">
            <option v-for="(l, k) in priorityLabels" :key="k" :value="k">{{ l }}</option>
          </select>
        </div>
      </div>
    </div>

  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
.td-success{background:#ecfdf5;color:#059669;padding:12px 16px;border-radius:12px;font-size:14px;font-weight:600;border:1px solid #a7f3d0;margin-bottom:16px}
.td-layout{display:grid;grid-template-columns:1fr 320px;gap:20px}
.td-card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;padding:20px}
.td-desc{font-size:14px;color:#334155;line-height:1.7;padding-bottom:16px;border-bottom:1px solid #f1f5f9}
.td-replies{display:flex;flex-direction:column;gap:12px;margin-top:16px}
.td-reply{padding:14px;border-radius:14px;border:1px solid #e2e8f0}
.td-reply-admin{background:#ecfdf5;border-color:#a7f3d0}
.td-reply-user{background:#f8fafc}
.td-reply-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px}
.td-reply-name{font-size:13px;font-weight:600;color:#0f172a}
.td-reply-date{font-size:11px;color:#94a3b8}
.td-reply-body{font-size:14px;color:#334155;line-height:1.6;white-space:pre-wrap}
.td-reply-form{margin-top:16px;padding-top:16px;border-top:1px solid #f1f5f9}
.td-input{width:100%;border:1px solid #e2e8f0;border-radius:12px;padding:12px;font-size:14px;color:#0f172a;outline:none;resize:none}.td-input:focus{border-color:#10b981}
.td-send-btn{margin-top:8px;padding:10px 20px;border-radius:12px;background:#10b981;color:#fff;border:none;font-weight:700;cursor:pointer;font-size:14px}.td-send-btn:hover{background:#059669}.td-send-btn:disabled{opacity:.5}
.td-info-title{font-size:14px;font-weight:700;color:#0f172a;margin-bottom:10px}
.td-info-row{display:flex;justify-content:space-between;font-size:13px;color:#475569;padding:6px 0;border-bottom:1px solid #f8fafc}
.td-link{color:#10b981;text-decoration:none;font-weight:600}.td-link:hover{text-decoration:underline}
.td-divider{height:1px;background:#e2e8f0;margin:14px 0}
.td-select{width:100%;padding:8px 12px;border:1px solid #e2e8f0;border-radius:10px;font-size:13px;color:#0f172a;outline:none;background:#fff}.td-select:focus{border-color:#10b981}
@media(max-width:900px){.td-layout{grid-template-columns:1fr}}
</style>
