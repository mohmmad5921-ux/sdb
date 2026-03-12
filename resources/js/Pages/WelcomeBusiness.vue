<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed, onMounted, onUnmounted } from 'vue';

const isAr = inject('isAr', computed(() => true));

/* ── Countdown ── */
const launchDate = new Date('2026-03-22T00:00:00');
const cd = ref({ d:0, h:0, m:0, s:0 });
let ti;
function tick(){const x=launchDate-new Date();if(x<=0)return;cd.value={d:Math.floor(x/864e5),h:Math.floor(x%864e5/36e5),m:Math.floor(x%36e5/6e4),s:Math.floor(x%6e4/1e3)}}

/* ── Waitlist ── */
const em = ref('');const done = ref(false);const emailErr = ref('');const submitting = ref(false);
async function submitEmail() {
  if(!em.value||!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(em.value)){emailErr.value=isAr.value?'أدخل بريد صحيح':'Enter a valid email';return}
  emailErr.value='';submitting.value=true;
  try{const r=await fetch('/waitlist',{method:'POST',headers:{'Content-Type':'application/json','Accept':'application/json','X-CSRF-TOKEN':document.querySelector('meta[name="csrf-token"]')?.content||''},body:JSON.stringify({email:em.value,source:'biz-hero'})});const d=await r.json();if(r.ok&&d.success){done.value=true}else{emailErr.value=isAr.value?'حدث خطأ':'Something went wrong'}}catch(e){emailErr.value=isAr.value?'خطأ بالاتصال':'Connection error'}
  submitting.value=false;
}

/* ── FAQ ── */
const faqOpen = ref(-1);
function toggleFaq(i){faqOpen.value=faqOpen.value===i?-1:i}

/* ── Scroll Animations ── */
let obs;
onMounted(()=>{
  tick();ti=setInterval(tick,1e3);
  obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting){x.target.classList.add('vi')}}),{threshold:.08,rootMargin:'0px 0px -40px 0px'});
  document.querySelectorAll('.bn').forEach(el=>obs.observe(el));
});
onUnmounted(()=>{clearInterval(ti);obs?.disconnect()});

/* ── Global currency (injected from SiteLayout) ── */
const userCurrency = inject('userCurrency', ref({code:'EUR',symbol:'€',flag:'🇪🇺',rate:1}));
const convertPrice = inject('convertPrice', v => v);

/* Dynamic pricing based on user currency */
function priceLabel(eurAmount) {
  const cc = userCurrency.value.code;
  const sym = userCurrency.value.symbol;
  if (cc === 'EUR') return '€' + eurAmount;
  return sym + convertPrice(eurAmount);
}
function periodLabel() {
  return isAr.value ? '/شهر' : '/mo';
}

