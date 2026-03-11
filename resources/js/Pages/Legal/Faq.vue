<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed, onMounted } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
let obs;
onMounted(()=>{obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.08});document.querySelectorAll('.an').forEach(el=>obs.observe(el))});

const openFaq = ref(null);
const search = ref('');
const toggle = (i) => openFaq.value = openFaq.value === i ? null : i;

const t = computed(() => isAr.value ? {
  title:'الأسئلة الشائعة — SDB Bank',tag:'الأسئلة الشائعة',heroH:'كيف نقدر نساعدك؟',heroP:'ابحث عن سؤالك أو تصفّح الأقسام.',searchPh:'ابحث عن سؤالك...',noResult:'ما لقينا نتائج. جرّب كلمات ثانية.',
  ctaH:'ما لقيت جوابك؟',ctaP:'فريق الدعم متاح 24/7',ctaBtn1:'📧 راسلنا',ctaBtn2:'🎧 دعم مباشر',
  faqs:[
    {cat:'🏦 الحسابات',items:[
      {q:'كيف أفتح حساب مع SDB؟',a:'يمكنك فتح حساب خلال دقائق بالتسجيل على الموقع أو التطبيق. تحتاج لبياناتك الشخصية وهوية سارية، ثم التحقق من الهوية (KYC).'},
      {q:'ما المستندات المطلوبة لفتح حساب؟',a:'تحتاج جواز سفر أو هوية وطنية سارية، + إثبات عنوان حديث (كشف حساب بنكي، فاتورة خدمات، أو عقد إيجار خلال آخر 3 أشهر).'},
      {q:'هل يمكن فتح أكثر من حساب؟',a:'نعم! يمكنك فتح حسابات بعملات مختلفة. كل حساب يحصل على IBAN فريد ورقم حساب داخلي مكوّن من 10 أرقام.'},
    ]},
    {cat:'💳 البطاقات',items:[
      {q:'كيف أحصل على بطاقة ماستركارد SDB؟',a:'يمكنك إصدار بطاقة افتراضية فوراً من لوحة التحكم. البطاقة الافتراضية تعمل للشراء عبر الإنترنت و Apple Pay / Google Pay. البطاقات الفعلية تُشحن خلال 5-7 أيام عمل.'},
      {q:'كيف أجمّد بطاقتي؟',a:'يمكنك تجميد بطاقتك فوراً من التطبيق بنقرة واحدة. التجميد يمنع جميع المعاملات ويمكنك إلغاء التجميد بسهولة.'},
      {q:'ما حدود البطاقة؟',a:'الحدود تختلف حسب الخطة. الحد اليومي الأساسي €5,000 والشهري €25,000. يمكنك تعديل الحدود من صفحة إدارة البطاقات.'},
    ]},
    {cat:'💸 التحويلات',items:[
      {q:'كم تستغرق التحويلات؟',a:'التحويلات الداخلية بين حسابات SDB فورية ومجانية. التحويلات الخارجية (SWIFT) تستغرق 1-3 أيام عمل.'},
      {q:'هل التحويلات مجانية؟',a:'التحويلات الداخلية مجانية تماماً. التحويلات الخارجية تبدأ من €2 حسب الوجهة والعملة.'},
      {q:'كيف أحوّل عملات؟',a:'من لوحة التحكم، اختر "صرف"، حدد الحساب المصدر والهدف (بعملة مختلفة)، أدخل المبلغ وسيتم التنفيذ بأسعار السوق الحقيقية.'},
    ]},
    {cat:'💰 الإيداعات',items:[
      {q:'كيف أودع المال في حسابي؟',a:'يمكنك الإيداع عبر: بطاقة فيزا/ماستركارد خارجية، Apple Pay، أو Google Pay. الحد الأقصى للإيداع الواحد €50,000.'},
      {q:'ما رسوم الإيداع؟',a:'رسوم الإيداع 1.5% من المبلغ + €0.50 رسم ثابت. مثال: إيداع €100 = €2 رسوم، €98 يُضاف لحسابك.'},
    ]},
    {cat:'🔒 الأمان',items:[
      {q:'كيف يحمي SDB أموالي؟',a:'نستخدم تشفير TLS 256-بت، مصادقة ثنائية (2FA)، مراقبة أمنية 24/7، وكشف احتيال بالذكاء الاصطناعي.'},
      {q:'ماذا أفعل إذا فقدت هاتفي؟',a:'تواصل مع الدعم فوراً 24/7 لتجميد حسابك وبطاقاتك. يمكنك أيضاً تسجيل الدخول من جهاز آخر وتجميد بطاقاتك بنفسك.'},
      {q:'ما هو KYC ولماذا مطلوب؟',a:'KYC (اعرف عميلك) هو إجراء تنظيمي إلزامي للتحقق من هوية العميل. يتضمن تقديم هوية وإثبات عنوان. هذا يحمي حسابك ويساعد في مكافحة غسيل الأموال.'},
    ]},
    {cat:'🎧 الدعم',items:[
      {q:'كيف أتواصل مع الدعم؟',a:'يمكنك الوصول إلينا عبر: دعم مباشر داخل التطبيق (24/7)، إيميل support@sdb-bank.com، أو هاتف +45 42 80 55 94.'},
      {q:'كم يستغرق الرد على التذاكر؟',a:'نهدف للرد خلال 4 ساعات كحد أقصى. الأمور العاجلة (مثل الاحتيال) تُعالج فوراً.'},
    ]},
  ],
} : {
  title:'FAQ — SDB Bank',tag:'FAQ',heroH:'How can we help you?',heroP:'Search your question or browse categories.',searchPh:'Search your question...',noResult:'No results found. Try different keywords.',
  ctaH:'Didn\'t find your answer?',ctaP:'Our support team is available 24/7',ctaBtn1:'📧 Email us',ctaBtn2:'🎧 Live Support',
  faqs:[
    {cat:'🏦 Accounts',items:[
      {q:'How do I open an account with SDB?',a:'You can open an account in minutes by registering on the website or app. You\'ll need your personal details and a valid ID, then complete identity verification (KYC).'},
      {q:'What documents are required?',a:'A valid passport or national ID, plus a recent proof of address (bank statement, utility bill, or rental contract within the last 3 months).'},
      {q:'Can I open more than one account?',a:'Yes! You can open accounts in different currencies. Each account gets a unique IBAN and 10-digit internal account number.'},
    ]},
    {cat:'💳 Cards',items:[
      {q:'How do I get an SDB Mastercard?',a:'Issue a virtual card instantly from the dashboard. Physical cards ship in 5-7 business days.'},
      {q:'How do I freeze my card?',a:'Freeze instantly from the app with one tap. Freezing prevents all transactions and you can unfreeze just as easily.'},
      {q:'What are the card limits?',a:'Limits vary by plan. Basic daily limit is €5,000 and monthly €25,000. Adjustable from card management.'},
    ]},
    {cat:'💸 Transfers',items:[
      {q:'How long do transfers take?',a:'Internal SDB transfers are instant and free. External (SWIFT) transfers take 1-3 business days.'},
      {q:'Are there fees?',a:'Internal transfers are free. External transfers start from €2 depending on destination and currency.'},
      {q:'How do I exchange currencies?',a:'From the dashboard, select "Exchange", choose source and target accounts, enter the amount — executed at live market rates.'},
    ]},
    {cat:'💰 Deposits',items:[
      {q:'How do I deposit money?',a:'Via external Visa/Mastercard, Apple Pay, or Google Pay. Maximum single deposit is €50,000.'},
      {q:'What are the deposit fees?',a:'1.5% of the amount + €0.50 fixed fee. Example: depositing €100 = €2 in fees, €98 credited.'},
    ]},
    {cat:'🔒 Security',items:[
      {q:'How does SDB protect my money?',a:'TLS 256-bit encryption, 2FA, 24/7 security monitoring, and AI-powered fraud detection.'},
      {q:'What if I lose my phone?',a:'Contact support 24/7 immediately to freeze your account and cards. You can also log in from another device.'},
      {q:'What is KYC?',a:'KYC (Know Your Customer) is mandatory identity verification. It involves providing an ID and proof of address. Protects against fraud.'},
    ]},
    {cat:'🎧 Support',items:[
      {q:'How do I contact support?',a:'In-app live support (24/7), email support@sdb-bank.com, or phone +45 42 80 55 94.'},
      {q:'How long for ticket responses?',a:'We aim to respond within 4 hours maximum. Urgent matters are processed immediately.'},
    ]},
  ],
});

