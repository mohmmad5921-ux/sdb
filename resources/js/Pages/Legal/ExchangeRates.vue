<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed, ref, onMounted } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));

/* ─── Currencies with flags ─── */
const curs = [
  {c:'SYP',f:'🇸🇾',n:'ليرة سورية',en:'Syrian Lira'},
  {c:'EUR',f:'🇪🇺',n:'يورو',en:'Euro'},
  {c:'USD',f:'🇺🇸',n:'دولار أمريكي',en:'US Dollar'},
  {c:'GBP',f:'🇬🇧',n:'جنيه إسترليني',en:'British Pound'},
  {c:'DKK',f:'🇩🇰',n:'كرونة دنماركية',en:'Danish Krone'},
  {c:'SEK',f:'🇸🇪',n:'كرونة سويدية',en:'Swedish Krona'},
  {c:'NOK',f:'🇳🇴',n:'كرونة نرويجية',en:'Norwegian Krone'},
  {c:'CHF',f:'🇨🇭',n:'فرنك سويسري',en:'Swiss Franc'},
  {c:'TRY',f:'🇹🇷',n:'ليرة تركية',en:'Turkish Lira'},
  {c:'AED',f:'🇦🇪',n:'درهم إماراتي',en:'UAE Dirham'},
  {c:'SAR',f:'🇸🇦',n:'ريال سعودي',en:'Saudi Riyal'},
  {c:'KWD',f:'🇰🇼',n:'دينار كويتي',en:'Kuwaiti Dinar'},
  {c:'QAR',f:'🇶🇦',n:'ريال قطري',en:'Qatari Riyal'},
  {c:'BHD',f:'🇧🇭',n:'دينار بحريني',en:'Bahraini Dinar'},
  {c:'OMR',f:'🇴🇲',n:'ريال عماني',en:'Omani Rial'},
  {c:'JOD',f:'🇯🇴',n:'دينار أردني',en:'Jordanian Dinar'},
  {c:'EGP',f:'🇪🇬',n:'جنيه مصري',en:'Egyptian Pound'},
  {c:'LBP',f:'🇱🇧',n:'ليرة لبنانية',en:'Lebanese Pound'},
  {c:'IQD',f:'🇮🇶',n:'دينار عراقي',en:'Iraqi Dinar'},
  {c:'CAD',f:'🇨🇦',n:'دولار كندي',en:'Canadian Dollar'},
  {c:'AUD',f:'🇦🇺',n:'دولار أسترالي',en:'Australian Dollar'},
  {c:'JPY',f:'🇯🇵',n:'ين ياباني',en:'Japanese Yen'},
];

/* Rates vs EUR — fetched live from API */
const ratesVsEUR = ref({SYP:13500,EUR:1,USD:1.08,GBP:0.86,DKK:7.46,SEK:11.2,NOK:11.5,CHF:0.96,TRY:34.2,AED:3.97,SAR:4.05,KWD:0.33,QAR:3.93,BHD:0.41,OMR:0.42,JOD:0.77,EGP:53.2,LBP:96800,IQD:1415,CAD:1.47,AUD:1.65,JPY:162});
const isLive = ref(false);
const updatedAt = ref(null);

onMounted(async () => {
  try {
    const res = await fetch('/api/public/rates');
    const data = await res.json();
    if (data.rates) {
      ratesVsEUR.value = data.rates;
      isLive.value = data.is_live || false;
      updatedAt.value = data.updated_at;
    }
  } catch (e) { /* fallback to hardcoded */ }
});

const fromCur = ref('EUR');
const toCur = ref('SYP');
const fromAmt = ref(1000);
const showFromDD = ref(false);
const showToDD = ref(false);

