<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'الامتثال والتراخيص — SDB Bank',tag:'الامتثال',
  heroH:'شفافية كاملة.',heroEm:'ثقة مطلقة.',
  heroP:'SDB Bank ApS مسجّلة ومرخّصة في مملكة الدنمارك، خاضعة لرقابة الجهات المالية الأوروبية. نلتزم بأعلى معايير الامتثال والحوكمة.',
  regTitle:'التسجيل والترخيص',
  regs:[
    {ic:'🇩🇰',t:'تسجيل بالدنمارك',d:'SDB Bank ApS شركة مسجّلة في مملكة الدنمارك برقم CVR. تخضع للقانون الدنماركي والأوروبي.'},
    {ic:'🏛️',t:'رقابة مالية',d:'خاضعة لرقابة Finanstilsynet (هيئة الرقابة المالية الدنماركية). تقارير دورية وتفتيش منتظم.'},
    {ic:'🇪🇺',t:'معايير أوروبية',d:'ملتزمون بتوجيهات الاتحاد الأوروبي للخدمات المالية PSD2 وجميع القوانين ذات الصلة.'},
    {ic:'🏦',t:'ماستركارد',d:'عضو معتمد في شبكة Mastercard العالمية. بطاقاتنا مقبولة بأكثر من 90 مليون متجر.'},
  ],
  compTitle:'إطار الامتثال',
  compSections:[
    {t:'مكافحة غسل الأموال (AML)',items:['تحقق من هوية العميل (KYC) لجميع الحسابات','مراقبة مستمرة للعمليات المشبوهة','إبلاغ تلقائي عن العمليات المريبة (SAR)','تدريب دوري لفريق الامتثال','تقييم مخاطر العملاء بشكل مستمر','تعاون مع وحدات الاستخبارات المالية']},
    {t:'حماية البيانات (GDPR)',items:['الامتثال الكامل للائحة العامة لحماية البيانات','حق الوصول والتصحيح والحذف','مسؤول حماية بيانات (DPO) معيّن','تشفير كل البيانات الشخصية','سياسة خصوصية شفافة','إخطار بخروقات البيانات خلال 72 ساعة']},
    {t:'أمن المعلومات',items:['شهادة PCI DSS Level 1','معيار ISO 27001','اختبار اختراق دوري','فريق أمن سيبراني متخصص','خطة استمرارية أعمال','نسخ احتياطي متعدد المواقع']},
    {t:'حماية أموال العملاء',items:['فصل أموال العملاء عن أموال الشركة','إيداع في بنوك أوروبية معتمدة','تدقيق خارجي سنوي','تأمين على الودائع','شفافية كاملة في التقارير المالية','الامتثال لمتطلبات رأس المال']},
  ],
  partnersTitle:'شركاؤنا',
  partners:['Mastercard','SWIFT Network','SEPA','Finanstilsynet','Apple Pay','Google Pay'],
  reportTitle:'الإبلاغ والشفافية',
  reports:[
    {t:'التقرير السنوي',d:'تقرير سنوي شامل عن الأداء المالي والعمليات والحوكمة.'},
    {t:'تقارير الامتثال',d:'تقارير ربع سنوية للجهات الرقابية.'},
    {t:'سياسة الخصوصية',d:'سياسة شفافة ومفصّلة عن كيفية معالجة بياناتك.',href:'/privacy'},
    {t:'الشروط والأحكام',d:'شروط استخدام الخدمة بلغة واضحة ومفهومة.',href:'/terms'},
  ],
  ctaTitle:'ثقتك أولويتنا',ctaSub:'معايير أوروبية صارمة. شفافية كاملة.',ctaBtn:'افتح حسابك ←',
} : {
  title:'Compliance & Licensing — SDB Bank',tag:'Compliance',
  heroH:'Full transparency.',heroEm:'Absolute trust.',
  heroP:'SDB Bank ApS is registered and licensed in the Kingdom of Denmark, subject to European financial authority oversight. We adhere to the highest compliance and governance standards.',
  regTitle:'Registration & Licensing',
  regs:[
    {ic:'🇩🇰',t:'Danish Registration',d:'SDB Bank ApS is a company registered in the Kingdom of Denmark with CVR number. Subject to Danish and European law.'},
    {ic:'🏛️',t:'Financial Oversight',d:'Subject to Finanstilsynet (Danish Financial Supervisory Authority) oversight. Regular reporting and inspections.'},
    {ic:'🇪🇺',t:'European Standards',d:'Compliant with EU financial services directives PSD2 and all relevant regulations.'},
    {ic:'🏦',t:'Mastercard',d:'Certified member of the global Mastercard network. Our cards accepted at 90+ million merchants.'},
  ],
  compTitle:'Compliance Framework',
  compSections:[
    {t:'Anti-Money Laundering (AML)',items:['Customer identity verification (KYC) for all accounts','Continuous suspicious activity monitoring','Automatic Suspicious Activity Reports (SAR)','Regular compliance team training','Ongoing customer risk assessment','Cooperation with Financial Intelligence Units']},
    {t:'Data Protection (GDPR)',items:['Full GDPR compliance','Right to access, rectify, and delete','Designated Data Protection Officer (DPO)','All personal data encrypted','Transparent privacy policy','Data breach notification within 72 hours']},
    {t:'Information Security',items:['PCI DSS Level 1 certified','ISO 27001 standard','Regular penetration testing','Dedicated cybersecurity team','Business continuity plan','Multi-site backups']},
    {t:'Client Fund Protection',items:['Client funds segregated from company funds','Deposited in approved European banks','Annual external audit','Deposit insurance','Full financial transparency','Capital requirement compliance']},
  ],
  partnersTitle:'Our Partners',
  partners:['Mastercard','SWIFT Network','SEPA','Finanstilsynet','Apple Pay','Google Pay'],
  reportTitle:'Reporting & Transparency',
  reports:[
    {t:'Annual Report',d:'Comprehensive annual report on financial performance, operations, and governance.'},
    {t:'Compliance Reports',d:'Quarterly reports to regulatory authorities.'},
    {t:'Privacy Policy',d:'Transparent and detailed policy on how we handle your data.',href:'/privacy'},
    {t:'Terms of Service',d:'Terms of service in clear, understandable language.',href:'/terms'},
  ],
  ctaTitle:'Your trust is our priority',ctaSub:'Strict European standards. Full transparency.',ctaBtn:'Open your account →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.regTitle }}</h2><div class="g4"><div v-for="r in t.regs" :key="r.t" class="reg-c"><span class="reg-ic">{{ r.ic }}</span><h3 class="reg-t">{{ r.t }}</h3><p class="reg-d">{{ r.d }}</p></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.compTitle }}</h2><div class="g2"><div v-for="s in t.compSections" :key="s.t" class="comp-c"><h4 class="comp-ct">{{ s.t }}</h4><ul class="comp-list"><li v-for="i in s.items" :key="i">{{ i }}</li></ul></div></div></div></section>

<section class="sec"><div class="sw tc"><h2 class="t2">{{ t.partnersTitle }}</h2><div class="partners"><span v-for="p in t.partners" :key="p" class="partner-i">{{ p }}</span></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.reportTitle }}</h2><div class="g4"><component v-for="r in t.reports" :key="r.t" :is="r.href?'a':'div'" :href="r.href||undefined" class="rep-c"><h4 class="rep-t">{{ r.t }}</h4><p class="rep-d">{{ r.d }}</p></component></div></div></section>

