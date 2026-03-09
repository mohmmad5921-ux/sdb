<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed, onMounted } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
let obs;
onMounted(()=>{obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.08});document.querySelectorAll('.an').forEach(el=>obs.observe(el))});
const t = computed(() => isAr.value ? {
  tag:'المدونة',title:'أحدث المقالات.',fade:'أخبار ونصائح مالية.',
  posts:[
    {tag:'أخبار',date:'8 مارس 2026',title:'SDB Bank يحصل على ترخيص مالي أوروبي',desc:'حصل SDB Bank رسمياً على التراخيص المالية اللازمة من السلطات الدنماركية، مما يمهد الطريق لإطلاق خدماته المصرفية الرقمية الكاملة.',read:'5 دقائق قراءة',color:'#0EA5E9'},
    {tag:'تعليم',date:'5 مارس 2026',title:'الليرة السورية الجديدة: كل ما تحتاج معرفته عن إلغاء الأصفار',desc:'شرح مفصل لقرار البنك المركزي السوري بحذف صفرين من الليرة، وكيف يؤثر ذلك على حسابك وتحويلاتك.',read:'8 دقائق قراءة',color:'#059669'},
    {tag:'نصائح',date:'1 مارس 2026',title:'كيف ترسل أموال لعائلتك بسوريا بأقل التكاليف',desc:'دليل شامل لأفضل طرق تحويل الأموال لسوريا — مقارنة الرسوم، السرعة، والأمان بين مختلف الخدمات.',read:'6 دقائق قراءة',color:'#7C3AED'},
    {tag:'تكنولوجيا',date:'25 فبراير 2026',title:'ما هو IBAN وكيف تستخدمه مع حسابك الرقمي',desc:'كل ما تحتاج معرفته عن رقم الحساب البنكي الدولي IBAN — ما هو، كيف تحصل عليه، وكيف تستخدمه للتحويلات.',read:'4 دقائق قراءة',color:'#DB2777'},
    {tag:'أمان',date:'20 فبراير 2026',title:'10 نصائح لحماية حسابك البنكي من الاختراق',desc:'حماية حسابك البنكي الرقمي أمر بالغ الأهمية. اتبع هذه النصائح العشرة لضمان أمان أموالك.',read:'7 دقائق قراءة',color:'#F59E0B'},
    {tag:'عملات رقمية',date:'15 فبراير 2026',title:'البيتكوين والعملات الرقمية: دليل المبتدئين',desc:'هل تفكر بالاستثمار في العملات الرقمية؟ إليك دليل شامل للمبتدئين يشرح الأساسيات والمخاطر.',read:'10 دقائق قراءة',color:'#EA580C'},
  ],
  categories:['الكل','أخبار','تعليم','نصائح','تكنولوجيا','أمان','عملات رقمية'],
  readMore:'اقرأ المزيد ←',
  newsletter:'اشترك بالنشرة',nlDesc:'احصل على أحدث المقالات والأخبار المالية.',nlPh:'بريدك الإلكتروني...',nlBtn:'اشترك',nlDone:'✓ تم الاشتراك!',
} : {
  tag:'Blog',title:'Latest articles.',fade:'Financial news & tips.',
  posts:[
    {tag:'News',date:'Mar 8, 2026',title:'SDB Bank Obtains European Financial License',desc:'SDB Bank has officially received the necessary financial licenses from Danish authorities, paving the way for full digital banking services.',read:'5 min read',color:'#0EA5E9'},
    {tag:'Education',date:'Mar 5, 2026',title:'The New Syrian Lira: Everything About the Redenomination',desc:'Detailed explanation of the Central Bank\'s decision to remove two zeros from the Lira, and how it affects your accounts and transfers.',read:'8 min read',color:'#059669'},
    {tag:'Tips',date:'Mar 1, 2026',title:'How to Send Money to Family in Syria at Lowest Cost',desc:'Complete guide to the best ways to transfer money to Syria — comparing fees, speed, and security across different services.',read:'6 min read',color:'#7C3AED'},
    {tag:'Tech',date:'Feb 25, 2026',title:'What is IBAN and How to Use It with Your Digital Account',desc:'Everything about the International Bank Account Number — what it is, how to get it, and how to use it for transfers.',read:'4 min read',color:'#DB2777'},
    {tag:'Security',date:'Feb 20, 2026',title:'10 Tips to Protect Your Bank Account from Hacking',desc:'Protecting your digital bank account is crucial. Follow these ten tips to ensure your money stays safe.',read:'7 min read',color:'#F59E0B'},
    {tag:'Crypto',date:'Feb 15, 2026',title:'Bitcoin and Cryptocurrency: A Beginner\'s Guide',desc:'Thinking about investing in crypto? Here\'s a comprehensive guide explaining the basics and risks.',read:'10 min read',color:'#EA580C'},
  ],
  categories:['All','News','Education','Tips','Tech','Security','Crypto'],
  readMore:'Read more →',
  newsletter:'Subscribe to our newsletter',nlDesc:'Get the latest articles and financial news.',nlPh:'Your email...',nlBtn:'Subscribe',nlDone:'✓ Subscribed!',
});
const activeCat = ref(0);
const nlEm = ref('');const nlDone = ref(false);
</script>
<template>
<Head :title="isAr?'المدونة — SDB Bank':'Blog — SDB Bank'"/>
<section class="hero"><div class="sw">
  <div class="hero-tag an">{{ t.tag }}</div>
  <h1 class="t2 an">{{ t.title }}<br><span class="t2-em">{{ t.fade }}</span></h1>
