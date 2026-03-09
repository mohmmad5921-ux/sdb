<script setup>
import { Head } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';

const props = defineProps({ services: Array, systemInfo: Object });
const statusColors = { online: '#10b981', offline: '#ef4444', error: '#ef4444', warning: '#f59e0b', configured: '#10b981', unknown: '#94a3b8' };
const statusLabels = { online: 'متصل ✅', offline: 'غير متصل ❌', error: 'خطأ ⚠️', warning: 'تحذير ⚠️', configured: 'مُعد ✅', unknown: 'غير معروف' };
</script>

<template>
  <Head title="حالة الخدمات" />
  <AdminLayout title="🌐 حالة الخدمات و API" subtitle="مراقبة حالة الاتصال بالخدمات الخارجية">

    <div class="api-services">
      <div v-for="s in services" :key="s.name" class="api-card">
        <div class="api-card-head">
          <div class="flex items-center gap-3">
            <span class="api-icon">{{ s.icon }}</span>
            <div>
              <div class="api-name">{{ s.name }}</div>
              <div class="api-detail">{{ s.details }}</div>
            </div>
          </div>
          <div class="api-status-wrap">
            <span class="api-status-dot" :style="{background: statusColors[s.status]}"></span>
            <span class="api-status-text" :style="{color: statusColors[s.status]}">{{ statusLabels[s.status] }}</span>
          </div>
        </div>
        <div class="api-card-footer">
          <span v-if="s.response_time">⚡ {{ s.response_time }}ms</span>
          <span>🕐 آخر فحص: الآن</span>
        </div>
      </div>
    </div>

    <!-- System Info -->
    <div class="api-sys-card">
      <h3 class="api-sys-title">⚙️ معلومات النظام</h3>
      <div class="api-sys-grid">
        <div class="api-sys-item"><span class="api-sys-key">PHP</span><span class="api-sys-val">{{ systemInfo?.php_version }}</span></div>
        <div class="api-sys-item"><span class="api-sys-key">Laravel</span><span class="api-sys-val">{{ systemInfo?.laravel_version }}</span></div>
        <div class="api-sys-item"><span class="api-sys-key">البيئة</span><span class="api-sys-val">{{ systemInfo?.env }}</span></div>
        <div class="api-sys-item"><span class="api-sys-key">المنطقة الزمنية</span><span class="api-sys-val">{{ systemInfo?.timezone }}</span></div>
        <div class="api-sys-item"><span class="api-sys-key">وضع التصحيح</span><span class="api-sys-val">{{ systemInfo?.debug ? 'مفعّل ⚠️' : 'معطّل ✅' }}</span></div>
        <div class="api-sys-item"><span class="api-sys-key">وقت الخادم</span><span class="api-sys-val">{{ systemInfo?.server_time }}</span></div>
      </div>
    </div>
  </AdminLayout>
</template>

<style>
@import '../../../css/admin.css';
.api-services{display:grid;grid-template-columns:repeat(auto-fit,minmax(340px,1fr));gap:16px;margin-bottom:20px}
.api-card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;padding:20px;transition:all .15s}
.api-card:hover{border-color:#cbd5e1;box-shadow:0 2px 8px rgba(0,0,0,.04)}
.api-card-head{display:flex;justify-content:space-between;align-items:center}
.api-icon{font-size:28px}
.api-name{font-size:15px;font-weight:700;color:#0f172a}
.api-detail{font-size:12px;color:#64748b;margin-top:2px;max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.api-status-wrap{display:flex;align-items:center;gap:6px}
.api-status-dot{width:10px;height:10px;border-radius:50%;animation:pulse 2s infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.5}}
.api-status-text{font-size:13px;font-weight:700}
.api-card-footer{display:flex;justify-content:space-between;margin-top:14px;padding-top:12px;border-top:1px solid #f1f5f9;font-size:12px;color:#94a3b8}
.api-sys-card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;padding:24px}
.api-sys-title{font-size:16px;font-weight:700;color:#0f172a;margin-bottom:16px}
.api-sys-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:12px}
.api-sys-item{display:flex;justify-content:space-between;padding:10px 14px;background:#f8fafc;border-radius:10px}
.api-sys-key{font-size:13px;font-weight:600;color:#64748b}
.api-sys-val{font-size:13px;font-weight:700;color:#0f172a;font-family:monospace}
</style>
