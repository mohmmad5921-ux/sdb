<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, computed, ref, watch } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));

/* ─── Converter Logic ─── */
const amount = ref('');
const direction = ref('old'); // 'old' = old→new, 'new' = new→old

const result = computed(() => {
  const n = parseFloat(amount.value.replace(/,/g, '')) || 0;
  if (n === 0) return 0;
  return direction.value === 'old' ? n / 100 : n * 100;
});

const resultFormatted = computed(() => result.value.toLocaleString('en-US'));

/* ─── عرض المبلغ كتابة بالعربية ─── */
const ones = ['','واحد','اثنان','ثلاثة','أربعة','خمسة','ستة','سبعة','ثمانية','تسعة','عشرة','أحد عشر','اثنا عشر','ثلاثة عشر','أربعة عشر','خمسة عشر','ستة عشر','سبعة عشر','ثمانية عشر','تسعة عشر'];
const tens = ['','','عشرون','ثلاثون','أربعون','خمسون','ستون','سبعون','ثمانون','تسعون'];
const scales = ['','ألف','مليون','مليار'];

function numToAr(n) {
  if (n === 0) return 'صفر';
  if (n < 0) return 'سالب ' + numToAr(-n);
  n = Math.floor(n);
  if (n < 20) return ones[n];
  if (n < 100) {
    const t = Math.floor(n / 10), o = n % 10;
    return o ? ones[o] + ' و' + tens[t] : tens[t];
  }
  if (n < 1000) {
    const h = Math.floor(n / 100), r = n % 100;
    const hStr = h === 1 ? 'مئة' : h === 2 ? 'مئتان' : ones[h] + ' مئة';
    return r ? hStr + ' و' + numToAr(r) : hStr;
  }
  const parts = [];
  let remaining = n, si = 0;
  while (remaining > 0) {
    const chunk = remaining % 1000;
    if (chunk > 0) {
      const cStr = numToAr(chunk);
      if (si === 0) parts.unshift(cStr);
      else if (chunk === 1) parts.unshift(scales[si]);
      else if (chunk === 2) parts.unshift(scales[si] + 'ان');
      else parts.unshift(cStr + ' ' + scales[si]);
    }
    remaining = Math.floor(remaining / 1000);
    si++;
  }
  return parts.join(' و');
}
const resultText = computed(() => {
  const n = result.value;
  if (n === 0) return '';
  return numToAr(Math.floor(n)) + ' ليرة سورية';
});
const inputText = computed(() => {
  const n = parseFloat(amount.value.replace(/,/g, '')) || 0;
  if (n === 0) return '';
  return numToAr(Math.floor(n)) + ' ليرة سورية';
});

/* ─── تفصيل الفئات النقدية ─── */
const newDenominations = [5000, 2000, 1000, 500, 200, 100, 50, 10, 5, 1];
const oldDenominations = [500000, 200000, 100000, 50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100];

const breakdown = computed(() => {
  let val = Math.floor(result.value);
  if (val <= 0) return [];
  const denoms = direction.value === 'old' ? newDenominations : oldDenominations;
  const parts = [];
  for (const d of denoms) {
    if (val >= d) {
      const count = Math.floor(val / d);
      parts.push({ denom: d, count });
      val %= d;
    }
  }
  return parts;
});

/* ─── Chart Data ─── */
const chartMax = computed(() => {
  if (!breakdown.value.length) return 1;
  return Math.max(...breakdown.value.map(b => b.count));
});

function shareResult() {
  const n = parseFloat(amount.value.replace(/,/g, '')) || 0;
  if (n === 0) return;
  const dir = direction.value === 'old' ? 'قديم → جديد' : 'جديد → قديم';
  const text = `ليرتنا | تحويل ${dir}\n${n.toLocaleString()} ل.س = ${resultFormatted.value} ل.س\n${resultText.value}\nhttps://sdb-bank.com/lirtna`;
  if (navigator.share) {
    navigator.share({ title: 'ليرتنا', text });
  } else {
    navigator.clipboard.writeText(text);
    copied.value = true;
    setTimeout(() => copied.value = false, 2000);
  }
}
const copied = ref(false);

