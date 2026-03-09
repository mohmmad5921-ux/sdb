<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed, onMounted } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
let obs;
onMounted(()=>{obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.08});document.querySelectorAll('.an').forEach(el=>obs.observe(el))});
const t = computed(() => isAr.value ? {
  tag:'برنامج الإحالة',title:'ادعُ صديقك.',fade:'واحصل على مكافأة.',
  sub:'شارك SDB Bank مع أصدقائك وعائلتك. لكل شخص يسجّل حسابك عن طريق رابطك، تحصل أنت وهو على مكافأة.',
  howTitle:'كيف يعمل؟',
  steps:[
    {n:'1',t:'شارك رابطك',d:'انسخ رابط الإحالة الخاص بك من التطبيق وشاركه مع صديقك عبر أي وسيلة.','ic':'📤'},
    {n:'2',t:'صديقك يسجّل',d:'صديقك يفتح حساب مجاني باستخدام رابط الإحالة ويُكمل التحقق من الهوية.','ic':'📱'},
    {n:'3',t:'كلاكما يكسب',d:'عند إتمام أول تحويل، تحصل أنت وصديقك على المكافأة مباشرة بحسابكم.','ic':'🎁'},
  ],
  rewards:'المكافآت',
  rewardCards:[
    {v:'1,500 ل.س',l:'لك',d:'عند تسجيل كل صديق',c:'#0EA5E9'},
    {v:'1,500 ل.س',l:'لصديقك',d:'بونص ترحيبي فوري',c:'#059669'},
    {v:'لا حدود',l:'للإحالات',d:'ادعُ عدد لا محدود من الأصدقاء',c:'#7C3AED'},
  ],
  terms:'الشروط',
  termsList:['يجب أن يكون الحساب جديداً (لم يسجّل سابقاً)','المكافأة تُضاف بعد أول تحويل بقيمة 750 ل.س أو أكثر','المكافآت تُضاف خلال 24 ساعة من إتمام الشروط','يحق لـ SDB Bank تعديل أو إيقاف البرنامج بأي وقت'],
  ctaTitle:'ابدأ بكسب المكافآت الآن',ctaBtn:'شارك رابطك ←',
} : {
  tag:'Referral Program',title:'Invite a friend.',fade:'Earn a reward.',
  sub:'Share SDB Bank with friends and family. For each person who signs up through your link, you both earn a reward.',
  howTitle:'How it works',
  steps:[
    {n:'1',t:'Share your link',d:'Copy your unique referral link from the app and share it with a friend via any channel.','ic':'📤'},
    {n:'2',t:'Friend signs up',d:'Your friend opens a free account using your referral link and completes identity verification.','ic':'📱'},
    {n:'3',t:'Both earn',d:'After their first transfer, both you and your friend receive the reward directly to your accounts.','ic':'🎁'},
  ],
  rewards:'Rewards',
  rewardCards:[
    {v:'€10',l:'For you',d:'For each friend who signs up',c:'#0EA5E9'},
    {v:'€10',l:'For your friend',d:'Instant welcome bonus',c:'#059669'},
    {v:'Unlimited',l:'Referrals',d:'Invite as many friends as you want',c:'#7C3AED'},
  ],
  terms:'Terms & Conditions',
  termsList:['Account must be new (never registered before)','Reward credited after first transfer of €5 or more','Rewards credited within 24 hours of meeting conditions','SDB Bank reserves the right to modify or end the program at any time'],
  ctaTitle:'Start earning rewards now',ctaBtn:'Share your link →',
});
</script>
<template>
<Head :title="isAr?'برنامج الإحالة — SDB Bank':'Referral — SDB Bank'"/>
<section class="hero"><div class="sw tc">
  <div class="hero-tag an">{{ t.tag }}</div>
  <h1 class="t2 an">{{ t.title }}<br><span class="t2-em">{{ t.fade }}</span></h1>
  <p class="t2-sub an tc" style="margin:0 auto">{{ t.sub }}</p>
