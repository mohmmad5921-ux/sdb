<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'المدونة — SDB Bank',tag:'المدونة',
  heroH:'أخبار ومقالات.',heroEm:'من SDB Bank.',
  heroP:'آخر التحديثات، مقالات مالية تعليمية، ونصائح لإدارة أموالك بذكاء.',
  posts:[
    {cat:'أخبار',date:'مارس 2026',t:'SDB Bank يبدأ التسجيل المسبق',d:'أول بنك إلكتروني سوري يفتح باب التسجيل المسبق. تعرّف على كيفية الانضمام وما الذي ينتظرك.',read:'3 دقائق'},
    {cat:'تعليمي',date:'مارس 2026',t:'كيف تختار حساب بنكي مناسب في 2026',d:'دليل شامل لاختيار الحساب البنكي المناسب — رسوم، مميزات، أمان. مقارنة بين البنوك الرقمية والتقليدية.',read:'5 دقائق'},
    {cat:'أمان',date:'فبراير 2026',t:'5 نصائح لحماية حسابك البنكي من الاحتيال',d:'كيف تحمي نفسك من عمليات الاحتيال الإلكتروني؟ نصائح عملية وسهلة التطبيق.',read:'4 دقائق'},
    {cat:'تحديث',date:'فبراير 2026',t:'أسعار صرف حية — ميزة جديدة',d:'أطلقنا حاسبة أسعار الصرف الحية. حوّل بين 30+ عملة وشاهد الأسعار لحظياً.',read:'2 دقائق'},
    {cat:'تعليمي',date:'يناير 2026',t:'دليل التوفير الذكي — كيف توفّر بدون ما تحس',d:'تقنيات مثبتة علمياً للتوفير: Round-ups، القاعدة 50/30/20، وأهداف الادخار.',read:'6 دقائق'},
    {cat:'أخبار',date:'يناير 2026',t:'SDB Bank والتحول الرقمي في سوريا',d:'كيف يساهم SDB Bank في إعادة بناء البنية التحتية المالية السورية بعد الحرب.',read:'7 دقائق'},
    {cat:'أمان',date:'ديسمبر 2025',t:'ما هو الـ CVV الديناميكي وكيف يحميك؟',d:'تعرّف على تقنية CVV الديناميكي التي تغيّر رمز الأمان كل ساعة.',read:'3 دقائق'},
    {cat:'تعليمي',date:'ديسمبر 2025',t:'Apple Pay و Google Pay — كيف تضيف بطاقة SDB',d:'دليل خطوة بخطوة لإضافة بطاقة SDB Bank لمحفظتك الرقمية.',read:'4 دقائق'},
    {cat:'تحديث',date:'نوفمبر 2025',t:'إطلاق برنامج الشراكات',d:'كن شريك SDB Bank — برنامج إحالة بعمولات جذابة لكل عميل جديد.',read:'3 دقائق'},
  ],
  catTitle:'المواضيع',
  cats:['الكل','أخبار','تعليمي','أمان','تحديث'],
  ctaTitle:'اشترك بالنشرة',ctaSub:'مقالات، تحديثات، ونصائح مالية أسبوعياً.',ctaBtn:'سجّل اهتمامك ←',
} : {
  title:'Blog — SDB Bank',tag:'Blog',
  heroH:'News & Articles.',heroEm:'From SDB Bank.',
  heroP:'Latest updates, educational financial articles, and tips to manage your money smartly.',
  posts:[
    {cat:'News',date:'March 2026',t:'SDB Bank Opens Pre-registration',d:'Syria\'s first digital bank opens pre-registration. Learn how to join and what awaits you.',read:'3 min'},
    {cat:'Education',date:'March 2026',t:'How to Choose the Right Bank Account in 2026',d:'Comprehensive guide to choosing the right bank — fees, features, security. Digital vs traditional comparison.',read:'5 min'},
    {cat:'Security',date:'February 2026',t:'5 Tips to Protect Your Bank Account from Fraud',d:'How to protect yourself from online fraud? Practical and easy-to-apply tips.',read:'4 min'},
    {cat:'Update',date:'February 2026',t:'Live Exchange Rates — New Feature',d:'We launched the live currency calculator. Convert between 30+ currencies with real-time rates.',read:'2 min'},
    {cat:'Education',date:'January 2026',t:'Smart Saving Guide — Save Without Noticing',d:'Scientifically proven techniques: Round-ups, 50/30/20 rule, and savings goals.',read:'6 min'},
    {cat:'News',date:'January 2026',t:'SDB Bank and Syria\'s Digital Transformation',d:'How SDB Bank contributes to rebuilding Syria\'s financial infrastructure post-war.',read:'7 min'},
    {cat:'Security',date:'December 2025',t:'What is Dynamic CVV and How Does it Protect You?',d:'Learn about dynamic CVV technology that changes security code every hour.',read:'3 min'},
    {cat:'Education',date:'December 2025',t:'Apple Pay & Google Pay — Add Your SDB Card',d:'Step-by-step guide to adding your SDB Bank card to your digital wallet.',read:'4 min'},
    {cat:'Update',date:'November 2025',t:'Partnership Program Launch',d:'Become an SDB Bank partner — referral program with attractive commissions.',read:'3 min'},
  ],
  catTitle:'Topics',
  cats:['All','News','Education','Security','Update'],
  ctaTitle:'Subscribe to newsletter',ctaSub:'Articles, updates, and weekly financial tips.',ctaBtn:'Register interest →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>
<section class="sec"><div class="sw"><div class="cats"><span v-for="c in t.cats" :key="c" class="cat-pill">{{ c }}</span></div><div class="posts"><div v-for="p in t.posts" :key="p.t" class="post-c"><div class="post-meta"><span class="post-cat">{{ p.cat }}</span><span class="post-date">{{ p.date }}</span></div><h3 class="post-t">{{ p.t }}</h3><p class="post-d">{{ p.d }}</p><span class="post-read">{{ p.read }}</span></div></div></div></section>
<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-sky{background:linear-gradient(135deg,#0C4A6E,#0369A1,#0EA5E9);color:#fff;padding:100px 0}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 60px;background:linear-gradient(135deg,#0C4A6E,#0369A1,#0EA5E9);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#7DD3FC}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto;line-height:1.8}
.cats{display:flex;gap:8px;margin-bottom:32px;flex-wrap:wrap;justify-content:center}
.cat-pill{font-size:13px;font-weight:700;color:#0C4A6E;background:#F0F9FF;padding:8px 18px;border-radius:20px;cursor:pointer;border:1px solid rgba(14,165,233,.1);transition:all .2s}.cat-pill:first-child{background:#0EA5E9;color:#fff}
.posts{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.post-c{padding:28px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:18px;transition:all .3s;cursor:pointer}.post-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(14,165,233,.06)}
.post-meta{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px}
.post-cat{font-size:11px;font-weight:700;color:#0EA5E9;background:rgba(14,165,233,.06);padding:3px 10px;border-radius:6px}
.post-date{font-size:11px;color:rgba(10,10,10,.25)}
.post-t{font-size:15px;font-weight:800;color:#0C4A6E;margin-bottom:8px;line-height:1.4}.post-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.7;margin-bottom:12px}
.post-read{font-size:11px;font-weight:700;color:rgba(14,165,233,.6)}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#0C4A6E;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.posts{grid-template-columns:1fr}}
</style>
