<template>
  <AdminLayout title="محادثات الدعم">
    <div class="chat-container">
      <!-- Sidebar: Conversations List -->
      <div class="conversations-panel">
        <div class="panel-header">
          <h3>💬 المحادثات</h3>
          <span class="count">{{ conversations.length }}</span>
        </div>
        <div class="conv-list">
          <div v-for="c in conversations" :key="c.user_id"
               class="conv-item" :class="{ active: selectedUser === c.user_id, unread: c.unread_count > 0 }"
               @click="selectUser(c)">
            <div class="conv-avatar" :class="c.user_status">
              {{ (c.user_name || 'U')[0] }}
            </div>
            <div class="conv-info">
              <div class="conv-name">
                {{ c.user_name }}
                <span v-if="c.unread_count" class="badge">{{ c.unread_count }}</span>
              </div>
              <div class="conv-preview">
                <span v-if="c.sender_type === 'ai'" class="sender-tag ai">🤖</span>
                <span v-else-if="c.sender_type === 'admin'" class="sender-tag admin">👤</span>
                {{ truncate(c.last_message, 40) }}
              </div>
              <div class="conv-time">{{ timeAgo(c.last_message_at) }}</div>
            </div>
          </div>
          <div v-if="!conversations.length" class="empty">لا توجد محادثات</div>
        </div>
      </div>

      <!-- Chat Panel -->
      <div class="chat-panel">
        <template v-if="selectedUser">
          <div class="chat-header">
            <strong>{{ selectedUserName }}</strong>
            <span class="status-badge" :class="selectedUserStatus">
              {{ selectedUserStatus === 'pending' ? 'قيد المراجعة' : selectedUserStatus === 'active' ? 'نشط' : selectedUserStatus }}
            </span>
          </div>
          <div class="messages-area" ref="messagesArea">
            <div v-for="m in messages" :key="m.id"
                 class="message" :class="m.sender_type">
              <div class="msg-sender" v-if="m.sender_type !== 'user'">
                <span v-if="m.sender_type === 'ai'" class="sender-label ai">🤖 SDB AI</span>
                <span v-else class="sender-label admin">👤 {{ m.sender_name || 'موظف' }}</span>
              </div>
              <div class="msg-bubble">{{ m.content }}</div>
              <div class="msg-time">{{ formatTime(m.created_at) }}</div>
            </div>
          </div>
          <div class="reply-bar">
            <input v-model="replyText" @keyup.enter="sendReply"
                   placeholder="اكتب ردك... (يتم إرسال الرد كموظف)" />
            <button @click="sendReply" :disabled="!replyText.trim() || sending">
              {{ sending ? '...' : 'إرسال' }}
            </button>
          </div>
        </template>
        <div v-else class="no-selection">
          <div class="empty-icon">💬</div>
          <p>اختر محادثة من القائمة</p>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup>
import { ref, nextTick } from 'vue';
import { router } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';

const props = defineProps({ conversations: { type: Array, default: () => [] } });

const selectedUser = ref(null);
const selectedUserName = ref('');
const selectedUserStatus = ref('');
const messages = ref([]);
const replyText = ref('');
const sending = ref(false);
const messagesArea = ref(null);
let pollInterval = null;

function selectUser(c) {
  selectedUser.value = c.user_id;
  selectedUserName.value = c.user_name;
  selectedUserStatus.value = c.user_status;
  loadMessages();
  // Poll every 3s
  if (pollInterval) clearInterval(pollInterval);
  pollInterval = setInterval(loadMessages, 3000);
}

async function loadMessages() {
  if (!selectedUser.value) return;
  try {
    const res = await fetch(`/admin/chat/${selectedUser.value}/messages`);
    const data = await res.json();
    messages.value = data.messages || [];
    await nextTick();
    scrollToBottom();
  } catch (e) { console.error(e); }
}

async function sendReply() {
  if (!replyText.value.trim() || sending.value) return;
  sending.value = true;
  try {
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
    const res = await fetch(`/admin/chat/${selectedUser.value}/reply`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken, 'Accept': 'application/json' },
      body: JSON.stringify({ message: replyText.value }),
    });
    const data = await res.json();
    if (data.message) {
      messages.value.push(data.message);
      replyText.value = '';
      await nextTick();
      scrollToBottom();
    }
  } catch (e) { console.error(e); }
  sending.value = false;
}

function scrollToBottom() {
  if (messagesArea.value) messagesArea.value.scrollTop = messagesArea.value.scrollHeight;
}