/* ─── Tab ─── */
const tab = ref('convert'); // convert, info

/* ─── Swap direction ─── */
function swap() {
  const prevResult = result.value;
  direction.value = direction.value === 'old' ? 'new' : 'old';
  amount.value = prevResult > 0 ? prevResult.toString() : '';
}

/* ─── Translations ─── */
const t = computed(() => isAr.value ? {
  title: 'ليرتنا — محوّل العملة السورية | SDB Bank',
  tag: '🇸🇾 ليرتنا',
  heroH: 'ليرتنا.',
  heroEm: 'حوّل بسهولة.',
  heroP: 'محوّل الليرة السورية بين القديم والجديد — سريع، دقيق، واحترافي. مع تفصيل الفئات النقدية وعرض المبلغ كتابةً.',
  tabConvert: 'تحويل',
  tabInfo: 'معلومات',
  enterAmount: 'أدخل المبلغ',
  oldLira: 'ليرة قديمة',
  newLira: 'ليرة جديدة',
  oldToNew: 'قديم ← جديد',
  newToOld: 'جديد ← قديم',
  result: 'النتيجة',
  syr: 'ل.س',
  textResult: 'كتابةً',
  textInput: 'المبلغ المُدخل كتابةً',
  denomBreakdown: 'تفصيل الفئات النقدية',
  denomChart: 'توزيع الفئات',
  share: 'مشاركة النتيجة',
  copied: 'تم النسخ ✓',
  bill: 'ورقة',
  bills: 'أوراق',
  infoTitle: 'كل ما تحتاج معرفته',
  infoCards: [
    { ic: '🔢', t: 'ما هو مسح الصفرين؟', d: 'تم حذف صفرين من العملة السورية. 100,000 ليرة قديمة = 1,000 ليرة جديدة. القيمة الشرائية لا تتغير.' },
    { ic: '💵', t: 'الفئات النقدية الجديدة', d: 'فئات الورقية: 1, 5, 10, 50, 100, 500, 1000, 2000, 5000 ل.س. عملات معدنية: 1, 5, 10, 25, 50 قرش.' },
    { ic: '📅', t: 'الفترة الانتقالية', d: 'العملتان القديمة والجديدة مقبولتان خلال الفترة الانتقالية التي حددها البنك المركزي.' },
    { ic: '📱', t: 'لماذا ليرتنا؟', d: 'تطبيق سريع وبسيط لتحويل المبالغ، مع عرض الفئات النقدية والمبلغ كتابةً — مثالي للتجار والأفراد.' },
    { ic: '🛡️', t: 'حماية قيمتك', d: 'لا فقدان بالقيمة — التحويل حسابي بسيط (÷100 أو ×100). محفظتك آمنة.' },
    { ic: '🏦', t: 'SDB Bank', d: 'أول بنك رقمي يدعم الليرة الجديدة — حوّل، ادفع، واستلم بدون نقد مباشرة من التطبيق.' },
  ],
  ctaTitle: 'حمّل التطبيق وحوّل ليرتك رقمياً',
  ctaSub: 'افتح حسابك في SDB Bank واستمتع بتجربة بنكية رقمية كاملة.',
  ctaBtn: 'افتح حسابك ←',
} : {
  title: 'Lirtna — Syrian Currency Converter | SDB Bank',
  tag: '🇸🇾 Lirtna',
  heroH: 'Lirtna.',
  heroEm: 'Convert with ease.',
  heroP: 'Convert Syrian Lira between old and new denominations — fast, accurate, and professional. With banknote breakdown and amount in words.',
  tabConvert: 'Convert',
  tabInfo: 'Info',
  enterAmount: 'Enter amount',
  oldLira: 'Old Lira',
  newLira: 'New Lira',
  oldToNew: 'Old → New',
  newToOld: 'New → Old',
  result: 'Result',
  syr: 'SYP',
  textResult: 'In words',
  textInput: 'Input amount in words',
  denomBreakdown: 'Banknote Breakdown',
  denomChart: 'Denomination Chart',
  share: 'Share Result',
  copied: 'Copied ✓',
  bill: 'bill',
  bills: 'bills',
  infoTitle: 'Everything you need to know',
  infoCards: [
    { ic: '🔢', t: 'What is redenomination?', d: 'Two zeros were removed from Syrian currency. 100,000 old lira = 1,000 new lira. Purchasing power remains the same.' },
    { ic: '💵', t: 'New banknote denominations', d: 'Banknotes: 1, 5, 10, 50, 100, 500, 1000, 2000, 5000 SYP. Coins: 1, 5, 10, 25, 50 piasters.' },
    { ic: '📅', t: 'Transition period', d: 'Both old and new currencies are accepted during the central bank\'s transition period.' },
    { ic: '📱', t: 'Why Lirtna?', d: 'A fast, simple app for converting amounts with banknote breakdown and amount in words — ideal for merchants and individuals.' },
    { ic: '🛡️', t: 'Value protection', d: 'No value loss — conversion is simple math (÷100 or ×100). Your money is safe.' },
    { ic: '🏦', t: 'SDB Bank', d: 'First digital bank supporting the new lira — convert, pay, and receive cashlessly directly from the app.' },
  ],
  ctaTitle: 'Download the app & go digital',
  ctaSub: 'Open your SDB Bank account and enjoy a complete digital banking experience.',
  ctaBtn: 'Open your account →',
});
</script>
<template>
<Head :title="t.title" />

