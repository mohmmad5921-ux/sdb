<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'حساب Enterprise — SDB Bank',tag:'Enterprise · حلول مخصصة',
  heroH:'حساب Enterprise.',heroEm:'مخصص بالكامل.',
  heroP:'حلول بنكية مخصصة لمؤسستك — كل ميزات Business بالإضافة لـ Web Shop، ربط ERP، عمولات مخصصة، وتطوير حسب الطلب.',
  price:'مخصص',priceNote:'تواصل معنا للسعر',
  heroBtn:'تواصل معنا ←',
  inclTitle:'كل شيء في Business + حلول مخصصة',
  incl:['5 بطاقات Mastercard','5 حسابات','عمولات مخصصة حسب الحجم','كل ميزات Business','Web Shop متكامل (متجر إلكتروني)','ربط مع أنظمة ERP / SAP','تطوير ميزات حسب الطلب','بطاقات غير محدودة على الطلب','حلول دفع مخصصة','AI مساعد ذكي','تأمين ضد الاحتيال','كاشباك مخصص','دعم مخصص مع SLA','مدير حساب مخصص'],
  entTitle:'ميزات Enterprise الحصرية',
  ents:[
    {ic:'🛒',t:'Web Shop متكامل',d:'متجر إلكتروني متكامل مربوط مع حسابك — اقبل المدفوعات، أدر المنتجات، وتابع الطلبات.'},
    {ic:'🔗',t:'ربط ERP / SAP',d:'اربط SDB مع أنظمة ERP و SAP الموجودة لديك. تدفق بيانات تلقائي بدون تدخل يدوي.'},
    {ic:'💸',t:'عمولات مخصصة',d:'عمولات مفصلة حسب حجم عملياتك — كلما زاد الحجم، قلت العمولة.'},
    {ic:'🔧',t:'تطوير حسب الطلب',d:'فريق تطوير مخصص لبناء ميزات حسب احتياجاتك الفريدة.'},
    {ic:'👤',t:'مدير حساب مخصص',d:'مدير مخصص لك متاح بالهاتف أو الواتساب — يساعدك بكل شي.'},
    {ic:'📋',t:'SLA مخصص',d:'اتفاقية مستوى خدمة مخصصة تضمن استجابة سريعة وتوافر عالي.'},
  ],
  ctaTitle:'تواصل معنا',ctaSub:'حلول مخصصة لمؤسستك. دعنا نجد الحل المثالي لاحتياجاتك.',ctaBtn:'تواصل معنا ←',ctaBtn2:'قارن كل الباقات',
} : {
  title:'Enterprise Account — SDB Bank',tag:'Enterprise · Custom Solutions',
  heroH:'Enterprise Account.',heroEm:'Fully custom.',
  heroP:'Custom banking solutions for your organization — all Business features plus Web Shop, ERP integration, custom fees, and bespoke development.',
  price:'Custom',priceNote:'Contact us for pricing',
  heroBtn:'Contact us →',
  inclTitle:'Everything in Business + custom solutions',
  incl:['5 Mastercard cards','5 accounts','Custom fees based on volume','All Business features','Full Web Shop (e-commerce)','ERP / SAP integration','Custom feature development','Unlimited cards on request','Custom payment solutions','AI assistant','Fraud protection','Custom cashback','Dedicated support with SLA','Dedicated account manager'],
  entTitle:'Enterprise exclusive features',
  ents:[
    {ic:'🛒',t:'Full Web Shop',d:'Complete e-commerce shop linked to your account — accept payments, manage products, track orders.'},
    {ic:'🔗',t:'ERP / SAP Integration',d:'Connect SDB with your existing ERP and SAP systems. Automatic data flow without manual intervention.'},
    {ic:'💸',t:'Custom Fees',d:'Tailored fees based on your transaction volume — the higher the volume, the lower the fee.'},
    {ic:'🔧',t:'Custom Development',d:'Dedicated development team to build features tailored to your unique needs.'},
    {ic:'👤',t:'Dedicated Account Manager',d:'A dedicated manager available by phone or WhatsApp — helps with everything.'},
    {ic:'📋',t:'Custom SLA',d:'Custom service level agreement ensuring fast response and high availability.'},
  ],
  ctaTitle:'Contact us',ctaSub:'Custom solutions for your organization. Let us find the perfect solution for your needs.',ctaBtn:'Contact us →',ctaBtn2:'Compare all plans',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><div class="price-box"><span class="price-v">{{ t.price }}</span><span class="price-n">{{ t.priceNote }}</span></div><a href="/contact" class="hero-btn">{{ t.heroBtn }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.inclTitle }}</h2><div class="incl-grid"><div v-for="i in t.incl" :key="i" class="incl-i">✓ {{ i }}</div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.entTitle }}</h2><div class="g3"><div v-for="e in t.ents" :key="e.t" class="ent-c"><span class="ent-ic">{{ e.ic }}</span><h3 class="ent-t">{{ e.t }}</h3><p class="ent-d">{{ e.d }}</p></div></div></div></section>
<section class="sec sec-gold tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><div class="cta-row"><a href="/contact" class="cta-btn">{{ t.ctaBtn }}</a><Link href="/plans" class="cta-btn2">{{ t.ctaBtn2 }}</Link></div></div></section>
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
.price-box{margin-bottom:28px}.price-v{font-size:48px;font-weight:900;color:#fff}.price-n{display:block;font-size:16px;color:rgba(255,255,255,.4);margin-top:4px}
.hero-btn{display:inline-block;padding:16px 44px;background:linear-gradient(135deg,#FDE68A,#FBBF24);color:#78350F;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s;box-shadow:0 4px 16px rgba(251,191,36,.3)}.hero-btn:hover{transform:translateY(-2px)}
.incl-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.incl-i{padding:16px 20px;background:#fff;border:1px solid rgba(180,83,9,.06);border-radius:12px;font-size:13px;font-weight:600;color:#78350F}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.ent-c{padding:28px;background:#fff;border:1px solid rgba(180,83,9,.06);border-radius:18px;transition:all .3s}.ent-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(180,83,9,.06)}
.ent-ic{font-size:28px;display:block;margin-bottom:10px}.ent-t{font-size:15px;font-weight:800;color:#78350F;margin-bottom:6px}.ent-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.cta-row{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}
.cta-btn{display:inline-block;padding:16px 44px;background:linear-gradient(135deg,#FDE68A,#FBBF24);color:#78350F;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s;box-shadow:0 4px 16px rgba(251,191,36,.3)}.cta-btn:hover{transform:translateY(-2px)}
.cta-btn2{display:inline-block;padding:16px 44px;background:transparent;color:rgba(255,255,255,.6);font-size:15px;font-weight:600;border-radius:12px;text-decoration:none;border:2px solid rgba(255,255,255,.15);transition:all .2s}.cta-btn2:hover{border-color:rgba(255,255,255,.4)}
@media(max-width:768px){.incl-grid,.g3{grid-template-columns:1fr}}
</style>
