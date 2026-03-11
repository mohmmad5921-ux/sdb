<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'الأمان والحماية — SDB Bank',tag:'الأمان',
  heroH:'أموالك محمية.',heroEm:'بأعلى المعايير.',
  heroP:'نستخدم نفس تقنيات الحماية المعتمدة في أكبر البنوك العالمية. بياناتك وأموالك محمية بمعايير أوروبية صارمة.',
  layers:[
    {ic:'🔐',t:'تشفير AES-256',d:'أعلى مستوى تشفير متاح — المستوى العسكري. كل بياناتك مشفّرة أثناء النقل والتخزين. المفاتيح تتغير دورياً باستخدام HSM.',detail:['تشفير طرف لطرف (E2E)','شهادات TLS 1.3','Hardware Security Modules (HSM)','تدوير المفاتيح التلقائي']},
    {ic:'👆',t:'مصادقة بيومترية',d:'افتح التطبيق وأكّد العمليات بالبصمة أو التعرف على الوجه. لا أحد غيرك يقدر يوصل لحسابك.',detail:['Face ID / Face Recognition','Touch ID / Fingerprint','PIN كنسخة احتياطية','قفل تلقائي بعد الخمول']},
    {ic:'🔄',t:'CVV ديناميكي',d:'رمز الأمان (CVV) يتغير تلقائياً كل ساعة. حتى لو سرق رقم بطاقتك، الـ CVV صار غير صالح.',detail:['يتغير كل 60 دقيقة','يظهر فقط بالتطبيق','حماية من السرقة الإلكترونية','لا CVV ثابت أبداً']},
    {ic:'❄️',t:'تجميد فوري للبطاقة',d:'فقدت بطاقتك؟ جمّدها فوراً من التطبيق بضغطة واحدة. ألغِ التجميد بنفس السهولة.',detail:['تجميد/إلغاء فوري','حظر أنواع محددة من العمليات','إلغاء البطاقة نهائياً','طلب بطاقة بديلة فورية']},
    {ic:'🛡️',t:'3D Secure',d:'طبقة حماية إضافية عند الدفع إلكترونياً. يتطلب تأكيدك من التطبيق قبل إتمام أي عملية.',detail:['موافقة من التطبيق','تنبيه فوري لكل عملية','رفض تلقائي للعمليات المشبوهة','متوافق مع جميع المتاجر']},
    {ic:'🤖',t:'ذكاء اصطناعي لكشف الاحتيال',d:'نظامنا يراقب كل العمليات 24/7. يكشف الأنماط المشبوهة فوراً ويحمي حسابك قبل حدوث الضرر.',detail:['مراقبة لحظية 24/7/365','تعلم آلي متطور','تنبيه فوري SMS + إشعار','حظر تلقائي للعمليات المريبة']},
    {ic:'🔑',t:'مصادقة ثنائية (2FA)',d:'طبقة أمان إضافية بكل عملية حساسة — تحويلات كبيرة، تغيير كلمة المرور، إضافة مستفيد جديد.',detail:['رمز OTP عبر SMS','إشعار تأكيد بالتطبيق','مفتاح TOTP','حماية كل العمليات الحساسة']},
    {ic:'📋',t:'حماية المشتريات',d:'حماية تصل لـ €10,000 على مشترياتك حسب مستوى بطاقتك. منتج تالف؟ لم يصل؟ نحميك.',detail:['تغطية حتى €10,000','بضاعة تالفة أو لم تصل','استرداد خلال 30 يوم','حماية عالمية']},
  ],
  compTitle:'أعلى معايير الحماية',
  compRows:[
    {f:'تشفير البيانات',us:'AES-256 + TLS 1.3',them:'AES-128 أو أقل'},
    {f:'CVV ديناميكي',us:'✅ كل ساعة',them:'❌ ثابت'},
    {f:'مراقبة احتيال AI',us:'✅ 24/7',them:'محدود'},
    {f:'تجميد فوري',us:'✅ من التطبيق',them:'اتصل بالبنك'},
    {f:'3D Secure',us:'✅ تلقائي',them:'حسب البنك'},
    {f:'مصادقة بيومترية',us:'✅ Face ID + بصمة',them:'PIN فقط'},
  ],
  tipsTitle:'نصائح أمان',
  tips:[
    {ic:'🔒',t:'لا تشارك بياناتك',d:'لن نطلب منك أبداً كلمة المرور أو الـ PIN عبر الهاتف أو البريد.'},
    {ic:'📱',t:'حدّث التطبيق دائماً',d:'تأكد من تحديث التطبيق لآخر إصدار للحصول على أحدث ميزات الأمان.'},
    {ic:'🔔',t:'فعّل الإشعارات',d:'إشعارات فورية لكل عملية تساعدك بكشف أي نشاط غير مأذون فوراً.'},
    {ic:'❄️',t:'جمّد إذا شككت',d:'شاكك بنشاط مريب؟ جمّد بطاقتك فوراً من التطبيق ثم تواصل معنا.'},
  ],
  certTitle:'شهادات وتراخيص',
  certs:['🇩🇰 مرخّص في الدنمارك','🇪🇺 GDPR متوافق','🔒 PCI DSS Level 1','📋 ISO 27001','🏦 Mastercard معتمد','🛡️ AML/KYC ملتزم'],
  ctaTitle:'أموالك بأمان معنا',ctaSub:'أعلى معايير الحماية الأوروبية. 24/7.',ctaBtn:'افتح حسابك الآمن ←',ctaBtn2:'إبلاغ عن احتيال',
} : {
  title:'Security & Protection — SDB Bank',tag:'Security',
  heroH:'Your money is protected.',heroEm:'Highest standards.',
  heroP:'We use the same security technologies trusted by the world\'s largest banks. Your data and money are protected by strict European standards.',
  layers:[
    {ic:'🔐',t:'AES-256 Encryption',d:'Highest available encryption — military grade. All data encrypted in transit and at rest. Keys rotated regularly using HSM.',detail:['End-to-end encryption (E2E)','TLS 1.3 certificates','Hardware Security Modules (HSM)','Automatic key rotation']},
    {ic:'👆',t:'Biometric Authentication',d:'Unlock the app and confirm transactions with fingerprint or facial recognition. Only you can access your account.',detail:['Face ID / Face Recognition','Touch ID / Fingerprint','PIN as fallback','Auto-lock on idle']},
    {ic:'🔄',t:'Dynamic CVV',d:'Security code changes automatically every hour. Even if your card number is stolen, the CVV is already invalid.',detail:['Changes every 60 minutes','Only visible in app','Protects against online theft','Never a static CVV']},
    {ic:'❄️',t:'Instant Card Freeze',d:'Lost your card? Freeze it instantly from the app with one tap. Unfreeze just as easily.',detail:['Instant freeze/unfreeze','Block specific transaction types','Permanently cancel card','Request instant replacement']},
    {ic:'🛡️',t:'3D Secure',d:'Extra protection layer for online payments. Requires your confirmation from the app before completing any transaction.',detail:['In-app approval','Instant notification for every transaction','Auto-reject suspicious transactions','Compatible with all merchants']},
    {ic:'🤖',t:'AI Fraud Detection',d:'Our system monitors all transactions 24/7. Detects suspicious patterns instantly and protects your account before damage occurs.',detail:['Real-time 24/7/365 monitoring','Advanced machine learning','Instant SMS + push alert','Auto-block suspicious activity']},
    {ic:'🔑',t:'Two-Factor Auth (2FA)',d:'Extra security layer on every sensitive operation — large transfers, password changes, adding new beneficiaries.',detail:['SMS OTP code','In-app confirmation push','TOTP key support','Protects all sensitive operations']},
    {ic:'📋',t:'Purchase Protection',d:'Protection up to €10,000 on your purchases depending on your card tier. Damaged product? Didn\'t arrive? We protect you.',detail:['Coverage up to €10,000','Damaged or undelivered goods','Refund within 30 days','Worldwide protection']},
  ],
  compTitle:'Highest protection standards',
  compRows:[
    {f:'Data encryption',us:'AES-256 + TLS 1.3',them:'AES-128 or lower'},
    {f:'Dynamic CVV',us:'✅ Every hour',them:'❌ Static'},
    {f:'AI fraud monitoring',us:'✅ 24/7',them:'Limited'},
    {f:'Instant freeze',us:'✅ From app',them:'Call the bank'},
    {f:'3D Secure',us:'✅ Automatic',them:'Varies'},
    {f:'Biometric auth',us:'✅ Face ID + fingerprint',them:'PIN only'},
  ],
  tipsTitle:'Security Tips',
  tips:[
    {ic:'🔒',t:'Never share your data',d:'We will never ask for your password or PIN via phone or email.'},
    {ic:'📱',t:'Keep app updated',d:'Always update to the latest version for the newest security features.'},
    {ic:'🔔',t:'Enable notifications',d:'Instant notifications for every transaction help you detect unauthorized activity immediately.'},
    {ic:'❄️',t:'Freeze if in doubt',d:'Suspicious activity? Freeze your card instantly from the app, then contact us.'},
  ],
  certTitle:'Certifications & Licenses',
  certs:['🇩🇰 Licensed in Denmark','🇪🇺 GDPR Compliant','🔒 PCI DSS Level 1','📋 ISO 27001','🏦 Mastercard Certified','🛡️ AML/KYC Compliant'],
  ctaTitle:'Your money is safe with us',ctaSub:'Highest European protection standards. 24/7.',ctaBtn:'Open your secure account →',ctaBtn2:'Report fraud',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<section class="sec"><div class="sw"><div class="layers"><div v-for="l in t.layers" :key="l.t" class="layer"><div class="layer-main"><span class="layer-ic">{{ l.ic }}</span><div class="layer-txt"><h3 class="layer-t">{{ l.t }}</h3><p class="layer-d">{{ l.d }}</p></div></div><div class="layer-details"><span v-for="d in l.detail" :key="d" class="layer-det">{{ d }}</span></div></div></div></div></section>

<section class="sec sec-sky"><div class="sw"><h2 class="t2 t2-w tc">{{ t.compTitle }}</h2><div class="comp-tbl"><div v-for="r in t.compRows" :key="r.f" class="comp-row"><div class="comp-f">{{ r.f }}</div><div class="comp-us">{{ r.us }}</div><div class="comp-them">{{ r.them }}</div></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.tipsTitle }}</h2><div class="g4"><div v-for="tp in t.tips" :key="tp.t" class="tip-c"><span class="tip-ic">{{ tp.ic }}</span><h4 class="tip-t">{{ tp.t }}</h4><p class="tip-d">{{ tp.d }}</p></div></div></div></section>

