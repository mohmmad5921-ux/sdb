<script setup>
import SiteLayout from '@/Layouts/SiteLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: SiteLayout });
</script>

<template>
<Head title="Terms & Conditions — SDB Bank" />
<div class="lp">
  <!-- Hero -->
  <div class="lp-hero">
    <div class="lp-hero-glow"></div>
    <div class="lp-hero-inner">
      <div class="lp-badge">⚖️ Legal Agreement</div>
      <h1 class="lp-h1">Terms & Conditions</h1>
      <p class="lp-sub">The agreement governing your use of SDB Bank services</p>
      <p class="lp-date">Last updated: February 2026</p>
    </div>
  </div>

  <!-- Content -->
  <div class="lp-body">
    <div class="lp-content">

      <section class="lp-s">
        <div class="lp-s-num">01</div>
        <h2>Introduction</h2>
        <p>Welcome to SDB Bank ApS. By using our digital banking services, you agree to comply with these Terms and Conditions. Please read them carefully before opening an account or using any of our services.</p>
        <p>SDB Bank is a digital financial institution registered in Denmark, operating in accordance with applicable European banking laws and regulations. We are subject to oversight by the relevant regulatory authorities and maintain the highest standards of financial compliance.</p>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">02</div>
        <h2>Account Opening & Registration</h2>
        <p>To open an account with SDB, you must:</p>
        <div class="lp-reqs">
          <div class="lp-req"><span class="lp-req-ic">✅</span> Be at least 18 years of age</div>
          <div class="lp-req"><span class="lp-req-ic">✅</span> Provide accurate and truthful personal information</div>
          <div class="lp-req"><span class="lp-req-ic">✅</span> Successfully complete identity verification (KYC)</div>
          <div class="lp-req"><span class="lp-req-ic">✅</span> Submit valid identity documents (passport, national ID)</div>
          <div class="lp-req"><span class="lp-req-ic">✅</span> Agree to these Terms and our Privacy Policy</div>
        </div>
        <div class="lp-note">The bank reserves the right to decline any account opening request without stating reasons, in accordance with internal compliance policies and anti-money laundering requirements.</div>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">03</div>
        <h2>Banking Accounts</h2>
        <p>SDB offers several types of banking accounts:</p>
        <div class="lp-cards">
          <div class="lp-card"><div class="lp-card-ic">🏦</div><div class="lp-card-h">Current Account</div><p>For day-to-day money management and transactions</p></div>
          <div class="lp-card"><div class="lp-card-ic">🌍</div><div class="lp-card-h">Multi-Currency Account</div><p>Supports multiple currencies with competitive exchange rates</p></div>
          <div class="lp-card"><div class="lp-card-ic">💰</div><div class="lp-card-h">Savings Account</div><p>With competitive interest rates</p></div>
        </div>
        <p style="margin-top:14px">Each account receives a unique IBAN and an internal 10-digit account number.</p>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">04</div>
        <h2>Cards</h2>
        <p>SDB offers Mastercard cards in two types:</p>
        <div class="lp-cards lp-cards-2">
          <div class="lp-card"><div class="lp-card-ic">💳</div><div class="lp-card-h">Virtual Card</div><p>Issued instantly for online use</p></div>
          <div class="lp-card"><div class="lp-card-ic">💳</div><div class="lp-card-h">Physical Card</div><p>Shipped to your registered address</p></div>
        </div>
        <p style="margin-top:14px">Cards are subject to daily and monthly spending limits which can be adjusted through the app. You can temporarily freeze your card at any time for security reasons.</p>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">05</div>
        <h2>Transfers & Transactions</h2>
        <div class="lp-list">
          <div class="lp-item"><span class="lp-item-ic">⚡</span><div>Internal transfers between SDB accounts are <strong>instant and free</strong></div></div>
          <div class="lp-item"><span class="lp-item-ic">🌐</span><div>External transfers are subject to fees and processing timelines</div></div>
          <div class="lp-item"><span class="lp-item-ic">💱</span><div>Currency exchange is executed at live market rates with a competitive margin</div></div>
          <div class="lp-item"><span class="lp-item-ic">🔒</span><div>All transactions are final once confirmed and cannot be reversed</div></div>
        </div>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">06</div>
        <h2>Fees & Charges</h2>
        <table class="lp-tbl">
          <thead><tr><th>Service</th><th>Fee</th></tr></thead>
          <tbody>
            <tr><td>Card deposit</td><td>1.5% + €0.50</td></tr>
            <tr><td>Internal transfers</td><td class="lp-free">Free</td></tr>
            <tr><td>Virtual card issuance</td><td class="lp-free">Free</td></tr>
            <tr><td>Physical card issuance</td><td>Depends on plan</td></tr>
            <tr><td>Currency exchange</td><td>0.5% – 2% margin</td></tr>
          </tbody>
        </table>
        <div class="lp-note" style="margin-top:14px">The bank reserves the right to modify fees with at least 30 days' prior notice to customers.</div>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">07</div>
        <h2>Security & Responsibilities</h2>
        <div class="lp-shields">
          <div class="lp-shield"><span>🔑</span> Maintain confidentiality of login credentials</div>
          <div class="lp-shield"><span>🚨</span> Notify us immediately of suspicious activity</div>
          <div class="lp-shield"><span>🔒</span> TLS 256-bit encryption protects all data</div>
          <div class="lp-shield"><span>📱</span> Two-factor authentication (2FA) recommended</div>
          <div class="lp-shield"><span>🧊</span> Accounts may be frozen on suspicion of illicit activity</div>
        </div>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">08</div>
        <h2>Anti-Money Laundering (AML)</h2>
        <p>SDB complies with anti-money laundering and counter-terrorism financing laws. We may require:</p>
        <ul>
          <li>Enhanced identity verification for large transactions</li>
          <li>Additional information on the source of funds</li>
          <li>Reporting of suspicious transactions to relevant authorities</li>
        </ul>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">09</div>
        <h2>Termination</h2>
        <p>You may close your account at any time, provided all obligations are settled. The bank reserves the right to close any account that violates these Terms or is used for unlawful purposes.</p>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">10</div>
        <h2>Governing Law</h2>
        <div class="lp-law">
          <span class="lp-law-flag">🇩🇰 🇪🇺</span>
          <p>These Terms are governed by the laws of the <strong>Kingdom of Denmark</strong> and the <strong>European Union</strong>. In case of any dispute, resolution will first be attempted through mediation, then arbitration before the competent Danish courts if necessary.</p>
        </div>
      </section>

      <section class="lp-s lp-s-last">
        <div class="lp-s-num">11</div>
        <h2>Contact Us</h2>
        <div class="lp-contact">
          <div class="lp-contact-item">📧 legal@sdb-bank.com</div>
          <div class="lp-contact-item">📞 +45 42 80 55 94</div>
          <div class="lp-contact-item">💬 In-app support: Available 24/7</div>
          <div class="lp-contact-item">📍 Denmark 🇩🇰</div>
        </div>
      </section>

    </div>
  </div>
