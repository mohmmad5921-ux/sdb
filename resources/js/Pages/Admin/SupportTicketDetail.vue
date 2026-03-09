<script setup>
import { Head, Link, useForm, usePage, router } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { computed } from 'vue';

const props = defineProps({ ticket: Object });
const flash = computed(() => usePage().props.flash || {});
const form = useForm({ message: '' });
const reply = () => form.post(route('admin.support.reply', props.ticket.id), { onSuccess: () => form.reset() });
const updateStatus = (status) => router.patch(route('admin.support.status', props.ticket.id), { status });
const statusLabels = { open: 'مفتوحة', in_progress: 'قيد المعالجة', waiting_customer: 'بانتظار العميل', resolved: 'تم الحل', closed: 'مغلقة' };
const timeAgo = (d) => { if (!d) return '-'; const s = Math.floor((Date.now() - new Date(d)) / 1000); if (s < 60) return 'الآن'; if (s < 3600) return Math.floor(s/60) + ' دقيقة'; if (s < 86400) return Math.floor(s/3600) + ' ساعة'; return Math.floor(s/86400) + ' يوم'; };
</script>

<template>
  <Head :title="'Support: ' + ticket.ticket_number" />
  <AdminLayout title="🎧 تفاصيل التذكرة">
    <div class="sd-root">
      <div class="sd-header">
        <div class="max-w-3xl mx-auto px-6 py-4">
          <div class="flex justify-between items-start">
            <div>
              <h1 class="text-xl font-bold text-[#f1f5f9]">{{ ticket.subject }}</h1>
              <div class="text-xs text-[#94a3b8] mt-1 flex items-center gap-2">
                <span class="font-mono text-[#1E5EFF]">{{ ticket.ticket_number }}</span><span>·</span><span>{{ ticket.user?.full_name }}</span><span>·</span><span>{{ statusLabels[ticket.status] }}</span>
              </div>
            </div>
            <Link :href="route('admin.support')" class="sd-back">← القائمة</Link>
          </div>
          <div class="flex gap-2 mt-3">
            <button @click="updateStatus('in_progress')" class="sd-status-btn sd-btn-yellow">⏳ قيد المعالجة</button>
            <button @click="updateStatus('resolved')" class="sd-status-btn sd-btn-green">✅ تم الحل</button>
            <button @click="updateStatus('closed')" class="sd-status-btn sd-btn-gray">🔒 إغلاق</button>
          </div>
        </div>
      </div>
      <div v-if="flash.success" class="max-w-3xl mx-auto px-6 mt-3"><div class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-2 text-emerald-700 text-sm">✓ {{ flash.success }}</div></div>
      <div class="flex-1 max-w-3xl mx-auto w-full px-6 py-4 overflow-y-auto">
        <div class="space-y-4">
          <div v-for="msg in ticket.messages" :key="msg.id" :class="msg.is_admin ? 'ml-auto' : 'mr-auto'" class="max-w-[80%]">
            <div :class="msg.is_admin ? 'sd-msg-admin' : 'sd-msg-user'" class="rounded-2xl p-4">
              <div class="flex items-center gap-2 mb-2">
                <span class="text-xs font-medium" :class="msg.is_admin ? 'text-[#1E5EFF]' : 'text-[#cbd5e1]'">{{ msg.is_admin ? '🛡 أنت (الدعم)' : '👤 ' + msg.user?.full_name }}</span>
                <span class="text-[10px] text-[#94a3b8]">{{ timeAgo(msg.created_at) }}</span>
              </div>
              <p class="text-sm leading-relaxed whitespace-pre-wrap text-[#f1f5f9]">{{ msg.message }}</p>
            </div>
          </div>
        </div>
      </div>
      <div class="sd-reply-bar">
        <form @submit.prevent="reply" class="max-w-3xl mx-auto flex gap-3">
          <input v-model="form.message" placeholder="اكتب ردك كإداري..." class="sd-reply-input" />
          <button type="submit" :disabled="!form.message || form.processing" class="sd-reply-btn">إرسال</button>
        </form>
      </div>
    </div>
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
@import '../../../css/admin.css';
.sd-root{min-height:100vh;background:#f1f5f9;direction:rtl;display:flex;flex-direction:column}
.sd-header{background:#ffffff;border-bottom:1px solid #e2e8f0}
.sd-back{padding:6px 14px;background:#ffffff;color:#3b82f6;border-radius:8px;font-size:12px;font-weight:600;text-decoration:none;border:1px solid rgba(16,185,129,0.2)}.sd-back:hover{background:#10b981;color:#fff}
.sd-status-btn{font-size:11px;padding:4px 12px;border-radius:8px;font-weight:600;cursor:pointer;border:1px solid transparent;transition:all .2s}
.sd-btn-yellow{background:rgba(245,158,11,0.08);color:#d97706;border-color:rgba(245,158,11,0.15)}.sd-btn-green{background:rgba(16,185,129,0.08);color:#059669;border-color:rgba(16,185,129,0.15)}.sd-btn-gray{background:#f1f5f9;color:#64748b}
.sd-msg-admin{background:#ffffff;border:1px solid rgba(16,185,129,0.2)}.sd-msg-user{background:#ffffff;border:1px solid #e2e8f0}
.sd-reply-bar{border-top:1px solid #E8ECF1;padding:16px;background:#ffffff}
.sd-reply-input{flex:1;border:1px solid #e2e8f0;border-radius:14px;padding:12px 16px;font-size:13px;color:#0f172a;outline:none}.sd-reply-input:focus{border-color:#10b981}.sd-reply-input::placeholder{color:#64748b}
.sd-reply-btn{padding:12px 24px;background:#10b981;color:#fff;border-radius:14px;font-size:13px;font-weight:600;border:none;cursor:pointer}.sd-reply-btn:hover{background:#1047b8}.sd-reply-btn:disabled{opacity:0.5}
</style>
