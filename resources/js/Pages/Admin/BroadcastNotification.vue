<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ stats: Object });
const page = usePage();

const form = useForm({
  title: '',
  message: '',
  target: 'all',
});

const showPreview = ref(false);
const sending = ref(false);

const targetLabels = { all: 'جميع العملاء', active: 'العملاء النشطون فقط', verified: 'العملاء الموثّقون (KYC)' };
const targetCount = computed(() => props.stats?.[form.target] || 0);

const templates = [
  { title: '🔧 صيانة النظام', message: 'سيتم إجراء صيانة دورية على النظام. قد يتأثر بعض الخدمات مؤقتاً. نعتذر عن أي إزعاج.' },
  { title: '🎉 تحديث جديد', message: 'تم إطلاق تحديث جديد يتضمن تحسينات على الأداء وميزات جديدة. قم بتحديث التطبيق للاستفادة من أحدث الميزات.' },
  { title: '🎁 عرض خاص', message: 'عرض حصري لعملائنا! لا تفوت الفرصة. تواصل معنا لمزيد من التفاصيل.' },
  { title: '📢 إعلان هام', message: '' },
];

const applyTemplate = (t) => {
  form.title = t.title;
  form.message = t.message;
};

const send = () => {
  sending.value = true;
  form.post(route('admin.broadcast.send'), {
    preserveScroll: true,
    onFinish: () => { sending.value = false; showPreview.value = false; },
    onSuccess: () => { form.reset(); },
  });
};
</script>

<template>
  <Head title="إشعارات جماعية - Broadcast" />
  <AdminLayout title="📢 إشعارات جماعية">
    <div class="bn-root">
      <div class="bn-header">
        <div class="max-w-4xl mx-auto px-6 py-6 flex items-center justify-between">
          <div><h1 class="text-2xl font-bold text-[#0f172a]">📢 إشعارات جماعية</h1><p class="text-sm text-[#475569] mt-1">أرسل إشعاراً لجميع عملائك أو مجموعة محددة</p></div>
          <Link :href="route('admin.dashboard')" class="bn-back">← الرئيسية</Link>
        </div>
      </div>

      <div class="max-w-4xl mx-auto px-6 py-6">
        <!-- Success message -->
        <div v-if="page.props.flash?.success" class="bn-success mb-4">✅ {{ page.props.flash.success }}</div>

        <!-- Stats row -->
        <div class="bn-stats-row mb-6">
          <div class="bn-stat-mini"><span class="bn-stat-num">{{ stats.all }}</span><span class="bn-stat-txt">كل العملاء</span></div>
          <div class="bn-stat-mini"><span class="bn-stat-num" style="color:#10b981">{{ stats.active }}</span><span class="bn-stat-txt">نشط</span></div>
          <div class="bn-stat-mini"><span class="bn-stat-num" style="color:#3b82f6">{{ stats.verified }}</span><span class="bn-stat-txt">موثّق</span></div>
        </div>

        <div class="grid grid-cols-3 gap-6">
          <!-- Form -->
          <div class="col-span-2">
            <div class="bn-card">
              <h3 class="bn-card-title">✉️ تكوين الإشعار</h3>

              <div class="bn-field">
                <label class="bn-label">الفئة المستهدفة</label>
                <div class="bn-target-grid">
                  <button v-for="(label, key) in targetLabels" :key="key" @click="form.target = key"
                    :class="['bn-target-btn', form.target === key ? 'bn-target-active' : '']">
                    <span>{{ label }}</span>
                    <span class="bn-target-count">{{ stats[key] }}</span>
                  </button>
                </div>
              </div>

              <div class="bn-field">
                <label class="bn-label">عنوان الإشعار</label>
                <input v-model="form.title" type="text" class="bn-input" placeholder="مثال: تحديث جديد..." />
                <div v-if="form.errors.title" class="bn-error">{{ form.errors.title }}</div>
              </div>

              <div class="bn-field">
                <label class="bn-label">نص الرسالة</label>
                <textarea v-model="form.message" rows="5" class="bn-input bn-textarea" placeholder="اكتب رسالتك هنا..."></textarea>
                <div class="bn-char-count">{{ form.message.length }} / 2000</div>
                <div v-if="form.errors.message" class="bn-error">{{ form.errors.message }}</div>
              </div>

              <div class="flex gap-3 mt-4">
                <button @click="showPreview = true" :disabled="!form.title || !form.message" class="bn-preview-btn">👁️ معاينة</button>
                <button @click="send" :disabled="!form.title || !form.message || sending" class="bn-send-btn">
                  <span v-if="sending">⏳ جاري الإرسال...</span>
                  <span v-else>📤 إرسال إلى {{ targetCount }} عميل</span>
                </button>
              </div>
            </div>
          </div>

          <!-- Templates -->
          <div>
            <div class="bn-card">
              <h3 class="bn-card-title">📋 قوالب جاهزة</h3>
              <div v-for="(t, i) in templates" :key="i" class="bn-template" @click="applyTemplate(t)">
                <div class="bn-template-title">{{ t.title }}</div>
                <div class="bn-template-preview" v-if="t.message">{{ t.message.substring(0, 60) }}...</div>
                <div class="bn-template-preview" v-else>قالب فارغ — أضف رسالتك</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Preview Modal -->
        <div v-if="showPreview" class="bn-modal-overlay" @click.self="showPreview = false">
          <div class="bn-modal">
            <h3 class="bn-modal-title">👁️ معاينة الإشعار</h3>
            <div class="bn-preview-card">
              <div class="bn-preview-icon">🔔</div>
              <div class="bn-preview-title">{{ form.title }}</div>
              <div class="bn-preview-msg">{{ form.message }}</div>
              <div class="bn-preview-meta">سيتم إرساله إلى <strong>{{ targetCount }}</strong> عميل — {{ targetLabels[form.target] }}</div>
            </div>
            <div class="flex gap-3 mt-4 justify-end">
              <button @click="showPreview = false" class="bn-cancel-btn">إلغاء</button>
              <button @click="send" :disabled="sending" class="bn-send-btn">
                <span v-if="sending">⏳ جاري الإرسال...</span>
                <span v-else>📤 تأكيد الإرسال</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
