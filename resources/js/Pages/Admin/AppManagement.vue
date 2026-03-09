<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { ref, reactive } from 'vue';

const props = defineProps({ settings: Object });
const page = usePage();

// Flatten for form
const formData = reactive({});
Object.values(props.settings || {}).forEach(group => {
  group.forEach(s => { formData[s.key] = s.type === 'boolean' ? (s.value === '1' || s.value === 'true') : s.value; });
});

const saving = ref(false);

const save = () => {
  saving.value = true;
  const payload = {};
  Object.keys(formData).forEach(k => {
    payload[k] = typeof formData[k] === 'boolean' ? (formData[k] ? '1' : '0') : formData[k];
  });
  const form = useForm({ settings: payload });
  form.post(route('admin.app-management.update'), {
    preserveScroll: true,
    onFinish: () => { saving.value = false; },
  });
};

const groupLabels = { app: '📱 إعدادات التطبيق', features: '🎛️ تفعيل الميزات', limits: '📊 الحدود والقيود' };
const groupIcons = { app: '📱', features: '🎛️', limits: '📊' };
</script>

<template>
  <Head title="إدارة التطبيق" />
  <AdminLayout title="📱 إدارة التطبيق" subtitle="التحكم بالصيانة والتحديثات وتفعيل الميزات">

    <div v-if="page.props.flash?.success" class="am-success">✅ {{ page.props.flash.success }}</div>

    <div class="am-grid">
      <!-- App Settings -->
      <div class="am-card" v-if="settings?.app">
        <h3 class="am-card-title">📱 إعدادات التطبيق</h3>
        <div v-for="s in settings.app" :key="s.key" class="am-setting">
          <div class="am-setting-info">
            <span class="am-setting-label">{{ s.label }}</span>
            <span class="am-setting-key">{{ s.key }}</span>
          </div>
          <div v-if="s.type === 'boolean'" class="am-toggle-wrap">
            <button @click="formData[s.key] = !formData[s.key]" :class="['am-toggle', formData[s.key] ? 'am-toggle-on' : '']">
              <span class="am-toggle-dot"></span>
            </button>
            <span class="am-toggle-label">{{ formData[s.key] ? 'مفعّل' : 'معطّل' }}</span>
          </div>
          <input v-else v-model="formData[s.key]" type="text" class="am-input" />
        </div>

        <!-- Maintenance Warning -->
        <div v-if="formData.maintenance_mode" class="am-warn mt-4">
          ⚠️ وضع الصيانة مفعّل! التطبيق سيعرض رسالة الصيانة للمستخدمين.
        </div>
        <div v-if="formData.force_update" class="am-warn mt-2">
          ⚠️ التحديث الإجباري مفعّل! المستخدمون بإصدار أقل من {{ formData.min_app_version }} سيُجبرون على التحديث.
        </div>
      </div>

      <!-- Feature Flags -->
      <div class="am-card" v-if="settings?.features">
        <h3 class="am-card-title">🎛️ تفعيل الميزات</h3>
        <p class="am-desc">تفعيل أو تعطيل ميزات معينة في التطبيق</p>
        <div v-for="s in settings.features" :key="s.key" class="am-feature">
          <div class="am-feature-info">
            <span class="am-feature-icon" :class="formData[s.key] ? 'am-f-on' : 'am-f-off'">{{ formData[s.key] ? '✅' : '⛔' }}</span>
            <span class="am-feature-label">{{ s.label }}</span>
          </div>
          <button @click="formData[s.key] = !formData[s.key]" :class="['am-toggle', formData[s.key] ? 'am-toggle-on' : '']">
            <span class="am-toggle-dot"></span>
          </button>
        </div>
      </div>

      <!-- Limits -->
      <div class="am-card" v-if="settings?.limits">
        <h3 class="am-card-title">📊 الحدود والقيود</h3>
        <div v-for="s in settings.limits" :key="s.key" class="am-setting">
          <div class="am-setting-info">
            <span class="am-setting-label">{{ s.label }}</span>
            <span class="am-setting-key">{{ s.key }}</span>
          </div>
          <div class="flex items-center gap-2">
            <input v-model="formData[s.key]" type="number" class="am-input" style="width:160px" />
            <span class="am-currency">€</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Save Button -->
    <div class="am-save-bar">
      <button @click="save" :disabled="saving" class="am-save-btn">
        <span v-if="saving">⏳ جاري الحفظ...</span>
        <span v-else>💾 حفظ جميع الإعدادات</span>
      </button>
    </div>

  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
.am-success{background:#ecfdf5;color:#059669;padding:12px 16px;border-radius:12px;font-size:14px;font-weight:600;border:1px solid #a7f3d0}
.am-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(380px,1fr));gap:20px}
.am-card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;padding:24px}
.am-card-title{font-size:17px;font-weight:700;color:#0f172a;margin-bottom:16px}
.am-desc{font-size:13px;color:#64748b;margin-bottom:16px}
.am-setting{display:flex;align-items:center;justify-content:space-between;padding:14px 0;border-bottom:1px solid #f1f5f9}
.am-setting:last-child{border-bottom:none}
.am-setting-info{display:flex;flex-direction:column;gap:2px}
.am-setting-label{font-size:14px;font-weight:600;color:#0f172a}
.am-setting-key{font-size:11px;color:#94a3b8;font-family:monospace}
.am-input{padding:8px 14px;border:1px solid #e2e8f0;border-radius:10px;font-size:14px;color:#0f172a;outline:none;background:#fff}.am-input:focus{border-color:#10b981;box-shadow:0 0 0 3px rgba(16,185,129,.1)}
.am-currency{font-size:14px;color:#64748b;font-weight:600}

.am-toggle{width:48px;height:26px;border-radius:13px;background:#e2e8f0;border:none;cursor:pointer;position:relative;transition:all .2s;flex-shrink:0}
.am-toggle-on{background:#10b981}
.am-toggle-dot{position:absolute;top:3px;right:3px;width:20px;height:20px;border-radius:50%;background:#fff;transition:transform .2s;box-shadow:0 1px 3px rgba(0,0,0,.15)}
.am-toggle-on .am-toggle-dot{transform:translateX(-22px)}
.am-toggle-wrap{display:flex;align-items:center;gap:8px}
.am-toggle-label{font-size:12px;color:#64748b;font-weight:600}

.am-feature{display:flex;align-items:center;justify-content:space-between;padding:12px;border:1px solid #f1f5f9;border-radius:12px;margin-bottom:6px;transition:all .15s}
.am-feature:hover{border-color:#e2e8f0;background:#fafbfc}
.am-feature-info{display:flex;align-items:center;gap:10px}
.am-feature-icon{font-size:18px}
.am-feature-label{font-size:14px;font-weight:600;color:#334155}

.am-warn{background:#fffbeb;border:1px solid #fde68a;border-radius:10px;padding:10px 14px;font-size:13px;color:#92400e;font-weight:600}

.am-save-bar{position:sticky;bottom:20px;display:flex;justify-content:center;padding:16px 0}
.am-save-btn{padding:14px 40px;border-radius:14px;background:linear-gradient(135deg,#10b981,#059669);color:#fff;border:none;font-size:16px;font-weight:700;cursor:pointer;box-shadow:0 4px 16px rgba(16,185,129,.3);transition:all .2s}
.am-save-btn:hover{transform:translateY(-2px);box-shadow:0 6px 20px rgba(16,185,129,.4)}
.am-save-btn:disabled{opacity:.5;cursor:not-allowed;transform:none}
</style>
