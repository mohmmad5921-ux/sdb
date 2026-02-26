<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref } from 'vue';

const openFaq = ref(null);
const toggle = (i) => openFaq.value = openFaq.value === i ? null : i;

const faqs = [
  { cat: '🏦 الحساب', items: [
    { q: 'كيف أفتح حساب في SDB؟', a: 'يمكنك فتح حساب خلال دقائق من خلال التسجيل على الموقع أو التطبيق. ستحتاج لتقديم بياناتك الشخصية ووثيقة هوية سارية المفعول، ثم إتمام عملية التحقق من الهوية (KYC).' },
    { q: 'ما هي الوثائق المطلوبة لفتح حساب؟', a: 'تحتاج إلى جواز سفر ساري المفعول أو بطاقة هوية وطنية، بالإضافة إلى إثبات عنوان حديث (كشف حساب بنكي، فاتورة خدمات، أو عقد إيجار صادر خلال آخر 3 أشهر).' },
    { q: 'هل يمكنني فتح أكثر من حساب واحد؟', a: 'نعم! يمكنك فتح حسابات بعملات مختلفة. كل حساب يحصل على رقم IBAN فريد ورقم حساب داخلي مكون من 10 أرقام.' },
    { q: 'ما هو رقم العميل؟', a: 'رقم العميل هو رقم مكون من 10 أرقام يُمنح لك عند فتح الحساب. هو معرّفك الفريد في نظامنا ويمكنك استخدامه للتعريف عن نفسك عند التواصل مع خدمة العملاء.' },
  ]},
  { cat: '💳 البطاقات', items: [
    { q: 'كيف أحصل على بطاقة SDB Mastercard؟', a: 'يمكنك إصدار بطاقة افتراضية فوراً من لوحة التحكم. البطاقة الافتراضية تعمل للمشتريات عبر الإنترنت والدفع عبر Apple Pay و Google Pay. البطاقات الفعلية تُشحن إلى عنوانك خلال 5-7 أيام عمل.' },
    { q: 'ما الفرق بين البطاقة الافتراضية والفعلية؟', a: 'البطاقة الافتراضية تُصدر فوراً وتُستخدم للمشتريات الإلكترونية فقط. البطاقة الفعلية هي بطاقة بلاستيكية تصل لعنوانك ويمكن استخدامها في المتاجر وأجهزة الصراف الآلي بالإضافة للمشتريات الإلكترونية.' },
    { q: 'كيف أجمّد بطاقتي؟', a: 'يمكنك تجميد البطاقة فوراً من التطبيق بضغطة واحدة. التجميد يمنع جميع المعاملات ويمكنك إلغاء التجميد بنفس السهولة في أي وقت.' },
    { q: 'ما هي حدود البطاقة؟', a: 'تختلف الحدود حسب خطتك. الحد اليومي الأساسي هو 5,000€ والشهري 25,000€. يمكنك تعديل الحدود من صفحة إدارة البطاقة أو التواصل مع الدعم لرفع الحدود.' },
  ]},
  { cat: '💸 التحويلات', items: [
    { q: 'كم تستغرق التحويلات؟', a: 'التحويلات الداخلية بين حسابات SDB فورية ومجانية. التحويلات الخارجية (SWIFT) تستغرق 1-3 أيام عمل حسب بنك المستلم.' },
    { q: 'هل هناك رسوم على التحويلات؟', a: 'التحويلات الداخلية مجانية تماماً. التحويلات الخارجية تخضع لرسوم تبدأ من 2€ حسب الوجهة والعملة.' },
    { q: 'كيف أعمل صرف عملات؟', a: 'من لوحة التحكم، اضغط على "صرف عملات"، اختر الحساب المصدر والحساب الهدف (بعملة مختلفة)، أدخل المبلغ وسيتم الصرف بسعر السوق الحي مع هامش تنافسي.' },
  ]},
  { cat: '💰 الإيداع', items: [
    { q: 'كيف أودع أموال في حسابي؟', a: 'يمكنك الإيداع من خلال: بطاقة Visa/Mastercard خارجية، Apple Pay، أو Google Pay. الحد الأقصى للإيداع الواحد هو 50,000€.' },
    { q: 'ما هي رسوم الإيداع؟', a: 'رسوم الإيداع هي 1.5% من المبلغ + 0.50€ رسوم ثابتة. مثلاً: إيداع 100€ = رسوم 2€، يُضاف لحسابك 98€.' },
    { q: 'متى يظهر الإيداع في حسابي؟', a: 'الإيداعات عبر البطاقة و Apple Pay و Google Pay فورية. يظهر المبلغ في حسابك خلال ثوانٍ من تأكيد الدفع.' },
  ]},
  { cat: '🔒 الأمان', items: [
    { q: 'كيف يحمي SDB أموالي؟', a: 'نستخدم تشفير TLS 256-bit، مصادقة ثنائية (2FA)، مراقبة أمنية 24/7، وكشف الاحتيال بالذكاء الاصطناعي. حسابك محمي بأعلى معايير الأمان المصرفي.' },
    { q: 'ماذا أفعل إذا فقدت هاتفي؟', a: 'تواصل فوراً مع الدعم على مدار الساعة لتجميد حسابك وبطاقاتك. يمكنك أيضاً تسجيل الدخول من جهاز آخر وتجميد البطاقات بنفسك.' },
    { q: 'ما هو KYC ولماذا هو مطلوب؟', a: 'KYC (اعرف عميلك) هو إجراء تنظيمي إلزامي للتحقق من هوية العملاء. يشمل تقديم وثيقة هوية وإثبات عنوان. هذا يحمي حسابك ويساعد في مكافحة غسيل الأموال والاحتيال.' },
  ]},
  { cat: '🎧 الدعم', items: [
    { q: 'كيف أتواصل مع خدمة العملاء؟', a: 'يمكنك التواصل معنا عبر: الدعم المباشر داخل التطبيق (24/7)، البريد الإلكتروني support@shambank.com، أو الهاتف. فريقنا متاح دائماً لمساعدتك.' },
    { q: 'كم تستغرق معالجة تذاكر الدعم؟', a: 'نسعى للرد على جميع التذاكر خلال 4 ساعات كحد أقصى. المسائل العاجلة (مثل الاحتيال) تُعالج فوراً.' },
  ]},
];

