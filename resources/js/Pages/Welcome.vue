<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';
defineProps({ canLogin: Boolean, canRegister: Boolean });
const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');
const toggleLang = () => lang.value = lang.value === 'ar' ? 'en' : 'ar';
const ar = (a, e) => isAr.value ? a : e;
const mob = ref(false);

const launchDate = new Date('2026-04-15T00:00:00');
const cd = ref({ d:0, h:0, m:0, s:0 });
let ti;
function tick(){const x=launchDate-new Date();if(x<=0)return;cd.value={d:Math.floor(x/864e5),h:Math.floor(x%864e5/36e5),m:Math.floor(x%36e5/6e4),s:Math.floor(x%6e4/1e3)}}
const em = ref('');
const done = ref(false);

let obs;
onMounted(()=>{tick();ti=setInterval(tick,1e3);obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.08});document.querySelectorAll('.a').forEach(el=>obs.observe(el))});
onUnmounted(()=>{clearInterval(ti);obs?.disconnect()});
</script>

<template>
<Head :title="ar('SDB Bank — قريباً','SDB Bank — Coming Soon')">
  <meta name="description" :content="ar('SDB Bank — البنك الرقمي الجديد','SDB Bank — The new digital bank')" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Cairo:wght@300;400;600;700;800;900&display=swap" rel="stylesheet" />
</Head>

<div :class="['pg', isAr ? 'rtl af' : 'ltr']" :dir="isAr ? 'rtl' : 'ltr'">

<!-- Nav -->
<nav class="nav">
  <div class="mx flex items-center justify-between">
    <a href="/" class="mark">SDB<span class="dot">.</span></a>
    <div class="flex items-center gap-5">
      <button @click="toggleLang" class="nl">{{ ar('EN','عربي') }}</button>
      <Link v-if="canLogin" :href="route('login')" class="nl">{{ ar('دخول','Log in') }}</Link>
      <Link v-if="canRegister" :href="route('register')" class="nbtn">{{ ar('سجّل مبكراً','Early access') }}</Link>
    </div>
  </div>
</nav>

<!-- ████  HERO  ████ -->
<section class="hero">
  <div class="mx hero-mx">
    <div class="htag a">{{ ar('الإطلاق قريباً','LAUNCHING SOON') }}</div>
    <h1 class="hd a">
      <span class="hd-line">{{ ar('بنك لعصر','Banking for') }}</span>
      <span class="hd-em">{{ ar('جديد','a new era') }}</span>
    </h1>
    <p class="hp a">{{ ar('حسابات متعددة العملات · بطاقات Mastercard فورية · تداول كريبتو بمحافظ حقيقية · تحويلات لـ 150+ دولة. كل ذلك من مكان واحد.','Multi-currency accounts · Instant Mastercard · Crypto with real wallets · Transfers to 150+ countries. All in one place.') }}</p>

    <!-- countdown -->
    <div class="cd a">
      <div v-for="(lb,k) in {d:ar('يوم','Days'),h:ar('ساعة','Hrs'),m:ar('دقيقة','Min'),s:ar('ثانية','Sec')}" :key="k" class="cd-b">
        <div class="cd-n">{{ String(cd[k]).padStart(2,'0') }}</div>
        <div class="cd-l">{{ lb }}</div>
      </div>
    </div>

    <!-- email -->
    <div class="eml a">
      <template v-if="!done">
        <input v-model="em" type="email" :placeholder="ar('بريدك الإلكتروني...','Your email...')" class="eml-i" @keyup.enter="done=!!em"/>
        <button @click="done=!!em" class="eml-b">{{ ar('أبلغني عند الإطلاق','Notify me') }}</button>
      </template>
      <div v-else class="eml-ok">✓ {{ ar('تم! سنبلغك فور الإطلاق.','Done! We\'ll let you know.') }}</div>
    </div>

    <!-- trust -->
    <div class="trust a">
      <span v-for="t in ['🇩🇰 '+ar('مرخّص في الدنمارك','Licensed in Denmark'),'🔒 '+ar('تشفير 256-bit','256-bit encrypted'),'🏦 Mastercard '+ar('معتمد','certified')]" :key="t" class="trust-i">{{ t }}</span>
    </div>
  </div>
</section>