const rate = computed(() => {
  const fr = ratesVsEUR.value[fromCur.value]||1;
  const to = ratesVsEUR.value[toCur.value]||1;
  return to/fr;
});
const toAmt = computed(() => {
  const v = fromAmt.value * rate.value;
  return v >= 1000 ? Math.round(v).toLocaleString('en-US') : v.toFixed(2);
});
const rateDisplay = computed(() => {
  const r = rate.value;
  return r >= 100 ? Math.round(r).toLocaleString('en-US') : r >= 1 ? r.toFixed(4) : r.toFixed(6);
});
const fee = computed(() => {
  const f = fromAmt.value * 0.003;
  return f < 1 ? f.toFixed(2) : Math.round(f).toLocaleString('en-US');
});
const bankFee = computed(() => {
  const f = fromAmt.value * 0.035;
  return f < 1 ? f.toFixed(2) : Math.round(f).toLocaleString('en-US');
});
const savings = computed(() => {
  const s = fromAmt.value * 0.032;
  return s < 1 ? s.toFixed(2) : Math.round(s).toLocaleString('en-US');
});
const fromObj = computed(() => curs.find(c => c.c === fromCur.value) || curs[1]);
const toObj = computed(() => curs.find(c => c.c === toCur.value) || curs[0]);

function swapCur(){ const tmp = fromCur.value; fromCur.value = toCur.value; toCur.value = tmp; }
function selectFrom(c){ fromCur.value = c; showFromDD.value = false; }
function selectTo(c){ toCur.value = c; showToDD.value = false; }

/* Popular pairs */
const popularPairs = [
  {from:'EUR',to:'SYP',f1:'🇪🇺',f2:'🇸🇾'},{from:'USD',to:'SYP',f1:'🇺🇸',f2:'🇸🇾'},
  {from:'GBP',to:'SYP',f1:'🇬🇧',f2:'🇸🇾'},{from:'TRY',to:'SYP',f1:'🇹🇷',f2:'🇸🇾'},
  {from:'AED',to:'SYP',f1:'🇦🇪',f2:'🇸🇾'},{from:'SAR',to:'SYP',f1:'🇸🇦',f2:'🇸🇾'},
  {from:'EUR',to:'USD',f1:'🇪🇺',f2:'🇺🇸'},{from:'EUR',to:'GBP',f1:'🇪🇺',f2:'🇬🇧'},
  {from:'USD',to:'TRY',f1:'🇺🇸',f2:'🇹🇷'},{from:'EUR',to:'DKK',f1:'🇪🇺',f2:'🇩🇰'},
  {from:'GBP',to:'EUR',f1:'🇬🇧',f2:'🇪🇺'},{from:'USD',to:'JPY',f1:'🇺🇸',f2:'🇯🇵'},
];
function pairRate(from,to){ return ((ratesVsEUR.value[to]||1)/(ratesVsEUR.value[from]||1)); }
function fmtRate(r){ return r >= 100 ? Math.round(r).toLocaleString('en-US') : r >= 1 ? r.toFixed(4) : r.toFixed(6); }
function pickPair(from,to){ fromCur.value=from; toCur.value=to; fromAmt.value=1000; window.scrollTo({top:0,behavior:'smooth'}); }

