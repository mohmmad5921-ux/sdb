<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'البطاقات — SDB Bank',tag:'بطاقات ماستركارد',
  heroH:'بطاقتك.',heroEm:'بين يديك فوراً.',heroP:'بطاقة افتراضية فورية مجانية عند التسجيل. أو بطاقة معدنية فاخرة تصلك لأي مكان. ادفع بـ Apple Pay و Google Pay بكل مكان بالعالم.',
  heroCta:'احصل على بطاقتك',
  tierTitle:'اختر بطاقتك المثالية',
  tiers:[
    {name:'Standard',badge:'مجاني',color:'#9FE870',feats:['بطاقة افتراضية فورية','Apple Pay و Google Pay','ادفع بأي متجر إلكتروني','حد سحب يومي 75,000 ل.س','إشعارات فورية لكل عملية','تجميد فوري من التطبيق']},
    {name:'Plus',badge:'600 ل.س/شهر',color:'#7C3AED',feats:['بطاقة معدنية فاخرة','حماية مشتريات 150,000 ل.س','حد يومي مضاعف 300,000 ل.س','دعم أولوية 24/7','CVV ديناميكي','تحويلات دولية مجانية (150,000 ل.س/شهر)']},
    {name:'Premium',badge:'1,200 ل.س/شهر',color:'#DB2777',feats:['صرف عملات بلا حدود بسعر السوق','تأمين سفر شامل','3 زيارات صالة مطار شهرياً','شريحة eSIM دولية (3GB)','حماية مشتريات 750,000 ل.س','حد سحب يومي 750,000 ل.س']},
    {name:'Elite',badge:'2,250 ل.س/شهر',color:'#B45309',feats:['صالات VIP بلا حدود','مدير حساب شخصي','استرداد نقدي 1% على كل عملية','تأمين شامل (سفر + صحة)','شريحة eSIM دولية (10GB)','حد سحب يومي 1,500,000 ل.س']},
  ],
  compTitle:'مقارنة البطاقات',
  compH:['الميزة','Standard','Plus','Premium','Elite'],
  compR:[['السعر الشهري','مجاني','600 ل.س','1,200 ل.س','2,250 ل.س'],['بطاقة افتراضية','✓','✓','✓','✓'],['بطاقة معدنية','—','✓','✓','✓'],['Apple Pay','✓','✓','✓','✓'],['حد السحب اليومي','75,000 ل.س','300,000 ل.س','750,000 ل.س','1,500,000 ل.س'],['صرف عملات مجاني','30,000 ل.س/شهر','150,000 ل.س/شهر','بلا حدود','بلا حدود'],['حماية مشتريات','—','150,000 ل.س','750,000 ل.س','1,500,000 ل.س'],['تأمين سفر','—','—','✓','✓ شامل'],['صالات مطار','—','—','3/شهر','بلا حدود'],['CVV ديناميكي','—','✓','✓','✓'],['استرداد نقدي','—','—','0.5%','1%'],['مدير حساب','—','—','—','✓']],
  featTitle:'كل مميزات البطاقة',
  feats:[
    {ic:'📱',t:'Apple Pay و Google Pay',d:'أضف بطاقتك لمحفظتك الرقمية وادفع بهاتفك أو ساعتك الذكية بأي متجر.'},
    {ic:'❄️',t:'تجميد فوري',d:'جمّد بطاقتك فوراً من التطبيق إذا فقدتها أو شككت بنشاط غير عادي.'},
    {ic:'🔄',t:'CVV ديناميكي',d:'رمز أمان يتغير تلقائياً كل ساعة لحماية إضافية بالمشتريات الإلكترونية.'},
    {ic:'🔔',t:'إشعارات فورية',d:'كل عملية دفع أو سحب ترسل إشعار فوري بكل التفاصيل لهاتفك.'},
    {ic:'🌍',t:'ادفع بأي مكان',d:'ماستركارد مقبولة بأكثر من 80 مليون متجر حول العالم.'},
    {ic:'💱',t:'تحويل تلقائي',d:'ادفع بأي عملة والتحويل يتم تلقائياً بسعر الصرف الحقيقي.'},
    {ic:'🛡️',t:'3D Secure',d:'طبقة أمان إضافية تتحقق من هويتك عند الدفع إلكترونياً.'},
    {ic:'📊',t:'تحليل المصاريف',d:'تتبع وين رايحة فلوسك مع تصنيف تلقائي وتقارير شهرية.'},
    {ic:'🔐',t:'أمان متعدد الطبقات',d:'تشفير 256-بت، مصادقة ثنائية، وبصمة الوجه أو الإصبع.'},
  ],
  ctaTitle:'احصل على بطاقتك اليوم',ctaSub:'سجّل بدقائق واحصل على بطاقة افتراضية فوراً. بدون رسوم مخفية.',ctaBtn:'سجّل مجاناً ←',
} : {
  title:'Cards — SDB Bank',tag:'Mastercard Cards',
  heroH:'Your card.',heroEm:'Instantly yours.',heroP:'Free instant virtual card on signup. Or a premium metal card delivered anywhere. Pay with Apple Pay and Google Pay worldwide.',
  heroCta:'Get your card',
  tierTitle:'Choose your perfect card',
  tiers:[
    {name:'Standard',badge:'Free',color:'#9FE870',feats:['Instant virtual Mastercard','Apple Pay & Google Pay','Pay at any online store','Daily withdrawal limit €500','Instant notifications','Instant freeze from app']},
    {name:'Plus',badge:'€3.99/mo',color:'#7C3AED',feats:['Premium metal Mastercard','Purchase protection €1,000','Double daily limit €2,000','Priority 24/7 support','Dynamic CVV','Free intl. transfers (€1,000/mo)']},
    {name:'Premium',badge:'€7.99/mo',color:'#DB2777',feats:['Unlimited FX at market rate','Comprehensive travel insurance','3 airport lounges/month','Intl. eSIM data (3GB)','Purchase protection €5,000','Daily withdrawal €5,000']},
    {name:'Elite',badge:'€14.99/mo',color:'#B45309',feats:['Unlimited VIP lounges','Personal account manager','1% cashback on everything','Full insurance (travel + health)','Intl. eSIM data (10GB)','Daily withdrawal €10,000']},
  ],
  compTitle:'Card Comparison',
  compH:['Feature','Standard','Plus','Premium','Elite'],
  compR:[['Monthly price','Free','€3.99','€7.99','€14.99'],['Virtual card','✓','✓','✓','✓'],['Metal card','—','✓','✓','✓'],['Apple Pay','✓','✓','✓','✓'],['Daily withdrawal','€500','€2,000','€5,000','€10,000'],['Free FX','€200/mo','€1,000/mo','Unlimited','Unlimited'],['Purchase protection','—','€1,000','€5,000','€10,000'],['Travel insurance','—','—','✓','✓ Full'],['Airport lounges','—','—','3/mo','Unlimited'],['Dynamic CVV','—','✓','✓','✓'],['Cashback','—','—','0.5%','1%'],['Account manager','—','—','—','✓']],
  featTitle:'All Card Features',
  feats:[
    {ic:'📱',t:'Apple Pay & Google Pay',d:'Add your card to your digital wallet and pay with your phone or smartwatch.'},
    {ic:'❄️',t:'Instant Freeze',d:'Freeze your card instantly from the app if lost or suspicious activity detected.'},
    {ic:'🔄',t:'Dynamic CVV',d:'Security code that changes automatically every hour for extra protection.'},
    {ic:'🔔',t:'Instant Notifications',d:'Every payment triggers instant notification with full details.'},
    {ic:'🌍',t:'Pay Anywhere',d:'Mastercard accepted at 80M+ stores worldwide.'},
    {ic:'💱',t:'Auto Conversion',d:'Pay in any currency with auto conversion at real exchange rate.'},
    {ic:'🛡️',t:'3D Secure',d:'Extra security layer verifying identity during online payments.'},
    {ic:'📊',t:'Spending Analytics',d:'Track where your money goes with auto categorization.'},
    {ic:'🔐',t:'Multi-Layer Security',d:'256-bit encryption, 2FA, and Face ID or fingerprint.'},
  ],
  ctaTitle:'Get your card today',ctaSub:'Sign up in minutes and get a virtual card instantly. No hidden fees.',ctaBtn:'Sign up free →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><a href="/preregister" class="p-cta">{{ t.heroCta }}</a></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.tierTitle }}</h2><div class="tiers"><div v-for="(tr,i) in t.tiers" :key="i" class="tier"><div class="tier-top" :style="{background:`linear-gradient(135deg,${tr.color},${tr.color}dd)`}"><div class="tier-emoji">💳</div></div><div class="tier-body"><span class="tier-badge" :style="{color:tr.color,background:tr.color+'12'}">{{ tr.badge }}</span><h3 class="tier-name">{{ tr.name }}</h3><ul class="tier-feats"><li v-for="f in tr.feats" :key="f">✓ {{ f }}</li></ul></div></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.compTitle }}</h2><div class="tbl-wrap"><table class="tbl"><thead><tr><th v-for="h in t.compH" :key="h">{{ h }}</th></tr></thead><tbody><tr v-for="(r,i) in t.compR" :key="i"><td v-for="(c,j) in r" :key="j" :class="{'tbl-first':j===0}">{{ c }}</td></tr></tbody></table></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.featTitle }}</h2><div class="feat-g"><div v-for="f in t.feats" :key="f.t" class="feat-c"><span class="feat-ic">{{ f.ic }}</span><h4 class="feat-t">{{ f.t }}</h4><p class="feat-d">{{ f.d }}</p></div></div></div></section>

<section class="sec sec-dark tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="p-cta">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}
.sec{padding:100px 0}.sec-alt{background:#fafafa}.sec-dark{background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.tc{text-align:center}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:500px}.t2-sub-w{color:rgba(255,255,255,.3)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#0a0a0a 0%,#162d4d 100%);color:#fff;text-align:center}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#9FE870;text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}
.p-hero-em{color:#9FE870}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.45);max-width:560px;margin:0 auto 32px;line-height:1.8}
.p-cta{display:inline-block;padding:16px 44px;background:#fff;color:#0a0a0a;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.p-cta:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,.2)}
.tiers{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.tier{background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;overflow:hidden;transition:all .3s}.tier:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(0,0,0,.06)}
.tier-top{height:140px;display:flex;align-items:center;justify-content:center}
.tier-emoji{font-size:56px;filter:drop-shadow(0 4px 12px rgba(0,0,0,.3))}
.tier-body{padding:24px}
.tier-badge{display:inline-block;padding:6px 16px;border-radius:100px;font-size:12px;font-weight:700;margin-bottom:12px}
.tier-name{font-size:24px;font-weight:900;margin-bottom:16px}
.tier-feats{list-style:none;padding:0}.tier-feats li{padding:8px 0;font-size:13px;color:rgba(10,10,10,.5);border-bottom:1px solid rgba(10,10,10,.04)}
.tbl-wrap{overflow-x:auto}
.tbl{width:100%;border-collapse:collapse;font-size:13px}
.tbl th{padding:14px;text-align:center;font-weight:800;background:#0a0a0a;color:#fff;font-size:12px}.tbl th:first-child{text-align:start;border-radius:12px 0 0 0}.tbl th:last-child{border-radius:0 12px 0 0}
.tbl td{padding:12px 14px;text-align:center;border-bottom:1px solid rgba(10,10,10,.06);color:rgba(10,10,10,.5)}
.tbl-first{text-align:start!important;font-weight:600;color:#0a0a0a!important}
.tbl tbody tr:hover{background:rgba(159,232,112,.02)}
.feat-g{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.feat-c{padding:32px 24px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:18px;transition:all .3s}.feat-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.feat-ic{font-size:28px;display:block;margin-bottom:12px}
.feat-t{font-size:15px;font-weight:800;margin-bottom:6px}
.feat-d{font-size:13px;color:rgba(10,10,10,.35);line-height:1.75}
@media(max-width:900px){.tiers{grid-template-columns:repeat(2,1fr)}}
@media(max-width:600px){.tiers,.feat-g{grid-template-columns:1fr}}
</style>
