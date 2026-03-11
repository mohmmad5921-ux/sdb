<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed, onMounted } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
let obs;
onMounted(()=>{obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.08});document.querySelectorAll('.an').forEach(el=>obs.observe(el))});

const t = computed(() => isAr.value ? {
  tag:'المدونة',title:'آخر الأخبار.',fade:'ابقَ على اطّلاع.',
  desc:'اقرأ عن آخر التطورات في عالم SDB Bank والخدمات المالية الرقمية.',
  soon:'قريباً — مقالات ونصائح مالية',
  soonDesc:'نعمل على إعداد محتوى مميز يساعدك في إدارة أموالك واتخاذ قرارات مالية أفضل.',
  topics:'المواضيع القادمة',
  items:[
    {ic:'💳',t:'دليل البطاقات',d:'كل ما تحتاج معرفته عن بطاقات ماستركارد من SDB Bank.'},
    {ic:'🌍',t:'التحويلات الدولية',d:'نصائح لتوفير المال على التحويلات المالية.'},
    {ic:'🔒',t:'أمان الحسابات',d:'كيف نحمي بياناتك وأموالك بأعلى المعايير.'},
    {ic:'📱',t:'دليل التطبيق',d:'استفد من جميع ميزات تطبيق SDB Bank.'},
    {ic:'💡',t:'نصائح مالية',d:'إدارة الميزانية والادخار والاستثمار.'},
    {ic:'📰',t:'أخبار SDB',d:'آخر الإطلاقات والتحديثات والشراكات.'},
  ],
  ctaTitle:'لا تفوّت أي جديد',ctaSub:'سجّل الآن لتصلك الأخبار فور نشرها.',ctaBtn:'سجّل مبكراً →',
} : {
  tag:'Blog',title:'Latest news.',fade:'Stay updated.',
  desc:'Read about the latest developments at SDB Bank and digital financial services.',
  soon:'Coming Soon — Articles & Financial Tips',
  soonDesc:'We are preparing premium content to help you manage your money and make better financial decisions.',
  topics:'Upcoming Topics',
  items:[
    {ic:'💳',t:'Card Guide',d:'Everything you need to know about SDB Bank Mastercard cards.'},
    {ic:'🌍',t:'International Transfers',d:'Tips to save money on international money transfers.'},
    {ic:'🔒',t:'Account Security',d:'How we protect your data and money with the highest standards.'},
    {ic:'📱',t:'App Guide',d:'Take advantage of all SDB Bank app features.'},
    {ic:'💡',t:'Financial Tips',d:'Budgeting, saving, and investment advice.'},
    {ic:'📰',t:'SDB News',d:'Latest launches, updates, and partnerships.'},
  ],
  ctaTitle:"Don't miss any updates",ctaSub:'Register now to receive news as soon as it is published.',ctaBtn:'Pre-register →',
});
</script>
<template>
<Head :title="isAr?'المدونة — SDB Bank':'Blog — SDB Bank'"/>
<section class="hero"><div class="sw">
  <div class="hero-tag an">{{ t.tag }}</div>
  <h1 class="t2 an">{{ t.title }}<br><span class="t2-em">{{ t.fade }}</span></h1>
  <p class="t2-sub an" style="max-width:600px">{{ t.desc }}</p>
</div></section>
<section class="sec"><div class="sw tc">
  <div class="soon-badge an">{{ t.soon }}</div>
  <p class="t2-sub an tc" style="margin:0 auto 48px;max-width:500px">{{ t.soonDesc }}</p>
  <h2 class="t2 tc an">{{ t.topics }}</h2>
  <div class="topics-grid an">
    <div v-for="item in t.items" :key="item.t" class="topic-c">
      <span class="topic-ic">{{ item.ic }}</span>
      <h4 class="topic-t">{{ item.t }}</h4>
      <p class="topic-d">{{ item.d }}</p>
    </div>
  </div>
</div></section>
<section class="sec sec-cta"><div class="sw tc">
  <h2 class="t2 an">{{ t.ctaTitle }}</h2>
  <p class="t2-sub an tc" style="margin:0 auto 32px">{{ t.ctaSub }}</p>
  <Link href="/preregister" class="cta-btn an">{{ t.ctaBtn }}</Link>
</div></section>
</template>
<style scoped>
.hero{padding:160px 0 80px;background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.7);text-transform:uppercase;margin-bottom:24px}
.t2{font-size:clamp(2rem,4vw,3.2rem);font-weight:900;line-height:1.1;margin-bottom:16px;color:#163300}.t2-em{color:#9FE870}
.hero .t2{color:#fff}.hero .t2-em{color:#E8F5E0}
.t2-sub{font-size:16px;color:rgba(10,10,10,.6);line-height:1.85;max-width:520px}.hero .t2-sub{color:rgba(255,255,255,.7)}
.sec{padding:80px 0}.sec-cta{padding:100px 0;background:linear-gradient(135deg,#F5F9F3,#E8F5E0)}
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.soon-badge{display:inline-block;padding:12px 32px;background:linear-gradient(135deg,#9FE870,#2D6A00);color:#fff;font-size:14px;font-weight:800;border-radius:50px;margin-bottom:24px}
.topics-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-top:24px}
.topic-c{padding:28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px;text-align:center;transition:all .3s}.topic-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.topic-ic{font-size:32px;display:block;margin-bottom:12px}
.topic-t{font-size:15px;font-weight:800;color:#163300;margin-bottom:6px}
.topic-d{font-size:13px;color:rgba(10,10,10,.5);line-height:1.7}
.cta-btn{display:inline-block;padding:18px 48px;background:linear-gradient(135deg,#2D6A00,#9FE870);color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(159,232,112,.2)}
.an{opacity:0;transform:translateY(24px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
@media(max-width:768px){
  .hero{padding:130px 0 50px}
  .t2{font-size:clamp(1.6rem,5vw,2.4rem)}
  .sec{padding:50px 0}.sec-cta{padding:60px 0}
  .sw{padding:0 16px}
  .topics-grid{grid-template-columns:1fr;gap:10px}
  .topic-c{padding:20px 16px}
  .cta-btn{width:100%;text-align:center;padding:16px 24px;display:block}
}
</style>