<!-- ████  MARQUEE  ████ -->
<div class="mq">
  <div class="mq-track">
    <span v-for="(p,i) in ['Mastercard','Visa','Apple Pay','Google Pay','SWIFT','SEPA','Mastercard','Visa','Apple Pay','Google Pay','SWIFT','SEPA']" :key="i" class="mq-i">{{ p }}</span>
  </div>
</div>

<!-- ████  FEATURES  ████ -->
<section class="sec sec-w">
  <div class="mx">
    <div class="sec-hdr a">
      <h2 class="t2">{{ ar('كل ما تحتاجه.','Everything you need.') }}<br><span class="t2-fade">{{ ar('لا شيء لا تحتاجه.','Nothing you don\'t.') }}</span></h2>
    </div>
    <div class="fg">
      <div v-for="(f,i) in [
        {ic:'💳',t:ar('بطاقات Mastercard','Mastercard Cards'),p:ar('بطاقة افتراضية فورية عند فتح حسابك. أو اطلب بطاقة معدنية فاخرة. ادفع بـ Apple Pay في أي مكان بالعالم.','Instant virtual card on signup. Or order a premium metal card. Pay with Apple Pay anywhere.'),tag:'CARDS'},
        {ic:'💱',t:ar('30+ عملة عالمية','30+ Global Currencies'),p:ar('احتفظ بأرصدة وحوّل بأسعار السوق الحقيقية. بدون عمولات مخفية. EUR, USD, GBP, AED, SAR والمزيد.','Hold and convert at real market rates. No hidden fees. EUR, USD, GBP, AED, SAR and more.'),tag:'FX'},
        {ic:'🪙',t:ar('كريبتو بمحافظ حقيقية','Crypto with Real Wallets'),p:ar('اشترِ وبِع BTC, ETH, SOL وأكثر. كل عميل يحصل على عنوان محفظة حقيقي معترف به عالمياً. أرسل واستقبل بحرية.','Buy and sell BTC, ETH, SOL and more. Every customer gets a real, globally recognized wallet address. Send and receive freely.'),tag:'CRYPTO'},
        {ic:'⚡',t:ar('تحويلات دولية','International Transfers'),p:ar('أرسل لـ 150+ دولة عبر SWIFT وSEPA. يوصل بدقائق مع أقل رسوم ممكنة.','Send to 150+ countries via SWIFT & SEPA. Arrives in minutes with lowest fees.'),tag:'TRANSFERS'},
        {ic:'🛡️',t:ar('أمان لا يُخترق','Unbreakable Security'),p:ar('تشفير بنكي 256-bit. مصادقة ثنائية وبصمة الوجه. فريق مراقبة احتيال يعمل 24/7.','Bank-grade 256-bit encryption. 2FA and Face ID. 24/7 fraud monitoring team.'),tag:'SECURITY'},
        {ic:'📱',t:ar('تطبيق واحد لكل شيء','One App for Everything'),p:ar('iOS وAndroid. تحكم كامل بحساباتك وبطاقاتك وتداولاتك ومحافظك من مكان واحد.','iOS & Android. Full control of accounts, cards, trades and wallets in one place.'),tag:'APP'}
      ]" :key="i" class="fc a" :style="{transitionDelay:(i*60)+'ms'}">
        <div class="fc-top">
          <span class="fc-tag">{{ f.tag }}</span>
          <span class="fc-ic">{{ f.ic }}</span>
        </div>
        <h3 class="fc-t">{{ f.t }}</h3>
        <p class="fc-p">{{ f.p }}</p>
      </div>
    </div>
  </div>
</section>

