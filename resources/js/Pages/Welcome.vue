<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed, onMounted, onUnmounted, watch, nextTick } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
import WelcomeBusiness from '@/Pages/WelcomeBusiness.vue';
defineOptions({ layout: SiteLayout });
const lang = inject('lang', ref('ar'));
const isAr = inject('isAr', computed(() => true));
const isBiz = inject('isBiz', computed(() => false));

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
  try{const r=await fetch('/waitlist',{method:'POST',headers:{'Content-Type':'application/json','Accept':'application/json','X-CSRF-TOKEN':document.querySelector('meta[name="csrf-token"]')?.content||''},body:JSON.stringify({email:em.value,source:'hero'})});const d=await r.json();if(r.ok&&d.success){done.value=true}else{emailErr.value=isAr.value?'حدث خطأ':'Something went wrong'}}catch(e){emailErr.value=isAr.value?'خطأ بالاتصال':'Connection error'}
  submitting.value=false;
}

/* ── Transfer Widget ── */
const sendAmt = ref('1,000');
const twCur = ref({code:'DKK',flag:'🇩🇰',rate:6.87}); // default DKK, updated by auto-detect
const exchangeRate = ref(14250); // SYP per unit of twCur
const fee = 2.99;
const numericAmt = computed(()=> parseFloat(sendAmt.value.replace(/,/g,''))||0);
const sypRate = computed(()=> {
  // rate of twCur is vs USD; exchangeRate is SYP per USD
  // so SYP per twCur unit = exchangeRate / twCur.rate
  if (twCur.value.rate === 0) return exchangeRate.value;
  return Math.round(exchangeRate.value / twCur.value.rate);
});
const receivedAmt = computed(()=> (numericAmt.value * sypRate.value).toLocaleString());
const showTwDD = ref(false);
function onSendInput(e){const v=e.target.value.replace(/[^0-9]/g,'');sendAmt.value=v?parseInt(v).toLocaleString():''}
function pickTwCur(c) { twCur.value = {code:c.code, flag:c.flag, rate:c.rate}; showTwDD.value = false; }

/* ── Calculator ── */
const currencies = ref([
  {code:'SYP',name:'Syrian Pound',nameAr:'ليرة سورية',flag:'🇸🇾',rate:14250},
  {code:'USD',name:'US Dollar',nameAr:'دولار أمريكي',flag:'🇺🇸',rate:1},
  {code:'EUR',name:'Euro',nameAr:'يورو',flag:'🇪🇺',rate:0.92},
  {code:'GBP',name:'British Pound',nameAr:'جنيه إسترليني',flag:'🇬🇧',rate:0.79},
  {code:'DKK',name:'Danish Krone',nameAr:'كرونة دنماركية',flag:'🇩🇰',rate:6.87},
  {code:'SEK',name:'Swedish Krona',nameAr:'كرونة سويدية',flag:'🇸🇪',rate:10.3},
  {code:'NOK',name:'Norwegian Krone',nameAr:'كرونة نرويجية',flag:'🇳🇴',rate:10.6},
  {code:'CHF',name:'Swiss Franc',nameAr:'فرنك سويسري',flag:'🇨🇭',rate:0.88},
  {code:'TRY',name:'Turkish Lira',nameAr:'ليرة تركية',flag:'🇹🇷',rate:32.1},
  {code:'AED',name:'UAE Dirham',nameAr:'درهم إماراتي',flag:'🇦🇪',rate:3.67},
  {code:'SAR',name:'Saudi Riyal',nameAr:'ريال سعودي',flag:'🇸🇦',rate:3.75},
  {code:'KWD',name:'Kuwaiti Dinar',nameAr:'دينار كويتي',flag:'🇰🇼',rate:0.31},
  {code:'QAR',name:'Qatari Riyal',nameAr:'ريال قطري',flag:'🇶🇦',rate:3.64},
  {code:'BHD',name:'Bahraini Dinar',nameAr:'دينار بحريني',flag:'🇧🇭',rate:0.38},
  {code:'OMR',name:'Omani Rial',nameAr:'ريال عماني',flag:'🇴🇲',rate:0.39},
  {code:'JOD',name:'Jordanian Dinar',nameAr:'دينار أردني',flag:'🇯🇴',rate:0.71},
  {code:'EGP',name:'Egyptian Pound',nameAr:'جنيه مصري',flag:'🇪🇬',rate:50.8},
  {code:'LBP',name:'Lebanese Pound',nameAr:'ليرة لبنانية',flag:'🇱🇧',rate:89500},
  {code:'IQD',name:'Iraqi Dinar',nameAr:'دينار عراقي',flag:'🇮🇶',rate:1310},
  {code:'CAD',name:'Canadian Dollar',nameAr:'دولار كندي',flag:'🇨🇦',rate:1.36},
  {code:'AUD',name:'Australian Dollar',nameAr:'دولار أسترالي',flag:'🇦🇺',rate:1.52},
  {code:'JPY',name:'Japanese Yen',nameAr:'ين ياباني',flag:'🇯🇵',rate:149},
]);
const calcAmt = ref('1000');const calcFrom = ref(1);const calcTo = ref(0);
const showFromDD = ref(false);const showToDD = ref(false);
const calcResult = computed(()=>{const a=parseFloat(calcAmt.value)||0;return(a*currencies.value[calcTo.value].rate/currencies.value[calcFrom.value].rate).toLocaleString(undefined,{maximumFractionDigits:2})});
const calcFee = computed(()=> ((parseFloat(calcAmt.value)||0)*0.005).toFixed(2));
const calcRate = computed(()=> (currencies.value[calcTo.value].rate/currencies.value[calcFrom.value].rate).toFixed(4));
function swapCalc(){const t=calcFrom.value;calcFrom.value=calcTo.value;calcTo.value=t}

/* ── Fetch live rates + auto-detect user currency ── */
const tzToCurrency = {
  'America/New_York':'USD','America/Chicago':'USD','America/Denver':'USD','America/Los_Angeles':'USD',
  'America/Toronto':'CAD','America/Vancouver':'CAD',
  'Europe/London':'GBP','Europe/Dublin':'GBP',
  'Europe/Berlin':'EUR','Europe/Paris':'EUR','Europe/Rome':'EUR','Europe/Madrid':'EUR',
  'Europe/Amsterdam':'EUR','Europe/Brussels':'EUR','Europe/Vienna':'EUR','Europe/Athens':'EUR',
  'Europe/Helsinki':'EUR','Europe/Lisbon':'EUR',
  'Europe/Copenhagen':'DKK',
  'Europe/Stockholm':'SEK',
  'Europe/Oslo':'NOK',
  'Europe/Zurich':'CHF',
  'Europe/Istanbul':'TRY',
  'Asia/Dubai':'AED','Asia/Abu_Dhabi':'AED',
  'Asia/Riyadh':'SAR',
  'Asia/Kuwait':'KWD',
  'Asia/Qatar':'QAR','Asia/Doha':'QAR',
  'Asia/Bahrain':'BHD',
  'Asia/Muscat':'OMR',
  'Asia/Amman':'JOD',
  'Africa/Cairo':'EGP',
  'Asia/Damascus':'SYP','Asia/Aleppo':'SYP',
  'Asia/Baghdad':'IQD',
  'Asia/Beirut':'LBP',
  'Asia/Tokyo':'JPY',
  'Australia/Sydney':'AUD','Australia/Melbourne':'AUD',
};

function detectUserCurrency() {
  try {
    const tz = Intl.DateTimeFormat().resolvedOptions().timeZone;
    return tzToCurrency[tz] || null;
  } catch (e) { return null; }
}

onMounted(async () => {
  // Auto-detect user currency from timezone
  const detected = detectUserCurrency();
  if (detected) {
    const idx = currencies.value.findIndex(c => c.code === detected);
    if (idx !== -1) {
      const c = currencies.value[idx];
      // Set transfer widget currency
      twCur.value = {code:c.code, flag:c.flag, rate:c.rate};
      // Set calculator currency
      calcFrom.value = idx;
      if (detected === 'SYP') {
        calcTo.value = currencies.value.findIndex(c => c.code === 'EUR');
      } else {
        calcTo.value = 0; // SYP is first
      }
    }
  }

  try {
    const res = await fetch('/api/public/rates');
    const data = await res.json();
    if (data.rates) {
      const r = data.rates;
      const usdPerEur = r.USD || 1.08;
      // Dynamically update all currencies (rates are vs EUR from API, convert to vs USD)
      currencies.value = currencies.value.map(c => {
        if (r[c.code] !== undefined) {
          return { ...c, rate: parseFloat((r[c.code] / usdPerEur).toFixed(4)) };
        }
        return c;
      });
      // Update transfer widget rate (1 USD = X SYP)
      exchangeRate.value = Math.round((r.SYP || 13500) / usdPerEur);
    }
  } catch (e) { /* fallback to hardcoded */ }
});
function pickFrom(i){calcFrom.value=i;showFromDD.value=false}
function pickTo(i){calcTo.value=i;showToDD.value=false}

/* ── FAQ ── */
const faqOpen = ref(-1);
function toggleFaq(i){faqOpen.value=faqOpen.value===i?-1:i}

/* ── Scroll Animations ── */
let obs;
onMounted(()=>{
  tick();ti=setInterval(tick,1e3);
  obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting){x.target.classList.add('vi');if(x.target.hasAttribute('data-stagger')){x.target.querySelectorAll(':scope > *').forEach((ch,i)=>{setTimeout(()=>ch.classList.add('vi'),i*100)})}}}),{threshold:.08,rootMargin:'0px 0px -40px 0px'});
  document.querySelectorAll('.an,.an-l,.an-r').forEach(el=>obs.observe(el));
  document.querySelectorAll('[data-stagger]').forEach(p=>{p.querySelectorAll(':scope > *').forEach(ch=>ch.classList.add('an'));obs.observe(p)});
});
onUnmounted(()=>{clearInterval(ti);obs?.disconnect()});

/* Re-observe animations when switching segments */
watch(isBiz, ()=>{
  nextTick(()=>{
    if(obs){
      document.querySelectorAll('.an,.an-l,.an-r').forEach(el=>{el.classList.remove('vi');obs.observe(el)});
      document.querySelectorAll('[data-stagger]').forEach(p=>{p.querySelectorAll(':scope > *').forEach(ch=>{ch.classList.remove('vi');ch.classList.add('an')});obs.observe(p)});
    }
  });
});


