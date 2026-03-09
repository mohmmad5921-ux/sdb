<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed, onMounted } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
let obs;
onMounted(()=>{obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.08});document.querySelectorAll('.an').forEach(el=>obs.observe(el))});
const t = computed(() => isAr.value ? {
  tag:'قصتنا',title:'نحن SDB Bank.',fade:'أول بنك سوري رقمي.',
  story:'ولدت فكرة SDB Bank من معاناة حقيقية: ملايين السوريين حول العالم يعانون من صعوبة التحويلات المالية والوصول للخدمات البنكية. قررنا أن نغيّر هذا الواقع بتكنولوجيا أوروبية وروح سورية.',
  mission:'مهمتنا',missionText:'جعل الخدمات المالية متاحة لكل سوري — داخل سوريا أو خارجها — بدون حدود جغرافية أو عوائق بيروقراطية.',
  vision:'رؤيتنا',visionText:'أن نكون البنك الرائد للسوريين حول العالم. بنك بلا فروع، بلا ورق، بلا طوابير — مالك كله بهاتفك.',
  values:'قيمنا',
  vals:[
    {ic:'🔒',t:'الأمان أولاً',d:'بياناتك وأموالك محمية بأعلى معايير التشفير الأوروبية.'},
    {ic:'🌍',t:'بلا حدود',d:'خدماتنا متاحة في 150+ دولة. سوري أينما كنت.'},
    {ic:'💡',t:'الابتكار',d:'نستخدم أحدث التقنيات: ذكاء اصطناعي، API مفتوح، بنية سحابية.'},
    {ic:'🤝',t:'الشفافية',d:'لا رسوم مخفية. أسعار صرف حقيقية. كل شيء واضح.'},
    {ic:'❤️',t:'للمجتمع',d:'مصممون لخدمة المجتمع السوري وتمكينه مالياً.'},
    {ic:'⚡',t:'السرعة',d:'تحويلات فورية. فتح حساب بدقائق. لا انتظار.'},
  ],
  timeline:'مسيرتنا',
  events:[
    {y:'2024',t:'البداية',d:'ولدت الفكرة في كوبنهاغن — بنك رقمي مصمم للسوريين.'},
    {y:'2025 Q1',t:'التأسيس',d:'تسجيل SDB Bank ApS في الدنمارك والبدء بتطوير المنصة.'},
    {y:'2025 Q3',t:'الترخيص',d:'الحصول على التراخيص المالية الأوروبية اللازمة.'},
    {y:'2026 Q1',t:'الإطلاق التجريبي',d:'فتح التسجيل المسبق واختبار المنصة.'},
    {y:'2026 Q2',t:'الإطلاق الرسمي',d:'إطلاق الخدمة الكاملة: حسابات، بطاقات، تحويلات.'},
    {y:'2027',t:'التوسع',d:'خدمات إضافية: قروض، تأمين، استثمار. توسع إقليمي.'},
  ],
  teamTitle:'فريقنا',teamDesc:'فريق متنوع من خبراء التكنولوجيا والمالية — سوريون ودنماركيون يعملون معاً.',
  team:[
    {n:'أحمد الحسن',r:'المؤسس والرئيس التنفيذي',d:'خبرة 15 سنة في القطاع المالي الأوروبي.'},
    {n:'طارق النجار',r:'رئيس التكنولوجيا',d:'مهندس برمجيات سابق في Revolut و N26.'},
    {n:'ليلى خانكان',r:'رئيسة العمليات',d:'خبرة في إدارة العمليات المصرفية في Danske Bank.'},
    {n:'مارك ينسن',r:'رئيس الامتثال',d:'خبير الامتثال المالي الأوروبي — GDPR و PSD2.'},
  ],
  numbers:[{v:'50K+',l:'مستخدم مسجّل'},{v:'150+',l:'دولة مدعومة'},{v:'30+',l:'عملة'},{v:'99.99%',l:'وقت تشغيل'}],
  ctaTitle:'انضم لعائلة SDB',ctaSub:'افتح حسابك المجاني بدقيقتين.',ctaBtn:'افتح حسابك ←',
} : {
  tag:'Our Story',title:'We are SDB Bank.',fade:'The first Syrian digital bank.',
  story:'SDB Bank was born from a real struggle: millions of Syrians worldwide face difficulties with money transfers and banking access. We decided to change this reality with European technology and a Syrian soul.',
  mission:'Our Mission',missionText:'Making financial services accessible to every Syrian — inside or outside Syria — without geographic borders or bureaucratic barriers.',
  vision:'Our Vision',visionText:'To be the leading bank for Syrians worldwide. A bank without branches, without paper, without queues — your money all in your phone.',
  values:'Our Values',
  vals:[
    {ic:'🔒',t:'Security First',d:'Your data and money protected by the highest European encryption standards.'},
    {ic:'🌍',t:'Borderless',d:'Our services available in 150+ countries. Syrian wherever you are.'},
    {ic:'💡',t:'Innovation',d:'Using the latest tech: AI, open API, cloud infrastructure.'},
    {ic:'🤝',t:'Transparency',d:'No hidden fees. Real exchange rates. Everything clear.'},
    {ic:'❤️',t:'Community',d:'Designed to serve and financially empower the Syrian community.'},
    {ic:'⚡',t:'Speed',d:'Instant transfers. Account opening in minutes. No waiting.'},
  ],
  timeline:'Our Journey',
  events:[
    {y:'2024',t:'The Beginning',d:'The idea was born in Copenhagen — a digital bank designed for Syrians.'},
    {y:'2025 Q1',t:'Foundation',d:'SDB Bank ApS registered in Denmark, platform development begins.'},
    {y:'2025 Q3',t:'Licensing',d:'Obtaining the necessary European financial licenses.'},
    {y:'2026 Q1',t:'Beta Launch',d:'Pre-registration opens and platform beta testing.'},
    {y:'2026 Q2',t:'Official Launch',d:'Full service launch: accounts, cards, transfers.'},
    {y:'2027',t:'Expansion',d:'Additional services: loans, insurance, investments. Regional expansion.'},
  ],
  teamTitle:'Our Team',teamDesc:'A diverse team of tech and finance experts — Syrians and Danes working together.',
  team:[
    {n:'Ahmed Al-Hassan',r:'Founder & CEO',d:'15 years experience in European financial sector.'},
    {n:'Tarek Al-Najjar',r:'CTO',d:'Former software engineer at Revolut and N26.'},
    {n:'Layla Khankan',r:'COO',d:'Banking operations management experience at Danske Bank.'},
    {n:'Marc Jensen',r:'Head of Compliance',d:'European financial compliance expert — GDPR & PSD2.'},
  ],
  numbers:[{v:'50K+',l:'Registered users'},{v:'150+',l:'Countries'},{v:'30+',l:'Currencies'},{v:'99.99%',l:'Uptime'}],
  ctaTitle:'Join the SDB family',ctaSub:'Open your free account in 2 minutes.',ctaBtn:'Open account →',
});
</script>
<template>
<Head :title="isAr?'عنّا — SDB Bank':'About — SDB Bank'"/>
<section class="hero"><div class="sw">
  <div class="hero-tag an">{{ t.tag }}</div>
  <h1 class="t2 an">{{ t.title }}<br><span class="t2-em">{{ t.fade }}</span></h1>
  <p class="t2-sub an" style="max-width:600px">{{ t.story }}</p>
