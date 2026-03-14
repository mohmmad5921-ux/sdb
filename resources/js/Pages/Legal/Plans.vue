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
  plans:[
    {n:'Personal',p:'€9.99',p2:'/شهر',c:'#9FE870',pop:false,btn:'احصل على Personal',cat:'personal'},
    {n:'Plus',p:'€19.99',p2:'/شهر',c:'#7C3AED',pop:true,btn:'احصل على Plus',cat:'personal'},
    {n:'Business',p:'€49',p2:'/شهر',c:'#2563EB',pop:false,btn:'احصل على Business',cat:'business'},
    {n:'Enterprise',p:'مخصص',p2:'',c:'#B45309',pop:false,btn:'تواصل معنا',cat:'business'},
  ],
  sections:[
    {cat:'العمولات',rows:[
      {f:'عمولة تحويل',v:['2.5%','1.5%','1%','مخصص']},
      {f:'عمولة إيداع',v:['2%','1%','0.8%','مخصص']},
      {f:'صرف عملات',v:['+3%','+1.5%','+1%','مخصص']},
      {f:'تداول كريبتو',v:['2%','1%','1%','مخصص']},
    ]},
    {cat:'البطاقات والحسابات',rows:[
      {f:'بطاقات Mastercard',v:['5','5','5','5']},
      {f:'حسابات',v:['5','5','5','5']},
    ]},
    {cat:'ميزات ذكية',rows:[
      {f:'AI مساعد ذكي',v:['✅','✅','✅','✅']},
      {f:'تأمين ضد الاحتيال',v:['✅','✅','✅','✅']},
      {f:'كاشباك',v:['❌','1%','❌','✅']},
      {f:'دعم أولوية',v:['❌','✅','✅','✅']},
    ]},
    {cat:'ميزات الأعمال',rows:[
      {f:'Payment Gateway',v:['❌','❌','✅','✅']},
      {f:'Net Bank Business',v:['❌','❌','✅','✅']},
      {f:'نظام محاسبة',v:['❌','❌','✅','✅']},
      {f:'إنشاء فواتير',v:['❌','❌','✅','✅']},
      {f:'Web Shop',v:['❌','❌','❌','✅']},
      {f:'API Access',v:['❌','❌','✅','✅']},
    ]},
  ],
  benefitsTitle:'لكل باقة مميزاتها',
  benefits:[
    {n:'Personal',ic:'⭐',d:'حساب شخصي مع بطاقة Mastercard، تحويلات، صرف عملات، وتداول كريبتو. كل ما تحتاجه للبنك الرقمي.',target:'أفراد'},
    {n:'Plus',ic:'💎',d:'عمولات أقل بكثير، كاشباك 1%، ودعم أولوية. للعملاء اللي بدهم أكثر.',target:'عملاء متقدمين'},
    {n:'Business',ic:'🏢',d:'حساب تجاري متكامل مع Payment Gateway، نظام محاسبة، فواتير، وNet Bank Business.',target:'شركات ومشاريع'},
    {n:'Enterprise',ic:'🚀',d:'حلول مخصصة بالكامل مع Web Shop، ربط ERP، عمولات مخصصة، وتطوير حسب الطلب.',target:'مؤسسات كبيرة'},
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
  plans:[
    {n:'Personal',p:'€9.99',p2:'/month',c:'#9FE870',pop:false,btn:'Get Personal',cat:'personal'},
    {n:'Plus',p:'€19.99',p2:'/month',c:'#7C3AED',pop:true,btn:'Get Plus',cat:'personal'},
    {n:'Business',p:'€49',p2:'/month',c:'#2563EB',pop:false,btn:'Get Business',cat:'business'},
    {n:'Enterprise',p:'Custom',p2:'',c:'#B45309',pop:false,btn:'Contact us',cat:'business'},
  ],
  sections:[
    {cat:'Fees',rows:[
      {f:'Transfer fee',v:['2.5%','1.5%','1%','Custom']},
      {f:'Deposit fee',v:['2%','1%','0.8%','Custom']},
      {f:'Currency exchange',v:['+3%','+1.5%','+1%','Custom']},
      {f:'Crypto trading',v:['2%','1%','1%','Custom']},
    ]},
    {cat:'Cards & Accounts',rows:[
      {f:'Mastercard cards',v:['5','5','5','5']},
      {f:'Accounts',v:['5','5','5','5']},
    ]},
    {cat:'Smart Features',rows:[
      {f:'AI Assistant',v:['✅','✅','✅','✅']},
      {f:'Fraud protection',v:['✅','✅','✅','✅']},
      {f:'Cashback',v:['❌','1%','❌','✅']},
      {f:'Priority support',v:['❌','✅','✅','✅']},
    ]},
    {cat:'Business Features',rows:[
      {f:'Payment Gateway',v:['❌','❌','✅','✅']},
      {f:'Net Bank Business',v:['❌','❌','✅','✅']},
      {f:'Accounting system',v:['❌','❌','✅','✅']},
      {f:'Invoicing',v:['❌','❌','✅','✅']},
      {f:'Web Shop',v:['❌','❌','❌','✅']},
      {f:'API Access',v:['❌','❌','✅','✅']},
    ]},
  ],
  benefitsTitle:'Each plan has its perks',
  benefits:[
    {n:'Personal',ic:'⭐',d:'Personal account with Mastercard, transfers, currency exchange, and crypto trading. Everything you need for digital banking.',target:'Individuals'},
    {n:'Plus',ic:'💎',d:'Much lower fees, 1% cashback, and priority support. For clients who want more.',target:'Advanced users'},
    {n:'Business',ic:'🏢',d:'Complete business account with Payment Gateway, accounting system, invoicing, and Net Bank Business.',target:'Companies & startups'},
    {n:'Enterprise',ic:'🚀',d:'Fully custom solutions with Web Shop, ERP integration, custom fees, and bespoke development.',target:'Large enterprises'},
  ],
  faqTitle:'FAQ',
  faqs:[
    {q:'Can I change plans later?',a:'Yes — upgrade or downgrade anytime from the app instantly.'},
    {q:'Can I cancel my subscription?',a:'Yes anytime. No contracts or commitments.'},
    {q:'What is the difference between Personal and Plus?',a:'Plus offers much lower fees (1.5% vs 2.5% for transfers), 1% cashback, and priority support.'},
    {q:'What does Business include?',a:'Everything your business needs: Payment Gateway, accounting system, invoicing, employee permissions, and API.'},
  ],
  ctaTitle:'Start today',ctaSub:'Choose the right plan and get started in minutes.',ctaBtn:'Open your account →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<!-- Personal Plans -->
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.persTitle }}</h2><div class="plan-g plan-g2"><div v-for="p in t.plans.filter(x=>x.cat==='personal')" :key="p.n" class="plan-c" :class="{'plan-pop':p.pop}"><div v-if="p.pop" class="plan-badge">{{ isAr?'الأكثر طلباً':'Most popular' }}</div><div class="plan-bar" :style="{background:p.c}"></div><h3 class="plan-n">{{ p.n }}</h3><div class="plan-price"><span class="plan-p">{{ p.p }}</span><span class="plan-p2">{{ p.p2 }}</span></div><a href="/preregister" class="plan-btn" :style="{background:p.c}">{{ p.btn }}</a></div></div></div></section>

