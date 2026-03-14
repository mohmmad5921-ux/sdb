<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'حساب Plus — SDB Bank',tag:'Plus · الأكثر طلباً',
  heroH:'حساب Plus.',heroEm:'عمولات أقل. مميزات أكثر.',
  heroP:'كل مميزات Personal بعمولات أقل بكثير، كاشباك 1% على كل مشترياتك، ودعم أولوية.',
  price:'€19.99',priceNote:'/شهر',
  heroBtn:'احصل على Plus ←',
  inclTitle:'كل شيء في Personal + أكثر',
  incl:['5 بطاقات Mastercard (افتراضية + فعلية)','5 حسابات','عمولة تحويل 1.5% (بدل 2.5%)','عمولة إيداع 1% (بدل 2%)','صرف عملات +1.5% (بدل +3%)','تداول كريبتو 1% (بدل 2%)','كاشباك 1% على كل المشتريات','AI مساعد ذكي','تأمين ضد الاحتيال','دعم أولوية'],
  feesTitle:'العمولات',
  fees:[{l:'تحويل',v:'1.5%'},{l:'إيداع',v:'1%'},{l:'صرف عملات',v:'+1.5%'},{l:'كريبتو',v:'1%'}],
  extraTitle:'مميزات حصرية لـ Plus',
  extras:[
    {ic:'💰',t:'كاشباك 1%',d:'استرداد 1% على كل مشترياتك. يُضاف تلقائياً لرصيدك كل شهر. بدون حد أقصى.'},
    {ic:'⚡',t:'عمولات مخفضة',d:'وفّر أكثر مع كل عملية — 1.5% تحويل بدل 2.5%، و1% إيداع بدل 2%.'},
    {ic:'🎧',t:'دعم أولوية',d:'أولوية في الرد على استفساراتك — وقت انتظار أقل ودعم متميز.'},
    {ic:'🤖',t:'AI مساعد ذكي',d:'مساعد بالذكاء الاصطناعي يساعدك بكل استفساراتك البنكية.'},
  ],
  upgradeTitle:'لشركتك؟',upgradeFade:'اكتشف Business',
  upgradeDesc:'حساب تجاري متكامل مع Payment Gateway، نظام محاسبة، فواتير، وNet Bank Business — بـ €49/شهر.',
  upgradeBtn:'اكتشف Business ←',upgradeBtnAll:'قارن كل الباقات',
  ctaTitle:'ارتقِ لـ Plus',ctaSub:'عمولات أقل + كاشباك 1% + دعم أولوية — بـ €19.99/شهر.',ctaBtn:'احصل على Plus ←',
} : {
  title:'Plus Account — SDB Bank',tag:'Plus · Most Popular',
  heroH:'Plus Account.',heroEm:'Lower fees. More features.',
  heroP:'Everything in Personal with much lower fees, 1% cashback on all purchases, and priority support.',
  price:'€19.99',priceNote:'/month',
  heroBtn:'Get Plus →',
  inclTitle:'Everything in Personal + more',
  incl:['5 Mastercard cards (virtual + physical)','5 accounts','1.5% transfer fee (vs 2.5%)','1% deposit fee (vs 2%)','+1.5% currency exchange (vs +3%)','1% crypto trading (vs 2%)','1% cashback on all purchases','AI assistant','Fraud protection','Priority support'],
  feesTitle:'Fees',
  fees:[{l:'Transfer',v:'1.5%'},{l:'Deposit',v:'1%'},{l:'Currency exchange',v:'+1.5%'},{l:'Crypto',v:'1%'}],
  extraTitle:'Plus exclusive features',
  extras:[
    {ic:'💰',t:'1% Cashback',d:'1% back on all purchases. Automatically credited to your balance monthly. No cap.'},
    {ic:'⚡',t:'Lower Fees',d:'Save more on every transaction — 1.5% transfer vs 2.5%, 1% deposit vs 2%.'},
    {ic:'🎧',t:'Priority Support',d:'Priority response to your inquiries — shorter wait times and premium support.'},
    {ic:'🤖',t:'AI Assistant',d:'AI-powered assistant to help with all your banking inquiries.'},
  ],
  upgradeTitle:'For your business?',upgradeFade:'Discover Business',
  upgradeDesc:'Complete business account with Payment Gateway, accounting system, invoicing, and Net Bank Business — €49/mo.',
  upgradeBtn:'Discover Business →',upgradeBtnAll:'Compare all plans',
  ctaTitle:'Upgrade to Plus',ctaSub:'Lower fees + 1% cashback + priority support — €19.99/mo.',ctaBtn:'Get Plus →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><div class="price-box"><span class="price-v">{{ t.price }}</span><span class="price-n">{{ t.priceNote }}</span></div><a href="/preregister" class="hero-btn">{{ t.heroBtn }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.inclTitle }}</h2><div class="incl-grid"><div v-for="i in t.incl" :key="i" class="incl-i">✓ {{ i }}</div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.feesTitle }}</h2><div class="g4"><div v-for="f in t.fees" :key="f.l" class="lim"><div class="lim-v">{{ f.v }}</div><div class="lim-l">{{ f.l }}</div></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.extraTitle }}</h2><div class="g4"><div v-for="e in t.extras" :key="e.t" class="ext-c"><span class="ext-ic">{{ e.ic }}</span><h3 class="ext-t">{{ e.t }}</h3><p class="ext-d">{{ e.d }}</p></div></div></div></section>
<section class="sec sec-alt"><div class="sw sec-hdr tc"><h2 class="t2">{{ t.upgradeTitle }}<br><span class="t2-em">{{ t.upgradeFade }}</span></h2><p class="t2-sub tc" style="margin:0 auto 24px">{{ t.upgradeDesc }}</p><div class="cta-row"><Link href="/cards/premium" class="link-btn-lg">{{ t.upgradeBtn }}</Link><Link href="/plans" class="link-btn-lg link-sec">{{ t.upgradeBtnAll }}</Link></div></div></section>
<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F9F3}.sec-sky{background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}.t2-em{color:#7C3AED}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#4C1D95,#6D28D9,#7C3AED);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#C4B5FD}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto 28px;line-height:1.8}
.price-box{margin-bottom:28px}.price-v{font-size:48px;font-weight:900;color:#fff}.price-n{font-size:16px;color:rgba(255,255,255,.4)}
.hero-btn{display:inline-block;padding:16px 44px;background:#fff;color:#4C1D95;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.hero-btn:hover{transform:translateY(-2px)}
.incl-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.incl-i{padding:16px 20px;background:#fff;border:1px solid rgba(124,58,237,.08);border-radius:12px;font-size:13px;font-weight:600;color:#4C1D95}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.lim{padding:28px;background:#fff;border:1px solid rgba(124,58,237,.08);border-radius:16px;text-align:center}
.lim-v{font-size:28px;font-weight:900;color:#7C3AED;margin-bottom:4px}.lim-l{font-size:12px;color:rgba(10,10,10,.4)}
.ext-c{padding:28px;background:#fff;border:1px solid rgba(124,58,237,.08);border-radius:18px;text-align:center;transition:all .3s}.ext-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(124,58,237,.06)}
.ext-ic{font-size:28px;display:block;margin-bottom:10px}.ext-t{font-size:14px;font-weight:800;color:#4C1D95;margin-bottom:6px}.ext-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.75}
.cta-row{display:flex;gap:16px;justify-content:center}
.link-btn-lg{font-size:15px;font-weight:700;color:#7C3AED;text-decoration:none;padding:12px 28px;border:2px solid rgba(124,58,237,.15);border-radius:12px;transition:all .2s}.link-btn-lg:hover{border-color:#7C3AED;background:rgba(124,58,237,.04)}
.link-sec{color:rgba(10,10,10,.3);border-color:rgba(10,10,10,.08)}.link-sec:hover{color:#4C1D95;border-color:rgba(10,10,10,.15)}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.incl-grid{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}}
</style>