let faqIndex = 0;
const indexedFaqs = computed(() => {
  let idx = 0;
  return t.value.faqs.map(cat => ({...cat, items: cat.items.map(item => ({...item, index: idx++}))}));
});

const filteredFaqs = computed(() => {
  if(!search.value.trim()) return indexedFaqs.value;
  const q = search.value.toLowerCase();
  return indexedFaqs.value.map(cat => ({
    ...cat,
    items: cat.items.filter(i => i.q.toLowerCase().includes(q) || i.a.toLowerCase().includes(q))
  })).filter(cat => cat.items.length > 0);
});
</script>
<template>
<Head :title="t.title"/>
<section class="hero"><div class="sw tc">
  <div class="hero-tag an">{{ t.tag }}</div>
  <h1 class="hero-h an">{{ t.heroH }}</h1>
  <p class="hero-p an">{{ t.heroP }}</p>
  <div class="search-wrap an"><input v-model="search" :placeholder="t.searchPh" class="search-input" /><span class="search-ic">🔍</span></div>
</div></section>

<section class="sec"><div class="sw">
  <div v-if="filteredFaqs.length === 0" class="no-result an">{{ t.noResult }}</div>
  <div v-for="cat in filteredFaqs" :key="cat.cat" class="faq-cat an">
    <h2 class="cat-h">{{ cat.cat }}</h2>
    <div class="faq-list">
      <div v-for="item in cat.items" :key="item.index" class="faq-card" :class="{'faq-open':openFaq===item.index}">
        <button class="faq-q" @click="toggle(item.index)">
          <span>{{ item.q }}</span>
          <span class="faq-arrow" :class="{'faq-arrow-open':openFaq===item.index}">+</span>
        </button>
        <Transition name="faq-slide">
          <div v-if="openFaq===item.index" class="faq-a">{{ item.a }}</div>
        </Transition>
      </div>
    </div>
  </div>

  <div class="cta-box an tc">
    <h3 class="cta-h">{{ t.ctaH }}</h3>
    <p class="cta-p">{{ t.ctaP }}</p>
    <div class="cta-btns"><a href="mailto:support@sdb-bank.com" class="cta-btn">{{ t.ctaBtn1 }}</a><Link href="/support" class="cta-btn cta-btn-primary">{{ t.ctaBtn2 }}</Link></div>
  </div>
