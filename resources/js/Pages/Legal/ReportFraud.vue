<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, computed, ref } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const formData = ref({type:'',cardLast4:'',date:'',amount:'',desc:''});
const t = computed(() => isAr.value ? {
  title:'إبلاغ عن احتيال — SDB Bank',tag:'الإبلاغ',
  heroH:'لاحظت نشاط مريب؟',heroEm:'أبلغنا فوراً.',
  heroP:'فريق الحماية متاح 24/7. أبلغنا فوراً وسنتخذ إجراءات عاجلة لحماية حسابك.',
  urgentTitle:'إجراءات طوارئ فورية',
  urgents:[
    {ic:'❄️',t:'جمّد بطاقتك فوراً',d:'افتح التطبيق → البطاقات → تجميد. هذا يمنع أي عمليات إضافية.'},
    {ic:'🔒',t:'غيّر كلمة المرور',d:'الإعدادات → الأمان → تغيير كلمة المرور. اختر كلمة قوية ومختلفة.'},
    {ic:'📞',t:'اتصل بنا فوراً',d:'خط الاحتيال الطوارئ: +45 XX XX XX XX (متاح 24/7).'},
    {ic:'🚫',t:'لا تشارك أي رموز',d:'لن نطلب منك أبداً OTP أو كلمة مرور. أي شخص يطلبها = محتال.'},
  ],
  typesTitle:'أنواع الاحتيال الشائعة',
  types:[
    {ic:'📧',t:'تصيّد إلكتروني (Phishing)',d:'بريد أو رسالة تبدو من SDB تطلب بياناتك. تأكد من الرابط — نحن نرسل فقط من @sdb-bank.com.','signs':['رابط غريب','طلب بيانات حساسة','إلحاح مريب']},
    {ic:'📱',t:'مكالمات مزيفة (Vishing)',d:'شخص يتصل يدّعي أنه من البنك ويطلب OTP أو كلمة المرور. نحن لا نتصل أبداً لطلب هذه البيانات.','signs':['يطلب OTP','يستعجلك','يهدد بإغلاق الحساب']},
    {ic:'💳',t:'سرقة بيانات البطاقة',d:'استخدام بيانات بطاقتك بدون إذنك. CVV الديناميكي يحميك — لكن أبلغنا فوراً.','signs':['عمليات لم تقم بها','مبالغ غير معروفة','مواقع غريبة']},
    {ic:'🎭',t:'انتحال هوية',d:'شخص يستخدم هويتك لفتح حساب أو طلب خدمات. راقب إشعاراتك دائماً.','signs':['حسابات لم تفتحها','تغييرات لم تطلبها','إشعارات غريبة']},
  ],
  formTitle:'نموذج الإبلاغ',
  formLabels:{type:'نوع الاحتيال',types:['سحب غير مأذون','عملية شراء مشبوهة','تصيّد إلكتروني','مكالمة مزيفة','انتحال هوية','أخرى'],card:'آخر 4 أرقام من البطاقة',date:'تاريخ الحادثة',amount:'المبلغ (إن وُجد)',desc:'وصف ما حدث بالتفصيل',submit:'أرسل البلاغ ←'},
  protecTitle:'كيف نحميك',
  protecs:['مراقبة AI 24/7 لكل عملية','تنبيه فوري عند اكتشاف نشاط مريب','تجميد تلقائي للعمليات المشبوهة','فريق تحقيق متخصص','استرداد أموال مؤكد خلال 14 يوم','تقرير للجهات المختصة'],
  ctaTitle:'حماية فورية',ctaSub:'فريقنا متاح 24/7. لا تتردد بالإبلاغ.',ctaPhone:'+45 XX XX XX XX',ctaEmail:'fraud@sdb-bank.com',
} : {
  title:'Report Fraud — SDB Bank',tag:'Report',
  heroH:'Noticed suspicious activity?',heroEm:'Report immediately.',
  heroP:'Our protection team is available 24/7. Report immediately and we\'ll take urgent action to protect your account.',
  urgentTitle:'Immediate Emergency Actions',
  urgents:[
    {ic:'❄️',t:'Freeze your card now',d:'Open app → Cards → Freeze. This prevents any additional transactions.'},
    {ic:'🔒',t:'Change your password',d:'Settings → Security → Change password. Choose a strong, unique password.'},
    {ic:'📞',t:'Call us immediately',d:'Fraud emergency line: +45 XX XX XX XX (available 24/7).'},
    {ic:'🚫',t:'Don\'t share any codes',d:'We never ask for OTP or passwords. Anyone who does = scammer.'},
  ],
  typesTitle:'Common Fraud Types',
  types:[
    {ic:'📧',t:'Phishing',d:'Email or message that looks like SDB asking for your data. Check the link — we only send from @sdb-bank.com.','signs':['Strange link','Asks sensitive data','Suspicious urgency']},
    {ic:'📱',t:'Vishing (Phone Scam)',d:'Someone calls claiming to be from the bank asking for OTP or password. We never call to request this data.','signs':['Asks for OTP','Rushes you','Threatens account closure']},
    {ic:'💳',t:'Card Data Theft',d:'Unauthorized use of your card data. Dynamic CVV protects you — but report to us immediately.','signs':['Transactions you didn\'t make','Unknown amounts','Strange websites']},
    {ic:'🎭',t:'Identity Theft',d:'Someone uses your identity to open accounts or request services. Always monitor your notifications.','signs':['Accounts you didn\'t open','Changes you didn\'t request','Strange notifications']},
  ],
  formTitle:'Report Form',
  formLabels:{type:'Fraud type',types:['Unauthorized withdrawal','Suspicious purchase','Phishing','Fake call','Identity theft','Other'],card:'Last 4 card digits',date:'Incident date',amount:'Amount (if any)',desc:'Describe what happened in detail',submit:'Submit report →'},
  protecTitle:'How we protect you',
  protecs:['24/7 AI monitoring of every transaction','Instant alert when suspicious activity detected','Auto-freeze suspicious transactions','Dedicated investigation team','Confirmed refund within 14 days','Report to relevant authorities'],
  ctaTitle:'Immediate Protection',ctaSub:'Our team is available 24/7. Don\'t hesitate to report.',ctaPhone:'+45 XX XX XX XX',ctaEmail:'fraud@sdb-bank.com',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>
<section class="sec sec-warn"><div class="sw"><h2 class="t2 tc t2-w">{{ t.urgentTitle }}</h2><div class="g4"><div v-for="u in t.urgents" :key="u.t" class="urg-c"><span class="urg-ic">{{ u.ic }}</span><h3 class="urg-t">{{ u.t }}</h3><p class="urg-d">{{ u.d }}</p></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.typesTitle }}</h2><div class="types"><div v-for="tp in t.types" :key="tp.t" class="type-c"><div class="type-hd"><span class="type-ic">{{ tp.ic }}</span><h3 class="type-t">{{ tp.t }}</h3></div><p class="type-d">{{ tp.d }}</p><div class="type-signs"><span v-for="s in tp.signs" :key="s" class="type-sign">⚠ {{ s }}</span></div></div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.formTitle }}</h2><form class="fraud-form" @submit.prevent><select v-model="formData.type" class="ff-inp"><option value="">{{ t.formLabels.type }}...</option><option v-for="ty in t.formLabels.types" :key="ty" :value="ty">{{ ty }}</option></select><div class="ff-row"><input v-model="formData.cardLast4" :placeholder="t.formLabels.card" class="ff-inp" maxlength="4"/><input v-model="formData.date" type="date" class="ff-inp"/></div><input v-model="formData.amount" :placeholder="t.formLabels.amount" class="ff-inp"/><textarea v-model="formData.desc" :placeholder="t.formLabels.desc" class="ff-inp ff-ta" rows="4"></textarea><button type="submit" class="ff-btn">{{ t.formLabels.submit }}</button></form></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.protecTitle }}</h2><div class="protec-g"><span v-for="p in t.protecs" :key="p" class="protec-i">🛡️ {{ p }}</span></div></div></section>
<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><div class="cta-row"><a :href="'tel:'+t.ctaPhone" class="cta-btn">📞 {{ t.ctaPhone }}</a><a :href="'mailto:'+t.ctaEmail" class="cta-btn2">📧 {{ t.ctaEmail }}</a></div></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#FEF2F2}.sec-warn{background:linear-gradient(135deg,#7F1D1D,#B91C1C,#DC2626);color:#fff;padding:80px 0}
.sec-sky{background:linear-gradient(135deg,#163300,#1a3d00,#9FE870);color:#fff;padding:100px 0}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 60px;background:linear-gradient(135deg,#7F1D1D,#B91C1C,#DC2626);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#FCA5A5}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto;line-height:1.8}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.urg-c{padding:24px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.1);border-radius:16px;backdrop-filter:blur(8px)}
.urg-ic{font-size:24px;display:block;margin-bottom:8px}.urg-t{font-size:14px;font-weight:800;color:#fff;margin-bottom:6px}.urg-d{font-size:12px;color:rgba(255,255,255,.5);line-height:1.7}
.types{display:grid;grid-template-columns:repeat(2,1fr);gap:16px}
.type-c{padding:28px;background:#fff;border:1px solid rgba(220,38,38,.06);border-radius:18px;border-right:3px solid #DC2626}
.rtl .type-c{border-right:none;border-left:3px solid #DC2626}
.type-hd{display:flex;align-items:center;gap:12px;margin-bottom:10px}
.type-ic{font-size:24px}.type-t{font-size:15px;font-weight:800;color:#7F1D1D}.type-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.7;margin-bottom:12px}
.type-signs{display:flex;gap:8px;flex-wrap:wrap}.type-sign{font-size:11px;font-weight:600;color:#B91C1C;background:rgba(220,38,38,.06);padding:4px 10px;border-radius:6px}
.fraud-form{max-width:600px;margin:0 auto;display:flex;flex-direction:column;gap:12px}
.ff-inp{padding:14px;border:1px solid rgba(220,38,38,.12);border-radius:12px;font-size:14px;font-family:inherit;outline:none;background:#fff;color:#163300}.ff-inp:focus{border-color:#DC2626}
.ff-row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.ff-ta{resize:vertical;min-height:100px}
.ff-btn{padding:16px;background:#DC2626;color:#fff;font-size:15px;font-weight:800;border:none;border-radius:12px;cursor:pointer;transition:all .2s;font-family:inherit}.ff-btn:hover{background:#B91C1C;transform:translateY(-1px)}
.protec-g{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;max-width:800px;margin:0 auto}
.protec-i{font-size:13px;font-weight:600;color:#163300;padding:14px;background:#F5F9F3;border-radius:12px;border:1px solid rgba(159,232,112,.08)}
.cta-row{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}
.cta-btn{display:inline-block;padding:16px 36px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
.cta-btn2{display:inline-block;padding:16px 36px;background:rgba(255,255,255,.1);color:#fff;font-size:15px;font-weight:600;border-radius:12px;text-decoration:none;border:1px solid rgba(255,255,255,.15);transition:all .2s}.cta-btn2:hover{background:rgba(255,255,255,.2)}
@media(max-width:768px){.g4,.types,.protec-g{grid-template-columns:1fr}.ff-row{grid-template-columns:1fr}}
</style>
