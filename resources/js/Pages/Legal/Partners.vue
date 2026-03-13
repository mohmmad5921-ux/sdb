<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'الشراكات — SDB Bank',tag:'الشراكات',
  heroH:'كن شريكنا.',heroEm:'وانمو معنا.',
  heroP:'برنامج شراكات مصمم للشركات والأفراد. انضم لشبكة SDB العالمية وساهم في بناء مستقبل الخدمات المالية الرقمية.',
  heroBtn:'قدّم طلب شراكة ←',
  progTitle:'برامج الشراكة',
  progs:[
    {ic:'👤',t:'برنامج الإحالة الفردي',d:'أحِل أصدقاءك وعائلتك واكسب €10 عن كل عميل جديد يفتح حساب ويفعّله. بدون حد أقصى.',bonus:'€10/إحالة',target:'أفراد'},
    {ic:'🏢',t:'شراكة الأعمال',d:'مناسب للشركات ومقدمي الخدمات. عمولة أعلى + لوحة تحكم خاصة + مدير شراكات مخصص.',bonus:'€25/إحالة',target:'شركات'},
    {ic:'📱',t:'تكامل API',d:'ادمج خدمات SDB Bank في منصتك. API مفتوح للدفع، التحويلات، والتحقق من الهوية.',bonus:'حسب الحجم',target:'مطورون'},
    {ic:'🏪',t:'نقاط بيع',d:'اقبل الدفع بتطبيق SDB في متجرك. بدون رسوم إعداد. دعم QR Code و NFC.',bonus:'0.3% تسوية',target:'تجار'},
  ],
  howTitle:'كيف يعمل؟',
  steps:[
    {n:'1',t:'سجّل',d:'قدّم طلب الشراكة وحدد البرنامج المناسب.'},
    {n:'2',t:'احصل على رابطك',d:'رابط إحالة فريد + مواد تسويقية جاهزة.'},
    {n:'3',t:'أحِل عملاء',d:'شارك رابطك — نتتبع كل إحالة تلقائياً.'},
    {n:'4',t:'اجمع أرباحك',d:'عمولتك تُضاف لحسابك مباشرة.'},
  ],
  ctaTitle:'ابدأ الشراكة',ctaSub:'سجّل الآن وابدأ الكسب فوراً.',ctaBtn:'قدّم طلب ←',ctaEmail:'partners@sdb-bank.com',
} : {
  title:'Partners — SDB Bank',tag:'Partners',
  heroH:'Be our partner.',heroEm:'Grow with us.',
  heroP:'Partnership programs designed for businesses and individuals. Earn commissions on every new client and join SDB\'s global network.',
  heroBtn:'Apply for partnership →',
  progTitle:'Partnership Programs',
  progs:[
    {ic:'👤',t:'Individual Referral',d:'Refer friends and family and earn €10 for every new client who opens and activates an account. No cap.',bonus:'€10/referral',target:'Individuals'},
    {ic:'🏢',t:'Business Partner',d:'Ideal for companies and service providers. Higher commission + dedicated dashboard + partner manager.',bonus:'€25/referral',target:'Businesses'},
    {ic:'📱',t:'API Integration',d:'Integrate SDB Bank services into your platform. Open API for payments, transfers, and identity verification.',bonus:'Volume-based',target:'Developers'},
    {ic:'🏪',t:'Point of Sale',d:'Accept SDB app payments in your store. No setup fees. QR Code and NFC support.',bonus:'0.3% settlement',target:'Merchants'},
  ],
  howTitle:'How it works',
  steps:[
    {n:'1',t:'Register',d:'Apply for partnership and choose your program.'},
    {n:'2',t:'Get your link',d:'Unique referral link + ready marketing materials.'},
    {n:'3',t:'Refer clients',d:'Share your link — we track every referral automatically.'},
    {n:'4',t:'Collect earnings',d:'Commission credited to your account directly.'},
  ],
  ctaTitle:'Start partnering',ctaSub:'Register now and start earning immediately.',ctaBtn:'Apply now →',ctaEmail:'partners@sdb-bank.com',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><a href="/preregister?type=business" class="hero-btn">{{ t.heroBtn }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.progTitle }}</h2><div class="g4"><div v-for="p in t.progs" :key="p.t" class="pc"><span class="pc-ic">{{ p.ic }}</span><h3 class="pc-t">{{ p.t }}</h3><p class="pc-d">{{ p.d }}</p><div class="pc-meta"><span class="pc-bonus">{{ p.bonus }}</span><span class="pc-target">{{ p.target }}</span></div></div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.howTitle }}</h2><div class="g4"><div v-for="s in t.steps" :key="s.n" class="st-c"><div class="st-n">{{ s.n }}</div><h4 class="st-t">{{ s.t }}</h4><p class="st-d">{{ s.d }}</p></div></div></div></section>
<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a :href="'mailto:'+t.ctaEmail" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F9F3}.sec-sky{background:linear-gradient(135deg,#163300,#1a3d00,#9FE870);color:#fff;padding:100px 0}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#163300,#1a3d00,#9FE870);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#9FE870}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto 28px;line-height:1.8}
.hero-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.hero-btn:hover{transform:translateY(-2px)}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.pc{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:18px;text-align:center;transition:all .3s}.pc:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(159,232,112,.06)}
.pc-ic{font-size:28px;display:block;margin-bottom:10px}.pc-t{font-size:15px;font-weight:800;color:#163300;margin-bottom:6px}.pc-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.7;margin-bottom:12px}
.pc-meta{display:flex;justify-content:space-between;gap:8px}
.pc-bonus{font-size:12px;font-weight:800;color:#9FE870;background:rgba(159,232,112,.06);padding:4px 10px;border-radius:6px}
.pc-target{font-size:12px;font-weight:600;color:rgba(10,10,10,.3);background:rgba(10,10,10,.03);padding:4px 10px;border-radius:6px}
.st-c{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:16px;text-align:center}
.st-n{font-size:40px;font-weight:900;color:rgba(159,232,112,.1);line-height:1;margin-bottom:8px}
.st-t{font-size:14px;font-weight:800;color:#163300;margin-bottom:4px}.st-d{font-size:12px;color:rgba(10,10,10,.4)}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.g4{grid-template-columns:repeat(2,1fr)}}
</style>
