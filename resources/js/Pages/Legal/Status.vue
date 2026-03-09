<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, computed, onMounted, ref } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
let obs;
onMounted(()=>{obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.08});document.querySelectorAll('.an').forEach(el=>obs.observe(el))});

const t = computed(() => isAr.value ? {
  tag:'حالة الخدمة',title:'كل الأنظمة تعمل.',fade:'بسلاسة.',
  desc:'تحقق من حالة خدمات SDB Bank في الوقت الفعلي.',
  services:[
    {n:'🌐 الموقع الإلكتروني',s:'operational',l:'شغّال'},
    {n:'📱 تطبيق الموبايل',s:'operational',l:'شغّال'},
    {n:'💳 خدمات البطاقات',s:'operational',l:'شغّال'},
    {n:'💸 التحويلات الدولية',s:'operational',l:'شغّال'},
    {n:'💱 محوّل العملات',s:'operational',l:'شغّال'},
    {n:'🔐 المصادقة والأمان',s:'operational',l:'شغّال'},
    {n:'📧 نظام الإيميل',s:'operational',l:'شغّال'},
    {n:'🏦 واجهة البنك API',s:'operational',l:'شغّال'},
  ],
  uptimeTitle:'وقت التشغيل',uptime:'99.99%',uptimeDesc:'خلال آخر 30 يوم',
  lastChecked:'آخر فحص: الآن',
} : {
  tag:'Service Status',title:'All systems operational.',fade:'Running smoothly.',
  desc:'Check the real-time status of SDB Bank services.',
  services:[
    {n:'🌐 Website',s:'operational',l:'Operational'},
    {n:'📱 Mobile App',s:'operational',l:'Operational'},
    {n:'💳 Card Services',s:'operational',l:'Operational'},
    {n:'💸 International Transfers',s:'operational',l:'Operational'},
    {n:'💱 Currency Converter',s:'operational',l:'Operational'},
    {n:'🔐 Authentication & Security',s:'operational',l:'Operational'},
    {n:'📧 Email System',s:'operational',l:'Operational'},
    {n:'🏦 Banking API',s:'operational',l:'Operational'},
  ],
  uptimeTitle:'Uptime',uptime:'99.99%',uptimeDesc:'Over the last 30 days',
  lastChecked:'Last checked: Just now',
});
</script>
<template>
<Head :title="isAr?'حالة الخدمة — SDB Bank':'Service Status — SDB Bank'"/>
<section class="hero"><div class="sw tc">
  <div class="hero-tag an">{{ t.tag }}</div>
  <h1 class="t2 an">{{ t.title }}<br><span class="t2-em">{{ t.fade }}</span></h1>
  <p class="t2-sub an tc" style="max-width:500px;margin:0 auto">{{ t.desc }}</p>
</div></section>
<section class="sec"><div class="sw">
  <div class="status-card an">
    <div v-for="s in t.services" :key="s.n" class="status-row">
      <span class="status-name">{{ s.n }}</span>
      <span class="status-badge" :class="'st-'+s.s">{{ s.l }}</span>
    </div>
  </div>
  <div class="uptime-bar an">
    <h3 class="up-title">{{ t.uptimeTitle }}</h3>
    <div class="up-number">{{ t.uptime }}</div>
    <p class="up-desc">{{ t.uptimeDesc }}</p>
    <div class="up-visual"><div class="up-fill" style="width:99.99%"></div></div>
  </div>
  <p class="last-check an tc">{{ t.lastChecked }}</p>
</div></section>
</template>
<style scoped>
.hero{padding:160px 0 80px;background:linear-gradient(135deg,#059669 0%,#10B981 50%,#34D399 100%);color:#fff}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:rgba(255,255,255,.7);text-transform:uppercase;margin-bottom:24px}
.t2{font-size:clamp(2rem,4vw,3.2rem);font-weight:900;line-height:1.1;margin-bottom:16px;color:#fff}.t2-em{color:#D1FAE5}
.t2-sub{font-size:16px;color:rgba(255,255,255,.7);line-height:1.85}
.sec{padding:80px 0}.sw{max-width:800px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.status-card{background:#fff;border-radius:20px;overflow:hidden;box-shadow:0 8px 32px rgba(0,0,0,.04);border:1px solid rgba(16,185,129,.08)}
.status-row{display:flex;justify-content:space-between;align-items:center;padding:18px 24px;border-bottom:1px solid rgba(16,185,129,.04)}.status-row:last-child{border:none}
.status-name{font-size:14px;font-weight:600;color:#0C4A6E}
.status-badge{padding:4px 14px;border-radius:50px;font-size:12px;font-weight:800}
.st-operational{background:rgba(16,185,129,.08);color:#059669}
.st-degraded{background:rgba(245,158,11,.08);color:#D97706}
.st-down{background:rgba(220,38,38,.08);color:#DC2626}
.uptime-bar{margin-top:32px;padding:28px;background:#fff;border-radius:16px;text-align:center;box-shadow:0 4px 16px rgba(0,0,0,.03);border:1px solid rgba(16,185,129,.06)}
.up-title{font-size:14px;font-weight:800;color:rgba(10,10,10,.5);margin-bottom:8px;text-transform:uppercase;letter-spacing:2px}
.up-number{font-size:40px;font-weight:900;color:#059669;margin-bottom:4px}
.up-desc{font-size:13px;color:rgba(10,10,10,.4);margin-bottom:16px}
.up-visual{height:8px;background:rgba(16,185,129,.1);border-radius:4px;overflow:hidden}
.up-fill{height:100%;background:linear-gradient(90deg,#059669,#10B981);border-radius:4px}
.last-check{margin-top:24px;font-size:13px;color:rgba(10,10,10,.35);font-weight:600}
.an{opacity:0;transform:translateY(24px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
@media(max-width:768px){
  .hero{padding:130px 0 50px}
  .t2{font-size:clamp(1.6rem,5vw,2.4rem)}
  .status-row{padding:14px 16px}
  .status-name{font-size:13px}
}
</style>
