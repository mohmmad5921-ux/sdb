<script setup>
import { Head, Link, useForm, usePage, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';

const props = defineProps({ documents: Array, kycStatus: String, requiredDocuments: Array });
const page = usePage();
const flash = computed(() => page.props.flash || {});

const uploadType = ref('');
const uploadForm = useForm({ document_type: '', file: null });

const startUpload = (type) => {
    uploadType.value = type;
    uploadForm.document_type = type;
    uploadForm.file = null;
};

const onFileSelect = (e) => {
    uploadForm.file = e.target.files[0];
};

const submitUpload = () => {
    uploadForm.post(route('banking.kyc.upload'), {
        forceFormData: true,
        onSuccess: () => { uploadType.value = ''; uploadForm.reset(); },
    });
};

const deleteDoc = (id) => router.delete(route('banking.kyc.delete', id));

const getDocForType = (type) => props.documents.find(d => d.document_type === type);
const statusColors = { pending: 'bg-yellow-500/10 text-yellow-400 border-yellow-500/20', approved: 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20', rejected: 'bg-red-500/10 text-red-400 border-red-500/20' };
const statusLabels = { pending: 'قيد المراجعة', approved: 'معتمد ✓', rejected: 'مرفوض ✗' };
const kycBadge = { unverified: { class: 'bg-gray-500/10 text-gray-400', label: 'غير موثّق' }, pending: { class: 'bg-yellow-500/10 text-yellow-400', label: 'قيد المراجعة' }, verified: { class: 'bg-emerald-500/10 text-emerald-400', label: 'موثّق ✓' }, rejected: { class: 'bg-red-500/10 text-red-400', label: 'مرفوض' } };
</script>

<template>
    <Head title="KYC - التحقق من الهوية" />
    <AuthenticatedLayout>
        <div class="min-h-screen bg-[#0a0f1c] text-white">
            <div class="px-6 py-6 border-b border-white/5">
                <div class="max-w-4xl mx-auto flex items-center justify-between">
                    <div>
                        <h1 class="text-2xl font-bold">التحقق من الهوية - KYC</h1>
                        <p class="text-gray-400 text-sm mt-1">ارفع مستنداتك للتحقق من هويتك وتفعيل حسابك بالكامل</p>
                    </div>
                    <div class="flex items-center gap-3">
                        <span :class="kycBadge[kycStatus]?.class" class="px-4 py-2 rounded-xl text-sm font-semibold border border-white/5">
                            {{ kycBadge[kycStatus]?.label }}
                        </span>
                        <Link :href="route('dashboard')" class="px-4 py-2 bg-white/5 hover:bg-white/10 rounded-xl text-sm">← حسابي</Link>
                    </div>
                </div>
            </div>

            <div v-if="flash.success" class="max-w-4xl mx-auto px-6 mt-4">
                <div class="bg-emerald-500/10 border border-emerald-500/20 rounded-xl px-4 py-3 text-emerald-400 text-sm">✓ {{ flash.success }}</div>
            </div>
            <div v-if="flash.warning" class="max-w-4xl mx-auto px-6 mt-4">
                <div class="bg-amber-500/10 border border-amber-500/20 rounded-xl px-4 py-3 text-amber-400 text-sm">⚠️ {{ flash.warning }}</div>
            </div>

            <div class="max-w-4xl mx-auto px-6 py-8 space-y-6">
                <!-- KYC Status Banner -->
                <div v-if="kycStatus === 'verified'" class="bg-emerald-500/5 border border-emerald-500/10 rounded-2xl p-6 text-center">
                    <div class="text-4xl mb-3">✅</div>
                    <h3 class="text-xl font-bold text-emerald-400">تم التحقق من هويتك!</h3>
                    <p class="text-gray-400 text-sm mt-1">Your identity has been verified. All features are unlocked.</p>
                    <Link :href="route('dashboard')" class="inline-block mt-4 px-6 py-2.5 bg-emerald-600 hover:bg-emerald-500 rounded-xl text-sm font-semibold">← الذهاب للحساب المصرفي</Link>
                </div>

                <!-- MANDATORY KYC WARNING -->
                <div v-else class="bg-red-500/5 border border-red-500/20 rounded-2xl p-6">
                    <div class="flex items-start gap-4">
                        <div class="text-4xl">🔒</div>
                        <div class="flex-1">
                            <h3 class="font-bold text-lg text-red-400">التحقق من الهوية مطلوب!</h3>
                            <p class="text-gray-300 text-sm mt-1">يجب إكمال التحقق من هويتك قبل أن تتمكن من استخدام أي خدمة مصرفية. لن يتم تفعيل حسابك إلا بعد اعتماد مستنداتك.</p>
                            <p class="text-gray-400 text-xs mt-2">Identity verification is required before you can access banking features. Upload the documents below.</p>
                            <div class="flex gap-2 mt-3 text-xs text-gray-500">
                                <span class="bg-white/5 px-2 py-1 rounded">JPG, PNG, PDF</span>
                                <span class="bg-white/5 px-2 py-1 rounded">حتى 5 ميجابايت</span>
                                <span class="bg-white/5 px-2 py-1 rounded">مراجعة خلال 24 ساعة</span>
                            </div>
                        </div>
                    </div>
                    <div v-if="kycStatus === 'pending'" class="mt-4 bg-yellow-500/10 border border-yellow-500/20 rounded-xl px-4 py-3">
                        <div class="text-yellow-400 text-sm font-medium">⏳ مستنداتك قيد المراجعة — سيتم إخطارك بمجرد اعتمادها</div>
                    </div>
                </div>

                <!-- Document Cards -->
                <div class="grid md:grid-cols-2 gap-4">
                    <div v-for="req in requiredDocuments" :key="req.type"
                        class="bg-white/[0.02] border border-white/5 rounded-2xl p-5 hover:border-white/10 transition-all">
                        <div class="flex justify-between items-start mb-3">
                            <div>
                                <h4 class="font-semibold text-sm">{{ req.label }}</h4>
                                <p class="text-xs text-gray-500 mt-0.5">{{ req.label_en }}</p>
                            </div>
                            <span v-if="getDocForType(req.type)" :class="statusColors[getDocForType(req.type).status]"
                                class="text-xs px-2.5 py-1 rounded-full border">
                                {{ statusLabels[getDocForType(req.type).status] }}
                            </span>
                            <span v-else class="text-xs px-2.5 py-1 rounded-full bg-gray-500/10 text-gray-500 border border-gray-500/10">غير مرفوع</span>
                        </div>

                        <!-- Existing Document -->
                        <div v-if="getDocForType(req.type)" class="space-y-2">
                            <div class="bg-white/[0.02] rounded-xl px-3 py-2 flex items-center justify-between">
                                <div class="flex items-center gap-2 min-w-0">
                                    <span class="text-lg">📄</span>
                                    <span class="text-xs text-gray-400 truncate">{{ getDocForType(req.type).original_filename }}</span>
                                </div>
                                <div class="flex gap-2">
                                    <button v-if="getDocForType(req.type).status !== 'approved'"
                                        @click="deleteDoc(getDocForType(req.type).id)"
                                        class="text-xs text-red-400 hover:text-red-300">حذف</button>
                                </div>
                            </div>
                            <div v-if="getDocForType(req.type).status === 'rejected'" class="bg-red-500/5 border border-red-500/10 rounded-xl px-3 py-2">
                                <div class="text-xs text-red-400">❌ {{ getDocForType(req.type).rejection_reason || 'تم الرفض، يرجى إعادة الرفع' }}</div>
                            </div>
                            <button v-if="getDocForType(req.type).status === 'rejected'" @click="startUpload(req.type)"
                                class="w-full text-xs text-center text-emerald-400 hover:text-emerald-300 mt-1">↻ إعادة رفع</button>
                        </div>

                        <!-- Upload Button -->
                        <div v-else>
                            <button v-if="uploadType !== req.type" @click="startUpload(req.type)"
                                class="w-full mt-2 py-3 border-2 border-dashed border-white/10 hover:border-emerald-500/30 rounded-xl text-sm text-gray-400 hover:text-emerald-400 transition-all">
                                📎 اختر ملف للرفع
                            </button>
                        </div>

                        <!-- Upload Form -->
                        <div v-if="uploadType === req.type && (!getDocForType(req.type) || getDocForType(req.type).status === 'rejected')"
                            class="mt-3 space-y-3 bg-white/[0.02] rounded-xl p-4 border border-emerald-500/20">
                            <input type="file" @change="onFileSelect" accept=".jpg,.jpeg,.png,.pdf"
                                class="w-full text-xs text-gray-400 file:mr-3 file:py-2 file:px-4 file:rounded-lg file:border-0 file:bg-emerald-600 file:text-white file:text-xs file:cursor-pointer" />
                            <div class="flex gap-2">
                                <button @click="submitUpload" :disabled="!uploadForm.file || uploadForm.processing"
                                    class="flex-1 py-2 bg-emerald-600 hover:bg-emerald-500 rounded-lg text-xs font-semibold disabled:opacity-50">
                                    {{ uploadForm.processing ? 'جاري الرفع...' : '⬆ رفع' }}
                                </button>
                                <button @click="uploadType = ''" class="px-4 py-2 bg-white/5 rounded-lg text-xs">إلغاء</button>
                            </div>
                            <div v-if="uploadForm.errors.file" class="text-xs text-red-400">{{ uploadForm.errors.file }}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
