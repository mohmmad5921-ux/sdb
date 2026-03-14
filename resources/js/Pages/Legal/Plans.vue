<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'الباقات والأسعار — SDB Bank',tag:'باقات SDB',
  heroH:'اختر الباقة',heroEm:'المناسبة لك.',
  heroP:'حسابات شخصية وتجارية بمميزات استثنائية — عمولات منافسة، بطاقات Mastercard، ومساعد ذكي بالذكاء الاصطناعي.',
  persTitle:'الحسابات الشخصية',
  bizTitle:'الحسابات التجارية',
  personal:[
    {n:'Personal',p:'€9.99',p2:'/شهر',c:'#9FE870',pop:false,btn:'احصل على Personal',link:'/cards/standard',feats:[
      '5 بطاقات Mastercard','5 حسابات','عمولة تحويل 2.5%','عمولة إيداع 2%','صرف عملات +3%','تداول كريبتو 2%','🤖 AI مساعد ذكي','🛡️ تأمين ضد الاحتيال'
    ]},
    {n:'Plus',p:'€19.99',p2:'/شهر',c:'#7C3AED',pop:true,btn:'احصل على Plus',link:'/cards/plus',feats:[
      '5 بطاقات Mastercard','5 حسابات','عمولة تحويل 1.5%','عمولة إيداع 1%','صرف عملات +1.5%','تداول كريبتو 1%','💰 كاشباك 1%','🤖 AI مساعد ذكي','🛡️ تأمين ضد الاحتيال','⚡ دعم أولوية'
    ]},
  ],
  business:[
    {n:'Business',p:'€49',p2:'/شهر',c:'#2563EB',pop:false,btn:'احصل على Business',link:'/cards/premium',feats:[
      '5 بطاقات Mastercard','5 حسابات','عمولة تحويل 1%','عمولة إيداع 0.8%','صرف عملات +1%','🌐 Payment Gateway','🏦 Net Bank Business','📊 نظام محاسبة','🧾 فواتير','🔐 API Access','🤖 AI مساعد ذكي','🛡️ تأمين ضد الاحتيال','⚡ دعم أولوية'
    ]},
    {n:'Enterprise',p:'مخصص',p2:'',c:'#B45309',pop:false,btn:'تواصل معنا',link:'/contact',feats:[
      'كل ميزات Business +','🛒 Web Shop متكامل','🔗 ربط ERP / SAP','💸 عمولات مخصصة','🔧 تطوير حسب الطلب','👤 مدير حساب مخصص','📋 SLA مخصص'
    ]},
  ],
  compTitle:'مقارنة شاملة',
  compH:['الميزة','Personal','Plus','Business','Enterprise'],
  compR:[
    ['السعر الشهري','€9.99','€19.99','€49','مخصص'],
    ['عمولة تحويل','2.5%','1.5%','1%','مخصص'],
    ['عمولة إيداع','2%','1%','0.8%','مخصص'],
    ['صرف عملات','+3%','+1.5%','+1%','مخصص'],
    ['تداول كريبتو','2%','1%','1%','مخصص'],
    ['بطاقات Mastercard','5','5','5','5'],
    ['حسابات','5','5','5','5'],
    ['AI مساعد ذكي','✓','✓','✓','✓'],
    ['تأمين ضد الاحتيال','✓','✓','✓','✓'],
    ['كاشباك','—','1%','—','✓'],
    ['دعم أولوية','—','✓','✓','✓'],
    ['Payment Gateway','—','—','✓','✓'],
    ['Net Bank Business','—','—','✓','✓'],
    ['نظام محاسبة','—','—','✓','✓'],
    ['فواتير','—','—','✓','✓'],
    ['API Access','—','—','✓','✓'],
    ['Web Shop','—','—','—','✓'],
    ['ربط ERP','—','—','—','✓'],
  ],
  faqTitle:'أسئلة شائعة',
  faqs:[
    {q:'هل يمكنني تغيير الباقة لاحقاً؟',a:'نعم — يمكنك الترقية أو التخفيض بأي وقت من التطبيق فوراً.'},
    {q:'هل يمكنني إلغاء الاشتراك؟',a:'نعم بأي وقت. لا يوجد عقود أو التزامات.'},
    {q:'ما الفرق بين Personal و Plus؟',a:'Plus يقدم عمولات أقل بكثير (1.5% بدل 2.5% للتحويل)، كاشباك 1%، ودعم أولوية.'},
    {q:'ماذا يتضمن حساب Business؟',a:'كل ما تحتاجه شركتك: Payment Gateway للموقع، نظام محاسبة، فواتير، صلاحيات موظفين، وAPI.'},
  ],
  ctaTitle:'ابدأ اليوم',ctaSub:'اختر الباقة المناسبة وابدأ خلال دقائق.',ctaBtn:'افتح حسابك ←',
} : {
  title:'Plans & Pricing — SDB Bank',tag:'SDB Plans',
  heroH:'Choose the plan',heroEm:'that fits you.',
  heroP:'Personal and business accounts with exceptional features — competitive fees, Mastercard cards, and AI-powered assistant.',
  persTitle:'Personal Accounts',
  bizTitle:'Business Accounts',
  personal:[
    {n:'Personal',p:'€9.99',p2:'/month',c:'#9FE870',pop:false,btn:'Get Personal',link:'/cards/standard',feats:[
      '5 Mastercard cards','5 accounts','2.5% transfer fee','2% deposit fee','+3% currency exchange','2% crypto trading','🤖 AI assistant','🛡️ Fraud protection'
    ]},
    {n:'Plus',p:'€19.99',p2:'/month',c:'#7C3AED',pop:true,btn:'Get Plus',link:'/cards/plus',feats:[
      '5 Mastercard cards','5 accounts','1.5% transfer fee','1% deposit fee','+1.5% currency exchange','1% crypto trading','💰 1% Cashback','🤖 AI assistant','🛡️ Fraud protection','⚡ Priority support'
    ]},
  ],
  business:[
    {n:'Business',p:'€49',p2:'/month',c:'#2563EB',pop:false,btn:'Get Business',link:'/cards/premium',feats:[
      '5 Mastercard cards','5 accounts','1% transfer fee','0.8% deposit fee','+1% currency exchange','🌐 Payment Gateway','🏦 Net Bank Business','📊 Accounting system','🧾 Invoicing','🔐 API Access','🤖 AI assistant','🛡️ Fraud protection','⚡ Priority support'
    ]},
    {n:'Enterprise',p:'Custom',p2:'',c:'#B45309',pop:false,btn:'Contact us',link:'/contact',feats:[
      'All Business features +','🛒 Full Web Shop','🔗 ERP / SAP integration','💸 Custom fees','🔧 Custom development','👤 Dedicated account manager','📋 Custom SLA'
    ]},
  ],
  compTitle:'Full Comparison',
  compH:['Feature','Personal','Plus','Business','Enterprise'],
  compR:[
    ['Monthly price','€9.99','€19.99','€49','Custom'],
    ['Transfer fee','2.5%','1.5%','1%','Custom'],
    ['Deposit fee','2%','1%','0.8%','Custom'],
    ['Currency exchange','+3%','+1.5%','+1%','Custom'],
    ['Crypto trading','2%','1%','1%','Custom'],
    ['Mastercard cards','5','5','5','5'],
    ['Accounts','5','5','5','5'],
    ['AI assistant','✓','✓','✓','✓'],
    ['Fraud protection','✓','✓','✓','✓'],
    ['Cashback','—','1%','—','✓'],
    ['Priority support','—','✓','✓','✓'],
    ['Payment Gateway','—','—','✓','✓'],
    ['Net Bank Business','—','—','✓','✓'],
    ['Accounting system','—','—','✓','✓'],
    ['Invoicing','—','—','✓','✓'],
    ['API Access','—','—','✓','✓'],
    ['Web Shop','—','—','—','✓'],
    ['ERP integration','—','—','—','✓'],
  ],
  faqTitle:'FAQ',
  faqs:[
    {q:'Can I change plans later?',a:'Yes — upgrade or downgrade anytime from the app instantly.'},
    {q:'Can I cancel my subscription?',a:'Yes anytime. No contracts or commitments.'},
    {q:'What\'s the difference between Personal and Plus?',a:'Plus offers much lower fees (1.5% vs 2.5% for transfers), 1% cashback, and priority support.'},
    {q:'What does Business include?',a:'Everything your business needs: Payment Gateway, accounting system, invoicing, employee permissions, and API.'},
  ],
  ctaTitle:'Start today',ctaSub:'Choose the right plan and get started in minutes.',ctaBtn:'Open your account →',
});
</script>
<template>
<Head :title="t.title" />

