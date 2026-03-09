<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'بطاقة Elite — SDB Bank',tag:'Elite · أعلى مستوى',
  heroH:'بطاقة Elite.',heroEm:'لقمة الفخامة.',
  heroP:'أعلى مستوى في SDB Bank. بطاقة معدنية ذهبية، مدير حساب شخصي، صالات VIP بلا حدود، 1% cashback، تأمين صحي شامل — لكبار العملاء.',
  price:'€14.99',priceNote:'/شهر',
  heroBtn:'احصل على Elite ←',
  inclTitle:'أعلى مستوى — كل شيء في Premium + أكثر',
  incl:['بطاقة معدنية ذهبية بتصميم Ultra Premium','حتى 5 بطاقات (فعلية + افتراضية)','مدير حساب شخصي مخصص','صالات مطار LoungeKey غير محدودة','ضيف مجاني في الصالات','1% cashback على كل المشتريات','10GB بيانات eSIM شهرياً','تحويل €200,000/شهر','سحب €10,000/يوم من ATM','SWIFT دولي مجاني','صرف عملات غير محدود','حماية مشتريات €10,000','تأمين سفر شامل + طبي','تأمين تأخير رحلة','تحليلات متقدمة + AI','تحويلات جملة غير محدودة','دعم 24/7 مع SLA','كل مميزات Premium'],
  limitsTitle:'الحدود',
  limits:[{l:'سحب ATM يومي',v:'€10,000'},{l:'صرف شهري',v:'غير محدود'},{l:'تحويل شهري',v:'€200,000'},{l:'بطاقات',v:'5'}],
  eliteTitle:'مميزات Elite الحصرية',
  elites:[
    {ic:'🏆',t:'مدير حساب شخصي',d:'مدير مخصص لك وحدك. متاح بالهاتف أو الواتساب. يساعدك بكل شيء — من التحويلات الكبيرة لحل أي مشكلة فوراً.'},
    {ic:'👑',t:'بطاقة ذهبية معدنية',d:'بطاقة Ultra Premium ذهبية — أثقل، أجمل، وأكثر فخامة. تصميم حصري محدود الإصدار.'},
    {ic:'✈️',t:'صالات مطار بلا حدود',d:'دخول غير محدود لـ 1,300+ صالة LoungeKey حول العالم + ضيف واحد مجاناً كل مرة.'},
    {ic:'💰',t:'1% Cashback',d:'استرداد 1% على كل مشترياتك. بدون حد أقصى. يُضاف تلقائياً لرصيدك كل شهر.'},
    {ic:'📡',t:'10GB eSIM عالمي',d:'10GB بيانات مجانية شهرياً في 100+ دولة. ابقَ متصلاً أينما كنت.'},
    {ic:'🏥',t:'تأمين صحي سفر',d:'تأمين طبي شامل أثناء السفر — حوادث، أمراض طارئة، إخلاء طبي. تغطية عالمية.'},
  ],
  ctaTitle:'انضم لنخبة SDB',ctaSub:'أعلى مستوى بنكي. لكبار العملاء ورجال الأعمال.',ctaBtn:'احصل على Elite ←',ctaBtn2:'قارن كل الباقات',
} : {
  title:'Elite Card — SDB Bank',tag:'Elite · Highest Tier',
  heroH:'Elite Card.',heroEm:'Peak luxury.',
  heroP:'The highest tier at SDB Bank. Gold metal card, personal account manager, unlimited VIP lounges, 1% cashback, comprehensive health insurance — for top clients.',
  price:'€14.99',priceNote:'/month',
  heroBtn:'Get Elite →',
  inclTitle:'Highest tier — Everything in Premium + more',
  incl:['Gold metal Ultra Premium card','Up to 5 cards (physical + virtual)','Dedicated personal account manager','Unlimited LoungeKey airport access','Free guest at lounges','1% cashback on all purchases','10GB eSIM data monthly','€200,000/mo transfer limit','€10,000/day ATM withdrawal','Free SWIFT international','Unlimited FX exchange','€10,000 purchase protection','Comprehensive travel + medical insurance','Flight delay insurance','Advanced analytics + AI','Unlimited bulk transfers','24/7 support with SLA','All Premium features'],
  limitsTitle:'Limits',
  limits:[{l:'Daily ATM',v:'€10,000'},{l:'Monthly FX',v:'Unlimited'},{l:'Monthly transfer',v:'€200,000'},{l:'Cards',v:'5'}],
  eliteTitle:'Elite exclusive features',
  elites:[
    {ic:'🏆',t:'Personal Account Manager',d:'A dedicated manager just for you. Available by phone or WhatsApp. Helps with everything — from large transfers to resolving any issue instantly.'},
    {ic:'👑',t:'Gold Metal Card',d:'Ultra Premium gold card — heavier, more beautiful, more luxurious. Exclusive limited edition design.'},
    {ic:'✈️',t:'Unlimited Airport Lounges',d:'Unlimited access to 1,300+ LoungeKey lounges worldwide + one free guest every time.'},
    {ic:'💰',t:'1% Cashback',d:'1% back on all purchases. No cap. Automatically credited to your balance monthly.'},
    {ic:'📡',t:'10GB Global eSIM',d:'10GB free monthly data in 100+ countries. Stay connected wherever you are.'},
    {ic:'🏥',t:'Travel Health Insurance',d:'Comprehensive medical insurance while traveling — accidents, emergencies, medical evacuation. Worldwide coverage.'},
  ],
  ctaTitle:'Join SDB Elite',ctaSub:'Highest banking tier. For top clients and business leaders.',ctaBtn:'Get Elite →',ctaBtn2:'Compare all plans',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><div class="price-box"><span class="price-v">{{ t.price }}</span><span class="price-n">{{ t.priceNote }}</span></div><a href="/preregister" class="hero-btn">{{ t.heroBtn }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.inclTitle }}</h2><div class="incl-grid"><div v-for="i in t.incl" :key="i" class="incl-i">✓ {{ i }}</div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.limitsTitle }}</h2><div class="g4"><div v-for="l in t.limits" :key="l.l" class="lim"><div class="lim-v">{{ l.v }}</div><div class="lim-l">{{ l.l }}</div></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.eliteTitle }}</h2><div class="g3"><div v-for="e in t.elites" :key="e.t" class="elite-c"><span class="elite-ic">{{ e.ic }}</span><h3 class="elite-t">{{ e.t }}</h3><p class="elite-d">{{ e.d }}</p></div></div></div></section>
