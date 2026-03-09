<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'تطبيق SDB Bank',tag:'التطبيق',
  heroH:'بنكك كله.',heroEm:'بجيبتك.',
  heroP:'تطبيق واحد يجمع كل خدماتك البنكية. صُمم ليكون بسيطاً وقوياً — واجهة عربية كاملة مع تجربة استخدام لا مثيل لها.',
  heroBtn1:'App Store',heroBtn2:'Google Play',
  screensTitle:'كل شيء من شاشة واحدة',
  screens:[
    {ic:'🏠',t:'لوحة التحكم',d:'نظرة شاملة على رصيدك، آخر العمليات، بطاقاتك، وإحصائيات مصاريفك — كل شيء بنظرة واحدة.'},
    {ic:'💳',t:'إدارة البطاقات',d:'بطاقاتك الافتراضية والفعلية. تجميد، إلغاء تجميد، حدود الإنفاق، وتتبع كل عملية لحظياً.'},
    {ic:'💸',t:'التحويلات',d:'أرسل لأي شخص بالعالم. جهات اتصال محفوظة، تحويلات مجدولة، QR Pay. كل شيء بلمسة.'},
    {ic:'💱',t:'صرف العملات',d:'حوّل بين 30+ عملة بأسعار السوق الحقيقية. رسوم بيانية حية، تنبيهات أسعار، محافظ متعددة.'},
    {ic:'📊',t:'التحليلات',d:'تصنيف تلقائي للمصاريف، ميزانيات شهرية، أهداف ادخار، تقارير مفصّلة بالأسبوع والشهر.'},
    {ic:'🔔',t:'الإشعارات',d:'تنبيه فوري لكل عملية. تخصيص كامل — اختر نوع الإشعارات ومتى تصلك.'},
    {ic:'👤',t:'الملف الشخصي',d:'بياناتك، إعدادات الأمان، اللغة، المظهر. تحقق هويتك ورفع الحدود من نفس المكان.'},
    {ic:'🎧',t:'الدعم',d:'دردشة مباشرة مع فريق الدعم. قاعدة معرفة شاملة. إبلاغ عن مشاكل بخطوات بسيطة.'},
  ],
  specTitle:'المواصفات التقنية',
  specs:[
    {l:'iOS',v:'15.0+',d:'iPhone 8 وأحدث'},{l:'Android',v:'8.0+',d:'معظم الأجهزة'},{l:'الحجم',v:'~65 MB',d:'تحميل سريع'},
    {l:'اللغات',v:'عربي + English',d:'تبديل فوري'},{l:'التحديثات',v:'أسبوعية',d:'ميزات جديدة دائماً'},{l:'الأمان',v:'AES-256',d:'تشفير عسكري'},
  ],
  featTitle:'مميزات التطبيق',
  feats:['واجهة عربية RTL كاملة','وضع داكن / فاتح','مصادقة بيومترية','إشعارات فورية قابلة للتخصيص','ويدجت للشاشة الرئيسية','Apple Watch / Wear OS','دعم QR Code','NFC للدفع','بحث ذكي في العمليات','تصدير كشف حساب PDF','مشاركة تفاصيل الدفع','اختصارات Siri / Google Assistant'],
  ctaTitle:'حمّل التطبيق الآن',ctaSub:'مجاني ومتاح على iOS و Android.',ctaBtn1:'App Store',ctaBtn2:'Google Play',
} : {
  title:'SDB Bank App',tag:'The App',
  heroH:'Your entire bank.',heroEm:'In your pocket.',
  heroP:'One app for all your banking needs. Designed to be simple and powerful — full Arabic interface with an unmatched user experience.',
  heroBtn1:'App Store',heroBtn2:'Google Play',
  screensTitle:'Everything from one screen',
  screens:[
    {ic:'🏠',t:'Dashboard',d:'Complete overview of your balance, recent transactions, cards, and spending analytics — all at a glance.'},
    {ic:'💳',t:'Card Management',d:'Virtual and physical cards. Freeze, unfreeze, spending limits, and real-time transaction tracking.'},
    {ic:'💸',t:'Transfers',d:'Send to anyone worldwide. Saved contacts, scheduled transfers, QR Pay. Everything with one tap.'},
    {ic:'💱',t:'Currency Exchange',d:'Convert between 30+ currencies at real market rates. Live charts, rate alerts, multi-currency wallets.'},
    {ic:'📊',t:'Analytics',d:'Auto-categorized expenses, monthly budgets, savings goals, detailed weekly and monthly reports.'},
    {ic:'🔔',t:'Notifications',d:'Instant alert for every transaction. Fully customizable — choose what alerts you want and when.'},
    {ic:'👤',t:'Profile',d:'Your data, security settings, language, appearance. Verify identity and raise limits from the same place.'},
    {ic:'🎧',t:'Support',d:'Live chat with support team. Comprehensive knowledge base. Report issues in simple steps.'},
  ],
  specTitle:'Technical Specs',
  specs:[
    {l:'iOS',v:'15.0+',d:'iPhone 8 and newer'},{l:'Android',v:'8.0+',d:'Most devices'},{l:'Size',v:'~65 MB',d:'Quick download'},
    {l:'Languages',v:'Arabic + English',d:'Instant switch'},{l:'Updates',v:'Weekly',d:'Always new features'},{l:'Security',v:'AES-256',d:'Military-grade'},
  ],
  featTitle:'App Features',
  feats:['Full Arabic RTL interface','Dark / light mode','Biometric authentication','Customizable instant notifications','Home screen widget','Apple Watch / Wear OS','QR Code support','NFC payments','Smart transaction search','PDF statement export','Payment detail sharing','Siri / Google Assistant shortcuts'],
  ctaTitle:'Download the app now',ctaSub:'Free on iOS and Android.',ctaBtn1:'App Store',ctaBtn2:'Google Play',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><div class="app-img-wrap"><img src="/images/app-mockup.png" alt="SDB App" class="app-hero-img" loading="lazy"/></div><div class="dl-row"><a href="https://apps.apple.com" target="_blank" class="store-badge"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 48" width="160" height="48"><rect width="160" height="48" rx="8" fill="#000"/><g fill="#fff"><path d="M38.7 24.4c0-3.5 2.9-5.2 3-5.3-1.6-2.4-4.2-2.7-5.1-2.7-2.1-.2-4.2 1.3-5.3 1.3s-2.8-1.3-4.6-1.2c-2.4 0-4.5 1.4-5.8 3.5-2.5 4.3-.6 10.6 1.8 14.1 1.2 1.7 2.6 3.6 4.4 3.5 1.8-.1 2.5-1.1 4.6-1.1s2.8 1.1 4.6 1.1c1.9 0 3.1-1.7 4.3-3.4 1.4-2 1.9-3.9 2-4-.1-.1-3.8-1.5-3.9-5.8zM35 14.5c1-1.2 1.6-2.8 1.4-4.5-1.4.1-3.1.9-4.1 2.1-.9 1.1-1.7 2.8-1.5 4.4 1.6.1 3.2-.8 4.2-2z"/><text x="47" y="19" font-family="-apple-system,system-ui,sans-serif" font-size="9" fill="rgba(255,255,255,.7)">Download on the</text><text x="47" y="33" font-family="-apple-system,system-ui,sans-serif" font-size="16" font-weight="600">App Store</text></g></svg></a><a href="https://play.google.com" target="_blank" class="store-badge"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 48" width="160" height="48"><rect width="160" height="48" rx="8" fill="#000"/><g><path d="M19.5 10.8l12.8 7.4-3.3 3.3L19.5 10.8z" fill="#36A852"/><path d="M16.1 10.1c-.3.3-.5.8-.5 1.4v25c0 .6.2 1.1.5 1.4l.1.1 14-14v-.3L16.1 10.1z" fill="#4285F4"/><path d="M32.3 28.5L29 25.2v-.3l3.3-3.3 4.3 2.4c1.2.7 1.2 1.8 0 2.5l-4.3 2z" fill="#FABB05"/><path d="M30.2 25.1L16.2 39c.9.9 2.3 1 3.6.3l14.5-8.3-4-6z" fill="#E94235"/><path d="M30.2 22.9l4.4-6L20 8.5c-1.3-.7-2.7-.6-3.6.3l13.8 14.1z" fill="#36A852"/></g><g fill="#fff"><text x="44" y="19" font-family="-apple-system,system-ui,sans-serif" font-size="9" fill="rgba(255,255,255,.7)">GET IT ON</text><text x="44" y="33" font-family="-apple-system,system-ui,sans-serif" font-size="16" font-weight="600">Google Play</text></g></svg></a></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.screensTitle }}</h2><div class="g4"><div v-for="s in t.screens" :key="s.t" class="sc-c"><span class="sc-ic">{{ s.ic }}</span><h3 class="sc-t">{{ s.t }}</h3><p class="sc-d">{{ s.d }}</p></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.specTitle }}</h2><div class="g6"><div v-for="s in t.specs" :key="s.l" class="spec-c"><div class="spec-l">{{ s.l }}</div><div class="spec-v">{{ s.v }}</div><div class="spec-d">{{ s.d }}</div></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.featTitle }}</h2><div class="feat-grid"><span v-for="f in t.feats" :key="f" class="feat-pill">✓ {{ f }}</span></div></div></section>

<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><div class="dl-row"><a href="https://apps.apple.com" target="_blank" class="store-badge"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 48" width="160" height="48"><rect width="160" height="48" rx="8" fill="#000"/><g fill="#fff"><path d="M38.7 24.4c0-3.5 2.9-5.2 3-5.3-1.6-2.4-4.2-2.7-5.1-2.7-2.1-.2-4.2 1.3-5.3 1.3s-2.8-1.3-4.6-1.2c-2.4 0-4.5 1.4-5.8 3.5-2.5 4.3-.6 10.6 1.8 14.1 1.2 1.7 2.6 3.6 4.4 3.5 1.8-.1 2.5-1.1 4.6-1.1s2.8 1.1 4.6 1.1c1.9 0 3.1-1.7 4.3-3.4 1.4-2 1.9-3.9 2-4-.1-.1-3.8-1.5-3.9-5.8zM35 14.5c1-1.2 1.6-2.8 1.4-4.5-1.4.1-3.1.9-4.1 2.1-.9 1.1-1.7 2.8-1.5 4.4 1.6.1 3.2-.8 4.2-2z"/><text x="47" y="19" font-family="-apple-system,system-ui,sans-serif" font-size="9" fill="rgba(255,255,255,.7)">Download on the</text><text x="47" y="33" font-family="-apple-system,system-ui,sans-serif" font-size="16" font-weight="600">App Store</text></g></svg></a><a href="https://play.google.com" target="_blank" class="store-badge"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 48" width="160" height="48"><rect width="160" height="48" rx="8" fill="#000"/><g><path d="M19.5 10.8l12.8 7.4-3.3 3.3L19.5 10.8z" fill="#36A852"/><path d="M16.1 10.1c-.3.3-.5.8-.5 1.4v25c0 .6.2 1.1.5 1.4l.1.1 14-14v-.3L16.1 10.1z" fill="#4285F4"/><path d="M32.3 28.5L29 25.2v-.3l3.3-3.3 4.3 2.4c1.2.7 1.2 1.8 0 2.5l-4.3 2z" fill="#FABB05"/><path d="M30.2 25.1L16.2 39c.9.9 2.3 1 3.6.3l14.5-8.3-4-6z" fill="#E94235"/><path d="M30.2 22.9l4.4-6L20 8.5c-1.3-.7-2.7-.6-3.6.3l13.8 14.1z" fill="#36A852"/></g><g fill="#fff"><text x="44" y="19" font-family="-apple-system,system-ui,sans-serif" font-size="9" fill="rgba(255,255,255,.7)">GET IT ON</text><text x="44" y="33" font-family="-apple-system,system-ui,sans-serif" font-size="16" font-weight="600">Google Play</text></g></svg></a></div></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F0F9FF}.sec-sky{background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:140px 0 40px;background:linear-gradient(135deg,#0C4A6E 0%,#0369A1 50%,#0EA5E9 100%);color:#fff}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.6);text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#7DD3FC}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto 32px;line-height:1.8}
.app-img-wrap{margin:0 auto 32px}.app-hero-img{max-width:320px;width:100%;border-radius:24px;box-shadow:0 24px 48px rgba(0,0,0,.3)}
.dl-row{display:flex;gap:16px;justify-content:center;flex-wrap:wrap;align-items:center}
.store-badge{display:inline-block;transition:all .25s;border-radius:8px;overflow:hidden;line-height:0}.store-badge:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.2)}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.g6{display:grid;grid-template-columns:repeat(6,1fr);gap:12px}
.sc-c{padding:28px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:18px;transition:all .3s}.sc-c:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(14,165,233,.08)}
.sc-ic{font-size:28px;display:block;margin-bottom:12px}.sc-t{font-size:14px;font-weight:800;margin-bottom:6px;color:#0C4A6E}.sc-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.75}
.spec-c{padding:20px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:14px;text-align:center}
.spec-l{font-size:11px;font-weight:700;color:#0EA5E9;margin-bottom:4px;text-transform:uppercase}.spec-v{font-size:22px;font-weight:900;color:#0C4A6E;margin-bottom:2px}.spec-d{font-size:11px;color:rgba(10,10,10,.3)}
.feat-grid{display:flex;flex-wrap:wrap;gap:10px;justify-content:center}
.feat-pill{font-size:13px;font-weight:600;color:#0C4A6E;background:rgba(14,165,233,.06);padding:10px 18px;border-radius:10px;border:1px solid rgba(14,165,233,.08)}
@media(max-width:768px){.g4{grid-template-columns:repeat(2,1fr)}.g6{grid-template-columns:repeat(3,1fr)}}
</style>
