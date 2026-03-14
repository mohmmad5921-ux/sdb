<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'حساب Business — SDB Bank',tag:'Business',
  heroH:'حساب Business.',heroEm:'لشركتك.',
  heroP:'حساب تجاري متكامل — Payment Gateway، Net Bank Business، نظام محاسبة، فواتير، وعمولات منافسة. كل ما تحتاجه شركتك.',
  price:'€49',priceNote:'/شهر',
  heroBtn:'احصل على Business ←',
  inclTitle:'كل ما تحتاجه شركتك',
  incl:['5 بطاقات Mastercard للموظفين','5 حسابات','عمولة تحويل 1%','عمولة إيداع 0.8%','صرف عملات +1%','Payment Gateway لموقعك','Net Bank Business','نظام محاسبة متكامل','إنشاء وإرسال فواتير','مستخدمين متعددين + صلاحيات','AI مساعد ذكي','تأمين ضد الاحتيال','دعم أولوية','API Access'],
  feesTitle:'العمولات',
  fees:[{l:'تحويل',v:'1%'},{l:'إيداع',v:'0.8%'},{l:'صرف عملات',v:'+1%'},{l:'كريبتو',v:'1%'}],
  bizTitle:'ميزات الأعمال',
  bizFeats:[
    {ic:'🌐',t:'Payment Gateway',d:'اقبل المدفوعات على موقعك الإلكتروني مباشرة. ربط سهل وآمن مع Stripe.'},
    {ic:'🏦',t:'Net Bank Business',d:'واجهة بنكية ويب احترافية لإدارة حسابات شركتك من أي مكان.'},
    {ic:'📊',t:'نظام محاسبة',d:'نظام محاسبة متكامل مع تقارير مالية وتصدير Excel. كل شي بمكان واحد.'},
    {ic:'🧾',t:'فواتير',d:'أنشئ وأرسل فواتير احترافية لعملائك مباشرة من حسابك.'},
    {ic:'👥',t:'صلاحيات الموظفين',d:'أضف موظفيك وحدد صلاحياتهم — من يرسل، من يشاهد، من يوافق.'},
    {ic:'🔐',t:'API Access',d:'اربط SDB مع أنظمتك الموجودة عبر API آمن ومرن.'},
  ],
  upgradeTitle:'تحتاج أكثر؟',upgradeFade:'اكتشف Enterprise',
  upgradeDesc:'حلول مخصصة بالكامل مع Web Shop، ربط ERP، عمولات مخصصة، وتطوير حسب الطلب.',
  upgradeBtn:'اكتشف Enterprise ←',upgradeBtnAll:'قارن كل الباقات',
  ctaTitle:'ابدأ مع Business',ctaSub:'حساب تجاري متكامل بـ €49/شهر.',ctaBtn:'احصل على Business ←',
} : {
  title:'Business Account — SDB Bank',tag:'Business',
  heroH:'Business Account.',heroEm:'For your company.',
  heroP:'Complete business account — Payment Gateway, Net Bank Business, accounting system, invoicing, and competitive fees. Everything your business needs.',
  price:'€49',priceNote:'/month',
  heroBtn:'Get Business →',
  inclTitle:'Everything your business needs',
  incl:['5 Mastercard cards for employees','5 accounts','1% transfer fee','0.8% deposit fee','+1% currency exchange','Payment Gateway for your website','Net Bank Business','Complete accounting system','Create & send invoices','Multi-user access + permissions','AI assistant','Fraud protection','Priority support','API Access'],
  feesTitle:'Fees',
  fees:[{l:'Transfer',v:'1%'},{l:'Deposit',v:'0.8%'},{l:'Currency exchange',v:'+1%'},{l:'Crypto',v:'1%'}],
  bizTitle:'Business Features',
  bizFeats:[
    {ic:'🌐',t:'Payment Gateway',d:'Accept payments on your website directly. Easy and secure Stripe integration.'},
    {ic:'🏦',t:'Net Bank Business',d:'Professional web banking interface to manage your company accounts from anywhere.'},
    {ic:'📊',t:'Accounting System',d:'Complete accounting with financial reports and Excel export. Everything in one place.'},
    {ic:'🧾',t:'Invoicing',d:'Create and send professional invoices to your clients directly from your account.'},
    {ic:'👥',t:'Employee Permissions',d:'Add employees and set permissions — who sends, who views, who approves.'},
    {ic:'🔐',t:'API Access',d:'Connect SDB with your existing systems via a secure and flexible API.'},
  ],
  upgradeTitle:'Need more?',upgradeFade:'Discover Enterprise',
  upgradeDesc:'Fully custom solutions with Web Shop, ERP integration, custom fees, and bespoke development.',
  upgradeBtn:'Discover Enterprise →',upgradeBtnAll:'Compare all plans',
  ctaTitle:'Start with Business',ctaSub:'Complete business account at €49/month.',ctaBtn:'Get Business →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><div class="price-box"><span class="price-v">{{ t.price }}</span><span class="price-n">{{ t.priceNote }}</span></div><a href="/preregister" class="hero-btn">{{ t.heroBtn }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.inclTitle }}</h2><div class="incl-grid"><div v-for="i in t.incl" :key="i" class="incl-i">✓ {{ i }}</div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.feesTitle }}</h2><div class="g4"><div v-for="f in t.fees" :key="f.l" class="lim"><div class="lim-v">{{ f.v }}</div><div class="lim-l">{{ f.l }}</div></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.bizTitle }}</h2><div class="g3"><div v-for="b in t.bizFeats" :key="b.t" class="biz-c"><span class="biz-ic">{{ b.ic }}</span><h3 class="biz-t">{{ b.t }}</h3><p class="biz-d">{{ b.d }}</p></div></div></div></section>
<section class="sec sec-alt"><div class="sw sec-hdr tc"><h2 class="t2">{{ t.upgradeTitle }}<br><span class="t2-em">{{ t.upgradeFade }}</span></h2><p class="t2-sub tc" style="margin:0 auto 24px">{{ t.upgradeDesc }}</p><div class="cta-row"><Link href="/cards/elite" class="link-btn-lg">{{ t.upgradeBtn }}</Link><Link href="/plans" class="link-btn-lg link-sec">{{ t.upgradeBtnAll }}</Link></div></div></section>
<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#EFF6FF}.sec-sky{background:linear-gradient(135deg,#1E3A5F,#2563EB);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}.t2-em{color:#2563EB}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#1E3A5F,#1D4ED8,#2563EB);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#93C5FD}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:580px;margin:0 auto 28px;line-height:1.8}
.price-box{margin-bottom:28px}.price-v{font-size:48px;font-weight:900;color:#fff}.price-n{font-size:16px;color:rgba(255,255,255,.4)}
.hero-btn{display:inline-block;padding:16px 44px;background:#fff;color:#1E3A5F;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.hero-btn:hover{transform:translateY(-2px)}
.incl-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.incl-i{padding:16px 20px;background:#fff;border:1px solid rgba(37,99,235,.06);border-radius:12px;font-size:13px;font-weight:600;color:#1E3A5F}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.lim{padding:28px;background:#fff;border:1px solid rgba(37,99,235,.06);border-radius:16px;text-align:center}
.lim-v{font-size:28px;font-weight:900;color:#2563EB;margin-bottom:4px}.lim-l{font-size:12px;color:rgba(10,10,10,.4)}
.biz-c{padding:28px;background:#fff;border:1px solid rgba(37,99,235,.06);border-radius:18px;transition:all .3s}.biz-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(37,99,235,.06)}
.biz-ic{font-size:28px;display:block;margin-bottom:10px}.biz-t{font-size:15px;font-weight:800;color:#1E3A5F;margin-bottom:6px}.biz-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.cta-row{display:flex;gap:16px;justify-content:center}
.link-btn-lg{font-size:15px;font-weight:700;color:#2563EB;text-decoration:none;padding:12px 28px;border:2px solid rgba(37,99,235,.15);border-radius:12px;transition:all .2s}.link-btn-lg:hover{border-color:#2563EB;background:rgba(37,99,235,.04)}
.link-sec{color:rgba(10,10,10,.3);border-color:rgba(10,10,10,.08)}.link-sec:hover{color:#1E3A5F;border-color:rgba(10,10,10,.15)}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#1E3A5F;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
.sec-hdr{margin-bottom:0}
@media(max-width:768px){.incl-grid,.g3{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}}
</style>
