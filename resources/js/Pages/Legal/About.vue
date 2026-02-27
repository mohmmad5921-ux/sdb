<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="About SDB Bank - عن البنك" />
    <div class="lg-root">
        <header class="lg-header">
            <div class="max-w-5xl mx-auto px-6 flex justify-between items-center">
                <Link href="/" class="flex items-center gap-2">
                    <img src="/images/sdb-logo.png" alt="SDB" class="h-16 w-auto" />
                </Link>
                <div class="flex gap-4">
                    <Link href="/terms" class="lg-link">الشروط والأحكام</Link>
                    <Link href="/privacy" class="lg-link">الخصوصية</Link>
                    <Link href="/faq" class="lg-link">الأسئلة الشائعة</Link>
                    <Link href="/support" class="lg-link">الدعم</Link>
                </div>
            </div>
        </header>

        <main class="max-w-4xl mx-auto px-6 py-12" style="direction:rtl">
            <!-- Hero -->
            <div class="text-center mb-12">
                <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#1E5EFF]/8 text-[#1E5EFF] text-xs font-semibold mb-4">🏦 عن SDB Bank</div>
                <h1 class="text-4xl font-black text-[#0B1F3A] mb-3">بنكك الرقمي الذكي</h1>
                <p class="text-lg text-[#0B1F3A]/60 max-w-xl mx-auto">نعيد تعريف الخدمات المصرفية من خلال التكنولوجيا المتقدمة والتصميم الذكي</p>
            </div>

            <!-- Mission -->
            <div class="ab-card ab-card-blue mb-8">
                <h2 class="text-xl font-black text-[#0B1F3A] mb-3">🎯 رسالتنا</h2>
                <p class="text-sm text-[#0B1F3A]/65 leading-7">نسعى في SDB Bank لتوفير تجربة مصرفية رقمية متكاملة تجمع بين الأمان العالي والبساطة في الاستخدام. هدفنا هو جعل الخدمات المصرفية متاحة للجميع بغض النظر عن موقعهم، وتقديم أدوات مالية ذكية تساعد عملائنا على إدارة أموالهم بكفاءة.</p>
            </div>

            <!-- Values -->
            <h2 class="text-xl font-bold text-[#0B1F3A] mb-4">💎 قيمنا الأساسية</h2>
            <div class="grid grid-cols-2 gap-4 mb-8">
                <div class="ab-card"><div class="text-3xl mb-3">🔒</div><h3 class="font-bold text-[#0B1F3A] mb-2">الأمان أولاً</h3><p class="text-sm text-[#0B1F3A]/60">نستخدم تشفير AES-256 وأحدث تقنيات المصادقة البيومترية لحماية أموال ومعلومات عملائنا على مدار الساعة.</p></div>
                <div class="ab-card"><div class="text-3xl mb-3">⚡</div><h3 class="font-bold text-[#0B1F3A] mb-2">السرعة والكفاءة</h3><p class="text-sm text-[#0B1F3A]/60">تحويلات فورية 24/7، إصدار بطاقات لحظي، وفتح حساب في دقائق معدودة.</p></div>
                <div class="ab-card"><div class="text-3xl mb-3">🌍</div><h3 class="font-bold text-[#0B1F3A] mb-2">عالمية بلا حدود</h3><p class="text-sm text-[#0B1F3A]/60">حسابات متعددة العملات (DKK, USD, EUR, GBP)، تحويلات SWIFT دولية، وبطاقات مقبولة في أكثر من 150 دولة.</p></div>
                <div class="ab-card"><div class="text-3xl mb-3">💡</div><h3 class="font-bold text-[#0B1F3A] mb-2">الابتكار المستمر</h3><p class="text-sm text-[#0B1F3A]/60">نطوّر خدماتنا باستمرار لتلبية احتياجات عملائنا المتغيرة باستخدام أحدث التقنيات المالية.</p></div>
            </div>

            <!-- Features -->
            <h2 class="text-xl font-bold text-[#0B1F3A] mb-4">🚀 ما يميزنا</h2>
            <div class="grid grid-cols-3 gap-4 mb-8">
                <div class="ab-feat"><span class="text-2xl">💳</span><div><div class="font-bold text-[#0B1F3A] text-sm">بطاقات Mastercard</div><div class="text-xs text-[#0B1F3A]/50">افتراضية وفعلية فورية</div></div></div>
                <div class="ab-feat"><span class="text-2xl">💱</span><div><div class="font-bold text-[#0B1F3A] text-sm">صرف عملات</div><div class="text-xs text-[#0B1F3A]/50">أسعار تنافسية حية</div></div></div>
                <div class="ab-feat"><span class="text-2xl">🔔</span><div><div class="font-bold text-[#0B1F3A] text-sm">إشعارات فورية</div><div class="text-xs text-[#0B1F3A]/50">لكل معاملة ونشاط</div></div></div>
                <div class="ab-feat"><span class="text-2xl">📊</span><div><div class="font-bold text-[#0B1F3A] text-sm">تحليلات مالية</div><div class="text-xs text-[#0B1F3A]/50">رؤى ذكية لإنفاقك</div></div></div>
                <div class="ab-feat"><span class="text-2xl">🪪</span><div><div class="font-bold text-[#0B1F3A] text-sm">KYC رقمي</div><div class="text-xs text-[#0B1F3A]/50">تحقق من الهوية ذكي</div></div></div>
                <div class="ab-feat"><span class="text-2xl">🎧</span><div><div class="font-bold text-[#0B1F3A] text-sm">دعم 24/7</div><div class="text-xs text-[#0B1F3A]/50">فريق متخصص دائماً</div></div></div>
            </div>

            <!-- Stats -->
            <div class="ab-stats mb-8">
                <div class="text-center"><div class="text-3xl font-black text-[#1E5EFF]">50K+</div><div class="text-xs text-[#0B1F3A]/50 mt-1">عميل نشط</div></div>
                <div class="text-center"><div class="text-3xl font-black text-[#1E5EFF]">$25M+</div><div class="text-xs text-[#0B1F3A]/50 mt-1">حجم المعاملات</div></div>
                <div class="text-center"><div class="text-3xl font-black text-[#1E5EFF]">99.9%</div><div class="text-xs text-[#0B1F3A]/50 mt-1">وقت التشغيل</div></div>
                <div class="text-center"><div class="text-3xl font-black text-[#1E5EFF]">15+</div><div class="text-xs text-[#0B1F3A]/50 mt-1">عملة مدعومة</div></div>
            </div>

            <!-- Compliance -->
            <div class="ab-card ab-card-green mb-8">
                <h2 class="text-xl font-black text-[#0B1F3A] mb-3">✅ الامتثال والتراخيص</h2>
                <ul class="space-y-2">
                    <li class="flex items-start gap-2 text-sm text-[#0B1F3A]/65"><span class="text-emerald-500 font-bold mt-0.5">✓</span> مسجّل في المملكة الدنماركية كشركة خدمات مالية</li>
                    <li class="flex items-start gap-2 text-sm text-[#0B1F3A]/65"><span class="text-emerald-500 font-bold mt-0.5">✓</span> متوافق مع معايير مكافحة غسيل الأموال الأوروبية (AML/CFT)</li>
                    <li class="flex items-start gap-2 text-sm text-[#0B1F3A]/65"><span class="text-emerald-500 font-bold mt-0.5">✓</span> معتمد بشهادة أمان المعلومات ISO 27001</li>
                    <li class="flex items-start gap-2 text-sm text-[#0B1F3A]/65"><span class="text-emerald-500 font-bold mt-0.5">✓</span> متوافق مع اللائحة العامة لحماية البيانات GDPR</li>
                    <li class="flex items-start gap-2 text-sm text-[#0B1F3A]/65"><span class="text-emerald-500 font-bold mt-0.5">✓</span> شريك رسمي مع Stripe لخدمات الدفع والإصدار</li>
                </ul>
            </div>

            <!-- Contact -->
            <div class="ab-card">
                <h2 class="text-xl font-black text-[#0B1F3A] mb-3">📬 تواصل معنا</h2>
                <div class="grid grid-cols-3 gap-4">
                    <div><div class="text-sm font-bold text-[#0B1F3A] mb-1">📧 البريد الإلكتروني</div><div class="text-xs text-[#0B1F3A]/55">info@sdb-bank.com</div></div>
                    <div><div class="text-sm font-bold text-[#0B1F3A] mb-1">📞 الهاتف</div><div class="text-xs text-[#0B1F3A]/55">+45 42 80 55 94</div></div>
                    <div><div class="text-sm font-bold text-[#0B1F3A] mb-1">📍 العنوان</div><div class="text-xs text-[#0B1F3A]/55">Wimosem 18, 4000 Roskilde, Denmark</div></div>
                </div>
            </div>
        </main>

        <footer class="lg-footer">
            <div class="max-w-4xl mx-auto px-6 flex justify-between items-center">
                <span class="text-sm text-[#0B1F3A]/40">© 2026 SDB Bank ApS. جميع الحقوق محفوظة. مسجل في الدنمارك.</span>
                <div class="flex gap-4"><Link href="/terms" class="lg-flink">الشروط</Link><Link href="/privacy" class="lg-flink">الخصوصية</Link><Link href="/support" class="lg-flink">الدعم</Link><Link href="/" class="lg-flink">الرئيسية</Link></div>
            </div>
        </footer>
    </div>
