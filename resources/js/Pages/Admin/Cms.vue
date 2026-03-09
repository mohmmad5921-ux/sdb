<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ sections: Object, contents: Array });
const editing = ref({});
const edit = (id, en, ar) => { editing.value[id] = {en, ar}; };
const save = id => router.patch(route('admin.cms.update', id), {value_en:editing.value[id].en, value_ar:editing.value[id].ar}, {onSuccess:()=>delete editing.value[id]});
</script>
<template>
<Head title="إدارة المحتوى" />
<div class="cm">
  <h1 class="cm-h">📝 إدارة المحتوى (CMS)</h1>

  <div v-for="(items, section) in p.sections" :key="section" class="cm-sec">
    <h2 class="cm-sec-h">{{ {landing:'الصفحة الرئيسية',system:'النظام',emails:'البريد الإلكتروني',general:'عام'}[section]||section }}</h2>
    <div v-for="item in items" :key="item.id" class="cm-item">
      <div class="cm-itop"><span class="cm-label">{{ item.label }}</span><code class="cm-key">{{ item.key }}</code></div>
      <template v-if="editing[item.id]">
        <div class="cm-row">
          <div class="cm-col"><label>English</label><textarea v-model="editing[item.id].en" class="cm-ta" rows="2"></textarea></div>
          <div class="cm-col"><label>العربية</label><textarea v-model="editing[item.id].ar" class="cm-ta" rows="2"></textarea></div>
        </div>
        <div class="cm-acts"><button @click="save(item.id)" class="cm-sv">حفظ</button><button @click="delete editing[item.id]" class="cm-cn">إلغاء</button></div>
      </template>
      <template v-else>
        <div class="cm-row">
          <div class="cm-col"><span class="cm-lang">EN</span><span class="cm-val">{{ item.value_en || '—' }}</span></div>
          <div class="cm-col"><span class="cm-lang">AR</span><span class="cm-val">{{ item.value_ar || '—' }}</span></div>
        </div>
        <button @click="edit(item.id, item.value_en, item.value_ar)" class="cm-edit">✏️ تعديل</button>
      </template>
    </div>
  </div>
</div>
</template>
<style scoped>
.cm{padding:24px;direction:rtl}.cm-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:24px}
.cm-sec{margin-bottom:28px}.cm-sec-h{font-size:16px;font-weight:700;color:#0f172a;margin-bottom:12px;padding-bottom:8px;border-bottom:2px solid #f1f5f9}
.cm-item{background:#fff;border-radius:14px;padding:20px;border:1px solid #f1f5f9;margin-bottom:12px}
.cm-itop{display:flex;align-items:center;justify-content:space-between;margin-bottom:12px}
.cm-label{font-size:14px;font-weight:700;color:#1e293b}.cm-key{font-size:11px;background:#f1f5f9;padding:2px 8px;border-radius:5px;color:#64748b}
.cm-row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.cm-col{display:flex;flex-direction:column;gap:4px}.cm-col label{font-size:11px;font-weight:600;color:#64748b}
.cm-lang{font-size:10px;font-weight:700;color:#94a3b8;background:#f8fafc;padding:2px 6px;border-radius:4px;align-self:flex-start}
.cm-val{font-size:13px;color:#475569;margin-top:4px}
.cm-ta{width:100%;padding:10px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;resize:vertical;outline:none;box-sizing:border-box}.cm-ta:focus{border-color:#2563eb}
.cm-acts{display:flex;gap:8px;margin-top:10px}
.cm-sv{padding:8px 18px;background:#10b981;color:#fff;border:none;border-radius:8px;font-weight:700;cursor:pointer;font-size:12px}
.cm-cn{padding:8px 18px;background:#f1f5f9;color:#64748b;border:none;border-radius:8px;font-weight:600;cursor:pointer;font-size:12px}
.cm-edit{margin-top:8px;padding:6px 14px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:8px;font-size:12px;cursor:pointer;color:#64748b}
</style>