/* ── Business overrides ── */
const bizAr = {
  heroTag:'🏢 حلول مصرفية للشركات',
  h1a:'ادر أعمالك',h1b:'بنظام مصرفي متكامل',
  heroP:'نت بنك متطور للشركات. تحويلات دولية، محافظ متعددة العملات، وتقارير مالية متقدمة.',
  howTitle:'ابدأ مع حساب الأعمال في 4 خطوات',howSub:'افتح حسابك التجاري وابدأ بإدارة أعمالك المالية.',
  steps:[{n:'01',t:'سجّل شركتك',d:'أدخل بيانات الشركة والسجل التجاري.'},{n:'02',t:'فعّل الحساب',d:'تحقق من الهوية واعتمد الحساب.'},{n:'03',t:'أضف المستخدمين',d:'أنشئ حسابات لفريقك مع صلاحيات مخصصة.'},{n:'04',t:'ابدأ التشغيل',d:'استخدم النت بنك وأدر تحويلاتك.'}],
  featTitle:'أدوات مصرفية متكاملة للأعمال',featSub:'كل ما تحتاجه شركتك في منصة واحدة احترافية',
  feats:[{ic:'🏢',t:'حسابات متعددة',d:'حسابات منفصلة لكل فرع أو قسم',cl:'feat-amber'},{ic:'📊',t:'تقارير مالية',d:'تقارير وتحليلات متقدمة في الوقت الحقيقي',cl:'feat-blue'},{ic:'💱',t:'صرف عملات',d:'تحويل فوري بين 30+ عملة',cl:'feat-green'},{ic:'🌐',t:'تحويلات SWIFT',d:'تحويلات دولية لـ 170+ دولة',cl:'feat-purple'},{ic:'👥',t:'إدارة الفريق',d:'صلاحيات مخصصة لكل مستخدم',cl:'feat-pink'},{ic:'🖥️',t:'نت بنك',d:'لوحة تحكم ويب متطورة للشركات',cl:'feat-orange'},{ic:'🔐',t:'موافقات متعددة',d:'نظام موافقات لتحويلات آمنة',cl:'feat-cyan'},{ic:'📋',t:'API للأعمال',d:'ربط مباشر مع أنظمة المحاسبة',cl:'feat-rose'}],
  appTag:'النت بنك',appTitle:'لوحة تحكم متطورة لأعمالك',appSub:'سجّل دخولك عبر الويب وأدر جميع معاملاتك المالية من أي مكان.',
  appFeats:[{ic:'📊',t:'تقارير متقدمة',d:'تقارير مالية وتحليلات شاملة'},{ic:'👥',t:'إدارة الصلاحيات',d:'صلاحيات مخصصة لكل مستخدم'},{ic:'💱',t:'محافظ متعددة',d:'عملات متعددة في حساب واحد'},{ic:'📋',t:'كشف حساب',d:'تصدير بيانات بصيغ متعددة'},{ic:'🔐',t:'موافقات مزدوجة',d:'نظام أمان للتحويلات الكبيرة'},{ic:'🔗',t:'API ربط',d:'تكامل مع أنظمتك المحاسبية'}],
  ctaTitle:'ابدأ مع حساب الأعمال',ctaSub:'سجّل شركتك الآن واحصل على نت بنك متكامل للأعمال.',ctaBtn:'افتح حساب أعمال ←',ctaBtn2:'تواصل مع فريق المبيعات',
  faqTag:'الأسئلة الشائعة',faqTitle:'أسئلة حسابات الأعمال',
  faqs:[{q:'ما المتطلبات لفتح حساب أعمال؟',a:'السجل التجاري، إثبات هوية المسؤول، ونموذج فتح الحساب.'},{q:'كم يكلف حساب الأعمال؟',a:'الحساب الأساسي مجاني. الباقات المتقدمة تبدأ من €49/شهر.'},{q:'هل يمكن إضافة عدة مستخدمين؟',a:'نعم، مع صلاحيات مختلفة لكل مستخدم.'},{q:'هل يدعم API للربط مع أنظمتنا؟',a:'نعم، نوفر API RESTful كامل.'},{q:'ما هي العملات المدعومة؟',a:'ندعم 30+ عملة مع تحويل فوري.'}],
};
const bizEn = {
  heroTag:'🏢 Business Banking Solutions',
  h1a:'Run your business',h1b:'with a complete banking system',
  heroP:'Advanced net banking for businesses. International transfers, multi-currency wallets, and advanced financial reports.',
  howTitle:'Get started with a business account in 4 steps',howSub:'Open your business account and start managing your finances.',
  steps:[{n:'01',t:'Register your company',d:'Enter company details and trade license.'},{n:'02',t:'Activate the account',d:'Verify identity and approve the account.'},{n:'03',t:'Add team members',d:'Create accounts for your team with custom permissions.'},{n:'04',t:'Start operating',d:'Use net banking and manage your transfers.'}],
  featTitle:'Complete banking tools for business',featSub:'Everything your company needs in one professional platform',
  feats:[{ic:'🏢',t:'Multiple accounts',d:'Separate accounts for each branch or department',cl:'feat-amber'},{ic:'📊',t:'Financial reports',d:'Advanced real-time reports and analytics',cl:'feat-blue'},{ic:'💱',t:'Currency exchange',d:'Instant exchange between 30+ currencies',cl:'feat-green'},{ic:'🌐',t:'SWIFT transfers',d:'International transfers to 170+ countries',cl:'feat-purple'},{ic:'👥',t:'Team management',d:'Custom permissions for each user',cl:'feat-pink'},{ic:'🖥️',t:'Net Banking',d:'Advanced web dashboard for businesses',cl:'feat-orange'},{ic:'🔐',t:'Multi-approval',d:'Approval system for secure transfers',cl:'feat-cyan'},{ic:'📋',t:'Business API',d:'Direct integration with accounting systems',cl:'feat-rose'}],
  appTag:'NET BANKING',appTitle:'Advanced dashboard for your business',appSub:'Log in via the web and manage all your financial operations from anywhere.',
  appFeats:[{ic:'📊',t:'Advanced Reports',d:'Comprehensive financial reports and analytics'},{ic:'👥',t:'Permission Management',d:'Custom permissions for each user'},{ic:'💱',t:'Multi Wallets',d:'Multiple currencies in one account'},{ic:'📋',t:'Statements',d:'Export data in multiple formats'},{ic:'🔐',t:'Dual Approval',d:'Security system for large transfers'},{ic:'🔗',t:'API Integration',d:'Connect with your accounting systems'}],
  ctaTitle:'Start with a Business Account',ctaSub:'Register your company now and get a complete net banking solution.',ctaBtn:'Open business account →',ctaBtn2:'Contact sales team',
  faqTag:'FAQ',faqTitle:'Business Account Questions',
  faqs:[{q:'What are the requirements for a business account?',a:'Trade license, responsible person ID, and account opening form.'},{q:'How much does a business account cost?',a:'Basic account is free. Advanced plans start from €49/month.'},{q:'Can I add multiple users?',a:'Yes, with different permissions for each user.'},{q:'Does it support API integration?',a:'Yes, we provide a full RESTful API.'},{q:'Which currencies are supported?',a:'We support 30+ currencies with instant exchange.'}],
};

