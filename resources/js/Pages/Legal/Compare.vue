<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed, onMounted } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
let obs;
onMounted(()=>{obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.08});document.querySelectorAll('.an').forEach(el=>obs.observe(el))});

const t = computed(() => isAr.value ? {
  tag:'قارن وقرّر',title:'SDB مقابل البنوك.',fade:'الفرق واضح.',
  desc:'قارن SDB Bank مع أشهر البنوك الرقمية واكتشف لماذا SDB هو الخيار الأفضل للسوريين.',
  headers:['الميزة','SDB Bank','Wise','Revolut','N26'],
  rows:[
    ['فتح الحساب','مجاني — دقيقتين','مجاني — 5 دقائق','مجاني — 5 دقائق','مجاني — 10 دقائق'],
    ['بطاقة مجانية','✅ افتراضية فورية','✅ افتراضية','✅ افتراضية','✅ افتراضية'],
    ['بطاقة معدنية','✅ من 600 ل.س/شهر','❌ غير متوفر','✅ من €7.99/شهر','✅ من €9.90/شهر'],
    ['دعم الليرة السورية','✅ SYP مدعومة','❌ غير متوفر','❌ غير متوفر','❌ غير متوفر'],
    ['تحويل لسوريا','✅ فوري — 0.5%','⚠️ محدود','❌ غير متوفر','❌ غير متوفر'],
    ['رسوم التحويل','0.3% فقط','0.4% — 1.5%','0% — 1.5%','مجاني (محدود)'],
    ['سعر الصرف','سعر السوق الحقيقي','سعر السوق','سعر السوق (أيام العمل)','سعر السوق (محدود)'],
    ['عملات مدعومة','30+','40+','30+','أساسية فقط'],
    ['تطبيق عربي','✅ عربي + English','❌ English فقط','❌ English فقط','❌ English فقط'],
    ['دعم بالعربي','✅ 24/7','❌','❌','❌'],
    ['ترخيص أوروبي','✅ الدنمارك 🇩🇰','✅ بلجيكا','✅ ليتوانيا','✅ ألمانيا'],
    ['عملات رقمية','✅ BTC, ETH + 10','❌','✅ 80+','❌ (مع شركاء)'],
  ],
  verdict:'SDB Bank هو الخيار الوحيد المصمم خصيصاً للسوريين — بدعم عربي كامل، تحويلات لسوريا، ودعم الليرة السورية.',
  ctaTitle:'جاهز؟',ctaBtn:'سجّل مبكراً →',
} : {
  tag:'Compare & Decide',title:'SDB vs Banks.',fade:'The difference is clear.',
  desc:'Compare SDB Bank with the most popular digital banks and discover why SDB is the best choice for Syrians.',
  headers:['Feature','SDB Bank','Wise','Revolut','N26'],
  rows:[
    ['Account opening','Free — 2 minutes','Free — 5 minutes','Free — 5 minutes','Free — 10 minutes'],
    ['Free card','✅ Virtual instant','✅ Virtual','✅ Virtual','✅ Virtual'],
    ['Metal card','✅ From 600 SYP/mo','❌ Not available','✅ From €7.99/mo','✅ From €9.90/mo'],
    ['Syrian Lira support','✅ SYP supported','❌ Not available','❌ Not available','❌ Not available'],
    ['Transfer to Syria','✅ Instant — 0.5%','⚠️ Limited','❌ Not available','❌ Not available'],
    ['Transfer fees','0.3% only','0.4% — 1.5%','0% — 1.5%','Free (limited)'],
    ['Exchange rate','Real market rate','Market rate','Market rate (weekdays)','Market rate (limited)'],
    ['Supported currencies','30+','40+','30+','Basic only'],
    ['Arabic app','✅ Arabic + English','❌ English only','❌ English only','❌ English only'],
    ['Arabic support','✅ 24/7','❌','❌','❌'],
    ['EU license','✅ Denmark 🇩🇰','✅ Belgium','✅ Lithuania','✅ Germany'],
    ['Crypto','✅ BTC, ETH + 10','❌','✅ 80+','❌ (partners)'],
  ],
  verdict:'SDB Bank is the only option designed specifically for Syrians — with full Arabic support, transfers to Syria, and Syrian Lira support.',
  ctaTitle:'Ready?',ctaBtn:'Pre-register →',
});
</script>
<template>
<Head :title="isAr?'قارن — SDB Bank':'Compare — SDB Bank'"/>
<section class="hero"><div class="sw tc">
  <div class="hero-tag an">{{ t.tag }}</div>
  <h1 class="t2 an">{{ t.title }}<br><span class="t2-em">{{ t.fade }}</span></h1>
  <p class="t2-sub an tc" style="max-width:600px;margin:0 auto">{{ t.desc }}</p>