/* ── i18n ── */
const t = computed(() => isAr.value ? {
  badge:'🏢 حلول مصرفية للشركات',
  h1a:'نت بنك متكامل',h1b:'لأعمالك',
  heroP:'نظام مصرفي متطور للشركات والمؤسسات. تحويلات دولية، محافظ متعددة العملات، وتقارير مالية متقدمة — كلها في لوحة تحكم واحدة.',
  cta1:'افتح حساب أعمال ←',cta2:'تسجيل الدخول',
  days:'يوم',hrs:'ساعة',min:'دقيقة',sec:'ثانية',
  emailPh:'بريد شركتك...',notify:'سجّل شركتك',emailDone:'✨ تم! سنتواصل معك قريباً.',
  whyTag:'لماذا SDB للأعمال',whyTitle:'كل ما تحتاجه شركتك',whySub:'منصة مصرفية احترافية صُممت خصيصاً لاحتياجات الشركات',
  feats:[
    {ic:'🖥️',t:'نت بنك متطور',d:'لوحة تحكم ويب شاملة لإدارة جميع العمليات المالية لشركتك بسهولة واحترافية.',highlights:['لوحة بيانات حية','إدارة الحسابات','تتبع المعاملات']},
    {ic:'👥',t:'إدارة الفريق',d:'أنشئ حسابات لموظفيك مع صلاحيات مخصصة. تحكم كامل بمن يصل لماذا.',highlights:['صلاحيات متعددة المستويات','سجل النشاطات','قفل وإلغاء فوري']},
    {ic:'💱',t:'محافظ متعددة العملات',d:'احتفظ بأرصدة في 30+ عملة وحوّل بينها فوراً بسعر الصرف الحقيقي.',highlights:['30+ عملة مدعومة','تحويل فوري','أسعار حية']},
    {ic:'🌐',t:'تحويلات SWIFT دولية',d:'أرسل واستقبل التحويلات الدولية إلى 170+ دولة بسرعة وأمان عبر شبكة SWIFT.',highlights:['170+ دولة','رسوم شفافة','تتبع مباشر']},
  ],
  dashTitle:'لوحة تحكم قوية',dashSub:'أدر كل شيء من مكان واحد',
  dashFeats:['تقارير مالية متقدمة','كشوفات حساب تفصيلية','تصدير PDF و Excel','رسوم بيانية تفاعلية','إشعارات فورية','API للربط مع أنظمتك'],
  pricingTag:'الباقات',pricingTitle:'اختر الباقة المناسبة لشركتك',
  plans:[
    {name:'أساسي',price:'مجاناً',period:'',desc:'للشركات الناشئة',feats:['حساب أعمال واحد','مستخدم واحد','تحويلات محلية','كشف حساب شهري','دعم عبر البريد'],cta:'ابدأ مجاناً',popular:false},
    {name:'احترافي',price:'€49',period:'/شهر',desc:'للشركات المتوسطة',feats:['3 حسابات أعمال','5 مستخدمين','تحويلات SWIFT','تقارير متقدمة','API كامل','دعم اولوية'],cta:'ابدأ تجربة مجانية',popular:true},
    {name:'مؤسسي',price:'مخصص',period:'',desc:'للمؤسسات الكبيرة',feats:['حسابات غير محدودة','مستخدمين غير محدودين','تحويلات بدون حدود','مدير حساب مخصص','SLA مضمون','تكامل مخصص'],cta:'تواصل معنا',popular:false},
  ],
  stepsTag:'كيف تبدأ',stepsTitle:'افتح حسابك في 4 خطوات',
  steps:[{n:'1',t:'سجّل شركتك',d:'أدخل بيانات الشركة والسجل التجاري.'},{n:'2',t:'تحقق من الهوية',d:'ارفع المستندات المطلوبة للتحقق.'},{n:'3',t:'فعّل الحساب',d:'بعد الموافقة، ابدأ باستخدام النت بنك.'},{n:'4',t:'ادعُ فريقك',d:'أضف المستخدمين وحدد الصلاحيات.'}],
  secTitle:'أمان على مستوى المؤسسات',secSub:'معايير أمان عالمية لحماية أموال شركتك',
  secItems:[{ic:'🔐',t:'تشفير AES-256'},{ic:'🛡️',t:'PCI DSS معتمد'},{ic:'✅',t:'ISO 27001'},{ic:'🏆',t:'SOC 2 Type II'},{ic:'📋',t:'GDPR متوافق'},{ic:'🌐',t:'شبكة SWIFT'}],
  faqTag:'أسئلة شائعة',faqTitle:'الأسئلة الأكثر تكراراً',
  faqs:[{q:'ما المتطلبات لفتح حساب أعمال؟',a:'السجل التجاري، إثبات هوية المسؤول، ونموذج فتح الحساب.'},{q:'كم يكلف حساب الأعمال؟',a:'الحساب الأساسي مجاني. الباقات المتقدمة تبدأ من €49/شهر.'},{q:'هل يمكن إضافة عدة مستخدمين؟',a:'نعم، مع صلاحيات مختلفة لكل مستخدم.'},{q:'هل يدعم API للربط مع أنظمتنا؟',a:'نعم، نوفر API RESTful كامل مع وثائق شاملة.'},{q:'ما هي العملات المدعومة؟',a:'ندعم 30+ عملة مع تحويل فوري بسعر الصرف الحقيقي.'}],
  ctaTitle:'ابدأ مع SDB Business',ctaSub:'افتح حساب أعمالك اليوم واحصل على نت بنك احترافي.',ctaBtn:'افتح حساب أعمال ←',ctaBtn2:'تحدث مع فريق المبيعات',
} : {
  badge:'🏢 Business Banking Solutions',
  h1a:'Complete Net Banking',h1b:'for your business',
  heroP:'Advanced banking for companies and institutions. International transfers, multi-currency wallets, and advanced financial reports — all in one dashboard.',
  cta1:'Open business account →',cta2:'Log in',
  days:'Days',hrs:'Hrs',min:'Min',sec:'Sec',
  emailPh:'Your company email...',notify:'Register your company',emailDone:'✨ Done! We\'ll be in touch soon.',
  whyTag:'WHY SDB BUSINESS',whyTitle:'Everything your company needs',whySub:'A professional banking platform built specifically for business needs',
  feats:[
    {ic:'🖥️',t:'Advanced Net Banking',d:'Comprehensive web dashboard to manage all financial operations for your company with ease and professionalism.',highlights:['Live dashboard','Account management','Transaction tracking']},
    {ic:'👥',t:'Team Management',d:'Create accounts for your employees with custom permissions. Full control over who accesses what.',highlights:['Multi-level permissions','Activity logs','Instant lock & revoke']},
    {ic:'💱',t:'Multi-Currency Wallets',d:'Hold balances in 30+ currencies and exchange between them instantly at the real exchange rate.',highlights:['30+ currencies','Instant exchange','Live rates']},
    {ic:'🌐',t:'International SWIFT Transfers',d:'Send and receive international transfers to 170+ countries quickly and securely via the SWIFT network.',highlights:['170+ countries','Transparent fees','Live tracking']},
  ],
  dashTitle:'Powerful Dashboard',dashSub:'Manage everything from one place',
  dashFeats:['Advanced financial reports','Detailed account statements','PDF & Excel export','Interactive charts','Real-time notifications','API integration'],
  pricingTag:'PRICING',pricingTitle:'Choose the right plan for your business',
  plans:[
    {name:'Starter',price:'Free',period:'',desc:'For startups',feats:['1 business account','1 user','Local transfers','Monthly statement','Email support'],cta:'Start for free',popular:false},
    {name:'Professional',price:'€49',period:'/mo',desc:'For growing businesses',feats:['3 business accounts','5 users','SWIFT transfers','Advanced reports','Full API','Priority support'],cta:'Start free trial',popular:true},
    {name:'Enterprise',price:'Custom',period:'',desc:'For large institutions',feats:['Unlimited accounts','Unlimited users','Unlimited transfers','Dedicated manager','Guaranteed SLA','Custom integration'],cta:'Contact us',popular:false},
  ],
  stepsTag:'HOW TO START',stepsTitle:'Open your account in 4 steps',
  steps:[{n:'1',t:'Register your company',d:'Enter company details and trade license.'},{n:'2',t:'Verify identity',d:'Upload required documents for verification.'},{n:'3',t:'Activate account',d:'After approval, start using the net bank.'},{n:'4',t:'Invite your team',d:'Add users and set permissions.'}],
  secTitle:'Enterprise-grade Security',secSub:'Global security standards to protect your company\'s money',
  secItems:[{ic:'🔐',t:'AES-256 Encryption'},{ic:'🛡️',t:'PCI DSS Certified'},{ic:'✅',t:'ISO 27001'},{ic:'🏆',t:'SOC 2 Type II'},{ic:'📋',t:'GDPR Compliant'},{ic:'🌐',t:'SWIFT Network'}],
  faqTag:'FAQ',faqTitle:'Frequently Asked Questions',
  faqs:[{q:'What are the requirements for a business account?',a:'Trade license, responsible person ID, and account opening form.'},{q:'How much does a business account cost?',a:'The starter account is free. Advanced plans start from €49/month.'},{q:'Can I add multiple users?',a:'Yes, with different permissions for each user.'},{q:'Does it support API integration?',a:'Yes, we provide a full RESTful API with comprehensive documentation.'},{q:'Which currencies are supported?',a:'We support 30+ currencies with instant exchange at the real rate.'}],
  ctaTitle:'Start with SDB Business',ctaSub:'Open your business account today and get professional net banking.',ctaBtn:'Open business account →',ctaBtn2:'Talk to sales',
});
</script>