<!-- Hero -->
<section class="lr-hero"><div class="sw tc">
  <div class="lr-tag">{{ t.tag }}</div>
  <h1 class="lr-h">{{ t.heroH }}<br><span class="lr-em">{{ t.heroEm }}</span></h1>
  <p class="lr-p">{{ t.heroP }}</p>
</div></section>

<!-- Tabs -->
<section class="sec"><div class="sw">
  <div class="lr-tabs">
    <button :class="['lr-tab', tab === 'convert' && 'lr-tab-on']" @click="tab='convert'">{{ t.tabConvert }}</button>
    <button :class="['lr-tab', tab === 'info' && 'lr-tab-on']" @click="tab='info'">{{ t.tabInfo }}</button>
  </div>

  <!-- ═══════ CONVERT TAB ═══════ -->
  <div v-if="tab === 'convert'">
    <!-- Direction Toggle -->
    <div class="lr-dir-bar">
      <button :class="['lr-dir', direction==='old' && 'lr-dir-on']" @click="direction='old'">{{ t.oldToNew }}</button>
      <button class="lr-swap" @click="swap">⇅</button>
      <button :class="['lr-dir', direction==='new' && 'lr-dir-on']" @click="direction='new'">{{ t.newToOld }}</button>
    </div>

    <!-- Converter Card -->
    <div class="lr-conv-card">
      <!-- Input -->
      <div class="lr-input-wrap">
        <label class="lr-label">{{ direction === 'old' ? t.oldLira : t.newLira }}</label>
        <div class="lr-input-row">
          <input v-model="amount" type="text" inputmode="numeric" :placeholder="t.enterAmount" class="lr-input" />
          <span class="lr-cur">{{ t.syr }}</span>
        </div>
        <div v-if="inputText" class="lr-text-sm">{{ t.textInput }}: {{ inputText }}</div>
      </div>

      <!-- Arrow -->
      <div class="lr-arrow">
        <div class="lr-arrow-line"></div>
        <div class="lr-arrow-circle">{{ direction === 'old' ? '÷100' : '×100' }}</div>
        <div class="lr-arrow-line"></div>
      </div>

      <!-- Result -->
      <div class="lr-result-wrap">
        <label class="lr-label">{{ direction === 'old' ? t.newLira : t.oldLira }}</label>
        <div class="lr-result-big">{{ resultFormatted }} <span class="lr-result-cur">{{ t.syr }}</span></div>
        <div v-if="resultText" class="lr-result-text">{{ t.textResult }}: {{ resultText }}</div>
      </div>
    </div>

    <!-- Share -->
    <div class="lr-actions" v-if="result > 0">
      <button class="lr-share" @click="shareResult">{{ copied ? t.copied : t.share }} {{ copied ? '' : '↗' }}</button>
    </div>

    <!-- Denomination Breakdown -->
    <div v-if="breakdown.length" class="lr-denom-section">
      <h3 class="lr-sec-title">{{ t.denomBreakdown }}</h3>
      <div class="lr-denom-grid">
        <div v-for="b in breakdown" :key="b.denom" class="lr-denom-card">
          <div class="lr-denom-count">{{ b.count }}×</div>
          <div class="lr-denom-val">{{ b.denom.toLocaleString() }}</div>
          <div class="lr-denom-label">{{ t.syr }}</div>
        </div>
      </div>
    </div>

    <!-- Chart -->
    <div v-if="breakdown.length > 1" class="lr-chart-section">
      <h3 class="lr-sec-title">{{ t.denomChart }}</h3>
      <div class="lr-chart">
        <div v-for="b in breakdown" :key="b.denom" class="lr-bar-wrap">
          <div class="lr-bar-count">{{ b.count }}</div>
          <div class="lr-bar" :style="{ height: Math.max(8, (b.count / chartMax) * 160) + 'px' }"></div>
          <div class="lr-bar-label">{{ b.denom >= 1000 ? (b.denom/1000)+'K' : b.denom }}</div>
        </div>
      </div>
    </div>
  </div>


  <!-- ═══════ INFO TAB ═══════ -->
  <div v-if="tab === 'info'">
    <h2 class="t2 tc">{{ t.infoTitle }}</h2>
    <div class="lr-info-grid">
      <div v-for="c in t.infoCards" :key="c.t" class="lr-info-card">
        <span class="lr-info-ic">{{ c.ic }}</span>
        <h4 class="lr-info-t">{{ c.t }}</h4>
        <p class="lr-info-d">{{ c.d }}</p>
      </div>
    </div>
  </div>