/* Final merged translations */
const tBase = computed(() => isAr.value ? {
  heroTag:'⭐ 4.9 من 100,000+ تقييم',
  h1a:'حوّل أموالك',h1b:'بذكاء وبشكل فوري',
  heroP:'أرسل واستقبل الأموال بسعر الصرف الحقيقي. وفّر حتى 90% مقارنة بالبنوك التقليدية.',
  days:'يوم',hrs:'ساعة',min:'دقيقة',sec:'ثانية',
  emailPh:'بريدك الإلكتروني...',notify:'سجّل مبكراً',emailDone:'✨ تم! سنبلغك فور الإطلاق.',
  twTitle:'حاسبة التحويل',twInstant:'فوري',twSend:'أنت ترسل',twGets:'المستلم يحصل على',twFee:'رسوم',twRate:'سعر الصرف',twTime:'وقت الوصول',twSecs:'خلال ثوانٍ',twCta:'ابدأ التحويل الآن →',
  partTag:'شركاؤنا',partTitle:'نعمل مع أفضل الشبكات المالية العالمية',
  partStats:[{v:'8+',l:'شريك مالي'},{v:'170+',l:'دولة مدعومة'},{v:'30+',l:'عملة'},{v:'24/7',l:'دعم متواصل'}],
  howTag:'كيف يعمل',howTitle:'أرسل المال في 4 خطوات بسيطة',howSub:'لا تعقيد، لا رسوم خفية. فقط طريقة بسيطة وشفافة.',
  steps:[{n:'01',t:'أنشئ حسابك',d:'التسجيل مجاني ويستغرق دقيقتين فقط.'},{n:'02',t:'أضف المستلم',d:'أدخل تفاصيل المستلم وحسابه البنكي.'},{n:'03',t:'اختر المبلغ',d:'شاهد سعر الصرف الحقيقي والرسوم.'},{n:'04',t:'أرسل فوراً',d:'أكد التحويل وسيصل المال خلال ثوانٍ.'}],
  featTag:'المميزات',featTitle:'كل ما تحتاجه في مكان واحد',featSub:'منصة مصرفية متكاملة توفر لك كل الأدوات لإدارة أموالك بذكاء',
  feats:[{ic:'⚡',t:'تحويلات فورية',d:'74% من التحويلات تصل خلال 20 ثانية',cl:'feat-amber'},{ic:'🔒',t:'حماية متقدمة',d:'تشفير على مستوى البنوك',cl:'feat-blue'},{ic:'💰',t:'السعر الحقيقي',d:'سعر الصرف بدون إضافات',cl:'feat-green'},{ic:'🌍',t:'170+ دولة',d:'أرسل المال لأي مكان بالعالم',cl:'feat-purple'},{ic:'💳',t:'بطاقات ذكية',d:'بطاقات مجانية للدفع والسحب',cl:'feat-pink'},{ic:'📱',t:'تطبيق سهل',d:'أدر كل شيء من هاتفك',cl:'feat-orange'},{ic:'🕐',t:'دعم 24/7',d:'فريق دعم متاح على مدار الساعة',cl:'feat-cyan'},{ic:'🐷',t:'وفر أكثر',d:'وفر حتى 90% من الرسوم',cl:'feat-rose'}],
  compTag:'قارن الأسعار',compTitle:'وفّر حتى 90% من رسوم التحويل',compSub:'البنوك تخفي الرسوم في سعر الصرف. نحن نقدم السعر الحقيقي بشفافية.',
  compBest:'الأفضل قيمة',compRec:'موصى به',compGets:'المستلم يحصل على',
  compSdb:{n:'SDB Bank',amt:'14,250,000',pts:['سعر الصرف الحقيقي','رسوم 2.99$ فقط','يصل خلال ثوانٍ']},
  compBank:{n:'بنك تقليدي',amt:'13,800,000',less:'- 450,000 أقل',pts:['هامش 3-5% مخفي','رسوم 25$+','2-5 أيام عمل']},
  compWu:{n:'Western Union',amt:'13,500,000',less:'- 750,000 أقل',pts:['سعر غير تنافسي +5%','رسوم 35$+','1-3 أيام']},
  calcTag:'حاسبة التحويل',calcTitle:'احسب تحويلك الآن',calcSub:'استخدم حاسبتنا لمعرفة المبلغ الذي سيصل للمستلم.',
  calcBenefits:[{ic:'📈',t:'سعر الصرف الحقيقي',d:'بدون إضافات مخفية'},{ic:'⚡',t:'تحويل سريع',d:'74% تصل خلال 20 ثانية'},{ic:'🔒',t:'آمن ومضمون',d:'تشفير على مستوى البنوك'}],
  calcSend:'أنت ترسل',calcGets:'المستلم يحصل على',calcFee:'الرسوم',calcExRate:'سعر الصرف',calcArrival:'وقت الوصول',calcSecs:'خلال ثوانٍ',calcCta:'ابدأ التحويل',
  appTag:'التطبيق',appTitle:'كل شيء في تطبيق واحد',appSub:'حمّل تطبيقنا وابدأ بإدارة أموالك بطريقة أذكى.',
  appFeats:[{ic:'🔔',t:'إشعارات فورية',d:'تنبيهات لكل معاملة'},{ic:'👆',t:'مصادقة بيومترية',d:'ادخل بالبصمة أو Face ID'},{ic:'💳',t:'إدارة البطاقات',d:'تحكم كامل في بطاقاتك'},{ic:'📊',t:'تحليل المصاريف',d:'تتبع وحلل إنفاقك'},{ic:'📷',t:'دفع بـ QR',d:'ادفع بمسح رمز QR'},{ic:'💰',t:'محافظ متعددة',d:'أنشئ محافظ بعملات مختلفة'}],
  globTag:'تغطية عالمية',globTitle:'أرسل المال إلى',globHighlight:'170+ دولة',globSub:'سواء كنت ترسل للعائلة أو تدفع للأعمال، نغطي معظم دول العالم.',globCta:'اكتشف جميع الدول →',globMore:'+162 عملة أخرى',
  globStats:[{v:'$0',l:'تحويلات شهرية'},{v:'0',l:'معاملة يومية'},{v:'20s',l:'متوسط وقت التحويل'},{v:'0.5%',l:'رسوم منخفضة'}],
  trustTag:'الأمان والثقة',trustTitle:'آمن في كل خطوة',trustSub:'ملايين العملاء يثقون بنا لنقل أموالهم بأمان',
  trustItems:[{ic:'🛡️',t:'مرخص ومنظم',d:'مرخص على المستوى الوطني مع 65 ترخيصاً'},{ic:'🔐',t:'أموالك محمية',d:'أموالك محمية في حسابات منفصلة وآمنة'},{ic:'👁️',t:'مكافحة الاحتيال',d:'أكثر من 1,000 خبير أمني و7 مليون فحص يومياً'},{ic:'🏅',t:'تشفير متقدم',d:'نستخدم تشفير 256-bit لحماية جميع بياناتك'}],
  trustStats:[{v:'0',l:'عميل نشط'},{v:'$0',l:'تحويلات شهرية'},{v:'99.9%',l:'وقت التشغيل'},{v:'0/5',l:'تقييم العملاء'}],
  secTag:'الأمان والحماية',secTitle:'معتمدون من أعلى الجهات',secMsg:'أموالك محمية بأعلى معايير الأمان العالمية',
  secBadges:[{ic:'🛡️',t:'PCI DSS',d:'معتمد لمعايير أمان بيانات البطاقات'},{ic:'🔒',t:'SSL 256-bit',d:'تشفير من الدرجة العسكرية'},{ic:'✅',t:'ISO 27001',d:'نظام إدارة أمن المعلومات'},{ic:'🏆',t:'SOC 2 Type II',d:'معايير الأمان والخصوصية'},{ic:'📋',t:'GDPR',d:'متوافق مع قوانين حماية البيانات'},{ic:'🌐',t:'Swift',d:'عضو في شبكة Swift العالمية'}],
  testTag:'آراء العملاء',testTitle:'يثق بنا الملايين',testSub:'اكتشف لماذا يختار عملاؤنا SDB Bank',
  tests:[{n:'أحمد محمد',r:'رجل أعمال',q:'خدمة ممتازة وسريعة. التحويلات تصل في ثوانٍ. أنصح الجميع بتجربة SDB.',a:'A'},{n:'سارة العلي',r:'مهندسة برمجيات',q:'تطبيق سهل ورسوم شفافة. أفضل تجربة مصرفية رقمية.',a:'S'},{n:'محمود حسن',r:'طبيب',q:'أستخدم SDB منذ سنة. الأمان والسرعة لا مثيل لهما.',a:'M'},{n:'نور الدين',r:'مدير مشاريع',q:'وفرت الكثير مقارنة بالبنوك التقليدية.',a:'N'}],
  testStats:[{v:'0/5',l:'تقييم App Store'},{v:'0',l:'تقييمات'},{v:'0',l:'عميل سعيد'},{v:'0%',l:'رضا العملاء'}],
  faqTag:'الأسئلة الشائعة',faqTitle:'كل ما تريد معرفته',
  faqs:[{q:'كيف أفتح حساب في SDB Bank؟',a:'التسجيل مجاني ويستغرق دقيقتين. كل ما تحتاجه بريدك الإلكتروني وإثبات هوية.'},{q:'ما هي رسوم التحويل؟',a:'رسومنا تبدأ من 0.3% فقط.'},{q:'كم يستغرق التحويل؟',a:'74% من التحويلات تصل خلال 20 ثانية.'},{q:'هل أموالي آمنة؟',a:'نعم. نستخدم تشفير AES-256 وحماية ثنائية.'},{q:'ما هي الدول المدعومة؟',a:'ندعم 170+ دولة حول العالم.'}],
  ctaTitle:'البنك في جيبك',ctaSub:'حمّل تطبيق SDB Bank وأرسل الأموال من أي مكان.',ctaBtn:'افتح حسابك المجاني ←',ctaBtn2:'تواصل معنا',
  balance:'إجمالي الرصيد',send:'إرسال',receive:'استلام',cards:'البطاقات',more:'المزيد',recentTx:'المعاملات الأخيرة',received:'تم الاستلام',
} : {
  heroTag:'⭐ 4.9 from 100,000+ reviews',
  h1a:'Move your money',h1b:'smarter and instantly',
  heroP:'Send and receive money at the real exchange rate. Save up to 90% compared to banks.',
  days:'Days',hrs:'Hrs',min:'Min',sec:'Sec',
  emailPh:'Your email...',notify:'Sign up early',emailDone:'✨ Done! We\'ll notify you at launch.',
  twTitle:'Transfer Calculator',twInstant:'Instant',twSend:'You send',twGets:'Recipient gets',twFee:'fee',twRate:'Exchange rate',twTime:'Delivery time',twSecs:'In seconds',twCta:'Start your transfer →',
  partTag:'OUR PARTNERS',partTitle:'Working with the best global financial networks',
  partStats:[{v:'8+',l:'Financial Partners'},{v:'170+',l:'Supported Countries'},{v:'30+',l:'Currencies'},{v:'24/7',l:'Support Available'}],
  howTag:'HOW IT WORKS',howTitle:'Send money in 4 simple steps',howSub:'No complexity, no hidden fees. Just a simple, transparent way.',
  steps:[{n:'01',t:'Create your account',d:'Signing up is free and takes just 2 minutes.'},{n:'02',t:'Add your recipient',d:'Enter recipient details and bank account.'},{n:'03',t:'Choose the amount',d:'See the real exchange rate and fees.'},{n:'04',t:'Send instantly',d:'Confirm and money arrives in seconds.'}],
  featTag:'FEATURES',featTitle:'Everything you need in one place',featSub:'A complete banking platform with all the tools to manage your money smartly',
  feats:[{ic:'⚡',t:'Instant transfers',d:'74% of transfers arrive in under 20 seconds',cl:'feat-amber'},{ic:'🔒',t:'Advanced security',d:'Bank-level encryption and fraud protection',cl:'feat-blue'},{ic:'💰',t:'Real exchange rate',d:'We use the real rate with no markup',cl:'feat-green'},{ic:'🌍',t:'170+ countries',d:'Send money almost anywhere in the world',cl:'feat-purple'},{ic:'💳',t:'Smart cards',d:'Free cards to pay and withdraw anywhere',cl:'feat-pink'},{ic:'📱',t:'Easy app',d:'Manage everything easily from your phone',cl:'feat-orange'},{ic:'🕐',t:'24/7 support',d:'Support team available around the clock',cl:'feat-cyan'},{ic:'🐷',t:'Save more',d:'Save up to 90% compared to banks',cl:'feat-rose'}],
  compTag:'COMPARE PRICES',compTitle:'Save up to 90% on transfer fees',compSub:'Banks hide fees in exchange rates. We offer the real rate with complete transparency.',
  compBest:'BEST VALUE',compRec:'Recommended',compGets:'Recipient gets',
  compSdb:{n:'SDB Bank',amt:'14,250,000',pts:['Real exchange rate','Only $2.99 fee','Arrives in seconds']},
  compBank:{n:'Traditional Bank',amt:'13,800,000',less:'- 450,000 SYP less',pts:['Marked up rate (+3%)','$25+ fees','2-5 business days']},
  compWu:{n:'Western Union',amt:'13,500,000',less:'- 750,000 SYP less',pts:['Poor rate (+5%)','$35+ fees','1-3 days']},
  calcTag:'CALCULATOR',calcTitle:'Calculate your transfer now',calcSub:'Use our calculator to find out how much the recipient will receive.',
  calcBenefits:[{ic:'📈',t:'Real exchange rate',d:'No hidden markups on the rate'},{ic:'⚡',t:'Fast transfer',d:'74% of transfers arrive in 20 seconds'},{ic:'🔒',t:'Safe and secure',d:'Bank-level encryption'}],
  calcSend:'You send',calcGets:'Recipient gets',calcFee:'Fee',calcExRate:'Exchange rate',calcArrival:'Arrival time',calcSecs:'In seconds',calcCta:'Start Transfer',
  appTag:'THE APP',appTitle:'Everything in One App',appSub:'Download our app and start managing your money smarter and easier than ever.',
  appFeats:[{ic:'🔔',t:'Instant Notifications',d:'Alerts for every transaction'},{ic:'👆',t:'Biometric Auth',d:'Login with fingerprint or Face ID'},{ic:'💳',t:'Card Management',d:'Full control of your cards'},{ic:'📊',t:'Spending Analytics',d:'Track and analyze your spending'},{ic:'📷',t:'QR Payments',d:'Pay by scanning QR code'},{ic:'💰',t:'Multi Wallets',d:'Create wallets in different currencies'}],
  globTag:'GLOBAL COVERAGE',globTitle:'Send money to',globHighlight:'170+ countries',globSub:'Whether you\'re sending to family or paying for business, we cover most countries worldwide.',globCta:'Explore all countries →',globMore:'+162 more currencies',
  globStats:[{v:'$0',l:'Monthly transfers'},{v:'0',l:'Daily transactions'},{v:'20s',l:'Avg. transfer time'},{v:'0.5%',l:'Low fees'}],
  trustTag:'SECURITY & TRUST',trustTitle:'Safe at every step',trustSub:'Millions trust us to move their money safely',
  trustItems:[{ic:'🛡️',t:'Licensed & regulated',d:'Regulated nationwide with 65 licences worldwide'},{ic:'🔐',t:'Safeguarded funds',d:'Your money is protected in separate accounts'},{ic:'👁️',t:'Anti-fraud tech',d:'1,000+ security experts and 7M daily checks'},{ic:'🏅',t:'Bank-level encryption',d:'We use 256-bit encryption to protect your data'}],
  trustStats:[{v:'0',l:'Active customers'},{v:'$0',l:'Monthly transfers'},{v:'99.9%',l:'Uptime'},{v:'0/5',l:'Customer rating'}],
  secTag:'SECURITY & PROTECTION',secTitle:'Certified by Top Authorities',secMsg:'Your money is protected by the highest global security standards',
  secBadges:[{ic:'🛡️',t:'PCI DSS',d:'Payment Card Industry Data Security Standard'},{ic:'🔒',t:'SSL 256-bit',d:'Military-grade encryption'},{ic:'✅',t:'ISO 27001',d:'Information Security Management'},{ic:'🏆',t:'SOC 2 Type II',d:'Security & Privacy Standards'},{ic:'📋',t:'GDPR',d:'Data Protection Compliant'},{ic:'🌐',t:'Swift',d:'Swift Network Member'}],
  testTag:'TESTIMONIALS',testTitle:'Trusted by millions',testSub:'Discover why customers choose SDB Bank',
  tests:[{n:'Ahmad Mohammad',r:'Businessman',q:'Excellent and fast service. Transfers arrive in seconds.',a:'A'},{n:'Sara Al-Ali',r:'Software Engineer',q:'Easy to use app with transparent fees. Best digital banking.',a:'S'},{n:'Mahmoud Hassan',r:'Doctor',q:'I\'ve been using SDB for a year. Security and speed are unmatched.',a:'M'},{n:'Nour Al-Din',r:'Project Manager',q:'Saved a lot on fees compared to traditional banks.',a:'N'}],
  testStats:[{v:'0/5',l:'App Store Rating'},{v:'0',l:'Reviews'},{v:'0',l:'Happy Customers'},{v:'0%',l:'Satisfaction Rate'}],
  faqTag:'FAQ',faqTitle:'Everything you need to know',
  faqs:[{q:'How do I open an SDB Bank account?',a:'Registration is free and takes 2 minutes.'},{q:'What are the transfer fees?',a:'Our fees start from just 0.3%.'},{q:'How long does a transfer take?',a:'74% of transfers arrive in 20 seconds.'},{q:'Is my money safe?',a:'Yes. AES-256 encryption and 2FA.'},{q:'Which countries are supported?',a:'We support 170+ countries worldwide.'}],
  ctaTitle:'Banking in your pocket',ctaSub:'Download the SDB Bank app and send money from anywhere.',ctaBtn:'Open free account →',ctaBtn2:'Contact us',
  balance:'Total Balance',send:'Send',receive:'Receive',cards:'Cards',more:'More',recentTx:'Recent Transactions',received:'Received',
});
const t = computed(() => {
  const base = tBase.value;
  if (!isBiz.value) return base;
  const biz = isAr.value ? bizAr : bizEn;
  return { ...base, ...biz };
});
const stepColors = ['sc-blue','sc-purple','sc-amber','sc-green'];
const stepBgs = ['sb-blue','sb-purple','sb-amber','sb-green'];
const testColors = ['tc-blue','tc-purple','tc-green','tc-orange'];
const flagGrid = [{f:'🇺🇸',n:'USD'},{f:'🇪🇺',n:'EUR'},{f:'🇬🇧',n:'GBP'},{f:'🇦🇪',n:'AED'},{f:'🇸🇦',n:'SAR'},{f:'🇹🇷',n:'TRY'},{f:'🇯🇴',n:'JOD'},{f:'🇱🇧',n:'LBP'}];
const floatingSymbols = [{s:'$',top:'10%',left:'5%'},{s:'€',top:'20%',right:'10%'},{s:'£',top:'60%',left:'8%'},{s:'¥',top:'70%',right:'5%'},{s:'₺',top:'40%',left:'15%'}];
</script>
<template>
<!-- Business Page -->
<WelcomeBusiness v-if="isBiz" key="biz" />

