<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'الحساب التجاري — SDB Bank',tag:'حسابات الأعمال',
  heroH:'عملك يستحق',heroEm:'بنك بمستواه.',
  heroP:'حساب تجاري متكامل لإدارة أموال شركتك. بطاقات لكل موظف، فواتير إلكترونية، تكامل مع أنظمة المحاسبة، وتقارير مالية تفصيلية.',
  heroBtn:'افتح حساب تجاري ←',
  statsRow:[{v:'€200K',l:'حد شهري'},{v:'50',l:'بطاقة موظف'},{v:'30+',l:'عملة'},{v:'0.5%',l:'تحويل دولي'}],
  featTitle:'كل ما تحتاجه لإدارة أعمالك',
  feats:[
    {ic:'💳',t:'بطاقات الموظفين',d:'أصدر بطاقات ماستركارد لكل موظف بحدود مصاريف مخصصة. تتبع مصاريف كل بطاقة لحظياً. ألغِ أو جمّد أي بطاقة فوراً من لوحة التحكم.'},
    {ic:'🧾',t:'فواتير إلكترونية',d:'أنشئ وأرسل فواتير احترافية لعملائك مباشرة من التطبيق. تتبع الفواتير المدفوعة والمعلقة. تذكيرات دفع تلقائية.'},
    {ic:'📊',t:'تقارير مالية',d:'تقارير يومية وأسبوعية وشهرية وسنوية. تصدير CSV/PDF. تصنيف المصاريف تلقائياً. رؤى مالية بالذكاء الاصطناعي.'},
    {ic:'🔗',t:'تكامل API',d:'API مفتوح للتكامل مع أنظمة المحاسبة (Xero, QuickBooks). Webhooks لأحداث الحساب. SDK متاحة.'},
    {ic:'💱',t:'صرف عملات',d:'30+ عملة بأسعار السوق الحقيقية. مثالي للتجارة الدولية. لا هوامش ربح مخفية.'},
    {ic:'⚡',t:'تحويلات جملة',d:'حوّل لعدة مستفيدين دفعة واحدة عبر ملف CSV. مثالي لرواتب الموظفين والموردين.'},
    {ic:'👥',t:'إدارة الفريق',d:'أدوار مختلفة: مدير، محاسب، مشاهد. كل دور بصلاحيات محددة. سجل كامل لكل الأنشطة.'},
    {ic:'🏷️',t:'تصنيف المصاريف',d:'صنّف مصاريفك بعلامات مخصصة. مشاريع، أقسام، عملاء. تقارير حسب التصنيف.'},
    {ic:'🔐',t:'حماية متقدمة',d:'موافقات متعددة للتحويلات الكبيرة. سجل تدقيق كامل. تنبيهات أمنية فورية.'},
  ],
  plansTitle:'باقات الأعمال',
  plans:[
    {n:'Starter',p:'مجاني',c:'#9FE870',f:['حساب + IBAN','بطاقة واحدة','€5,000 تحويل/شهر','تقارير أساسية','دعم بريدي']},
    {n:'Growth',p:'€49/شهر',c:'#7C3AED',f:['10 بطاقات موظف','€50,000 تحويل/شهر','فواتير إلكترونية','تقارير متقدمة','دعم أولوية']},
    {n:'Enterprise',p:'€49/شهر',c:'#B45309',f:['50 بطاقة موظف','€200,000 تحويل/شهر','API كامل + Webhooks','مدير حساب مخصص','دعم 24/7 + SLA']},
  ],
  useCases:'قصص نجاح',
  cases:[
    {t:'مطعم سوري ببرلين',d:'يستخدم SDB Business لدفع رواتب 12 موظف ببطاقات مخصصة. الفواتير الإلكترونية وفّرت 10 ساعات شهرياً.'},
    {t:'شركة تصدير بإسطنبول',d:'تستخدم التحويلات الجملية لدفع 30+ مورد شهرياً. توفير 60% على رسوم التحويل الدولي.'},
    {t:'متجر إلكتروني بكوبنهاغن',d:'يستخدم API البنك للربط مع نظام المحاسبة. أتمتة كاملة للعمليات المالية.'},
  ],
  faqTitle:'أسئلة شائعة',
  faqs:[
    {q:'هل أحتاج سجل تجاري؟',a:'نعم، تحتاج سجل تجاري أو ما يعادله حسب بلد التسجيل.'},
    {q:'كم يستغرق فتح الحساب؟',a:'عادة 1-3 أيام عمل للشركات. التحقق من الوثائق يتم رقمياً.'},
    {q:'هل يمكنني تحويل من الحساب التجاري للشخصي؟',a:'نعم — تحويلات فورية ومجانية بين حساباتك.'},
    {q:'ما هي العملات المدعومة؟',a:'30+ عملة بما فيها EUR, USD, GBP, TRY, AED, SAR وغيرها.'},
  ],
  ctaTitle:'جاهز لتنمية عملك؟',ctaSub:'افتح حساب تجاري وابدأ بإدارة أموال شركتك باحترافية.',ctaBtn:'افتح حساب تجاري ←',
} : {
  title:'Business Account — SDB Bank',tag:'Business Accounts',
  heroH:'Your business deserves',heroEm:'a world-class bank.',
  heroP:'Complete business account for managing your company\'s finances. Employee cards, e-invoicing, accounting integration, and detailed financial reports.',
  heroBtn:'Open business account →',
  statsRow:[{v:'€200K',l:'Monthly limit'},{v:'50',l:'Employee cards'},{v:'30+',l:'Currencies'},{v:'0.5%',l:'International'}],
  featTitle:'Everything you need to run your business',
  feats:[
    {ic:'💳',t:'Employee Cards',d:'Issue Mastercards for each employee with custom spending limits. Track every card\'s spending in real-time. Freeze or cancel any card instantly.'},
    {ic:'🧾',t:'E-Invoicing',d:'Create and send professional invoices directly from the app. Track paid and pending invoices. Automatic payment reminders.'},
    {ic:'📊',t:'Financial Reports',d:'Daily, weekly, monthly, and annual reports. CSV/PDF export. Auto-categorized expenses. AI-powered financial insights.'},
    {ic:'🔗',t:'API Integration',d:'Open API for accounting integration (Xero, QuickBooks). Account event webhooks. SDKs available.'},
    {ic:'💱',t:'FX Exchange',d:'30+ currencies at real market rates. Perfect for international trade. No hidden markup.'},
    {ic:'⚡',t:'Bulk Transfers',d:'Transfer to multiple beneficiaries at once via CSV upload. Ideal for payroll and supplier payments.'},
    {ic:'👥',t:'Team Management',d:'Different roles: admin, accountant, viewer. Each role with specific permissions. Complete activity log.'},
    {ic:'🏷️',t:'Expense Tags',d:'Categorize expenses with custom tags. Projects, departments, clients. Reports by category.'},
    {ic:'🔐',t:'Advanced Security',d:'Multi-approval for large transfers. Complete audit trail. Instant security alerts.'},
  ],
  plansTitle:'Business Plans',
  plans:[
    {n:'Starter',p:'Free',c:'#9FE870',f:['Account + IBAN','1 card','€5,000 transfers/mo','Basic reports','Email support']},
    {n:'Growth',p:'€49/mo',c:'#7C3AED',f:['10 employee cards','€50,000 transfers/mo','E-invoicing','Advanced reports','Priority support']},
    {n:'Enterprise',p:'€49/mo',c:'#B45309',f:['50 employee cards','€200,000 transfers/mo','Full API + Webhooks','Dedicated manager','24/7 support + SLA']},
  ],
  useCases:'Success Stories',
  cases:[
    {t:'Syrian Restaurant in Berlin',d:'Uses SDB Business for 12 employee payroll with custom cards. E-invoicing saves 10 hours monthly.'},
    {t:'Export Company in Istanbul',d:'Uses bulk transfers for 30+ monthly suppliers. 60% savings on international transfer fees.'},
    {t:'Online Store in Copenhagen',d:'Uses bank API for accounting integration. Fully automated financial operations.'},
  ],
  faqTitle:'FAQ',
  faqs:[
    {q:'Do I need a business registration?',a:'Yes, you need a commercial registration or equivalent from your country of incorporation.'},
    {q:'How long to open an account?',a:'Usually 1-3 business days for companies. Document verification is digital.'},
    {q:'Can I transfer between business and personal?',a:'Yes — instant and free transfers between your accounts.'},
    {q:'What currencies are supported?',a:'30+ currencies including EUR, USD, GBP, TRY, AED, SAR and more.'},
  ],
  ctaTitle:'Ready to grow your business?',ctaSub:'Open a business account and start managing your company\'s finances professionally.',ctaBtn:'Open business account →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><a href="/preregister" class="hero-btn">{{ t.heroBtn }}</a><div class="stats-row"><div v-for="s in t.statsRow" :key="s.v" class="stat-i"><div class="stat-v">{{ s.v }}</div><div class="stat-l">{{ s.l }}</div></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.featTitle }}</h2><div class="g3"><div v-for="f in t.feats" :key="f.t" class="fcard"><span class="fcard-ic">{{ f.ic }}</span><h3 class="fcard-t">{{ f.t }}</h3><p class="fcard-d">{{ f.d }}</p></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.plansTitle }}</h2><div class="g3"><div v-for="p in t.plans" :key="p.n" class="plan-c"><div class="plan-bar" :style="{background:p.c}"></div><h3 class="plan-n">{{ p.n }}</h3><div class="plan-p">{{ p.p }}</div><ul class="plan-f"><li v-for="f in p.f" :key="f">✓ {{ f }}</li></ul><a href="/preregister" class="plan-btn" :style="{background:p.c}">{{ isAr?'ابدأ الآن':'Get started' }}</a></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.useCases }}</h2><div class="g3"><div v-for="c in t.cases" :key="c.t" class="case-c"><h4 class="case-t">{{ c.t }}</h4><p class="case-d">{{ c.d }}</p></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.faqTitle }}</h2><div class="faqs"><div v-for="f in t.faqs" :key="f.q" class="faq-c"><h4 class="faq-q">{{ f.q }}</h4><p class="faq-a">{{ f.a }}</p></div></div></div></section>

<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:100px 0}.sec-alt{background:#F5F9F3}.sec-sky{background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.6);text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}.p-hero-em{color:#9FE870}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:600px;margin:0 auto 32px;line-height:1.8}
.hero-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s;box-shadow:0 4px 16px rgba(0,0,0,.1)}.hero-btn:hover{transform:translateY(-2px)}
.stats-row{display:flex;gap:24px;justify-content:center;margin-top:48px;flex-wrap:wrap}
.stat-i{text-align:center;min-width:80px}.stat-v{font-size:28px;font-weight:900;color:#fff}.stat-l{font-size:11px;color:rgba(255,255,255,.4);margin-top:4px}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.fcard{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:18px;transition:all .3s}.fcard:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(159,232,112,.08)}
.fcard-ic{font-size:28px;display:block;margin-bottom:12px}.fcard-t{font-size:15px;font-weight:800;margin-bottom:8px;color:#163300}.fcard-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.plan-c{padding:32px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:20px;text-align:center;position:relative;overflow:hidden}
.plan-bar{height:4px;position:absolute;top:0;left:0;right:0}
.plan-n{font-size:20px;font-weight:900;margin:12px 0 4px;color:#163300}.plan-p{font-size:24px;font-weight:900;color:#9FE870;margin-bottom:20px}
.plan-f{list-style:none;padding:0;display:flex;flex-direction:column;gap:8px;margin-bottom:24px;text-align:start}.plan-f li{font-size:13px;color:rgba(10,10,10,.5);padding:6px 0;border-bottom:1px solid rgba(159,232,112,.06)}
.plan-btn{display:inline-block;padding:12px 32px;color:#fff;font-size:14px;font-weight:700;border-radius:10px;text-decoration:none;transition:all .2s}.plan-btn:hover{opacity:.9;transform:translateY(-2px)}
.case-c{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:18px;border-right:4px solid #9FE870}
.rtl .case-c{border-right:none;border-left:4px solid #9FE870}
.case-t{font-size:15px;font-weight:800;margin-bottom:8px;color:#163300}.case-d{font-size:13px;color:rgba(10,10,10,.4);line-height:1.75}
.faqs{max-width:700px;margin:0 auto;display:flex;flex-direction:column;gap:12px}
.faq-c{padding:24px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:16px}
.faq-q{font-size:15px;font-weight:800;margin-bottom:8px;color:#163300}.faq-a{font-size:13px;color:rgba(10,10,10,.4);line-height:1.8}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.g3{grid-template-columns:1fr}.stats-row{gap:16px}}
</style>
