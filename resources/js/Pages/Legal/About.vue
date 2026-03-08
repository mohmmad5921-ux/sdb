<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'عنّا — SDB Bank',tag:'من نحن',
  heroH:'ولدنا من رحم',heroEm:'المعاناة.',
  heroP:'سوريون بالدنمارك حلموا ببنك يخدم كل سوري. بعد سنوات من الحرب والتأخر التكنولوجي في القطاع المالي السوري، قررنا نسد الفجوة بتكنولوجيا أوروبية وروح سورية.',
  missionTitle:'مهمتنا',
  missionDesc:'تقديم تجربة بنكية رقمية شاملة لكل سوري بالعالم. نجمع بين أعلى معايير الأمان الأوروبية وسهولة الاستخدام، لنجعل الخدمات البنكية متاحة للجميع بغض النظر عن موقعهم — سواء كانوا بدمشق أو برلين.',
  visionTitle:'رؤيتنا',
  visionFade:'بنك بلا حدود.',
  visionDesc:'أن نكون البنك الرقمي الأول والأكبر لكل سوري بالعالم. بنك يكسر الحواجز الجغرافية والبيروقراطية ويقدم خدمات مالية بمعايير عالمية.',
  valuesTitle:'قيمنا',
  values:[
    {ic:'🔒',t:'الأمان أولاً',d:'نستخدم تشفير AES-256 ومصادقة بيومترية متقدمة لحماية أصول وبيانات عملائنا على مدار الساعة.'},
    {ic:'⚡',t:'السرعة والكفاءة',d:'تحويلات فورية 24/7، إصدار بطاقات فوري، وفتح حساب بدقائق.'},
    {ic:'🌍',t:'بنك بلا حدود',d:'حسابات متعددة العملات، تحويلات دولية SWIFT، وبطاقات مقبولة بأكثر من 150 دولة.'},
    {ic:'💡',t:'ابتكار مستمر',d:'نطوّر خدماتنا باستمرار لتلبية احتياجات عملائنا المتغيرة بأحدث التقنيات المالية.'},
    {ic:'🤝',t:'شفافية كاملة',d:'لا رسوم مخفية، لا مفاجآت. كل شي واضح وشفاف من اليوم الأول.'},
    {ic:'🎯',t:'العميل أولاً',d:'كل قرار نتخذه يبدأ من سؤال واحد: كيف نخدم عملاءنا بشكل أفضل؟'},
  ],
  diffTitle:'ما يميّزنا',
  diffs:[
    {ic:'💳',t:'بطاقات ماستركارد',d:'افتراضية ومعدنية فورية'},
    {ic:'💱',t:'صرف عملات',d:'أسعار سوق حقيقية'},
    {ic:'🔔',t:'إشعارات فورية',d:'لكل عملية'},
    {ic:'📊',t:'تحليلات مالية',d:'ذكاء اصطناعي'},
    {ic:'🪪',t:'تحقق رقمي',d:'KYC بدون أوراق'},
    {ic:'🎧',t:'دعم 24/7',d:'فريق متخصص دائماً'},
  ],
  compTitle:'الامتثال والتراخيص',
  comps:['مسجّلة في الدنمارك كشركة خدمات مالية','ملتزمة بمعايير مكافحة غسل الأموال الأوروبية AML/CFT','حاصلة على شهادة أمن المعلومات ISO 27001','متوافقة مع اللائحة العامة لحماية البيانات GDPR'],
  contactTitle:'تواصل معنا',
  contactItems:[{ic:'📧',t:'البريد الإلكتروني',d:'info@sdb-bank.com'},{ic:'📞',t:'الهاتف',d:'+45 42 80 55 94'},{ic:'📍',t:'الموقع',d:'الدنمارك 🇩🇰'}],
  ctaTitle:'انضم لعائلة SDB',ctaSub:'كن من أوائل المستخدمين وافتح حسابك المجاني.',ctaBtn:'سجّل الآن ←',
} : {
  title:'About — SDB Bank',tag:'About Us',
  heroH:'Born from',heroEm:'struggle.',
  heroP:'Syrians in Denmark dreamed of a bank that serves every Syrian. After years of war and technological lag in Syria\'s financial sector, we decided to bridge the gap with European technology and a Syrian soul.',
  missionTitle:'Our Mission',
  missionDesc:'To provide a comprehensive digital banking experience for every Syrian worldwide. We combine the highest European security standards with ease of use, making banking accessible to everyone regardless of location — whether in Damascus or Berlin.',
  visionTitle:'Our Vision',
  visionFade:'Banking without borders.',
  visionDesc:'To be the first and largest digital bank for every Syrian worldwide. A bank that breaks geographic and bureaucratic barriers and delivers world-class financial services.',
  valuesTitle:'Our Values',
  values:[
    {ic:'🔒',t:'Security First',d:'AES-256 encryption and advanced biometric authentication to protect assets around the clock.'},
    {ic:'⚡',t:'Speed & Efficiency',d:'Instant 24/7 transfers, instant card issuance, account opening in minutes.'},
    {ic:'🌍',t:'Borderless Banking',d:'Multi-currency accounts, SWIFT transfers, cards accepted in 150+ countries.'},
    {ic:'💡',t:'Continuous Innovation',d:'Constantly evolving to meet changing needs with the latest fintech.'},
    {ic:'🤝',t:'Full Transparency',d:'No hidden fees, no surprises. Everything clear from day one.'},
    {ic:'🎯',t:'Customer First',d:'Every decision starts with one question: how do we serve our customers better?'},
  ],
  diffTitle:'What Sets Us Apart',
  diffs:[
    {ic:'💳',t:'Mastercard Cards',d:'Instant virtual & physical'},
    {ic:'💱',t:'Currency Exchange',d:'Real market rates'},
    {ic:'🔔',t:'Instant Notifications',d:'For every transaction'},
    {ic:'📊',t:'Financial Analytics',d:'AI-powered insights'},
    {ic:'🪪',t:'Digital KYC',d:'No paperwork needed'},
    {ic:'🎧',t:'24/7 Support',d:'Dedicated team always'},
  ],
  compTitle:'Compliance & Licensing',
  comps:['Registered in Denmark as a financial services company','Compliant with European AML/CFT standards','ISO 27001 information security certified','GDPR compliant'],
  contactTitle:'Contact Us',
  contactItems:[{ic:'📧',t:'Email',d:'info@sdb-bank.com'},{ic:'📞',t:'Phone',d:'+45 42 80 55 94'},{ic:'📍',t:'Location',d:'Denmark 🇩🇰'}],
  ctaTitle:'Join the SDB family',ctaSub:'Be among the first users and open your free account.',ctaBtn:'Sign up now →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<section class="sec"><div class="sw ab-split"><div><h2 class="t2">{{ t.missionTitle }}</h2><p class="ab-desc">{{ t.missionDesc }}</p></div><div><h2 class="t2">{{ t.visionTitle }}<br><span class="t2-em">{{ t.visionFade }}</span></h2><p class="ab-desc">{{ t.visionDesc }}</p></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.valuesTitle }}</h2><div class="val-g"><div v-for="v in t.values" :key="v.t" class="val-c"><span class="val-ic">{{ v.ic }}</span><h3 class="val-t">{{ v.t }}</h3><p class="val-d">{{ v.d }}</p></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.diffTitle }}</h2><div class="diff-g"><div v-for="d in t.diffs" :key="d.t" class="diff-c"><span class="diff-ic">{{ d.ic }}</span><div><div class="diff-t">{{ d.t }}</div><div class="diff-d">{{ d.d }}</div></div></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><div class="comp-box"><h2 class="t2">✅ {{ t.compTitle }}</h2><ul class="comp-list"><li v-for="c in t.comps" :key="c"><span class="comp-ck">✓</span>{{ c }}</li></ul></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.contactTitle }}</h2><div class="contact-g"><div v-for="c in t.contactItems" :key="c.t" class="contact-c"><span class="contact-ic">{{ c.ic }}</span><div class="contact-t">{{ c.t }}</div><div class="contact-d">{{ c.d }}</div></div></div></div></section>

<section class="sec sec-dark tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="p-cta">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}
.sec{padding:100px 0}.sec-alt{background:#fafafa}.sec-dark{background:#0a0a0a;color:#fff}
.tc{text-align:center}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:24px}.t2-w{color:#fff}.t2-em{color:#2563EB}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:500px}.t2-sub-w{color:rgba(255,255,255,.3)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#0a0a0a 0%,#162d4d 100%);color:#fff;text-align:center}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#60A5FA;text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}
.p-hero-em{color:#60A5FA}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.45);max-width:600px;margin:0 auto;line-height:1.8}
.p-cta{display:inline-block;padding:16px 44px;background:#fff;color:#0a0a0a;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.p-cta:hover{transform:translateY(-2px)}
.ab-split{display:grid;grid-template-columns:1fr 1fr;gap:64px}
.ab-desc{font-size:15px;color:rgba(10,10,10,.45);line-height:1.9}
.val-g{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.val-c{padding:32px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;transition:all .3s}.val-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.val-ic{font-size:32px;display:block;margin-bottom:14px}
.val-t{font-size:16px;font-weight:800;margin-bottom:8px}
.val-d{font-size:13px;color:rgba(10,10,10,.4);line-height:1.75}
.diff-g{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.diff-c{display:flex;align-items:center;gap:14px;padding:18px 20px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:14px;transition:all .3s}.diff-c:hover{border-color:rgba(37,99,235,.2);transform:translateY(-2px)}
.diff-ic{font-size:24px}
.diff-t{font-size:14px;font-weight:800}
.diff-d{font-size:11px;color:rgba(10,10,10,.35)}
.comp-box{max-width:700px;margin:0 auto;padding:40px;background:#fff;border:2px solid rgba(16,185,129,.15);border-radius:20px}
.comp-list{list-style:none;padding:0;display:flex;flex-direction:column;gap:14px;margin-top:16px}
.comp-list li{font-size:14px;color:rgba(10,10,10,.6);display:flex;align-items:flex-start;gap:10px}
.comp-ck{color:#10B981;font-weight:800;font-size:16px}
.contact-g{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.contact-c{padding:28px;text-align:center;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px}
.contact-ic{font-size:28px;display:block;margin-bottom:10px}
.contact-t{font-size:14px;font-weight:800;margin-bottom:4px}
.contact-d{font-size:13px;color:rgba(10,10,10,.4)}
@media(max-width:768px){.ab-split,.val-g,.diff-g,.contact-g{grid-template-columns:1fr}}
</style>