<section class="sec sec-alt"><div class="sw tc"><h2 class="t2">{{ t.certTitle }}</h2><div class="certs"><span v-for="c in t.certs" :key="c" class="cert-i">{{ c }}</span></div></div></section>

<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><div class="cta-row"><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a><Link href="/support" class="cta-btn2">{{ t.ctaBtn2 }}</Link></div></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F9F3}.sec-sky{background:linear-gradient(135deg,#163300,#1a3d00,#0f2600);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px;color:#163300}.t2-w{color:#fff}
.t2-sub{font-size:16px;color:#666;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.5)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#163300,#1a3d00,#0f2600);color:#fff;position:relative;overflow:hidden}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#9FE870;text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}.p-hero-em{color:#9FE870}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:600px;margin:0 auto;line-height:1.8}
.layers{display:flex;flex-direction:column;gap:16px}
.layer{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.1);border-radius:18px;transition:all .3s}.layer:hover{box-shadow:0 8px 24px rgba(159,232,112,.08);border-color:rgba(159,232,112,.3)}
.layer-main{display:flex;gap:20px;align-items:flex-start;margin-bottom:16px}
.layer-ic{font-size:32px;flex-shrink:0}.layer-t{font-size:16px;font-weight:800;color:#163300;margin-bottom:6px}.layer-d{font-size:13px;color:#666;line-height:1.75}
.layer-details{display:flex;gap:8px;flex-wrap:wrap}.layer-det{font-size:11px;font-weight:600;color:#2D6A00;background:rgba(159,232,112,.12);padding:5px 12px;border-radius:6px}
.comp-tbl{border:1px solid rgba(255,255,255,.1);border-radius:16px;overflow:hidden}
.comp-row{display:grid;grid-template-columns:1fr 1fr 1fr;border-bottom:1px solid rgba(255,255,255,.06)}
.comp-row:last-child{border:none}
.comp-f{padding:14px 20px;font-size:13px;font-weight:700;color:#fff}.comp-us{padding:14px 20px;font-size:13px;color:#9FE870;font-weight:600;text-align:center;background:rgba(255,255,255,.03)}.comp-them{padding:14px 20px;font-size:13px;color:rgba(255,255,255,.3);text-align:center}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.tip-c{padding:24px;background:#fff;border:1px solid rgba(159,232,112,.1);border-radius:16px;text-align:center;transition:all .3s}.tip-c:hover{border-color:rgba(159,232,112,.3);transform:translateY(-3px)}
.tip-ic{font-size:28px;display:block;margin-bottom:10px}.tip-t{font-size:14px;font-weight:800;color:#163300;margin-bottom:6px}.tip-d{font-size:12px;color:#666;line-height:1.7}
.certs{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}.cert-i{font-size:14px;font-weight:700;color:#163300;background:#fff;padding:12px 20px;border-radius:12px;border:1px solid rgba(159,232,112,.15);transition:all .2s}.cert-i:hover{border-color:#9FE870}
.cta-row{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}
.cta-btn{display:inline-block;padding:16px 44px;background:#9FE870;color:#163300;font-size:15px;font-weight:800;border-radius:999px;text-decoration:none;transition:all .2s;box-shadow:0 4px 16px rgba(159,232,112,.3)}.cta-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(159,232,112,.4)}
.cta-btn2{display:inline-block;padding:16px 44px;background:transparent;color:#fff;font-size:15px;font-weight:800;border-radius:999px;text-decoration:none;border:2px solid rgba(255,255,255,.2);transition:all .2s}.cta-btn2:hover{border-color:rgba(255,255,255,.5)}
@media(max-width:768px){.g4{grid-template-columns:repeat(2,1fr)}.comp-row{grid-template-columns:1fr}.comp-us,.comp-them{text-align:start}.layer-main{flex-direction:column}}
</style>
