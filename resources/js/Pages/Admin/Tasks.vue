<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref } from 'vue';
defineOptions({ layout: AdminLayout });
const p = defineProps({ tasks: Array, admins: Array, filter: String });
const show = ref(false);
const form = useForm({title:'',description:'',assigned_to:'',priority:'medium',category:'',due_date:''});
const save = () => form.post(route('admin.tasks.store'), {onSuccess:()=>{show.value=false;form.reset()}});
const setStatus = (id,s) => router.patch(route('admin.tasks.status', id), {status:s});
const prioColor = p => ({urgent:'#ef4444',high:'#f97316',medium:'#f59e0b',low:'#10b981'}[p]||'#64748b');
const statusIcon = s => ({pending:'⏳',in_progress:'🔄',completed:'✅',cancelled:'❌'}[s]||'');
</script>
<template>
<Head title="جدولة المهام" />
<div class="tk"><div class="tk-top"><h1 class="tk-h">📅 جدولة المهام</h1><button @click="show=!show" class="tk-add">+ مهمة جديدة</button></div>
  <div v-if="show" class="tk-form">
    <div class="tk-row"><input v-model="form.title" placeholder="عنوان المهمة" class="tk-inp" style="flex:2"/><select v-model="form.priority" class="tk-inp"><option value="low">منخفض</option><option value="medium">متوسط</option><option value="high">عالي</option><option value="urgent">عاجل</option></select><select v-model="form.assigned_to" class="tk-inp"><option value="">غير محدد</option><option v-for="a in p.admins" :value="a.id">{{ a.name }}</option></select><input v-model="form.due_date" type="date" class="tk-inp"/></div>
    <textarea v-model="form.description" placeholder="الوصف" class="tk-ta" rows="2"></textarea>
    <button @click="save" class="tk-sv" :disabled="form.processing">حفظ</button>
  </div>
  <div class="tk-list">
    <div v-for="t in p.tasks" :key="t.id" class="tk-item">
      <div class="tk-prio" :style="{background:prioColor(t.priority)}"></div>
      <div class="tk-body"><div class="tk-title">{{ statusIcon(t.status) }} {{ t.title }}</div><div class="tk-meta">{{ t.assignee_name||'غير محدد' }} · {{ t.due_date?new Date(t.due_date).toLocaleDateString('ar'):'بدون موعد' }}</div></div>
      <div class="tk-acts"><button v-if="t.status!=='completed'" @click="setStatus(t.id,'completed')" class="tk-btn tk-g">✓</button><button v-if="t.status==='pending'" @click="setStatus(t.id,'in_progress')" class="tk-btn">▶</button></div>
    </div>
    <div v-if="!p.tasks.length" class="tk-empty">لا توجد مهام</div>
  </div>
</div>
</template>
<style scoped>
.tk{padding:24px;direction:rtl}.tk-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}
.tk-h{font-size:22px;font-weight:800;color:#1e293b}.tk-add{padding:10px 20px;background:#0f172a;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.tk-form{background:#fff;border-radius:14px;padding:20px;border:1px solid #f1f5f9;margin-bottom:20px}
.tk-row{display:flex;gap:10px;margin-bottom:10px}.tk-inp{padding:10px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;outline:none;flex:1}
.tk-ta{width:100%;padding:10px 12px;border:1.5px solid #e2e8f0;border-radius:10px;font-size:13px;resize:none;outline:none;margin-bottom:10px;box-sizing:border-box}
.tk-sv{padding:10px 24px;background:#10b981;color:#fff;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px}
.tk-list{display:flex;flex-direction:column;gap:8px}
.tk-item{display:flex;align-items:center;gap:12px;background:#fff;border-radius:12px;padding:14px 18px;border:1px solid #f1f5f9}
.tk-prio{width:4px;height:36px;border-radius:4px;flex-shrink:0}
.tk-body{flex:1}.tk-title{font-size:14px;font-weight:700;color:#0f172a}.tk-meta{font-size:12px;color:#94a3b8;margin-top:2px}
.tk-acts{display:flex;gap:4px}.tk-btn{width:32px;height:32px;border:1px solid #e2e8f0;border-radius:8px;background:#fff;cursor:pointer;font-size:14px;display:flex;align-items:center;justify-content:center}.tk-g{background:#ecfdf5;border-color:#a7f3d0}
.tk-empty{text-align:center;color:#cbd5e1;font-style:italic;padding:40px}
</style>