</div></section>
<section class="sec"><div class="sw mv-grid">
  <div class="mv-card an"><div class="mv-ic">🎯</div><h3 class="mv-t">{{ t.mission }}</h3><p class="mv-d">{{ t.missionText }}</p></div>
  <div class="mv-card an" style="transition-delay:100ms"><div class="mv-ic">🔭</div><h3 class="mv-t">{{ t.vision }}</h3><p class="mv-d">{{ t.visionText }}</p></div>
</div></section>
<section class="sec sec-alt"><div class="sw">
  <h2 class="t2 tc an">{{ t.values }}</h2>
  <div class="vals-grid an"><div v-for="v in t.vals" :key="v.t" class="val-c"><span class="val-ic">{{ v.ic }}</span><h4 class="val-t">{{ v.t }}</h4><p class="val-d">{{ v.d }}</p></div></div>
</div></section>
<section class="sec"><div class="sw">
  <h2 class="t2 tc an">{{ t.timeline }}</h2>
  <div class="tl an"><div v-for="(e,i) in t.events" :key="i" class="tl-item"><div class="tl-dot"></div><div class="tl-y">{{ e.y }}</div><h4 class="tl-t">{{ e.t }}</h4><p class="tl-d">{{ e.d }}</p></div></div>
</div></section>
<section class="sec sec-alt"><div class="sw">
  <h2 class="t2 tc an">{{ t.teamTitle }}</h2>
  <p class="t2-sub tc an" style="margin:0 auto 40px">{{ t.teamDesc }}</p>
  <div class="team-grid an"><div v-for="m in t.team" :key="m.n" class="team-c"><div class="team-av">{{ m.n.charAt(0) }}</div><h4 class="team-n">{{ m.n }}</h4><div class="team-r">{{ m.r }}</div><p class="team-d">{{ m.d }}</p></div></div>
</div></section>
<section class="sec"><div class="sw">
  <div class="nums an"><div v-for="n in t.numbers" :key="n.v" class="num-i"><div class="num-v">{{ n.v }}</div><div class="num-l">{{ n.l }}</div></div></div>
</div></section>
<section class="sec sec-cta"><div class="sw tc">
  <h2 class="t2 an">{{ t.ctaTitle }}</h2>
  <p class="t2-sub an tc" style="margin:0 auto 32px">{{ t.ctaSub }}</p>
  <a href="/preregister" class="cta-btn an">{{ t.ctaBtn }}</a>