<!-- ████  CRYPTO  ████ -->
<section class="sec sec-bk">
  <div class="mx">
    <div class="sec-hdr a">
      <h2 class="t2 text-white">{{ ar('عملاتك الرقمية.','Your crypto.') }}<br><span class="t2-fade-w">{{ ar('محفظتك الحقيقية.','Your real wallet.') }}</span></h2>
      <p class="sp sp-w">{{ ar('اشترِ وبِع وأرسل واستقبل — محافظ على البلوكتشين باسمك.','Buy, sell, send and receive — blockchain wallets in your name.') }}</p>
    </div>
    <div class="cr-coins a">
      <div v-for="c in [{s:'BTC',n:'Bitcoin',c:'#F7931A'},{s:'ETH',n:'Ethereum',c:'#627EEA'},{s:'USDT',n:'Tether',c:'#26A17B'},{s:'SOL',n:'Solana',c:'#9945FF'},{s:'XRP',n:'Ripple',c:'#fff'},{s:'ADA',n:'Cardano',c:'#3CC8C8'}]" :key="c.s" class="cr-c">
        <span class="cr-dot" :style="{background:c.c}"></span>
        <div><div class="cr-cn">{{ c.n }}</div><div class="cr-cs">{{ c.s }}</div></div>
      </div>
    </div>
    <div class="cr-grid a">
      <div class="cr-box"><span class="cr-box-ic">📥</span><span class="cr-box-t">{{ ar('استقبال','Receive') }}</span><span class="cr-box-d">{{ ar('عنوان محفظة فريد لك','Your unique wallet address') }}</span></div>
      <div class="cr-box"><span class="cr-box-ic">📤</span><span class="cr-box-t">{{ ar('إرسال','Send') }}</span><span class="cr-box-d">{{ ar('لأي محفظة بالعالم','To any wallet worldwide') }}</span></div>
      <div class="cr-box"><span class="cr-box-ic">🔄</span><span class="cr-box-t">{{ ar('تحويل','Swap') }}</span><span class="cr-box-d">{{ ar('بين الكريبتو والعملات','Between crypto & fiat') }}</span></div>
      <div class="cr-box"><span class="cr-box-ic">📊</span><span class="cr-box-t">{{ ar('تتبع','Track') }}</span><span class="cr-box-d">{{ ar('أسعار حية ومحفظتك','Live prices & portfolio') }}</span></div>
    </div>
  </div>
</section>

<!-- ████  PLANS  ████ -->
<section class="sec sec-w">
  <div class="mx">
    <div class="sec-hdr a">
      <h2 class="t2">{{ ar('خطط واضحة.','Clear plans.') }}<br><span class="t2-fade">{{ ar('بدون مفاجآت.','No surprises.') }}</span></h2>
    </div>
    <div class="pl a">
      <div v-for="(p,i) in [
        {n:'Standard',pr:ar('مجاناً','Free'),ft:[ar('بطاقة Mastercard افتراضية','Virtual Mastercard'),ar('حسابات EUR + USD + GBP','EUR + USD + GBP accounts'),'Apple Pay & Google Pay',ar('تحويلات SEPA مجانية','Free SEPA transfers')]},
        {n:'Premium',pr:'7.99€',pop:true,ft:[ar('كل مميزات Standard','All Standard features'),ar('صرف عملات غير محدود','Unlimited FX'),ar('تأمين سفر شامل','Full travel insurance'),ar('3 زيارات صالات مطارات','3 lounge visits/mo')]},
        {n:'Elite',pr:'14.99€',ft:[ar('كل مميزات Premium','All Premium features'),ar('صالات VIP غير محدودة','Unlimited VIP lounges'),ar('استرداد نقدي 1%','1% cashback'),ar('مدير حساب خاص','Personal account manager')]}
      ]" :key="i" class="pl-c" :class="{'pl-pop':p.pop}">
        <div v-if="p.pop" class="pl-badge">{{ ar('الأكثر طلباً','POPULAR') }}</div>
        <div class="pl-n">{{ p.n }}</div>
        <div class="pl-pr">{{ p.pr }}<span v-if="!['مجاناً','Free'].includes(p.pr)" class="pl-mo">/{{ ar('شهر','mo') }}</span></div>
        <div class="pl-div"></div>
        <ul class="pl-ul"><li v-for="f in p.ft" :key="f"><span class="pl-ck" :class="{'pl-ck-w':p.pop}">✓</span>{{ f }}</li></ul>
        <Link v-if="canRegister" :href="route('register')" class="pl-btn" :class="{'pl-btn-w':p.pop}">{{ ar('ابدأ','Get started') }}</Link>
      </div>
    </div>
  </div>
</section>

<!-- Numbers -->
<section class="sec sec-bk">
  <div class="mx">
    <div class="st a">
      <div v-for="s in [{v:'30+',l:ar('عملة مدعومة','Currencies')},{v:'6+',l:ar('كريبتو','Cryptos')},{v:'150+',l:ar('دولة','Countries')},{v:'24/7',l:ar('دعم فني','Support')}]" :key="s.v" class="st-i">
        <div class="st-v">{{ s.v }}</div>
        <div class="st-l">{{ s.l }}</div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="sec sec-w" style="padding:120px 0">
  <div class="mx text-center">
    <h2 class="t2 a">{{ ar('جاهز للمستقبل؟','Ready for the future?') }}</h2>
    <p class="sp a" style="margin-bottom:32px">{{ ar('سجّل الآن واحصل على وصول مبكر. مجاناً تماماً.','Sign up now and get early access. Completely free.') }}</p>
    <Link v-if="canRegister" :href="route('register')" class="cta-big a">{{ ar('افتح حسابك مجاناً →','Open your free account →') }}</Link>
  </div>
