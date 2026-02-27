<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Privacy Policy - سياسة الخصوصية" />
    <div class="lg-root">
        <header class="lg-header">
            <div class="max-w-5xl mx-auto px-6 flex justify-between items-center">
                <Link href="/" class="flex items-center gap-2">
                    <img src="/images/sdb-logo.png" alt="SDB" class="h-16 w-auto" />
                </Link>
                <div class="flex gap-3">
                    <Link href="/terms" class="lg-link">الشروط والأحكام</Link>
                    <Link href="/about" class="lg-link">عن البنك</Link>
                    <Link href="/faq" class="lg-link">الأسئلة الشائعة</Link>
                    <Link href="/support" class="lg-link">الدعم</Link>
                </div>
            </div>
        </header>

        <main class="max-w-4xl mx-auto px-6 py-12" style="direction:rtl">
            <h1 class="text-3xl font-black text-[#0B1F3A] mb-2">سياسة الخصوصية</h1>
            <p class="text-sm text-gray-400 mb-10">آخر تحديث: فبراير 2026</p>

            <div class="lg-content">
                <section class="lg-section">
                    <h2>1. التزامنا بالخصوصية</h2>
                    <p>في SDB Bank ApS، نأخذ خصوصية عملائنا على محمل الجد. توضح هذه السياسة كيفية جمع واستخدام وحماية ومشاركة معلوماتك الشخصية عند استخدام خدماتنا المصرفية.</p>
                    <p>نلتزم بأعلى معايير حماية البيانات ونتوافق مع اللائحة العامة لحماية البيانات (GDPR) والقوانين المحلية المعمول بها.</p>
                </section>

                <section class="lg-section">
                    <h2>2. البيانات التي نجمعها</h2>
                    <h3>بيانات شخصية</h3>
                    <ul>
                        <li>الاسم الكامل، تاريخ الميلاد، الجنسية</li>
                        <li>عنوان البريد الإلكتروني ورقم الهاتف</li>
                        <li>العنوان السكني ومعلومات الإقامة</li>
                        <li>وثائق الهوية (جواز السفر، الهوية الوطنية)</li>
                    </ul>
                    <h3>بيانات مالية</h3>
                    <ul>
                        <li>معلومات الحسابات المصرفية والأرصدة</li>
                        <li>سجل المعاملات والتحويلات</li>
                        <li>معلومات البطاقات المصرفية</li>
                        <li>مصادر الدخل والتوظيف</li>
                    </ul>
                    <h3>بيانات تقنية</h3>
                    <ul>
                        <li>عنوان IP ونوع المتصفح والجهاز</li>
                        <li>سجلات تسجيل الدخول والنشاط</li>
                        <li>بيانات الموقع الجغرافي (بموافقتك)</li>
                        <li>ملفات تعريف الارتباط (Cookies)</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>3. كيف نستخدم بياناتك</h2>
                    <ul>
                        <li><strong>توفير الخدمات:</strong> إدارة حسابك وتنفيذ المعاملات</li>
                        <li><strong>التحقق من الهوية:</strong> الامتثال لمتطلبات KYC ومكافحة غسيل الأموال</li>
                        <li><strong>الأمان:</strong> كشف الاحتيال ومنع النشاطات المشبوهة</li>
                        <li><strong>التحسين:</strong> تطوير وتحسين خدماتنا وتجربة المستخدم</li>
                        <li><strong>التواصل:</strong> إرسال إشعارات مهمة عن حسابك</li>
                        <li><strong>الامتثال القانوني:</strong> الاستجابة للطلبات التنظيمية والقانونية</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>4. مشاركة البيانات</h2>
                    <p>لا نبيع بياناتك الشخصية أبداً. قد نشارك بياناتك في الحالات التالية فقط:</p>
                    <ul>
                        <li><strong>مزودو الخدمات:</strong> شركات معالجة الدفع وشركاء التكنولوجيا الموثوقون</li>
                        <li><strong>الجهات التنظيمية:</strong> البنك المركزي والجهات الرقابية المختصة</li>
                        <li><strong>المتطلبات القانونية:</strong> أوامر المحكمة والطلبات القانونية الملزمة</li>
                        <li><strong>مكافحة الاحتيال:</strong> مع مؤسسات مكافحة الجرائم المالية</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>5. حماية البيانات</h2>
                    <p>نتخذ إجراءات أمنية شاملة لحماية بياناتك:</p>
                    <ul>
                        <li>تشفير TLS 256-bit لجميع البيانات أثناء النقل والتخزين</li>
                        <li>مراكز بيانات آمنة ومعتمدة بشهادة ISO 27001</li>
                        <li>مراقبة أمنية على مدار الساعة 24/7</li>
                        <li>اختبارات اختراق دورية وتدقيق أمني مستقل</li>
                        <li>صلاحيات وصول محدودة بناءً على الحاجة</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>6. حقوقك</h2>
                    <p>لديك الحقوق التالية فيما يتعلق ببياناتك الشخصية:</p>
                    <ul>
                        <li><strong>حق الوصول:</strong> طلب نسخة من بياناتك المخزنة لدينا</li>
                        <li><strong>حق التصحيح:</strong> تحديث أو تصحيح بياناتك غير الدقيقة</li>
                        <li><strong>حق الحذف:</strong> طلب حذف بياناتك (وفقاً للمتطلبات القانونية)</li>
                        <li><strong>حق النقل:</strong> الحصول على بياناتك بتنسيق قابل للقراءة</li>
                        <li><strong>حق الاعتراض:</strong> رفض استخدام بياناتك لأغراض تسويقية</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>7. ملفات تعريف الارتباط (Cookies)</h2>
                    <p>نستخدم ملفات تعريف الارتباط لتحسين تجربتك:</p>
                    <ul>
                        <li><strong>أساسية:</strong> ضرورية لعمل الموقع (تسجيل الدخول، الأمان)</li>
                        <li><strong>وظيفية:</strong> تذكر تفضيلاتك (اللغة، المنطقة الزمنية)</li>
                        <li><strong>تحليلية:</strong> فهم كيفية استخدام الخدمة لتحسينها</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>8. الاحتفاظ بالبيانات</h2>
                    <p>نحتفظ ببياناتك طالما كان حسابك نشطاً، ولمدة 5 سنوات بعد إغلاق الحساب كحد أدنى وفقاً للمتطلبات التنظيمية لمكافحة غسيل الأموال.</p>
                </section>

                <section class="lg-section">
                    <h2>9. التعديلات</h2>
                    <p>نحتفظ بحق تعديل هذه السياسة. سيتم إشعارك بأي تغييرات جوهرية عبر البريد الإلكتروني أو إشعار داخل التطبيق قبل 30 يوماً من تطبيقها.</p>
                </section>

                <section class="lg-section">
                    <h2>10. الاتصال بمسؤول حماية البيانات</h2>
                    <ul>
                        <li>البريد الإلكتروني: dpo@sdb-bank.com</li>
                        <li>العنوان: قسم حماية البيانات — SDB Bank ApS، Wimosem 18, 4000 Roskilde, Denmark</li>
                        <li>الدعم داخل التطبيق: متاح 24/7</li>
                    </ul>
                </section>
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
.lg-section{margin-bottom:32px;padding-bottom:24px;border-bottom:1px solid rgba(11,31,58,0.05)}
.lg-section:last-child{border:none}
.lg-section h2{font-size:18px;font-weight:800;color:#0B1F3A;margin-bottom:12px}
.lg-section h3{font-size:15px;font-weight:700;color:#1E5EFF;margin:12px 0 6px}
.lg-section p{font-size:14px;line-height:1.8;color:rgba(11,31,58,0.6);margin-bottom:10px}
.lg-section ul{padding-right:20px;margin:10px 0}
.lg-section li{font-size:14px;line-height:2;color:rgba(11,31,58,0.6);list-style:disc}
.lg-section li strong{color:#0B1F3A}
.lg-footer{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
.lg-flink{font-size:12px;color:rgba(11,31,58,0.4);text-decoration:none}.lg-flink:hover{color:#1E5EFF}
</style>
