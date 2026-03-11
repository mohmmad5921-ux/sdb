<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ documents: Object, filters: Object, stats: Object, userQueue: Array });
const flash = computed(() => usePage().props.flash || {});
const filter = ref(props.filters?.status || 'pending');

const applyFilter = (status) => { filter.value = status; router.get(route('admin.kyc'), { status }, { preserveState: true }); };

const reviewDoc = ref(null);
const rejectionReason = ref('');
const previewDoc = ref(null);
const zoomLevel = ref(1);
const msgModal = ref(null);
const msgType = ref('approved');
const customMsg = ref('');
const expandedUser = ref(null);
const selectedDocTypes = ref([]);

const approve = (doc) => router.post(route('admin.kyc.review', doc.id), { action: 'approve' }, { preserveScroll: true });
const reject = (doc) => {
  if (!rejectionReason.value) return;
  router.post(route('admin.kyc.review', doc.id), { action: 'reject', rejection_reason: rejectionReason.value }, {
    preserveScroll: true, onSuccess: () => { reviewDoc.value = null; rejectionReason.value = ''; }
  });
};
const approveAll = (userId) => router.post(route('admin.kyc.approve-all', userId), {}, { preserveScroll: true });
const sendMessage = (userId) => {
  router.post(route('admin.kyc.message', userId), {
    message_type: msgType.value,
    custom_message: msgType.value === 'custom' ? customMsg.value : null,
    doc_types: msgType.value === 'request_docs' ? selectedDocTypes.value : null,
  }, {
    preserveScroll: true,
    onSuccess: () => { msgModal.value = null; customMsg.value = ''; msgType.value = 'approved'; selectedDocTypes.value = []; }
  });
};

const docTypeLabels = { id_card: 'بطاقة هوية', id_front: 'هوية — أمام', id_back: 'هوية — خلف', selfie: 'صورة شخصية', proof_of_address: 'إثبات عنوان', passport: 'جواز سفر' };
const statusBadge = { pending: 'ky-badge-yellow', approved: 'ky-badge-green', rejected: 'ky-badge-red' };

const rejectionReasons = [
  'صورة غير واضحة أو مقصوصة',
  'المستند منتهي الصلاحية',
  'الاسم لا يتطابق مع بيانات الحساب',
  'المستند ليس بالنوع المطلوب',
  'صورة السيلفي لا تتطابق مع الهوية',
  'المستند مزور أو معدّل',
  'سبب آخر',
];

const zoomIn = () => { zoomLevel.value = Math.min(zoomLevel.value + 0.25, 3); };
const zoomOut = () => { zoomLevel.value = Math.max(zoomLevel.value - 0.25, 0.5); };
const resetZoom = () => { zoomLevel.value = 1; };

const getSideBySide = (doc) => {
  if (!doc?.user_id) return { id: null, selfie: null };
  const allDocs = props.documents?.data || [];
  const userDocs = allDocs.filter(d => d.user_id === doc.user_id);
  return {
    id: userDocs.find(d => d.document_type === 'id_front' || d.document_type === 'id_card' || d.document_type === 'passport'),
    selfie: userDocs.find(d => d.document_type === 'selfie'),
  };
};

const toggleExpand = (uid) => { expandedUser.value = expandedUser.value === uid ? null : uid; };

const alertColor = (type) => {
  if (type === 'suspended' || type === 'similar_suspended') return '#ef4444';
  if (type === 'closed') return '#f59e0b';
  return '#3b82f6';
};
</script>