<template>
<Head :title="isAr?'SDB Business — حلول مصرفية للشركات':'SDB Business — Corporate Banking Solutions'"/>

<!-- ═══ HERO ═══ -->
<section class="bz-hero">
  <div class="bz-hero-deco1"></div>
  <div class="bz-hero-deco2"></div>
  <div class="bz-sw bz-hero-inner">
    <div class="bz-hero-content bn">
      <div class="bz-badge">{{ t.badge }}</div>
      <h1 class="bz-h1">{{ t.h1a }}<br><span class="bz-h1-em">{{ t.h1b }}</span></h1>
      <p class="bz-hero-p">{{ t.heroP }}</p>
      <div class="bz-hero-actions">
        <Link href="/preregister?type=business" class="bz-btn-primary">{{ t.cta1 }}</Link>
        <Link href="/login" class="bz-btn-outline">{{ t.cta2 }}</Link>
      </div>
      <div class="bz-hero-cd bn">
        <div v-for="(lb,k) in {d:t.days,h:t.hrs,m:t.min,s:t.sec}" :key="k" class="bz-cd-box">
          <div class="bz-cd-n">{{ String(cd[k]).padStart(2,'0') }}</div>
          <div class="bz-cd-l">{{ lb }}</div>
        </div>
      </div>
    </div>
    <div class="bz-hero-visual bn">
      <div class="bz-dash-mock">
        <div class="bz-dash-header">
          <div class="bz-dash-dots"><span></span><span></span><span></span></div>
          <span class="bz-dash-url">sdb-bank.com/business/dashboard</span>
        </div>
        <div class="bz-dash-body">
          <div class="bz-dash-sidebar">
            <div class="bz-dash-nav-item active">📊 Dashboard</div>
            <div class="bz-dash-nav-item">💱 Transfers</div>
            <div class="bz-dash-nav-item">👥 Team</div>
            <div class="bz-dash-nav-item">📋 Reports</div>
            <div class="bz-dash-nav-item">⚙️ Settings</div>
          </div>
          <div class="bz-dash-main">
            <div class="bz-dash-stat-row">
              <div class="bz-dash-stat"><div class="bz-ds-label">{{ isAr?'الرصيد الكلي':'Total Balance' }}</div><div class="bz-ds-value">$124,580</div></div>
              <div class="bz-dash-stat"><div class="bz-ds-label">{{ isAr?'هذا الشهر':'This Month' }}</div><div class="bz-ds-value">$42,350</div></div>
              <div class="bz-dash-stat"><div class="bz-ds-label">{{ isAr?'المعاملات':'Transactions' }}</div><div class="bz-ds-value">156</div></div>
            </div>
            <div class="bz-dash-chart">
              <div v-for="h in [40,65,45,80,55,90,70,85,60,75,95,50]" :key="h" class="bz-bar" :style="{height:h+'%'}"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ═══ FEATURES ═══ -->
