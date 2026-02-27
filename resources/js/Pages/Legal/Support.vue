<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="الدعم - Support" />
    <div class="lg-root">
        <header class="lg-header">
            <div class="max-w-5xl mx-auto px-6 flex justify-between items-center">
                <Link href="/" class="text-xl font-black text-[#1E5EFF]">SDB</Link>
                <div class="flex gap-3">
                    <Link href="/terms" class="lg-link">الشروط والأحكام</Link>
                    <Link href="/privacy" class="lg-link">الخصوصية</Link>
                    <Link href="/about" class="lg-link">عن البنك</Link>
                    <Link href="/faq" class="lg-link">الأسئلة الشائعة</Link>
                </div>
            </div>
        </header>

        <main class="max-w-4xl mx-auto px-6 py-12" style="direction:rtl">
            <div class="text-center mb-10">
                <div class="text-4xl mb-3">🎧</div>
                <h1 class="text-3xl font-black text-[#0B1F3A] mb-2">الدعم الفني</h1>
                <p class="text-sm text-gray-400">فريقنا متاح على مدار الساعة لمساعدتك</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-10">
                <div class="sp-card">
                    <div class="sp-icon">📧</div>
                    <h3 class="sp-title">البريد الإلكتروني</h3>
                    <p class="sp-desc">أرسل لنا رسالة وسنرد خلال ساعات</p>
                    <a href="mailto:info@sdb-bank.com" class="sp-action">info@sdb-bank.com</a>
                </div>
                <div class="sp-card">
                    <div class="sp-icon">📱</div>
                    <h3 class="sp-title">الهاتف</h3>
                    <p class="sp-desc">اتصل بنا خلال ساعات العمل</p>
                    <a href="tel:+4542805594" class="sp-action">+45 42 80 55 94</a>
                </div>
                <div class="sp-card">
                    <div class="sp-icon">💬</div>
                    <h3 class="sp-title">الدعم المباشر</h3>
                    <p class="sp-desc">تحدث مع فريق الدعم مباشرة</p>
                    <Link href="/login" class="sp-action">تسجيل الدخول للمحادثة</Link>
                </div>
                <div class="sp-card">
                    <div class="sp-icon">❓</div>
                    <h3 class="sp-title">الأسئلة الشائعة</h3>
                    <p class="sp-desc">ابحث عن إجابات سريعة</p>
                    <Link href="/faq" class="sp-action">تصفح الأسئلة الشائعة</Link>
                </div>
            </div>

            <div class="sp-info">
                <h2 class="font-bold text-[#0B1F3A] text-lg mb-4">ساعات العمل</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="sp-schedule">
                        <span class="sp-day">الأحد - الخميس</span>
                        <span class="sp-time">9:00 صباحاً - 6:00 مساءً (CET)</span>
                    </div>
                    <div class="sp-schedule">
                        <span class="sp-day">الجمعة - السبت</span>
                        <span class="sp-time">10:00 صباحاً - 2:00 مساءً (CET)</span>
                    </div>
                </div>
                <p class="text-xs text-gray-400 mt-4">خدمة الطوارئ (تجميد البطاقات والحسابات) متاحة 24/7 عبر الهاتف والتطبيق</p>
            </div>

            <div class="sp-address mt-8">
                <h2 class="font-bold text-[#0B1F3A] text-lg mb-3">العنوان</h2>
                <p class="text-sm text-gray-500 leading-7">
                    SDB Bank ApS<br>
                    Wimosem 18<br>
                    4000 Roskilde<br>
                    Denmark 🇩🇰
                </p>
            </div>
        </main>

        <footer class="lg-footer">
            <div class="max-w-4xl mx-auto px-6 flex justify-between items-center">
                <span class="text-sm text-gray-400">© 2026 SDB. جميع الحقوق محفوظة.</span>
                <div class="flex gap-4">
                    <Link href="/terms" class="lg-flink">الشروط</Link>
                    <Link href="/privacy" class="lg-flink">الخصوصية</Link>
                    <Link href="/" class="lg-flink">الرئيسية</Link>
                </div>
            </div>
        </footer>
    </div>
</template>

<style scoped>
.lg-root{min-height:100vh;background:#fff;font-family:'Inter',system-ui,sans-serif}
.lg-header{padding:16px 0;border-bottom:1px solid rgba(11,31,58,0.06);position:sticky;top:0;background:rgba(255,255,255,0.95);backdrop-filter:blur(10px);z-index:10}
.lg-link{font-size:13px;color:rgba(11,31,58,0.5);text-decoration:none;font-weight:500}.lg-link:hover{color:#1E5EFF}
.sp-card{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:16px;padding:24px;text-align:center;transition:all .3s}
.sp-card:hover{border-color:rgba(30,94,255,0.2);box-shadow:0 8px 24px rgba(30,94,255,0.06);transform:translateY(-2px)}
.sp-icon{font-size:32px;margin-bottom:12px}
.sp-title{font-size:16px;font-weight:700;color:#0B1F3A;margin-bottom:6px}
.sp-desc{font-size:13px;color:rgba(11,31,58,0.45);margin-bottom:14px}
.sp-action{display:inline-block;padding:8px 16px;background:linear-gradient(135deg,#1E5EFF,#3B82F6);color:#fff;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;transition:all .3s}
.sp-action:hover{box-shadow:0 4px 12px rgba(30,94,255,0.3)}
.sp-info{background:linear-gradient(135deg,rgba(30,94,255,0.03),rgba(0,194,255,0.03));border:1.5px solid rgba(30,94,255,0.08);border-radius:18px;padding:24px}
.sp-schedule{display:flex;justify-content:space-between;padding:10px 0;border-bottom:1px solid rgba(11,31,58,0.05)}
.sp-day{font-size:14px;font-weight:600;color:#0B1F3A}
.sp-time{font-size:13px;color:rgba(11,31,58,0.5)}
.sp-address{background:#FAFBFC;border:1.5px solid rgba(11,31,58,0.05);border-radius:18px;padding:24px}
.lg-footer{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
.lg-flink{font-size:12px;color:rgba(11,31,58,0.4);text-decoration:none}.lg-flink:hover{color:#1E5EFF}
</style>
