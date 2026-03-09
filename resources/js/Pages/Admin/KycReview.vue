<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ documents: Object, filters: Object, stats: Object });
const flash = computed(() => usePage().props.flash || {});
const filter = ref(props.filters?.status || 'pending');
const applyFilter = (status) => { filter.value = status; router.get(route('admin.kyc'), { status }, { preserveState: true }); };

const reviewDoc = ref(null);
const rejectionReason = ref('');
const previewDoc = ref(null);

const approve = (doc) => router.post(route('admin.kyc.review', doc.id), { action: 'approve' });
const reject = (doc) => {
  if (!rejectionReason.value.trim()) return;
  router.post(route('admin.kyc.review', doc.id), { action: 'reject', rejection_reason: rejectionReason.value });
  reviewDoc.value = null; rejectionReason.value = '';
};

const docTypeLabels = { id_front: 'هوية - أمام', id_back: 'هوية - خلف', selfie: 'صورة شخصية', proof_of_address: 'إثبات عنوان', passport: 'جواز سفر' };
const statusBadge = { pending: 'ky-badge-yellow', approved: 'ky-badge-green', rejected: 'ky-badge-red' };

// Document authenticity analysis (simulated AI-based verification)
const analyzeDocument = (doc) => {
  const checks = [];
  // Check file metadata indicators
  if (doc.mime_type && doc.mime_type.includes('image')) {
    checks.push({ label: 'نوع الملف', status: 'pass', detail: doc.mime_type });
  }
  if (doc.file_size) {
    const sizeKB = doc.file_size / 1024;
    if (sizeKB < 50) {
      checks.push({ label: 'حجم الملف', status: 'warning', detail: `${sizeKB.toFixed(0)}KB — صغير جداً (قد يكون سكرين شوت)` });
    } else if (sizeKB > 200) {
      checks.push({ label: 'حجم الملف', status: 'pass', detail: `${sizeKB.toFixed(0)}KB — حجم طبيعي لمستند أصلي` });
    } else {
      checks.push({ label: 'حجم الملف', status: 'info', detail: `${sizeKB.toFixed(0)}KB` });
    }
  }
  // Check image dimensions if available
  if (doc.image_width && doc.image_height) {
    const ratio = doc.image_width / doc.image_height;
    const isScreenRatio = (ratio > 0.5 && ratio < 0.7) || (ratio > 1.7 && ratio < 2.0); // Phone screenshot ratios
    checks.push({ label: 'أبعاد الصورة', status: isScreenRatio ? 'warning' : 'pass', detail: `${doc.image_width}×${doc.image_height} ${isScreenRatio ? '(أبعاد مشابهة لسكرين شوت)' : '(أبعاد طبيعية)'}` });
  }
  // Check original filename
  if (doc.original_filename) {
    const isScreenshot = /screenshot|screen|IMG_\d{4}/i.test(doc.original_filename);
    const isCameraPhoto = /^(IMG|DSC|DCIM|photo|P_)\d/i.test(doc.original_filename);
    checks.push({ label: 'اسم الملف', status: isScreenshot ? 'fail' : (isCameraPhoto ? 'pass' : 'info'), detail: `"${doc.original_filename}" ${isScreenshot ? '⚠️ يبدو سكرين شوت!' : isCameraPhoto ? '✅ صورة كاميرا' : ''}` });
  }
  // Overall scoring
  const fails = checks.filter(c => c.status === 'fail').length;
  const warnings = checks.filter(c => c.status === 'warning').length;
  const score = Math.max(0, 100 - (fails * 40) - (warnings * 15));
  return { checks, score, verdict: fails > 0 ? 'مشبوه' : warnings > 1 ? 'يحتاج مراجعة' : 'يبدو أصلي' };
};
</script>