<section class="bz-sec">
  <div class="bz-sw">
    <div class="bz-sec-hdr bn">
      <span class="bz-pill">{{ t.whyTag }}</span>
      <h2 class="bz-t2">{{ t.whyTitle }}</h2>
      <p class="bz-t2-sub">{{ t.whySub }}</p>
    </div>
    <div class="bz-feats-grid">
      <div v-for="(f,i) in t.feats" :key="i" class="bz-feat-card bn">
        <div class="bz-feat-ic">{{ f.ic }}</div>
        <h3 class="bz-feat-t">{{ f.t }}</h3>
        <p class="bz-feat-d">{{ f.d }}</p>
        <div class="bz-feat-hl">
          <span v-for="h in f.highlights" :key="h" class="bz-hl-item">✓ {{ h }}</span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ═══ DASHBOARD PREVIEW ═══ -->
<section class="bz-sec bz-sec-tinted">
  <div class="bz-sw">
    <div class="bz-sec-hdr bn">
      <h2 class="bz-t2">{{ t.dashTitle }}</h2>
      <p class="bz-t2-sub">{{ t.dashSub }}</p>
    </div>
    <div class="bz-dash-features bn">
      <div v-for="(f,i) in t.dashFeats" :key="i" class="bz-dash-feat-item">
        <span class="bz-dash-feat-check">✓</span>
        <span>{{ f }}</span>
      </div>
    </div>
  </div>
</section>

<!-- ═══ PRICING ═══ -->
<section class="bz-sec">
  <div class="bz-sw">
    <div class="bz-sec-hdr bn">
      <span class="bz-pill">{{ t.pricingTag }}</span>
      <h2 class="bz-t2">{{ t.pricingTitle }}</h2>
    </div>
    <div class="bz-pricing-grid">
      <div v-for="(p,i) in t.plans" :key="i" class="bz-plan-card bn" :class="{popular:p.popular}">
        <div v-if="p.popular" class="bz-popular-tag">{{ isAr?'الأكثر طلباً':'Most Popular' }}</div>
        <h3 class="bz-plan-name">{{ p.name }}</h3>
        <p class="bz-plan-desc">{{ p.desc }}</p>
        <div class="bz-plan-price">{{ p.price }}<span v-if="p.period" class="bz-plan-period">{{ p.period }}</span></div>
        <ul class="bz-plan-feats">
          <li v-for="f in p.feats" :key="f">✓ {{ f }}</li>
        </ul>
        <Link href="/preregister?type=business" class="bz-plan-cta" :class="{primary:p.popular}">{{ p.cta }}</Link>
      </div>
    </div>
  </div>
</section>

<!-- ═══ STEPS ═══ -->
<section class="bz-sec bz-sec-tinted">
  <div class="bz-sw">
    <div class="bz-sec-hdr bn">
      <span class="bz-pill">{{ t.stepsTag }}</span>
      <h2 class="bz-t2">{{ t.stepsTitle }}</h2>
    </div>
    <div class="bz-steps-row">
      <div v-for="(s,i) in t.steps" :key="i" class="bz-step bn">
        <div class="bz-step-n">{{ s.n }}</div>
        <h3 class="bz-step-t">{{ s.t }}</h3>
        <p class="bz-step-d">{{ s.d }}</p>
      </div>
    </div>
  </div>
</section>