.bn-root{min-height:100vh;background:#f1f5f9;direction:rtl}
.bn-header{background:#ffffff;border-bottom:1px solid #e2e8f0}
.bn-back{padding:8px 18px;background:#ffffff;color:#3b82f6;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(16,185,129,0.2)}.bn-back:hover{background:#10b981;color:#fff}
.bn-success{background:#ecfdf5;color:#059669;padding:12px 16px;border-radius:12px;font-size:14px;font-weight:600;border:1px solid #a7f3d0}
.bn-stats-row{display:flex;gap:12px}
.bn-stat-mini{background:#ffffff;border:1px solid #e2e8f0;border-radius:12px;padding:12px 20px;display:flex;align-items:center;gap:8px;flex:1}
.bn-stat-num{font-size:20px;font-weight:700;color:#0f172a}
.bn-stat-txt{font-size:12px;color:#64748b}
.bn-card{background:#ffffff;border:1px solid #e2e8f0;border-radius:16px;padding:24px}
.bn-card-title{font-size:16px;font-weight:700;color:#0f172a;margin-bottom:20px}
.bn-field{margin-bottom:16px}
.bn-label{display:block;font-size:13px;font-weight:600;color:#334155;margin-bottom:6px}
.bn-input{width:100%;padding:12px 16px;border:1px solid #e2e8f0;border-radius:12px;font-size:14px;color:#0f172a;outline:none;background:#ffffff}.bn-input:focus{border-color:#10b981;box-shadow:0 0 0 3px rgba(16,185,129,0.1)}
.bn-textarea{resize:vertical;min-height:120px;font-family:inherit}
.bn-char-count{text-align:left;font-size:11px;color:#94a3b8;margin-top:4px}
.bn-error{color:#ef4444;font-size:12px;margin-top:4px}

.bn-target-grid{display:flex;gap:8px;flex-wrap:wrap}
.bn-target-btn{padding:10px 16px;border:1px solid #e2e8f0;border-radius:10px;background:#ffffff;cursor:pointer;display:flex;align-items:center;gap:8px;font-size:13px;color:#334155;transition:all .2s}.bn-target-btn:hover{border-color:#10b981}
.bn-target-active{background:#ecfdf5!important;border-color:#10b981!important;color:#059669!important;font-weight:600}
.bn-target-count{font-size:11px;background:#f1f5f9;padding:2px 8px;border-radius:6px;font-weight:700}

.bn-template{padding:12px;border:1px solid #e2e8f0;border-radius:10px;cursor:pointer;margin-bottom:8px;transition:all .2s}.bn-template:hover{border-color:#3b82f6;background:#f8fafc}
.bn-template-title{font-size:13px;font-weight:600;color:#0f172a}
.bn-template-preview{font-size:11px;color:#64748b;margin-top:4px}

.bn-preview-btn{padding:10px 20px;border-radius:10px;background:#ffffff;color:#334155;border:1px solid #e2e8f0;font-size:14px;font-weight:600;cursor:pointer}.bn-preview-btn:hover{border-color:#3b82f6;color:#3b82f6}.bn-preview-btn:disabled{opacity:0.4;cursor:not-allowed}
.bn-send-btn{padding:10px 24px;border-radius:10px;background:#10b981;color:#fff;border:none;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s}.bn-send-btn:hover{background:#059669}.bn-send-btn:disabled{opacity:0.5;cursor:not-allowed}
.bn-cancel-btn{padding:10px 20px;border-radius:10px;background:#f1f5f9;color:#475569;border:none;font-size:14px;cursor:pointer}.bn-cancel-btn:hover{background:#e2e8f0}

.bn-modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;display:flex;align-items:center;justify-content:center}
.bn-modal{background:#ffffff;border-radius:20px;padding:28px;max-width:500px;width:90%;max-height:90vh;overflow-y:auto}
.bn-modal-title{font-size:18px;font-weight:700;color:#0f172a;margin-bottom:16px}
.bn-preview-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:14px;padding:20px;text-align:center}
.bn-preview-icon{font-size:40px;margin-bottom:8px}
.bn-preview-title{font-size:16px;font-weight:700;color:#0f172a;margin-bottom:8px}
.bn-preview-msg{font-size:14px;color:#475569;line-height:1.6}
.bn-preview-meta{font-size:12px;color:#94a3b8;margin-top:12px;padding-top:12px;border-top:1px solid #e2e8f0}
</style>