</section>

<!-- Footer -->
<footer class="ft">
  <div class="mx">
    <div class="ft-g">
      <div>
        <a href="/" class="mark mark-ft">SDB<span class="dot">.</span></a>
        <p class="ft-d">{{ ar('بنك رقمي مرخّص في الدنمارك.\nخدمات مصرفية بمعايير أوروبية.','Licensed digital bank in Denmark.\nBanking with European standards.') }}</p>
      </div>
      <div>
        <div class="ft-h">{{ ar('المنتجات','Products') }}</div>
        <div class="ft-lk"><Link href="/currencies">{{ ar('العملات','Currencies') }}</Link><Link href="/cards-info">{{ ar('البطاقات','Cards') }}</Link><Link href="/transfers-info">{{ ar('التحويلات','Transfers') }}</Link></div>
      </div>
      <div>
        <div class="ft-h">{{ ar('قانوني','Legal') }}</div>
        <div class="ft-lk"><Link href="/terms">{{ ar('الشروط','Terms') }}</Link><Link href="/privacy">{{ ar('الخصوصية','Privacy') }}</Link><Link href="/about">{{ ar('عن البنك','About') }}</Link></div>
      </div>
      <div>
        <div class="ft-h">{{ ar('تواصل','Contact') }}</div>
        <div class="ft-lk" style="gap:4px"><span>info@sdb-bank.com</span><span>+45 42 80 55 94</span><span>Denmark 🇩🇰</span></div>
      </div>
    </div>
    <div class="ft-btm">
      <span>© 2026 SDB Bank ApS</span>
      <button @click="toggleLang" class="nl">{{ ar('English','عربي') }}</button>
    </div>
  </div>
</footer>

</div>
</template>

