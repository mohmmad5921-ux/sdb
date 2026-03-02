<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>
<template>
<Head title="International Transfers — SDB Bank" />
<div class="pg">
  <nav class="pg-nav">
    <div class="pg-wrap flex items-center justify-between h-16">
      <Link href="/" class="pg-mark">SDB<span class="pg-dot">.</span></Link>
      <div class="hidden md:flex items-center gap-6 text-sm">
        <Link href="/" class="pg-link">Home</Link>
        <Link href="/cards-info" class="pg-link">Cards</Link>
        <Link href="/currencies" class="pg-link">Currencies</Link>
        <Link href="/transfers-info" class="pg-link pg-active">Transfers</Link>
        <Link href="/about" class="pg-link">About</Link>
      </div>
      <Link href="/preregister" class="pg-btn">Open Account</Link>
    </div>
  </nav>

  <section class="pg-hero">
    <h1 class="pg-hero-h">Send money worldwide</h1>
    <p class="pg-hero-p">Fast, secure international transfers at the real exchange rate to 150+ countries.</p>
  </section>

  <section class="pg-sec">
    <div class="pg-wrap">
      <div class="grid sm:grid-cols-4 gap-6">
        <div v-for="s in [{val:'150+',l:'Countries worldwide'},{val:'30+',l:'Supported currencies'},{val:'<60',l:'Seconds to transfer'},{val:'0.5%',l:'Fee only'}]" :key="s.val" class="tr-stat">
          <div class="tr-stat-val">{{ s.val }}</div>
          <div class="tr-stat-label">{{ s.l }}</div>
        </div>
      </div>
    </div>
  </section>

  <section class="pg-sec pg-sec-light">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">How transfers work</h2>
      <p class="pg-sub text-center max-w-xl mx-auto">Send money to anyone in the world in 3 simple steps.</p>
      <div class="grid sm:grid-cols-3 gap-8 mt-10">
        <div v-for="(s,i) in [
          {num:'01',icon:'👤',t:'Add Beneficiary',d:'Enter the recipient\'s details — name, country, and bank account number (IBAN) or phone number.'},
          {num:'02',icon:'💱',t:'Choose Amount & Currency',d:'Set the amount and choose from 30+ currencies. See the real exchange rate and fees before sending.'},
          {num:'03',icon:'🚀',t:'Send Instantly',d:'Confirm the transfer and the money arrives within seconds to minutes depending on the destination.'}
        ]" :key="i" class="tr-step">
          <div class="tr-step-num">{{ s.num }}</div>
          <div class="text-3xl mb-4">{{ s.icon }}</div>
          <h3 class="font-bold text-lg mb-2">{{ s.t }}</h3>
          <p class="text-sm text-[#0B1F3A]/45 leading-relaxed">{{ s.d }}</p>
        </div>
      </div>
    </div>
  </section>

  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">Send to 150+ countries</h2>
      <p class="pg-sub text-center max-w-xl mx-auto">Most popular destinations for our customers — and dozens more.</p>
      <div class="tr-country-grid">
        <div v-for="c in [
          {flag:'🇦🇪',name:'UAE',cur:'AED'},{flag:'🇸🇦',name:'Saudi Arabia',cur:'SAR'},
          {flag:'🇹🇷',name:'Turkey',cur:'TRY'},{flag:'🇬🇧',name:'UK',cur:'GBP'},
          {flag:'🇺🇸',name:'USA',cur:'USD'},{flag:'🇩🇪',name:'Germany',cur:'EUR'},
          {flag:'🇫🇷',name:'France',cur:'EUR'},{flag:'🇪🇬',name:'Egypt',cur:'EGP'},
          {flag:'🇯🇴',name:'Jordan',cur:'JOD'},{flag:'🇱🇧',name:'Lebanon',cur:'LBP'},
          {flag:'🇮🇶',name:'Iraq',cur:'IQD'},{flag:'🇸🇪',name:'Sweden',cur:'SEK'},
          {flag:'🇳🇴',name:'Norway',cur:'NOK'},{flag:'🇩🇰',name:'Denmark',cur:'DKK'},
          {flag:'🇨🇦',name:'Canada',cur:'CAD'},{flag:'🇦🇺',name:'Australia',cur:'AUD'},
          {flag:'🇯🇵',name:'Japan',cur:'JPY'},{flag:'🇰🇷',name:'South Korea',cur:'KRW'},
          {flag:'🇮🇳',name:'India',cur:'INR'},{flag:'🇧🇷',name:'Brazil',cur:'BRL'}
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

  <section class="pg-sec pg-sec-light">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">Transfer Types</h2>
      <div class="grid sm:grid-cols-2 gap-6 mt-10">
        <div v-for="t in [
          {icon:'⚡',t:'SEPA (Europe)',d:'Instant transfers within the Eurozone. Arrives in seconds with no additional fees. Perfect for everyday transfers.',time:'0-10 seconds',fee:'Free'},
          {icon:'🌐',t:'SWIFT (International)',d:'International transfers to any bank worldwide via the SWIFT network. Reliable and secure for any amount.',time:'1-3 business days',fee:'0.5%'},
          {icon:'📱',t:'Internal (SDB)',d:'Send money instantly to any other SDB customer for free. Just enter their phone number or username.',time:'Instant',fee:'Free'},
          {icon:'🔄',t:'Recurring Transfer',d:'Schedule automatic regular transfers — weekly or monthly. Perfect for rent or family support.',time:'Varies',fee:'Varies'}
        ]" :key="t.t" class="tr-type">
          <div class="text-3xl mb-3">{{ t.icon }}</div>
          <h3 class="font-bold text-lg mb-2">{{ t.t }}</h3>
          <p class="text-sm text-[#0B1F3A]/45 leading-relaxed mb-4">{{ t.d }}</p>
          <div class="flex gap-4">
            <div class="tr-mini-stat"><span class="tr-mini-label">Time</span><span class="tr-mini-val">{{ t.time }}</span></div>
            <div class="tr-mini-stat"><span class="tr-mini-label">Fee</span><span class="tr-mini-val">{{ t.fee }}</span></div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">Why SDB for transfers?</h2>
      <div class="grid sm:grid-cols-3 gap-6 mt-10">
        <div v-for="f in [
          {icon:'💱',t:'Real Exchange Rate',d:'The rate you see is the rate you get. No hidden markups like traditional banks.'},
          {icon:'🔒',t:'Secure & Protected',d:'Every transfer is protected with 256-bit encryption and monitored by our 24/7 fraud team.'},
          {icon:'📊',t:'Real-Time Tracking',d:'Track your transfer status in real-time with notifications at every stage until delivery.'},
          {icon:'⚡',t:'Blazing Fast',d:'SEPA transfers in seconds. International transfers arrive 3x faster than traditional banks.'},
          {icon:'💰',t:'Transparent Fees',d:'Know exactly how much you\'ll pay before confirming. No surprises, no hidden charges.'},
          {icon:'🌍',t:'150+ Countries',d:'Send to family or business partners anywhere in the world with one tap.'}
        ]" :key="f.t" class="tr-why">
          <div class="text-2xl mb-3">{{ f.icon }}</div>
          <h4 class="font-bold text-[15px] mb-1">{{ f.t }}</h4>
          <p class="text-xs text-[#0B1F3A]/40 leading-relaxed">{{ f.d }}</p>
        </div>
      </div>
    </div>
  </section>

  <section class="pg-sec pg-sec-light">
    <div class="pg-wrap max-w-3xl mx-auto">
      <h2 class="pg-h2 text-center">Transfer FAQ</h2>
      <div class="space-y-4 mt-10">
        <div v-for="q in [
          {q:'How long do international transfers take?',a:'SEPA (Europe) transfers arrive in seconds. International SWIFT transfers arrive in 1-3 business days depending on the destination country and recipient bank.'},
          {q:'What are the fees?',a:'SEPA and internal transfers are free. International transfers cost 0.5% of the amount with a minimum of €1.'},
          {q:'Can I cancel a transfer?',a:'Only pending transfers can be cancelled. Once a transfer is completed, it cannot be reversed — but our 24/7 support is available to assist.'},
          {q:'What is the maximum transfer amount?',a:'Depends on your plan: Standard up to €5,000/month, Plus up to €20,000, Premium up to €50,000, Elite up to €200,000.'},
          {q:'Are transfers secure?',a:'Yes. Every transfer is protected with 256-bit encryption, two-factor authentication, and monitored by our specialised fraud prevention team around the clock.'}
        ]" :key="q.q" class="tr-faq">
          <h4 class="font-bold text-[15px] mb-2">{{ q.q }}</h4>
          <p class="text-sm text-[#0B1F3A]/45 leading-relaxed">{{ q.a }}</p>
        </div>
      </div>
    </div>
  </section>

  <section class="pg-sec pg-sec-dark">
    <div class="pg-wrap text-center">
      <h2 class="pg-h2 text-white max-w-2xl mx-auto">Start your first international transfer today</h2>
      <p class="pg-sub text-white/35 max-w-xl mx-auto">Sign up for free and send money anywhere at the real exchange rate.</p>
      <Link href="/preregister" class="pg-btn-light pg-btn-lg">Sign up for free</Link>
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
.pg-btn-light{display:inline-flex;align-items:center;padding:14px 36px;border-radius:100px;font-weight:700;font-size:15px;background:#fff;color:#0B1F3A;transition:all .25s;text-decoration:none}.pg-btn-light:hover{background:rgba(255,255,255,0.9);transform:translateY(-1px)}
.pg-btn-lg{padding:18px 48px;font-size:17px}
.pg-hero{padding:140px 24px 60px;text-align:center;background:linear-gradient(135deg,#4DA3E8 0%,#2563EB 100%)}
.pg-hero-h{font-size:clamp(2rem,5vw,3.5rem);font-weight:900;color:#fff;margin-bottom:16px}
.pg-hero-p{font-size:18px;color:rgba(255,255,255,0.65);max-width:600px;margin:0 auto}
.pg-sec{padding:80px 0}.pg-sec-light{background:#F0F0F0}.pg-sec-dark{background:#0B1F3A}
.pg-h2{font-size:clamp(1.6rem,3vw,2.4rem);font-weight:900;margin-bottom:12px}
.pg-sub{font-size:16px;color:rgba(11,31,58,0.45);margin-bottom:32px}
.tr-stat{padding:28px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.06);border-radius:18px;text-align:center}
.tr-stat-val{font-size:36px;font-weight:900;color:#2563EB;margin-bottom:6px}
.tr-stat-label{font-size:13px;color:rgba(11,31,58,0.35);font-weight:600}
.tr-step{padding:32px 24px;background:#fff;border:1px solid rgba(11,31,58,0.05);border-radius:20px;text-align:center}
.tr-step-num{font-size:48px;font-weight:900;color:rgba(37,99,235,0.08);line-height:1;margin-bottom:8px}
.tr-country-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:10px;margin-top:32px}
.tr-country{display:flex;align-items:center;gap:12px;padding:14px 16px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.05);border-radius:12px;transition:all .3s}.tr-country:hover{border-color:rgba(37,99,235,0.15);transform:translateY(-2px)}
.tr-flag{font-size:28px}
.tr-type{padding:32px;background:#fff;border:1px solid rgba(11,31,58,0.05);border-radius:20px}
.tr-mini-stat{display:flex;flex-direction:column;gap:2px}
.tr-mini-label{font-size:10px;color:rgba(11,31,58,0.3);text-transform:uppercase;font-weight:700;letter-spacing:1px}
.tr-mini-val{font-size:13px;font-weight:700;color:#2563EB}
.tr-why{padding:24px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.05);border-radius:16px;text-align:center;transition:all .3s}.tr-why:hover{transform:translateY(-3px);box-shadow:0 8px 25px rgba(0,0,0,0.04)}
.tr-faq{padding:24px;background:#fff;border:1px solid rgba(11,31,58,0.06);border-radius:16px}
.pg-ft{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
</style>