const t = computed(() => isAr.value ? {
  title:'محوّل العملات — SDB Bank',
  heroTag:'محوّل عملات SDB',heroH:'حوّل أموالك',heroEm:'بأفضل سعر.',
  heroP:'أسعار صرف حقيقية بدون هوامش ربح مخفية. أرسل واستقبل الأموال بأكثر من 25 عملة.',
  youSend:'أنت ترسل',recipientGets:'المستلم يحصل على',
  guaranteed:'⏱ سعر مضمون لمدة 24 ساعة',
  rateLabel:'سعر الصرف',
  arriveLabel:'وقت الوصول',arriveVal:'اليوم — خلال ثوانٍ',
  feeLabel:'رسوم SDB',feeNote:'مشمولة بالمبلغ',
  bankLabel:'رسوم البنوك التقليدية',
  saveLabel:'توفيرك مع SDB',
  sendBtn:'حوّل الآن ←',
  popTitle:'أسعار الصرف الشائعة',
  popSub:'اضغط على أي زوج لتحويله فوراً',
  whyTitle:'لماذا SDB أفضل من البنوك؟',
  whyCards:[
    {ic:'💰',t:'سعر السوق الحقيقي',d:'لا هوامش ربح مخفية. نفس السعر الذي تراه بالأسواق العالمية — شفافية كاملة.'},
    {ic:'⚡',t:'وصول فوري',d:'تحويلاتك تصل خلال ثوانٍ — ليس أيام. حتى عطلة نهاية الأسبوع.'},
    {ic:'🛡️',t:'رسوم أقل بـ 8x',d:'رسومنا 0.3% فقط. البنوك التقليدية تأخذ 3-5% + رسوم مخفية بالسعر.'},
    {ic:'🔔',t:'تنبيهات الأسعار',d:'حدد السعر اللي تبيه وبنبلّغك لحظة ما يوصل. لا تضيّع الفرصة.'},
    {ic:'📱',t:'من التطبيق',d:'حوّل بين 25+ عملة بضغطة واحدة من تطبيق SDB — بأي وقت ومكان.'},
    {ic:'🔒',t:'آمن 100%',d:'تشفير بنكي 256-بت. مصادقة بيومترية. حساباتك محمية 24/7.'},
  ],
  ctaTitle:'ابدأ التحويل الآن',ctaSub:'افتح حسابك وحوّل بأفضل الأسعار. مجاني — بدون رسوم مخفية.',ctaBtn:'افتح حسابك ←',
} : {
  title:'Currency Converter — SDB Bank',
  heroTag:'SDB Currency Converter',heroH:'Convert your money',heroEm:'at the best rate.',
  heroP:'Real exchange rates with no hidden markup. Send and receive money in 25+ currencies.',
  youSend:'You send exactly',recipientGets:'Recipient gets',
  guaranteed:'⏱ Rate guaranteed for 24 hours',
  rateLabel:'Exchange rate',
  arriveLabel:'Arrival time',arriveVal:'Today — in seconds',
  feeLabel:'SDB fee',feeNote:'Included in amount',
  bankLabel:'Traditional bank fee',
  saveLabel:'You save with SDB',
  sendBtn:'Convert now →',
  popTitle:'Popular Exchange Rates',
  popSub:'Click any pair to convert instantly',
  whyTitle:'Why SDB is better than banks?',
  whyCards:[
    {ic:'💰',t:'Real Market Rate',d:'No hidden markup. The same rate you see on global markets — full transparency.'},
    {ic:'⚡',t:'Instant Arrival',d:'Your transfers arrive in seconds — not days. Even on weekends.'},
    {ic:'🛡️',t:'8x Lower Fees',d:'Our fee is just 0.3%. Traditional banks charge 3-5% + hidden rate markup.'},
    {ic:'🔔',t:'Rate Alerts',d:'Set your target rate and we\'ll notify you the moment it\'s reached.'},
    {ic:'📱',t:'From the App',d:'Convert between 25+ currencies with one tap from the SDB app — anytime, anywhere.'},
    {ic:'🔒',t:'100% Secure',d:'256-bit bank encryption. Biometric auth. Your accounts protected 24/7.'},
  ],
  ctaTitle:'Start converting now',ctaSub:'Open your account and convert at the best rates. Free — no hidden fees.',ctaBtn:'Open your account →',
});
</script>
<template>
<Head :title="t.title" />
<!-- Hero -->
<section class="hero"><div class="sw tc">
  <div class="hero-tag">{{ t.heroTag }}</div>
  <h1 class="hero-h">{{ t.heroH }}<br><span class="hero-em">{{ t.heroEm }}</span></h1>
  <p class="hero-p">{{ t.heroP }}</p>
</div></section>