<template>
  <Head title="KYC Review - مراجعة وثائق الهوية" />
  <AdminLayout title="🪪 مراجعة KYC">
    <div class="ky-root">
      <div class="ky-header">
        <div class="max-w-7xl mx-auto px-6 py-6 flex justify-between items-center">
          <div><h1 class="text-2xl font-bold text-[#0f172a]">مراجعة وثائق الهوية — KYC</h1><p class="text-sm text-[#475569] mt-1">فحص والتحقق من أصالة المستندات</p></div>
          <Link :href="route('admin.dashboard')" class="ky-back">← الرئيسية</Link>
        </div>
      </div>

      <div v-if="flash.success" class="max-w-7xl mx-auto px-6 mt-4">
        <div class="bg-emerald-50 border border-emerald-200 rounded-xl px-4 py-3 text-emerald-700 text-sm">✓ {{ flash.success }}</div>
      </div>

      <div class="max-w-7xl mx-auto px-6 py-6 space-y-6">
        <!-- Stats Filter -->
        <div class="grid grid-cols-3 gap-4">
          <button @click="applyFilter('pending')" class="ky-stat" :class="filter === 'pending' ? 'ky-stat-yellow-active' : ''">
            <div class="text-3xl font-black text-amber-600">{{ stats.pending }}</div>
            <div class="text-sm text-[#475569] mt-1">⏳ قيد المراجعة</div>
          </button>
          <button @click="applyFilter('approved')" class="ky-stat" :class="filter === 'approved' ? 'ky-stat-green-active' : ''">
            <div class="text-3xl font-black text-emerald-600">{{ stats.approved }}</div>
            <div class="text-sm text-[#475569] mt-1">✅ معتمد</div>
          </button>
          <button @click="applyFilter('rejected')" class="ky-stat" :class="filter === 'rejected' ? 'ky-stat-red-active' : ''">
            <div class="text-3xl font-black text-red-600">{{ stats.rejected }}</div>
            <div class="text-sm text-[#475569] mt-1">❌ مرفوض</div>
          </button>
        </div>

        <!-- Documents -->
        <div class="ky-card overflow-hidden">
          <div class="overflow-x-auto">
            <table class="ky-table">
              <thead><tr>
                <th>العميل</th><th>نوع المستند</th><th>الملف</th><th>فحص الأصالة</th><th class="text-center">الحالة</th><th>التاريخ</th><th class="text-center">إجراء</th>
              </tr></thead>
              <tbody>
                <tr v-for="doc in documents.data" :key="doc.id">
                  <td>
                    <div class="flex items-center gap-3">
                      <div class="ky-avatar">{{ doc.user?.full_name?.charAt(0) }}</div>
                      <div><div class="text-sm font-semibold text-[#0f172a]">{{ doc.user?.full_name }}</div><div class="text-xs text-[#475569]">{{ doc.user?.email }}</div></div>
                    </div>
                  </td>
                  <td class="text-sm text-[#334155]">{{ docTypeLabels[doc.document_type] || doc.document_type }}</td>
                  <td>
                    <a :href="route('admin.kyc.view', doc.id)" target="_blank" class="ky-file-link">📄 {{ doc.original_filename }}</a>
                  </td>
                  <td>
                    <div class="flex items-center gap-2">
                      <div class="ky-auth-score" :class="{ 'ky-auth-pass': analyzeDocument(doc).score >= 70, 'ky-auth-warn': analyzeDocument(doc).score >= 40 && analyzeDocument(doc).score < 70, 'ky-auth-fail': analyzeDocument(doc).score < 40 }">
                        {{ analyzeDocument(doc).score }}%
                      </div>
                      <span class="text-xs text-[#475569]">{{ analyzeDocument(doc).verdict }}</span>
                      <button @click="previewDoc = doc" class="text-xs text-[#1E5EFF] hover:underline">تفاصيل</button>
                    </div>
                  </td>
                  <td class="text-center"><span :class="statusBadge[doc.status]" class="ky-badge">{{ doc.status }}</span></td>
                  <td class="text-[#475569] text-xs">{{ new Date(doc.created_at).toLocaleString('en-GB') }}</td>
                  <td class="text-center">
                    <div v-if="doc.status === 'pending'" class="flex justify-center gap-1">
                      <button @click="approve(doc)" class="ky-btn-green">✓ اعتماد</button>
                      <button @click="reviewDoc = doc" class="ky-btn-red">✗ رفض</button>
                    </div>
                    <div v-else-if="doc.status === 'rejected'" class="text-xs text-red-500 max-w-[150px] truncate">{{ doc.rejection_reason }}</div>
                    <div v-else class="text-xs text-[#475569]">{{ doc.reviewer?.full_name }}</div>
                  </td>
                </tr>
                <tr v-if="!documents.data?.length"><td colspan="7" class="py-12 text-center text-[#475569]">لا توجد مستندات</td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Rejection Modal -->
      <Teleport to="body">
        <div v-if="reviewDoc" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm" @click.self="reviewDoc = null">
          <div class="bg-[#1e293b] rounded-2xl w-full max-w-md p-6 shadow-2xl border border-[#334155]" style="direction:rtl">
            <h3 class="text-lg font-bold text-[#0f172a] mb-1">رفض مستند</h3>
            <p class="text-[#475569] text-sm mb-4">{{ reviewDoc.user?.full_name }} — {{ docTypeLabels[reviewDoc.document_type] }}</p>
            <textarea v-model="rejectionReason" placeholder="سبب الرفض..." rows="3"
              class="w-full border border-[#334155] rounded-xl px-4 py-3 text-[#0f172a] outline-none focus:border-red-400 text-sm resize-none"></textarea>
            <div class="flex gap-3 mt-4">
              <button @click="reject(reviewDoc)" :disabled="!rejectionReason.trim()" class="flex-1 py-3 bg-red-500 hover:bg-red-600 text-white rounded-xl font-semibold text-sm disabled:opacity-50">✗ رفض</button>
              <button @click="reviewDoc = null" class="flex-1 py-3 bg-gray-200 text-gray-700 rounded-xl text-sm">إلغاء</button>
            </div>
          </div>
        </div>
      </Teleport>

      <!-- Document Analysis Modal -->
      <Teleport to="body">
        <div v-if="previewDoc" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm" @click.self="previewDoc = null">
          <div class="bg-[#1e293b] rounded-2xl w-full max-w-lg p-6 shadow-2xl border border-[#334155]" style="direction:rtl">
            <h3 class="text-lg font-bold text-[#0f172a] mb-1">🔍 تقرير فحص أصالة المستند</h3>
            <p class="text-[#475569] text-sm mb-4">{{ previewDoc.user?.full_name }} — {{ docTypeLabels[previewDoc.document_type] }}</p>

            <div class="text-center mb-4">
              <div class="inline-flex items-center gap-3 px-6 py-3 rounded-2xl" :class="{'bg-emerald-50 border-emerald-200': analyzeDocument(previewDoc).score >= 70, 'bg-amber-50 border-amber-200': analyzeDocument(previewDoc).score >= 40 && analyzeDocument(previewDoc).score < 70, 'bg-red-50 border-red-200': analyzeDocument(previewDoc).score < 40}" style="border-width:1px">
                <span class="text-3xl font-black" :class="{'text-emerald-600': analyzeDocument(previewDoc).score >= 70, 'text-amber-600': analyzeDocument(previewDoc).score >= 40 && analyzeDocument(previewDoc).score < 70, 'text-red-600': analyzeDocument(previewDoc).score < 40}">{{ analyzeDocument(previewDoc).score }}%</span>
                <span class="text-sm font-semibold" :class="{'text-emerald-700': analyzeDocument(previewDoc).score >= 70, 'text-amber-700': analyzeDocument(previewDoc).score >= 40 && analyzeDocument(previewDoc).score < 70, 'text-red-700': analyzeDocument(previewDoc).score < 40}">{{ analyzeDocument(previewDoc).verdict }}</span>
              </div>
            </div>

            <div class="space-y-2">
              <div v-for="(check, i) in analyzeDocument(previewDoc).checks" :key="i" class="flex items-center gap-3 p-3 rounded-xl" :class="{'bg-emerald-50': check.status === 'pass', 'bg-amber-50': check.status === 'warning', 'bg-red-50': check.status === 'fail', 'bg-gray-50': check.status === 'info'}">
                <span v-if="check.status === 'pass'" class="text-emerald-500">✅</span>
                <span v-else-if="check.status === 'warning'" class="text-amber-500">⚠️</span>
                <span v-else-if="check.status === 'fail'" class="text-red-500">❌</span>
                <span v-else class="text-blue-500">ℹ️</span>
                <div>
                  <div class="text-sm font-semibold text-[#0f172a]">{{ check.label }}</div>
                  <div class="text-xs text-[#475569]">{{ check.detail }}</div>
                </div>
              </div>
            </div>

            <div class="mt-4 p-3 bg-blue-50 border border-blue-200 rounded-xl text-xs text-blue-700">
              💡 <strong>ملاحظة:</strong> يتم فحص الملف تلقائياً بناءً على حجم الصورة وأبعادها واسم الملف. سكرين شوت عادة تكون بحجم صغير وأبعاد شاشة الهاتف.
            </div>

            <button @click="previewDoc = null" class="w-full mt-4 py-3 bg-gray-200 text-gray-700 rounded-xl text-sm">إغلاق</button>
          </div>
        </div>
      </Teleport>
    </div>
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
@import '../../../css/admin.css';
.ky-root{min-height:100vh;background:#f1f5f9;direction:rtl}
.ky-header{background:#ffffff;border-bottom:1px solid #e2e8f0}
.ky-back{padding:8px 18px;background:#ffffff;color:#3b82f6;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(16,185,129,0.2)}.ky-back:hover{background:#10b981;color:#fff}
.ky-stat{background:#ffffff;border:2px solid #E8ECF1;border-radius:16px;padding:20px;text-align:center;cursor:pointer;transition:all .2s}.ky-stat:hover{border-color:#10b981}.ky-stat-yellow-active{border-color:#f59e0b;background:rgba(245,158,11,0.03)}.ky-stat-green-active{border-color:#10b981;background:rgba(16,185,129,0.03)}.ky-stat-red-active{border-color:#ef4444;background:rgba(239,68,68,0.03)}
.ky-card{background:#ffffff;border:1px solid #e2e8f0;border-radius:16px}
.ky-table{width:100%;border-collapse:collapse;font-size:13px}
.ky-table th{text-align:right;padding:12px 16px;background:#ffffff;color:#64748b;font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #e2e8f0}
.ky-table td{padding:12px 16px;border-bottom:1px solid #f1f5f9;vertical-align:middle}
.ky-table tr:hover td{background:#ffffff}
.ky-avatar{width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,#3b82f6,#1d4ed8);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:13px;flex-shrink:0}
.ky-badge{font-size:11px;padding:2px 10px;border-radius:100px;font-weight:600}
.ky-badge-green{background:rgba(16,185,129,0.1);color:#059669}.ky-badge-yellow{background:rgba(245,158,11,0.1);color:#d97706}.ky-badge-red{background:rgba(239,68,68,0.1);color:#dc2626}
.ky-file-link{font-size:12px;color:#3b82f6;text-decoration:none;display:flex;align-items:center;gap:4px}.ky-file-link:hover{text-decoration:underline}
.ky-auth-score{font-size:11px;font-weight:700;padding:2px 8px;border-radius:8px}
.ky-auth-pass{background:rgba(16,185,129,0.1);color:#059669}.ky-auth-warn{background:rgba(245,158,11,0.1);color:#d97706}.ky-auth-fail{background:rgba(239,68,68,0.1);color:#dc2626}
.ky-btn-green{font-size:11px;padding:5px 12px;background:#10b981;color:#fff;border-radius:8px;font-weight:600;cursor:pointer;border:none;transition:background .2s}.ky-btn-green:hover{background:#059669}
.ky-btn-red{font-size:11px;padding:5px 12px;background:#ef4444;color:#fff;border-radius:8px;font-weight:600;cursor:pointer;border:none;transition:background .2s}.ky-btn-red:hover{background:#dc2626}
</style>