<!-- ═══ SECURITY ═══ -->
<section class="bz-sec">
  <div class="bz-sw">
    <div class="bz-sec-hdr bn">
      <h2 class="bz-t2">{{ t.secTitle }}</h2>
      <p class="bz-t2-sub">{{ t.secSub }}</p>
    </div>
    <div class="bz-sec-badges bn">
      <div v-for="s in t.secItems" :key="s.t" class="bz-sec-badge">
        <span class="bz-sec-ic">{{ s.ic }}</span>
        <span class="bz-sec-name">{{ s.t }}</span>
      </div>
    </div>
  </div>
</section>

<!-- ═══ FAQ ═══ -->
<section class="bz-sec bz-sec-tinted">
  <div class="bz-sw" style="max-width:720px">
    <div class="bz-sec-hdr bn">
      <span class="bz-pill">{{ t.faqTag }}</span>
      <h2 class="bz-t2">{{ t.faqTitle }}</h2>
    </div>
    <div class="bz-faq-list">
      <div v-for="(f,i) in t.faqs" :key="i" class="bz-faq-item bn" :class="{open:faqOpen===i}" @click="toggleFaq(i)">
        <div class="bz-faq-q">{{ f.q }}<span class="bz-faq-arrow">{{ faqOpen===i?'−':'+' }}</span></div>
        <div v-if="faqOpen===i" class="bz-faq-a">{{ f.a }}</div>
      </div>
    </div>
  </div>
</section>

<!-- ═══ CTA ═══ -->
<section class="bz-cta-sec">
  <div class="bz-cta-glow"></div>
  <div class="bz-sw bz-cta-inner bn">
    <h2 class="bz-cta-title">{{ t.ctaTitle }}</h2>
    <p class="bz-cta-sub">{{ t.ctaSub }}</p>
    <div class="bz-cta-actions">
      <Link href="/preregister?type=business" class="bz-btn-primary bz-btn-lg">{{ t.ctaBtn }}</Link>
      <Link href="/contact" class="bz-btn-outline-dark bz-btn-lg">{{ t.ctaBtn2 }}</Link>
    </div>
    <div class="bz-cta-email">
      <template v-if="!done">
        <input v-model="em" type="email" :placeholder="t.emailPh" class="bz-eml-i" @keyup.enter="submitEmail"/>
        <button @click="submitEmail" class="bz-eml-b" :disabled="submitting">{{ t.notify }}</button>
      </template>
      <div v-else class="bz-eml-ok">{{ t.emailDone }}</div>
      <div v-if="emailErr" class="bz-eml-err">{{ emailErr }}</div>
    </div>
  </div>
</section>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap');
*{box-sizing:border-box}

/* ─── Animation ─── */
.bn{opacity:0;transform:translateY(24px);transition:all .7s cubic-bezier(.16,1,.3,1)}
.bn.vi{opacity:1;transform:translateY(0)}

/* ─── Layout ─── */
.bz-sw{max-width:1200px;margin:0 auto;padding:0 24px;width:100%}

