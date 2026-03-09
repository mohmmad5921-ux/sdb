<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'بطاقة Premium — SDB Bank',tag:'Premium · الأكثر طلباً',
  heroH:'بطاقة Premium.',heroEm:'بلا حدود.',
  heroP:'بطاقة ماستركارد معدنية فاخرة. صالات مطار، تأمين سفر شامل، صرف عملات بلا حدود، 0.5% cashback — تجربة بنكية استثنائية.',
  price:'1,200',priceNote:' ل.س/شهر',
  heroBtn:'احصل على Premium ←',
  inclTitle:'كل شيء في Plus + أكثر بكثير',
  incl:['بطاقة معدنية فاخرة بتصميم حصري','حتى 4 بطاقات (فعلية + افتراضية)','صرف عملات غير محدود بسعر السوق','سحب €5,000/يوم من ATM مجاناً','تحويل شهري حتى €50,000','SWIFT دولي بـ 0.1% فقط','حماية مشتريات حتى €5,000','تأمين سفر شامل','تأمين تأخير رحلة','4 دخلات صالات مطار LoungeKey/سنة','3GB بيانات eSIM شهرياً','0.5% cashback على كل المشتريات','تحويلات جملة','تحليلات متقدمة','كل مميزات Plus'],
  limitsTitle:'الحدود',
  limits:[{l:'سحب ATM يومي',v:'€5,000'},{l:'صرف شهري',v:'غير محدود'},{l:'تحويل شهري',v:'€50,000'},{l:'بطاقات',v:'4'}],
  premTitle:'مميزات Premium الحصرية',
  prems:[
    {ic:'✨',t:'بطاقة معدنية',d:'بطاقة ماستركارد معدنية بتصميم حصري. ثقيلة وفاخرة — تبرز بين البطاقات العادية. شحن مجاني لعنوانك.'},
    {ic:'✈️',t:'صالات مطار',d:'4 دخلات سنوية لصالات LoungeKey بأكثر من 1,300 صالة حول العالم. واي فاي مجاني، مشروبات وأطعمة، مقاعد مريحة.'},
    {ic:'🛡️',t:'تأمين سفر شامل',d:'تأمين طبي أثناء السفر، تأخير رحلات (€500 تعويض)، فقدان أمتعة. تغطية عالمية تلقائية عند الدفع بالبطاقة.'},
    {ic:'📡',t:'eSIM بيانات',d:'3GB بيانات مجانية شهرياً في 100+ دولة. ابقَ متصلاً بدون بطاقة SIM محلية.'},
    {ic:'💰',t:'0.5% Cashback',d:'استرداد 0.5% على كل مشترياتك. يُضاف تلقائياً لرصيدك كل شهر. بدون حد أقصى.'},
    {ic:'💎',t:'صرف بلا حدود',d:'حوّل بين كل العملات بسعر السوق الحقيقي بدون أي حد شهري. مثالي للمسافرين ورجال الأعمال.'},
  ],
  upgradeTitle:'تبي القمة؟',upgradeFade:'اكتشف Elite',
  upgradeDesc:'مدير حساب شخصي، صالات VIP بلا حدود، 1% cashback، تأمين صحي شامل، €200,000 تحويل/شهر.',
  upgradeBtn:'اكتشف Elite ←',upgradeBtnAll:'قارن كل الباقات',
  ctaTitle:'ارتقِ لـ Premium',ctaSub:'بطاقة معدنية + صالات مطار + تأمين — بـ 1,200 ل.س/شهر.',ctaBtn:'احصل على Premium ←',
} : {
  title:'Premium Card — SDB Bank',tag:'Premium · Most Popular',
  heroH:'Premium Card.',heroEm:'Without limits.',
  heroP:'Premium metal Mastercard. Airport lounges, comprehensive travel insurance, unlimited FX, 0.5% cashback — an exceptional banking experience.',
  price:'€7.99',priceNote:'/month',
  heroBtn:'Get Premium →',
  inclTitle:'Everything in Plus + much more',
  incl:['Premium metal card with exclusive design','Up to 4 cards (physical + virtual)','Unlimited FX at market rate','€5,000/day free ATM withdrawal','€50,000 monthly transfer limit','0.1% SWIFT international','€5,000 purchase protection','Comprehensive travel insurance','Flight delay insurance','4 LoungeKey airport visits/year','3GB eSIM data monthly','0.5% cashback on all purchases','Bulk transfers','Advanced analytics','All Plus features'],
  limitsTitle:'Limits',
  limits:[{l:'Daily ATM',v:'€5,000'},{l:'Monthly FX',v:'Unlimited'},{l:'Monthly transfer',v:'€50,000'},{l:'Cards',v:'4'}],
  premTitle:'Premium exclusive features',
  prems:[
    {ic:'✨',t:'Metal Card',d:'Exclusive design metal Mastercard. Heavy and luxurious — stands out from regular cards. Free delivery to your address.'},
    {ic:'✈️',t:'Airport Lounges',d:'4 annual LoungeKey visits at 1,300+ lounges worldwide. Free WiFi, food & drinks, comfortable seating.'},
    {ic:'🛡️',t:'Travel Insurance',d:'Medical insurance while traveling, flight delays (€500 compensation), lost luggage. Automatic worldwide coverage when paying with card.'},
    {ic:'📡',t:'eSIM Data',d:'3GB free monthly data in 100+ countries. Stay connected without a local SIM card.'},
    {ic:'💰',t:'0.5% Cashback',d:'0.5% back on all purchases. Automatically credited to your balance monthly. No cap.'},
    {ic:'💎',t:'Unlimited FX',d:'Convert between all currencies at real market rate with no monthly limit. Perfect for travelers and business.'},
  ],
  upgradeTitle:'Want the pinnacle?',upgradeFade:'Discover Elite',
  upgradeDesc:'Personal account manager, unlimited VIP lounges, 1% cashback, comprehensive health insurance, €200,000 transfers/mo.',
  upgradeBtn:'Discover Elite →',upgradeBtnAll:'Compare all plans',
  ctaTitle:'Upgrade to Premium',ctaSub:'Metal card + airport lounges + insurance — €7.99/mo.',ctaBtn:'Get Premium →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><div class="price-box"><span class="price-v">{{ t.price }}</span><span class="price-n">{{ t.priceNote }}</span></div><a href="/preregister" class="hero-btn">{{ t.heroBtn }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.inclTitle }}</h2><div class="incl-grid"><div v-for="i in t.incl" :key="i" class="incl-i">✓ {{ i }}</div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.limitsTitle }}</h2><div class="g4"><div v-for="l in t.limits" :key="l.l" class="lim"><div class="lim-v">{{ l.v }}</div><div class="lim-l">{{ l.l }}</div></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.premTitle }}</h2><div class="g3"><div v-for="p in t.prems" :key="p.t" class="prem-c"><span class="prem-ic">{{ p.ic }}</span><h3 class="prem-t">{{ p.t }}</h3><p class="prem-d">{{ p.d }}</p></div></div></div></section>
<section class="sec sec-alt"><div class="sw sec-hdr tc"><h2 class="t2">{{ t.upgradeTitle }}<br><span class="t2-em">{{ t.upgradeFade }}</span></h2><p class="t2-sub tc" style="margin:0 auto 24px">{{ t.upgradeDesc }}</p><div class="cta-row"><Link href="/cards/elite" class="link-btn-lg">{{ t.upgradeBtn }}</Link><Link href="/plans" class="link-btn-lg link-sec">{{ t.upgradeBtnAll }}</Link></div></div></section>
<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#FDF2F8}.sec-sky{background:linear-gradient(135deg,#831843,#BE185D,#DB2777);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}.t2-em{color:#DB2777}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#831843,#BE185D,#DB2777);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#FBCFE8}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:580px;margin:0 auto 28px;line-height:1.8}
.price-box{margin-bottom:28px}.price-v{font-size:48px;font-weight:900;color:#fff}.price-n{font-size:16px;color:rgba(255,255,255,.4)}
.hero-btn{display:inline-block;padding:16px 44px;background:#fff;color:#831843;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.hero-btn:hover{transform:translateY(-2px)}
.incl-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.incl-i{padding:16px 20px;background:#fff;border:1px solid rgba(219,39,119,.06);border-radius:12px;font-size:13px;font-weight:600;color:#831843}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.lim{padding:28px;background:#fff;border:1px solid rgba(219,39,119,.06);border-radius:16px;text-align:center}
.lim-v{font-size:28px;font-weight:900;color:#DB2777;margin-bottom:4px}.lim-l{font-size:12px;color:rgba(10,10,10,.4)}
.prem-c{padding:28px;background:#fff;border:1px solid rgba(219,39,119,.06);border-radius:18px;transition:all .3s}.prem-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(219,39,119,.06)}
.prem-ic{font-size:28px;display:block;margin-bottom:10px}.prem-t{font-size:15px;font-weight:800;color:#831843;margin-bottom:6px}.prem-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.cta-row{display:flex;gap:16px;justify-content:center}
.link-btn-lg{font-size:15px;font-weight:700;color:#DB2777;text-decoration:none;padding:12px 28px;border:2px solid rgba(219,39,119,.15);border-radius:12px;transition:all .2s}.link-btn-lg:hover{border-color:#DB2777;background:rgba(219,39,119,.04)}
.link-sec{color:rgba(10,10,10,.3);border-color:rgba(10,10,10,.08)}.link-sec:hover{color:#831843;border-color:rgba(10,10,10,.15)}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#831843;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
.sec-hdr{margin-bottom:0}
@media(max-width:768px){.incl-grid,.g3{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}}
</style>
