<script setup>
import { Head, Link } from '@inertiajs/vue3';

const cryptoList = [
  {name:'Bitcoin',sym:'BTC',price:'€89,450',change:'+2.4%',up:true,icon:'₿',color:'#F7931A'},
  {name:'Ethereum',sym:'ETH',price:'€3,210',change:'+5.1%',up:true,icon:'⟠',color:'#627EEA'},
  {name:'Tether',sym:'USDT',price:'€0.92',change:'+0.01%',up:true,icon:'₮',color:'#26A17B'},
  {name:'Solana',sym:'SOL',price:'€183.20',change:'-1.2%',up:false,icon:'◎',color:'#9945FF'},
  {name:'Ripple',sym:'XRP',price:'€2.15',change:'+3.8%',up:true,icon:'✕',color:'#23292F'},
  {name:'Cardano',sym:'ADA',price:'€0.68',change:'+1.5%',up:true,icon:'⬡',color:'#3CC8C8'},
];
</script>
<template>
<Head title="Currencies — SDB Bank" />
<div class="pg">
  <nav class="pg-nav">
    <div class="pg-wrap flex items-center justify-between h-16">
      <Link href="/" class="pg-mark">SDB<span class="pg-dot">.</span></Link>
      <div class="hidden md:flex items-center gap-6 text-sm">
        <Link href="/" class="pg-link">Home</Link>
        <Link href="/cards-info" class="pg-link">Cards</Link>
        <Link href="/currencies" class="pg-link pg-active">Currencies</Link>
        <Link href="/transfers-info" class="pg-link">Transfers</Link>
        <Link href="/about" class="pg-link">About</Link>
      </div>
      <Link href="/preregister" class="pg-btn">Open Account</Link>
    </div>
  </nav>

  <section class="pg-hero">
    <h1 class="pg-hero-h">Supported Currencies</h1>
    <p class="pg-hero-p">Trade and convert between 30+ currencies at the real exchange rate, with no hidden fees.</p>
  </section>

  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2">Live Exchange Rates</h2>
      <p class="pg-sub">Updated in real-time — what you see is what you get.</p>
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

  <section class="pg-sec pg-sec-light">
    <div class="pg-wrap">
      <h2 class="pg-h2">30+ Supported Currencies</h2>
      <p class="pg-sub">Convert and hold balances in dozens of currencies directly from your account.</p>
      <div class="cur-grid">
        <div v-for="(c,i) in [
          {name:'Euro',code:'EUR',flag:'🇪🇺',symbol:'€'},
          {name:'US Dollar',code:'USD',flag:'🇺🇸',symbol:'$'},
          {name:'British Pound',code:'GBP',flag:'🇬🇧',symbol:'£'},
          {name:'Swiss Franc',code:'CHF',flag:'🇨🇭',symbol:'Fr'},
          {name:'Japanese Yen',code:'JPY',flag:'🇯🇵',symbol:'¥'},
          {name:'UAE Dirham',code:'AED',flag:'🇦🇪',symbol:'د.إ'},
          {name:'Saudi Riyal',code:'SAR',flag:'🇸🇦',symbol:'﷼'},
          {name:'Turkish Lira',code:'TRY',flag:'🇹🇷',symbol:'₺'},
          {name:'Canadian Dollar',code:'CAD',flag:'🇨🇦',symbol:'C$'},
          {name:'Australian Dollar',code:'AUD',flag:'🇦🇺',symbol:'A$'},
          {name:'Swedish Krona',code:'SEK',flag:'🇸🇪',symbol:'kr'},
          {name:'Norwegian Krone',code:'NOK',flag:'🇳🇴',symbol:'kr'},
          {name:'Danish Krone',code:'DKK',flag:'🇩🇰',symbol:'kr'},
          {name:'Polish Złoty',code:'PLN',flag:'🇵🇱',symbol:'zł'},
          {name:'Czech Koruna',code:'CZK',flag:'🇨🇿',symbol:'Kč'},
          {name:'Hungarian Forint',code:'HUF',flag:'🇭🇺',symbol:'Ft'},
          {name:'Romanian Leu',code:'RON',flag:'🇷🇴',symbol:'lei'},
          {name:'Croatian Kuna',code:'HRK',flag:'🇭🇷',symbol:'kn'},
          {name:'South African Rand',code:'ZAR',flag:'🇿🇦',symbol:'R'},
          {name:'Singapore Dollar',code:'SGD',flag:'🇸🇬',symbol:'S$'},
          {name:'Hong Kong Dollar',code:'HKD',flag:'🇭🇰',symbol:'HK$'},
          {name:'South Korean Won',code:'KRW',flag:'🇰🇷',symbol:'₩'},
          {name:'Thai Baht',code:'THB',flag:'🇹🇭',symbol:'฿'},
          {name:'Mexican Peso',code:'MXN',flag:'🇲🇽',symbol:'$'}
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

  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2">Cryptocurrencies</h2>
      <p class="pg-sub">Trade and monitor the most popular digital currencies — buy directly from your account.</p>
      <div class="crypto-grid">
        <div v-for="(c,i) in cryptoList" :key="i" class="cr-card">
          <div class="cr-icon" :style="{background:c.color+'15',color:c.color}">{{ c.icon }}</div>
          <div class="cr-info">
            <div class="cr-name">{{ c.name }} <span class="cr-sym">{{ c.sym }}</span></div>
            <div class="cr-price">{{ c.price }}</div>
          </div>
          <div class="cr-actions">
            <div class="cr-change" :class="c.up ? 'cr-up' : 'cr-dn'">{{ c.change }}</div>
            <Link href="/preregister" class="cr-buy-btn">Buy {{ c.sym }}</Link>
          </div>
        </div>
      </div>
      <div class="mp-badge">
        <span class="mp-badge-text">🔒 Sign up and start trading</span>
        <span class="mp-badge-logo">SDB Crypto</span>
      </div>
    </div>
  </section>

  <section class="pg-sec pg-sec-dark">
    <div class="pg-wrap text-center">
      <h2 class="pg-h2 text-white mb-8">Why SDB for currencies?</h2>
      <div class="grid sm:grid-cols-3 gap-8">
        <div v-for="f in [
          {icon:'💱',t:'Real Exchange Rate',d:'No hidden markups. The rate you see is the rate you get.'},
          {icon:'⚡',t:'Instant Conversion',d:'Convert between currencies in seconds directly from your account.'},
          {icon:'🔒',t:'100% Secure',d:'Advanced encryption and round-the-clock protection for all your transactions.'}
        ]" :key="f.t" class="why-card">
          <div class="why-icon">{{ f.icon }}</div>
          <h3 class="why-title">{{ f.t }}</h3>
          <p class="why-desc">{{ f.d }}</p>
        </div>
      </div>
    </div>
  </section>

  <section class="pg-sec">
    <div class="pg-wrap text-center">
      <h2 class="pg-h2 max-w-2xl mx-auto">Start trading multi-currency today</h2>
      <p class="pg-sub max-w-xl mx-auto">Open your free account and start converting between 30+ currencies at the real exchange rate.</p>
      <Link href="/preregister" class="pg-btn pg-btn-lg">Open free account</Link>
    </div>
  </section>

  <footer class="pg-ft">
    <div class="pg-wrap flex flex-col md:flex-row items-center justify-between gap-3">
      <p class="text-[#0B1F3A]/20 text-xs">© 2026 SDB Bank ApS. All rights reserved.</p>
      <div class="flex gap-4 text-xs text-[#0B1F3A]/30"><Link href="/">Home</Link><Link href="/terms">Terms</Link><Link href="/privacy">Privacy</Link><Link href="/support">Support</Link></div>
    </div>
  </footer>