</div></section>
</template>
<style scoped>
.hero{padding:160px 0 80px;background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.7);text-transform:uppercase;margin-bottom:24px}
.t2{font-size:clamp(2rem,4vw,3.2rem);font-weight:900;line-height:1.1;margin-bottom:16px;color:#0C4A6E}.t2-em{color:#0EA5E9}
.hero .t2{color:#fff}.hero .t2-em{color:#E0F2FE}
.t2-sub{font-size:16px;color:rgba(10,10,10,.6);line-height:1.85;max-width:520px}.hero .t2-sub{color:rgba(255,255,255,.7)}
.sec{padding:80px 0}.sec-alt{background:#fafafa}.sec-cta{padding:100px 0;background:linear-gradient(135deg,#F0F9FF,#E0F2FE)}
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.mv-grid{display:grid;grid-template-columns:1fr 1fr;gap:24px}
.mv-card{padding:40px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:20px;box-shadow:0 4px 16px rgba(0,0,0,.03)}
.mv-ic{font-size:36px;margin-bottom:16px}.mv-t{font-size:20px;font-weight:900;color:#0C4A6E;margin-bottom:10px}.mv-d{font-size:15px;color:rgba(10,10,10,.6);line-height:1.8}
.vals-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.val-c{padding:28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px;text-align:center;transition:all .3s}.val-c:hover{transform:translateY(-4px);box-shadow:0 8px 24px rgba(0,0,0,.05)}
.val-ic{font-size:28px;display:block;margin-bottom:10px}.val-t{font-size:15px;font-weight:800;color:#0C4A6E;margin-bottom:6px}.val-d{font-size:13px;color:rgba(10,10,10,.55);line-height:1.7}
.tl{display:flex;flex-direction:column;gap:0;max-width:600px;margin:0 auto;position:relative;padding-inline-start:32px}
.tl::before{content:'';position:absolute;top:0;bottom:0;width:2px;background:linear-gradient(180deg,#0EA5E9,rgba(14,165,233,.1));inset-inline-start:8px}
.tl-item{position:relative;padding:20px 0}.tl-dot{width:16px;height:16px;background:#0EA5E9;border:3px solid #fff;border-radius:50%;position:absolute;inset-inline-start:-28px;top:24px;box-shadow:0 0 0 3px rgba(14,165,233,.2)}
.tl-y{font-size:12px;font-weight:800;color:#0EA5E9;margin-bottom:4px}.tl-t{font-size:16px;font-weight:800;color:#0C4A6E;margin-bottom:4px}.tl-d{font-size:14px;color:rgba(10,10,10,.55);line-height:1.7}
.team-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.team-c{padding:28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px;text-align:center;transition:all .3s}.team-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.team-av{width:56px;height:56px;background:linear-gradient(135deg,#0EA5E9,#0369A1);color:#fff;font-size:22px;font-weight:900;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 12px}
.team-n{font-size:15px;font-weight:800;color:#0C4A6E;margin-bottom:4px}.team-r{font-size:12px;font-weight:700;color:#0EA5E9;margin-bottom:8px}.team-d{font-size:12px;color:rgba(10,10,10,.5);line-height:1.6}
.nums{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:rgba(10,10,10,.06);border:1px solid rgba(10,10,10,.06);border-radius:20px;overflow:hidden}
.num-i{padding:40px 20px;background:#fff;text-align:center}.num-v{font-size:clamp(2rem,4vw,3rem);font-weight:900;color:#0EA5E9;margin-bottom:4px}.num-l{font-size:13px;color:rgba(10,10,10,.5);font-weight:600}
.cta-btn{display:inline-block;padding:18px 48px;background:linear-gradient(135deg,#0284C7,#0EA5E9);color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(14,165,233,.2)}
.an{opacity:0;transform:translateY(24px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
@media(max-width:768px){
  .hero{padding:130px 0 50px}
  .t2{font-size:clamp(1.6rem,5vw,2.4rem)}
  .t2-sub{font-size:14px}
  .sec{padding:50px 0}.sec-cta{padding:60px 0}
  .sw{padding:0 16px}
  .mv-grid{grid-template-columns:1fr}
  .mv-card{padding:28px 20px}
  .vals-grid{grid-template-columns:1fr;gap:10px}
  .val-c{padding:20px 16px}
  .team-grid{grid-template-columns:repeat(2,1fr);gap:10px}
  .team-c{padding:20px 16px}
  .team-av{width:44px;height:44px;font-size:18px}
  .nums{grid-template-columns:repeat(2,1fr)}
  .num-i{padding:28px 12px}
  .tl{padding-inline-start:24px}
  .cta-btn{width:100%;text-align:center;padding:16px 24px;display:block}
}
</style>