</div></section>

<!-- CTA -->
<section class="sec lr-cta tc"><div class="sw">
  <h2 class="t2 t2-w">{{ t.ctaTitle }}</h2>
  <p class="lr-cta-sub">{{ t.ctaSub }}</p>
  <a href="/preregister" class="lr-cta-btn">{{ t.ctaBtn }}</a>
</div></section>
</template>

<style scoped>
/* ─── Base ─── */
.sw { max-width: 1200px; margin: 0 auto; padding: 0 24px }
.tc { text-align: center }
.sec { padding: 60px 0 }
.t2 { font-size: clamp(1.6rem, 3.5vw, 2.4rem); font-weight: 900; line-height: 1.1; margin-bottom: 32px }
.t2-w { color: #fff }

/* ─── Hero ─── */
.lr-hero { padding: 140px 0 60px; background: linear-gradient(135deg, #0f172a 0%, #1e293b 40%, #10B981 100%); color: #fff; position: relative; overflow: hidden }
.lr-hero::before { content: ''; position: absolute; top: -50%; right: -30%; width: 600px; height: 600px; border-radius: 50%; background: radial-gradient(circle, rgba(16,185,129,.15), transparent 70%); pointer-events: none }
.lr-tag { font-size: 13px; font-weight: 800; letter-spacing: 2px; color: rgba(255,255,255,.5); margin-bottom: 20px }
.lr-h { font-size: clamp(2.4rem, 6vw, 4.2rem); font-weight: 900; line-height: 1.05; margin-bottom: 18px }
.lr-em { color: #34D399; display: block }
.lr-p { font-size: 16px; color: rgba(255,255,255,.45); max-width: 520px; margin: 0 auto; line-height: 1.9 }

/* ─── Tabs ─── */
.lr-tabs { display: flex; justify-content: center; gap: 4px; margin-bottom: 36px; background: #f1f5f9; border-radius: 14px; padding: 4px; max-width: 420px; margin-left: auto; margin-right: auto }
.lr-tab { flex: 1; padding: 12px; border: none; background: transparent; font-size: 14px; font-weight: 700; color: #64748b; border-radius: 12px; cursor: pointer; transition: all .25s; font-family: inherit }
.lr-tab-on { background: #fff; color: #0f172a; box-shadow: 0 2px 8px rgba(0,0,0,.08) }

/* ─── Direction Toggle ─── */
.lr-dir-bar { display: flex; align-items: center; justify-content: center; gap: 8px; margin-bottom: 32px }
.lr-dir { padding: 10px 24px; border: 2px solid #e2e8f0; background: #fff; font-size: 13px; font-weight: 700; color: #64748b; border-radius: 12px; cursor: pointer; transition: all .2s; font-family: inherit }
.lr-dir-on { background: #0f172a; color: #fff; border-color: #0f172a }
.lr-swap { width: 40px; height: 40px; border-radius: 20px; border: 2px solid #10B981; background: #F0FDF4; color: #10B981; font-size: 18px; font-weight: 900; cursor: pointer; transition: all .25s; display: flex; align-items: center; justify-content: center }
.lr-swap:hover { background: #10B981; color: #fff; transform: rotate(180deg) }

/* ─── Converter Card ─── */
.lr-conv-card { max-width: 560px; margin: 0 auto; background: #fff; border: 2px solid #e2e8f0; border-radius: 24px; padding: 36px; box-shadow: 0 4px 24px rgba(0,0,0,.04) }
.lr-label { font-size: 12px; font-weight: 800; color: #64748b; letter-spacing: 1px; margin-bottom: 10px; display: block }
.lr-input-row { display: flex; gap: 8px; align-items: center }
.lr-input { flex: 1; padding: 18px; border: 2px solid #e2e8f0; border-radius: 16px; font-size: 28px; font-weight: 900; color: #0f172a; outline: none; font-family: inherit; transition: border .2s; text-align: center }
.lr-input:focus { border-color: #10B981 }
.lr-cur { font-size: 14px; font-weight: 900; color: #10B981; background: #F0FDF4; padding: 18px 16px; border-radius: 16px; white-space: nowrap }
.lr-text-sm { font-size: 11px; color: #94a3b8; margin-top: 8px; line-height: 1.5 }

/* ─── Arrow ─── */
.lr-arrow { display: flex; align-items: center; justify-content: center; gap: 0; margin: 20px 0 }
.lr-arrow-line { flex: 1; height: 2px; background: linear-gradient(90deg, transparent, #e2e8f0, transparent) }
.lr-arrow-circle { width: 52px; height: 52px; border-radius: 26px; background: linear-gradient(135deg, #10B981, #34D399); color: #fff; font-size: 13px; font-weight: 900; display: flex; align-items: center; justify-content: center; flex-shrink: 0; box-shadow: 0 4px 16px rgba(16,185,129,.3) }

/* ─── Result ─── */
.lr-result-wrap { background: #F0FDF4; border-radius: 18px; padding: 24px; text-align: center }
.lr-result-big { font-size: clamp(2rem, 5vw, 3rem); font-weight: 900; color: #065F46; line-height: 1.2 }
.lr-result-cur { font-size: 16px; color: #10B981; font-weight: 700 }
.lr-result-text { font-size: 13px; color: #047857; margin-top: 8px; font-weight: 600; line-height: 1.6 }

/* ─── Actions ─── */
.lr-actions { display: flex; justify-content: center; gap: 8px; margin-top: 20px }
.lr-share { padding: 12px 28px; background: #0f172a; color: #fff; border: none; border-radius: 12px; font-size: 14px; font-weight: 700; cursor: pointer; transition: all .2s; font-family: inherit }
.lr-share:hover { background: #10B981 }

/* ─── Denomination ─── */
.lr-denom-section { margin-top: 48px; max-width: 560px; margin-left: auto; margin-right: auto }
.lr-sec-title { font-size: 16px; font-weight: 900; color: #0f172a; margin-bottom: 20px; text-align: center }
.lr-denom-grid { display: flex; flex-wrap: wrap; gap: 10px; justify-content: center }
.lr-denom-card { background: #fff; border: 2px solid #e2e8f0; border-radius: 16px; padding: 16px 20px; text-align: center; min-width: 100px; transition: all .2s }
.lr-denom-card:hover { border-color: #10B981; transform: translateY(-2px) }
.lr-denom-count { font-size: 24px; font-weight: 900; color: #10B981 }
.lr-denom-val { font-size: 18px; font-weight: 800; color: #0f172a }
.lr-denom-label { font-size: 11px; color: #94a3b8; font-weight: 700 }

/* ─── Chart ─── */
.lr-chart-section { margin-top: 40px; max-width: 560px; margin-left: auto; margin-right: auto }
.lr-chart { display: flex; align-items: flex-end; justify-content: center; gap: 16px; padding: 24px; background: #fff; border: 2px solid #e2e8f0; border-radius: 20px }
.lr-bar-wrap { display: flex; flex-direction: column; align-items: center; gap: 6px }
.lr-bar-count { font-size: 12px; font-weight: 800; color: #0f172a }
.lr-bar { width: 36px; border-radius: 8px 8px 4px 4px; background: linear-gradient(180deg, #10B981, #34D399); transition: height .5s ease; min-height: 8px }
.lr-bar-label { font-size: 10px; font-weight: 700; color: #64748b }

/* ─── History ─── */
.lr-empty { text-align: center; padding: 60px 0; color: #94a3b8 }
.lr-empty-ic { font-size: 48px; margin-bottom: 12px }
.lr-hist-actions { display: flex; justify-content: flex-end; margin-bottom: 16px }
.lr-clear { padding: 8px 16px; background: #fef2f2; color: #ef4444; border: 1px solid #fecaca; border-radius: 10px; font-size: 12px; font-weight: 700; cursor: pointer; font-family: inherit }
.lr-hist-list { display: flex; flex-direction: column; gap: 8px }
.lr-hist-card { display: flex; align-items: center; gap: 14px; padding: 16px; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; transition: all .15s }
.lr-hist-card:hover { border-color: #10B981 }
.lr-hist-dir { font-size: 24px }
.lr-hist-body { flex: 1 }
.lr-hist-amt { font-size: 15px; font-weight: 800; color: #0f172a }
.lr-hist-muted { color: #94a3b8 }
.lr-hist-date { font-size: 11px; color: #94a3b8; margin-top: 2px }

/* ─── Info ─── */
.lr-info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px }
.lr-info-card { padding: 28px; background: #fff; border: 1px solid #e2e8f0; border-radius: 18px; text-align: center; transition: all .3s }
.lr-info-card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(0,0,0,.06) }
.lr-info-ic { font-size: 32px; display: block; margin-bottom: 12px }
.lr-info-t { font-size: 15px; font-weight: 800; color: #0f172a; margin-bottom: 6px }
.lr-info-d { font-size: 12.5px; color: #64748b; line-height: 1.75 }

/* ─── CTA ─── */
.lr-cta { background: linear-gradient(135deg, #0f172a 0%, #1e293b 60%, #10B981 100%); color: #fff; padding: 80px 0 }
.lr-cta-sub { font-size: 15px; color: rgba(255,255,255,.4); max-width: 480px; margin: 0 auto 28px; line-height: 1.8 }
.lr-cta-btn { display: inline-block; padding: 16px 44px; background: #10B981; color: #fff; font-size: 15px; font-weight: 800; border-radius: 14px; text-decoration: none; transition: all .25s }
.lr-cta-btn:hover { background: #fff; color: #0f172a; transform: translateY(-2px) }

/* ─── Responsive ─── */
@media (max-width: 900px) { .lr-info-grid { grid-template-columns: repeat(2, 1fr) } }
@media (max-width: 600px) {
  .lr-info-grid { grid-template-columns: 1fr }
  .lr-dir-bar { flex-wrap: wrap }
  .lr-input { font-size: 22px }
  .lr-result-big { font-size: 2rem }
  .lr-chart { gap: 10px; padding: 16px }
  .lr-bar { width: 28px }
  .lr-denom-card { min-width: 80px; padding: 12px }
}
</style>
