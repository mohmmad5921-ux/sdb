<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Terms & Conditions - الشروط والأحكام" />
    <div class="lg-root">
        <header class="lg-header">
            <div class="max-w-5xl mx-auto px-6 flex justify-between items-center">
                <Link href="/" class="text-xl font-black text-[#1E5EFF]">SDB</Link>
                <div class="flex gap-3">
                    <Link href="/privacy" class="lg-link">الخصوصية</Link>
                    <Link href="/about" class="lg-link">عن البنك</Link>
                    <Link href="/faq" class="lg-link">الأسئلة الشائعة</Link>
                </div>
            </div>
        </header>

        <main class="max-w-4xl mx-auto px-6 py-12" style="direction:rtl">
            <h1 class="text-3xl font-black text-[#0B1F3A] mb-2">الشروط والأحكام</h1>
            <p class="text-sm text-gray-400 mb-10">آخر تحديث: فبراير 2026</p>

            <div class="lg-content">
                <section class="lg-section">
                    <h2>1. مقدمة</h2>
                    <p>مرحباً بك في ShambaDigital Bank (SDB). باستخدامك لخدماتنا المصرفية الرقمية، فإنك توافق على الالتزام بهذه الشروط والأحكام. يرجى قراءتها بعناية قبل فتح حساب أو استخدام أي من خدماتنا.</p>
                    <p>SDB هو بنك رقمي مرخّص ويعمل وفقاً للقوانين واللوائح المصرفية المعمول بها. نخضع لرقابة الجهات التنظيمية المختصة ونلتزم بأعلى معايير الامتثال المالي.</p>
                </section>

                <section class="lg-section">
                    <h2>2. فتح الحساب والتسجيل</h2>
                    <p>لفتح حساب لدى SDB، يجب أن:</p>
                    <ul>
                        <li>يكون عمرك 18 عاماً على الأقل</li>
                        <li>تقدم معلومات شخصية دقيقة وصحيحة</li>
                        <li>إتمام عملية التحقق من الهوية (KYC) بنجاح</li>
                        <li>تقديم وثائق هوية سارية المفعول (جواز سفر، بطاقة هوية وطنية)</li>
                        <li>الموافقة على هذه الشروط وسياسة الخصوصية</li>
                    </ul>
                    <p>يحتفظ البنك بحق رفض أي طلب فتح حساب دون إبداء الأسباب، وفقاً لسياسات الامتثال الداخلية ومتطلبات مكافحة غسيل الأموال.</p>
                </section>

                <section class="lg-section">
                    <h2>3. الحسابات المصرفية</h2>
                    <p>يوفر SDB أنواعاً متعددة من الحسابات المصرفية:</p>
                    <ul>
                        <li><strong>حساب جاري:</strong> للإدارة اليومية للأموال والمعاملات</li>
                        <li><strong>حساب متعدد العملات:</strong> يدعم عملات متعددة بأسعار صرف تنافسية</li>
                        <li><strong>حساب توفير:</strong> بعوائد ربحية تنافسية</li>
                    </ul>
                    <p>كل حساب يحصل على رقم IBAN فريد ورقم حساب داخلي مكون من 10 أرقام.</p>
                </section>

                <section class="lg-section">
                    <h2>4. البطاقات المصرفية</h2>
                    <p>يقدم SDB بطاقات Mastercard بنوعين:</p>
                    <ul>
                        <li><strong>بطاقة افتراضية:</strong> تُصدر فوراً للاستخدام عبر الإنترنت</li>
                        <li><strong>بطاقة فعلية:</strong> تُشحن إلى عنوانك المسجل</li>
                    </ul>
                    <p>تخضع البطاقات لحدود يومية وشهرية وحدود إنفاق يمكن تعديلها من خلال التطبيق. يمكنك تجميد البطاقة مؤقتاً في أي وقت لأسباب أمنية.</p>
                </section>

                <section class="lg-section">
                    <h2>5. التحويلات والمعاملات</h2>
                    <ul>
                        <li>التحويلات الداخلية بين حسابات SDB فورية ومجانية</li>
                        <li>التحويلات الخارجية تخضع لرسوم ومواعيد معالجة محددة</li>
                        <li>صرف العملات يتم بأسعار السوق الحية مع هامش تنافسي</li>
                        <li>جميع المعاملات نهائية بعد تأكيدها ولا يمكن التراجع عنها</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>6. الرسوم والعمولات</h2>
                    <p>رسوم الخدمات المصرفية:</p>
                    <ul>
                        <li>رسوم الإيداع بالبطاقة: 1.5% + 0.50€</li>
                        <li>التحويلات الداخلية: مجاناً</li>
                        <li>إصدار بطاقة افتراضية: مجاناً</li>
                        <li>إصدار بطاقة فعلية: حسب الخطة المختارة</li>
                        <li>صرف العملات: هامش 0.5% - 2%</li>
                    </ul>
                    <p>يحق للبنك تعديل الرسوم مع إشعار العملاء مسبقاً بـ 30 يوماً على الأقل.</p>
                </section>

                <section class="lg-section">
                    <h2>7. الأمان والمسؤوليات</h2>
                    <ul>
                        <li>أنت مسؤول عن الحفاظ على سرية بيانات تسجيل الدخول</li>
                        <li>يجب إبلاغنا فوراً عن أي نشاط مشبوه على حسابك</li>
                        <li>نستخدم تشفير TLS 256-bit لحماية جميع البيانات</li>
                        <li>المصادقة الثنائية (2FA) متاحة ومُوصى بها</li>
                        <li>يحق للبنك تجميد الحساب مؤقتاً عند الاشتباه بنشاط غير مشروع</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>8. مكافحة غسيل الأموال (AML)</h2>
                    <p>يلتزم SDB بقوانين مكافحة غسيل الأموال وتمويل الإرهاب. قد نطلب:</p>
                    <ul>
                        <li>التحقق المعزّز من الهوية للمعاملات الكبيرة</li>
                        <li>معلومات إضافية عن مصدر الأموال</li>
                        <li>الإبلاغ عن المعاملات المشبوهة للجهات المختصة</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>9. إنهاء الخدمة</h2>
                    <p>يمكنك إغلاق حسابك في أي وقت بشرط تصفية جميع الالتزامات. يحتفظ البنك بحق إغلاق أي حساب يخالف هذه الشروط أو يُستخدم لأغراض غير مشروعة.</p>
                </section>

                <section class="lg-section">
                    <h2>10. القانون المطبق</h2>
                    <p>تخضع هذه الشروط للقوانين المعمول بها. في حالة أي نزاع، يتم حله عبر الوساطة أولاً، ثم التحكيم إذا لزم الأمر.</p>
                </section>

                <section class="lg-section">
                    <h2>11. الاتصال بنا</h2>
                    <p>لأي استفسارات حول هذه الشروط:</p>
                    <ul>
                        <li>البريد الإلكتروني: legal@shambank.com</li>
                        <li>الهاتف: +963-XXX-XXX-XXXX</li>
                        <li>الدعم داخل التطبيق: متاح 24/7</li>
                    </ul>
                </section>
            </div>
        </main>

        <footer class="lg-footer">
            <div class="max-w-4xl mx-auto px-6 flex justify-between items-center">
                <span class="text-sm text-gray-400">© 2026 SDB. جميع الحقوق محفوظة.</span>
                <div class="flex gap-4"><Link href="/terms" class="lg-flink">الشروط</Link><Link href="/privacy" class="lg-flink">الخصوصية</Link><Link href="/" class="lg-flink">الرئيسية</Link></div>
            </div>
        </footer>
    </div>