</div>
</template>

<style scoped>
.lp{direction:ltr}
.lp-hero{background:linear-gradient(135deg,#0a1628 0%,#132743 50%,#0d2137 100%);padding:80px 20px 60px;text-align:center;position:relative;overflow:hidden}
.lp-hero-glow{position:absolute;width:400px;height:400px;background:radial-gradient(circle,rgba(16,185,129,.15),transparent 70%);top:-100px;left:20%;pointer-events:none}
.lp-hero-inner{position:relative;z-index:1;max-width:700px;margin:0 auto}
.lp-badge{display:inline-block;background:rgba(16,185,129,.12);border:1px solid rgba(16,185,129,.25);color:#10b981;font-size:12px;font-weight:700;padding:6px 16px;border-radius:20px;margin-bottom:20px;letter-spacing:1px}
.lp-h1{font-size:42px;font-weight:900;color:#fff;margin-bottom:12px}
.lp-sub{font-size:16px;color:rgba(255,255,255,.55);margin-bottom:8px}
.lp-date{font-size:13px;color:rgba(255,255,255,.3)}
.lp-body{max-width:800px;margin:0 auto;padding:40px 20px 60px}
.lp-content{display:flex;flex-direction:column;gap:0}
.lp-s{padding:32px 0;border-bottom:1px solid rgba(0,0,0,.06)}
.lp-s-last{border-bottom:none}
.lp-s-num{font-size:12px;font-weight:900;color:#10b981;letter-spacing:2px;margin-bottom:8px}
.lp-s h2{font-size:22px;font-weight:800;color:#0f172a;margin-bottom:14px}
.lp-s p{font-size:15px;line-height:1.8;color:#475569;margin-bottom:10px}
.lp-s p strong{color:#0f172a}
.lp-s ul{padding-left:20px;margin:10px 0}
.lp-s li{font-size:14px;line-height:2;color:#475569;list-style:disc}
.lp-s li strong{color:#0f172a}
.lp-cards{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
.lp-cards-2{grid-template-columns:repeat(2,1fr)}
.lp-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:14px;padding:20px}
.lp-card-ic{font-size:24px;margin-bottom:8px}
.lp-card-h{font-size:14px;font-weight:800;color:#0f172a;margin-bottom:6px}
.lp-card p{font-size:13px;color:#64748b;margin:0}
.lp-reqs{display:flex;flex-direction:column;gap:6px;margin:10px 0}
.lp-req{display:flex;align-items:center;gap:10px;font-size:14px;color:#334155;padding:8px 0}
.lp-req-ic{font-size:16px}
.lp-note{background:#fffbeb;border:1px solid #fde68a;border-radius:10px;padding:12px 18px;font-size:13px;color:#92400e;line-height:1.7}
.lp-list{display:flex;flex-direction:column;gap:10px}
.lp-item{display:flex;gap:14px;padding:14px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px}
.lp-item-ic{font-size:20px;flex-shrink:0}
.lp-item strong{color:#0f172a;font-size:14px}
.lp-item div{font-size:13px;color:#64748b;line-height:1.6}
.lp-tbl{width:100%;border-collapse:collapse;background:#f8fafc;border-radius:12px;overflow:hidden;border:1px solid #e2e8f0}
.lp-tbl th{text-align:left;font-size:12px;font-weight:700;color:#64748b;padding:12px 16px;background:#f1f5f9;border-bottom:2px solid #e2e8f0}
.lp-tbl td{font-size:14px;color:#334155;padding:12px 16px;border-bottom:1px solid #e2e8f0}
.lp-tbl tr:last-child td{border-bottom:none}
.lp-free{color:#10b981;font-weight:700}
.lp-shields{display:flex;flex-wrap:wrap;gap:10px}
.lp-shield{background:linear-gradient(135deg,#0f172a,#1e293b);color:#fff;padding:10px 18px;border-radius:10px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:8px}
.lp-law{background:linear-gradient(135deg,#eff6ff,#dbeafe);border:1px solid #93c5fd;border-radius:14px;padding:20px;display:flex;gap:16px;align-items:flex-start}
.lp-law-flag{font-size:28px;flex-shrink:0}
.lp-law p{margin:0}
.lp-contact{display:flex;flex-direction:column;gap:8px}
.lp-contact-item{font-size:15px;color:#334155;font-weight:600;padding:10px 0;border-bottom:1px solid #f1f5f9}
.lp-contact-item:last-child{border:none}
@media(max-width:768px){.lp-h1{font-size:28px}.lp-cards,.lp-cards-2{grid-template-columns:1fr}.lp-shields{flex-direction:column}}
</style>