<!-- Converter Card -->
<section class="sec-conv"><div class="sw"><div class="conv-card">
  <!-- Guaranteed badge -->
  <div class="conv-badge">{{ t.guaranteed }}</div>

  <!-- You send -->
  <div class="conv-section">
    <label class="conv-label">{{ t.youSend }}</label>
    <div class="conv-row">
      <div class="cur-picker" @click="showFromDD=!showFromDD;showToDD=false">
        <span class="cur-flag">{{ fromObj.f }}</span>
        <span class="cur-code">{{ fromObj.c }}</span>
        <span class="cur-arrow">▾</span>
        <!-- Dropdown -->
        <div v-if="showFromDD" class="cur-dd">
          <div v-for="c in curs" :key="c.c" class="cur-dd-item" :class="{'cur-dd-active':c.c===fromCur}" @click.stop="selectFrom(c.c)">
            <span>{{ c.f }}</span><span class="cur-dd-code">{{ c.c }}</span><span class="cur-dd-name">{{ isAr?c.n:c.en }}</span>
          </div>
        </div>
      </div>
      <input v-model.number="fromAmt" type="number" class="conv-input" />
    </div>
  </div>

  <!-- Swap button -->
  <div class="conv-swap" @click="swapCur">
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 16V4m0 0L3 8m4-4l4 4M17 8v12m0 0l4-4m-4 4l-4-4"/></svg>
  </div>

  <!-- Recipient gets -->
  <div class="conv-section">
    <label class="conv-label">{{ t.recipientGets }}</label>
    <div class="conv-row">
      <div class="cur-picker" @click="showToDD=!showToDD;showFromDD=false">
        <span class="cur-flag">{{ toObj.f }}</span>
        <span class="cur-code">{{ toObj.c }}</span>
        <span class="cur-arrow">▾</span>
        <div v-if="showToDD" class="cur-dd">
          <div v-for="c in curs" :key="c.c" class="cur-dd-item" :class="{'cur-dd-active':c.c===toCur}" @click.stop="selectTo(c.c)">
            <span>{{ c.f }}</span><span class="cur-dd-code">{{ c.c }}</span><span class="cur-dd-name">{{ isAr?c.n:c.en }}</span>
          </div>
        </div>
      </div>
      <div class="conv-result">{{ toAmt }}</div>
    </div>
  </div>

  <!-- Info rows -->
  <div class="conv-info">
    <div class="info-row"><div class="info-icon">📊</div><div><div class="info-label">{{ t.rateLabel }}</div><div class="info-val">1 {{ fromCur }} = {{ rateDisplay }} {{ toCur }}</div></div></div>
    <div class="info-row"><div class="info-icon">⚡</div><div><div class="info-label">{{ t.arriveLabel }}</div><div class="info-val info-green">{{ t.arriveVal }}</div></div></div>
    <div class="info-row"><div class="info-icon">🏷️</div><div><div class="info-label">{{ t.feeLabel }}</div><div class="info-val">{{ fee }} {{ fromCur }} <span class="info-note">(0.3% — {{ t.feeNote }})</span></div></div></div>
    <div class="info-row info-row-dim"><div class="info-icon">🏦</div><div><div class="info-label">{{ t.bankLabel }}</div><div class="info-val info-strike">{{ bankFee }} {{ fromCur }} <span class="info-note">(3.5%)</span></div></div></div>
    <div class="info-row info-row-save"><div class="info-icon">💚</div><div><div class="info-label">{{ t.saveLabel }}</div><div class="info-val info-green-bold">{{ savings }} {{ fromCur }}</div></div></div>
  </div>

  <!-- CTA -->
  <a href="/preregister" class="conv-cta">{{ t.sendBtn }}</a>
</div></div></section>

<!-- Popular Pairs -->
<section class="sec"><div class="sw">
  <h2 class="t2 tc">{{ t.popTitle }}</h2>
  <p class="t2-sub tc" style="margin:-24px auto 40px">{{ t.popSub }}</p>
  <div class="pop-grid">
    <div v-for="p in popularPairs" :key="p.from+p.to" class="pop-c" @click="pickPair(p.from,p.to)">
      <div class="pop-flags"><span>{{ p.f1 }}</span><span class="pop-ar">→</span><span>{{ p.f2 }}</span></div>
      <div class="pop-pair">{{ p.from }}/{{ p.to }}</div>
      <div class="pop-rate">{{ fmtRate(pairRate(p.from,p.to)) }}</div>
    </div>
  </div>