<!-- Personal Page -->
<template v-else>
<Head :title="isAr?'SDB Bank — أول بنك إلكتروني سوري':'SDB Bank — First Syrian Digital Bank'"/>

<!-- ═══════════ 1. HERO ═══════════ -->
<section class="hero"><div class="hero-bg"></div>
<div class="hero-circles"><div class="hc hc1"></div><div class="hc hc2"></div><div class="hc hc3"></div></div>
<div class="sw hero-grid">
  <div class="hero-left">
    <div class="hero-tag an">{{ t.heroTag }}</div>
    <h1 class="hero-h1 an" style="transition-delay:.1s">{{ t.h1a }}<br><span class="hero-em">{{ t.h1b }}</span></h1>
    <p class="hero-p an" style="transition-delay:.2s">{{ t.heroP }}</p>
    <div class="hero-cd an" style="transition-delay:.3s"><div v-for="(lb,k) in {d:t.days,h:t.hrs,m:t.min,s:t.sec}" :key="k" class="cd-box"><div class="cd-n">{{ String(cd[k]).padStart(2,'0') }}</div><div class="cd-l">{{ lb }}</div></div></div>
    <div class="hero-eml an" style="transition-delay:.4s"><template v-if="!done"><input v-model="em" type="email" :placeholder="t.emailPh" class="eml-i" @keyup.enter="submitEmail"/><button @click="submitEmail" class="eml-b" :disabled="submitting">{{ t.notify }}</button></template><div v-else class="eml-ok">{{ t.emailDone }}</div><div v-if="emailErr" class="eml-err">{{ emailErr }}</div></div>
  </div>
  <!-- Transfer Widget -->
  <div class="hero-right an-r">
    <div class="tw-glow"></div>
    <div class="tw">
      <div class="tw-head"><h3 class="tw-title">{{ t.twTitle }}</h3><span class="tw-instant">⚡ {{ t.twInstant }}</span></div>
      <div class="tw-field"><label class="tw-lbl">{{ t.twSend }}</label><div class="tw-row"><input type="text" :value="sendAmt" @input="onSendInput" class="tw-inp" placeholder="0"/><div class="tw-cur tw-cur-pick" @click="showTwDD=!showTwDD">{{ twCur.flag }} <span>{{ twCur.code }}</span> <span class="tw-cur-arr">▾</span>
        <div v-if="showTwDD" class="tw-dd" @click.stop>
          <div v-for="c in currencies" :key="c.code" class="tw-dd-item" :class="{'tw-dd-active':c.code===twCur.code}" @click="pickTwCur(c)">{{ c.flag }} <span>{{ c.code }}</span></div>
        </div>
      </div></div></div>
      <div class="tw-swap"><div class="tw-swap-circle">↓</div><div class="tw-line"></div></div>
      <div class="tw-info"><span>✓ {{ fee }} {{ twCur.code }} {{ t.twFee }}</span><span>1 {{ twCur.code }} = {{ sypRate.toLocaleString() }} SYP</span></div>
      <div class="tw-field"><label class="tw-lbl">{{ t.twGets }}</label><div class="tw-row tw-row-result"><span class="tw-result">{{ receivedAmt }}</span><div class="tw-cur tw-cur-result">🇸🇾 <span>SYP</span></div></div></div>
      <div class="tw-delivery"><span>⚡ {{ t.twTime }}</span><span class="tw-bold">{{ t.twSecs }}</span></div>
      <Link href="/preregister" class="tw-cta">{{ t.twCta }}</Link>
      <div class="tw-badges"><span>✓ {{ isAr?'مشفر':'Encrypted' }}</span><span>•</span><span>✓ {{ isAr?'آمن':'Secure' }}</span><span>•</span><span>✓ {{ isAr?'مرخص':'Licensed' }}</span></div>
    </div>
  </div>
</div></section>

<!-- ═══════════ 2. PARTNERS ═══════════ -->
<section class="sec-dark partners-sec">
  <div class="partners-glow"></div>
  <div class="sw" style="position:relative;z-index:1">
    <div class="sec-hdr an"><p class="pill-green">{{ t.partTag }}</p><h3 class="part-title">{{ t.partTitle }}</h3></div>
    <div class="mq-wrap"><div class="mq-track"><div v-for="(p,i) in ['VISA','Mastercard','SWIFT','Apple Pay','Google Pay','Samsung Pay','VISA','Mastercard','SWIFT','Apple Pay','Google Pay','Samsung Pay','VISA','Mastercard','SWIFT','Apple Pay','Google Pay','Samsung Pay']" :key="i" class="mq-item">{{ p }}</div></div></div>
    <div class="part-stats an" data-stagger><div v-for="s in t.partStats" :key="s.l" class="pstat"><div class="pstat-v">{{ s.v }}</div><div class="pstat-l">{{ s.l }}</div></div></div>
  </div>
</section>

<!-- ═══════════ 3. HOW IT WORKS ═══════════ -->
<section class="sec-white"><div class="sw">
  <div class="sec-hdr an"><span class="pill">{{ t.howTag }}</span><h2 class="t2">{{ t.howTitle }}</h2><p class="t2-sub">{{ t.howSub }}</p></div>
  <div class="steps-grid" data-stagger><div class="steps-line"></div>
    <div v-for="(s,i) in t.steps" :key="i" class="step">
      <div class="step-num" :class="stepColors[i]">{{ s.n }}</div>
      <div class="step-card" :class="stepBgs[i]"><h3 class="step-t">{{ s.t }}</h3><p class="step-d">{{ s.d }}</p></div>
    </div>
  </div>
</div></section>

<!-- ═══════════ 4. FEATURES ═══════════ -->
<section class="sec-white sec-feat-bg"><div class="sec-feat-glow1"></div><div class="sec-feat-glow2"></div><div class="sw" style="position:relative;z-index:1">
  <div class="sec-hdr an"><span class="pill">{{ t.featTag }}</span><h2 class="t2">{{ t.featTitle }}</h2><p class="t2-sub">{{ t.featSub }}</p></div>
  <div class="feats-grid" data-stagger><div v-for="f in t.feats" :key="f.t" class="feat" :class="f.cl">
    <span class="feat-ic">{{ f.ic }}</span><h3 class="feat-t">{{ f.t }}</h3><p class="feat-d">{{ f.d }}</p>
  </div></div>
</div></section>

<!-- ═══════════ 5. SERVICES COMPARISON ═══════════ -->
<section class="sec-light"><div class="sw">
  <div class="sec-hdr an"><span class="pill">{{ t.compTag }}</span><h2 class="t2">{{ t.compTitle }}</h2><p class="t2-sub">{{ t.compSub }}</p></div>
  <div class="comp-grid" data-stagger>
    <div class="comp-card comp-best"><div class="comp-badge">{{ t.compBest }}</div><div class="comp-logo"><div class="comp-sdb-icon">SDB</div><div><h3 class="comp-name">{{ t.compSdb.n }}</h3><span class="comp-rec">{{ t.compRec }}</span></div></div><div class="comp-amt-box"><span class="comp-amt-lbl">{{ t.compGets }}</span><span class="comp-amt-val">{{ t.compSdb.amt }} <small>SYP</small></span></div><ul class="comp-pts"><li v-for="p in t.compSdb.pts" :key="p"><span class="ck">✓</span>{{ p }}</li></ul><Link href="/preregister" class="comp-cta">{{ isAr?'ابدأ الآن →':'Get started →' }}</Link></div>
    <div class="comp-card comp-dim"><div class="comp-logo"><div class="comp-dim-icon">BANK</div><h3 class="comp-name-dim">{{ t.compBank.n }}</h3></div><div class="comp-amt-box"><span class="comp-amt-lbl">{{ t.compGets }}</span><span class="comp-amt-dim">{{ t.compBank.amt }} <small>SYP</small></span><span class="comp-less">{{ t.compBank.less }}</span></div><ul class="comp-pts-dim"><li v-for="p in t.compBank.pts" :key="p"><span class="xx">✗</span>{{ p }}</li></ul></div>
    <div class="comp-card comp-dim"><div class="comp-logo"><div class="comp-wu-icon">WU</div><h3 class="comp-name-dim">{{ t.compWu.n }}</h3></div><div class="comp-amt-box"><span class="comp-amt-lbl">{{ t.compGets }}</span><span class="comp-amt-dim">{{ t.compWu.amt }} <small>SYP</small></span><span class="comp-less">{{ t.compWu.less }}</span></div><ul class="comp-pts-dim"><li v-for="p in t.compWu.pts" :key="p"><span class="xx">✗</span>{{ p }}</li></ul></div>
  </div>
</div></section>

<!-- ═══════════ 6. CALCULATOR ═══════════ -->
<section class="sec-calc"><div class="sec-calc-glow1"></div><div class="sec-calc-glow2"></div><div class="sw" style="position:relative;z-index:1">
  <div class="calc-grid">
    <div class="calc-left an-l">
      <span class="pill">{{ t.calcTag }}</span>
      <h2 class="t2" style="text-align:start">{{ t.calcTitle }}</h2>
      <p class="t2-sub" style="text-align:start;margin:0 0 32px">{{ t.calcSub }}</p>
      <div class="calc-benefits"><div v-for="b in t.calcBenefits" :key="b.t" class="calc-ben"><div class="calc-ben-ic">{{ b.ic }}</div><div><h4 class="calc-ben-t">{{ b.t }}</h4><p class="calc-ben-d">{{ b.d }}</p></div></div></div>
    </div>
    <div class="calc-right an-r">
      <div class="calc-card">
        <div class="calc-field"><label class="calc-lbl">{{ t.calcSend }}</label><div class="calc-row"><input v-model="calcAmt" type="number" class="calc-inp" placeholder="0"/><div class="calc-dd-wrap" @click="showFromDD=!showFromDD"><span class="calc-flag">{{ currencies[calcFrom].flag }}</span><span class="calc-code">{{ currencies[calcFrom].code }}</span><span class="calc-chev">▾</span>
          <div v-if="showFromDD" class="calc-dd"><button v-for="(c,i) in currencies" :key="c.code" @click.stop="pickFrom(i)" class="calc-dd-item"><span>{{ c.flag }}</span><span>{{ c.code }}</span><span class="calc-dd-name">{{ isAr?c.nameAr:c.name }}</span></button></div>
        </div></div></div>
        <div class="calc-swap-wrap"><button @click="swapCalc" class="calc-swap-btn">⇅</button></div>
        <div class="calc-field"><label class="calc-lbl">{{ t.calcGets }}</label><div class="calc-row"><div class="calc-result">{{ calcResult }}</div><div class="calc-dd-wrap" @click="showToDD=!showToDD"><span class="calc-flag">{{ currencies[calcTo].flag }}</span><span class="calc-code">{{ currencies[calcTo].code }}</span><span class="calc-chev">▾</span>
          <div v-if="showToDD" class="calc-dd"><button v-for="(c,i) in currencies" :key="c.code" @click.stop="pickTo(i)" class="calc-dd-item"><span>{{ c.flag }}</span><span>{{ c.code }}</span><span class="calc-dd-name">{{ isAr?c.nameAr:c.name }}</span></button></div>
        </div></div></div>
        <div class="calc-details"><div class="calc-det-row"><span>{{ t.calcFee }}</span><span class="calc-det-val">{{ calcFee }} {{ currencies[calcFrom].code }}</span></div><div class="calc-det-row"><span>{{ t.calcExRate }}</span><span class="calc-det-val calc-det-green">1 {{ currencies[calcFrom].code }} = {{ calcRate }} {{ currencies[calcTo].code }}</span></div><div class="calc-det-row calc-det-border"><span>{{ t.calcArrival }}</span><span class="calc-det-val">⚡ {{ t.calcSecs }}</span></div></div>
        <button class="calc-cta">{{ t.calcCta }}</button>
      </div>
    </div>
  </div>
