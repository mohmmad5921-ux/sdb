<script setup>
import SiteLayout from '@/Layouts/SiteLayout.vue';
import { Head } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title: 'سياسة الخصوصية — SDB Bank',
  badge: '🔒 متوافق مع GDPR',
  h1: 'سياسة الخصوصية',
  sub: 'كيف نجمع بياناتك الشخصية ونحميها ونستخدمها',
  date: 'آخر تحديث: فبراير ٢٠٢٦',
  s1t: 'التزامنا بالخصوصية',
  s1p1: 'في SDB Bank ApS، نأخذ خصوصية عملائنا على محمل الجد. توضح هذه السياسة كيف نجمع ونستخدم ونحمي ونشارك معلوماتك الشخصية عند استخدام خدماتنا المصرفية.',
  s1p2: 'نحافظ على أعلى معايير حماية البيانات ونلتزم بالنظام العام لحماية البيانات (GDPR) والقوانين المحلية المعمول بها.',
  s2t: 'البيانات التي نجمعها',
  s2c1t: 'البيانات الشخصية', s2c1: ['الاسم الكامل، تاريخ الميلاد، الجنسية','البريد الإلكتروني ورقم الهاتف','عنوان السكن ومعلومات الإقامة','وثائق الهوية (جواز السفر، الهوية الوطنية)'],
  s2c2t: 'البيانات المالية', s2c2: ['معلومات الحسابات المصرفية والأرصدة','تاريخ المعاملات والتحويلات','معلومات البطاقات','مصادر الدخل والتوظيف'],
  s2c3t: 'البيانات التقنية', s2c3: ['عنوان IP ونوع المتصفح والجهاز','سجلات تسجيل الدخول والنشاط','بيانات الموقع الجغرافي (بموافقتك)','ملفات تعريف الارتباط (Cookies)'],
  s3t: 'كيف نستخدم بياناتك',
  s3items: [
    {ic:'🛡️',t:'تقديم الخدمة',d:'إدارة حسابك ومعالجة المعاملات'},
    {ic:'🪪',t:'التحقق من الهوية',d:'الامتثال لمتطلبات KYC ومكافحة غسيل الأموال'},
    {ic:'🔐',t:'الأمان',d:'كشف الاحتيال ومنع الأنشطة المشبوهة'},
    {ic:'📈',t:'التحسين',d:'تطوير وتحسين خدماتنا وتجربة المستخدم'},
    {ic:'📧',t:'التواصل',d:'إرسال إشعارات مهمة حول حسابك'},
    {ic:'⚖️',t:'الامتثال القانوني',d:'الاستجابة للطلبات التنظيمية والقانونية'},
  ],
  s4t: 'مشاركة البيانات',
  s4alert: '⚠️ لا نبيع بياناتك الشخصية أبداً.',
  s4p: 'قد نشارك بياناتك فقط في الحالات التالية:',
  s4items: [
    {b:'مزودو الخدمة:',d:'معالجات الدفع وشركاء التكنولوجيا الموثوقون'},
    {b:'الجهات الرقابية:',d:'البنك المركزي والسلطات الإشرافية المختصة'},
    {b:'المتطلبات القانونية:',d:'أوامر المحكمة والطلبات القانونية الملزمة'},
    {b:'منع الاحتيال:',d:'مع مؤسسات مكافحة الجرائم المالية'},
  ],
  s5t: 'حماية البيانات',
  s5items: ['🔒 تشفير TLS 256-bit','🏢 مراكز بيانات معتمدة ISO 27001','👁️ مراقبة أمنية 24/7','🔍 اختبارات اختراق دورية','🔑 صلاحيات وصول حسب الحاجة'],
  s6t: 'حقوقك',
  s6items: [
    {ic:'📋',t:'حق الوصول',d:'طلب نسخة من بياناتك المخزنة'},
    {ic:'✏️',t:'حق التصحيح',d:'تحديث أو تصحيح البيانات غير الدقيقة'},
    {ic:'🗑️',t:'حق الحذف',d:'طلب حذف بياناتك (وفقاً للمتطلبات القانونية)'},
    {ic:'📤',t:'حق النقل',d:'الحصول على بياناتك بتنسيق قابل للقراءة الآلية'},
    {ic:'🚫',t:'حق الاعتراض',d:'رفض استخدام بياناتك لأغراض تسويقية'},
  ],
  s7t: 'ملفات تعريف الارتباط',
  s7c1t: 'أساسية', s7c1d: 'ضرورية لتشغيل الموقع (تسجيل الدخول، الأمان)',
  s7c2t: 'وظيفية', s7c2d: 'تذكر تفضيلاتك (اللغة، المنطقة الزمنية)',
  s7c3t: 'تحليلية', s7c3d: 'فهم الاستخدام لتحسين الخدمة',
  s8t: 'الاحتفاظ بالبيانات',
  s8p: 'نحتفظ ببياناتك طالما حسابك نشط، ولمدة لا تقل عن <strong>5 سنوات</strong> بعد إغلاق الحساب وفقاً لمتطلبات مكافحة غسيل الأموال.',
  s9t: 'التغييرات',
  s9p: 'نحتفظ بالحق في تعديل هذه السياسة. سيتم إخطارك بأي تغييرات جوهرية عبر البريد الإلكتروني أو إشعار داخل التطبيق قبل <strong>30 يوماً</strong> على الأقل من دخولها حيز التنفيذ.',
  s10t: 'الاتصال بمسؤول حماية البيانات',
  s10items: ['📧 dpo@sdb-bank.com','🏢 قسم حماية البيانات — SDB Bank ApS، الدنمارك','💬 الدعم داخل التطبيق: متاح 24/7'],
} : {
  title: 'Privacy Policy — SDB Bank',
  badge: '🔒 GDPR Compliant',
  h1: 'Privacy Policy',
  sub: 'How we collect, protect and use your personal data',
  date: 'Last updated: February 2026',
  s1t: 'Our Commitment to Privacy',
  s1p1: 'At SDB Bank ApS, we take our customers\' privacy seriously. This policy explains how we collect, use, protect and share your personal information when using our banking services.',
  s1p2: 'We maintain the highest data protection standards and comply with the General Data Protection Regulation (GDPR) and applicable local laws.',
  s2t: 'Data We Collect',
  s2c1t: 'Personal Data', s2c1: ['Full name, date of birth, nationality','Email address and phone number','Residential address and residency information','Identity documents (passport, national ID)'],
  s2c2t: 'Financial Data', s2c2: ['Bank account information and balances','Transaction and transfer history','Card information','Income sources and employment'],
  s2c3t: 'Technical Data', s2c3: ['IP address, browser type and device','Login and activity logs','Geolocation data (with your consent)','Cookies'],
  s3t: 'How We Use Your Data',
  s3items: [
    {ic:'🛡️',t:'Service Delivery',d:'Managing your account and processing transactions'},
    {ic:'🪪',t:'Identity Verification',d:'Compliance with KYC and AML requirements'},
    {ic:'🔐',t:'Security',d:'Fraud detection and prevention of suspicious activities'},
    {ic:'📈',t:'Improvement',d:'Developing and enhancing our services and user experience'},
    {ic:'📧',t:'Communication',d:'Sending important notifications about your account'},
    {ic:'⚖️',t:'Legal Compliance',d:'Responding to regulatory and legal requests'},
  ],
  s4t: 'Data Sharing',
  s4alert: '⚠️ We never sell your personal data.',
  s4p: 'We may share your data only in the following cases:',
  s4items: [
    {b:'Service Providers:',d:'Payment processors and trusted technology partners'},
    {b:'Regulators:',d:'Central bank and relevant supervisory authorities'},
    {b:'Legal Requirements:',d:'Court orders and binding legal requests'},
    {b:'Fraud Prevention:',d:'With financial crime prevention institutions'},
  ],
  s5t: 'Data Protection',
  s5items: ['🔒 TLS 256-bit encryption','🏢 ISO 27001 certified data centres','👁️ 24/7 security monitoring','🔍 Regular penetration testing','🔑 Need-based access permissions'],
  s6t: 'Your Rights',
  s6items: [
    {ic:'📋',t:'Right of Access',d:'Request a copy of your stored data'},
    {ic:'✏️',t:'Right to Rectification',d:'Update or correct inaccurate data'},
    {ic:'🗑️',t:'Right to Erasure',d:'Request deletion of your data (subject to legal requirements)'},
    {ic:'📤',t:'Right to Portability',d:'Receive your data in a machine-readable format'},
    {ic:'🚫',t:'Right to Object',d:'Refuse use of your data for marketing purposes'},
  ],
  s7t: 'Cookies',
  s7c1t: 'Essential', s7c1d: 'Necessary for site operation (login, security)',
  s7c2t: 'Functional', s7c2d: 'Remember your preferences (language, timezone)',
  s7c3t: 'Analytical', s7c3d: 'Understand usage to improve the service',
  s8t: 'Data Retention',
  s8p: 'We retain your data as long as your account is active, and for a minimum of <strong>5 years</strong> after account closure in accordance with anti-money laundering regulatory requirements.',
  s9t: 'Changes',
  s9p: 'We reserve the right to amend this policy. You will be notified of any material changes via email or in-app notification at least <strong>30 days</strong> before they take effect.',
  s10t: 'Contact the Data Protection Officer',
  s10items: ['📧 dpo@sdb-bank.com','🏢 Data Protection Dept. — SDB Bank ApS, Denmark','💬 In-app support: Available 24/7'],
});
</script>