/* ═══ HERO — Light gradient ═══ */
.bz-hero{position:relative;background:linear-gradient(165deg,#f0fbe4 0%,#e8f5d8 30%,#fff 70%);overflow:hidden;padding:140px 0 80px}
.bz-hero-deco1{position:absolute;width:500px;height:500px;background:radial-gradient(circle,rgba(159,232,112,.18),transparent 70%);top:-100px;right:-100px;border-radius:50%;pointer-events:none}
.bz-hero-deco2{position:absolute;width:400px;height:400px;background:radial-gradient(circle,rgba(45,106,0,.06),transparent 70%);bottom:-80px;left:-80px;border-radius:50%;pointer-events:none}
.bz-hero-inner{position:relative;display:flex;align-items:center;gap:60px}
.bz-hero-content{flex:1}
.bz-badge{display:inline-block;padding:8px 20px;background:rgba(45,106,0,.06);border:1px solid rgba(45,106,0,.12);color:#2D6A00;font-size:13px;font-weight:700;border-radius:100px;margin-bottom:24px;letter-spacing:.5px}
.bz-h1{font-size:52px;font-weight:900;color:#163300;line-height:1.1;letter-spacing:-.03em}
.bz-h1-em{color:#2D6A00;background:linear-gradient(135deg,#2D6A00,#4a9e1c);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.bz-hero-p{font-size:17px;color:#5a6b4e;line-height:1.8;margin-top:20px;max-width:520px}
.bz-hero-actions{display:flex;gap:14px;margin-top:32px}
.bz-btn-primary{display:inline-flex;align-items:center;padding:16px 32px;background:linear-gradient(135deg,#2D6A00,#3d8a10);color:#fff;font-size:15px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .25s;border:none;cursor:pointer;font-family:inherit;box-shadow:0 4px 16px rgba(45,106,0,.2)}
.bz-btn-primary:hover{transform:translateY(-2px);box-shadow:0 8px 32px rgba(45,106,0,.3)}
.bz-btn-outline{display:inline-flex;align-items:center;padding:16px 32px;background:transparent;color:#2D6A00;font-size:15px;font-weight:700;border-radius:14px;text-decoration:none;border:2px solid rgba(45,106,0,.2);transition:all .25s}
.bz-btn-outline:hover{border-color:#2D6A00;background:rgba(45,106,0,.03)}
.bz-btn-outline-dark{display:inline-flex;align-items:center;padding:16px 32px;background:transparent;color:#2D6A00;font-size:15px;font-weight:700;border-radius:14px;text-decoration:none;border:2px solid rgba(45,106,0,.2);transition:all .25s}
.bz-btn-outline-dark:hover{border-color:#2D6A00;background:rgba(45,106,0,.04)}
.bz-btn-lg{padding:18px 40px;font-size:16px}
.bz-hero-cd{display:flex;gap:12px;margin-top:28px}
.bz-cd-box{text-align:center;background:#fff;border:1px solid rgba(45,106,0,.08);border-radius:12px;padding:10px 16px;min-width:64px;box-shadow:0 2px 8px rgba(0,0,0,.04)}
.bz-cd-n{font-size:22px;font-weight:900;color:#2D6A00}
.bz-cd-l{font-size:10px;color:#8a9a7e;text-transform:uppercase;margin-top:2px}

/* Dashboard Mock — Light theme */
.bz-hero-visual{flex:1;max-width:540px}
.bz-dash-mock{background:#fff;border-radius:16px;overflow:hidden;border:1px solid rgba(0,0,0,.08);box-shadow:0 24px 48px rgba(0,0,0,.08),0 4px 12px rgba(0,0,0,.04)}
.bz-dash-header{display:flex;align-items:center;gap:12px;padding:12px 16px;background:#fafbf8;border-bottom:1px solid rgba(0,0,0,.05)}
.bz-dash-dots span{width:10px;height:10px;border-radius:50%;display:inline-block;margin-right:6px}
.bz-dash-dots span:nth-child(1){background:#ff5f57}
.bz-dash-dots span:nth-child(2){background:#febc2e}
.bz-dash-dots span:nth-child(3){background:#28c840}
.bz-dash-url{font-size:11px;color:#999;font-family:'SF Mono',monospace}
.bz-dash-body{display:flex;min-height:280px}
.bz-dash-sidebar{width:140px;background:#fafbf8;border-right:1px solid rgba(0,0,0,.04);padding:12px 0}
.bz-dash-nav-item{padding:10px 16px;font-size:12px;color:#999;cursor:default;transition:all .2s}
.bz-dash-nav-item.active{color:#2D6A00;background:rgba(45,106,0,.05);border-right:2px solid #2D6A00;font-weight:600}
.bz-dash-main{flex:1;padding:16px;background:#fff}
.bz-dash-stat-row{display:flex;gap:10px;margin-bottom:16px}
.bz-dash-stat{flex:1;background:#f8faf5;border:1px solid rgba(45,106,0,.06);border-radius:10px;padding:10px 12px}
.bz-ds-label{font-size:9px;color:#8a9a7e;text-transform:uppercase;letter-spacing:.5px}
.bz-ds-value{font-size:16px;font-weight:800;color:#163300;margin-top:4px}
.bz-dash-chart{display:flex;align-items:flex-end;gap:6px;height:100px;padding-top:12px}
.bz-bar{flex:1;background:linear-gradient(to top,rgba(45,106,0,.2),rgba(45,106,0,.5));border-radius:4px 4px 0 0;animation:barGrow 1.2s ease-out forwards;transform-origin:bottom}
@keyframes barGrow{from{transform:scaleY(0)}to{transform:scaleY(1)}}

/* ═══ SECTIONS ═══ */
.bz-sec{padding:100px 0;background:#fff}
.bz-sec-tinted{background:#f8faf5}
.bz-sec-hdr{text-align:center;margin-bottom:60px}
.bz-pill{display:inline-block;padding:6px 18px;background:rgba(45,106,0,.06);border:1px solid rgba(45,106,0,.1);color:#2D6A00;font-size:12px;font-weight:800;border-radius:100px;margin-bottom:16px;letter-spacing:1px;text-transform:uppercase}
.bz-t2{font-size:40px;font-weight:900;color:#163300;letter-spacing:-.03em;line-height:1.15}
.bz-t2-sub{font-size:16px;color:#6b7c60;margin-top:12px;max-width:540px;margin-left:auto;margin-right:auto;line-height:1.7}

/* Features */
.bz-feats-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:20px}
.bz-feat-card{background:#fff;border:1px solid rgba(0,0,0,.06);border-radius:20px;padding:36px 32px;transition:all .3s;box-shadow:0 2px 8px rgba(0,0,0,.02)}
.bz-feat-card:hover{border-color:rgba(45,106,0,.15);box-shadow:0 12px 32px rgba(45,106,0,.06);transform:translateY(-4px)}
.bz-feat-ic{font-size:36px;margin-bottom:16px}
.bz-feat-t{font-size:20px;font-weight:800;color:#163300;margin-bottom:10px}
.bz-feat-d{font-size:14px;color:#6b7c60;line-height:1.7;margin-bottom:16px}
.bz-feat-hl{display:flex;flex-wrap:wrap;gap:8px}
.bz-hl-item{font-size:12px;color:#2D6A00;background:rgba(45,106,0,.05);padding:4px 12px;border-radius:8px;font-weight:600}

/* Dashboard features */
.bz-dash-features{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.bz-dash-feat-item{display:flex;align-items:center;gap:12px;padding:20px 24px;background:#fff;border:1px solid rgba(0,0,0,.06);border-radius:14px;font-size:15px;font-weight:600;color:#163300;transition:all .2s;box-shadow:0 2px 8px rgba(0,0,0,.02)}
.bz-dash-feat-item:hover{border-color:rgba(45,106,0,.15);transform:translateY(-2px);box-shadow:0 8px 24px rgba(45,106,0,.06)}
.bz-dash-feat-check{width:24px;height:24px;background:#2D6A00;color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:900;flex-shrink:0}

/* Pricing */
.bz-pricing-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;align-items:start}
.bz-plan-card{background:#fff;border:1px solid rgba(0,0,0,.06);border-radius:24px;padding:40px 32px;text-align:center;position:relative;transition:all .3s;box-shadow:0 2px 8px rgba(0,0,0,.02)}
.bz-plan-card.popular{border-color:#2D6A00;box-shadow:0 12px 40px rgba(45,106,0,.1);transform:scale(1.02)}
.bz-plan-card:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(0,0,0,.06)}
.bz-plan-card.popular:hover{transform:scale(1.02) translateY(-4px)}
.bz-popular-tag{position:absolute;top:-12px;left:50%;transform:translateX(-50%);background:#2D6A00;color:#fff;font-size:11px;font-weight:800;padding:5px 16px;border-radius:100px;white-space:nowrap}
.bz-plan-name{font-size:22px;font-weight:800;color:#163300;margin-bottom:4px}
.bz-plan-desc{font-size:13px;color:#8a9a7e;margin-bottom:20px}
.bz-plan-price{font-size:44px;font-weight:900;color:#2D6A00;margin-bottom:24px}
.bz-plan-period{font-size:16px;font-weight:500;color:#8a9a7e}
.bz-plan-local{font-size:14px;color:#2D6A00;font-weight:600;margin-top:-16px;margin-bottom:16px;opacity:.7}
.bz-plan-feats{list-style:none;padding:0;text-align:start;margin-bottom:28px}
.bz-plan-feats li{padding:10px 0;border-bottom:1px solid rgba(0,0,0,.04);font-size:14px;color:#5a6b4e}
.bz-plan-cta{display:block;padding:14px;background:rgba(45,106,0,.04);border:1px solid rgba(45,106,0,.12);color:#2D6A00;font-size:14px;font-weight:700;border-radius:12px;text-decoration:none;text-align:center;transition:all .2s}
.bz-plan-cta.primary{background:linear-gradient(135deg,#2D6A00,#3d8a10);color:#fff;border:none;box-shadow:0 4px 16px rgba(45,106,0,.2)}
.bz-plan-cta:hover{transform:translateY(-2px)}

/* Steps */
.bz-steps-row{display:grid;grid-template-columns:repeat(4,1fr);gap:20px}
.bz-step{text-align:center;padding:32px 20px}
.bz-step-n{width:48px;height:48px;background:linear-gradient(135deg,#2D6A00,#3d8a10);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:900;margin:0 auto 16px;box-shadow:0 4px 12px rgba(45,106,0,.15)}
.bz-step-t{font-size:16px;font-weight:800;color:#163300;margin-bottom:8px}
.bz-step-d{font-size:13px;color:#6b7c60;line-height:1.6}

/* Security */
.bz-sec-badges{display:grid;grid-template-columns:repeat(6,1fr);gap:16px}
.bz-sec-badge{display:flex;flex-direction:column;align-items:center;gap:10px;padding:28px 16px;background:#fff;border:1px solid rgba(0,0,0,.06);border-radius:16px;transition:all .2s;box-shadow:0 2px 8px rgba(0,0,0,.02)}
.bz-sec-badge:hover{border-color:rgba(45,106,0,.15);box-shadow:0 8px 24px rgba(45,106,0,.06)}
.bz-sec-ic{font-size:28px}
.bz-sec-name{font-size:12px;font-weight:800;color:#5a6b4e;text-align:center}

/* FAQ */
.bz-faq-list{display:flex;flex-direction:column;gap:10px}
.bz-faq-item{background:#fff;border:1px solid rgba(0,0,0,.06);border-radius:14px;padding:20px 24px;cursor:pointer;transition:all .2s;box-shadow:0 2px 8px rgba(0,0,0,.02)}
.bz-faq-item:hover{border-color:rgba(45,106,0,.15)}
.bz-faq-item.open{border-color:#2D6A00;background:rgba(45,106,0,.02)}
.bz-faq-q{display:flex;justify-content:space-between;align-items:center;font-size:15px;font-weight:700;color:#163300}
.bz-faq-arrow{font-size:20px;color:#2D6A00;font-weight:300}
.bz-faq-a{margin-top:12px;font-size:14px;color:#6b7c60;line-height:1.7;padding-top:12px;border-top:1px solid rgba(0,0,0,.04)}

/* CTA */
.bz-cta-sec{position:relative;background:linear-gradient(165deg,#f0fbe4,#e8f5d8,#dff0cc);padding:100px 0;overflow:hidden}
.bz-cta-glow{position:absolute;width:600px;height:600px;background:radial-gradient(circle,rgba(45,106,0,.08),transparent);top:50%;left:50%;transform:translate(-50%,-50%);border-radius:50%;pointer-events:none}
.bz-cta-inner{position:relative;text-align:center}
.bz-cta-title{font-size:44px;font-weight:900;color:#163300;letter-spacing:-.03em}
.bz-cta-sub{font-size:17px;color:#5a6b4e;margin-top:12px;margin-bottom:32px;line-height:1.7}
.bz-cta-actions{display:flex;gap:14px;justify-content:center;margin-bottom:32px}
.bz-cta-email{max-width:420px;margin:0 auto;display:flex;gap:8px}
.bz-eml-i{flex:1;padding:14px 20px;background:#fff;border:1px solid rgba(45,106,0,.12);border-radius:12px;color:#163300;font-size:14px;outline:none;font-family:inherit;box-shadow:0 2px 8px rgba(0,0,0,.04)}
.bz-eml-i:focus{border-color:#2D6A00;box-shadow:0 0 0 3px rgba(45,106,0,.08)}
.bz-eml-i::placeholder{color:#aab8a0}
.bz-eml-b{padding:14px 24px;background:linear-gradient(135deg,#2D6A00,#3d8a10);color:#fff;border:none;border-radius:12px;font-size:14px;font-weight:800;cursor:pointer;font-family:inherit;transition:all .2s;white-space:nowrap;box-shadow:0 4px 12px rgba(45,106,0,.2)}
.bz-eml-b:hover{box-shadow:0 8px 24px rgba(45,106,0,.3);transform:translateY(-1px)}
.bz-eml-ok{color:#2D6A00;font-size:15px;font-weight:700;text-align:center;width:100%}
.bz-eml-err{color:#dc2626;font-size:12px;margin-top:8px;text-align:center}

/* ─── Responsive ─── */
@media(max-width:900px){
  .bz-hero-inner{flex-direction:column;text-align:center}
  .bz-hero-content{order:1}
  .bz-hero-visual{order:2;max-width:100%}
  .bz-hero-actions{justify-content:center}
  .bz-hero-cd{justify-content:center}
  .bz-hero-p{margin-left:auto;margin-right:auto}
  .bz-h1{font-size:36px}
  .bz-feats-grid{grid-template-columns:1fr}
  .bz-pricing-grid{grid-template-columns:1fr}
  .bz-plan-card.popular{transform:none}
  .bz-steps-row{grid-template-columns:repeat(2,1fr)}
  .bz-dash-features{grid-template-columns:1fr}
  .bz-sec-badges{grid-template-columns:repeat(3,1fr)}
  .bz-t2{font-size:30px}
  .bz-cta-title{font-size:30px}
  .bz-cta-email{flex-direction:column}
  .bz-dash-mock{display:none}
}
@media(max-width:600px){
  .bz-hero{padding:120px 0 60px}
  .bz-sec{padding:60px 0}
  .bz-h1{font-size:28px}
  .bz-steps-row{grid-template-columns:1fr}
  .bz-sec-badges{grid-template-columns:repeat(2,1fr)}
  .bz-hero-actions{flex-direction:column;align-items:center}
}
</style>
