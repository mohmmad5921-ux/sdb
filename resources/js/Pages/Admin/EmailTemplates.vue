<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ templates: Array });
const editing = ref({});
const edit = t => { editing.value[t.id] = {...t}; };
const save = id => { router.patch(route('admin.email-templates.update', id), editing.value[id], {onSuccess:()=>delete editing.value[id]}); };
const typeLabel = t => ({welcome:'ترحيب',alert:'تنبيه',promotion:'ترويجي',notification:'إشعار',custom:'مخصص'}[t]||t);
</script>
<template>
<Head title="قوالب البريد" />
<div class="et"><h1 class="et-h">📨 قوالب البريد الإلكتروني</h1>
  <div v-for="t in p.templates" :key="t.id" class="et-item">
    <div class="et-top"><span class="et-name">{{ t.name }}</span><span class="et-type">{{ typeLabel(t.type) }}</span><span class="et-badge" :class="t.active?'et-on':'et-off'">{{ t.active?'فعّال':'معطّل' }}</span>
      <button v-if="!editing[t.id]" @click="edit(t)" class="et-edit">✏️</button></div>
    <template v-if="editing[t.id]">
      <div class="et-row"><div class="et-col"><label>Subject EN</label><input v-model="editing[t.id].subject_en" class="et-inp"/></div><div class="et-col"><label>Subject AR</label><input v-model="editing[t.id].subject_ar" class="et-inp"/></div></div>
      <div class="et-row"><div class="et-col"><label>Body EN</label><textarea v-model="editing[t.id].body_en" class="et-ta" rows="3"></textarea></div><div class="et-col"><label>Body AR</label><textarea v-model="editing[t.id].body_ar" class="et-ta" rows="3"></textarea></div></div>
      <div class="et-acts"><button @click="save(t.id)" class="et-sv">حفظ</button><button @click="delete editing[t.id]" class="et-cn">إلغاء</button></div>
    </template>
    <template v-else><div class="et-preview"><div><strong>EN:</strong> {{ t.subject_en }}</div><div><strong>AR:</strong> {{ t.subject_ar }}</div></div></template>
  </div>
</div>
</template>
<style scoped>
.et{padding:24px;direction:rtl}.et-h{font-size:22px;font-weight:800;color:#1e293b;margin-bottom:20px}
.et-item{background:#fff;border-radius:14px;padding:20px;border:1px solid #f1f5f9;margin-bottom:12px}
.et-top{display:flex;align-items:center;gap:10px;margin-bottom:10px}.et-name{font-size:15px;font-weight:700;color:#0f172a}
.et-type{font-size:10px;font-weight:700;background:#eff6ff;color:#2563eb;padding:2px 8px;border-radius:5px}
.et-badge{font-size:10px;font-weight:700;padding:2px 8px;border-radius:5px}.et-on{background:#ecfdf5;color:#059669}.et-off{background:#fef2f2;color:#dc2626}
.et-edit{margin-right:auto;background:none;border:none;cursor:pointer;font-size:14px}
.et-row{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:10px}.et-col{display:flex;flex-direction:column;gap:4px}.et-col label{font-size:11px;font-weight:600;color:#64748b}
.et-inp{padding:10px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;outline:none}.et-ta{padding:10px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;resize:vertical;outline:none}
.et-acts{display:flex;gap:8px}.et-sv{padding:8px 18px;background:#10b981;color:#fff;border:none;border-radius:8px;font-weight:700;cursor:pointer;font-size:12px}.et-cn{padding:8px 18px;background:#f1f5f9;color:#64748b;border:none;border-radius:8px;cursor:pointer;font-size:12px}
.et-preview{font-size:13px;color:#64748b}.et-preview div{margin-bottom:2px}
</style>