let faqIndex = 0;
const indexedFaqs = faqs.map(cat => ({ ...cat, items: cat.items.map(item => ({ ...item, index: faqIndex++ })) }));
</script>

<template>
    <Head title="FAQ - الأسئلة الشائعة" />
    <div class="lg-root">
        <header class="lg-header">
            <div class="max-w-5xl mx-auto px-6 flex justify-between items-center">
                <Link href="/" class="text-xl font-black text-[#1E5EFF]">SDB</Link>
                <div class="flex gap-3">
                    <Link href="/terms" class="lg-link">الشروط والأحكام</Link>
                    <Link href="/privacy" class="lg-link">الخصوصية</Link>
                    <Link href="/about" class="lg-link">عن البنك</Link>
                </div>
            </div>
        </header>

        <main class="max-w-4xl mx-auto px-6 py-12" style="direction:rtl">
            <div class="text-center mb-10">
                <h1 class="text-3xl font-black text-[#0B1F3A] mb-2">الأسئلة الشائعة</h1>
                <p class="text-sm text-gray-400">إجابات شاملة على أكثر الأسئلة المتكررة حول خدماتنا المصرفية</p>
            </div>

            <div class="space-y-8">
                <div v-for="cat in indexedFaqs" :key="cat.cat">
                    <h2 class="text-lg font-bold text-[#0B1F3A] mb-3">{{ cat.cat }}</h2>
                    <div class="space-y-2">
                        <div v-for="item in cat.items" :key="item.index" class="fq-card" :class="openFaq === item.index ? 'fq-card-open' : ''">
                            <button class="fq-q" @click="toggle(item.index)">
                                <span>{{ item.q }}</span>
                                <span class="fq-arrow" :class="openFaq === item.index ? 'fq-arrow-open' : ''">›</span>
                            </button>
                            <div v-if="openFaq === item.index" class="fq-a">{{ item.a }}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="fq-cta">
                <div class="text-2xl mb-2">🤔</div>
                <h3 class="font-bold text-[#0B1F3A] text-lg mb-1">لم تجد إجابتك؟</h3>
                <p class="text-sm text-gray-400 mb-4">فريق الدعم لدينا متاح 24/7 لمساعدتك</p>
                <div class="flex gap-3 justify-center">
                    <a href="mailto:support@shambank.com" class="fq-btn">📧 راسلنا</a>
                    <Link href="/login" class="fq-btn fq-btn-blue">🎧 الدعم المباشر</Link>
                </div>
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
.fq-card{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:12px;overflow:hidden;transition:all .3s}
.fq-card:hover{border-color:rgba(30,94,255,0.15)}
.fq-card-open{border-color:rgba(30,94,255,0.2);background:rgba(30,94,255,0.01)}
.fq-q{width:100%;text-align:right;padding:14px 18px;display:flex;justify-content:space-between;align-items:center;cursor:pointer;font-size:14px;font-weight:600;color:#0B1F3A;background:none;border:none}
.fq-arrow{font-size:20px;color:rgba(30,94,255,0.5);transition:transform .2s;font-weight:300}
.fq-arrow-open{transform:rotate(90deg);color:#1E5EFF}
.fq-a{padding:0 18px 16px;font-size:13px;line-height:1.9;color:rgba(11,31,58,0.55);border-top:1px solid rgba(11,31,58,0.05);padding-top:12px;margin:0 18px;animation:fadeIn .2s}
@keyframes fadeIn{from{opacity:0;transform:translateY(-5px)}to{opacity:1;transform:translateY(0)}}
.fq-cta{text-align:center;padding:40px;background:linear-gradient(135deg,rgba(30,94,255,0.03),rgba(0,194,255,0.03));border:1.5px solid rgba(30,94,255,0.1);border-radius:20px;margin-top:40px}
.fq-btn{display:inline-flex;padding:10px 20px;border-radius:12px;font-size:13px;font-weight:600;color:rgba(11,31,58,0.5);border:1.5px solid rgba(11,31,58,0.1);text-decoration:none;transition:all .3s;background:#fff}.fq-btn:hover{border-color:#1E5EFF;color:#1E5EFF}
.fq-btn-blue{background:linear-gradient(135deg,#1E5EFF,#3B82F6)!important;color:#fff!important;border-color:#1E5EFF!important;box-shadow:0 4px 12px rgba(30,94,255,0.2)}.fq-btn-blue:hover{box-shadow:0 6px 20px rgba(30,94,255,0.3)}
.lg-footer{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
.lg-flink{font-size:12px;color:rgba(11,31,58,0.4);text-decoration:none}.lg-flink:hover{color:#1E5EFF}
</style>
