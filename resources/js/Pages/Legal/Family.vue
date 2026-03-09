<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'الحساب العائلي — SDB Bank',tag:'حساب العائلة',
  heroH:'عائلتك بأمان.',heroEm:'مالي.',
  heroP:'حساب عائلي متكامل — بطاقات للأطفال بحدود قابلة للتحكم، إشعارات فورية لكل عملية، وأدوات تعليمية لتنمية الوعي المالي.',
  heroBtn:'سجّل اهتمامك ←',
  featTitle:'كل العائلة. حساب واحد.',
  feats:[
    {ic:'👨‍👩‍👧‍👦',t:'بطاقات لكل فرد',d:'أصدر بطاقات مخصصة لكل فرد بالعائلة. بطاقات أطفال (6+) ببطاقة افتراضية آمنة مع حدود صرف مخصصة.'},
    {ic:'🎯',t:'حدود مصاريف ذكية',d:'حدد لكل طفل مبلغ يومي أو شهري. فئات محددة (لا ألعاب، لا شراء داخل التطبيقات). تحكم كامل من حسابك.'},
    {ic:'🔔',t:'إشعارات الأهل',d:'تنبيه فوري على هاتفك لحظة صرف أي فرد من العائلة. ماذا اشترى؟ أين؟ بكم؟'},
    {ic:'📊',t:'تقارير عائلية',d:'تقرير شامل لمصاريف كل العائلة. من يصرف أكثر؟ على ماذا؟ مقارنات شهرية.'},
    {ic:'🎓',t:'تعليم مالي',d:'مهام وتحديات مالية للأطفال. "وفّر €20 هذا الأسبوع" — مكافآت رقمية لتحفيز الادخار.'},
    {ic:'💰',t:'مصروف تلقائي',d:'حدد مبلغ أسبوعي أو شهري يُحوّل تلقائياً لبطاقة الطفل. بدون ما تنساه.'},
    {ic:'🔒',t:'تحكم الأهل',d:'أوقف أو جمّد أي بطاقة فوراً. حدد ساعات الاستخدام. حظر تجار معينين.'},
    {ic:'🎮',t:'تطبيق الأطفال',d:'واجهة مبسطة وممتعة للأطفال. يشوفون رصيدهم ومصاريفهم بطريقة تعليمية.'},
    {ic:'🎁',t:'مكافآت العائلة',d:'نقاط مكافآت عائلية على كل المشتريات. اجمعوها معاً واستبدلوها بهدايا.'},
  ],
  pricingTitle:'باقات العائلة',
  pricing:[
    {n:'عائلي مجاني',p:'مجاني',f:['حساب الأهل + طفل واحد','بطاقة افتراضية للطفل','إشعارات أساسية','حدود مصاريف']},
    {n:'عائلي Plus',p:'€4.99/شهر',f:['حتى 4 بطاقات أطفال','بطاقات فعلية','تقارير متقدمة','مهام مالية','مصروف تلقائي']},
  ],
  ctaTitle:'ابدأ رحلة عائلتك المالية',ctaSub:'علّم أطفالك إدارة المال من صغرهم.',ctaBtn:'سجّل اهتمامك ←',ctaTag:'قريباً',
} : {
  title:'Family Account — SDB Bank',tag:'Family Account',
  heroH:'Your family.',heroEm:'Financially safe.',
  heroP:'Complete family account — kids cards with controllable limits, instant notifications for every transaction, and educational tools for financial literacy.',
  heroBtn:'Register interest →',
  featTitle:'Whole family. One account.',
  feats:[
    {ic:'👨‍👩‍👧‍👦',t:'Cards for Everyone',d:'Issue custom cards for every family member. Kids cards (6+) with safe virtual card and custom spending limits.'},
    {ic:'🎯',t:'Smart Spending Limits',d:'Set daily or monthly amounts per child. Specific categories (no games, no in-app purchases). Full control from your account.'},
    {ic:'🔔',t:'Parent Notifications',d:'Instant alert on your phone the moment any family member spends. What did they buy? Where? How much?'},
    {ic:'📊',t:'Family Reports',d:'Comprehensive report of all family spending. Who spends most? On what? Monthly comparisons.'},
    {ic:'🎓',t:'Financial Education',d:'Tasks and challenges for kids. "Save €20 this week" — digital rewards to encourage saving.'},
    {ic:'💰',t:'Auto Allowance',d:'Set weekly or monthly amount auto-transferred to child\'s card. Never forget.'},
    {ic:'🔒',t:'Parental Controls',d:'Pause or freeze any card instantly. Set usage hours. Block specific merchants.'},
    {ic:'🎮',t:'Kids App',d:'Simplified and fun interface for kids. They see their balance and spending in an educational way.'},
    {ic:'🎁',t:'Family Rewards',d:'Family reward points on all purchases. Collect together and redeem for gifts.'},
  ],
  pricingTitle:'Family Plans',
  pricing:[
    {n:'Family Free',p:'Free',f:['Parent account + 1 child','Virtual card for child','Basic notifications','Spending limits']},
    {n:'Family Plus',p:'€4.99/mo',f:['Up to 4 kids cards','Physical cards','Advanced reports','Financial tasks','Auto allowance']},
  ],
  ctaTitle:'Start your family\'s financial journey',ctaSub:'Teach your kids money management from a young age.',ctaBtn:'Register interest →',ctaTag:'Coming Soon',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><a href="/preregister" class="hero-btn">{{ t.heroBtn }}</a></div></section>
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.featTitle }}</h2><div class="g3"><div v-for="f in t.feats" :key="f.t" class="fc"><span class="fc-ic">{{ f.ic }}</span><h3 class="fc-t">{{ f.t }}</h3><p class="fc-d">{{ f.d }}</p></div></div></div></section>
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.pricingTitle }}</h2><div class="plan-row"><div v-for="p in t.pricing" :key="p.n" class="plan-c"><h3 class="plan-n">{{ p.n }}</h3><div class="plan-p">{{ p.p }}</div><ul class="plan-f"><li v-for="f in p.f" :key="f">✓ {{ f }}</li></ul></div></div></div></section>
<section class="sec sec-sky tc"><div class="sw"><div class="tag-sm">{{ t.ctaTag }}</div><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F0FDF4}.sec-sky{background:linear-gradient(135deg,#064E3B,#047857,#10B981);color:#fff;padding:100px 0}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.tag-sm{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:16px}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#064E3B,#047857,#10B981);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.5);text-transform:uppercase;margin-bottom:20px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#6EE7B7}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto 28px;line-height:1.8}
.hero-btn{display:inline-block;padding:16px 44px;background:#fff;color:#064E3B;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.hero-btn:hover{transform:translateY(-2px)}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.fc{padding:28px;background:#fff;border:1px solid rgba(16,185,129,.08);border-radius:18px;transition:all .3s}.fc:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(16,185,129,.06)}
.fc-ic{font-size:28px;display:block;margin-bottom:10px}.fc-t{font-size:15px;font-weight:800;color:#064E3B;margin-bottom:6px}.fc-d{font-size:12.5px;color:rgba(10,10,10,.4);line-height:1.75}
.plan-row{display:grid;grid-template-columns:repeat(2,1fr);gap:16px;max-width:700px;margin:0 auto}
.plan-c{padding:32px;background:#fff;border:1px solid rgba(16,185,129,.08);border-radius:20px;text-align:center}
.plan-n{font-size:18px;font-weight:900;color:#064E3B;margin-bottom:8px}.plan-p{font-size:24px;font-weight:900;color:#10B981;margin-bottom:20px}
.plan-f{list-style:none;padding:0;display:flex;flex-direction:column;gap:8px;text-align:start}.plan-f li{font-size:13px;color:rgba(10,10,10,.5);padding:6px 0;border-bottom:1px solid rgba(16,185,129,.06)}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#064E3B;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.g3,.plan-row{grid-template-columns:1fr}}
</style>