<!-- Business Plans -->
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.bizTitle }}</h2><div class="plan-g plan-g2"><div v-for="p in t.plans.filter(x=>x.cat==='business')" :key="p.n" class="plan-c" :class="{'plan-pop':p.pop}"><div v-if="p.pop" class="plan-badge">{{ isAr?'الأكثر طلباً':'Most popular' }}</div><div class="plan-bar" :style="{background:p.c}"></div><h3 class="plan-n">{{ p.n }}</h3><div class="plan-price"><span class="plan-p">{{ p.p }}</span><span class="plan-p2">{{ p.p2 }}</span></div><a :href="p.n==='Enterprise'?'/contact':'/preregister'" class="plan-btn" :style="{background:p.c}">{{ p.btn }}</a></div></div></div></section>

<!-- Comparison Table -->
<section class="sec"><div class="sw"><div v-for="s in t.sections" :key="s.cat" class="cmp-sec"><h3 class="cmp-cat">{{ s.cat }}</h3><div class="cmp-grid"><div class="cmp-header"><div class="cmp-h-label"></div><div v-for="p in t.plans" :key="p.n" class="cmp-h-plan" :style="{borderTopColor:p.c}">{{ p.n }}</div></div><div v-for="r in s.rows" :key="r.f" class="cmp-row"><div class="cmp-feat">{{ r.f }}</div><div v-for="(v,i) in r.v" :key="i" class="cmp-val" :class="{'cmp-yes':v==='✅','cmp-no':v==='❌'}">{{ v }}</div></div></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.benefitsTitle }}</h2><div class="g4"><div v-for="b in t.benefits" :key="b.n" class="ben-c"><span class="ben-ic">{{ b.ic }}</span><h4 class="ben-n">{{ b.n }}</h4><p class="ben-d">{{ b.d }}</p><span class="ben-target">{{ b.target }}</span></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.faqTitle }}</h2><div class="faqs"><div v-for="f in t.faqs" :key="f.q" class="faq-c"><h4 class="faq-q">{{ f.q }}</h4><p class="faq-a">{{ f.a }}</p></div></div></div></section>