</template>

<style scoped>
.lg-root{min-height:100vh;background:#fff;font-family:'Inter',system-ui,sans-serif}
.lg-header{padding:16px 0;border-bottom:1px solid rgba(11,31,58,0.06);position:sticky;top:0;background:rgba(255,255,255,0.95);backdrop-filter:blur(10px);z-index:10}
.lg-link{font-size:13px;color:rgba(11,31,58,0.5);text-decoration:none;font-weight:500}.lg-link:hover{color:#1E5EFF}
.lg-content{space-y:0}
.lg-section{margin-bottom:32px;padding-bottom:24px;border-bottom:1px solid rgba(11,31,58,0.05)}
.lg-section:last-child{border:none}
.lg-section h2{font-size:18px;font-weight:800;color:#0B1F3A;margin-bottom:12px}
.lg-section p{font-size:14px;line-height:1.8;color:rgba(11,31,58,0.6);margin-bottom:10px}
.lg-section ul{padding-right:20px;margin:10px 0}
.lg-section li{font-size:14px;line-height:2;color:rgba(11,31,58,0.6);list-style:disc}
.lg-section li strong{color:#0B1F3A}
.lg-footer{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
.lg-flink{font-size:12px;color:rgba(11,31,58,0.4);text-decoration:none}.lg-flink:hover{color:#1E5EFF}
</style>
