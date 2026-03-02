<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>
<template>
<Head title="Mastercard Cards — SDB Bank" />
<div class="pg">
  <nav class="pg-nav">
    <div class="pg-wrap flex items-center justify-between h-16">
      <Link href="/" class="pg-mark">SDB<span class="pg-dot">.</span></Link>
      <div class="hidden md:flex items-center gap-6 text-sm">
        <Link href="/" class="pg-link">Home</Link>
        <Link href="/cards-info" class="pg-link pg-active">Cards</Link>
        <Link href="/currencies" class="pg-link">Currencies</Link>
        <Link href="/transfers-info" class="pg-link">Transfers</Link>
        <Link href="/about" class="pg-link">About</Link>
      </div>
      <Link href="/preregister" class="pg-btn">Open Account</Link>
    </div>
  </nav>

  <section class="pg-hero pg-hero-dark">
    <h1 class="pg-hero-h">SDB Mastercard Cards</h1>
    <p class="pg-hero-p">Virtual and premium metal cards. Pay anywhere, online or in-store, with full protection.</p>
    <Link href="/preregister" class="pg-btn-light mt-6">Get your card</Link>
  </section>

  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">Choose your perfect card</h2>
      <p class="pg-sub text-center max-w-2xl mx-auto">From a free virtual card to a premium metal card — we have something for your lifestyle.</p>

      <div class="cd-tier">
        <div class="cd-tier-img"><div class="cd-placeholder">💳</div></div>
        <div class="cd-tier-info">
          <span class="cd-badge">Free</span>
          <h3 class="cd-name">Standard</h3>
          <p class="cd-desc">A free virtual Mastercard issued instantly when you open your account. Perfect for online payments and everyday purchases.</p>
          <ul class="cd-features">
            <li>✓ Instant virtual Mastercard</li>
            <li>✓ Apple Pay & Google Pay</li>
            <li>✓ Pay online at any store</li>
            <li>✓ Daily withdrawal limit €500</li>
            <li>✓ Instant notifications for every transaction</li>
            <li>✓ Instant freeze from the app</li>
          </ul>
        </div>
      </div>

      <div class="cd-tier cd-tier-rev">
        <div class="cd-tier-info">
          <span class="cd-badge cd-badge-plus">€3.99/month</span>
          <h3 class="cd-name">Plus</h3>
          <p class="cd-desc">A sleek metal Mastercard with higher limits and purchase protection. For the smart spender who wants more.</p>
          <ul class="cd-features">
            <li>✓ Premium metal Mastercard</li>
            <li>✓ Purchase protection up to €1,000</li>
            <li>✓ Double daily limits €2,000</li>
            <li>✓ Priority 24/7 support</li>
            <li>✓ Dynamic CVV for extra protection</li>
            <li>✓ Fee-free international transfers (up to €1,000/month)</li>
          </ul>
        </div>
        <div class="cd-tier-img"><div class="cd-placeholder cd-placeholder-plus">💳</div></div>
      </div>

      <div class="cd-tier">
        <div class="cd-tier-img"><div class="cd-placeholder cd-placeholder-prem">💳</div></div>
        <div class="cd-tier-info">
          <span class="cd-badge cd-badge-prem">€7.99/month</span>
          <h3 class="cd-name">Premium</h3>
          <p class="cd-desc">For travel and international shopping lovers. Unlimited FX, comprehensive travel insurance, and airport lounges worldwide.</p>
          <ul class="cd-features">
            <li>✓ Unlimited currency exchange at market rate</li>
            <li>✓ Comprehensive travel insurance (medical + cancellation + delay)</li>
            <li>✓ 3 monthly airport lounge visits</li>
            <li>✓ International eSIM data (3GB/month)</li>
            <li>✓ Purchase protection up to €5,000</li>
            <li>✓ Daily withdrawal limit €5,000</li>
          </ul>
        </div>
      </div>

      <div class="cd-tier cd-tier-rev">
        <div class="cd-tier-info">
          <span class="cd-badge cd-badge-elite">€14.99/month</span>
          <h3 class="cd-name">Elite</h3>
          <p class="cd-desc">The pinnacle of digital banking. Unlimited VIP lounges, a personal account manager, and cashback on every transaction.</p>
          <ul class="cd-features">
            <li>✓ Unlimited VIP airport lounges</li>
            <li>✓ Dedicated personal account manager</li>
            <li>✓ 1% cashback on every transaction</li>
            <li>✓ Comprehensive insurance (travel + health + vehicle)</li>
            <li>✓ International eSIM data (10GB/month)</li>
            <li>✓ Daily withdrawal limit €10,000</li>
            <li>✓ Partner subscriptions worth €2,100/year</li>
          </ul>
        </div>
        <div class="cd-tier-img"><div class="cd-placeholder cd-placeholder-elite">💳</div></div>
      </div>
    </div>
  </section>

  <section class="pg-sec pg-sec-light">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">Card Comparison</h2>
      <div class="cd-table-wrap">
        <table class="cd-table">
          <thead>
            <tr><th>Feature</th><th>Standard</th><th>Plus</th><th>Premium</th><th>Elite</th></tr>
          </thead>
          <tbody>
            <tr><td>Monthly price</td><td>Free</td><td>€3.99</td><td>€7.99</td><td>€14.99</td></tr>
            <tr><td>Virtual card</td><td>✓</td><td>✓</td><td>✓</td><td>✓</td></tr>
            <tr><td>Metal card</td><td>—</td><td>✓</td><td>✓</td><td>✓</td></tr>
            <tr><td>Apple Pay & Google Pay</td><td>✓</td><td>✓</td><td>✓</td><td>✓</td></tr>
            <tr><td>Daily withdrawal limit</td><td>€500</td><td>€2,000</td><td>€5,000</td><td>€10,000</td></tr>
            <tr><td>Free FX exchange</td><td>€200/mo</td><td>€1,000/mo</td><td>Unlimited</td><td>Unlimited</td></tr>
            <tr><td>Purchase protection</td><td>—</td><td>€1,000</td><td>€5,000</td><td>€10,000</td></tr>
            <tr><td>Travel insurance</td><td>—</td><td>—</td><td>✓</td><td>✓ Full</td></tr>
            <tr><td>Airport lounges</td><td>—</td><td>—</td><td>3/month</td><td>Unlimited</td></tr>
            <tr><td>Dynamic CVV</td><td>—</td><td>✓</td><td>✓</td><td>✓</td></tr>
            <tr><td>Cashback</td><td>—</td><td>—</td><td>0.5%</td><td>1%</td></tr>
            <tr><td>Personal account manager</td><td>—</td><td>—</td><td>—</td><td>✓</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>

  <section class="pg-sec">
    <div class="pg-wrap">
      <h2 class="pg-h2 text-center">All Card Features</h2>
      <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6 mt-10">
        <div v-for="f in [
          {icon:'📱',t:'Apple Pay & Google Pay',d:'Add your card to your digital wallet and pay with your phone or smartwatch at any store.'},
          {icon:'❄️',t:'Instant Freeze',d:'Freeze your card instantly from the app if you lose it or suspect unusual activity. Unfreeze just as easily.'},
          {icon:'🔄',t:'Dynamic CVV',d:'A security code that changes automatically every hour for extra protection in online purchases.'},
          {icon:'🔔',t:'Instant Notifications',d:'Every payment or withdrawal triggers an instant notification with full details to your phone.'},
          {icon:'🌍',t:'Pay Anywhere',d:'Mastercard accepted at over 80 million stores worldwide and online.'},
          {icon:'💱',t:'Auto Conversion',d:'Pay in any currency and conversion happens automatically at the real exchange rate with no hidden fees.'},
          {icon:'🛡️',t:'3D Secure',d:'Extra security layer that verifies your identity during online payments to prevent fraud.'},
          {icon:'📊',t:'Spending Analytics',d:'Track where your money goes with automatic categorisation and detailed monthly reports.'},
          {icon:'🔐',t:'Multi-Layer Security',d:'256-bit encryption, two-factor authentication, and Face ID or fingerprint for every transaction.'}
        ]" :key="f.t" class="cd-feat">
          <div class="cd-feat-icon">{{ f.icon }}</div>
          <h4 class="cd-feat-title">{{ f.t }}</h4>
          <p class="cd-feat-desc">{{ f.d }}</p>
        </div>
      </div>
    </div>
  </section>

  <section class="pg-sec pg-sec-dark">
    <div class="pg-wrap text-center">
      <h2 class="pg-h2 text-white max-w-2xl mx-auto">Get your Mastercard today</h2>
      <p class="pg-sub text-white/35 max-w-xl mx-auto">Sign up in minutes and get a virtual card instantly. No hidden fees.</p>
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
.pg-hero{padding:140px 24px 60px;text-align:center}
.pg-hero-dark{background:linear-gradient(135deg,#0B1F3A 0%,#162d4d 50%,#0B1F3A 100%)}
.pg-hero-h{font-size:clamp(2rem,5vw,3.5rem);font-weight:900;color:#fff;margin-bottom:16px}
.pg-hero-p{font-size:18px;color:rgba(255,255,255,0.5);max-width:600px;margin:0 auto}
.pg-sec{padding:80px 0}.pg-sec-light{background:#F0F0F0}.pg-sec-dark{background:#0B1F3A}
.pg-h2{font-size:clamp(1.6rem,3vw,2.4rem);font-weight:900;margin-bottom:12px}
.pg-sub{font-size:16px;color:rgba(11,31,58,0.45);margin-bottom:32px}
.cd-tier{display:grid;grid-template-columns:1fr 1fr;gap:48px;align-items:center;padding:60px 0;border-bottom:1px solid rgba(11,31,58,0.06)}
.cd-tier-rev{direction:ltr}
.cd-tier:last-of-type{border-bottom:none}
.cd-placeholder{width:100%;max-width:380px;height:240px;border-radius:20px;display:flex;align-items:center;justify-content:center;font-size:80px;background:linear-gradient(135deg,#2563EB,#3B82F6);box-shadow:0 20px 50px rgba(37,99,235,0.3)}
.cd-placeholder-plus{background:linear-gradient(135deg,#7C3AED,#A855F7)}
.cd-placeholder-prem{background:linear-gradient(135deg,#DB2777,#EC4899)}
.cd-placeholder-elite{background:linear-gradient(135deg,#B45309,#D97706)}
.cd-badge{display:inline-flex;padding:6px 18px;border-radius:100px;font-size:13px;font-weight:700;background:rgba(37,99,235,0.08);color:#2563EB;margin-bottom:12px}
.cd-badge-plus{background:rgba(168,85,247,0.08);color:#A855F7}
.cd-badge-prem{background:rgba(236,72,153,0.08);color:#EC4899}
.cd-badge-elite{background:rgba(245,158,11,0.08);color:#D97706}
.cd-name{font-size:2rem;font-weight:900;margin-bottom:12px}
.cd-desc{font-size:15px;color:rgba(11,31,58,0.5);line-height:1.7;margin-bottom:20px}
.cd-features{list-style:none;padding:0}.cd-features li{padding:6px 0;font-size:14px;color:rgba(11,31,58,0.6);border-bottom:1px solid rgba(11,31,58,0.04)}
.cd-table-wrap{overflow-x:auto;margin-top:32px}
.cd-table{width:100%;border-collapse:collapse;font-size:14px}
.cd-table th{padding:14px 16px;text-align:center;font-weight:800;background:#0B1F3A;color:#fff;font-size:13px}.cd-table th:first-child{text-align:left;border-radius:12px 0 0 0}.cd-table th:last-child{border-radius:0 12px 0 0}
.cd-table td{padding:12px 16px;text-align:center;border-bottom:1px solid rgba(11,31,58,0.06);font-size:13px;color:rgba(11,31,58,0.6)}.cd-table td:first-child{text-align:left;font-weight:600;color:#0B1F3A}
.cd-table tbody tr:hover{background:rgba(37,99,235,0.02)}
.cd-table tbody tr:last-child td{border-bottom:none}
.cd-feat{padding:28px;background:#FAFBFC;border:1px solid rgba(11,31,58,0.05);border-radius:18px;transition:all .3s}.cd-feat:hover{transform:translateY(-3px);box-shadow:0 10px 30px rgba(0,0,0,0.05)}
.cd-feat-icon{font-size:28px;margin-bottom:12px}
.cd-feat-title{font-weight:800;font-size:15px;margin-bottom:8px}
.cd-feat-desc{font-size:13px;color:rgba(11,31,58,0.45);line-height:1.7}
.pg-ft{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
@media(max-width:768px){.cd-tier{grid-template-columns:1fr;gap:24px}.pg-hero-h{font-size:2rem}}
</style>