<!-- Hero -->
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<!-- Personal Plans with features -->
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.persTitle }}</h2><div class="plan-g"><div v-for="p in t.personal" :key="p.n" class="plan-c" :class="{'plan-pop':p.pop}">
  <div v-if="p.pop" class="plan-badge">{{ isAr?'الأكثر طلباً':'Most popular' }}</div>
  <div class="plan-bar" :style="{background:p.c}"></div>
  <h3 class="plan-n">{{ p.n }}</h3>
  <div class="plan-price"><span class="plan-p" :style="{color:p.c}">{{ p.p }}</span><span class="plan-p2">{{ p.p2 }}</span></div>
  <ul class="plan-feats"><li v-for="f in p.feats" :key="f">{{ f }}</li></ul>
  <a :href="p.link" class="plan-btn" :style="{background:p.c}">{{ p.btn }}</a>
</div></div></div></section>

<!-- Business Plans with features -->
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.bizTitle }}</h2><div class="plan-g"><div v-for="p in t.business" :key="p.n" class="plan-c">
  <div class="plan-bar" :style="{background:p.c}"></div>
  <h3 class="plan-n">{{ p.n }}</h3>
  <div class="plan-price"><span class="plan-p" :style="{color:p.c}">{{ p.p }}</span><span class="plan-p2">{{ p.p2 }}</span></div>
  <ul class="plan-feats"><li v-for="f in p.feats" :key="f">{{ f }}</li></ul>
  <a :href="p.link" class="plan-btn" :style="{background:p.c}">{{ p.btn }}</a>