<template>
<Head :title="t.title" />
<div class="lp" :style="{direction: isAr ? 'rtl' : 'ltr'}">
  <div class="lp-hero">
    <div class="lp-hero-glow"></div>
    <div class="lp-hero-inner">
      <div class="lp-badge">{{ t.badge }}</div>
      <h1 class="lp-h1">{{ t.h1 }}</h1>
      <p class="lp-sub">{{ t.sub }}</p>
      <p class="lp-date">{{ t.date }}</p>
    </div>
  </div>

  <div class="lp-body">
    <div class="lp-content">

      <section class="lp-s"><div class="lp-s-num">01</div><h2>{{ t.s1t }}</h2><p>{{ t.s1p1 }}</p><p>{{ t.s1p2 }}</p></section>

      <section class="lp-s"><div class="lp-s-num">02</div><h2>{{ t.s2t }}</h2>
        <div class="lp-cards">
          <div class="lp-card"><div class="lp-card-ic">👤</div><div class="lp-card-h">{{ t.s2c1t }}</div><ul><li v-for="i in t.s2c1" :key="i">{{ i }}</li></ul></div>
          <div class="lp-card"><div class="lp-card-ic">💰</div><div class="lp-card-h">{{ t.s2c2t }}</div><ul><li v-for="i in t.s2c2" :key="i">{{ i }}</li></ul></div>
          <div class="lp-card"><div class="lp-card-ic">🖥️</div><div class="lp-card-h">{{ t.s2c3t }}</div><ul><li v-for="i in t.s2c3" :key="i">{{ i }}</li></ul></div>
        </div>
      </section>

      <section class="lp-s"><div class="lp-s-num">03</div><h2>{{ t.s3t }}</h2>
        <div class="lp-list">
          <div v-for="it in t.s3items" :key="it.t" class="lp-item"><span class="lp-item-ic">{{ it.ic }}</span><div><strong>{{ it.t }}</strong><br>{{ it.d }}</div></div>
        </div>
      </section>

      <section class="lp-s"><div class="lp-s-num">04</div><h2>{{ t.s4t }}</h2>
        <div class="lp-alert">{{ t.s4alert }}</div>
        <p>{{ t.s4p }}</p>
        <ul><li v-for="it in t.s4items" :key="it.b"><strong>{{ it.b }}</strong> {{ it.d }}</li></ul>
      </section>

      <section class="lp-s"><div class="lp-s-num">05</div><h2>{{ t.s5t }}</h2>
        <div class="lp-shields"><div v-for="s in t.s5items" :key="s" class="lp-shield">{{ s }}</div></div>
      </section>

      <section class="lp-s"><div class="lp-s-num">06</div><h2>{{ t.s6t }}</h2>
        <div class="lp-list">
          <div v-for="it in t.s6items" :key="it.t" class="lp-item"><span class="lp-item-ic">{{ it.ic }}</span><div><strong>{{ it.t }}</strong><br>{{ it.d }}</div></div>
        </div>
      </section>

      <section class="lp-s"><div class="lp-s-num">07</div><h2>{{ t.s7t }}</h2>
        <div class="lp-cards lp-cards-3">
          <div class="lp-card"><div class="lp-card-ic">⚙️</div><div class="lp-card-h">{{ t.s7c1t }}</div><p>{{ t.s7c1d }}</p></div>
          <div class="lp-card"><div class="lp-card-ic">🎛️</div><div class="lp-card-h">{{ t.s7c2t }}</div><p>{{ t.s7c2d }}</p></div>
          <div class="lp-card"><div class="lp-card-ic">📊</div><div class="lp-card-h">{{ t.s7c3t }}</div><p>{{ t.s7c3d }}</p></div>
        </div>
      </section>

      <section class="lp-s"><div class="lp-s-num">08</div><h2>{{ t.s8t }}</h2><p v-html="t.s8p"></p></section>
      <section class="lp-s"><div class="lp-s-num">09</div><h2>{{ t.s9t }}</h2><p v-html="t.s9p"></p></section>

      <section class="lp-s lp-s-last"><div class="lp-s-num">10</div><h2>{{ t.s10t }}</h2>
        <div class="lp-contact"><div v-for="c in t.s10items" :key="c" class="lp-contact-item">{{ c }}</div></div>
      </section>

    </div>
  </div>