<style>
*{margin:0;padding:0;box-sizing:border-box}
.af{font-family:'Cairo',sans-serif}
.pg{font-family:'Inter',sans-serif;color:#0a0a0a;overflow-x:hidden}
.rtl{direction:rtl}.ltr{direction:ltr}
html{scroll-behavior:smooth}
.mx{max-width:1120px;margin:0 auto;padding:0 28px}
.text-center{text-align:center}
.text-white{color:#fff}

/* ── Nav ── */
.nav{position:fixed;top:0;left:0;right:0;z-index:99;height:64px;display:flex;align-items:center;background:rgba(255,255,255,.88);backdrop-filter:blur(20px) saturate(1.8);border-bottom:1px solid rgba(0,0,0,.06)}
.mark{font-size:28px;font-weight:900;color:#0a0a0a;text-decoration:none;letter-spacing:-1.5px}
.dot{color:#2563EB;font-size:32px;line-height:0}
.nl{font-size:13px;color:#0a0a0a;opacity:.35;font-weight:500;background:none;border:none;cursor:pointer;transition:opacity .2s;text-decoration:none}.nl:hover{opacity:.7}
.nbtn{font-size:13px;font-weight:700;color:#fff;background:#0a0a0a;padding:9px 22px;border-radius:10px;text-decoration:none;transition:all .2s;border:none}.nbtn:hover{background:#222}

/* ── Hero ── */
.hero{padding:200px 0 120px;background:#fff;position:relative;overflow:hidden}
.hero::after{content:'';position:absolute;top:0;right:-20%;width:60%;height:100%;background:radial-gradient(ellipse at center,rgba(37,99,235,.04) 0%,transparent 70%);pointer-events:none}
.hero-mx{max-width:720px;position:relative;z-index:1}
.htag{font-size:11px;font-weight:800;letter-spacing:3px;color:#2563EB;margin-bottom:32px;text-transform:uppercase}
.hd{margin-bottom:28px;line-height:1}
.hd-line{display:block;font-size:clamp(3rem,7vw,5.5rem);font-weight:900;letter-spacing:-.04em;color:#0a0a0a}
.hd-em{display:block;font-size:clamp(3rem,7vw,5.5rem);font-weight:900;letter-spacing:-.04em;color:#2563EB}
.hp{font-size:17px;color:#0a0a0a;opacity:.35;line-height:1.9;margin-bottom:56px;max-width:540px}

.cd{display:flex;gap:24px;margin-bottom:48px}
.cd-b{text-align:center;min-width:60px}
.cd-n{font-size:52px;font-weight:900;color:#0a0a0a;line-height:1;font-variant-numeric:tabular-nums}
.cd-l{font-size:10px;color:#0a0a0a;opacity:.2;margin-top:8px;font-weight:700;letter-spacing:1.5px;text-transform:uppercase}

.eml{display:flex;gap:0;max-width:460px;border:2px solid #0a0a0a;border-radius:14px;overflow:hidden}
.eml-i{flex:1;padding:16px 20px;border:none;outline:none;font-size:15px;background:transparent;color:#0a0a0a;font-family:inherit}.eml-i::placeholder{color:#ccc}
.eml-b{padding:16px 28px;background:#0a0a0a;color:#fff;border:none;font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;transition:background .2s;white-space:nowrap}.eml-b:hover{background:#222}
.eml-ok{padding:16px;color:#2563EB;font-weight:700;font-size:15px}

.trust{display:flex;gap:24px;margin-top:48px;flex-wrap:wrap}
.trust-i{font-size:12px;color:#0a0a0a;opacity:.25;font-weight:600}

/* ── Marquee ── */
.mq{padding:20px 0;border-top:1px solid rgba(0,0,0,.04);border-bottom:1px solid rgba(0,0,0,.04);overflow:hidden;background:#fafafa}
.mq-track{display:flex;gap:56px;animation:mqs 18s linear infinite;white-space:nowrap}
.mq-i{font-size:13px;font-weight:800;color:#0a0a0a;opacity:.08;letter-spacing:3px;text-transform:uppercase}
@keyframes mqs{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}

/* ── Sections ── */
.sec{padding:120px 0}
.sec-w{background:#fff}
.sec-bk{background:#0a0a0a}
.sec-hdr{margin-bottom:64px}
.t2{font-size:clamp(2rem,4.5vw,3.2rem);font-weight:900;line-height:1.1;letter-spacing:-.03em}
.t2-fade{opacity:.15}
.t2-fade-w{opacity:.25}
.sp{font-size:16px;opacity:.35;line-height:1.8;max-width:440px;margin-top:16px}.sp-w{color:#fff}

/* ── Feature grid ── */
.fg{display:grid;grid-template-columns:repeat(3,1fr);gap:1px;background:rgba(0,0,0,.06);border:1px solid rgba(0,0,0,.06);border-radius:20px;overflow:hidden}
.fc{padding:36px 32px;background:#fff;transition:background .3s}.fc:hover{background:#fafafa}
.fc-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:20px}
.fc-tag{font-size:10px;font-weight:800;letter-spacing:2px;color:#2563EB;opacity:.5;text-transform:uppercase}
.fc-ic{font-size:32px}
.fc-t{font-size:17px;font-weight:800;color:#0a0a0a;margin-bottom:8px}
.fc-p{font-size:13px;color:#0a0a0a;opacity:.3;line-height:1.8}

/* ── Crypto ── */
.cr-coins{display:flex;gap:12px;margin-bottom:48px;flex-wrap:wrap}
.cr-c{display:flex;align-items:center;gap:12px;padding:14px 20px;border:1px solid rgba(255,255,255,.08);border-radius:12px;flex:1;min-width:140px}
.cr-dot{width:12px;height:12px;border-radius:50%;flex-shrink:0}
.cr-cn{font-size:14px;font-weight:700;color:#fff}
.cr-cs{font-size:11px;color:rgba(255,255,255,.25);font-weight:600}
.cr-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.06);border-radius:16px;overflow:hidden}
.cr-box{padding:28px 20px;background:#0a0a0a;text-align:center;display:flex;flex-direction:column;align-items:center;gap:8px}
.cr-box-ic{font-size:28px}
.cr-box-t{font-size:14px;font-weight:800;color:#fff}
.cr-box-d{font-size:11px;color:rgba(255,255,255,.2);line-height:1.5}

/* ── Plans ── */
.pl{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.pl-c{padding:36px 32px;border:1px solid rgba(0,0,0,.07);border-radius:20px;display:flex;flex-direction:column;transition:all .3s;position:relative;background:#fff}.pl-c:hover{box-shadow:0 8px 30px rgba(0,0,0,.06);transform:translateY(-4px)}
.pl-pop{background:#0a0a0a;border-color:transparent;color:#fff}.pl-pop:hover{box-shadow:0 8px 40px rgba(0,0,0,.3)}
.pl-badge{position:absolute;top:-11px;right:20px;font-size:10px;font-weight:800;letter-spacing:1.5px;background:#2563EB;color:#fff;padding:4px 14px;border-radius:6px;text-transform:uppercase}
.pl-n{font-size:14px;font-weight:700;opacity:.4;letter-spacing:.5px;text-transform:uppercase;margin-bottom:4px}
.pl-pr{font-size:36px;font-weight:900;margin-bottom:20px}
.pl-mo{font-size:14px;font-weight:400;opacity:.3}
.pl-div{height:1px;background:rgba(0,0,0,.06);margin-bottom:20px}.pl-pop .pl-div{background:rgba(255,255,255,.08)}
.pl-ul{list-style:none;display:flex;flex-direction:column;gap:12px;flex:1;margin-bottom:28px}
.pl-ul li{font-size:13px;display:flex;align-items:center;gap:10px;opacity:.5}.pl-pop .pl-ul li{opacity:.6}
.pl-ck{color:#2563EB;font-weight:900;font-size:13px;flex-shrink:0}.pl-ck-w{color:#60A5FA}
.pl-btn{display:block;text-align:center;padding:14px;border:2px solid rgba(0,0,0,.08);border-radius:12px;font-size:14px;font-weight:700;text-decoration:none;color:#0a0a0a;transition:all .2s}.pl-btn:hover{background:#0a0a0a;color:#fff;border-color:#0a0a0a}
.pl-btn-w{border-color:rgba(255,255,255,.15);color:#fff}.pl-btn-w:hover{background:#fff;color:#0a0a0a}

/* ── Stats ── */
.st{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.06);border-radius:16px;overflow:hidden}
.st-i{padding:48px 24px;background:#0a0a0a;text-align:center}
.st-v{font-size:44px;font-weight:900;color:#fff;margin-bottom:4px}
.st-l{font-size:12px;color:rgba(255,255,255,.2);font-weight:600}

/* ── CTA ── */
.cta-big{display:inline-block;padding:18px 48px;background:#0a0a0a;color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s;letter-spacing:-.02em}.cta-big:hover{background:#222;transform:translateY(-2px)}

/* ── Footer ── */
.ft{padding:80px 0 32px;background:#fafafa;border-top:1px solid rgba(0,0,0,.05)}
.ft-g{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:40px;margin-bottom:40px}
.mark-ft{font-size:22px;display:block;margin-bottom:8px}
.ft-d{font-size:12px;color:#0a0a0a;opacity:.2;line-height:1.7;white-space:pre-line;max-width:260px}
.ft-h{font-size:11px;font-weight:800;letter-spacing:1.5px;text-transform:uppercase;color:#0a0a0a;opacity:.2;margin-bottom:16px}
.ft-lk{display:flex;flex-direction:column;gap:10px}.ft-lk a,.ft-lk span{font-size:13px;color:#0a0a0a;opacity:.35;text-decoration:none;transition:opacity .2s}.ft-lk a:hover{opacity:.7}
.ft-btm{display:flex;justify-content:space-between;align-items:center;border-top:1px solid rgba(0,0,0,.05);padding-top:24px}
.ft-btm span{font-size:11px;color:#0a0a0a;opacity:.15}

/* ── Animation ── */
.a{opacity:0;transform:translateY(22px);transition:opacity .65s cubic-bezier(.25,.46,.45,.94),transform .65s cubic-bezier(.25,.46,.45,.94)}.a.vi{opacity:1;transform:none}

/* ── Responsive ── */
@media(max-width:768px){
  .fg{grid-template-columns:1fr}
  .pl{grid-template-columns:1fr}
  .cr-grid,.st{grid-template-columns:repeat(2,1fr)}
  .ft-g{grid-template-columns:1fr;gap:24px}
  .hero{padding:140px 0 80px}
  .sec{padding:80px 0}
  .cd{gap:14px}.cd-n{font-size:36px}
  .cr-coins{flex-direction:column}
  .trust{flex-direction:column;gap:8px}
}
</style>