</div></section>

<!-- ═══════════ 7. APP FEATURES (dark) ═══════════ -->
<section class="sec-dark app-sec"><div class="app-glow1"></div><div class="app-glow2"></div><div class="sw app-grid" style="position:relative;z-index:1">
  <div class="app-left">
    <div class="app-badge an">{{ t.appTag }}</div>
    <h2 class="app-title an" style="transition-delay:.1s">{{ t.appTitle }}</h2>
    <p class="app-sub an" style="transition-delay:.2s">{{ t.appSub }}</p>
    <div class="app-feats" data-stagger><div v-for="f in t.appFeats" :key="f.t" class="app-feat"><div class="af-ic">{{ f.ic }}</div><div><h4 class="af-t">{{ f.t }}</h4><p class="af-d">{{ f.d }}</p></div></div></div>
    <div class="app-dl an" style="transition-delay:.5s">
      <a href="#" class="dl-gplay"><svg class="dl-svg" viewBox="0 0 24 24" fill="currentColor"><path d="M3.609 1.814L13.792 12 3.61 22.186a.996.996 0 01-.61-.92V2.734a1 1 0 01.609-.92zm10.89 10.893l2.302 2.302-10.937 6.333 8.635-8.635zm3.199-3.198l2.807 1.626a1 1 0 010 1.73l-2.808 1.626L15.206 12l2.492-2.491zM5.864 2.658L16.8 8.99l-2.302 2.302-8.634-8.634z"/></svg><div><p class="dl-sm">{{ isAr?'متوفر على':'Get it on' }}</p><p class="dl-lg">Google Play</p></div></a>
      <a href="#" class="dl-apple"><svg class="dl-svg dl-svg-dark" viewBox="0 0 24 24" fill="currentColor"><path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09zM13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/></svg><div><p class="dl-sm-dark">{{ isAr?'حمّل من':'Download on the' }}</p><p class="dl-lg-dark">App Store</p></div></a>
    </div>
  </div>
  <!-- Phone Mockup -->
  <div class="app-right an-r">
    <div class="phone-float-notif"><div class="pfn-ic">✓</div><div><p class="pfn-sm">{{ t.received }}</p><p class="pfn-amt">+$800.00</p></div></div>
    <div class="phone"><div class="phone-island"></div><div class="phone-screen">
      <div class="ps-status"><span>9:41</span><div class="ps-batt"></div></div>
      <div class="ps-content">
        <p class="ps-bal-lbl">{{ t.balance }}</p><h3 class="ps-bal">$12,485<span>.50</span></h3>
        <div class="ps-actions"><div v-for="(a,i) in [{ic:'↑',lb:t.send,c:'psa-green'},{ic:'↓',lb:t.receive,c:'psa-blue'},{ic:'⬚',lb:t.cards,c:'psa-purple'},{ic:'•••',lb:t.more,c:'psa-gray'}]" :key="i" class="ps-action"><div class="psa-ic" :class="a.c">{{ a.ic }}</div><span class="psa-lb">{{ a.lb }}</span></div></div>
        <p class="ps-tx-lbl">{{ t.recentTx }}</p>
        <div v-for="(tx,i) in [{n:'Netflix',a:'-$15.99',ic:'N',c:'pstx-red'},{n:'Salary',a:'+$3,500',ic:'S',c:'pstx-green',pos:true},{n:'Transfer',a:'-$200',ic:'T',c:'pstx-blue'}]" :key="i" class="ps-tx"><div class="pstx-left"><div class="pstx-ic" :class="tx.c">{{ tx.ic }}</div><span class="pstx-name">{{ tx.n }}</span></div><span class="pstx-amt" :class="{'pstx-pos':tx.pos}">{{ tx.a }}</span></div>
      </div>
    </div></div>
    <div class="phone-float-rating"><span class="pfr-score">4.9</span><span class="pfr-stars">★★★★★</span><span class="pfr-label">App Store</span></div>
  </div>
</div></section>

<!-- ═══════════ 8. GLOBAL COVERAGE (dark) ═══════════ -->
<section class="sec-dark glob-sec"><div class="glob-glow1"></div><div class="glob-glow2"></div>
  <div v-for="(fs,i) in floatingSymbols" :key="i" class="glob-float" :style="{top:fs.top,left:fs.left,right:fs.right,animationDelay:i*0.5+'s'}">{{ fs.s }}</div>
  <div class="sw glob-grid" style="position:relative;z-index:1">
    <div class="glob-left an-l"><span class="pill-green-border">{{ t.globTag }}</span><h2 class="glob-h2">{{ t.globTitle }}<br><span class="glob-hl">{{ t.globHighlight }}</span></h2><p class="glob-p">{{ t.globSub }}</p><Link href="/exchange-rates" class="glob-cta">{{ t.globCta }}</Link></div>
    <div class="glob-right an-r"><div class="flag-grid" data-stagger><div v-for="c in flagGrid" :key="c.n" class="flag-item"><span class="flag-emoji">{{ c.f }}</span><span class="flag-code">{{ c.n }}</span></div></div><div class="flag-more">{{ t.globMore }}</div></div>
  </div>
  <div class="glob-stats an"><div v-for="s in t.globStats" :key="s.l" class="gstat"><p class="gstat-v">{{ s.v }}</p><p class="gstat-l">{{ s.l }}</p></div></div>
</section>

<!-- ═══════════ 9. TRUST (dark) ═══════════ -->
<section class="sec-dark trust-sec"><div class="trust-glow1"></div><div class="trust-glow2"></div><div class="trust-grid-bg"></div>
<div class="sw" style="position:relative;z-index:1">
  <div class="sec-hdr an"><span class="pill-green-border">{{ t.trustTag }}</span><h2 class="t2" style="color:#fff">{{ t.trustTitle }}</h2><p class="t2-sub" style="color:rgba(255,255,255,.7)">{{ t.trustSub }}</p></div>
  <div class="trust-grid" data-stagger><div v-for="ti in t.trustItems" :key="ti.t" class="trust-card"><div class="trust-ic-wrap"><span class="trust-ic">{{ ti.ic }}</span></div><div><h3 class="trust-t">{{ ti.t }}</h3><p class="trust-d">{{ ti.d }}</p></div></div></div>
  <div class="trust-stats an"><div v-for="s in t.trustStats" :key="s.l" class="tstat"><p class="tstat-v">{{ s.v }}</p><p class="tstat-l">{{ s.l }}</p></div></div>
</div></section>

<!-- ═══════════ 10. SECURITY BADGES ═══════════ -->
<section class="sec-light"><div class="sw">
  <div class="sec-hdr an"><span class="pill">{{ t.secTag }}</span><h2 class="t2">{{ t.secTitle }}</h2></div>
  <div class="sec-badges" data-stagger><div v-for="b in t.secBadges" :key="b.t" class="sbadge"><div class="sbadge-ic">{{ b.ic }}</div><h3 class="sbadge-t">{{ b.t }}</h3><p class="sbadge-d">{{ b.d }}</p></div></div>
  <p class="sec-trust-msg an">{{ t.secMsg }}</p>
</div></section>

<!-- ═══════════ 11. TESTIMONIALS ═══════════ -->
<section class="sec-light"><div class="sw">
  <div class="sec-hdr an"><span class="pill">{{ t.testTag }}</span><h2 class="t2">{{ t.testTitle }}</h2><p class="t2-sub">{{ t.testSub }}</p></div>
  <div class="tests-grid" data-stagger><div v-for="(tt,i) in t.tests" :key="i" class="test-card">
    <div class="test-top"><span class="test-quote">❝</span><span class="test-stars">★★★★★</span></div>
    <p class="test-q">"{{ tt.q }}"</p>
    <div class="test-author"><div class="test-avatar" :class="testColors[i]">{{ tt.a }}</div><div><div class="test-name">{{ tt.n }}</div><div class="test-role">{{ tt.r }}</div></div></div>
  </div></div>
  <div class="test-stats-bar an"><div v-for="s in t.testStats" :key="s.l" class="ts-item"><div class="ts-v">{{ s.v }}</div><div class="ts-l">{{ s.l }}</div></div></div>
</div></section>

<!-- ═══════════ 12. FAQ ═══════════ -->
<section class="sec-white"><div class="sw" style="max-width:800px">
  <div class="sec-hdr an"><span class="pill">{{ t.faqTag }}</span><h2 class="t2">{{ t.faqTitle }}</h2></div>
  <div class="faqs an"><div v-for="(f,i) in t.faqs" :key="i" class="faq" :class="{faqOpen:faqOpen===i}" @click="toggleFaq(i)">
    <div class="faq-q"><span>{{ f.q }}</span><span class="faq-arrow">{{ faqOpen===i?'−':'+' }}</span></div>
    <div class="faq-a" v-if="faqOpen===i">{{ f.a }}</div>
  </div></div>
</div></section>

<!-- ═══════════ 13. CTA ═══════════ -->
<section class="sec-cta"><div class="sw tc">
  <h2 class="t2 an">{{ t.ctaTitle }}</h2>
  <p class="t2-sub an tc" style="margin:0 auto 32px">{{ t.ctaSub }}</p>
  <div class="cta-row an"><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a><a href="/support" class="cta-btn2">{{ t.ctaBtn2 }}</a></div>
</div></section>
</template><!-- end v-else personal page -->
</template>