</div></section>

<!-- Why SDB -->
<section class="sec sec-alt"><div class="sw">
  <h2 class="t2 tc">{{ t.whyTitle }}</h2>
  <div class="g3">
    <div v-for="w in t.whyCards" :key="w.t" class="why-c">
      <span class="why-ic">{{ w.ic }}</span>
      <h4 class="why-t">{{ w.t }}</h4>
      <p class="why-d">{{ w.d }}</p>
    </div>
  </div>
</div></section>

<!-- CTA -->
<section class="sec sec-sky tc"><div class="sw">
  <h2 class="t2 t2-w">{{ t.ctaTitle }}</h2>
  <p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p>
  <a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a>
</div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F9F3}
.sec-sky{background:linear-gradient(135deg,#163300,#1a3d00,#9FE870);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:32px}.t2-w{color:#fff}
.t2-sub{font-size:15px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}

/* ─── Hero ─── */
.hero{padding:140px 0 40px;background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.85);text-transform:uppercase;margin-bottom:20px}
.hero-h{font-size:clamp(2rem,4.5vw,3.4rem);font-weight:900;line-height:1.1;margin-bottom:14px;color:#fff}.hero-em{color:#E8F5E0}
.hero-p{font-size:16px;color:rgba(255,255,255,.75);max-width:520px;margin:0 auto;line-height:1.8}

/* ─── Converter Card ─── */
.sec-conv{margin-top:-40px;padding-bottom:40px;position:relative;z-index:10}
.conv-card{max-width:560px;margin:0 auto;background:#fff;border-radius:24px;box-shadow:0 20px 60px rgba(0,0,0,.08),0 1px 3px rgba(0,0,0,.04);padding:36px 32px;position:relative}
.conv-badge{display:inline-flex;align-items:center;gap:6px;background:rgba(159,232,112,.06);border:1px solid rgba(159,232,112,.12);border-radius:20px;padding:8px 18px;font-size:13px;font-weight:700;color:#1a3d00;margin-bottom:28px}
.conv-section{margin-bottom:8px}
.conv-label{font-size:14px;font-weight:600;color:rgba(10,10,10,.45);margin-bottom:10px;display:block}
.conv-row{display:flex;align-items:center;gap:14px;padding:16px 20px;background:#F8FAFC;border:2px solid rgba(159,232,112,.08);border-radius:16px;transition:border-color .2s}
.conv-row:focus-within{border-color:#9FE870}

/* Currency picker */
.cur-picker{display:flex;align-items:center;gap:8px;cursor:pointer;padding:8px 14px;background:#fff;border:1px solid rgba(159,232,112,.12);border-radius:12px;position:relative;user-select:none;transition:all .2s;flex-shrink:0}
.cur-picker:hover{border-color:#9FE870;box-shadow:0 2px 8px rgba(159,232,112,.1)}
.cur-flag{font-size:24px}.cur-code{font-size:18px;font-weight:900;color:#163300}
.cur-arrow{font-size:10px;color:rgba(10,10,10,.25);transition:transform .2s}
.cur-dd{position:absolute;top:calc(100% + 8px);left:0;min-width:280px;background:#fff;border:1px solid rgba(159,232,112,.1);border-radius:16px;box-shadow:0 16px 48px rgba(0,0,0,.12);padding:8px;z-index:100;max-height:320px;overflow-y:auto}
.rtl .cur-dd{left:auto;right:0}
.cur-dd-item{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;cursor:pointer;transition:background .15s;font-size:14px}
.cur-dd-item:hover{background:rgba(159,232,112,.06)}
.cur-dd-active{background:rgba(159,232,112,.1)!important;font-weight:700}
.cur-dd-code{font-weight:800;color:#163300;min-width:40px}.cur-dd-name{color:rgba(10,10,10,.4);font-size:13px}

.conv-input{flex:1;border:none;background:transparent;font-size:clamp(28px,5vw,36px);font-weight:900;color:#163300;text-align:end;outline:none;font-family:inherit;min-width:0}
.conv-input::-webkit-inner-spin-button,.conv-input::-webkit-outer-spin-button{-webkit-appearance:none}
.conv-input{-moz-appearance:textfield}
.rtl .conv-input{text-align:start}
.conv-result{flex:1;font-size:clamp(28px,5vw,36px);font-weight:900;color:#9FE870;text-align:end}
.rtl .conv-result{text-align:start}

/* Swap */
.conv-swap{display:flex;align-items:center;justify-content:center;width:44px;height:44px;margin:-6px auto;background:#fff;border:2px solid rgba(159,232,112,.12);border-radius:50%;cursor:pointer;color:#9FE870;transition:all .2s;position:relative;z-index:2}
.conv-swap:hover{background:#9FE870;color:#fff;transform:rotate(180deg);border-color:#9FE870}

/* Info rows */
.conv-info{margin-top:24px;padding-top:24px;border-top:1px solid rgba(159,232,112,.08);display:flex;flex-direction:column;gap:14px}
.info-row{display:flex;align-items:center;gap:12px}
.info-icon{font-size:18px;width:36px;height:36px;display:flex;align-items:center;justify-content:center;background:#F5F9F3;border-radius:10px;flex-shrink:0}
.info-label{font-size:12px;color:rgba(10,10,10,.35);margin-bottom:1px}.info-val{font-size:15px;font-weight:700;color:#163300}
.info-note{font-size:12px;color:rgba(10,10,10,.25);font-weight:400}
.info-green{color:#059669}.info-green-bold{color:#059669;font-size:17px;font-weight:900}
.info-strike .info-val{text-decoration:line-through;color:rgba(10,10,10,.2)}
.info-row-dim{opacity:.45}.info-row-save{background:rgba(45,106,0,.04);padding:10px 12px;border-radius:12px;margin:0 -12px}

/* CTA button */
.conv-cta{display:block;width:100%;padding:18px;background:linear-gradient(135deg,#9FE870,#1a3d00);color:#fff;font-size:17px;font-weight:800;text-align:center;border-radius:14px;text-decoration:none;margin-top:24px;transition:all .2s;border:none;cursor:pointer}
.conv-cta:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(159,232,112,.25)}

/* ─── Popular Pairs ─── */
.pop-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.pop-c{padding:20px;background:#fff;border:1px solid rgba(159,232,112,.06);border-radius:16px;text-align:center;cursor:pointer;transition:all .3s}
.pop-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(159,232,112,.08);border-color:rgba(159,232,112,.15)}
.pop-flags{font-size:24px;display:flex;align-items:center;justify-content:center;gap:6px;margin-bottom:8px}
.pop-ar{font-size:14px;color:rgba(159,232,112,.3)}
.pop-pair{font-size:13px;font-weight:800;color:#163300;margin-bottom:4px}
.pop-rate{font-size:18px;font-weight:900;color:#9FE870}

/* ─── Why SDB ─── */
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.why-c{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.06);border-radius:18px;text-align:center;transition:all .3s}
.why-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(159,232,112,.06)}
.why-ic{font-size:32px;display:block;margin-bottom:12px}
.why-t{font-size:15px;font-weight:800;color:#163300;margin-bottom:8px}
.why-d{font-size:13px;color:rgba(10,10,10,.4);line-height:1.75}

.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}

@media(max-width:900px){.pop-grid{grid-template-columns:repeat(2,1fr)}.g3{grid-template-columns:repeat(2,1fr)}}
@media(max-width:600px){.pop-grid,.g3{grid-template-columns:1fr}.conv-card{padding:24px 18px}.conv-input,.conv-result{font-size:24px}}
</style>