<template>
  <Head title="KYC Review - مراجعة طلبات التحقق" />
  <AdminLayout title="🪪 مراجعة KYC" subtitle="فحص واعتماد وثائق الهوية والتحقق من الطلبات">
    <div class="ky-root">

      <div v-if="flash.success" class="ky-success">✓ {{ flash.success }}</div>

      <!-- Stats -->
      <div class="ky-stats-row">
        <button @click="applyFilter('pending')" :class="['ky-stat-card', filter === 'pending' ? 'ky-stat-active' : '']">
          <div class="ky-stat-val" style="color:#f59e0b">{{ stats.pending }}</div>
          <div class="ky-stat-label">⏳ معلّق</div>
        </button>
        <button @click="applyFilter('approved')" :class="['ky-stat-card', filter === 'approved' ? 'ky-stat-active' : '']">
          <div class="ky-stat-val" style="color:#10b981">{{ stats.approved }}</div>
          <div class="ky-stat-label">✅ معتمد</div>
        </button>
        <button @click="applyFilter('rejected')" :class="['ky-stat-card', filter === 'rejected' ? 'ky-stat-active' : '']">
          <div class="ky-stat-val" style="color:#ef4444">{{ stats.rejected }}</div>
          <div class="ky-stat-label">❌ مرفوض</div>
        </button>
        <div class="ky-stat-card" style="border-color:#fde68a;background:#fffbeb" v-if="stats.overdue > 0">
          <div class="ky-stat-val" style="color:#dc2626">{{ stats.overdue }}</div>
          <div class="ky-stat-label">🚨 متأخر +48h</div>
        </div>
      </div>

      <!-- User Review Queue -->
      <div v-if="userQueue?.length && filter === 'pending'" class="ky-card mb-4">
        <h3 class="ky-section-title">📋 طلبات التحقق حسب العميل ({{ userQueue.length }})</h3>
        <div class="ky-queue">
          <div v-for="u in userQueue" :key="u.user_id"
            :class="['ky-queue-card', u.is_overdue ? 'ky-queue-overdue' : '', u.has_alerts ? 'ky-queue-alert' : '']"
            @click="expandedUser = u">

            <div class="ky-queue-main">
              <div class="flex items-center gap-3">
                <div class="ky-avatar-wrap">
                  <div :class="['ky-avatar', u.has_alerts ? 'ky-avatar-warn' : '']">{{ u.user_name?.charAt(0) }}</div>
                  <div v-if="u.new_since_1h > 0" class="ky-new-badge">{{ u.new_since_1h }}</div>
                </div>
                <div>
                  <div class="ky-queue-name">
                    {{ u.user_name }}
                    <span v-if="u.has_alerts" class="ky-alert-badge">⚠️ تنبيه</span>
                    <span v-if="u.new_since_1h > 0" class="ky-new-tag">🔴 جديد</span>
                  </div>
                  <div class="ky-queue-info-row">
                    <span v-if="u.country || u.nationality" class="ky-info-tag">🌍 {{ u.country || u.nationality }}</span>
                    <span v-if="u.user_phone" class="ky-info-tag">📱 {{ u.user_phone }}</span>
                    <span class="ky-info-tag">📧 {{ u.user_email }}</span>
                  </div>
                  <div class="ky-queue-meta">مسجل {{ u.registered_ago }} · {{ u.docs_count }} مستند</div>
                  <div v-if="u.last_message" class="ky-last-msg">
                    ✉️ {{ u.last_message.title }}
                  </div>
                </div>
              </div>
              <div class="flex items-center gap-3">
                <div class="ky-queue-docs">
                  <span v-for="t in u.doc_types" :key="t" class="ky-doc-tag">{{ docTypeLabels[t] || t }}</span>
                </div>
                <div :class="['ky-queue-time', u.is_overdue ? 'ky-time-overdue' : '']">⏱️ {{ u.waiting_text || u.hours_waiting + 'h' }}</div>
                <div class="ky-expand-icon">→</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Applicant Detail Modal -->
      <Teleport to="body">
        <div v-if="expandedUser" class="ky-modal-overlay" @click.self="expandedUser = null">
          <div class="ky-detail-modal">
            <!-- Header -->
            <div class="ky-detail-header">
              <div class="flex items-center gap-3">
                <div :class="['ky-avatar ky-avatar-lg', expandedUser.has_alerts ? 'ky-avatar-warn' : '']">{{ expandedUser.user_name?.charAt(0) }}</div>
                <div>
                  <h2 class="ky-detail-name">{{ expandedUser.user_name }}</h2>
                  <div class="ky-queue-info-row">
                    <span v-if="expandedUser.country || expandedUser.nationality" class="ky-info-tag">🌍 {{ expandedUser.country || expandedUser.nationality }}</span>
                    <span class="ky-info-tag">📧 {{ expandedUser.user_email }}</span>
                    <span v-if="expandedUser.user_phone" class="ky-info-tag">📱 {{ expandedUser.user_phone }}</span>
                    <span class="ky-info-tag">📅 مسجل {{ expandedUser.registered_ago }}</span>
                  </div>
                </div>
              </div>
              <button @click="expandedUser = null" class="ky-close-btn">✕</button>
            </div>

            <!-- Info Grid -->
            <div class="ky-info-grid">
              <div class="ky-info-card">
                <div class="ky-info-label">👤 الاسم الكامل</div>
                <div class="ky-info-value">{{ expandedUser.user_name || '—' }}</div>
              </div>
              <div class="ky-info-card">
                <div class="ky-info-label">📧 البريد الإلكتروني</div>
                <div class="ky-info-value">{{ expandedUser.user_email || '—' }}</div>
              </div>
              <div class="ky-info-card">
                <div class="ky-info-label">📱 الهاتف</div>
                <div class="ky-info-value">{{ expandedUser.user_phone || '—' }}</div>
              </div>
              <div class="ky-info-card">
                <div class="ky-info-label">🌍 الجنسية</div>
                <div class="ky-info-value">{{ expandedUser.nationality || '—' }}</div>
              </div>
              <div class="ky-info-card">
                <div class="ky-info-label">📍 البلد</div>
                <div class="ky-info-value">{{ expandedUser.country || '—' }}</div>
              </div>
              <div class="ky-info-card">
                <div class="ky-info-label">🏙️ المدينة</div>
                <div class="ky-info-value">{{ expandedUser.city || '—' }}</div>
              </div>
              <div class="ky-info-card">
                <div class="ky-info-label">🏠 العنوان</div>
                <div class="ky-info-value">{{ expandedUser.address || '—' }}</div>
              </div>
              <div class="ky-info-card">
                <div class="ky-info-label">🎂 تاريخ الميلاد</div>
                <div class="ky-info-value">{{ expandedUser.date_of_birth || '—' }}</div>
              </div>
              <div class="ky-info-card">
                <div class="ky-info-label">📅 تاريخ التسجيل</div>
                <div class="ky-info-value">{{ expandedUser.registered_ago }}</div>
              </div>
              <div class="ky-info-card">
                <div class="ky-info-label">🔑 آخر دخول</div>
                <div class="ky-info-value">{{ expandedUser.last_login || 'لم يسجل دخول' }}</div>
              </div>
            </div>

            <!-- Documents List -->
            <div class="ky-docs-list-section">
              <h4 class="ky-sub-title">📎 المستندات المرفقة ({{ expandedUser.docs_count }})</h4>
              <div class="ky-docs-list">
                <div v-for="doc in expandedUser.documents_detail" :key="doc.id" class="ky-doc-row">
                  <span class="ky-doc-type-icon">{{ doc.type === 'selfie' ? '🤳' : doc.type === 'passport' ? '📘' : '🪪' }}</span>
                  <span class="ky-doc-type-name">{{ docTypeLabels[doc.type] || doc.type }}</span>
                  <span class="ky-doc-created">{{ doc.created }}</span>
                  <a :href="route('admin.kyc.view', doc.id)" target="_blank" class="ky-action-btn ky-view-doc">👁️ عرض المستند</a>
                </div>
              </div>
            </div>

            <!-- Alerts -->
            <div v-if="expandedUser.duplicates?.length" class="ky-alerts-section">
              <div class="ky-alerts-title">🔍 تنبيهات أمنية</div>
              <div v-for="(alert, i) in expandedUser.duplicates" :key="i" class="ky-alert-item" :style="{borderColor: alertColor(alert.type)}">
                <span class="ky-alert-msg">{{ alert.message }}</span>
              </div>
            </div>

            <!-- Quick Actions -->
            <div class="ky-detail-actions">
              <button @click="approveAll(expandedUser.user_id); expandedUser = null" class="ky-action-btn ky-approve ky-action-lg">✅ اعتماد الكل وفتح الحساب</button>
              <button @click="msgModal = expandedUser; msgType = 'request_docs'" class="ky-action-btn ky-msg-btn">📄 طلب مستندات إضافية</button>
              <button @click="msgModal = expandedUser; msgType = 'approved'" class="ky-action-btn ky-msg-btn">📫 إرسال رسالة</button>
            </div>
          </div>
        </div>
      </Teleport>

      <!-- Rejection Modal -->
      <Teleport to="body">
        <div v-if="reviewDoc" class="ky-modal-overlay" @click.self="reviewDoc = null">
          <div class="ky-modal">
            <h3 class="ky-modal-title">❌ رفض المستند</h3>
            <p class="ky-modal-desc">العميل: <strong>{{ reviewDoc.user?.full_name }}</strong> — {{ docTypeLabels[reviewDoc.document_type] }}</p>
            <div class="ky-reason-grid">
              <button v-for="r in rejectionReasons" :key="r" @click="rejectionReason = r"
                :class="['ky-reason-btn', rejectionReason === r ? 'ky-reason-active' : '']">{{ r }}</button>
            </div>
            <textarea v-model="rejectionReason" rows="2" class="ky-modal-input mt-3" placeholder="أو اكتب سبب آخر..."></textarea>
            <div class="flex gap-3 mt-4">
              <button @click="reject(reviewDoc)" :disabled="!rejectionReason" class="ky-action-btn ky-reject flex-1">❌ تأكيد الرفض</button>
              <button @click="reviewDoc = null" class="ky-action-btn ky-cancel flex-1">إلغاء</button>
            </div>
          </div>
        </div>
      </Teleport>

      <!-- Quick Message Modal -->
      <Teleport to="body">
        <div v-if="msgModal" class="ky-modal-overlay" @click.self="msgModal = null">
          <div class="ky-modal">
            <h3 class="ky-modal-title">📫 إرسال رسالة سريعة</h3>
            <p class="ky-modal-desc">
              إلى: <strong>{{ msgModal.user_name }}</strong>
              <span class="ky-lang-badge">{{ msgModal.preferred_language === 'ar' ? '🇸🇾 عربي' : msgModal.preferred_language === 'da' ? '🇩🇰 دنماركي' : '🇬🇧 إنجليزي' }}</span>
            </p>

            <div class="ky-msg-options">
              <button @click="msgType = 'approved'" :class="['ky-msg-opt', msgType === 'approved' ? 'ky-msg-opt-active' : '']">
                ✅ وافقنا على فتح الحساب
              </button>
              <button @click="msgType = 'request_docs'" :class="['ky-msg-opt', msgType === 'request_docs' ? 'ky-msg-opt-active' : '']">
                📄 طلب مستندات إضافية
              </button>
              <button @click="msgType = 'custom'" :class="['ky-msg-opt', msgType === 'custom' ? 'ky-msg-opt-active' : '']">
                ✏️ رسالة مخصصة
              </button>
            </div>

            <!-- Doc Type Checkboxes (for request_docs) -->
            <div v-if="msgType === 'request_docs'" class="ky-doctype-section">
              <div class="ky-doctype-title">📋 حدد المستندات المطلوبة:</div>
              <div class="ky-doctype-grid">
                <label v-for="(label, key) in { id_front: '🪪 الهوية (أمام)', id_back: '🪪 الهوية (خلف)', passport: '📘 جواز السفر', selfie: '🤳 صورة شخصية', proof_of_address: '📍 إثبات عنوان' }"
                  :key="key" class="ky-doctype-item">
                  <input type="checkbox" :value="key" v-model="selectedDocTypes" class="ky-checkbox" />
                  <span>{{ label }}</span>
                </label>
              </div>
            </div>

            <textarea v-if="msgType === 'custom'" v-model="customMsg" rows="3" class="ky-modal-input mt-3" placeholder="اكتب رسالتك..."></textarea>

            <div class="flex gap-3 mt-4">
              <button @click="sendMessage(msgModal.user_id)" class="ky-action-btn ky-approve flex-1"
                :disabled="(msgType === 'custom' && !customMsg) || (msgType === 'request_docs' && !selectedDocTypes.length)">📫 إرسال</button>
              <button @click="msgModal = null" class="ky-action-btn ky-cancel flex-1">إلغاء</button>
            </div>
          </div>
        </div>
      </Teleport>

      <!-- Document Preview/Zoom Modal -->
      <Teleport to="body">
        <div v-if="previewDoc" class="ky-modal-overlay" @click.self="previewDoc = null">
          <div class="ky-preview-modal">
            <div class="ky-preview-header">
              <h3 class="ky-modal-title">🔍 {{ docTypeLabels[previewDoc.document_type] }} — {{ previewDoc.user?.full_name }}</h3>
              <div class="ky-zoom-controls">
                <button @click="zoomOut" class="ky-zoom-ctrl">➖</button>
                <span class="ky-zoom-text">{{ Math.round(zoomLevel * 100) }}%</span>
                <button @click="zoomIn" class="ky-zoom-ctrl">➕</button>
                <button @click="resetZoom" class="ky-zoom-ctrl">↻</button>
                <button @click="previewDoc = null" class="ky-zoom-ctrl ky-close">✕</button>
              </div>
            </div>

            <div class="ky-sidebyside">
              <div class="ky-side-panel">
                <div class="ky-side-label">📄 {{ docTypeLabels[previewDoc.document_type] }}</div>
                <div class="ky-img-container" :style="{transform: `scale(${zoomLevel})`}">
                  <img :src="route('admin.kyc.view', previewDoc.id)" class="ky-preview-img" />
                </div>
              </div>
              <div class="ky-side-panel" v-if="getSideBySide(previewDoc).selfie && previewDoc.document_type !== 'selfie'">
                <div class="ky-side-label">🤳 صورة شخصية (للمقارنة)</div>
                <div class="ky-img-container" :style="{transform: `scale(${zoomLevel})`}">
                  <img :src="route('admin.kyc.view', getSideBySide(previewDoc).selfie.id)" class="ky-preview-img" />
                </div>
              </div>
              <div class="ky-side-panel" v-else-if="getSideBySide(previewDoc).id && previewDoc.document_type === 'selfie'">
                <div class="ky-side-label">🪪 الهوية (للمقارنة)</div>
                <div class="ky-img-container" :style="{transform: `scale(${zoomLevel})`}">
                  <img :src="route('admin.kyc.view', getSideBySide(previewDoc).id.id)" class="ky-preview-img" />
                </div>
              </div>
            </div>

            <div v-if="previewDoc.status === 'pending'" class="ky-preview-actions">
              <button @click="approve(previewDoc); previewDoc = null" class="ky-action-btn ky-approve">✅ اعتماد</button>
              <button @click="reviewDoc = previewDoc; previewDoc = null" class="ky-action-btn ky-reject">❌ رفض</button>
            </div>
          </div>
        </div>
      </Teleport>

    </div>
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
.ky-root{direction:rtl}
.ky-success{background:#ecfdf5;color:#059669;padding:12px 16px;border-radius:12px;font-size:14px;font-weight:600;border:1px solid #a7f3d0;margin-bottom:16px}
.ky-stats-row{display:flex;gap:12px;margin-bottom:20px}
.ky-stat-card{background:#fff;border:1px solid #e2e8f0;border-radius:14px;padding:16px 24px;text-align:center;cursor:pointer;transition:all .2s;flex:1}
.ky-stat-card:hover{border-color:#10b981}
.ky-stat-active{border-color:#10b981!important;box-shadow:0 0 0 3px rgba(16,185,129,.12)}
.ky-stat-val{font-size:32px;font-weight:800}
.ky-stat-label{font-size:13px;color:#64748b;margin-top:4px;font-weight:600}

.ky-card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;padding:20px}
.ky-section-title{font-size:16px;font-weight:700;color:#0f172a;margin-bottom:14px}

/* Enhanced Queue */
.ky-queue{display:flex;flex-direction:column;gap:8px}
.ky-queue-card{border:1px solid #e2e8f0;border-radius:14px;overflow:hidden;transition:all .2s}
.ky-queue-card:hover{border-color:#cbd5e1;box-shadow:0 2px 8px rgba(0,0,0,.04)}
.ky-queue-overdue{border-color:#fecaca!important;background:#fef2f2!important}
.ky-queue-alert{border-color:#fde68a!important}
.ky-queue-main{display:flex;justify-content:space-between;align-items:center;padding:14px 16px;cursor:pointer;transition:background .15s}
.ky-queue-main:hover{background:#fafbfc}
.ky-queue-details{padding:0 16px 16px;border-top:1px solid #f1f5f9}

.ky-avatar{width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:14px;flex-shrink:0}
.ky-avatar-warn{background:linear-gradient(135deg,#f59e0b,#ef4444)!important}
.ky-avatar-sm{width:28px;height:28px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:11px;flex-shrink:0}
.ky-queue-name{font-size:14px;font-weight:600;color:#0f172a;display:flex;align-items:center;gap:6px}
.ky-queue-email{font-size:12px;color:#64748b}
.ky-queue-meta{font-size:11px;color:#94a3b8;margin-top:2px}
.ky-queue-docs{display:flex;gap:4px;flex-wrap:wrap}
.ky-doc-tag{font-size:10px;background:#f1f5f9;color:#334155;padding:2px 8px;border-radius:6px;font-weight:600}
.ky-queue-time{font-size:13px;font-weight:700;color:#334155;min-width:60px;text-align:center}
.ky-expand-icon{font-size:10px;color:#94a3b8;width:20px;text-align:center}
.ky-alert-badge{font-size:10px;background:#fef3c7;color:#d97706;padding:2px 8px;border-radius:6px;font-weight:700}

/* Alerts */
.ky-alerts-section{margin-top:12px}
.ky-alerts-title{font-size:13px;font-weight:700;color:#dc2626;margin-bottom:8px}
.ky-alert-item{display:flex;justify-content:space-between;align-items:center;padding:8px 12px;background:#fef2f2;border-radius:10px;border-right:3px solid #ef4444;margin-bottom:6px;font-size:13px}
.ky-alert-msg{color:#7f1d1d;font-weight:600}
.ky-alert-link{font-size:12px;color:#3b82f6;text-decoration:none;font-weight:600;white-space:nowrap}.ky-alert-link:hover{text-decoration:underline}

/* Doc Thumbs */
.ky-docs-grid{display:flex;gap:10px;margin-top:14px;flex-wrap:wrap}
.ky-doc-preview-card{width:140px;border:1px solid #e2e8f0;border-radius:10px;overflow:hidden}
.ky-doc-thumb{width:100%;height:90px;object-fit:cover;display:block}
.ky-doc-thumb-label{padding:5px 8px;font-size:11px;font-weight:600;color:#334155;text-align:center;background:#f8fafc}

/* Quick Actions */
.ky-quick-actions{display:flex;gap:8px;margin-top:14px;flex-wrap:wrap}
.ky-action-lg{padding:10px 20px!important;font-size:14px!important}
.ky-msg-btn{background:#eff6ff;color:#2563eb;border:1px solid #bfdbfe}.ky-msg-btn:hover{background:#2563eb;color:#fff}
.ky-info-btn{background:#f1f5f9;color:#334155;border:1px solid #e2e8f0;text-decoration:none}.ky-info-btn:hover{background:#e2e8f0}

/* Message Modal */
.ky-msg-options{display:flex;flex-direction:column;gap:6px;margin-top:12px}
.ky-msg-opt{padding:10px 14px;border:1px solid #e2e8f0;border-radius:10px;background:#fff;text-align:right;cursor:pointer;font-size:13px;font-weight:600;color:#334155;transition:all .15s}
.ky-msg-opt:hover{border-color:#10b981;background:#f0fdf4}
.ky-msg-opt-active{border-color:#10b981!important;background:#ecfdf5!important;color:#059669!important}

.ky-time-overdue{color:#dc2626!important;font-weight:800}
.ky-time-warn{color:#f59e0b}
.ky-time-ok{color:#10b981}

/* Table */
.ky-table{width:100%;border-collapse:separate;border-spacing:0}
.ky-table th{background:#f8fafc;padding:12px 14px;font-size:13px;font-weight:700;color:#334155;border-bottom:1px solid #e2e8f0;text-align:right}
.ky-table td{padding:12px 14px;border-bottom:1px solid #f1f5f9;font-size:13px;color:#334155}
.ky-row-overdue td{background:#fef2f2!important}
.ky-badge{font-size:11px;font-weight:600;padding:3px 10px;border-radius:8px}
.ky-badge-yellow{background:#fffbeb;color:#d97706}
.ky-badge-green{background:#ecfdf5;color:#059669}
.ky-badge-red{background:#fef2f2;color:#dc2626}
.ky-doc-badge{font-size:12px;background:#f1f5f9;color:#334155;padding:4px 10px;border-radius:8px;font-weight:600}
.ky-time-badge{font-size:11px;font-weight:600;padding:3px 8px;border-radius:6px}

/* Buttons */
.ky-view-btn{font-size:12px;padding:5px 10px;border-radius:8px;border:1px solid #e2e8f0;background:#fff;color:#334155;cursor:pointer;text-decoration:none;font-weight:600}.ky-view-btn:hover{border-color:#10b981;color:#10b981}
.ky-action-btn{font-size:13px;padding:7px 14px;border-radius:10px;border:none;cursor:pointer;font-weight:600;transition:all .15s}
.ky-approve{background:#ecfdf5;color:#059669}.ky-approve:hover{background:#10b981;color:#fff}
.ky-reject{background:#fef2f2;color:#dc2626}.ky-reject:hover{background:#ef4444;color:#fff}
.ky-cancel{background:#f1f5f9;color:#64748b}.ky-cancel:hover{background:#e2e8f0}

/* Modal */
.ky-modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:9999;display:flex;align-items:center;justify-content:center;backdrop-filter:blur(4px)}
.ky-modal{background:#fff;border-radius:20px;padding:28px;max-width:500px;width:90%}
.ky-modal-title{font-size:18px;font-weight:700;color:#0f172a;margin-bottom:12px}
.ky-modal-desc{font-size:14px;color:#475569;margin-bottom:16px}
.ky-modal-input{width:100%;border:1px solid #e2e8f0;border-radius:10px;padding:10px;font-size:13px;color:#0f172a;outline:none;resize:none}.ky-modal-input:focus{border-color:#10b981}

.ky-reason-grid{display:flex;flex-wrap:wrap;gap:6px}
.ky-reason-btn{font-size:12px;padding:6px 12px;border-radius:8px;border:1px solid #e2e8f0;background:#fff;color:#334155;cursor:pointer;transition:all .15s}.ky-reason-btn:hover{border-color:#ef4444;color:#ef4444}
.ky-reason-active{background:#fef2f2!important;border-color:#ef4444!important;color:#dc2626!important;font-weight:600}

/* Preview Modal */
.ky-preview-modal{background:#fff;border-radius:20px;padding:24px;max-width:900px;width:95%;max-height:90vh;overflow-y:auto}
.ky-preview-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px}
.ky-zoom-controls{display:flex;align-items:center;gap:6px}
.ky-zoom-ctrl{width:32px;height:32px;border-radius:8px;border:1px solid #e2e8f0;background:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px}.ky-zoom-ctrl:hover{border-color:#10b981;background:#ecfdf5}
.ky-close{color:#ef4444}.ky-close:hover{background:#fef2f2!important;border-color:#ef4444!important}
.ky-zoom-text{font-size:12px;font-weight:700;color:#334155;min-width:40px;text-align:center}

.ky-sidebyside{display:grid;grid-template-columns:1fr 1fr;gap:16px}
.ky-side-panel{border:1px solid #e2e8f0;border-radius:14px;overflow:hidden}
.ky-side-label{background:#f8fafc;padding:10px 14px;font-size:13px;font-weight:700;color:#334155;border-bottom:1px solid #e2e8f0}
.ky-img-container{overflow:auto;max-height:400px;display:flex;align-items:center;justify-content:center;background:#f1f5f9;transition:transform .2s;transform-origin:center}
.ky-preview-img{max-width:100%;height:auto;display:block}
.ky-preview-actions{display:flex;gap:10px;justify-content:center;margin-top:16px;padding-top:16px;border-top:1px solid #e2e8f0}

.ky-pagination{display:flex;justify-content:center;gap:4px;margin-top:16px;padding-top:16px;border-top:1px solid #f1f5f9}
.ky-page-btn{padding:6px 12px;border-radius:8px;font-size:12px;color:#334155;text-decoration:none;border:1px solid #e2e8f0}.ky-page-btn:hover{border-color:#10b981}
.ky-page-active{background:#10b981!important;color:#fff!important;border-color:#10b981!important}
.ky-page-disabled{opacity:.4;cursor:not-allowed;pointer-events:none}

/* Info Tags (summary row) */
.ky-queue-info-row{display:flex;gap:6px;flex-wrap:wrap;margin:2px 0}
.ky-info-tag{font-size:11px;background:#f1f5f9;color:#475569;padding:2px 8px;border-radius:6px;font-weight:500}

/* Info Grid (expanded) */
.ky-info-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:8px;margin-top:14px}
.ky-info-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:10px 12px}
.ky-info-label{font-size:11px;color:#94a3b8;font-weight:600;margin-bottom:3px}
.ky-info-value{font-size:13px;color:#0f172a;font-weight:600}

/* Doc Type Checkboxes */
.ky-doctype-section{margin-top:12px;padding:12px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px}
.ky-doctype-title{font-size:13px;font-weight:700;color:#334155;margin-bottom:8px}
.ky-doctype-grid{display:flex;flex-direction:column;gap:6px}
.ky-doctype-item{display:flex;align-items:center;gap:8px;padding:8px 12px;border:1px solid #e2e8f0;border-radius:8px;cursor:pointer;font-size:13px;color:#334155;font-weight:500;transition:all .15s;background:#fff}
.ky-doctype-item:hover{border-color:#10b981;background:#f0fdf4}
.ky-doctype-item:has(input:checked){border-color:#10b981;background:#ecfdf5}
.ky-checkbox{accent-color:#10b981;width:16px;height:16px}
.ky-lang-badge{font-size:11px;background:#f1f5f9;color:#475569;padding:2px 8px;border-radius:6px;margin-right:8px;font-weight:600}

/* Detail Modal */
.ky-detail-modal{background:#fff;border-radius:20px;padding:28px;max-width:750px;width:95%;max-height:90vh;overflow-y:auto}
.ky-detail-header{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:20px;padding-bottom:16px;border-bottom:1px solid #e2e8f0}
.ky-detail-name{font-size:20px;font-weight:800;color:#0f172a;margin-bottom:4px}
.ky-close-btn{width:36px;height:36px;border-radius:10px;border:1px solid #e2e8f0;background:#fff;cursor:pointer;font-size:18px;display:flex;align-items:center;justify-content:center;color:#94a3b8;transition:all .15s;flex-shrink:0}.ky-close-btn:hover{border-color:#ef4444;color:#ef4444;background:#fef2f2}
.ky-avatar-lg{width:52px!important;height:52px!important;font-size:20px!important}

/* New Docs Badge */
.ky-avatar-wrap{position:relative;flex-shrink:0}
.ky-new-badge{position:absolute;top:-4px;right:-4px;width:18px;height:18px;border-radius:50%;background:#ef4444;color:#fff;font-size:10px;font-weight:700;display:flex;align-items:center;justify-content:center;border:2px solid #fff;animation:ky-pulse 2s infinite}
.ky-new-tag{font-size:10px;background:#fef2f2;color:#dc2626;padding:1px 6px;border-radius:5px;font-weight:700;animation:ky-pulse 2s infinite}
@keyframes ky-pulse{0%,100%{opacity:1}50%{opacity:.5}}

/* Documents List */
.ky-docs-list-section{margin-top:18px;padding-top:16px;border-top:1px solid #f1f5f9}
.ky-sub-title{font-size:14px;font-weight:700;color:#334155;margin-bottom:10px}
.ky-docs-list{display:flex;flex-direction:column;gap:6px}
.ky-doc-row{display:flex;align-items:center;gap:10px;padding:10px 14px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px}
.ky-doc-type-icon{font-size:20px;flex-shrink:0}
.ky-doc-type-name{font-size:13px;font-weight:600;color:#0f172a;flex:1}
.ky-doc-created{font-size:11px;color:#94a3b8;flex-shrink:0}
.ky-view-doc{font-size:12px;padding:5px 12px;background:#ecfdf5;color:#059669;border-radius:8px;text-decoration:none;white-space:nowrap}.ky-view-doc:hover{background:#10b981;color:#fff}

/* Detail Actions */
.ky-detail-actions{display:flex;gap:10px;margin-top:18px;padding-top:16px;border-top:1px solid #f1f5f9;flex-wrap:wrap}

/* Last Message Sent */
.ky-last-msg{font-size:11px;color:#6366f1;background:#eef2ff;padding:2px 8px;border-radius:6px;margin-top:4px;font-weight:600;display:inline-block}
</style>
