<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'وظائف — SDB Bank',tag:'وظائف',
  heroH:'انضم لفريق',heroEm:'SDB Bank.',
  heroP:'نبني أول بنك إلكتروني سوري. نبحث عن أشخاص موهوبين ومتحمسين يؤمنون بأن التكنولوجيا تغيّر حياة الناس.',
  heroBtn:'شوف الوظائف المتاحة ↓',
  whyTitle:'لماذا SDB؟',
  whys:[
    {ic:'🚀',t:'مهمة حقيقية',d:'نحن لا نبني مجرد بنك — نبني مستقبل سوريا المالي الرقمي. كل يوم عمل يؤثر بحياة ملايين.'},
    {ic:'🌍',t:'فريق عالمي',d:'فريقنا موزّع على الدنمارك، ألمانيا، تركيا، وسوريا. ثقافة عمل عن بعد بالكامل.'},
    {ic:'📈',t:'نمو مهني',d:'شركة ناشئة بتنمو بسرعة — فرصتك للتأثير والنمو معنا من البداية.'},
    {ic:'💰',t:'رواتب منافسة',d:'رواتب بالمعايير الأوروبية. أسهم شركة. مكافآت أداء.'},
    {ic:'🏖️',t:'مرونة كاملة',d:'عمل عن بعد 100%. ساعات مرنة. 30 يوم إجازة سنوية.'},
    {ic:'🎓',t:'تعلم مستمر',d:'ميزانية تدريب سنوية. مؤتمرات ودورات مدفوعة.'},
  ],
  depsTitle:'الأقسام',
  deps:[
    {n:'الهندسة',roles:['Full-Stack Developer (Vue.js/Laravel)','Flutter Mobile Developer','DevOps / Cloud Engineer','Backend Developer (Node.js)']},
    {n:'المنتج',roles:['Product Manager','UX/UI Designer','Product Analyst']},
    {n:'الامتثال والقانون',roles:['Compliance Officer','AML Analyst','Legal Counsel']},
    {n:'العمليات',roles:['Customer Support Lead','Operations Manager','QA Engineer']},
    {n:'التسويق',roles:['Growth Manager','Content Creator (AR/EN)','Social Media Manager']},
    {n:'المالية',roles:['Financial Controller','Treasury Analyst']},
  ],
  processTitle:'مسار التوظيف',
  process:[
    {n:'1',t:'تقديم طلب',d:'أرسل سيرتك الذاتية ورسالة تحفيزية.'},
    {n:'2',t:'مراجعة فنية',d:'مقابلة تقنية (1 ساعة) أو مهمة عملية.'},
    {n:'3',t:'مقابلة ثقافية',d:'نتعرف عليك ونشاركك رؤيتنا.'},
    {n:'4',t:'عرض العمل! 🎉',d:'عرض تنافسي + ترحيب بالفريق.'},
  ],
  ctaTitle:'لا ترى وظيفة مناسبة؟',ctaSub:'أرسل لنا سيرتك الذاتية وسنتواصل معك عند توفر فرصة.',ctaEmail:'careers@sdb-bank.com',
} : {
  title:'Careers — SDB Bank',tag:'Careers',
  heroH:'Join the',heroEm:'SDB Bank team.',
  heroP:'We\'re building Syria\'s first digital bank. Looking for talented, passionate people who believe technology changes lives.',
  heroBtn:'View open positions ↓',
  whyTitle:'Why SDB?',
  whys:[
    {ic:'🚀',t:'Real Mission',d:'We\'re not just building a bank — we\'re building Syria\'s digital financial future. Every work day impacts millions.'},
    {ic:'🌍',t:'Global Team',d:'Our team spans Denmark, Germany, Turkey, and Syria. Fully remote culture.'},
    {ic:'📈',t:'Career Growth',d:'Fast-growing startup — your chance to impact and grow with us from the start.'},
    {ic:'💰',t:'Competitive Pay',d:'European-standard salaries. Company equity. Performance bonuses.'},
    {ic:'🏖️',t:'Full Flexibility',d:'100% remote work. Flexible hours. 30 days annual leave.'},
    {ic:'🎓',t:'Continuous Learning',d:'Annual training budget. Paid conferences and courses.'},
  ],
  depsTitle:'Departments',
  deps:[
    {n:'Engineering',roles:['Full-Stack Developer (Vue.js/Laravel)','Flutter Mobile Developer','DevOps / Cloud Engineer','Backend Developer (Node.js)']},
    {n:'Product',roles:['Product Manager','UX/UI Designer','Product Analyst']},
    {n:'Compliance & Legal',roles:['Compliance Officer','AML Analyst','Legal Counsel']},
    {n:'Operations',roles:['Customer Support Lead','Operations Manager','QA Engineer']},
    {n:'Marketing',roles:['Growth Manager','Content Creator (AR/EN)','Social Media Manager']},
    {n:'Finance',roles:['Financial Controller','Treasury Analyst']},
  ],
  processTitle:'Hiring Process',
  process:[
    {n:'1',t:'Apply',d:'Send your CV and cover letter.'},
    {n:'2',t:'Technical Review',d:'Technical interview (1 hour) or practical task.'},
    {n:'3',t:'Culture Fit',d:'We get to know you and share our vision.'},
    {n:'4',t:'Offer! 🎉',d:'Competitive offer + team welcome.'},
  ],
  ctaTitle:'Don\'t see a fit?',ctaSub:'Send us your CV and we\'ll reach out when a position opens.',ctaEmail:'careers@sdb-bank.com',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.whyTitle }}</h2><div class="g3"><div v-for="w in t.whys" :key="w.t" class="fc"><span class="fc-ic">{{ w.ic }}</span><h3 class="fc-t">{{ w.t }}</h3><p class="fc-d">{{ w.d }}</p></div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.depsTitle }}</h2><div class="g3"><div v-for="d in t.deps" :key="d.n" class="dep-c"><h3 class="dep-n">{{ d.n }}</h3><div class="dep-roles"><span v-for="r in d.roles" :key="r" class="dep-role">{{ r }}</span></div></div></div></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.processTitle }}</h2><div class="g4"><div v-for="p in t.process" :key="p.n" class="pr-c"><div class="pr-n">{{ p.n }}</div><h4 class="pr-t">{{ p.t }}</h4><p class="pr-d">{{ p.d }}</p></div></div></div></section>