</div></section>
<section class="sec"><div class="sw">
  <h2 class="t2 tc an">{{ t.howTitle }}</h2>
  <div class="steps an"><div v-for="s in t.steps" :key="s.n" class="step-c"><span class="step-ic">{{ s.ic }}</span><div class="step-n">{{ s.n }}</div><h4 class="step-t">{{ s.t }}</h4><p class="step-d">{{ s.d }}</p></div></div>
</div></section>
<section class="sec sec-alt"><div class="sw">
  <h2 class="t2 tc an">{{ t.rewards }}</h2>
  <div class="rw-grid an"><div v-for="r in t.rewardCards" :key="r.l" class="rw-c"><div class="rw-v" :style="{color:r.c}">{{ r.v }}</div><div class="rw-l">{{ r.l }}</div><p class="rw-d">{{ r.d }}</p></div></div>
</div></section>
<section class="sec"><div class="sw">
  <h2 class="t2 tc an">{{ t.terms }}</h2>
  <ul class="terms-list an"><li v-for="tm in t.termsList" :key="tm">{{ tm }}</li></ul>
</div></section>
<section class="sec sec-cta"><div class="sw tc">
  <h2 class="t2 an">{{ t.ctaTitle }}</h2>
  <a href="/preregister" class="cta-btn an">{{ t.ctaBtn }}</a>
</div></section>
</template>
<style scoped>
.hero{padding:160px 0 80px;background:linear-gradient(135deg,#7C3AED 0%,#6D28D9 50%,#A855F7 100%);color:#fff}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.7);text-transform:uppercase;margin-bottom:24px}
.t2{font-size:clamp(2rem,4vw,3.2rem);font-weight:900;line-height:1.1;margin-bottom:16px;color:#0C4A6E}.t2-em{color:#7C3AED}
.hero .t2{color:#fff}.hero .t2-em{color:#DDD6FE}
.t2-sub{font-size:16px;color:rgba(10,10,10,.6);line-height:1.85;max-width:520px}.hero .t2-sub{color:rgba(255,255,255,.7)}
.sec{padding:80px 0}.sec-alt{background:#fafafa}.sec-cta{padding:100px 0;background:linear-gradient(135deg,#F5F3FF,#EDE9FE)}
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.steps{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;position:relative}
.steps::before{content:'';position:absolute;top:80px;left:15%;right:15%;height:2px;background:linear-gradient(90deg,#7C3AED,#A855F7,#7C3AED);opacity:.15}
.step-c{padding:32px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;text-align:center;position:relative;transition:all .3s}.step-c:hover{transform:translateY(-4px);box-shadow:0 8px 24px rgba(0,0,0,.05)}
.step-ic{font-size:32px;display:block;margin-bottom:12px}
.step-n{width:36px;height:36px;background:linear-gradient(135deg,#7C3AED,#A855F7);color:#fff;font-size:16px;font-weight:900;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 12px}
.step-t{font-size:16px;font-weight:800;color:#0C4A6E;margin-bottom:6px}.step-d{font-size:13px;color:rgba(10,10,10,.55);line-height:1.7}
.rw-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px}
.rw-c{padding:36px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:20px;text-align:center;transition:all .3s}.rw-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.rw-v{font-size:clamp(2rem,4vw,3rem);font-weight:900;margin-bottom:8px}.rw-l{font-size:16px;font-weight:800;color:#0C4A6E;margin-bottom:6px}.rw-d{font-size:13px;color:rgba(10,10,10,.5);line-height:1.6}
.terms-list{max-width:600px;margin:0 auto;list-style:none;padding:0;display:flex;flex-direction:column;gap:12px}
.terms-list li{font-size:14px;color:rgba(10,10,10,.6);padding:12px 16px;background:#fafafa;border-radius:10px;display:flex;align-items:center;gap:8px;line-height:1.6}
.terms-list li::before{content:'•';color:#7C3AED;font-weight:900;font-size:18px}
.cta-btn{display:inline-block;padding:18px 48px;background:linear-gradient(135deg,#7C3AED,#A855F7);color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(124,58,237,.3)}
.an{opacity:0;transform:translateY(24px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
@media(max-width:768px){.steps,.rw-grid{grid-template-columns:1fr}.steps::before{display:none}}
</style>