<section class="sec sec-gold tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><div class="cta-row"><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a><Link href="/plans" class="cta-btn2">{{ t.ctaBtn2 }}</Link></div></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#FFFBEB}
.sec-gold{background:linear-gradient(135deg,#78350F,#92400E,#B45309);color:#fff;padding:100px 0}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}.t2-em{color:#B45309}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#78350F,#92400E,#B45309);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#FDE68A}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:600px;margin:0 auto 28px;line-height:1.8}
.price-box{margin-bottom:28px}.price-v{font-size:48px;font-weight:900;color:#fff}.price-n{font-size:16px;color:rgba(255,255,255,.4)}
.hero-btn{display:inline-block;padding:16px 44px;background:linear-gradient(135deg,#FDE68A,#FBBF24);color:#78350F;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s;box-shadow:0 4px 16px rgba(251,191,36,.3)}.hero-btn:hover{transform:translateY(-2px)}
.incl-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.incl-i{padding:16px 20px;background:#fff;border:1px solid rgba(180,83,9,.06);border-radius:12px;font-size:13px;font-weight:600;color:#78350F}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.lim{padding:28px;background:#fff;border:1px solid rgba(180,83,9,.06);border-radius:16px;text-align:center}
.lim-v{font-size:28px;font-weight:900;color:#B45309;margin-bottom:4px}.lim-l{font-size:12px;color:rgba(10,10,10,.4)}
.elite-c{padding:28px;background:#fff;border:1px solid rgba(180,83,9,.06);border-radius:18px;transition:all .3s}.elite-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(180,83,9,.06)}
.elite-ic{font-size:28px;display:block;margin-bottom:10px}.elite-t{font-size:15px;font-weight:800;color:#78350F;margin-bottom:6px}.elite-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.cta-row{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}
.cta-btn{display:inline-block;padding:16px 44px;background:linear-gradient(135deg,#FDE68A,#FBBF24);color:#78350F;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s;box-shadow:0 4px 16px rgba(251,191,36,.3)}.cta-btn:hover{transform:translateY(-2px)}
.cta-btn2{display:inline-block;padding:16px 44px;background:transparent;color:rgba(255,255,255,.6);font-size:15px;font-weight:600;border-radius:12px;text-decoration:none;border:2px solid rgba(255,255,255,.15);transition:all .2s}.cta-btn2:hover{border-color:rgba(255,255,255,.4)}
@media(max-width:768px){.incl-grid,.g3{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}}
</style>
