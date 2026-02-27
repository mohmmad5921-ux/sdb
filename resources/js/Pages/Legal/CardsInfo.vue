<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>
<template>
<Head title="بطاقات Mastercard - SDB Bank" />
<div class="pg">
  <!-- NAV -->
  <nav class="pg-nav">
    <div class="pg-wrap flex items-center justify-between h-16">
      <Link href="/"><img src="/images/sdb-logo.png" alt="SDB" class="pg-logo" /></Link>
      <div class="hidden md:flex items-center gap-6 text-sm">
        <Link href="/" class="pg-link">الرئيسية</Link>
        <Link href="/cards-info" class="pg-link pg-active">البطاقات</Link>
        <Link href="/currencies" class="pg-link">العملات</Link>
        <Link href="/transfers-info" class="pg-link">التحويلات</Link>
        <Link href="/about" class="pg-link">عن البنك</Link>
      </div>
      <Link :href="route('register')" class="pg-btn">فتح حساب</Link>
    </div>
  </nav>

  <!-- HERO -->
  <section class="pg-hero pg-hero-dark">
    <h1 class="pg-hero-h">بطاقات Mastercard من SDB</h1>
    <p class="pg-hero-p">بطاقات افتراضية ومعدنية فاخرة. ادفع في كل مكان، عبر الإنترنت أو في المتاجر، مع حماية كاملة.</p>
    <Link :href="route('register')" class="pg-btn-light mt-6">احصل على بطاقتك</Link>
  </section>

  <!-- CARD TIERS -->
  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">اختر بطاقتك المثالية</h2>
      <p class="pg-sub text-center max-w-2xl mx-auto">من البطاقة الافتراضية المجانية إلى البطاقة المعدنية الفاخرة — لدينا ما يناسب أسلوب حياتك.</p>

      <!-- STANDARD -->
      <div class="cd-tier">
        <div class="cd-tier-img"><img src="/images/card-standard.png" alt="Standard" /></div>
        <div class="cd-tier-info">
          <span class="cd-badge">مجاني</span>
          <h3 class="cd-name">Standard</h3>
          <p class="cd-desc">بطاقة Mastercard افتراضية مجانية تحصل عليها فوراً عند فتح حسابك. مثالية للدفع عبر الإنترنت والمشتريات اليومية.</p>
          <ul class="cd-features">
            <li>✓ بطاقة Mastercard افتراضية فورية</li>
            <li>✓ Apple Pay & Google Pay</li>
            <li>✓ دفع عبر الإنترنت في أي متجر</li>
            <li>✓ حد سحب يومي €500</li>
            <li>✓ إشعارات فورية لكل عملية</li>
            <li>✓ تجميد فوري من التطبيق</li>
          </ul>
        </div>
      </div>

      <!-- PLUS -->
      <div class="cd-tier cd-tier-rev">
        <div class="cd-tier-info">
          <span class="cd-badge cd-badge-plus">3.99€/شهرياً</span>
          <h3 class="cd-name">Plus</h3>
          <p class="cd-desc">بطاقة Mastercard معدنية راقية مع حدود أعلى وحماية مشتريات. للمنفق الذكي الذي يريد المزيد.</p>
          <ul class="cd-features">
            <li>✓ بطاقة Mastercard معدنية فاخرة</li>
            <li>✓ حماية مشتريات حتى €1,000</li>
            <li>✓ حدود يومية مضاعفة €2,000</li>
            <li>✓ دعم أولوية 24/7</li>
            <li>✓ CVV متغير لحماية إضافية</li>
            <li>✓ تحويلات دولية بدون رسوم (حتى €1,000/شهرياً)</li>
          </ul>
        </div>
        <div class="cd-tier-img"><img src="/images/card-plus.png" alt="Plus" /></div>
      </div>

      <!-- PREMIUM -->
      <div class="cd-tier">
        <div class="cd-tier-img"><img src="/images/card-premium.png" alt="Premium" /></div>
        <div class="cd-tier-info">
          <span class="cd-badge cd-badge-prem">7.99€/شهرياً</span>
          <h3 class="cd-name">Premium</h3>
          <p class="cd-desc">لمحبي السفر والتسوق الدولي. صرف عملات غير محدود، تأمين سفر شامل، وصالات مطارات حول العالم.</p>
          <ul class="cd-features">
            <li>✓ صرف عملات غير محدود بسعر السوق</li>
            <li>✓ تأمين سفر شامل (طبي + إلغاء + تأخير)</li>
            <li>✓ 3 زيارات شهرية لصالات المطارات</li>
            <li>✓ بيانات eSIM دولية (3GB/شهر)</li>
            <li>✓ حماية مشتريات حتى €5,000</li>
            <li>✓ حد سحب يومي €5,000</li>
          </ul>
        </div>
      </div>

      <!-- ELITE -->
      <div class="cd-tier cd-tier-rev">
        <div class="cd-tier-info">
          <span class="cd-badge cd-badge-elite">14.99€/شهرياً</span>
          <h3 class="cd-name">Elite</h3>
          <p class="cd-desc">القمة في الخدمات المصرفية الرقمية. صالات VIP غير محدودة، مدير حساب خاص، واسترداد نقدي على كل عملية.</p>
          <ul class="cd-features">
            <li>✓ صالات مطارات VIP غير محدودة</li>
            <li>✓ مدير حساب شخصي مخصص</li>
            <li>✓ استرداد نقدي 1% على كل عملية</li>
            <li>✓ تأمين شامل (سفر + صحة + مركبة)</li>
            <li>✓ بيانات eSIM دولية (10GB/شهر)</li>
            <li>✓ حد سحب يومي €10,000</li>
            <li>✓ اشتراكات شركاء بقيمة €2,100/سنوياً</li>
          </ul>
        </div>
        <div class="cd-tier-img"><img src="/images/card-elite.png" alt="Elite" /></div>
      </div>
    </div>
  </section>

  <!-- COMPARISON TABLE -->
  <section class="pg-sec pg-sec-light">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">مقارنة البطاقات</h2>
      <div class="cd-table-wrap">
        <table class="cd-table">
          <thead>
            <tr>
              <th>الميزة</th>
              <th>Standard</th>
              <th>Plus</th>
              <th>Premium</th>
              <th>Elite</th>
            </tr>
          </thead>
          <tbody>
            <tr><td>السعر الشهري</td><td>مجاني</td><td>3.99€</td><td>7.99€</td><td>14.99€</td></tr>
            <tr><td>بطاقة افتراضية</td><td>✓</td><td>✓</td><td>✓</td><td>✓</td></tr>
            <tr><td>بطاقة معدنية</td><td>—</td><td>✓</td><td>✓</td><td>✓</td></tr>
            <tr><td>Apple Pay & Google Pay</td><td>✓</td><td>✓</td><td>✓</td><td>✓</td></tr>
            <tr><td>حد السحب اليومي</td><td>€500</td><td>€2,000</td><td>€5,000</td><td>€10,000</td></tr>
            <tr><td>صرف عملات مجاني</td><td>€200/شهر</td><td>€1,000/شهر</td><td>غير محدود</td><td>غير محدود</td></tr>
            <tr><td>حماية مشتريات</td><td>—</td><td>€1,000</td><td>€5,000</td><td>€10,000</td></tr>
            <tr><td>تأمين سفر</td><td>—</td><td>—</td><td>✓</td><td>✓ شامل</td></tr>
            <tr><td>صالات مطارات</td><td>—</td><td>—</td><td>3/شهر</td><td>غير محدود</td></tr>
            <tr><td>CVV متغير</td><td>—</td><td>✓</td><td>✓</td><td>✓</td></tr>
            <tr><td>استرداد نقدي</td><td>—</td><td>—</td><td>0.5%</td><td>1%</td></tr>
            <tr><td>مدير حساب خاص</td><td>—</td><td>—</td><td>—</td><td>✓</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>

  <!-- FEATURES -->
  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">ميزات كل البطاقات</h2>
      <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6 mt-10">
        <div v-for="f in [
          {icon:'📱',t:'Apple Pay & Google Pay',d:'أضف بطاقتك إلى محفظتك الرقمية وادفع بهاتفك أو ساعتك الذكية في أي متجر.'},
          {icon:'❄️',t:'تجميد فوري',d:'جمّد بطاقتك فوراً من التطبيق إذا فقدتها أو شككت بعملية غريبة. فعّلها مرة أخرى بضغطة.'},
          {icon:'🔄',t:'CVV متغير',d:'رمز أمان يتغير تلقائياً كل ساعة لحماية إضافية في عمليات الشراء عبر الإنترنت.'},
          {icon:'🔔',t:'إشعارات فورية',d:'كل عملية دفع أو سحب تحصل على إشعار فوري مع التفاصيل الكاملة على هاتفك.'},
          {icon:'🌍',t:'ادفع في كل مكان',d:'بطاقة Mastercard مقبولة في أكثر من 80 مليون متجر حول العالم وعبر الإنترنت.'},
          {icon:'💱',t:'تحويل تلقائي',d:'ادفع بأي عملة والتحويل يتم تلقائياً بسعر الصرف الحقيقي بدون رسوم مخفية.'},
          {icon:'🛡️',t:'حماية 3D Secure',d:'طبقة أمان إضافية تتحقق من هويتك عند الدفع عبر الإنترنت لمنع الاحتيال.'},
          {icon:'📊',t:'تحليل المصاريف',d:'تابع أين تذهب أموالك مع تصنيف تلقائي لمصاريفك وتقارير شهرية مفصلة.'},
          {icon:'🔐',t:'أمان متعدد الطبقات',d:'تشفير 256-bit، مصادقة ثنائية، وبصمة الوجه أو الإصبع لكل عملية.'}
        ]" :key="f.t" class="cd-feat">
          <div class="cd-feat-icon">{{ f.icon }}</div>
          <h4 class="cd-feat-title">{{ f.t }}</h4>
          <p class="cd-feat-desc">{{ f.d }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- CTA -->
  <section class="pg-sec pg-sec-dark">
    <div class="pg-wrap text-center">
      <h2 class="pg-h2 text-white max-w-2xl mx-auto">احصل على بطاقة Mastercard الخاصة بك اليوم</h2>
      <p class="pg-sub text-white/35 max-w-xl mx-auto">سجّل خلال دقائق واحصل على بطاقة افتراضية فوراً. بدون رسوم خفية.</p>
      <Link :href="route('register')" class="pg-btn-light pg-btn-lg">سجّل الآن مجاناً</Link>
    </div>
  </section>

  <!-- FOOTER -->
  <footer class="pg-ft">
    <div class="pg-wrap flex flex-col md:flex-row items-center justify-between gap-3">
      <p class="text-[#0B1F3A]/20 text-xs">© 2026 SDB Bank ApS. جميع الحقوق محفوظة.</p>
      <div class="flex gap-4 text-xs text-[#0B1F3A]/30">
        <Link href="/">الرئيسية</Link>
        <Link href="/terms">الشروط</Link>
        <Link href="/privacy">الخصوصية</Link>
        <Link href="/support">الدعم</Link>
      </div>
    </div>
  </footer>
</div>
</template>

<style scoped>
.pg{font-family:'Inter','Cairo',sans-serif;background:#fff;color:#0B1F3A;direction:rtl}
.pg-wrap{max-width:1200px;margin:0 auto;padding:0 24px}
.pg-nav{position:fixed;top:0;left:0;right:0;z-index:50;background:rgba(11,31,58,0.95);backdrop-filter:blur(20px)}
.pg-logo{height:40px;filter:brightness(0) invert(1)}
.pg-link{color:rgba(255,255,255,0.5);font-weight:500;transition:color .3s}.pg-link:hover,.pg-active{color:#fff}
.pg-btn{display:inline-flex;align-items:center;padding:10px 28px;border-radius:100px;font-weight:700;font-size:14px;background:#fff;color:#0B1F3A;transition:all .25s}.pg-btn:hover{background:rgba(255,255,255,0.85)}
.pg-btn-light{display:inline-flex;align-items:center;padding:14px 36px;border-radius:100px;font-weight:700;font-size:15px;background:#fff;color:#0B1F3A;transition:all .25s}.pg-btn-light:hover{background:rgba(255,255,255,0.9);transform:translateY(-1px)}
.pg-btn-lg{padding:18px 48px;font-size:17px}

.pg-hero{padding:140px 24px 60px;text-align:center}
.pg-hero-dark{background:linear-gradient(135deg,#0B1F3A 0%,#162d4d 50%,#0B1F3A 100%)}
.pg-hero-h{font-size:clamp(2rem,5vw,3.5rem);font-weight:900;color:#fff;margin-bottom:16px}
.pg-hero-p{font-size:18px;color:rgba(255,255,255,0.5);max-width:600px;margin:0 auto}

.pg-sec{padding:80px 0}.pg-sec-light{background:#F0F0F0}.pg-sec-dark{background:#0B1F3A}
.pg-h2{font-size:clamp(1.6rem,3vw,2.4rem);font-weight:900;margin-bottom:12px}
.pg-sub{font-size:16px;color:rgba(11,31,58,0.45);margin-bottom:32px}

/* CARD TIERS */
.cd-tier{display:grid;grid-template-columns:1fr 1fr;gap:48px;align-items:center;padding:60px 0;border-bottom:1px solid rgba(11,31,58,0.06)}
.cd-tier-rev{direction:rtl}
.cd-tier:last-of-type{border-bottom:none}
.cd-tier-img img{width:100%;max-width:380px;border-radius:20px;box-shadow:0 20px 50px rgba(0,0,0,0.15);transition:transform .5s}.cd-tier-img img:hover{transform:perspective(600px) rotateY(-5deg) scale(1.02)}
.cd-badge{display:inline-flex;padding:6px 18px;border-radius:100px;font-size:13px;font-weight:700;background:rgba(37,99,235,0.08);color:#2563EB;margin-bottom:12px}
.cd-badge-plus{background:rgba(168,85,247,0.08);color:#A855F7}
.cd-badge-prem{background:rgba(236,72,153,0.08);color:#EC4899}
.cd-badge-elite{background:rgba(245,158,11,0.08);color:#D97706}
.cd-name{font-size:2rem;font-weight:900;margin-bottom:12px}
.cd-desc{font-size:15px;color:rgba(11,31,58,0.5);line-height:1.7;margin-bottom:20px}
.cd-features{list-style:none;space-y:8px;padding:0}.cd-features li{padding:6px 0;font-size:14px;color:rgba(11,31,58,0.6);border-bottom:1px solid rgba(11,31,58,0.04)}

/* COMPARISON TABLE */
.cd-table-wrap{overflow-x:auto;margin-top:32px}
.cd-table{width:100%;border-collapse:collapse;font-size:14px}
.cd-table th{padding:14px 16px;text-align:center;font-weight:800;background:#0B1F3A;color:#fff;font-size:13px}.cd-table th:first-child{text-align:right;border-radius:12px 0 0 0}.cd-table th:last-child{border-radius:0 12px 0 0}
.cd-table td{padding:12px 16px;text-align:center;border-bottom:1px solid rgba(11,31,58,0.06);font-size:13px;color:rgba(11,31,58,0.6)}.cd-table td:first-child{text-align:right;font-weight:600;color:#0B1F3A}
.cd-table tbody tr:hover{background:rgba(37,99,235,0.02)}
.cd-table tbody tr:last-child td{border-bottom:none}

/* FEATURES */
.cd-feat{padding:28px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.05);border-radius:18px;transition:all .3s}.cd-feat:hover{transform:translateY(-3px);box-shadow:0 10px 30px rgba(0,0,0,0.05)}
.cd-feat-icon{font-size:28px;margin-bottom:12px}
.cd-feat-title{font-weight:800;font-size:15px;margin-bottom:8px}
.cd-feat-desc{font-size:13px;color:rgba(11,31,58,0.45);line-height:1.7}

.pg-ft{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}

@media(max-width:768px){.cd-tier{grid-template-columns:1fr;gap:24px}.cd-tier-rev{direction:rtl}.pg-hero-h{font-size:2rem}}
</style>
