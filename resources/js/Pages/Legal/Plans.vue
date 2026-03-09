<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'الباقات والأسعار — SDB Bank',tag:'باقات SDB',
  heroH:'اختر الباقة',heroEm:'المناسبة لك.',
  heroP:'4 مستويات تناسب كل أسلوب حياة — من Standard المجاني إلى Elite الفاخر. كل باقة بمميزات حصرية.',
  plans:[
    {n:'Standard',p:'مجاني',p2:'للأبد',c:'#0EA5E9',pop:false,btn:'ابدأ مجاناً'},
    {n:'Plus',p:'€3.99',p2:'/شهر',c:'#7C3AED',pop:false,btn:'احصل على Plus'},
    {n:'Premium',p:'€7.99',p2:'/شهر',c:'#DB2777',pop:true,btn:'احصل على Premium'},
    {n:'Elite',p:'€14.99',p2:'/شهر',c:'#B45309',pop:false,btn:'احصل على Elite'},
  ],
  sections:[
    {cat:'البطاقة',rows:[
      {f:'بطاقة افتراضية',v:['✅','✅','✅','✅']},
      {f:'بطاقة فعلية',v:['€9.99','✅ مجاناً','✅ معدنية','✅ معدنية ذهبية']},
      {f:'Apple/Google Pay',v:['✅','✅','✅','✅']},
      {f:'CVV ديناميكي',v:['❌','✅','✅','✅']},
      {f:'بطاقات إضافية',v:['❌','1','3','5']},
    ]},
    {cat:'التحويلات',rows:[
      {f:'داخلي SDB',v:['مجاني ♾️','مجاني ♾️','مجاني ♾️','مجاني ♾️']},
      {f:'SEPA أوروبي',v:['مجاني','مجاني','مجاني','مجاني']},
      {f:'SWIFT دولي',v:['0.5%','0.3%','0.1%','مجاني']},
      {f:'حد شهري',v:['€5,000','€20,000','€50,000','€200,000']},
      {f:'تحويلات جملة',v:['❌','❌','✅','✅']},
    ]},
    {cat:'صرف العملات',rows:[
      {f:'عملات مدعومة',v:['30+','30+','30+','30+']},
      {f:'صرف مجاني شهري',v:['€1,000','€5,000','غير محدود','غير محدود']},
      {f:'سعر السوق الحقيقي',v:['✅','✅','✅','✅']},
      {f:'تنبيهات الأسعار',v:['❌','✅','✅','✅']},
    ]},
    {cat:'سحب ATM',rows:[
      {f:'سحب مجاني شهري',v:['€500','€2,000','€5,000','€10,000']},
      {f:'رسوم إضافية',v:['2%','1%','مجاني','مجاني']},
    ]},
    {cat:'التأمين والحماية',rows:[
      {f:'حماية مشتريات',v:['❌','€1,000','€5,000','€10,000']},
      {f:'تأمين سفر',v:['❌','❌','✅','✅ شامل']},
      {f:'تأمين تأخير رحلة',v:['❌','❌','✅','✅']},
      {f:'تأمين طبي سفر',v:['❌','❌','❌','✅']},
    ]},
    {cat:'صالات المطار',rows:[
      {f:'صالات LoungeKey',v:['❌','❌','4/سنة','غير محدود']},
      {f:'ضيف مجاني',v:['❌','❌','❌','✅']},
    ]},
    {cat:'إضافية',rows:[
      {f:'eSIM بيانات',v:['❌','❌','3GB/شهر','10GB/شهر']},
      {f:'Cashback',v:['❌','❌','0.5%','1%']},
      {f:'مدير حساب شخصي',v:['❌','❌','❌','✅']},
      {f:'أولوية الدعم',v:['❌','✅','✅','✅ 24/7']},
      {f:'تحليلات متقدمة',v:['أساسية','✅','✅','✅ + AI']},
    ]},
  ],
  benefitsTitle:'لكل باقة مميزاتها',
  benefits:[
    {n:'Standard',ic:'🆓',d:'مثالي للاستخدام اليومي. حساب مجاني مع بطاقة افتراضية وتحويلات مجانية. كل ما تحتاجه للبدء.',target:'أي شخص يبحث عن بنك رقمي'},
    {n:'Plus',ic:'💎',d:'لمن يريد المزيد. بطاقة فعلية، CVV ديناميكي، حدود أعلى. مثالي للمسافرين المتكررين.',target:'مسافرون متكررون'},
    {n:'Premium',ic:'👑',d:'تجربة بنكية لا مثيل لها. بطاقة معدنية، صالات مطار، تأمين سفر، صرف بلا حدود.',target:'أسلوب حياة فاخر'},
    {n:'Elite',ic:'🏆',d:'أعلى مستوى. مدير شخصي، VIP lounges بلا حدود، cashback 1%، تأمين صحي شامل.',target:'رجال أعمال وكبار العملاء'},
  ],
  faqTitle:'أسئلة شائعة',
  faqs:[
    {q:'هل يمكنني تغيير الباقة لاحقاً؟',a:'نعم — يمكنك الترقية أو التخفيض بأي وقت من التطبيق فوراً.'},
    {q:'هل الباقة المجانية محدودة؟',a:'باقة Standard تتضمن كل الأساسيات: حساب + بطاقة + تحويلات. الباقات الأعلى تضيف مميزات إضافية.'},
    {q:'هل يمكنني إلغاء الاشتراك؟',a:'نعم بأي وقت. حسابك يرجع لباقة Standard المجانية تلقائياً.'},
    {q:'ماذا أحصل مع البطاقة المعدنية؟',a:'بطاقة ماستركارد معدنية فاخرة بتصميم حصري مع شحن مجاني لعنوانك.'},
  ],
  ctaTitle:'ابدأ مجاناً',ctaSub:'Standard مجاني للأبد. ترقية بأي وقت.',ctaBtn:'افتح حسابك ←',
} : {
  title:'Plans & Pricing — SDB Bank',tag:'SDB Plans',
  heroH:'Choose the plan',heroEm:'that fits you.',
  heroP:'4 tiers to match every lifestyle — from free Standard to premium Elite. Each plan with exclusive features.',
  plans:[
    {n:'Standard',p:'Free',p2:'forever',c:'#0EA5E9',pop:false,btn:'Start free'},
    {n:'Plus',p:'€3.99',p2:'/month',c:'#7C3AED',pop:false,btn:'Get Plus'},
    {n:'Premium',p:'€7.99',p2:'/month',c:'#DB2777',pop:true,btn:'Get Premium'},
    {n:'Elite',p:'€14.99',p2:'/month',c:'#B45309',pop:false,btn:'Get Elite'},
  ],
  sections:[
    {cat:'Card',rows:[
      {f:'Virtual card',v:['✅','✅','✅','✅']},
      {f:'Physical card',v:['€9.99','✅ Free','✅ Metal','✅ Gold metal']},
      {f:'Apple/Google Pay',v:['✅','✅','✅','✅']},
      {f:'Dynamic CVV',v:['❌','✅','✅','✅']},
      {f:'Extra cards',v:['❌','1','3','5']},
    ]},
    {cat:'Transfers',rows:[
      {f:'SDB internal',v:['Free ♾️','Free ♾️','Free ♾️','Free ♾️']},
      {f:'SEPA European',v:['Free','Free','Free','Free']},
      {f:'SWIFT International',v:['0.5%','0.3%','0.1%','Free']},
      {f:'Monthly limit',v:['€5,000','€20,000','€50,000','€200,000']},
      {f:'Bulk transfers',v:['❌','❌','✅','✅']},
    ]},
    {cat:'Currency Exchange',rows:[
      {f:'Supported currencies',v:['30+','30+','30+','30+']},
      {f:'Free monthly FX',v:['€1,000','€5,000','Unlimited','Unlimited']},
      {f:'Real market rate',v:['✅','✅','✅','✅']},
      {f:'Rate alerts',v:['❌','✅','✅','✅']},
    ]},
    {cat:'ATM Withdrawal',rows:[
      {f:'Free monthly ATM',v:['€500','€2,000','€5,000','€10,000']},
      {f:'Extra fee',v:['2%','1%','Free','Free']},
    ]},
    {cat:'Insurance & Protection',rows:[
      {f:'Purchase protection',v:['❌','€1,000','€5,000','€10,000']},
      {f:'Travel insurance',v:['❌','❌','✅','✅ Comprehensive']},
      {f:'Flight delay insurance',v:['❌','❌','✅','✅']},
      {f:'Travel medical',v:['❌','❌','❌','✅']},
    ]},
    {cat:'Airport Lounges',rows:[
      {f:'LoungeKey access',v:['❌','❌','4/year','Unlimited']},
      {f:'Free guest',v:['❌','❌','❌','✅']},
    ]},
    {cat:'Extras',rows:[
      {f:'eSIM data',v:['❌','❌','3GB/mo','10GB/mo']},
      {f:'Cashback',v:['❌','❌','0.5%','1%']},
      {f:'Personal manager',v:['❌','❌','❌','✅']},
      {f:'Support priority',v:['❌','✅','✅','✅ 24/7']},
      {f:'Advanced analytics',v:['Basic','✅','✅','✅ + AI']},
    ]},
  ],
  benefitsTitle:'Each plan has its perks',
  benefits:[
    {n:'Standard',ic:'🆓',d:'Perfect for daily use. Free account with virtual card and free transfers. Everything you need to start.',target:'Anyone looking for a digital bank'},
    {n:'Plus',ic:'💎',d:'For those who want more. Physical card, dynamic CVV, higher limits. Ideal for frequent travelers.',target:'Frequent travelers'},
    {n:'Premium',ic:'👑',d:'Unmatched banking experience. Metal card, airport lounges, travel insurance, unlimited FX.',target:'Luxury lifestyle'},
    {n:'Elite',ic:'🏆',d:'Highest tier. Personal manager, unlimited VIP lounges, 1% cashback, comprehensive health insurance.',target:'Business leaders & VIPs'},
  ],
  faqTitle:'FAQ',
  faqs:[
    {q:'Can I change plans later?',a:'Yes — upgrade or downgrade anytime from the app instantly.'},
    {q:'Is the free plan limited?',a:'Standard includes all basics: account + card + transfers. Higher plans add extra features.'},
    {q:'Can I cancel my subscription?',a:'Yes anytime. Your account reverts to free Standard automatically.'},
    {q:'What comes with the metal card?',a:'Premium Mastercard metal card with exclusive design, free shipping to your address.'},
  ],
  ctaTitle:'Start for free',ctaSub:'Standard is free forever. Upgrade anytime.',ctaBtn:'Open your account →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<section class="sec"><div class="sw"><div class="plan-g"><div v-for="p in t.plans" :key="p.n" class="plan-c" :class="{'plan-pop':p.pop}"><div v-if="p.pop" class="plan-badge">{{ isAr?'الأكثر طلباً':'Most popular' }}</div><div class="plan-bar" :style="{background:p.c}"></div><h3 class="plan-n">{{ p.n }}</h3><div class="plan-price"><span class="plan-p">{{ p.p }}</span><span class="plan-p2">{{ p.p2 }}</span></div><a href="/preregister" class="plan-btn" :style="{background:p.c}">{{ p.btn }}</a></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><div v-for="s in t.sections" :key="s.cat" class="cmp-sec"><h3 class="cmp-cat">{{ s.cat }}</h3><div class="cmp-grid"><div class="cmp-header"><div class="cmp-h-label"></div><div v-for="p in t.plans" :key="p.n" class="cmp-h-plan" :style="{borderTopColor:p.c}">{{ p.n }}</div></div><div v-for="r in s.rows" :key="r.f" class="cmp-row"><div class="cmp-feat">{{ r.f }}</div><div v-for="(v,i) in r.v" :key="i" class="cmp-val" :class="{'cmp-yes':v==='✅','cmp-no':v==='❌'}">{{ v }}</div></div></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.benefitsTitle }}</h2><div class="g4"><div v-for="b in t.benefits" :key="b.n" class="ben-c"><span class="ben-ic">{{ b.ic }}</span><h4 class="ben-n">{{ b.n }}</h4><p class="ben-d">{{ b.d }}</p><span class="ben-target">{{ b.target }}</span></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.faqTitle }}</h2><div class="faqs"><div v-for="f in t.faqs" :key="f.q" class="faq-c"><h4 class="faq-q">{{ f.q }}</h4><p class="faq-a">{{ f.a }}</p></div></div></div></section>

<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F0F9FF}.sec-sky{background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px}.t2-w{color:#fff}.t2-em{color:#0EA5E9}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 60px;background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.6);text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}.p-hero-em{color:#7DD3FC}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto;line-height:1.8}
.plan-g{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.plan-c{padding:32px 24px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:20px;text-align:center;position:relative;overflow:hidden;transition:all .3s}.plan-c:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(14,165,233,.08)}
.plan-pop{border:2px solid #DB2777;box-shadow:0 8px 30px rgba(219,39,119,.12)}
.plan-badge{position:absolute;top:12px;right:12px;background:#DB2777;color:#fff;font-size:10px;font-weight:800;padding:4px 10px;border-radius:6px}
.rtl .plan-badge{right:auto;left:12px}
.plan-bar{height:4px;position:absolute;top:0;left:0;right:0}
.plan-n{font-size:18px;font-weight:900;color:#0C4A6E;margin:14px 0 8px}
.plan-price{margin-bottom:20px}.plan-p{font-size:32px;font-weight:900;color:#0EA5E9}.plan-p2{font-size:13px;color:rgba(10,10,10,.3);margin-inline-start:4px}
.plan-btn{display:block;padding:12px;color:#fff;font-size:14px;font-weight:700;border-radius:10px;text-decoration:none;transition:all .2s}.plan-btn:hover{opacity:.9;transform:translateY(-1px)}
.cmp-sec{margin-bottom:40px}
.cmp-cat{font-size:16px;font-weight:800;color:#0EA5E9;margin-bottom:12px;padding-bottom:8px;border-bottom:2px solid rgba(14,165,233,.1)}
.cmp-grid{border:1px solid rgba(14,165,233,.08);border-radius:16px;overflow:hidden}
.cmp-header{display:grid;grid-template-columns:1.5fr repeat(4,1fr);background:#F0F9FF}
.cmp-h-label{padding:12px 16px}
.cmp-h-plan{padding:12px 16px;text-align:center;font-size:12px;font-weight:800;color:#0C4A6E;border-top:3px solid}
.cmp-row{display:grid;grid-template-columns:1.5fr repeat(4,1fr);border-top:1px solid rgba(14,165,233,.05)}
.cmp-feat{padding:10px 16px;font-size:13px;font-weight:600;color:#0C4A6E}
.cmp-val{padding:10px 16px;text-align:center;font-size:12px;color:rgba(10,10,10,.5)}
.cmp-yes{color:#059669;font-weight:700}.cmp-no{color:rgba(10,10,10,.15)}
.cmp-row:nth-child(odd){background:rgba(14,165,233,.01)}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.ben-c{padding:28px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:18px;text-align:center;transition:all .3s}.ben-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(14,165,233,.06)}
.ben-ic{font-size:36px;display:block;margin-bottom:12px}.ben-n{font-size:16px;font-weight:900;color:#0C4A6E;margin-bottom:8px}.ben-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75;margin-bottom:12px}
.ben-target{font-size:11px;font-weight:700;color:#0EA5E9;background:rgba(14,165,233,.06);padding:4px 12px;border-radius:6px}
.faqs{max-width:700px;margin:0 auto;display:flex;flex-direction:column;gap:12px}
.faq-c{padding:24px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:16px}
.faq-q{font-size:15px;font-weight:800;margin-bottom:8px;color:#0C4A6E}.faq-a{font-size:13px;color:rgba(10,10,10,.4);line-height:1.8}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#0C4A6E;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:900px){.plan-g{grid-template-columns:repeat(2,1fr)}.g4{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.plan-g{grid-template-columns:1fr}.cmp-header,.cmp-row{grid-template-columns:1.2fr repeat(4,1fr)}.cmp-feat,.cmp-val,.cmp-h-plan,.cmp-h-label{padding:8px;font-size:10px}.g4{grid-template-columns:1fr}}
</style>