<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F9F3}.sec-sky{background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px}.t2-w{color:#fff}.t2-em{color:#9FE870}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 60px;background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.6);text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}.p-hero-em{color:#9FE870}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto;line-height:1.8}
.plan-g{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.plan-g2{grid-template-columns:repeat(2,1fr);max-width:700px;margin:0 auto}
.plan-c{padding:32px 24px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:20px;text-align:center;position:relative;overflow:hidden;transition:all .3s}.plan-c:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(159,232,112,.08)}
.plan-pop{border:2px solid #7C3AED;box-shadow:0 8px 30px rgba(124,58,237,.12)}
.plan-badge{position:absolute;top:12px;right:12px;background:#7C3AED;color:#fff;font-size:10px;font-weight:800;padding:4px 10px;border-radius:6px}
.rtl .plan-badge{right:auto;left:12px}
.plan-bar{height:4px;position:absolute;top:0;left:0;right:0}
.plan-n{font-size:18px;font-weight:900;color:#163300;margin:14px 0 8px}
.plan-price{margin-bottom:20px}.plan-p{font-size:32px;font-weight:900;color:#9FE870}.plan-p2{font-size:13px;color:rgba(10,10,10,.3);margin-inline-start:4px}
.plan-btn{display:block;padding:12px;color:#fff;font-size:14px;font-weight:700;border-radius:10px;text-decoration:none;transition:all .2s}.plan-btn:hover{opacity:.9;transform:translateY(-1px)}
.cmp-sec{margin-bottom:40px}
.cmp-cat{font-size:16px;font-weight:800;color:#9FE870;margin-bottom:12px;padding-bottom:8px;border-bottom:2px solid rgba(159,232,112,.1)}
.cmp-grid{border:1px solid rgba(159,232,112,.08);border-radius:16px;overflow:hidden}
.cmp-header{display:grid;grid-template-columns:1.5fr repeat(4,1fr);background:#F5F9F3}
.cmp-h-label{padding:12px 16px}
.cmp-h-plan{padding:12px 16px;text-align:center;font-size:12px;font-weight:800;color:#163300;border-top:3px solid}
.cmp-row{display:grid;grid-template-columns:1.5fr repeat(4,1fr);border-top:1px solid rgba(159,232,112,.05)}
.cmp-feat{padding:10px 16px;font-size:13px;font-weight:600;color:#163300}
.cmp-val{padding:10px 16px;text-align:center;font-size:12px;color:rgba(10,10,10,.5)}
.cmp-yes{color:#059669;font-weight:700}.cmp-no{color:rgba(10,10,10,.15)}
.cmp-row:nth-child(odd){background:rgba(159,232,112,.01)}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.ben-c{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:18px;text-align:center;transition:all .3s}.ben-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(159,232,112,.06)}
.ben-ic{font-size:36px;display:block;margin-bottom:12px}.ben-n{font-size:16px;font-weight:900;color:#163300;margin-bottom:8px}.ben-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75;margin-bottom:12px}
.ben-target{font-size:11px;font-weight:700;color:#9FE870;background:rgba(159,232,112,.06);padding:4px 12px;border-radius:6px}
.faqs{max-width:700px;margin:0 auto;display:flex;flex-direction:column;gap:12px}
.faq-c{padding:24px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:16px}
.faq-q{font-size:15px;font-weight:800;margin-bottom:8px;color:#163300}.faq-a{font-size:13px;color:rgba(10,10,10,.4);line-height:1.8}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:900px){.plan-g{grid-template-columns:repeat(2,1fr)}.g4{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.plan-g,.plan-g2{grid-template-columns:1fr}.cmp-header,.cmp-row{grid-template-columns:1.2fr repeat(4,1fr)}.cmp-feat,.cmp-val,.cmp-h-plan,.cmp-h-label{padding:8px;font-size:10px}.g4{grid-template-columns:1fr}}
</style>