</div>
</template>

<style scoped>
.pg{font-family:'Inter',sans-serif;background:#fff;color:#0B1F3A}
.pg-wrap{max-width:1200px;margin:0 auto;padding:0 24px}
.pg-nav{position:fixed;top:0;left:0;right:0;z-index:50;background:rgba(11,31,58,0.95);backdrop-filter:blur(20px)}
.pg-mark{font-size:24px;font-weight:900;color:#fff;text-decoration:none;letter-spacing:-1.5px}
.pg-dot{color:#60A5FA;font-size:28px;line-height:0}
.pg-link{color:rgba(255,255,255,0.5);font-weight:500;transition:color .3s;text-decoration:none}.pg-link:hover,.pg-active{color:#fff}
.pg-btn{display:inline-flex;align-items:center;padding:10px 28px;border-radius:100px;font-weight:700;font-size:14px;background:#fff;color:#0B1F3A;transition:all .25s;text-decoration:none}.pg-btn:hover{background:rgba(255,255,255,0.85)}
.pg-btn-lg{padding:18px 48px;font-size:17px;background:#0B1F3A;color:#fff;border-radius:100px;font-weight:700;text-decoration:none;transition:all .25s;display:inline-flex}.pg-btn-lg:hover{background:#162d4d}
.pg-hero{padding:140px 24px 60px;text-align:center;background:linear-gradient(135deg,#0B1F3A 0%,#162d4d 50%,#0B1F3A 100%)}
.pg-hero-h{font-size:clamp(2rem,5vw,3.5rem);font-weight:900;color:#fff;margin-bottom:16px}
.pg-hero-p{font-size:18px;color:rgba(255,255,255,0.5);max-width:600px;margin:0 auto}
.pg-sec{padding:80px 0}.pg-sec-light{background:#F0F0F0}.pg-sec-dark{background:#0B1F3A}
.pg-h2{font-size:clamp(1.6rem,3vw,2.4rem);font-weight:900;margin-bottom:12px}
.pg-sub{font-size:16px;color:rgba(11,31,58,0.45);margin-bottom:32px}

.fx-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:10px;margin-top:24px}
.fx-card{padding:16px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.05);border-radius:14px;display:flex;align-items:center;gap:12px;transition:all .3s}.fx-card:hover{border-color:rgba(37,99,235,0.15);transform:translateY(-2px)}
.fx-pair{display:flex;align-items:center;gap:4px}
.fx-flag{font-size:20px}
.fx-arrow{color:rgba(11,31,58,0.15);font-size:14px}
.fx-names{font-size:13px;font-weight:700;flex:1}
.fx-rate{font-size:14px;font-weight:800;color:#2563EB}

.cur-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:8px}
.cur-card{display:flex;align-items:center;gap:12px;padding:14px 16px;background:#fff;border:1px solid rgba(11,31,58,0.06);border-radius:12px;transition:all .3s}.cur-card:hover{border-color:rgba(37,99,235,0.15);transform:translateY(-1px)}
.cur-flag{font-size:24px}
.cur-code{font-size:14px;font-weight:800}
.cur-name{font-size:11px;color:rgba(11,31,58,0.4)}
.cur-sym{margin-left:auto;font-size:16px;font-weight:800;color:rgba(11,31,58,0.15)}

.crypto-grid{display:grid;gap:8px}
.cr-card{display:flex;align-items:center;gap:16px;padding:18px 20px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.05);border-radius:14px;transition:all .3s}.cr-card:hover{border-color:rgba(37,99,235,0.12);transform:translateY(-1px)}
.cr-icon{width:44px;height:44px;display:flex;align-items:center;justify-content:center;border-radius:12px;font-size:20px;font-weight:800}
.cr-info{flex:1}
.cr-name{font-size:15px;font-weight:700}
.cr-sym{font-size:12px;color:rgba(11,31,58,0.3);font-weight:500;margin-left:6px}
.cr-price{font-size:13px;color:rgba(11,31,58,0.45);font-weight:600}
.cr-actions{display:flex;align-items:center;gap:12px}
.cr-change{font-size:13px;font-weight:700;padding:4px 10px;border-radius:8px}
.cr-up{background:rgba(16,185,129,0.08);color:#10B981}
.cr-dn{background:rgba(239,68,68,0.08);color:#EF4444}
.cr-buy-btn{padding:8px 16px;background:#2563EB;color:#fff;font-size:12px;font-weight:700;border-radius:10px;text-decoration:none;transition:all .3s}.cr-buy-btn:hover{background:#1d4ed8}

.mp-badge{display:flex;align-items:center;justify-content:center;gap:12px;margin-top:24px;padding:14px;background:rgba(37,99,235,0.04);border:1px solid rgba(37,99,235,0.08);border-radius:12px}
.mp-badge-text{font-size:13px;color:rgba(11,31,58,0.5)}
.mp-badge-logo{font-size:14px;font-weight:900;color:#2563EB}

.why-card{padding:28px;border:1px solid rgba(255,255,255,0.08);border-radius:18px;transition:all .3s}.why-card:hover{border-color:rgba(255,255,255,0.15)}
.why-icon{font-size:32px;margin-bottom:12px}
.why-title{font-size:16px;font-weight:800;color:#fff;margin-bottom:8px}
.why-desc{font-size:13px;color:rgba(255,255,255,0.35);line-height:1.7}

.pg-ft{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
</style>