</div></section>

<section class="sec"><div class="sw">
  <div class="cmp-wrap an">
    <table class="cmp-table">
      <thead>
        <tr><th v-for="h in t.headers" :key="h" :class="{'cmp-sdb':h==='SDB Bank'}">{{ h }}</th></tr>
      </thead>
      <tbody>
        <tr v-for="(row,i) in t.rows" :key="i">
          <td v-for="(cell,j) in row" :key="j" :class="{'cmp-feat':j===0,'cmp-sdb-cell':j===1}">{{ cell }}</td>
        </tr>
      </tbody>
    </table>
  </div>
  <div class="verdict an">{{ t.verdict }}</div>
</div></section>

<section class="sec sec-cta"><div class="sw tc">
  <h2 class="t2 an">{{ t.ctaTitle }}</h2>
  <Link href="/preregister" class="cta-btn an">{{ t.ctaBtn }}</Link>
</div></section>
</template>
<style scoped>
.hero{padding:160px 0 80px;background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.7);text-transform:uppercase;margin-bottom:24px}
.t2{font-size:clamp(2rem,4vw,3.2rem);font-weight:900;line-height:1.1;margin-bottom:16px;color:#0C4A6E}.t2-em{color:#0EA5E9}
.hero .t2{color:#fff}.hero .t2-em{color:#E0F2FE}
.t2-sub{font-size:16px;color:rgba(10,10,10,.6);line-height:1.85}.hero .t2-sub{color:rgba(255,255,255,.7)}
.sec{padding:80px 0}.sec-cta{padding:100px 0;background:linear-gradient(135deg,#F0F9FF,#E0F2FE)}
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.cmp-wrap{overflow-x:auto;-webkit-overflow-scrolling:touch;border-radius:20px;border:1px solid rgba(14,165,233,.08);box-shadow:0 8px 32px rgba(0,0,0,.04)}
.cmp-table{width:100%;border-collapse:collapse;background:#fff;font-size:14px}
.cmp-table thead{background:linear-gradient(135deg,#0C4A6E,#0369A1)}
.cmp-table th{padding:16px 20px;color:#fff;font-weight:800;font-size:14px;text-align:center;white-space:nowrap}
.cmp-table th:first-child{text-align:start}
.cmp-sdb{background:rgba(14,165,233,.3)!important;color:#E0F2FE!important}
.cmp-table td{padding:14px 20px;border-bottom:1px solid rgba(14,165,233,.04);text-align:center;color:rgba(10,10,10,.7)}
.cmp-feat{font-weight:700;color:#0C4A6E;text-align:start;white-space:nowrap}
.cmp-sdb-cell{background:rgba(14,165,233,.03);color:#0284C7;font-weight:700}
.cmp-table tbody tr:hover{background:rgba(14,165,233,.02)}
.verdict{margin-top:32px;padding:24px;background:linear-gradient(135deg,rgba(14,165,233,.05),rgba(14,165,233,.02));border-radius:16px;font-size:15px;color:#0C4A6E;font-weight:600;line-height:1.8;text-align:center;border:1px solid rgba(14,165,233,.08)}
.cta-btn{display:inline-block;padding:18px 48px;background:linear-gradient(135deg,#0284C7,#0EA5E9);color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s;margin-top:16px}.cta-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(14,165,233,.2)}
.an{opacity:0;transform:translateY(24px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
@media(max-width:768px){
  .hero{padding:130px 0 50px}
  .t2{font-size:clamp(1.6rem,5vw,2.4rem)}
  .sec{padding:50px 0}.sec-cta{padding:60px 0}
  .sw{padding:0 16px}
  .cmp-table{font-size:12px}
  .cmp-table th,.cmp-table td{padding:10px 12px}
  .cta-btn{width:100%;text-align:center;display:block}
}
</style>