</div></section>
<section class="sec"><div class="sw">
  <div class="cats an"><button v-for="(c,i) in t.categories" :key="c" @click="activeCat=i" class="cat-btn" :class="{'cat-active':activeCat===i}">{{ c }}</button></div>
  <div class="posts-grid an">
    <div v-for="(p,i) in t.posts" :key="i" class="post-c">
      <div class="post-tag" :style="{background:p.color+'15',color:p.color}">{{ p.tag }}</div>
      <h3 class="post-t">{{ p.title }}</h3>
      <p class="post-d">{{ p.desc }}</p>
      <div class="post-meta"><span class="post-date">{{ p.date }}</span><span class="post-read">{{ p.read }}</span></div>
      <span class="post-link">{{ t.readMore }}</span>
    </div>
  </div>
</div></section>
<section class="sec sec-alt"><div class="sw tc">
  <h2 class="t2 an">{{ t.newsletter }}</h2>
  <p class="t2-sub an tc" style="margin:0 auto 32px">{{ t.nlDesc }}</p>
  <div class="nl-row an"><template v-if="!nlDone"><input v-model="nlEm" :placeholder="t.nlPh" class="nl-i" @keyup.enter="nlDone=!!nlEm"/><button @click="nlDone=!!nlEm" class="nl-b">{{ t.nlBtn }}</button></template><div v-else class="nl-ok">{{ t.nlDone }}</div></div>
</div></section>
</template>
<style scoped>
.hero{padding:160px 0 60px;background:linear-gradient(135deg,#0C4A6E,#0369A1,#0EA5E9);color:#fff}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.7);text-transform:uppercase;margin-bottom:24px}
.t2{font-size:clamp(2rem,4vw,3.2rem);font-weight:900;line-height:1.1;margin-bottom:16px;color:#0C4A6E}.t2-em{color:#0EA5E9}
.hero .t2{color:#fff}.hero .t2-em{color:#E0F2FE}
.t2-sub{font-size:16px;color:rgba(10,10,10,.6);line-height:1.85;max-width:520px}
.sec{padding:80px 0}.sec-alt{background:#fafafa}
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.cats{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:40px}
.cat-btn{padding:8px 20px;background:transparent;border:1px solid rgba(10,10,10,.1);border-radius:10px;font-size:13px;font-weight:700;color:rgba(10,10,10,.5);cursor:pointer;font-family:inherit;transition:all .2s}.cat-btn:hover{border-color:#0EA5E9;color:#0EA5E9}
.cat-active{background:#0EA5E9!important;color:#fff!important;border-color:#0EA5E9!important}
.posts-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px}
.post-c{padding:28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;display:flex;flex-direction:column;transition:all .3s;cursor:pointer}.post-c:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(0,0,0,.06)}
.post-tag{display:inline-block;padding:4px 12px;border-radius:8px;font-size:11px;font-weight:800;margin-bottom:16px;align-self:flex-start}
.post-t{font-size:18px;font-weight:900;color:#0C4A6E;margin-bottom:10px;line-height:1.4}
.post-d{font-size:14px;color:rgba(10,10,10,.55);line-height:1.8;flex:1;margin-bottom:16px}
.post-meta{display:flex;justify-content:space-between;font-size:12px;color:rgba(10,10,10,.35);margin-bottom:12px}
.post-link{font-size:13px;font-weight:700;color:#0EA5E9}
.nl-row{display:flex;gap:0;max-width:420px;margin:0 auto;border:2px solid #0C4A6E;border-radius:14px;overflow:hidden}
.nl-i{flex:1;padding:14px 18px;border:none;outline:none;font-size:15px;background:transparent;font-family:inherit}.nl-i::placeholder{color:#ccc}
.nl-b{padding:14px 28px;background:#0C4A6E;color:#fff;border:none;font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;white-space:nowrap}.nl-b:hover{background:#0a3a5c}
.nl-ok{padding:14px;color:#059669;font-weight:700;font-size:15px}
.an{opacity:0;transform:translateY(24px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
@media(max-width:768px){.posts-grid{grid-template-columns:1fr}}
</style>
