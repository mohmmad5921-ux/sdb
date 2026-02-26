<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, reactive } from 'vue';

const props = defineProps({ settings: Object });
const form = reactive({});
Object.entries(props.settings || {}).forEach(([group, items]) => items.forEach(s => { form[s.key] = s.value; }));
const saving = ref(false);
const saveSettings = () => { saving.value = true; useForm(form).post(route('admin.settings.update'), { onFinish: () => saving.value = false }); };

const groupLabels = { general: 'إعدادات عامة', fees: 'الرسوم والعمولات', exchange: 'الصرف', limits: 'الحدود', cards: 'البطاقات' };
const groupIcons = { general: '🏦', fees: '💰', exchange: '💱', limits: '📊', cards: '💳' };
const settingLabels = {
  bank_name: 'اسم البنك (EN)', bank_name_ar: 'اسم البنك (AR)', transfer_fee_percentage: 'نسبة رسوم التحويل %',
  transfer_fee_min: 'الحد الأدنى للرسوم', transfer_fee_max: 'الحد الأقصى للرسوم', exchange_spread: 'هامش الصرف %',
  daily_transfer_limit: 'حد التحويل اليومي', monthly_transfer_limit: 'حد التحويل الشهري',
  max_cards_per_user: 'أقصى عدد بطاقات لكل مستخدم', default_card_daily_limit: 'حد البطاقة اليومي الافتراضي',
};
</script>

<template>
  <Head title="Settings - الإعدادات" />
  <AuthenticatedLayout>
    <div class="st-root">
      <div class="st-header">
        <div class="max-w-5xl mx-auto px-6 py-6 flex items-center justify-between">
          <div><h1 class="text-2xl font-bold text-[#1A2B4A]">⚙️ إعدادات النظام</h1><p class="text-sm text-[#8896AB] mt-1">تكوين إعدادات البنك والرسوم والحدود</p></div>
          <Link :href="route('admin.dashboard')" class="st-back">← الرئيسية</Link>
        </div>
      </div>
      <div class="max-w-5xl mx-auto px-6 py-6">
        <form @submit.prevent="saveSettings" class="space-y-6">
          <div v-for="(items, group) in settings" :key="group" class="st-card">
            <div class="st-card-header">
              <h2 class="font-bold text-[#1A2B4A] flex items-center gap-2"><span>{{ groupIcons[group] || '📌' }}</span>{{ groupLabels[group] || group }}</h2>
            </div>
            <div class="p-6 space-y-4">
              <div v-for="s in items" :key="s.key" class="flex items-center justify-between gap-6">
                <label class="text-sm text-[#5A6B82] min-w-[200px] font-medium">{{ settingLabels[s.key] || s.key }}</label>
                <input v-model="form[s.key]" :type="['numeric','float'].includes(s.type) ? 'number' : 'text'" step="any" class="st-input" />
              </div>
            </div>
          </div>
          <button type="submit" :disabled="saving" class="st-save-btn">{{ saving ? 'جاري الحفظ...' : '💾 حفظ الإعدادات' }}</button>
        </form>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
.st-root{min-height:100vh;background:#F0F2F5;direction:rtl}
.st-header{background:linear-gradient(135deg,#fff,#F8FAFC);border-bottom:1px solid #E8ECF1}
.st-back{padding:8px 18px;background:#F0F4FF;color:#1E5EFF;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1px solid rgba(30,94,255,0.12)}.st-back:hover{background:#1E5EFF;color:#fff}
.st-card{background:#fff;border:1px solid #E8ECF1;border-radius:16px;overflow:hidden}
.st-card-header{padding:16px 24px;border-bottom:1px solid #E8ECF1;background:#FAFBFC}
.st-input{flex:1;max-width:280px;border:1px solid #E8ECF1;border-radius:12px;padding:10px 14px;font-size:13px;color:#1A2B4A;outline:none;transition:border-color .2s}.st-input:focus{border-color:#1E5EFF;box-shadow:0 0 0 3px rgba(30,94,255,0.08)}
.st-save-btn{padding:12px 32px;background:linear-gradient(135deg,#1E5EFF,#3B82F6);color:#fff;border-radius:14px;font-size:15px;font-weight:700;border:none;cursor:pointer;box-shadow:0 4px 15px rgba(30,94,255,0.25);transition:all .2s}.st-save-btn:hover{transform:translateY(-1px);box-shadow:0 6px 20px rgba(30,94,255,0.3)}.st-save-btn:disabled{opacity:0.5;transform:none}
</style>
