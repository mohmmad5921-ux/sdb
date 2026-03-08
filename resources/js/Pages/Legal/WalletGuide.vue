<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, ref, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'المحفظة الرقمية — SDB Bank',tag:'Apple Wallet & Google Wallet',
  heroH:'بطاقتك في جيبك.',heroEm:'دائماً.',
  heroP:'أضف بطاقة SDB Mastercard لمحفظة Apple Wallet أو Google Wallet وادفع بهاتفك في أي مكان بالعالم. بدون محفظة فعلية.',
  appleTitle:'Apple Wallet',appleSub:'لأجهزة iPhone و Apple Watch',
  appleSteps:[
    {n:'1',t:'افتح تطبيق SDB',d:'ادخل على تطبيق SDB Bank وتوجه لقسم البطاقات.'},
    {n:'2',t:'اضغط "أضف لـ Apple Wallet"',d:'ستظهر لك بيانات البطاقة. اضغط على زر Apple Wallet.'},
    {n:'3',t:'أكّد الإضافة',d:'تحقق من البيانات واضغط "إضافة". قد يُطلب تحقق إضافي.'},
    {n:'4',t:'جاهز! 🎉',d:'بطاقتك الآن بـ Apple Wallet. ادفع بقرّب هاتفك من جهاز الدفع.'},
  ],
  googleTitle:'Google Wallet',googleSub:'لأجهزة Android',
  googleSteps:[
    {n:'1',t:'افتح تطبيق SDB',d:'ادخل على تطبيق SDB Bank وتوجه لقسم البطاقات.'},
    {n:'2',t:'اضغط "أضف لـ Google Wallet"',d:'ستظهر لك بيانات البطاقة. اضغط على زر Google Wallet.'},
    {n:'3',t:'أكّد في Google Pay',d:'سيفتح تطبيق Google Pay. تحقق من البيانات وأكّد.'},
    {n:'4',t:'جاهز! 🎉',d:'بطاقتك الآن بـ Google Wallet. ادفع بقرّب هاتفك من جهاز الدفع.'},
  ],
  tipsTitle:'نصائح مهمة',
  tips:[
    {ic:'🔓',t:'فعّل Face ID / بصمة الإصبع',d:'لأمان أعلى، فعّل المصادقة البيومترية على هاتفك.'},
    {ic:'🌐',t:'يعمل بأي مكان',d:'ادفع بـ Apple Pay أو Google Pay بأي متجر يقبل الدفع اللاتلامسي.'},
    {ic:'🔔',t:'إشعارات فورية',d:'تصلك إشعارات لكل عملية دفع حتى من المحفظة الرقمية.'},
    {ic:'❄️',t:'تجميد من التطبيق',d:'جمّد بطاقتك من تطبيق SDB وتتجمد بالمحفظة الرقمية أيضاً.'},
    {ic:'⌚',t:'Apple Watch',d:'ادفع من ساعتك الذكية بدون حاجة لإخراج هاتفك.'},
    {ic:'🔄',t:'تحديث تلقائي',d:'أي تغيير على بطاقتك ينعكس تلقائياً على المحفظة الرقمية.'},
  ],
  ctaTitle:'احصل على بطاقتك الآن',ctaSub:'سجّل وأضف بطاقتك لمحفظتك الرقمية بدقائق.',ctaBtn:'سجّل الآن ←',
} : {
  title:'Digital Wallet — SDB Bank',tag:'Apple Wallet & Google Wallet',
  heroH:'Your card in your pocket.',heroEm:'Always.',
  heroP:'Add your SDB Mastercard to Apple Wallet or Google Wallet and pay with your phone anywhere in the world. No physical wallet needed.',
  appleTitle:'Apple Wallet',appleSub:'For iPhone & Apple Watch',
  appleSteps:[
    {n:'1',t:'Open SDB app',d:'Open SDB Bank app and go to the Cards section.'},
    {n:'2',t:'Tap "Add to Apple Wallet"',d:'Your card details will appear. Tap the Apple Wallet button.'},
    {n:'3',t:'Confirm',d:'Verify the details and tap "Add". Additional verification may be required.'},
    {n:'4',t:'Ready! 🎉',d:'Your card is now in Apple Wallet. Pay by holding your phone near the terminal.'},
  ],
  googleTitle:'Google Wallet',googleSub:'For Android devices',
  googleSteps:[
    {n:'1',t:'Open SDB app',d:'Open SDB Bank app and go to the Cards section.'},
    {n:'2',t:'Tap "Add to Google Wallet"',d:'Your card details will appear. Tap the Google Wallet button.'},
    {n:'3',t:'Confirm in Google Pay',d:'Google Pay will open. Verify your details and confirm.'},
    {n:'4',t:'Ready! 🎉',d:'Your card is now in Google Wallet. Pay by holding your phone near the terminal.'},
  ],
  tipsTitle:'Important Tips',
  tips:[
    {ic:'🔓',t:'Enable Face ID / Fingerprint',d:'For higher security, enable biometric authentication on your phone.'},
    {ic:'🌐',t:'Works everywhere',d:'Pay with Apple Pay or Google Pay at any store accepting contactless payments.'},
    {ic:'🔔',t:'Instant notifications',d:'Get notifications for every payment even from the digital wallet.'},
    {ic:'❄️',t:'Freeze from app',d:'Freeze your card from SDB app and it freezes in the digital wallet too.'},
    {ic:'⌚',t:'Apple Watch',d:'Pay from your smartwatch without taking out your phone.'},
    {ic:'🔄',t:'Auto-sync',d:'Any change to your card automatically reflects in the digital wallet.'},
  ],
  ctaTitle:'Get your card now',ctaSub:'Sign up and add your card to your digital wallet in minutes.',ctaBtn:'Sign up now →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<section class="sec"><div class="sw"><div class="wallet-sec"><div class="wallet-hdr"><span class="wallet-logo"></span><h2 class="t2">{{ t.appleTitle }}</h2><p class="wallet-sub">{{ t.appleSub }}</p></div><div class="steps"><div v-for="s in t.appleSteps" :key="s.n" class="step"><div class="step-n">{{ s.n }}</div><h3 class="step-t">{{ s.t }}</h3><p class="step-d">{{ s.d }}</p></div></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><div class="wallet-sec"><div class="wallet-hdr"><span class="wallet-logo wallet-logo-g"></span><h2 class="t2">{{ t.googleTitle }}</h2><p class="wallet-sub">{{ t.googleSub }}</p></div><div class="steps"><div v-for="s in t.googleSteps" :key="s.n" class="step"><div class="step-n">{{ s.n }}</div><h3 class="step-t">{{ s.t }}</h3><p class="step-d">{{ s.d }}</p></div></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.tipsTitle }}</h2><div class="feat-g"><div v-for="tip in t.tips" :key="tip.t" class="feat-c"><span class="feat-ic">{{ tip.ic }}</span><h4 class="feat-t">{{ tip.t }}</h4><p class="feat-d">{{ tip.d }}</p></div></div></div></section>

<section class="sec sec-dark tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="p-cta">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}
.sec{padding:100px 0}.sec-alt{background:#fafafa}.sec-dark{background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.tc{text-align:center}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:24px}.t2-w{color:#fff}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:500px}.t2-sub-w{color:rgba(255,255,255,.3)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff;text-align:center}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#7DD3FC;text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}
.p-hero-em{color:#7DD3FC}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.45);max-width:560px;margin:0 auto;line-height:1.8}
.p-cta{display:inline-block;padding:16px 44px;background:#fff;color:#0a0a0a;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.p-cta:hover{transform:translateY(-2px)}
.wallet-sec{max-width:900px;margin:0 auto}
.wallet-hdr{margin-bottom:32px}
.wallet-sub{font-size:14px;color:rgba(10,10,10,.35);margin-top:4px}
.steps{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.step{padding:28px 20px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:18px;text-align:center;transition:all .3s}.step:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.sec-alt .step{background:#fff}
.step-n{font-size:36px;font-weight:900;color:rgba(14,165,233,.1);margin-bottom:8px}
.step-t{font-size:14px;font-weight:800;margin-bottom:6px}
.step-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.7}
.feat-g{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.feat-c{padding:28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:18px;transition:all .3s}.feat-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.feat-ic{font-size:28px;display:block;margin-bottom:10px}
.feat-t{font-size:15px;font-weight:800;margin-bottom:6px}
.feat-d{font-size:13px;color:rgba(10,10,10,.35);line-height:1.75}
@media(max-width:768px){.steps,.feat-g{grid-template-columns:1fr 1fr}}
@media(max-width:500px){.steps,.feat-g{grid-template-columns:1fr}}
</style>