<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F0F9FF}.sec-sky{background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 60px;background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.6);text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#7DD3FC}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:620px;margin:0 auto;line-height:1.8}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.g2{display:grid;grid-template-columns:repeat(2,1fr);gap:16px}
.reg-c{padding:28px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:18px;text-align:center}
.reg-ic{font-size:32px;display:block;margin-bottom:10px}.reg-t{font-size:15px;font-weight:800;color:#0C4A6E;margin-bottom:6px}.reg-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.comp-c{padding:28px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:18px}
.comp-ct{font-size:15px;font-weight:800;color:#0EA5E9;margin-bottom:14px;padding-bottom:10px;border-bottom:2px solid rgba(14,165,233,.1)}
.comp-list{list-style:none;padding:0;display:flex;flex-direction:column;gap:8px}.comp-list li{font-size:12.5px;color:rgba(10,10,10,.5);line-height:1.5;padding-left:16px;position:relative}.comp-list li::before{content:'✓';position:absolute;left:0;color:#0EA5E9;font-weight:700}
.rtl .comp-list li{padding-left:0;padding-right:16px}.rtl .comp-list li::before{left:auto;right:0}
.partners{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}.partner-i{font-size:15px;font-weight:800;color:#0C4A6E;padding:16px 28px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:14px}
.rep-c{padding:24px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:16px;text-decoration:none;color:inherit;display:block;transition:all .3s}.rep-c:hover{transform:translateY(-2px);box-shadow:0 8px 20px rgba(14,165,233,.06)}
.rep-t{font-size:14px;font-weight:800;color:#0C4A6E;margin-bottom:6px}.rep-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.7}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#0C4A6E;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.g4,.g2{grid-template-columns:1fr}}
</style>