</div></div></div></section>

<!-- Full Comparison Table -->
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.compTitle }}</h2><div class="tbl-wrap"><table class="tbl"><thead><tr><th v-for="h in t.compH" :key="h">{{ h }}</th></tr></thead><tbody><tr v-for="(r,i) in t.compR" :key="i"><td v-for="(c,j) in r" :key="j" :class="{'tbl-first':j===0,'tbl-yes':c==='✓','tbl-no':c==='—'}">{{ c }}</td></tr></tbody></table></div></div></section>

<!-- FAQ -->
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.faqTitle }}</h2><div class="faqs"><div v-for="f in t.faqs" :key="f.q" class="faq-c"><h4 class="faq-q">{{ f.q }}</h4><p class="faq-a">{{ f.a }}</p></div></div></div></section>

<!-- CTA -->
<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F9F3}.sec-sky{background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 60px;background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.6);text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}.p-hero-em{color:#9FE870}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto;line-height:1.8}
.plan-g{display:grid;grid-template-columns:repeat(2,1fr);gap:24px;max-width:800px;margin:0 auto}
.plan-c{padding:36px 28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;position:relative;overflow:hidden;transition:all .3s;display:flex;flex-direction:column}.plan-c:hover{transform:translateY(-4px);box-shadow:0 16px 40px rgba(0,0,0,.08)}
.plan-pop{border:2px solid #7C3AED;box-shadow:0 8px 30px rgba(124,58,237,.12)}
.plan-badge{position:absolute;top:12px;right:12px;background:#7C3AED;color:#fff;font-size:10px;font-weight:800;padding:4px 12px;border-radius:6px;z-index:1}
.rtl .plan-badge{right:auto;left:12px}
.plan-bar{height:4px;position:absolute;top:0;left:0;right:0}
.plan-n{font-size:22px;font-weight:900;color:#163300;margin:14px 0 12px;text-align:center}
.plan-price{text-align:center;margin-bottom:24px}.plan-p{font-size:38px;font-weight:900}.plan-p2{font-size:14px;color:rgba(10,10,10,.3);margin-inline-start:4px}
.plan-feats{list-style:none;padding:0;margin:0 0 24px;flex:1}
.plan-feats li{padding:10px 0;font-size:13px;font-weight:500;color:rgba(10,10,10,.6);border-bottom:1px solid rgba(10,10,10,.04);display:flex;align-items:center;gap:8px}
.plan-feats li::before{content:'✓';color:#059669;font-weight:800;font-size:14px;flex-shrink:0}
.plan-btn{display:block;padding:14px;color:#fff;font-size:15px;font-weight:700;border-radius:12px;text-decoration:none;text-align:center;transition:all .2s}.plan-btn:hover{opacity:.9;transform:translateY(-1px)}
.tbl-wrap{overflow-x:auto;border-radius:16px;border:1px solid rgba(10,10,10,.06)}
.tbl{width:100%;border-collapse:collapse;font-size:13px}
.tbl th{padding:14px 16px;text-align:center;font-weight:800;background:#163300;color:#fff;font-size:12px}.tbl th:first-child{text-align:start}
.tbl td{padding:12px 16px;text-align:center;border-bottom:1px solid rgba(10,10,10,.04);color:rgba(10,10,10,.5)}
.tbl-first{text-align:start!important;font-weight:600;color:#163300!important}
.tbl-yes{color:#059669!important;font-weight:700}.tbl-no{color:rgba(10,10,10,.12)!important}
.tbl tbody tr:hover{background:rgba(159,232,112,.03)}
.tbl tbody tr:nth-child(even){background:rgba(159,232,112,.015)}
.faqs{max-width:700px;margin:0 auto;display:flex;flex-direction:column;gap:12px}
.faq-c{padding:24px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:16px}
.faq-q{font-size:15px;font-weight:800;margin-bottom:8px;color:#163300}.faq-a{font-size:13px;color:rgba(10,10,10,.4);line-height:1.8}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.plan-g{grid-template-columns:1fr}.tbl th,.tbl td{padding:8px 10px;font-size:11px}}
</style>
