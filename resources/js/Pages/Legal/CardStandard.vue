<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'بطاقة Standard — SDB Bank',tag:'Standard',color:'#9FE870',
  heroH:'بطاقة Standard.',heroEm:'مجانية للأبد.',
  heroP:'كل ما تحتاجه للبدء — بطاقة ماستركارد افتراضية فورية، تحويلات مجانية، وصرف عملات بأسعار حقيقية. بدون رسوم شهرية.',
  price:'مجاني',priceNote:'للأبد — بدون رسوم مخفية',
  heroBtn:'احصل على Standard ←',
  inclTitle:'ماذا تتضمن؟',
  incl:['بطاقة ماستركارد افتراضية فورية','Apple Pay و Google Pay','IBAN دولي حقيقي','تحويلات داخلية مجانية غير محدودة','تحويلات SEPA أوروبية مجانية','تحويلات SWIFT دولية بـ 0.5%','صرف €1,000/شهر مجاناً بسعر السوق','سحب €500/يوم من ATM','30+ عملة مدعومة','إشعارات فورية لكل عملية','تطبيق ذكي بالعربية','دعم فني عبر البريد'],
  limitsTitle:'الحدود',
  limits:[{l:'سحب ATM يومي',v:'€500'},{l:'صرف مجاني شهري',v:'€1,000'},{l:'تحويل شهري',v:'€5,000'},{l:'بطاقات',v:'1 افتراضية'}],
  notInclTitle:'غير متضمن',
  notIncl:['بطاقة فعلية (€9.99 لمرة واحدة)','CVV ديناميكي','حماية مشتريات','تأمين سفر','صالات مطار','Cashback','مدير حساب شخصي'],
  upgradeTitle:'تبي أكثر؟',upgradeFade:'ارتقِ لـ Plus',
  upgradeDesc:'بطاقة فعلية مجانية، CVV ديناميكي، 300,000 ل.س سحب ATM، حماية مشتريات 150,000 ل.س — بـ 600 ل.س/شهر فقط.',
  upgradeBtn:'اكتشف Plus ←',upgradeBtnAll:'قارن كل الباقات',
  ctaTitle:'ابدأ مجاناً',ctaSub:'Standard مجاني للأبد. بدون شروط.',ctaBtn:'افتح حسابك ←',
} : {
  title:'Standard Card — SDB Bank',tag:'Standard',color:'#9FE870',
  heroH:'Standard Card.',heroEm:'Free forever.',
  heroP:'Everything you need to start — instant virtual Mastercard, free transfers, and real exchange rates. No monthly fees.',
  price:'Free',priceNote:'Forever — no hidden fees',
  heroBtn:'Get Standard →',
  inclTitle:'What\'s included?',
  incl:['Instant virtual Mastercard','Apple Pay & Google Pay','Real international IBAN','Unlimited free internal transfers','Free SEPA European transfers','0.5% SWIFT international transfers','€1,000/mo free FX at market rate','€500/day ATM withdrawal','30+ currencies supported','Instant notifications','Smart Arabic app','Email support'],
  limitsTitle:'Limits',
  limits:[{l:'Daily ATM',v:'€500'},{l:'Free monthly FX',v:'€1,000'},{l:'Monthly transfer',v:'€5,000'},{l:'Cards',v:'1 virtual'}],
  notInclTitle:'Not included',
  notIncl:['Physical card (€9.99 one-time)','Dynamic CVV','Purchase protection','Travel insurance','Airport lounges','Cashback','Personal account manager'],
  upgradeTitle:'Want more?',upgradeFade:'Upgrade to Plus',
  upgradeDesc:'Free physical card, dynamic CVV, €2,000 ATM, €1,000 purchase protection — just €3.99/mo.',
  upgradeBtn:'Discover Plus →',upgradeBtnAll:'Compare all plans',
  ctaTitle:'Start for free',ctaSub:'Standard is free forever. No strings attached.',ctaBtn:'Open your account →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero" :style="{background:'linear-gradient(135deg,#075985,#2D6A00,'+t.color+')'}"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><div class="price-box"><span class="price-v">{{ t.price }}</span><span class="price-n">{{ t.priceNote }}</span></div><a href="/preregister" class="hero-btn">{{ t.heroBtn }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.inclTitle }}</h2><div class="incl-grid"><div v-for="i in t.incl" :key="i" class="incl-i">✓ {{ i }}</div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.limitsTitle }}</h2><div class="g4"><div v-for="l in t.limits" :key="l.l" class="lim"><div class="lim-v">{{ l.v }}</div><div class="lim-l">{{ l.l }}</div></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.notInclTitle }}</h2><div class="not-grid"><div v-for="n in t.notIncl" :key="n" class="not-i">✗ {{ n }}</div></div></div></section>
<section class="sec sec-alt"><div class="sw sec-hdr tc"><h2 class="t2">{{ t.upgradeTitle }}<br><span class="t2-em">{{ t.upgradeFade }}</span></h2><p class="t2-sub tc" style="margin:0 auto 24px">{{ t.upgradeDesc }}</p><div class="cta-row"><Link href="/cards/plus" class="link-btn-lg">{{ t.upgradeBtn }}</Link><Link href="/plans" class="link-btn-lg link-sec">{{ t.upgradeBtnAll }}</Link></div></div></section>
<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F9F3}.sec-sky{background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}.t2-em{color:#9FE870}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 80px;color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#E8F5E0}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto 28px;line-height:1.8}
.price-box{margin-bottom:28px}.price-v{font-size:48px;font-weight:900;color:#fff}.price-n{display:block;font-size:13px;color:rgba(255,255,255,.4);margin-top:4px}
.hero-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.hero-btn:hover{transform:translateY(-2px)}
.incl-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.incl-i{padding:16px 20px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:12px;font-size:13px;font-weight:600;color:#163300}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.lim{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:16px;text-align:center}
.lim-v{font-size:28px;font-weight:900;color:#9FE870;margin-bottom:4px}.lim-l{font-size:12px;color:rgba(10,10,10,.4)}
.not-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;max-width:800px;margin:0 auto}
.not-i{padding:12px 16px;font-size:13px;color:rgba(10,10,10,.3);border-bottom:1px solid rgba(10,10,10,.04)}
.cta-row{display:flex;gap:16px;justify-content:center}
.link-btn-lg{font-size:15px;font-weight:700;color:#9FE870;text-decoration:none;padding:12px 28px;border:2px solid rgba(159,232,112,.15);border-radius:12px;transition:all .2s}.link-btn-lg:hover{border-color:#9FE870;background:rgba(159,232,112,.04)}
.link-sec{color:rgba(10,10,10,.3);border-color:rgba(10,10,10,.08)}.link-sec:hover{color:#163300;border-color:rgba(10,10,10,.15)}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
.sec-hdr{margin-bottom:0}
@media(max-width:768px){.incl-grid,.not-grid{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}}
</style>
