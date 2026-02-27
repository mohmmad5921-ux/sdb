<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>
<template>
<Head title="العملات - SDB Bank | Currencies" />
<div class="pg">
  <!-- NAV -->
  <nav class="pg-nav">
    <div class="pg-wrap flex items-center justify-between h-16">
      <Link href="/"><img src="/images/sdb-logo.png" alt="SDB" class="pg-logo" /></Link>
      <div class="hidden md:flex items-center gap-6 text-sm">
        <Link href="/" class="pg-link">الرئيسية</Link>
        <Link href="/cards-info" class="pg-link">البطاقات</Link>
        <Link href="/currencies" class="pg-link pg-active">العملات</Link>
        <Link href="/transfers-info" class="pg-link">التحويلات</Link>
        <Link href="/about" class="pg-link">عن البنك</Link>
      </div>
      <Link :href="route('register')" class="pg-btn">فتح حساب</Link>
    </div>
  </nav>

  <!-- HERO -->
  <section class="pg-hero">
    <h1 class="pg-hero-h">العملات المدعومة</h1>
    <p class="pg-hero-p">تداول وحوّل بين أكثر من 30 عملة بسعر الصرف الحقيقي، بدون رسوم مخفية.</p>
  </section>

  <!-- EXCHANGE RATES -->
  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2">أسعار الصرف الحية</h2>
      <p class="pg-sub">أسعار محدثة لحظياً — ما تشوفه هو ما تحصل عليه.</p>
      <div class="fx-grid">
        <div v-for="(c,i) in [
          {from:'EUR',to:'USD',rate:'1.0842',flag:'🇪🇺',flag2:'🇺🇸'},
          {from:'EUR',to:'GBP',rate:'0.8617',flag:'🇪🇺',flag2:'🇬🇧'},
          {from:'EUR',to:'CHF',rate:'0.9486',flag:'🇪🇺',flag2:'🇨🇭'},
          {from:'EUR',to:'JPY',rate:'162.35',flag:'🇪🇺',flag2:'🇯🇵'},
          {from:'EUR',to:'AED',rate:'3.9815',flag:'🇪🇺',flag2:'🇦🇪'},
          {from:'EUR',to:'SAR',rate:'4.0658',flag:'🇪🇺',flag2:'🇸🇦'},
          {from:'EUR',to:'TRY',rate:'34.82',flag:'🇪🇺',flag2:'🇹🇷'},
          {from:'EUR',to:'CAD',rate:'1.4723',flag:'🇪🇺',flag2:'🇨🇦'},
          {from:'EUR',to:'AUD',rate:'1.6548',flag:'🇪🇺',flag2:'🇦🇺'},
          {from:'EUR',to:'SEK',rate:'11.24',flag:'🇪🇺',flag2:'🇸🇪'},
          {from:'EUR',to:'NOK',rate:'11.58',flag:'🇪🇺',flag2:'🇳🇴'},
          {from:'EUR',to:'DKK',rate:'7.4589',flag:'🇪🇺',flag2:'🇩🇰'}
        ]" :key="i" class="fx-card">
          <div class="fx-pair">
            <span class="fx-flag">{{ c.flag }}</span>
            <span class="fx-arrow">→</span>
            <span class="fx-flag">{{ c.flag2 }}</span>
          </div>
          <div class="fx-names">{{ c.from }}/{{ c.to }}</div>
          <div class="fx-rate">{{ c.rate }}</div>
        </div>
      </div>
    </div>
  </section>

  <!-- SUPPORTED CURRENCIES -->
  <section class="pg-sec pg-sec-light">
    <div class="pg-wrap">
      <h2 class="pg-h2">30+ عملة مدعومة</h2>
      <p class="pg-sub">حوّل واحتفظ بأرصدة في عشرات العملات مباشرة من حسابك.</p>
      <div class="cur-grid">
        <div v-for="(c,i) in [
          {name:'يورو',code:'EUR',flag:'🇪🇺',symbol:'€'},
          {name:'دولار أمريكي',code:'USD',flag:'🇺🇸',symbol:'$'},
          {name:'جنيه إسترليني',code:'GBP',flag:'🇬🇧',symbol:'£'},
          {name:'فرنك سويسري',code:'CHF',flag:'🇨🇭',symbol:'Fr'},
          {name:'ين ياباني',code:'JPY',flag:'🇯🇵',symbol:'¥'},
          {name:'درهم إماراتي',code:'AED',flag:'🇦🇪',symbol:'د.إ'},
          {name:'ريال سعودي',code:'SAR',flag:'🇸🇦',symbol:'﷼'},
          {name:'ليرة تركية',code:'TRY',flag:'🇹🇷',symbol:'₺'},
          {name:'دولار كندي',code:'CAD',flag:'🇨🇦',symbol:'C$'},
          {name:'دولار أسترالي',code:'AUD',flag:'🇦🇺',symbol:'A$'},
          {name:'كرونة سويدية',code:'SEK',flag:'🇸🇪',symbol:'kr'},
          {name:'كرونة نرويجية',code:'NOK',flag:'🇳🇴',symbol:'kr'},
          {name:'كرونة دنماركية',code:'DKK',flag:'🇩🇰',symbol:'kr'},
          {name:'زلوتي بولندي',code:'PLN',flag:'🇵🇱',symbol:'zł'},
          {name:'كورونا تشيكية',code:'CZK',flag:'🇨🇿',symbol:'Kč'},
          {name:'فورنت مجري',code:'HUF',flag:'🇭🇺',symbol:'Ft'},
          {name:'لي روماني',code:'RON',flag:'🇷🇴',symbol:'lei'},
          {name:'كونا كرواتية',code:'HRK',flag:'🇭🇷',symbol:'kn'},
          {name:'راند جنوب أفريقي',code:'ZAR',flag:'🇿🇦',symbol:'R'},
          {name:'دولار سنغافوري',code:'SGD',flag:'🇸🇬',symbol:'S$'},
          {name:'دولار هونغ كونغ',code:'HKD',flag:'🇭🇰',symbol:'HK$'},
          {name:'وون كوري',code:'KRW',flag:'🇰🇷',symbol:'₩'},
          {name:'بات تايلندي',code:'THB',flag:'🇹🇭',symbol:'฿'},
          {name:'بيزو مكسيكي',code:'MXN',flag:'🇲🇽',symbol:'$'}
        ]" :key="i" class="cur-card">
          <span class="cur-flag">{{ c.flag }}</span>
          <div>
            <div class="cur-code">{{ c.code }}</div>
            <div class="cur-name">{{ c.name }}</div>
          </div>
          <div class="cur-sym">{{ c.symbol }}</div>
        </div>
      </div>
    </div>
  </section>

  <!-- CRYPTO -->
  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2">العملات الرقمية</h2>
      <p class="pg-sub">تداول وراقب أسعار العملات الرقمية الأكثر شهرة مباشرة من التطبيق.</p>
      <div class="crypto-grid">
        <div v-for="(c,i) in [
          {name:'Bitcoin',sym:'BTC',price:'€89,450',change:'+2.4%',up:true,icon:'₿',color:'#F7931A'},
          {name:'Ethereum',sym:'ETH',price:'€3,210',change:'+5.1%',up:true,icon:'⟠',color:'#627EEA'},
          {name:'Tether',sym:'USDT',price:'€0.92',change:'+0.01%',up:true,icon:'₮',color:'#26A17B'},
          {name:'Solana',sym:'SOL',price:'€183.20',change:'-1.2%',up:false,icon:'◎',color:'#9945FF'},
          {name:'Ripple',sym:'XRP',price:'€2.15',change:'+3.8%',up:true,icon:'✕',color:'#23292F'},
          {name:'Cardano',sym:'ADA',price:'€0.68',change:'+1.5%',up:true,icon:'⬡',color:'#3CC8C8'}
        ]" :key="i" class="cr-card">
          <div class="cr-icon" :style="{background:c.color+'15',color:c.color}">{{ c.icon }}</div>
          <div class="cr-info">
            <div class="cr-name">{{ c.name }} <span class="cr-sym">{{ c.sym }}</span></div>
            <div class="cr-price">{{ c.price }}</div>
          </div>
          <div class="cr-change" :class="c.up ? 'cr-up' : 'cr-dn'">{{ c.change }}</div>
        </div>
      </div>
    </div>
  </section>

  <!-- WHY SDB -->
  <section class="pg-sec pg-sec-dark">
    <div class="pg-wrap text-center">
      <h2 class="pg-h2 text-white mb-8">لماذا SDB للعملات؟</h2>
      <div class="grid sm:grid-cols-3 gap-8">
        <div v-for="f in [
          {icon:'💱',t:'سعر الصرف الحقيقي',d:'بدون هوامش ربح مخفية. السعر الذي تشوفه هو الذي تحصل عليه.'},
          {icon:'⚡',t:'تحويل فوري',d:'حوّل بين العملات في ثوانٍ مباشرة من حسابك.'},
          {icon:'🔒',t:'آمن 100%',d:'تشفير متقدم وحماية على مدار الساعة لكل معاملاتك.'}
        ]" :key="f.t" class="why-card">
          <div class="why-icon">{{ f.icon }}</div>
          <h3 class="why-title">{{ f.t }}</h3>
          <p class="why-desc">{{ f.d }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- CTA -->
  <section class="pg-sec">
    <div class="pg-wrap text-center">
      <h2 class="pg-h2 max-w-2xl mx-auto">ابدأ التداول بعملات متعددة اليوم</h2>
      <p class="pg-sub max-w-xl mx-auto">افتح حسابك المجاني وابدأ التحويل بين 30+ عملة بسعر الصرف الحقيقي.</p>
      <Link :href="route('register')" class="pg-btn pg-btn-lg">فتح حساب مجاني</Link>
    </div>
  </section>

  <!-- FOOTER -->
  <footer class="pg-ft">
    <div class="pg-wrap flex flex-col md:flex-row items-center justify-between gap-3">
      <p class="text-[#0B1F3A]/20 text-xs">© 2026 SDB Bank ApS. جميع الحقوق محفوظة.</p>
      <div class="flex gap-4 text-xs text-[#0B1F3A]/30">
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
.pg-btn-lg{padding:16px 40px;font-size:16px;background:#0B1F3A;color:#fff}.pg-btn-lg:hover{background:#162d4d}

.pg-hero{padding:140px 24px 60px;text-align:center;background:linear-gradient(135deg,#4DA3E8 0%,#2563EB 100%)}
.pg-hero-h{font-size:clamp(2rem,5vw,3.5rem);font-weight:900;color:#fff;margin-bottom:16px;letter-spacing:-0.02em}
.pg-hero-p{font-size:18px;color:rgba(255,255,255,0.7);max-width:600px;margin:0 auto}

.pg-sec{padding:80px 0}.pg-sec-light{background:#F0F0F0}.pg-sec-dark{background:#0B1F3A}
.pg-h2{font-size:clamp(1.6rem,3vw,2.4rem);font-weight:900;margin-bottom:12px;letter-spacing:-0.01em}
.pg-sub{font-size:16px;color:rgba(11,31,58,0.45);margin-bottom:32px}

/* EXCHANGE RATES */
.fx-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:12px}
.fx-card{display:flex;align-items:center;gap:12px;padding:18px 20px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.06);border-radius:14px;transition:all .3s}.fx-card:hover{border-color:rgba(37,99,235,0.2);box-shadow:0 8px 25px rgba(37,99,235,0.06)}
.fx-pair{display:flex;align-items:center;gap:6px}
.fx-flag{font-size:24px}.fx-arrow{color:rgba(11,31,58,0.2);font-size:14px}
.fx-names{font-weight:700;font-size:14px;flex:1}
.fx-rate{font-weight:800;font-size:16px;color:#2563EB}

/* CURRENCIES */
.cur-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:10px}
.cur-card{display:flex;align-items:center;gap:12px;padding:14px 16px;background:#fff;border:1px solid rgba(11,31,58,0.06);border-radius:12px;transition:all .3s}.cur-card:hover{border-color:rgba(37,99,235,0.15);transform:translateY(-2px)}
.cur-flag{font-size:28px}
.cur-code{font-weight:800;font-size:14px}
.cur-name{font-size:11px;color:rgba(11,31,58,0.4)}
.cur-sym{margin-right:auto;font-weight:700;font-size:16px;color:rgba(11,31,58,0.2)}

/* CRYPTO */
.crypto-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:14px}
.cr-card{display:flex;align-items:center;gap:14px;padding:20px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.06);border-radius:16px;transition:all .3s}.cr-card:hover{border-color:rgba(37,99,235,0.15);box-shadow:0 8px 20px rgba(0,0,0,0.04)}
.cr-icon{width:48px;height:48px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:22px;font-weight:bold;flex-shrink:0}
.cr-info{flex:1}.cr-name{font-weight:700;font-size:15px}.cr-sym{font-weight:400;font-size:12px;color:rgba(11,31,58,0.3)}
.cr-price{font-weight:800;font-size:18px;margin-top:2px}
.cr-change{padding:5px 12px;border-radius:8px;font-size:13px;font-weight:700}
.cr-up{background:rgba(0,208,132,0.1);color:#00D084}
.cr-dn{background:rgba(255,59,48,0.1);color:#FF3B30}

/* WHY */
.why-card{padding:32px;border-radius:20px;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.08)}
.why-icon{font-size:36px;margin-bottom:16px}
.why-title{font-weight:800;font-size:18px;color:#fff;margin-bottom:8px}
.why-desc{font-size:14px;color:rgba(255,255,255,0.4);line-height:1.7}

.pg-ft{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
</style>