function truncate(s, n) { return s && s.length > n ? s.slice(0, n) + '...' : s || ''; }
function timeAgo(d) {
  if (!d) return '';
  const diff = (Date.now() - new Date(d)) / 1000;
  if (diff < 60) return 'الآن';
  if (diff < 3600) return `${Math.floor(diff/60)}د`;
  if (diff < 86400) return `${Math.floor(diff/3600)}س`;
  return `${Math.floor(diff/86400)}ي`;
}
function formatTime(d) {
  if (!d) return '';
  return new Date(d).toLocaleTimeString('ar', { hour: '2-digit', minute: '2-digit' });
}
</script>

<style scoped>
.chat-container { display: flex; height: calc(100vh - 80px); border: 1px solid #e5e7eb; border-radius: 12px; overflow: hidden; background: #fff; }
.conversations-panel { width: 320px; border-right: 1px solid #e5e7eb; display: flex; flex-direction: column; }
.panel-header { display: flex; align-items: center; justify-content: space-between; padding: 16px; border-bottom: 1px solid #e5e7eb; }
.panel-header h3 { margin: 0; font-size: 16px; }
.count { background: #10b981; color: #fff; padding: 2px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }
.conv-list { flex: 1; overflow-y: auto; }
.conv-item { display: flex; align-items: center; padding: 14px 16px; cursor: pointer; border-bottom: 1px solid #f3f4f6; transition: background 0.15s; gap: 12px; }
.conv-item:hover { background: #f9fafb; }
.conv-item.active { background: #ecfdf5; border-right: 3px solid #10b981; }
.conv-item.unread { background: #fffbeb; }
.conv-avatar { width: 40px; height: 40px; border-radius: 20px; background: #e5e7eb; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 16px; color: #374151; flex-shrink: 0; }
.conv-avatar.pending { background: #fef3c7; color: #92400e; }
.conv-avatar.active { background: #d1fae5; color: #065f46; }
.conv-info { flex: 1; min-width: 0; }
.conv-name { font-weight: 600; font-size: 14px; display: flex; align-items: center; gap: 6px; }
.badge { background: #ef4444; color: #fff; padding: 1px 7px; border-radius: 10px; font-size: 11px; }
.conv-preview { font-size: 12px; color: #6b7280; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 2px; }
.conv-time { font-size: 11px; color: #9ca3af; margin-top: 2px; }
.sender-tag { font-size: 11px; }

.chat-panel { flex: 1; display: flex; flex-direction: column; }
.chat-header { padding: 16px; border-bottom: 1px solid #e5e7eb; display: flex; align-items: center; gap: 10px; }
.status-badge { font-size: 11px; padding: 2px 8px; border-radius: 8px; font-weight: 600; }
.status-badge.pending { background: #fef3c7; color: #92400e; }
.status-badge.active { background: #d1fae5; color: #065f46; }
.messages-area { flex: 1; overflow-y: auto; padding: 16px; display: flex; flex-direction: column; gap: 12px; }
.message { max-width: 70%; }
.message.user { align-self: flex-end; }
.message.ai, .message.admin { align-self: flex-start; }
.msg-sender { margin-bottom: 4px; }
.sender-label { font-size: 12px; font-weight: 600; }
.sender-label.ai { color: #10b981; }
.sender-label.admin { color: #3b82f6; }
.msg-bubble { padding: 10px 14px; border-radius: 14px; font-size: 14px; line-height: 1.6; word-break: break-word; }
.message.user .msg-bubble { background: #10b981; color: #fff; border-bottom-right-radius: 4px; }
.message.ai .msg-bubble { background: #f3f4f6; color: #111827; border-bottom-left-radius: 4px; }
.message.admin .msg-bubble { background: #eff6ff; color: #1e3a5f; border: 1px solid #bfdbfe; border-bottom-left-radius: 4px; }
.msg-time { font-size: 10px; color: #9ca3af; margin-top: 2px; }
.message.user .msg-time { text-align: right; }

.reply-bar { display: flex; gap: 8px; padding: 12px 16px; border-top: 1px solid #e5e7eb; }
.reply-bar input { flex: 1; padding: 10px 14px; border: 1px solid #e5e7eb; border-radius: 10px; font-size: 14px; direction: rtl; }
.reply-bar input:focus { outline: none; border-color: #3b82f6; }
.reply-bar button { padding: 10px 20px; background: #3b82f6; color: #fff; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; }
.reply-bar button:hover { background: #2563eb; }
.reply-bar button:disabled { opacity: 0.5; cursor: not-allowed; }

.no-selection { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #9ca3af; }
.empty-icon { font-size: 48px; margin-bottom: 12px; }
.empty { padding: 40px; text-align: center; color: #9ca3af; }
</style>