</div>
</template>

<style scoped>
.lp-hero{background:linear-gradient(135deg,#0a1628 0%,#132743 50%,#0d2137 100%);padding:80px 20px 60px;text-align:center;position:relative;overflow:hidden}
.lp-hero-glow{position:absolute;width:400px;height:400px;background:radial-gradient(circle,rgba(16,185,129,.15),transparent 70%);top:-100px;right:20%;pointer-events:none}
.lp-hero-inner{position:relative;z-index:1;max-width:700px;margin:0 auto}
.lp-badge{display:inline-block;background:rgba(16,185,129,.12);border:1px solid rgba(16,185,129,.25);color:#10b981;font-size:12px;font-weight:700;padding:6px 16px;border-radius:20px;margin-bottom:20px;letter-spacing:1px}
.lp-h1{font-size:42px;font-weight:900;color:#fff;margin-bottom:12px}
.lp-sub{font-size:16px;color:rgba(255,255,255,.55);margin-bottom:8px}
.lp-date{font-size:13px;color:rgba(255,255,255,.3)}
.lp-body{max-width:800px;margin:0 auto;padding:40px 20px 60px}
.lp-content{display:flex;flex-direction:column;gap:0}
.lp-s{padding:32px 0;border-bottom:1px solid rgba(0,0,0,.06)}
.lp-s-last{border-bottom:none}
.lp-s-num{font-size:12px;font-weight:900;color:#10b981;letter-spacing:2px;margin-bottom:8px}
.lp-s h2{font-size:22px;font-weight:800;color:#0f172a;margin-bottom:14px}
.lp-s p{font-size:15px;line-height:1.8;color:#475569;margin-bottom:10px}
.lp-s p:deep(strong){color:#0f172a}
.lp-s ul{padding-inline-start:20px;margin:10px 0}
.lp-s li{font-size:14px;line-height:2;color:#475569;list-style:disc}
.lp-s li strong{color:#0f172a}
.lp-cards{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
.lp-cards-3{grid-template-columns:repeat(3,1fr)}
.lp-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:14px;padding:20px}
.lp-card-ic{font-size:24px;margin-bottom:8px}
.lp-card-h{font-size:14px;font-weight:800;color:#0f172a;margin-bottom:6px}
.lp-card ul{padding-inline-start:16px;margin:0}.lp-card li{font-size:13px;line-height:1.8;color:#64748b}
.lp-card p{font-size:13px;color:#64748b;margin:0}
.lp-alert{background:#ecfdf5;border:1px solid #a7f3d0;border-radius:10px;padding:12px 18px;font-size:14px;font-weight:700;color:#059669;margin-bottom:14px}
.lp-list{display:flex;flex-direction:column;gap:10px}
.lp-item{display:flex;gap:14px;padding:14px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px}
.lp-item-ic{font-size:20px;flex-shrink:0}
.lp-item strong{color:#0f172a;font-size:14px}
.lp-item div{font-size:13px;color:#64748b;line-height:1.6}
.lp-shields{display:flex;flex-wrap:wrap;gap:10px}
.lp-shield{background:linear-gradient(135deg,#0f172a,#1e293b);color:#fff;padding:10px 18px;border-radius:10px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:8px}
.lp-contact{display:flex;flex-direction:column;gap:8px}
.lp-contact-item{font-size:15px;color:#334155;font-weight:600;padding:10px 0;border-bottom:1px solid #f1f5f9}
.lp-contact-item:last-child{border:none}
@media(max-width:768px){.lp-h1{font-size:28px}.lp-cards,.lp-cards-3{grid-template-columns:1fr}.lp-shields{flex-direction:column}}
</style>
