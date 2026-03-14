<script setup>
import SiteLayout from '@/Layouts/SiteLayout.vue';
import { Head } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title: 'الشروط والأحكام — SDB Bank',
  badge: '⚖️ اتفاقية قانونية',
  h1: 'الشروط والأحكام',
  sub: 'الاتفاقية التي تحكم استخدامك لخدمات SDB Bank',
  date: 'آخر تحديث: فبراير ٢٠٢٦',
  s1t: 'المقدمة',
  s1p1: 'مرحباً بك في SDB Bank ApS. باستخدامك لخدماتنا المصرفية الرقمية، فإنك توافق على الالتزام بهذه الشروط والأحكام. يرجى قراءتها بعناية قبل فتح حساب أو استخدام أي من خدماتنا.',
  s1p2: 'SDB Bank هي مؤسسة مالية رقمية مسجلة في الدنمارك، تعمل وفقاً للقوانين واللوائح المصرفية الأوروبية المعمول بها. نخضع لرقابة الجهات التنظيمية المختصة ونحافظ على أعلى معايير الامتثال المالي.',
  s2t: 'فتح الحساب والتسجيل',
  s2p: 'لفتح حساب في SDB، يجب أن:',
  s2reqs: ['أن يكون عمرك 18 سنة على الأقل','تقديم معلومات شخصية دقيقة وصحيحة','إكمال التحقق من الهوية (KYC) بنجاح','تقديم وثائق هوية صالحة (جواز سفر، هوية وطنية)','الموافقة على هذه الشروط وسياسة الخصوصية'],
  s2note: 'يحتفظ البنك بالحق في رفض أي طلب فتح حساب دون إبداء الأسباب، وفقاً للسياسات الداخلية ومتطلبات مكافحة غسيل الأموال.',
  s3t: 'الحسابات المصرفية',
  s3p: 'يقدم SDB عدة أنواع من الحسابات:',
  s3c1t: 'حساب جاري', s3c1d: 'لإدارة الأموال اليومية والمعاملات',
  s3c2t: 'حساب متعدد العملات', s3c2d: 'يدعم عملات متعددة بأسعار صرف تنافسية',
  s3c3t: 'حساب توفير', s3c3d: 'بمعدلات فائدة تنافسية',
  s3p2: 'يحصل كل حساب على IBAN فريد ورقم حساب داخلي مكون من 10 أرقام.',
  s4t: 'البطاقات',
  s4p: 'يقدم SDB بطاقات Mastercard بنوعين:',
  s4c1t: 'بطاقة افتراضية', s4c1d: 'تصدر فوراً للاستخدام عبر الإنترنت',
  s4c2t: 'بطاقة فعلية', s4c2d: 'تُشحن إلى عنوانك المسجل',
  s4p2: 'تخضع البطاقات لحدود إنفاق يومية وشهرية يمكن تعديلها من خلال التطبيق. يمكنك تجميد بطاقتك مؤقتاً في أي وقت لأسباب أمنية.',
  s5t: 'التحويلات والمعاملات',
  s5items: [
    {ic:'⚡',d:'التحويلات الداخلية بين حسابات SDB <strong>فورية ومجانية</strong>'},
    {ic:'🌐',d:'التحويلات الخارجية تخضع لرسوم ومواعيد معالجة'},
    {ic:'💱',d:'يتم تنفيذ صرف العملات بأسعار السوق الحية مع هامش تنافسي'},
    {ic:'🔒',d:'جميع المعاملات نهائية بمجرد التأكيد ولا يمكن التراجع عنها'},
  ],
  s6t: 'الرسوم والتكاليف',
  s6fees: [
    {s:'إيداع البطاقة',f:'1.5% + €0.50'},
    {s:'التحويلات الداخلية',f:'مجاني',free:true},
    {s:'إصدار بطاقة افتراضية',f:'مجاني',free:true},
    {s:'إصدار بطاقة فعلية',f:'حسب الباقة'},
    {s:'صرف العملات',f:'هامش 0.5% – 2%'},
  ],
  s6note: 'يحتفظ البنك بالحق في تعديل الرسوم مع إشعار مسبق لا يقل عن 30 يوماً.',
  s7t: 'الأمان والمسؤوليات',
  s7items: ['🔑 الحفاظ على سرية بيانات تسجيل الدخول','🚨 إبلاغنا فوراً بأي نشاط مشبوه','🔒 تشفير TLS 256-bit لحماية جميع البيانات','📱 المصادقة الثنائية (2FA) متاحة وموصى بها','🧊 قد يتم تجميد الحسابات عند الاشتباه بنشاط غير مشروع'],
  s8t: 'مكافحة غسيل الأموال (AML)',
  s8p: 'يلتزم SDB بقوانين مكافحة غسيل الأموال وتمويل الإرهاب. قد نطلب:',
  s8items: ['تحقق معزز من الهوية للمعاملات الكبيرة','معلومات إضافية عن مصدر الأموال','الإبلاغ عن المعاملات المشبوهة للجهات المختصة'],
  s9t: 'إنهاء الخدمة',
  s9p: 'يمكنك إغلاق حسابك في أي وقت، بشرط تسوية جميع الالتزامات. يحتفظ البنك بالحق في إغلاق أي حساب ينتهك هذه الشروط أو يُستخدم لأغراض غير مشروعة.',
  s10t: 'القانون الحاكم',
  s10p: 'تخضع هذه الشروط لقوانين <strong>مملكة الدنمارك</strong> و<strong>الاتحاد الأوروبي</strong>. في حالة أي نزاع، ستتم محاولة الحل أولاً من خلال الوساطة، ثم التحكيم أمام المحاكم الدنماركية المختصة إذا لزم الأمر.',
  s11t: 'اتصل بنا',
  s11items: ['📧 legal@sdb-bank.com','📞 +45 42 80 55 94','💬 الدعم داخل التطبيق: متاح 24/7','📍 الدنمارك 🇩🇰'],
  serviceLabel: 'الخدمة', feeLabel: 'الرسوم',
} : {
  title: 'Terms & Conditions — SDB Bank',
  badge: '⚖️ Legal Agreement',
  h1: 'Terms & Conditions',
  sub: 'The agreement governing your use of SDB Bank services',
  date: 'Last updated: February 2026',
  s1t: 'Introduction',
  s1p1: 'Welcome to SDB Bank ApS. By using our digital banking services, you agree to comply with these Terms and Conditions. Please read them carefully before opening an account or using any of our services.',
  s1p2: 'SDB Bank is a digital financial institution registered in Denmark, operating in accordance with applicable European banking laws and regulations. We are subject to oversight by the relevant regulatory authorities and maintain the highest standards of financial compliance.',
  s2t: 'Account Opening & Registration',
  s2p: 'To open an account with SDB, you must:',
  s2reqs: ['Be at least 18 years of age','Provide accurate and truthful personal information','Successfully complete identity verification (KYC)','Submit valid identity documents (passport, national ID)','Agree to these Terms and our Privacy Policy'],
  s2note: 'The bank reserves the right to decline any account opening request without stating reasons, in accordance with internal compliance policies and anti-money laundering requirements.',
  s3t: 'Banking Accounts',
  s3p: 'SDB offers several types of banking accounts:',
  s3c1t: 'Current Account', s3c1d: 'For day-to-day money management and transactions',
  s3c2t: 'Multi-Currency Account', s3c2d: 'Supports multiple currencies with competitive exchange rates',
  s3c3t: 'Savings Account', s3c3d: 'With competitive interest rates',
  s3p2: 'Each account receives a unique IBAN and an internal 10-digit account number.',
  s4t: 'Cards',
  s4p: 'SDB offers Mastercard cards in two types:',
  s4c1t: 'Virtual Card', s4c1d: 'Issued instantly for online use',
  s4c2t: 'Physical Card', s4c2d: 'Shipped to your registered address',
  s4p2: 'Cards are subject to daily and monthly spending limits which can be adjusted through the app. You can temporarily freeze your card at any time for security reasons.',
  s5t: 'Transfers & Transactions',
  s5items: [
    {ic:'⚡',d:'Internal transfers between SDB accounts are <strong>instant and free</strong>'},
    {ic:'🌐',d:'External transfers are subject to fees and processing timelines'},
    {ic:'💱',d:'Currency exchange is executed at live market rates with a competitive margin'},
    {ic:'🔒',d:'All transactions are final once confirmed and cannot be reversed'},
  ],
  s6t: 'Fees & Charges',
  s6fees: [
    {s:'Card deposit',f:'1.5% + €0.50'},
    {s:'Internal transfers',f:'Free',free:true},
    {s:'Virtual card issuance',f:'Free',free:true},
    {s:'Physical card issuance',f:'Depends on plan'},
    {s:'Currency exchange',f:'0.5% – 2% margin'},
  ],
  s6note: 'The bank reserves the right to modify fees with at least 30 days\' prior notice to customers.',
  s7t: 'Security & Responsibilities',
  s7items: ['🔑 Maintain confidentiality of login credentials','🚨 Notify us immediately of suspicious activity','🔒 TLS 256-bit encryption protects all data','📱 Two-factor authentication (2FA) recommended','🧊 Accounts may be frozen on suspicion of illicit activity'],
  s8t: 'Anti-Money Laundering (AML)',
  s8p: 'SDB complies with anti-money laundering and counter-terrorism financing laws. We may require:',
  s8items: ['Enhanced identity verification for large transactions','Additional information on the source of funds','Reporting of suspicious transactions to relevant authorities'],
  s9t: 'Termination',
  s9p: 'You may close your account at any time, provided all obligations are settled. The bank reserves the right to close any account that violates these Terms or is used for unlawful purposes.',
  s10t: 'Governing Law',
  s10p: 'These Terms are governed by the laws of the <strong>Kingdom of Denmark</strong> and the <strong>European Union</strong>. In case of any dispute, resolution will first be attempted through mediation, then arbitration before the competent Danish courts if necessary.',
  s11t: 'Contact Us',
  s11items: ['📧 legal@sdb-bank.com','📞 +45 42 80 55 94','💬 In-app support: Available 24/7','📍 Denmark 🇩🇰'],
  serviceLabel: 'Service', feeLabel: 'Fee',
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
        <p>{{ t.s2p }}</p>
        <div class="lp-reqs"><div v-for="r in t.s2reqs" :key="r" class="lp-req"><span class="lp-req-ic">✅</span> {{ r }}</div></div>
        <div class="lp-note">{{ t.s2note }}</div>
      </section>

      <section class="lp-s"><div class="lp-s-num">03</div><h2>{{ t.s3t }}</h2>
        <p>{{ t.s3p }}</p>
        <div class="lp-cards">
          <div class="lp-card"><div class="lp-card-ic">🏦</div><div class="lp-card-h">{{ t.s3c1t }}</div><p>{{ t.s3c1d }}</p></div>
          <div class="lp-card"><div class="lp-card-ic">🌍</div><div class="lp-card-h">{{ t.s3c2t }}</div><p>{{ t.s3c2d }}</p></div>
          <div class="lp-card"><div class="lp-card-ic">💰</div><div class="lp-card-h">{{ t.s3c3t }}</div><p>{{ t.s3c3d }}</p></div>
        </div>
        <p style="margin-top:14px">{{ t.s3p2 }}</p>
      </section>

      <section class="lp-s"><div class="lp-s-num">04</div><h2>{{ t.s4t }}</h2>
        <p>{{ t.s4p }}</p>
        <div class="lp-cards lp-cards-2">
          <div class="lp-card"><div class="lp-card-ic">💳</div><div class="lp-card-h">{{ t.s4c1t }}</div><p>{{ t.s4c1d }}</p></div>
          <div class="lp-card"><div class="lp-card-ic">💳</div><div class="lp-card-h">{{ t.s4c2t }}</div><p>{{ t.s4c2d }}</p></div>
        </div>
        <p style="margin-top:14px">{{ t.s4p2 }}</p>
      </section>

      <section class="lp-s"><div class="lp-s-num">05</div><h2>{{ t.s5t }}</h2>
        <div class="lp-list">
          <div v-for="it in t.s5items" :key="it.ic" class="lp-item"><span class="lp-item-ic">{{ it.ic }}</span><div v-html="it.d"></div></div>
        </div>
      </section>

      <section class="lp-s"><div class="lp-s-num">06</div><h2>{{ t.s6t }}</h2>
        <table class="lp-tbl">
          <thead><tr><th>{{ t.serviceLabel }}</th><th>{{ t.feeLabel }}</th></tr></thead>
          <tbody><tr v-for="f in t.s6fees" :key="f.s"><td>{{ f.s }}</td><td :class="{'lp-free': f.free}">{{ f.f }}</td></tr></tbody>
        </table>
        <div class="lp-note" style="margin-top:14px">{{ t.s6note }}</div>
      </section>

      <section class="lp-s"><div class="lp-s-num">07</div><h2>{{ t.s7t }}</h2>
        <div class="lp-shields"><div v-for="s in t.s7items" :key="s" class="lp-shield">{{ s }}</div></div>
      </section>

      <section class="lp-s"><div class="lp-s-num">08</div><h2>{{ t.s8t }}</h2>
        <p>{{ t.s8p }}</p>
        <ul><li v-for="i in t.s8items" :key="i">{{ i }}</li></ul>
      </section>

      <section class="lp-s"><div class="lp-s-num">09</div><h2>{{ t.s9t }}</h2><p>{{ t.s9p }}</p></section>

      <section class="lp-s"><div class="lp-s-num">10</div><h2>{{ t.s10t }}</h2>
        <div class="lp-law"><span class="lp-law-flag">🇩🇰 🇪🇺</span><p v-html="t.s10p"></p></div>
      </section>

      <section class="lp-s lp-s-last"><div class="lp-s-num">11</div><h2>{{ t.s11t }}</h2>
        <div class="lp-contact"><div v-for="c in t.s11items" :key="c" class="lp-contact-item">{{ c }}</div></div>
      </section>

    </div>
  </div>
</div>
</template>

<style scoped>
.lp-hero{background:linear-gradient(135deg,#0a1628 0%,#132743 50%,#0d2137 100%);padding:80px 20px 60px;text-align:center;position:relative;overflow:hidden}
.lp-hero-glow{position:absolute;width:400px;height:400px;background:radial-gradient(circle,rgba(16,185,129,.15),transparent 70%);top:-100px;left:20%;pointer-events:none}
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
.lp-cards-2{grid-template-columns:repeat(2,1fr)}
.lp-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:14px;padding:20px}
.lp-card-ic{font-size:24px;margin-bottom:8px}
.lp-card-h{font-size:14px;font-weight:800;color:#0f172a;margin-bottom:6px}
.lp-card p{font-size:13px;color:#64748b;margin:0}
.lp-reqs{display:flex;flex-direction:column;gap:6px;margin:10px 0}
.lp-req{display:flex;align-items:center;gap:10px;font-size:14px;color:#334155;padding:8px 0}
.lp-req-ic{font-size:16px}
.lp-note{background:#fffbeb;border:1px solid #fde68a;border-radius:10px;padding:12px 18px;font-size:13px;color:#92400e;line-height:1.7}
.lp-list{display:flex;flex-direction:column;gap:10px}
.lp-item{display:flex;gap:14px;padding:14px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px}
.lp-item-ic{font-size:20px;flex-shrink:0}
.lp-item strong,.lp-item :deep(strong){color:#0f172a;font-size:14px}
.lp-item div{font-size:13px;color:#64748b;line-height:1.6}
.lp-tbl{width:100%;border-collapse:collapse;background:#f8fafc;border-radius:12px;overflow:hidden;border:1px solid #e2e8f0}
.lp-tbl th{text-align:inherit;font-size:12px;font-weight:700;color:#64748b;padding:12px 16px;background:#f1f5f9;border-bottom:2px solid #e2e8f0}
.lp-tbl td{font-size:14px;color:#334155;padding:12px 16px;border-bottom:1px solid #e2e8f0}
.lp-tbl tr:last-child td{border-bottom:none}
.lp-free{color:#10b981;font-weight:700}
.lp-shields{display:flex;flex-wrap:wrap;gap:10px}
.lp-shield{background:linear-gradient(135deg,#0f172a,#1e293b);color:#fff;padding:10px 18px;border-radius:10px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:8px}
.lp-law{background:linear-gradient(135deg,#eff6ff,#dbeafe);border:1px solid #93c5fd;border-radius:14px;padding:20px;display:flex;gap:16px;align-items:flex-start}
.lp-law-flag{font-size:28px;flex-shrink:0}
.lp-law p{margin:0}
.lp-contact{display:flex;flex-direction:column;gap:8px}
.lp-contact-item{font-size:15px;color:#334155;font-weight:600;padding:10px 0;border-bottom:1px solid #f1f5f9}
.lp-contact-item:last-child{border:none}
@media(max-width:768px){.lp-h1{font-size:28px}.lp-cards,.lp-cards-2{grid-template-columns:1fr}.lp-shields{flex-direction:column}}
</style>
