<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'الهوية الرقمية — SDB Bank',tag:'Syria Digital ID',
  heroH:'هويتك الرقمية.',heroEm:'مستقبل سوريا.',
  heroP:'خدمة الهوية الرقمية السورية — تحقق من هويتك إلكترونياً بدون أوراق أو زيارة فرع. تقنية متقدمة تتيح لك إثبات هويتك بشكل آمن وسريع من أي مكان بالعالم.',
  whatTitle:'ما هي الهوية الرقمية؟',
  whatDesc:'Syria Digital ID هي خدمة تحقق رقمي متقدمة تتيح لك إثبات هويتك إلكترونياً. بدلاً من زيارة فرع أو إرسال أوراق، نستخدم تقنيات التعرف على الوجه ومسح الوثائق لتأكيد هويتك بثوانٍ.',
  stepsTitle:'كيف تعمل؟',
  steps:[
    {n:'01',ic:'📱',t:'حمّل التطبيق',d:'حمّل تطبيق SDB Bank على هاتفك وابدأ عملية التسجيل.'},
    {n:'02',ic:'🪪',t:'امسح هويتك',d:'صوّر بطاقة هويتك أو جواز سفرك. نظامنا يقرأ البيانات تلقائياً بتقنية OCR.'},
    {n:'03',ic:'🤳',t:'صورة سيلفي',d:'التقط صورة سيلفي حية. نظام التعرف على الوجه يطابق صورتك مع وثيقتك.'},
    {n:'04',ic:'✅',t:'تم التحقق!',d:'خلال دقائق — هويتك مؤكدة وحسابك جاهز بالكامل.'},
  ],
  featTitle:'مميزات الهوية الرقمية',
  feats:[
    {ic:'🚀',t:'سريع',d:'التحقق يتم خلال دقائق — بدل أيام بالبنوك التقليدية.'},
    {ic:'🌍',t:'من أي مكان',d:'سواء كنت بسوريا أو بأي دولة — تحقّق من هويتك عن بُعد.'},
    {ic:'🔐',t:'آمن بالكامل',d:'بياناتك مشفّرة بمعايير أوروبية. لا نشارك معلوماتك مع أي طرف ثالث.'},
    {ic:'📄',t:'بدون أوراق',d:'لا حاجة لطباعة أو إرسال أي مستندات. كل شيء رقمي.'},
    {ic:'🤖',t:'ذكاء اصطناعي',d:'تقنيات AI متقدمة للتعرف على الوجه ومسح الوثائق بدقة عالية.'},
    {ic:'🔄',t:'تحديث سهل',d:'حدّث بياناتك أو وثائقك بأي وقت من التطبيق مباشرة.'},
  ],
  docsTitle:'الوثائق المقبولة',
  docs:['🪪 بطاقة هوية وطنية','📘 جواز سفر سوري','📗 جواز سفر أجنبي','🏠 إثبات إقامة','📋 رخصة قيادة'],
  futureTitle:'خدمة المستقبل.',
  futureFade:'قريباً.',
  futureDesc:'نعمل على تطوير خدمة الهوية الرقمية لتشمل المزيد من الخدمات الحكومية والخاصة. هدفنا أن تكون هويتك الرقمية جواز سفرك المالي الشامل.',
  futureItems:['🏛️ خدمات حكومية رقمية','📋 توقيع عقود إلكترونياً','🏥 سجلات صحية رقمية','🎓 شهادات أكاديمية رقمية'],
  ctaTitle:'ابدأ التحقق الآن',ctaSub:'افتح حسابك وتحقق من هويتك بدقائق — بدون أوراق.',ctaBtn:'ابدأ الآن ←',
} : {
  title:'Digital ID — SDB Bank',tag:'Syria Digital ID',
  heroH:'Your digital ID.',heroEm:'Syria\'s future.',
  heroP:'Syria Digital ID — verify your identity digitally without paperwork or branch visits. Advanced technology that lets you prove your identity securely and quickly from anywhere in the world.',
  whatTitle:'What is Digital ID?',
  whatDesc:'Syria Digital ID is an advanced digital verification service that lets you prove your identity electronically. Instead of branch visits or mailing documents, we use facial recognition and document scanning to confirm your identity in seconds.',
  stepsTitle:'How it works',
  steps:[
    {n:'01',ic:'📱',t:'Download the app',d:'Download SDB Bank app and start the registration process.'},
    {n:'02',ic:'🪪',t:'Scan your ID',d:'Photograph your ID card or passport. Our OCR system reads data automatically.'},
    {n:'03',ic:'🤳',t:'Take a selfie',d:'Take a live selfie. Facial recognition matches your face to your document.'},
    {n:'04',ic:'✅',t:'Verified!',d:'Within minutes — your identity is confirmed and account fully ready.'},
  ],
  featTitle:'Digital ID Features',
  feats:[
    {ic:'🚀',t:'Fast',d:'Verification in minutes — instead of days at traditional banks.'},
    {ic:'🌍',t:'From anywhere',d:'Whether in Syria or abroad — verify your identity remotely.'},
    {ic:'🔐',t:'Fully secure',d:'Data encrypted to European standards. Never shared with third parties.'},
    {ic:'📄',t:'No paperwork',d:'No need to print or send any documents. Everything is digital.'},
    {ic:'🤖',t:'AI-powered',d:'Advanced AI for facial recognition and high-accuracy document scanning.'},
    {ic:'🔄',t:'Easy updates',d:'Update your data or documents anytime directly from the app.'},
  ],
  docsTitle:'Accepted Documents',
  docs:['🪪 National ID card','📘 Syrian passport','📗 Foreign passport','🏠 Proof of residence','📋 Driving license'],
  futureTitle:'The future service.',
  futureFade:'Coming soon.',
  futureDesc:'We\'re developing Digital ID to include more government and private services. Our goal is for your digital identity to be your comprehensive financial passport.',
  futureItems:['🏛️ Government e-services','📋 Electronic contract signing','🏥 Digital health records','🎓 Digital academic certificates'],
  ctaTitle:'Start verification now',ctaSub:'Open your account and verify your identity in minutes — no paperwork.',ctaBtn:'Start now →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>
<section class="sec"><div class="sw ab-box"><h2 class="t2">{{ t.whatTitle }}</h2><p class="ab-desc">{{ t.whatDesc }}</p></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.stepsTitle }}</h2><div class="steps"><div v-for="s in t.steps" :key="s.n" class="step"><div class="step-n">{{ s.n }}</div><div class="step-ic">{{ s.ic }}</div><h3 class="step-t">{{ s.t }}</h3><p class="step-d">{{ s.d }}</p></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.featTitle }}</h2><div class="feat-g"><div v-for="f in t.feats" :key="f.t" class="feat-c"><span class="feat-ic">{{ f.ic }}</span><h4 class="feat-t">{{ f.t }}</h4><p class="feat-d">{{ f.d }}</p></div></div></div></section>
<section class="sec sec-alt"><div class="sw tc"><h2 class="t2">{{ t.docsTitle }}</h2><div class="docs-g"><div v-for="d in t.docs" :key="d" class="doc-c">{{ d }}</div></div></div></section>
<section class="sec sec-dark"><div class="sw"><h2 class="t2 t2-w">{{ t.futureTitle }}<br><span class="t2-em-w">{{ t.futureFade }}</span></h2><p class="t2-sub t2-sub-w">{{ t.futureDesc }}</p><div class="soon-g"><div v-for="f in t.futureItems" :key="f" class="soon-i">{{ f }}</div></div></div></section>
<section class="sec tc"><div class="sw"><h2 class="t2">{{ t.ctaTitle }}</h2><p class="t2-sub tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="p-cta">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}
.sec{padding:100px 0}.sec-alt{background:#fafafa}.sec-dark{background:#0a0a0a;color:#fff}
.tc{text-align:center}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:24px}.t2-w{color:#fff}.t2-em-w{color:#60A5FA}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px;margin-bottom:32px}.t2-sub-w{color:rgba(255,255,255,.3)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#0a0a0a 0%,#1a1a3e 100%);color:#fff;text-align:center}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#60A5FA;text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}
.p-hero-em{color:#60A5FA}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.45);max-width:600px;margin:0 auto;line-height:1.8}
.p-cta{display:inline-block;padding:16px 44px;background:#0a0a0a;color:#fff;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.p-cta:hover{transform:translateY(-2px)}
.ab-box{max-width:700px}
.ab-desc{font-size:16px;color:rgba(10,10,10,.45);line-height:1.9}
.steps{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.step{padding:32px 20px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;text-align:center;transition:all .3s}.step:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(0,0,0,.05)}
.step-n{font-size:40px;font-weight:900;color:rgba(37,99,235,.08);line-height:1;margin-bottom:6px}
.step-ic{font-size:32px;margin-bottom:10px}
.step-t{font-size:15px;font-weight:800;margin-bottom:6px}
.step-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.7}
.feat-g{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.feat-c{padding:28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:18px;transition:all .3s}.feat-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.feat-ic{font-size:28px;display:block;margin-bottom:10px}
.feat-t{font-size:15px;font-weight:800;margin-bottom:6px}
.feat-d{font-size:13px;color:rgba(10,10,10,.35);line-height:1.75}
.docs-g{display:flex;flex-wrap:wrap;gap:12px;justify-content:center}
.doc-c{padding:16px 24px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:12px;font-size:14px;font-weight:600;transition:all .3s}.doc-c:hover{border-color:rgba(37,99,235,.15)}
.soon-g{display:grid;grid-template-columns:repeat(2,1fr);gap:12px;margin-top:24px}
.soon-i{padding:18px 24px;background:rgba(255,255,255,.04);border:1px solid rgba(255,255,255,.06);border-radius:12px;font-size:14px;font-weight:600;color:rgba(255,255,255,.5)}
@media(max-width:768px){.steps{grid-template-columns:repeat(2,1fr)}.feat-g{grid-template-columns:1fr}.soon-g{grid-template-columns:1fr}}
</style>