</div></section>
</template>
<style scoped>
.hero{padding:160px 0 60px;background:linear-gradient(135deg,#163300,#1a3d00,#0f2600);color:#fff;position:relative;overflow:hidden}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:#9FE870;text-transform:uppercase;margin-bottom:24px}
.hero-h{font-size:clamp(2rem,5vw,3.4rem);font-weight:900;line-height:1.1;margin-bottom:12px}
.hero-p{font-size:16px;color:rgba(255,255,255,.5);margin-bottom:32px}
.search-wrap{position:relative;max-width:520px;margin:0 auto}
.search-input{width:100%;padding:18px 24px 18px 50px;border:none;border-radius:16px;font-size:15px;font-family:inherit;outline:none;background:rgba(255,255,255,.95);color:#163300;box-shadow:0 8px 32px rgba(0,0,0,.15)}.search-input::placeholder{color:#aaa}
.search-ic{position:absolute;left:18px;top:50%;transform:translateY(-50%);font-size:18px}
.rtl .search-ic{left:auto;right:18px}
.rtl .search-input{padding:18px 50px 18px 24px}
.sec{padding:60px 0}
.sw{max-width:800px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.faq-cat{margin-bottom:40px}
.cat-h{font-size:18px;font-weight:800;color:#163300;margin-bottom:16px}
.faq-list{display:flex;flex-direction:column;gap:8px}
.faq-card{background:#fff;border:1.5px solid rgba(159,232,112,.1);border-radius:14px;overflow:hidden;transition:all .3s}
.faq-card:hover{border-color:rgba(159,232,112,.3)}
.faq-open{border-color:#9FE870;background:rgba(159,232,112,.03)}
.faq-q{width:100%;text-align:inherit;padding:16px 20px;display:flex;justify-content:space-between;align-items:center;cursor:pointer;font-size:15px;font-weight:700;color:#163300;background:none;border:none;font-family:inherit;gap:12px}
.faq-arrow{font-size:22px;color:#9FE870;transition:transform .3s;font-weight:300;flex-shrink:0}
.faq-arrow-open{transform:rotate(45deg)}
.faq-a{padding:0 20px 18px;font-size:14px;line-height:1.9;color:#666;border-top:1px solid rgba(159,232,112,.1);padding-top:14px;margin:0 20px}
.faq-slide-enter-active,.faq-slide-leave-active{transition:all .25s ease;overflow:hidden}
.faq-slide-enter-from,.faq-slide-leave-to{opacity:0;max-height:0}.faq-slide-enter-to,.faq-slide-leave-from{opacity:1;max-height:300px}
.no-result{text-align:center;padding:60px;color:#888;font-size:15px}
.cta-box{padding:48px;background:linear-gradient(135deg,#F0FBE8,#E8F5E0);border:1.5px solid rgba(159,232,112,.2);border-radius:24px;margin-top:40px}
.cta-h{font-size:22px;font-weight:900;color:#163300;margin-bottom:8px}
.cta-p{font-size:14px;color:#888;margin-bottom:24px}
.cta-btns{display:flex;gap:12px;justify-content:center;flex-wrap:wrap}
.cta-btn{padding:12px 24px;border:1.5px solid rgba(159,232,112,.2);border-radius:12px;font-size:14px;font-weight:700;color:#163300;text-decoration:none;background:#fff;transition:all .2s;font-family:inherit}.cta-btn:hover{border-color:#9FE870;color:#2D6A00}
.cta-btn-primary{background:#163300!important;color:#fff!important;border-color:#163300!important}
.an{opacity:0;transform:translateY(24px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
</style>
