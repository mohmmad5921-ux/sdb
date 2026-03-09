<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ tags: Array });
const show = ref(false);
const form = useForm({name:'',color:'#2563eb',description:''});
const save = () => form.post(route('admin.tags.store'), {onSuccess:()=>{show.value=false;form.reset()}});
</script>
<template>
<Head title="تصنيف العملاء" />
<div class="ct"><div class="ct-top"><h1 class="ct-h">🏷️ تصنيف العملاء</h1><button @click="show=!show" class="ct-add">+ تصنيف جديد</button></div>
  <div v-if="show" class="ct-form">
    <input v-model="form.name" placeholder="اسم التصنيف" class="ct-inp"/>
    <input v-model="form.color" type="color" class="ct-clr"/>
    <input v-model="form.description" placeholder="الوصف" class="ct-inp" style="flex:2"/>
    <button @click="save" class="ct-sv">حفظ</button>
  </div>
  <div class="ct-grid">
    <div v-for="tag in p.tags" :key="tag.id" class="ct-card">
      <div class="ct-dot" :style="{background:tag.color}"></div>
      <div class="ct-info"><div class="ct-name">{{ tag.name }}</div><div class="ct-desc">{{ tag.description||'—' }}</div></div>
      <div class="ct-count">{{ tag.user_count }} عميل</div>
    </div>
  </div>
</div>
</template>
<style scoped>
.ct{padding:24px;direction:rtl}.ct-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}
.ct-h{font-size:22px;font-weight:800;color:#1e293b}.ct-add{padding:10px 20px;background:#0f172a;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.ct-form{display:flex;gap:10px;align-items:center;background:#fff;border-radius:14px;padding:16px;border:1px solid #f1f5f9;margin-bottom:20px}
.ct-inp{padding:10px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;outline:none;flex:1}
.ct-clr{width:40px;height:40px;border:none;border-radius:10px;cursor:pointer;padding:0}
.ct-sv{padding:10px 18px;background:#10b981;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.ct-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
.ct-card{display:flex;align-items:center;gap:14px;background:#fff;border-radius:14px;padding:20px;border:1px solid #f1f5f9}
.ct-dot{width:14px;height:14px;border-radius:50%;flex-shrink:0}.ct-info{flex:1}.ct-name{font-size:15px;font-weight:700;color:#0f172a}.ct-desc{font-size:12px;color:#94a3b8;margin-top:2px}
.ct-count{font-size:13px;font-weight:700;color:#2563eb;background:#eff6ff;padding:6px 12px;border-radius:8px;white-space:nowrap}
</style>
