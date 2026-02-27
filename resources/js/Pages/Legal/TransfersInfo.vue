<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>
<template>
<Head title="التحويلات الدولية - SDB Bank" />
<div class="pg">
  <!-- NAV -->
  <nav class="pg-nav">
    <div class="pg-wrap flex items-center justify-between h-16">
      <Link href="/"><img src="/images/sdb-logo.png" alt="SDB" class="pg-logo" /></Link>
      <div class="hidden md:flex items-center gap-6 text-sm">
        <Link href="/" class="pg-link">الرئيسية</Link>
        <Link href="/cards-info" class="pg-link">البطاقات</Link>
        <Link href="/currencies" class="pg-link">العملات</Link>
        <Link href="/transfers-info" class="pg-link pg-active">التحويلات</Link>
        <Link href="/about" class="pg-link">عن البنك</Link>
      </div>
      <Link :href="route('register')" class="pg-btn">فتح حساب</Link>
    </div>
  </nav>

  <!-- HERO -->
  <section class="pg-hero">
    <h1 class="pg-hero-h">أرسل أموالك حول العالم</h1>
    <p class="pg-hero-p">تحويلات دولية سريعة وآمنة بسعر الصرف الحقيقي إلى أكثر من 150 دولة.</p>
  </section>

  <!-- STATS -->
  <section class="pg-sec">
    <div class="pg-wrap">
      <div class="grid sm:grid-cols-4 gap-6">
        <div v-for="s in [{val:'150+',l:'دولة حول العالم'},{val:'30+',l:'عملة مدعومة'},{val:'<60',l:'ثانية للتحويل'},{val:'0.5%',l:'رسوم فقط'}]" :key="s.val" class="tr-stat">
          <div class="tr-stat-val">{{ s.val }}</div>
          <div class="tr-stat-label">{{ s.l }}</div>
        </div>
      </div>
    </div>
  </section>

  <!-- HOW IT WORKS -->
  <section class="pg-sec pg-sec-light">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">كيف تعمل التحويلات</h2>
      <p class="pg-sub text-center max-w-xl mx-auto">أرسل المال لأي شخص في العالم في 3 خطوات بسيطة.</p>
      <div class="grid sm:grid-cols-3 gap-8 mt-10">
        <div v-for="(s,i) in [
          {num:'01',icon:'👤',t:'أضف المستفيد',d:'أدخل بيانات المستلم — اسمه، بلده، ورقم حسابه البنكي (IBAN) أو رقم هاتفه.'},
          {num:'02',icon:'💱',t:'اختر المبلغ والعملة',d:'حدد المبلغ واختر من بين 30+ عملة. شاهد سعر الصرف الحقيقي والرسوم قبل الإرسال.'},
          {num:'03',icon:'🚀',t:'أرسل فوراً',d:'أكّد التحويل وسيصل المال خلال ثوانٍ إلى دقائق حسب الدولة والعملة.'}
        ]" :key="i" class="tr-step">
          <div class="tr-step-num">{{ s.num }}</div>
          <div class="text-3xl mb-4">{{ s.icon }}</div>
          <h3 class="font-bold text-lg mb-2">{{ s.t }}</h3>
          <p class="text-sm text-[#0B1F3A]/45 leading-relaxed">{{ s.d }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- SUPPORTED COUNTRIES -->
  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">أرسل إلى أكثر من 150 دولة</h2>
      <p class="pg-sub text-center max-w-xl mx-auto">أكثر المناطق شعبية لعملائنا — وعشرات الدول الأخرى.</p>
      <div class="tr-country-grid">
        <div v-for="c in [
          {flag:'🇦🇪',name:'الإمارات',cur:'AED'},{flag:'🇸🇦',name:'السعودية',cur:'SAR'},
          {flag:'🇹🇷',name:'تركيا',cur:'TRY'},{flag:'🇬🇧',name:'بريطانيا',cur:'GBP'},
          {flag:'🇺🇸',name:'أمريكا',cur:'USD'},{flag:'🇩🇪',name:'ألمانيا',cur:'EUR'},
          {flag:'🇫🇷',name:'فرنسا',cur:'EUR'},{flag:'🇪🇬',name:'مصر',cur:'EGP'},
          {flag:'🇯🇴',name:'الأردن',cur:'JOD'},{flag:'🇱🇧',name:'لبنان',cur:'LBP'},
          {flag:'🇮🇶',name:'العراق',cur:'IQD'},{flag:'🇸🇪',name:'السويد',cur:'SEK'},
          {flag:'🇳🇴',name:'النرويج',cur:'NOK'},{flag:'🇩🇰',name:'الدنمارك',cur:'DKK'},
          {flag:'🇨🇦',name:'كندا',cur:'CAD'},{flag:'🇦🇺',name:'أستراليا',cur:'AUD'},
          {flag:'🇯🇵',name:'اليابان',cur:'JPY'},{flag:'🇰🇷',name:'كوريا',cur:'KRW'},
          {flag:'🇮🇳',name:'الهند',cur:'INR'},{flag:'🇧🇷',name:'البرازيل',cur:'BRL'}
        ]" :key="c.name" class="tr-country">
          <span class="tr-flag">{{ c.flag }}</span>
          <div>
            <div class="font-bold text-sm">{{ c.name }}</div>
            <div class="text-xs text-[#0B1F3A]/30">{{ c.cur }}</div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- TRANSFER TYPES -->
  <section class="pg-sec pg-sec-light">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">أنواع التحويلات</h2>
      <div class="grid sm:grid-cols-2 gap-6 mt-10">
        <div v-for="t in [
          {icon:'⚡',t:'SEPA (أوروبا)',d:'تحويلات فورية داخل منطقة اليورو. تصل خلال ثوانٍ بدون رسوم إضافية. مثالية للتحويلات اليومية.',time:'0-10 ثوانٍ',fee:'مجاني'},
          {icon:'🌐',t:'SWIFT (دولي)',d:'تحويلات دولية إلى أي بنك في العالم عبر شبكة SWIFT. موثوقة وآمنة لجميع المبالغ.',time:'1-3 أيام عمل',fee:'0.5%'},
          {icon:'📱',t:'تحويل داخلي (SDB)',d:'أرسل المال فوراً لأي عميل SDB آخر مجاناً. فقط أدخل رقم هاتفه أو اسم المستخدم.',time:'فوري',fee:'مجاني'},
          {icon:'🔄',t:'تحويل متكرر',d:'جدول تحويلات منتظمة تلقائياً — أسبوعية أو شهرية. مثالي للإيجار أو دعم العائلة.',time:'حسب النوع',fee:'حسب النوع'}
        ]" :key="t.t" class="tr-type">
          <div class="text-3xl mb-3">{{ t.icon }}</div>
          <h3 class="font-bold text-lg mb-2">{{ t.t }}</h3>
          <p class="text-sm text-[#0B1F3A]/45 leading-relaxed mb-4">{{ t.d }}</p>
          <div class="flex gap-4">
            <div class="tr-mini-stat"><span class="tr-mini-label">الوقت</span><span class="tr-mini-val">{{ t.time }}</span></div>
            <div class="tr-mini-stat"><span class="tr-mini-label">الرسوم</span><span class="tr-mini-val">{{ t.fee }}</span></div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- WHY SDB -->
  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">لماذا SDB للتحويلات؟</h2>
      <div class="grid sm:grid-cols-3 gap-6 mt-10">
        <div v-for="f in [
          {icon:'💱',t:'سعر الصرف الحقيقي',d:'السعر الذي تشوفه هو الذي تحصل عليه. بدون هوامش ربح مخفية كالبنوك التقليدية.'},
          {icon:'🔒',t:'آمنة ومحمية',d:'كل تحويل محمي بتشفير 256-bit وخاضع لمراقبة فريق مكافحة الاحتيال 24/7.'},
          {icon:'📊',t:'تتبع لحظي',d:'تابع حالة تحويلك لحظة بلحظة مع إشعارات عند كل مرحلة حتى الوصول.'},
          {icon:'⚡',t:'سرعة فائقة',d:'تحويلات SEPA في ثوانٍ، والدولية تصل أسرع بـ3 مرات من البنوك التقليدية.'},
          {icon:'💰',t:'رسوم شفافة',d:'تعرف بالضبط كم ستدفع قبل التأكيد. لا مفاجآت ولا رسوم مخفية.'},
          {icon:'🌍',t:'150+ دولة',d:'أرسل لعائلتك أو شركائك التجاريين في أي مكان في العالم بضغطة زر.'}
        ]" :key="f.t" class="tr-why">
          <div class="text-2xl mb-3">{{ f.icon }}</div>
          <h4 class="font-bold text-[15px] mb-1">{{ f.t }}</h4>
          <p class="text-xs text-[#0B1F3A]/40 leading-relaxed">{{ f.d }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- FAQ -->
  <section class="pg-sec pg-sec-light">
    <div class="pg-wrap max-w-3xl mx-auto">
      <h2 class="pg-h2 text-center">أسئلة شائعة عن التحويلات</h2>
      <div class="space-y-4 mt-10">
        <div v-for="q in [
          {q:'كم تستغرق التحويلات الدولية؟',a:'تحويلات SEPA (أوروبا) تصل خلال ثوانٍ. التحويلات الدولية عبر SWIFT تصل خلال 1-3 أيام عمل حسب الدولة والبنك المستلم.'},
          {q:'ما هي الرسوم؟',a:'تحويلات SEPA والتحويلات الداخلية مجانية. التحويلات الدولية تكلف 0.5% من المبلغ المحوّل مع حد أدنى €1.'},
          {q:'هل يمكنني إلغاء التحويل؟',a:'يمكن إلغاء التحويلات المعلقة فقط. بمجرد إتمام التحويل، لا يمكن إلغاؤه — لكن دعمنا متاح 24/7 للمساعدة.'},
          {q:'ما هو الحد الأقصى للتحويل؟',a:'يعتمد على خطتك: Standard حتى €5,000/شهرياً، Plus حتى €20,000، Premium حتى €50,000، Elite حتى €200,000.'},
          {q:'هل التحويلات آمنة؟',a:'نعم. كل تحويل محمي بتشفير 256-bit ومصادقة ثنائية وخاضع لمراقبة فريق مكافحة الاحتيال المتخصص على مدار الساعة.'}
        ]" :key="q.q" class="tr-faq">
          <h4 class="font-bold text-[15px] mb-2">{{ q.q }}</h4>
          <p class="text-sm text-[#0B1F3A]/45 leading-relaxed">{{ q.a }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- CTA -->
  <section class="pg-sec pg-sec-dark">
    <div class="pg-wrap text-center">
      <h2 class="pg-h2 text-white max-w-2xl mx-auto">ابدأ أول تحويل دولي اليوم</h2>
      <p class="pg-sub text-white/35 max-w-xl mx-auto">سجّل مجاناً وأرسل المال لأي مكان في العالم بسعر الصرف الحقيقي.</p>
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

.pg-hero{padding:140px 24px 60px;text-align:center;background:linear-gradient(135deg,#4DA3E8 0%,#2563EB 100%)}
.pg-hero-h{font-size:clamp(2rem,5vw,3.5rem);font-weight:900;color:#fff;margin-bottom:16px}
.pg-hero-p{font-size:18px;color:rgba(255,255,255,0.65);max-width:600px;margin:0 auto}

.pg-sec{padding:80px 0}.pg-sec-light{background:#F0F0F0}.pg-sec-dark{background:#0B1F3A}
.pg-h2{font-size:clamp(1.6rem,3vw,2.4rem);font-weight:900;margin-bottom:12px}
.pg-sub{font-size:16px;color:rgba(11,31,58,0.45);margin-bottom:32px}

/* STATS */
.tr-stat{padding:28px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.06);border-radius:18px;text-align:center}
.tr-stat-val{font-size:36px;font-weight:900;color:#2563EB;margin-bottom:6px}
.tr-stat-label{font-size:13px;color:rgba(11,31,58,0.35);font-weight:600}

/* STEPS */
.tr-step{padding:32px 24px;background:#fff;border:1px solid rgba(11,31,58,0.05);border-radius:20px;text-align:center}
.tr-step-num{font-size:48px;font-weight:900;color:rgba(37,99,235,0.08);line-height:1;margin-bottom:8px}

/* COUNTRIES */
.tr-country-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:10px;margin-top:32px}
.tr-country{display:flex;align-items:center;gap:12px;padding:14px 16px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.05);border-radius:12px;transition:all .3s}.tr-country:hover{border-color:rgba(37,99,235,0.15);transform:translateY(-2px)}
.tr-flag{font-size:28px}

/* TYPES */
.tr-type{padding:32px;background:#fff;border:1px solid rgba(11,31,58,0.05);border-radius:20px}
.tr-mini-stat{display:flex;flex-direction:column;gap:2px}
.tr-mini-label{font-size:10px;color:rgba(11,31,58,0.3);text-transform:uppercase;font-weight:700;letter-spacing:1px}
.tr-mini-val{font-size:13px;font-weight:700;color:#2563EB}

/* WHY */
.tr-why{padding:24px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.05);border-radius:16px;text-align:center;transition:all .3s}.tr-why:hover{transform:translateY(-3px);box-shadow:0 8px 25px rgba(0,0,0,0.04)}

/* FAQ */
.tr-faq{padding:24px;background:#fff;border:1px solid rgba(11,31,58,0.06);border-radius:16px}

.pg-ft{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
</style>
