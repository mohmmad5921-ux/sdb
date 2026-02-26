<script setup>
import GuestLayout from '@/Layouts/GuestLayout.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';

const form = useForm({
    full_name: '',
    email: '',
    phone: '',
    password: '',
    password_confirmation: '',
});

const submit = () => {
    form.post(route('register'), {
        onFinish: () => form.reset('password', 'password_confirmation'),
    });
};
</script>

<template>
    <GuestLayout>
        <Head title="Open Account - فتح حساب" />

        <form @submit.prevent="submit">
            <div>
                <InputLabel for="full_name" value="Full Name / الاسم الكامل" />
                <TextInput id="full_name" type="text" class="mt-1 block w-full" v-model="form.full_name" required autofocus autocomplete="name" />
                <InputError class="mt-2" :message="form.errors.full_name" />
            </div>

            <div class="mt-4">
                <InputLabel for="email" value="Email / البريد الإلكتروني" />
                <TextInput id="email" type="email" class="mt-1 block w-full" v-model="form.email" required autocomplete="username" />
                <InputError class="mt-2" :message="form.errors.email" />
            </div>

            <div class="mt-4">
                <InputLabel for="phone" value="Phone / رقم الهاتف" />
                <TextInput id="phone" type="tel" class="mt-1 block w-full" v-model="form.phone" autocomplete="tel" placeholder="+963..." />
                <InputError class="mt-2" :message="form.errors.phone" />
            </div>

            <div class="mt-4">
                <InputLabel for="password" value="Password / كلمة المرور" />
                <TextInput id="password" type="password" class="mt-1 block w-full" v-model="form.password" required autocomplete="new-password" />
                <InputError class="mt-2" :message="form.errors.password" />
            </div>

            <div class="mt-4">
                <InputLabel for="password_confirmation" value="Confirm Password / تأكيد كلمة المرور" />
                <TextInput id="password_confirmation" type="password" class="mt-1 block w-full" v-model="form.password_confirmation" required autocomplete="new-password" />
                <InputError class="mt-2" :message="form.errors.password_confirmation" />
            </div>

            <div class="mt-4 flex items-center justify-end">
                <Link :href="route('login')" class="rounded-md text-sm text-gray-600 underline hover:text-gray-900">
                    Already registered? / لديك حساب؟
                </Link>
                <PrimaryButton class="ms-4" :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                    Open Account / فتح حساب
                </PrimaryButton>
            </div>
        </form>
    </GuestLayout>
</template>