<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a :href="'mailto:'+t.ctaEmail" class="cta-btn">{{ t.ctaEmail }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F9F3}.sec-sky{background:linear-gradient(135deg,#163300,#1a3d00,#9FE870);color:#fff;padding:100px 0}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#163300,#1a3d00,#9FE870);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#9FE870}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto;line-height:1.8}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.fc{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:18px;text-align:center;transition:all .3s}.fc:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(159,232,112,.06)}
.fc-ic{font-size:28px;display:block;margin-bottom:10px}.fc-t{font-size:15px;font-weight:800;color:#163300;margin-bottom:6px}.fc-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.dep-c{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:18px}
.dep-n{font-size:16px;font-weight:800;color:#9FE870;margin-bottom:14px;padding-bottom:10px;border-bottom:2px solid rgba(159,232,112,.08)}
.dep-roles{display:flex;flex-direction:column;gap:8px}.dep-role{font-size:13px;color:#163300;font-weight:600;padding:8px 12px;background:rgba(159,232,112,.04);border-radius:8px}
.pr-c{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:16px;text-align:center}
.pr-n{font-size:40px;font-weight:900;color:rgba(159,232,112,.1);line-height:1;margin-bottom:8px}
.pr-t{font-size:14px;font-weight:800;color:#163300;margin-bottom:4px}.pr-d{font-size:12px;color:rgba(10,10,10,.4)}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.g3{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}}
</style>