</template>

<style scoped>
.lg-root{min-height:100vh;background:#fff;font-family:'Inter',system-ui,sans-serif}
.lg-header{padding:16px 0;border-bottom:1px solid rgba(11,31,58,0.06);position:sticky;top:0;background:rgba(255,255,255,0.95);backdrop-filter:blur(10px);z-index:10}
.lg-link{font-size:13px;color:rgba(11,31,58,0.5);text-decoration:none;font-weight:500}.lg-link:hover{color:#1E5EFF}
.ab-card{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:16px;padding:24px;transition:all .3s}.ab-card:hover{border-color:rgba(30,94,255,0.15)}
.ab-card-blue{background:linear-gradient(135deg,rgba(30,94,255,0.02),rgba(0,194,255,0.02));border-color:rgba(30,94,255,0.1)}
.ab-card-green{background:rgba(16,185,129,0.02);border-color:rgba(16,185,129,0.1)}
.ab-feat{display:flex;align-items:center;gap:12px;background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:12px;padding:14px 16px;transition:all .3s}.ab-feat:hover{border-color:rgba(30,94,255,0.2);transform:translateY(-2px)}
.ab-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;background:linear-gradient(135deg,rgba(30,94,255,0.03),rgba(0,194,255,0.03));border:1.5px solid rgba(30,94,255,0.1);border-radius:16px;padding:24px}
.lg-footer{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
.lg-flink{font-size:12px;color:rgba(11,31,58,0.4);text-decoration:none}.lg-flink:hover{color:#1E5EFF}
</style>
