<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed, onMounted, ref } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
let obs;
onMounted(()=>{obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.08});document.querySelectorAll('.an').forEach(el=>obs.observe(el))});

const copied = ref(false);
function copyLink() {
  navigator.clipboard.writeText('https://sdb-bank.com/preregister?ref=FRIEND');
  copied.value = true;
  setTimeout(() => copied.value = false, 2000);
}

const t = computed(() => isAr.value ? {
  tag:'برنامج الإحالة',title:'ادعُ أصدقاءك.',fade:'واحصل على مكافآت.',
  desc:'شارك رابط الإحالة الخاص بك واحصل على مكافآت عند تسجيل أصدقائك.',
  howTitle:'كيف يعمل؟',
  steps:[
    {n:'1',t:'شارك رابطك',d:'انسخ رابط الإحالة وأرسله لأصدقائك وعائلتك.'},
    {n:'2',t:'يسجّل صديقك',d:'عندما يسجّل صديقك باستخدام رابطك، يحصل على مكافأة ترحيبية.'},
    {n:'3',t:'تحصل على مكافأة',d:'تحصل أنت أيضاً على مكافأة لكل صديق يسجّل.'},
  ],
  rewardsTitle:'المكافآت',
  rewards:[
    {ic:'🎁',t:'10€ لك',d:'لكل صديق يفتح حساباً ويُفعّله.'},
    {ic:'🎉',t:'10€ لصديقك',d:'مكافأة ترحيبية عند التسجيل.'},
    {ic:'♾️',t:'بلا حدود',d:'ادعُ عدداً غير محدود من الأصدقاء.'},
    {ic:'⚡',t:'فوري',d:'المكافآت تُضاف فوراً لحسابك.'},
  ],
  linkTitle:'رابط الإحالة الخاص بك',
  copy:'نسخ الرابط',copied:'تم النسخ ✓',
  ctaTitle:'ابدأ الآن',ctaSub:'سجّل واحصل على رابط الإحالة الخاص بك.',ctaBtn:'سجّل مبكراً →',
} : {
  tag:'Referral Program',title:'Invite your friends.',fade:'Earn rewards.',
  desc:'Share your referral link and earn rewards when your friends sign up.',
  howTitle:'How it works',
  steps:[
    {n:'1',t:'Share your link',d:'Copy your referral link and send it to your friends and family.'},
    {n:'2',t:'Friend signs up',d:'When your friend registers using your link, they get a welcome bonus.'},
    {n:'3',t:'You earn a reward',d:'You also get a reward for every friend who signs up.'},
  ],
  rewardsTitle:'Rewards',
  rewards:[
    {ic:'🎁',t:'€10 for you',d:'For each friend who opens and activates an account.'},
    {ic:'🎉',t:'€10 for your friend',d:'Welcome bonus on sign-up.'},
    {ic:'♾️',t:'Unlimited',d:'Invite an unlimited number of friends.'},
    {ic:'⚡',t:'Instant',d:'Rewards are added instantly to your account.'},
  ],
  linkTitle:'Your referral link',
  copy:'Copy link',copied:'Copied ✓',
  ctaTitle:'Start now',ctaSub:'Register and get your personal referral link.',ctaBtn:'Pre-register →',
});
</script>
<template>
<Head :title="isAr?'برنامج الإحالة — SDB Bank':'Referral Program — SDB Bank'"/>
<section class="hero"><div class="sw tc">
  <div class="hero-tag an">{{ t.tag }}</div>
  <h1 class="t2 an">{{ t.title }}<br><span class="t2-em">{{ t.fade }}</span></h1>
  <p class="t2-sub an tc" style="max-width:600px;margin:0 auto">{{ t.desc }}</p>
</div></section>

<section class="sec"><div class="sw">
  <h2 class="t2 tc an">{{ t.howTitle }}</h2>
  <div class="steps-grid an">
    <div v-for="s in t.steps" :key="s.n" class="step-c">
      <div class="step-n">{{ s.n }}</div>
      <h4 class="step-t">{{ s.t }}</h4>
      <p class="step-d">{{ s.d }}</p>
    </div>
  </div>
</div></section>

<section class="sec sec-alt"><div class="sw">
  <h2 class="t2 tc an">{{ t.rewardsTitle }}</h2>
  <div class="rewards-grid an">
    <div v-for="r in t.rewards" :key="r.t" class="reward-c">
      <span class="reward-ic">{{ r.ic }}</span>
      <h4 class="reward-t">{{ r.t }}</h4>
      <p class="reward-d">{{ r.d }}</p>
    </div>
  </div>
</div></section>

<section class="sec"><div class="sw tc">
  <h3 class="t2 an">{{ t.linkTitle }}</h3>
  <div class="ref-box an">
    <code class="ref-url">https://sdb-bank.com/preregister?ref=FRIEND</code>
    <button class="ref-copy" @click="copyLink">{{ copied ? t.copied : t.copy }}</button>
  </div>
</div></section>

<section class="sec sec-cta"><div class="sw tc">
  <h2 class="t2 an">{{ t.ctaTitle }}</h2>
  <p class="t2-sub an tc" style="margin:0 auto 32px">{{ t.ctaSub }}</p>
  <Link href="/preregister" class="cta-btn an">{{ t.ctaBtn }}</Link>
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
.steps-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:24px;margin-top:40px}
.step-c{padding:32px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:20px;text-align:center;box-shadow:0 4px 16px rgba(0,0,0,.03)}
.step-n{width:48px;height:48px;background:linear-gradient(135deg,#0EA5E9,#0284C7);color:#fff;font-size:20px;font-weight:900;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 16px}
.step-t{font-size:16px;font-weight:800;color:#0C4A6E;margin-bottom:8px}
.step-d{font-size:14px;color:rgba(10,10,10,.6);line-height:1.7}
.rewards-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-top:40px}
.reward-c{padding:28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px;text-align:center;transition:all .3s}.reward-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.reward-ic{font-size:32px;display:block;margin-bottom:10px}
.reward-t{font-size:15px;font-weight:800;color:#0C4A6E;margin-bottom:6px}
.reward-d{font-size:13px;color:rgba(10,10,10,.5);line-height:1.7}
.ref-box{display:inline-flex;align-items:center;gap:12px;padding:8px 8px 8px 24px;background:#fff;border:2px solid rgba(14,165,233,.15);border-radius:16px;margin-top:16px;max-width:100%;flex-wrap:wrap;justify-content:center}
.ref-url{font-size:14px;color:#0C4A6E;font-weight:600;word-break:break-all}
.ref-copy{padding:12px 24px;background:linear-gradient(135deg,#0284C7,#0EA5E9);color:#fff;border:none;border-radius:12px;font-size:14px;font-weight:800;cursor:pointer;font-family:inherit;transition:all .2s;white-space:nowrap}.ref-copy:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(14,165,233,.2)}
.cta-btn{display:inline-block;padding:18px 48px;background:linear-gradient(135deg,#0284C7,#0EA5E9);color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(14,165,233,.2)}
.an{opacity:0;transform:translateY(24px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
@media(max-width:768px){
  .hero{padding:130px 0 50px}
  .t2{font-size:clamp(1.6rem,5vw,2.4rem)}
  .sec{padding:50px 0}.sec-cta{padding:60px 0}
  .sw{padding:0 16px}
  .steps-grid,.rewards-grid{grid-template-columns:1fr;gap:12px}
  .step-c,.reward-c{padding:24px 20px}
  .ref-box{flex-direction:column;padding:16px}
  .ref-copy{width:100%}
  .cta-btn{width:100%;text-align:center;padding:16px 24px;display:block}
}
</style>