<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec-white{padding:100px 0;background:#fff;position:relative;overflow:hidden}
.sec-light{padding:100px 0;background:#F5F9F3;position:relative;overflow:hidden}
.sec-dark{padding:100px 0;background:linear-gradient(135deg,#163300,#1a3d00,#0f2600);position:relative;overflow:hidden;color:#fff}
.sec-cta{padding:120px 0;background:linear-gradient(135deg,#F0FBE8,#E8F5E0)}
.sec-hdr{text-align:center;margin-bottom:48px}
.pill{display:inline-block;padding:6px 16px;background:#E8F5E0;color:#2D6A00;font-size:12px;font-weight:700;border-radius:999px;margin-bottom:12px;letter-spacing:1px}
.pill-green{display:inline-block;color:#9FE870;font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;margin-bottom:8px}
.pill-green-border{display:inline-block;padding:6px 16px;background:rgba(159,232,112,.2);color:#9FE870;font-size:12px;font-weight:700;border-radius:999px;margin-bottom:16px;border:1px solid rgba(159,232,112,.3)}
.t2{font-size:clamp(1.8rem,4vw,3rem);font-weight:900;line-height:1.1;letter-spacing:-.02em;margin-bottom:16px;color:#163300}.rtl .t2{letter-spacing:0}
.t2-sub{font-size:16px;color:#666;line-height:1.85;max-width:550px;margin:0 auto}
.hero{padding:160px 0 80px;position:relative;overflow:hidden;min-height:100vh;display:flex;align-items:center}
.hero-bg{position:absolute;inset:0;background:linear-gradient(135deg,#E8F5E0,#F0FBE8,#fff)}
.hero-circles{position:absolute;inset:0;overflow:hidden}
.hc{position:absolute;border-radius:50%;filter:blur(80px)}.hc1{top:-20%;right:-10%;width:600px;height:600px;background:rgba(159,232,112,.3);animation:pulse 4s ease-in-out infinite}.hc2{bottom:-20%;left:-10%;width:500px;height:500px;background:rgba(159,232,112,.2);animation:pulse 6s ease-in-out infinite}.hc3{top:40%;left:30%;width:300px;height:300px;background:rgba(22,51,0,.05)}
.hero-grid{display:grid;grid-template-columns:1.1fr 1fr;gap:48px;align-items:center;position:relative;z-index:1}
.hero-tag{display:inline-flex;background:rgba(255,255,255,.8);backdrop-filter:blur(8px);border-radius:999px;padding:8px 16px;font-size:13px;font-weight:600;color:#163300;border:1px solid rgba(159,232,112,.3);margin-bottom:24px;box-shadow:0 2px 8px rgba(0,0,0,.04)}
.hero-h1{font-size:clamp(2.5rem,5.5vw,4.5rem);font-weight:900;color:#163300;line-height:1.05;letter-spacing:-.04em;margin-bottom:20px}.hero-em{color:#2D6A00}
.hero-p{font-size:18px;color:#555;line-height:1.85;margin-bottom:24px;max-width:500px}
.hero-cd{display:flex;gap:18px;margin-bottom:28px}
.cd-box{text-align:center}.cd-n{font-size:38px;font-weight:900;color:#163300;line-height:1;font-variant-numeric:tabular-nums}.cd-l{font-size:10px;color:rgba(22,51,0,.4);margin-top:3px;font-weight:700;letter-spacing:1px;text-transform:uppercase}
.hero-eml{display:flex;max-width:420px;border:2px solid #163300;border-radius:999px;overflow:hidden;margin-bottom:28px}
.eml-i{flex:1;padding:14px 20px;border:none;outline:none;font-size:15px;background:transparent;color:#163300;font-family:inherit}.eml-i::placeholder{color:#aaa}
.eml-b{padding:14px 28px;background:#163300;color:#fff;border:none;font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;transition:all .2s;white-space:nowrap}.eml-b:hover{background:#1e4400}
.eml-ok{padding:14px;color:#2D6A00;font-weight:700;font-size:14px}.eml-err{font-size:12px;color:#DC2626;font-weight:700;margin-top:6px}
.rtl .hero-eml{flex-direction:row-reverse}
.hero-right{position:relative}
.tw-glow{position:absolute;inset:0;background:linear-gradient(135deg,rgba(159,232,112,.4),rgba(159,232,112,.2));border-radius:36px;filter:blur(40px);transform:scale(.9);opacity:.6}
.tw{position:relative;background:#fff;border-radius:32px;box-shadow:0 20px 80px rgba(0,0,0,.08);padding:32px;max-width:440px;margin:0 auto;border:1px solid #f0f0f0}
.tw-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px}
.tw-title{font-weight:800;color:#163300;font-size:18px}.tw-instant{background:#F0FDF4;color:#16A34A;font-size:12px;font-weight:600;padding:4px 12px;border-radius:999px}
.tw-field{margin-bottom:8px}.tw-lbl{font-size:13px;font-weight:600;color:#888;margin-bottom:8px;display:block}
.tw-row{display:flex;align-items:center;justify-content:space-between;border:2px solid #f0f0f0;border-radius:16px;padding:16px 20px;transition:all .2s}.tw-row:focus-within{border-color:#9FE870;box-shadow:0 0 0 4px rgba(159,232,112,.1)}
.tw-row-result{background:linear-gradient(to right,#F0FBE8,#E8F5E0);border-color:#9FE870}
.tw-inp{font-size:28px;font-weight:900;color:#163300;border:none;outline:none;background:transparent;width:100%;font-family:inherit}.tw-inp::-webkit-inner-spin-button,.tw-inp::-webkit-outer-spin-button{-webkit-appearance:none}
.tw-result{font-size:28px;font-weight:900;color:#163300;flex:1}
.tw-cur{display:flex;align-items:center;gap:8px;background:#f8f8f8;border-radius:12px;padding:8px 16px;flex-shrink:0;cursor:pointer;transition:background .2s;font-size:18px}.tw-cur:hover{background:#f0f0f0}.tw-cur span{font-weight:700;color:#163300;font-size:14px}
.tw-cur-pick{position:relative;border:1.5px solid rgba(159,232,112,.15)}.tw-cur-pick:hover{border-color:#9FE870}
.tw-cur-arr{font-size:10px!important;color:rgba(10,10,10,.3)!important;font-weight:400!important}
.tw-dd{position:absolute;top:calc(100% + 6px);left:0;right:0;min-width:200px;background:#fff;border:1px solid rgba(159,232,112,.1);border-radius:14px;box-shadow:0 12px 36px rgba(0,0,0,.12);padding:6px;z-index:100;max-height:260px;overflow-y:auto}
.rtl .tw-dd{left:auto;right:0}
.tw-dd-item{display:flex;align-items:center;gap:8px;padding:8px 12px;border-radius:8px;cursor:pointer;font-size:15px;transition:background .15s}.tw-dd-item:hover{background:rgba(159,232,112,.06)}.tw-dd-item span{font-weight:700;font-size:13px;color:#163300}
.tw-dd-active{background:rgba(159,232,112,.1)!important}
.tw-cur-result{background:#fff;box-shadow:0 2px 8px rgba(0,0,0,.06)}
.tw-swap{position:relative;padding:12px 0;display:flex;align-items:center;justify-content:center}
.tw-swap-circle{width:40px;height:40px;background:#163300;border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-size:18px;font-weight:700;box-shadow:0 4px 12px rgba(22,51,0,.2);z-index:1}
.tw-line{position:absolute;top:50%;left:0;right:0;height:1px;border-top:1px dashed #e0e0e0}
.tw-info{display:flex;justify-content:space-between;padding:0 8px;margin-bottom:8px;font-size:13px;color:#888}.tw-info span:first-child{color:#16A34A}
.tw-delivery{display:flex;justify-content:space-between;padding:12px 16px;background:#f8f8f8;border-radius:12px;margin:16px 0;font-size:13px;color:#888}.tw-bold{font-weight:800;color:#163300}
.tw-cta{display:block;padding:16px;background:#163300;color:#fff;font-size:15px;font-weight:800;text-align:center;border-radius:16px;text-decoration:none;transition:all .2s;margin-bottom:16px}.tw-cta:hover{background:#1e4400;transform:translateY(-2px);box-shadow:0 8px 24px rgba(22,51,0,.15)}
.tw-badges{display:flex;justify-content:center;gap:8px;font-size:11px;color:#aaa}
.partners-sec{padding:80px 0}.partners-glow{position:absolute;top:0;left:25%;width:500px;height:500px;background:#9FE870;border-radius:50%;filter:blur(150px);opacity:.3;animation:pulse 4s ease-in-out infinite}
.part-title{font-size:clamp(1.2rem,2.5vw,1.5rem);color:#fff;font-weight:500;text-align:center}
.mq-wrap{overflow:hidden;margin:32px 0}.mq-track{display:flex;gap:16px;animation:mqs 20s linear infinite;white-space:nowrap}
.mq-item{flex-shrink:0;padding:12px 32px;background:rgba(255,255,255,.1);backdrop-filter:blur(8px);border:1px solid rgba(255,255,255,.1);border-radius:12px;color:rgba(255,255,255,.8);font-size:16px;font-weight:700;letter-spacing:1px;cursor:pointer;transition:background .3s}.mq-item:hover{background:rgba(255,255,255,.2)}
@keyframes mqs{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}
.part-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:24px;text-align:center;margin-top:40px}
.pstat-v{font-size:clamp(1.8rem,3vw,2.5rem);font-weight:900;color:#9FE870;margin-bottom:4px}.pstat-l{font-size:13px;color:rgba(255,255,255,.7)}
.steps-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;position:relative}
.steps-line{display:none;position:absolute;top:36px;left:10%;right:10%;height:4px;background:linear-gradient(to right,#3B82F6,#8B5CF6,#F59E0B,#22C55E);border-radius:2px}@media(min-width:1024px){.steps-line{display:block}}
.step-num{width:72px;height:72px;border-radius:20px;display:flex;align-items:center;justify-content:center;font-size:22px;font-weight:900;color:#fff;margin-bottom:14px;box-shadow:0 8px 20px rgba(0,0,0,.1);transition:all .4s;position:relative;z-index:1}.step-num:hover{transform:scale(1.1) rotate(6deg)}
.sc-blue{background:linear-gradient(135deg,#3B82F6,#2563EB)}.sc-purple{background:linear-gradient(135deg,#8B5CF6,#7C3AED)}.sc-amber{background:linear-gradient(135deg,#F59E0B,#EA580C)}.sc-green{background:linear-gradient(135deg,#22C55E,#10B981)}
.step-card{border-radius:16px;padding:20px;transition:all .3s}.step-card:hover{box-shadow:0 8px 24px rgba(0,0,0,.06)}
.sb-blue{background:#EFF6FF}.sb-purple{background:#F5F3FF}.sb-amber{background:#FFFBEB}.sb-green{background:#F0FDF4}
.step-t{font-size:17px;font-weight:800;color:#163300;margin-bottom:8px}.step-d{font-size:14px;color:#666;line-height:1.7}
.sec-feat-bg{overflow:hidden;position:relative}.sec-feat-glow1{position:absolute;top:0;left:0;width:100%;height:128px;background:linear-gradient(to bottom,#F0FBE8,transparent)}.sec-feat-glow2{position:absolute;bottom:0;right:0;width:384px;height:384px;background:rgba(159,232,112,.1);border-radius:50%;filter:blur(100px)}
.feats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px}
.feat{padding:24px;background:#fff;border:2px solid #f0f0f0;border-radius:24px;transition:all .4s;cursor:pointer}.feat:hover{border-color:#9FE870;transform:translateY(-6px);box-shadow:0 16px 40px rgba(159,232,112,.15)}
.feat-ic{font-size:32px;display:block;margin-bottom:12px;transition:transform .3s}.feat:hover .feat-ic{transform:scale(1.15) rotate(6deg)}
.feat-t{font-size:16px;font-weight:800;color:#163300;margin-bottom:6px;transition:color .3s}.feat:hover .feat-t{color:#2D6A00}
.feat-d{font-size:13px;color:#666;line-height:1.7}
.comp-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.comp-card{background:#fff;border-radius:24px;padding:28px;border:1px solid #e8e8e8;position:relative;transition:all .3s}
.comp-best{border:2px solid #9FE870;box-shadow:0 16px 40px rgba(159,232,112,.15)}
.comp-badge{position:absolute;top:-14px;left:50%;transform:translateX(-50%);padding:6px 18px;background:linear-gradient(135deg,#163300,#2D6A00);color:#fff;font-size:11px;font-weight:800;border-radius:999px;white-space:nowrap;box-shadow:0 4px 12px rgba(22,51,0,.2)}
.comp-logo{display:flex;align-items:center;gap:10px;margin-bottom:20px}
.comp-sdb-icon{width:48px;height:48px;background:linear-gradient(135deg,#9FE870,#7ACC50);border-radius:14px;display:flex;align-items:center;justify-content:center;font-weight:800;color:#163300;font-size:13px;box-shadow:0 4px 12px rgba(159,232,112,.3)}
.comp-name{font-weight:800;color:#163300;font-size:16px}.comp-rec{font-size:11px;color:#2D6A00}
.comp-dim{opacity:.75;transition:opacity .3s}.comp-dim:hover{opacity:1}
.comp-dim-icon{width:48px;height:48px;background:#f0f0f0;border-radius:14px;display:flex;align-items:center;justify-content:center;font-weight:800;color:#aaa;font-size:12px}
.comp-wu-icon{width:48px;height:48px;background:#FEF9E7;border:1px solid #F59E0B;border-radius:14px;display:flex;align-items:center;justify-content:center;font-weight:800;color:#D97706;font-size:12px}
.comp-name-dim{font-weight:800;color:#888;font-size:16px}
.comp-amt-box{margin-bottom:20px;padding-bottom:20px;border-bottom:1px solid #f0f0f0}.comp-amt-lbl{display:block;font-size:12px;color:#888;margin-bottom:4px}
.comp-amt-val{font-size:28px;font-weight:900;color:#163300}.comp-amt-val small{font-size:14px;color:#888;margin-inline-start:4px}
.comp-amt-dim{font-size:28px;font-weight:900;color:#bbb}.comp-amt-dim small{font-size:14px}
.comp-less{display:block;font-size:11px;color:#EF4444;margin-top:2px}
.comp-pts{list-style:none;padding:0;margin:0 0 20px;display:flex;flex-direction:column;gap:10px}
.comp-pts li{display:flex;align-items:center;gap:8px;font-size:13px;font-weight:600;color:#333}
.ck{width:22px;height:22px;background:#E8F5E0;border-radius:50%;display:flex;align-items:center;justify-content:center;color:#2D6A00;font-size:12px;font-weight:900;flex-shrink:0}
.comp-pts-dim{list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:10px}
.comp-pts-dim li{display:flex;align-items:center;gap:8px;font-size:13px;color:#aaa}
.xx{width:22px;height:22px;background:#FEE2E2;border-radius:50%;display:flex;align-items:center;justify-content:center;color:#EF4444;font-size:12px;font-weight:900;flex-shrink:0}
.comp-cta{display:block;padding:14px;background:#163300;color:#fff;text-align:center;border-radius:14px;font-weight:800;font-size:14px;text-decoration:none;transition:all .2s}.comp-cta:hover{background:#1e4400;box-shadow:0 8px 20px rgba(22,51,0,.15)}
.sec-calc{padding:100px 0;background:#F8FBF5;position:relative;overflow:hidden}
.sec-calc-glow1{position:absolute;top:0;right:0;width:600px;height:600px;background:rgba(159,232,112,.1);border-radius:50%;filter:blur(150px)}.sec-calc-glow2{position:absolute;bottom:0;left:0;width:400px;height:400px;background:rgba(22,51,0,.05);border-radius:50%;filter:blur(100px)}
.calc-grid{display:grid;grid-template-columns:1fr 1fr;gap:64px;align-items:center}
.calc-benefits{display:flex;flex-direction:column;gap:12px}
.calc-ben{display:flex;align-items:flex-start;gap:16px;padding:16px;background:#fff;border:1px solid #f0f0f0;border-radius:16px}
.calc-ben-ic{width:48px;height:48px;border-radius:12px;background:#E8F5E0;display:flex;align-items:center;justify-content:center;font-size:22px;flex-shrink:0}
.calc-ben-t{font-weight:700;color:#163300;margin-bottom:2px;font-size:14px}.calc-ben-d{font-size:13px;color:#888}
.calc-card{background:#fff;border-radius:24px;box-shadow:0 20px 60px rgba(22,51,0,.08);padding:32px;border:1px solid #f0f0f0}
.calc-field{margin-bottom:8px}.calc-lbl{font-size:12px;font-weight:600;color:#888;margin-bottom:8px;display:block}
.calc-row{display:flex;gap:12px}
.calc-inp{flex:1;font-size:28px;font-weight:900;color:#163300;background:#f8f8f8;border:2px solid #f0f0f0;border-radius:16px;padding:16px 20px;outline:none;font-family:inherit;transition:all .2s}.calc-inp:focus{border-color:#9FE870;box-shadow:0 0 0 4px rgba(159,232,112,.15)}
.calc-inp::-webkit-inner-spin-button,.calc-inp::-webkit-outer-spin-button{-webkit-appearance:none}.calc-inp{-moz-appearance:textfield}
.calc-result{flex:1;font-size:28px;font-weight:900;color:#163300;background:#E8F5E0;border:2px solid rgba(159,232,112,.3);border-radius:16px;padding:16px 20px}
.calc-dd-wrap{position:relative;display:flex;align-items:center;gap:8px;background:#f8f8f8;border:2px solid #f0f0f0;border-radius:16px;padding:12px 16px;cursor:pointer;transition:border-color .2s}.calc-dd-wrap:hover{border-color:#ccc}
.calc-flag{font-size:22px}.calc-code{font-weight:700;color:#163300;font-size:14px}.calc-chev{font-size:12px;color:#888}
.calc-dd{position:absolute;top:calc(100% + 8px);right:0;background:#fff;border-radius:16px;box-shadow:0 12px 40px rgba(0,0,0,.12);border:1px solid #f0f0f0;padding:8px;width:200px;z-index:50;max-height:256px;overflow-y:auto}.rtl .calc-dd{right:auto;left:0}
.calc-dd-item{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;width:100%;border:none;background:none;cursor:pointer;font-family:inherit;font-size:14px;font-weight:600;color:#163300;transition:background .2s}.calc-dd-item:hover{background:#f8f8f8}
.calc-dd-name{font-size:11px;color:#888;font-weight:400}
.calc-swap-wrap{display:flex;justify-content:center;margin:-6px 0;position:relative;z-index:2}
.calc-swap-btn{width:48px;height:48px;background:#9FE870;border:none;border-radius:50%;font-size:18px;font-weight:700;color:#163300;cursor:pointer;box-shadow:0 4px 16px rgba(159,232,112,.3);transition:all .2s}.calc-swap-btn:hover{transform:scale(1.1)}
.calc-details{background:#f8f8f8;border-radius:16px;padding:20px;margin:20px 0;display:flex;flex-direction:column;gap:10px}
.calc-det-row{display:flex;justify-content:space-between;font-size:13px;color:#888}.calc-det-val{font-weight:700;color:#163300}.calc-det-green{color:#2D6A00}
.calc-det-border{padding-top:10px;border-top:1px solid #e8e8e8}
.calc-cta{width:100%;padding:16px;background:#9FE870;color:#163300;font-size:15px;font-weight:800;border:none;border-radius:16px;cursor:pointer;font-family:inherit;transition:all .2s}.calc-cta:hover{background:#8FD860;box-shadow:0 8px 24px rgba(159,232,112,.3);transform:translateY(-2px)}
.app-sec{padding:100px 0}.app-glow1{position:absolute;top:0;right:0;width:600px;height:600px;background:rgba(159,232,112,.1);border-radius:50%;filter:blur(150px)}.app-glow2{position:absolute;bottom:0;left:0;width:500px;height:500px;background:rgba(159,232,112,.05);border-radius:50%;filter:blur(120px)}
.app-grid{display:grid;grid-template-columns:1fr 1fr;gap:48px;align-items:center}
.app-badge{display:inline-block;padding:8px 20px;background:#2d5a00;border-radius:999px;color:#9FE870;font-size:13px;font-weight:700;margin-bottom:24px}
.app-title{font-size:clamp(2rem,4vw,3.5rem);font-weight:900;color:#fff;margin-bottom:16px;line-height:1.1}
.app-sub{color:rgba(255,255,255,.6);font-size:16px;line-height:1.8;margin-bottom:32px;max-width:500px}
.app-feats{display:grid;grid-template-columns:repeat(2,1fr);gap:12px;margin-bottom:32px}
.app-feat{display:flex;align-items:center;gap:12px;padding:14px;background:rgba(30,77,0,.6);border:1px solid rgba(159,232,112,.1);border-radius:16px;transition:all .3s}.app-feat:hover{border-color:rgba(159,232,112,.3);background:rgba(30,77,0,.8)}
.af-ic{width:44px;height:44px;border-radius:12px;background:rgba(159,232,112,.2);display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0;transition:background .3s}.app-feat:hover .af-ic{background:rgba(159,232,112,.3)}
.af-t{font-weight:700;color:#fff;font-size:13px;margin-bottom:2px}.af-d{font-size:11px;color:rgba(255,255,255,.5)}
.app-dl{display:flex;gap:12px;flex-wrap:wrap}
.dl-gplay{display:flex;align-items:center;gap:12px;padding:12px 24px;background:#1e4d00;border:1px solid rgba(159,232,112,.3);border-radius:12px;text-decoration:none;transition:all .2s}.dl-gplay:hover{background:#2d5a00}
.dl-apple{display:flex;align-items:center;gap:12px;padding:12px 24px;background:#fff;border-radius:12px;text-decoration:none;transition:all .2s}.dl-apple:hover{background:#f8f8f8}
.dl-svg{width:28px;height:28px;color:#fff;flex-shrink:0}.dl-svg-dark{color:#000}
.dl-sm{font-size:9px;color:rgba(255,255,255,.5)}.dl-lg{font-size:13px;font-weight:800;color:#fff}
.dl-sm-dark{font-size:9px;color:#888}.dl-lg-dark{font-size:13px;font-weight:800;color:#111}
.app-right{position:relative;display:flex;justify-content:center}
.phone{position:relative;width:300px;background:#1a1a1a;border-radius:52px;padding:10px;box-shadow:0 20px 60px rgba(0,0,0,.5)}
.phone-island{position:absolute;top:10px;left:50%;transform:translateX(-50%);width:112px;height:32px;background:#000;border-radius:999px;z-index:20}
.phone-screen{background:linear-gradient(to bottom,#1a3d0c,#0f2506);border-radius:44px;overflow:hidden;aspect-ratio:9/19.5}
.ps-status{display:flex;justify-content:space-between;align-items:center;padding:20px 40px 12px;font-size:12px;color:rgba(255,255,255,.8);font-weight:600}
.ps-batt{width:24px;height:12px;border:2px solid rgba(255,255,255,.8);border-radius:3px;position:relative}.ps-batt::after{content:'';position:absolute;inset:2px;width:70%;background:rgba(255,255,255,.8);border-radius:1px}.ps-batt::before{content:'';position:absolute;right:-4px;top:50%;transform:translateY(-50%);width:2px;height:6px;background:rgba(255,255,255,.8);border-radius:0 1px 1px 0}
.ps-content{padding:16px 24px}
.ps-bal-lbl{color:rgba(255,255,255,.5);font-size:12px;margin-bottom:4px}.ps-bal{font-size:32px;font-weight:900;color:#fff;margin-bottom:28px}.ps-bal span{font-size:20px;color:rgba(255,255,255,.6)}
.ps-actions{display:flex;justify-content:space-between;margin-bottom:28px}
.ps-action{display:flex;flex-direction:column;align-items:center;gap:6px}
.psa-ic{width:48px;height:48px;border-radius:16px;display:flex;align-items:center;justify-content:center;color:#9FE870;font-weight:700;font-size:16px}
.psa-green{background:rgba(45,90,0,.6)}.psa-blue{background:rgba(30,60,120,.6)}.psa-purple{background:rgba(80,40,120,.6)}.psa-gray{background:rgba(60,60,60,.6)}
.psa-lb{font-size:10px;color:rgba(255,255,255,.5)}
.ps-tx-lbl{font-size:12px;color:rgba(255,255,255,.5);margin-bottom:12px}
.ps-tx{display:flex;justify-content:space-between;align-items:center;padding:10px 12px;background:rgba(45,90,0,.3);border-radius:14px;margin-bottom:8px}
.pstx-left{display:flex;align-items:center;gap:10px}
.pstx-ic{width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:12px;color:#fff}
.pstx-red{background:#EF4444}.pstx-green{background:#9FE870;color:#163300}.pstx-blue{background:#3B82F6}
.pstx-name{font-size:13px;font-weight:600;color:#fff}
.pstx-amt{font-size:13px;font-weight:800;color:#fff}.pstx-pos{color:#9FE870}
.phone-float-notif{position:absolute;top:-8px;right:-16px;z-index:30;display:flex;align-items:center;gap:10px;padding:12px 16px;background:#fff;border-radius:16px;box-shadow:0 12px 40px rgba(0,0,0,.15);animation:float 3s ease-in-out infinite}
.pfn-ic{width:40px;height:40px;background:#9FE870;border-radius:50%;display:flex;align-items:center;justify-content:center;color:#163300;font-weight:900;font-size:16px}
.pfn-sm{font-size:10px;color:#888}.pfn-amt{font-size:16px;font-weight:900;color:#111}
.phone-float-rating{position:absolute;bottom:-20px;right:16px;z-index:20;display:flex;align-items:center;gap:6px;padding:8px 16px;background:#fff;border-radius:12px;box-shadow:0 8px 24px rgba(0,0,0,.12)}
.pfr-score{font-size:18px;font-weight:900;color:#111}.pfr-stars{color:#F59E0B;font-size:12px;letter-spacing:1px}.pfr-label{font-size:10px;color:#888}
@keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
.glob-sec{padding:100px 0}.glob-glow1{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:800px;height:800px;opacity:.1}.glob-glow2{position:absolute;bottom:0;left:0;width:500px;height:500px;background:rgba(159,232,112,.05);border-radius:50%;filter:blur(120px)}
.glob-float{position:absolute;width:56px;height:56px;background:rgba(255,255,255,.1);backdrop-filter:blur(8px);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:22px;border:1px solid rgba(255,255,255,.2);animation:float 4s ease-in-out infinite;z-index:1}
.glob-grid{display:grid;grid-template-columns:1fr 1fr;gap:64px;align-items:center}
.glob-h2{font-size:clamp(2rem,4vw,3rem);font-weight:900;color:#fff;line-height:1.1;margin-bottom:16px}.glob-hl{color:#9FE870}
.glob-p{font-size:16px;color:rgba(255,255,255,.7);line-height:1.85;margin-bottom:24px}
.glob-cta{display:inline-block;padding:14px 32px;background:#9FE870;color:#163300;font-weight:800;font-size:14px;border-radius:999px;text-decoration:none;transition:all .3s;box-shadow:0 4px 16px rgba(159,232,112,.3)}.glob-cta:hover{background:#8FD860;transform:scale(1.05);box-shadow:0 8px 24px rgba(159,232,112,.4)}
.flag-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.flag-item{background:rgba(255,255,255,.1);backdrop-filter:blur(8px);border:1px solid rgba(255,255,255,.1);border-radius:16px;padding:16px;text-align:center;transition:all .3s;cursor:pointer}.flag-item:hover{background:rgba(255,255,255,.2);border-color:rgba(159,232,112,.3);transform:scale(1.1) translateY(-4px)}
.flag-emoji{font-size:28px;display:block;margin-bottom:6px;transition:transform .3s}.flag-item:hover .flag-emoji{transform:scale(1.25)}
.flag-code{font-size:13px;font-weight:700;color:#fff}
.flag-more{margin-top:12px;padding:12px;background:linear-gradient(to right,rgba(159,232,112,.2),rgba(159,232,112,.1));border:1px solid rgba(159,232,112,.3);border-radius:16px;text-align:center;color:#9FE870;font-weight:700;font-size:14px;cursor:pointer;transition:all .3s}.flag-more:hover{background:linear-gradient(to right,rgba(159,232,112,.3),rgba(159,232,112,.2))}
.glob-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:24px;padding:32px;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.1);border-radius:24px;backdrop-filter:blur(8px);margin-top:64px;max-width:1200px;margin-left:auto;margin-right:auto;padding-left:24px;padding-right:24px}
.gstat{text-align:center}.gstat-v{font-size:clamp(1.5rem,3vw,2.5rem);font-weight:900;color:#9FE870;margin-bottom:4px;transition:transform .3s}.gstat:hover .gstat-v{transform:scale(1.1)}.gstat-l{font-size:13px;color:rgba(255,255,255,.6)}
.trust-sec{padding:100px 0}.trust-glow1{position:absolute;top:0;right:0;width:600px;height:600px;background:rgba(159,232,112,.1);border-radius:50%;filter:blur(150px);animation:pulse 6s ease-in-out infinite}.trust-glow2{position:absolute;bottom:0;left:0;width:500px;height:500px;background:rgba(159,232,112,.05);border-radius:50%;filter:blur(120px);animation:pulse 8s ease-in-out infinite}
.trust-grid-bg{position:absolute;inset:0;opacity:.03;background-image:url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none'%3E%3Cg fill='%23ffffff'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")}
.trust-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:16px;margin-bottom:48px}
.trust-card{display:flex;align-items:flex-start;gap:20px;padding:32px;background:rgba(255,255,255,.05);backdrop-filter:blur(8px);border:1px solid rgba(255,255,255,.1);border-radius:24px;transition:all .4s;cursor:pointer}.trust-card:hover{background:rgba(255,255,255,.1);border-color:rgba(159,232,112,.3);transform:translateY(-4px)}
.trust-ic-wrap{width:64px;height:64px;border-radius:16px;background:linear-gradient(135deg,#9FE870,#7ACC50);display:flex;align-items:center;justify-content:center;font-size:28px;flex-shrink:0;box-shadow:0 8px 20px rgba(159,232,112,.2);transition:all .4s}.trust-card:hover .trust-ic-wrap{transform:scale(1.1) rotate(3deg)}
.trust-t{font-size:18px;font-weight:800;color:#fff;margin-bottom:6px;transition:color .3s}.trust-card:hover .trust-t{color:#9FE870}
.trust-d{font-size:14px;color:rgba(255,255,255,.6);line-height:1.7}
.trust-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.tstat{text-align:center;padding:24px;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.1);border-radius:16px;transition:all .3s}.tstat:hover{background:rgba(255,255,255,.1);border-color:rgba(159,232,112,.3)}
.tstat-v{font-size:clamp(1.5rem,3vw,2.5rem);font-weight:900;color:#9FE870;margin-bottom:4px;transition:transform .3s}.tstat:hover .tstat-v{transform:scale(1.1)}
.tstat-l{font-size:13px;color:rgba(255,255,255,.6)}
.sec-badges{display:grid;grid-template-columns:repeat(6,1fr);gap:12px}
.sbadge{text-align:center;padding:24px 16px;background:#fff;border:1px solid #f0f0f0;border-radius:20px;transition:all .3s;cursor:pointer;position:relative;overflow:hidden}.sbadge:hover{border-color:rgba(159,232,112,.5);transform:translateY(-6px);box-shadow:0 12px 32px rgba(159,232,112,.1)}
.sbadge-ic{font-size:28px;margin-bottom:12px;transition:transform .3s}.sbadge:hover .sbadge-ic{transform:scale(1.15)}
.sbadge-t{font-weight:800;color:#163300;margin-bottom:4px;font-size:14px}.sbadge-d{font-size:11px;color:#888;line-height:1.5}
.sec-trust-msg{text-align:center;color:#888;margin-top:40px}
.tests-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:16px}
.test-card{background:#fff;border-radius:24px;padding:28px;border:1px solid #e8e8e8;transition:all .4s;cursor:pointer}.test-card:hover{border-color:rgba(159,232,112,.3);box-shadow:0 16px 40px rgba(0,0,0,.06);transform:translateY(-3px)}
.test-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:16px}
.test-quote{font-size:36px;color:rgba(159,232,112,.3);line-height:1;font-weight:900}.test-stars{color:#F59E0B;font-size:14px;letter-spacing:2px}
.test-q{font-size:16px;color:#333;line-height:1.8;margin-bottom:20px}
.test-author{display:flex;align-items:center;gap:12px}
.test-avatar{width:48px;height:48px;border-radius:16px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:16px;transition:transform .3s;box-shadow:0 4px 12px rgba(0,0,0,.1)}.test-card:hover .test-avatar{transform:scale(1.1)}
.tc-blue{background:linear-gradient(135deg,#60A5FA,#3B82F6)}.tc-purple{background:linear-gradient(135deg,#A78BFA,#8B5CF6)}.tc-green{background:linear-gradient(135deg,#4ADE80,#22C55E)}.tc-orange{background:linear-gradient(135deg,#FB923C,#F97316)}
.test-name{font-weight:800;color:#163300;font-size:15px}.test-role{font-size:12px;color:#888}
.test-stats-bar{margin-top:40px;background:#fff;border-radius:24px;padding:28px;border:1px solid #e8e8e8;display:grid;grid-template-columns:repeat(4,1fr);gap:16px;text-align:center}
.ts-v{font-size:24px;font-weight:900;color:#163300;margin-bottom:2px}.ts-l{font-size:12px;color:#888}
.faqs{display:flex;flex-direction:column;gap:8px}
.faq{background:#fff;border:1px solid #e8e8e8;border-radius:16px;padding:16px 20px;cursor:pointer;transition:all .3s}.faq:hover,.faqOpen{border-color:#9FE870;box-shadow:0 4px 16px rgba(159,232,112,.1)}
.faq-q{display:flex;justify-content:space-between;align-items:center;font-size:15px;font-weight:700;color:#163300}
.faq-arrow{font-size:20px;color:#9FE870;font-weight:300;flex-shrink:0;margin-inline-start:16px}
.faq-a{margin-top:12px;font-size:14px;color:#666;line-height:1.8;padding-top:12px;border-top:1px solid #f0f0f0}
.cta-row{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}
.cta-btn{display:inline-block;padding:18px 48px;background:#163300;color:#fff;font-size:16px;font-weight:800;border-radius:999px;text-decoration:none;transition:all .3s}.cta-btn:hover{background:#1e4400;transform:translateY(-2px);box-shadow:0 12px 32px rgba(22,51,0,.15)}
.cta-btn2{display:inline-block;padding:18px 48px;background:transparent;color:#163300;font-size:16px;font-weight:800;border-radius:999px;text-decoration:none;border:2px solid rgba(22,51,0,.15);transition:all .2s}.cta-btn2:hover{border-color:#163300}
.an{opacity:0;transform:translateY(28px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an.vi{opacity:1;transform:none}
.an-l{opacity:0;transform:translateX(-40px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an-l.vi{opacity:1;transform:none}
.an-r{opacity:0;transform:translateX(40px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}.an-r.vi{opacity:1;transform:none}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.5}}
@media(max-width:1024px){.sec-badges{grid-template-columns:repeat(3,1fr)}}
@media(max-width:900px){.hero-grid{grid-template-columns:1fr;gap:32px;text-align:center}.hero-left{display:flex;flex-direction:column;align-items:center}.hero-p{text-align:center}.steps-grid{grid-template-columns:repeat(2,1fr)}.feats-grid{grid-template-columns:repeat(2,1fr)}.comp-grid{grid-template-columns:1fr}.tests-grid{grid-template-columns:1fr}.calc-grid{grid-template-columns:1fr}.app-grid{grid-template-columns:1fr}.app-feats{grid-template-columns:1fr}.glob-grid{grid-template-columns:1fr;text-align:center}.glob-left{display:flex;flex-direction:column;align-items:center}.trust-grid{grid-template-columns:1fr}.trust-stats,.glob-stats,.part-stats{grid-template-columns:repeat(2,1fr)}.sec-badges{grid-template-columns:repeat(2,1fr)}}
@media(max-width:600px){.hero{padding:120px 0 40px}.sec-white,.sec-light,.sec-dark,.sec-calc{padding:60px 0}.sw{padding:0 16px}.t2{font-size:clamp(1.4rem,6vw,2rem)}.steps-grid,.feats-grid,.sec-badges{grid-template-columns:1fr}.hero-cd{flex-wrap:wrap;gap:12px;justify-content:center}.cd-n{font-size:28px}.hero-eml{flex-direction:column!important;border:none!important;border-radius:0!important;overflow:visible!important;gap:10px}.eml-i{border:2px solid #163300!important;border-radius:14px!important;background:#fff!important}.eml-b{border-radius:14px!important;width:100%}.cta-btn,.cta-btn2{width:100%;text-align:center;padding:16px}.cta-row{flex-direction:column;padding:0 16px}.phone{width:260px;border-radius:44px}.phone-island{width:96px;height:28px}.phone-float-notif{right:-8px;padding:8px 12px}.flag-grid{grid-template-columns:repeat(2,1fr)}.glob-float{display:none}.test-stats-bar{grid-template-columns:repeat(2,1fr)}.app-dl{flex-direction:column}.trust-card{flex-direction:column;align-items:center;text-align:center}.part-stats{grid-template-columns:repeat(2,1fr);gap:12px}}
</style>
