<script setup>
import SiteLayout from '@/Layouts/SiteLayout.vue';
import { Head } from '@inertiajs/vue3';
defineOptions({ layout: SiteLayout });
</script>

<template>
<Head title="Privacy Policy — SDB Bank" />
<div class="lp">
  <!-- Hero -->
  <div class="lp-hero">
    <div class="lp-hero-glow"></div>
    <div class="lp-hero-inner">
      <div class="lp-badge">🔒 GDPR Compliant</div>
      <h1 class="lp-h1">Privacy Policy</h1>
      <p class="lp-sub">How we collect, protect and use your personal data</p>
      <p class="lp-date">Last updated: February 2026</p>
    </div>
  </div>

  <!-- Content -->
  <div class="lp-body">
    <div class="lp-content">

      <section class="lp-s">
        <div class="lp-s-num">01</div>
        <h2>Our Commitment to Privacy</h2>
        <p>At SDB Bank ApS, we take our customers' privacy seriously. This policy explains how we collect, use, protect and share your personal information when using our banking services.</p>
        <p>We maintain the highest data protection standards and comply with the General Data Protection Regulation (GDPR) and applicable local laws.</p>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">02</div>
        <h2>Data We Collect</h2>
        <div class="lp-cards">
          <div class="lp-card">
            <div class="lp-card-ic">👤</div>
            <div class="lp-card-h">Personal Data</div>
            <ul><li>Full name, date of birth, nationality</li><li>Email address and phone number</li><li>Residential address and residency information</li><li>Identity documents (passport, national ID)</li></ul>
          </div>
          <div class="lp-card">
            <div class="lp-card-ic">💰</div>
            <div class="lp-card-h">Financial Data</div>
            <ul><li>Bank account information and balances</li><li>Transaction and transfer history</li><li>Card information</li><li>Income sources and employment</li></ul>
          </div>
          <div class="lp-card">
            <div class="lp-card-ic">🖥️</div>
            <div class="lp-card-h">Technical Data</div>
            <ul><li>IP address, browser type and device</li><li>Login and activity logs</li><li>Geolocation data (with your consent)</li><li>Cookies</li></ul>
          </div>
        </div>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">03</div>
        <h2>How We Use Your Data</h2>
        <div class="lp-list">
          <div class="lp-item"><span class="lp-item-ic">🛡️</span><div><strong>Service Delivery</strong><br>Managing your account and processing transactions</div></div>
          <div class="lp-item"><span class="lp-item-ic">🪪</span><div><strong>Identity Verification</strong><br>Compliance with KYC and AML requirements</div></div>
          <div class="lp-item"><span class="lp-item-ic">🔐</span><div><strong>Security</strong><br>Fraud detection and prevention of suspicious activities</div></div>
          <div class="lp-item"><span class="lp-item-ic">📈</span><div><strong>Improvement</strong><br>Developing and enhancing our services and user experience</div></div>
          <div class="lp-item"><span class="lp-item-ic">📧</span><div><strong>Communication</strong><br>Sending important notifications about your account</div></div>
          <div class="lp-item"><span class="lp-item-ic">⚖️</span><div><strong>Legal Compliance</strong><br>Responding to regulatory and legal requests</div></div>
        </div>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">04</div>
        <h2>Data Sharing</h2>
        <div class="lp-alert">⚠️ We never sell your personal data.</div>
        <p>We may share your data only in the following cases:</p>
        <ul><li><strong>Service Providers:</strong> Payment processors and trusted technology partners</li><li><strong>Regulators:</strong> Central bank and relevant supervisory authorities</li><li><strong>Legal Requirements:</strong> Court orders and binding legal requests</li><li><strong>Fraud Prevention:</strong> With financial crime prevention institutions</li></ul>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">05</div>
        <h2>Data Protection</h2>
        <div class="lp-shields">
          <div class="lp-shield"><span>🔒</span> TLS 256-bit encryption</div>
          <div class="lp-shield"><span>🏢</span> ISO 27001 certified data centres</div>
          <div class="lp-shield"><span>👁️</span> 24/7 security monitoring</div>
          <div class="lp-shield"><span>🔍</span> Regular penetration testing</div>
          <div class="lp-shield"><span>🔑</span> Need-based access permissions</div>
        </div>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">06</div>
        <h2>Your Rights</h2>
        <div class="lp-list">
          <div class="lp-item"><span class="lp-item-ic">📋</span><div><strong>Right of Access</strong><br>Request a copy of your stored data</div></div>
          <div class="lp-item"><span class="lp-item-ic">✏️</span><div><strong>Right to Rectification</strong><br>Update or correct inaccurate data</div></div>
          <div class="lp-item"><span class="lp-item-ic">🗑️</span><div><strong>Right to Erasure</strong><br>Request deletion of your data (subject to legal requirements)</div></div>
          <div class="lp-item"><span class="lp-item-ic">📤</span><div><strong>Right to Portability</strong><br>Receive your data in a machine-readable format</div></div>
          <div class="lp-item"><span class="lp-item-ic">🚫</span><div><strong>Right to Object</strong><br>Refuse use of your data for marketing purposes</div></div>
        </div>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">07</div>
        <h2>Cookies</h2>
        <div class="lp-cards lp-cards-3">
          <div class="lp-card"><div class="lp-card-ic">⚙️</div><div class="lp-card-h">Essential</div><p>Necessary for site operation (login, security)</p></div>
          <div class="lp-card"><div class="lp-card-ic">🎛️</div><div class="lp-card-h">Functional</div><p>Remember your preferences (language, timezone)</p></div>
          <div class="lp-card"><div class="lp-card-ic">📊</div><div class="lp-card-h">Analytical</div><p>Understand usage to improve the service</p></div>
        </div>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">08</div>
        <h2>Data Retention</h2>
        <p>We retain your data as long as your account is active, and for a minimum of <strong>5 years</strong> after account closure in accordance with anti-money laundering regulatory requirements.</p>
      </section>

      <section class="lp-s">
        <div class="lp-s-num">09</div>
        <h2>Changes</h2>
        <p>We reserve the right to amend this policy. You will be notified of any material changes via email or in-app notification at least <strong>30 days</strong> before they take effect.</p>
      </section>

      <section class="lp-s lp-s-last">
        <div class="lp-s-num">10</div>
        <h2>Contact the Data Protection Officer</h2>
        <div class="lp-contact">
          <div class="lp-contact-item">📧 dpo@sdb-bank.com</div>
          <div class="lp-contact-item">🏢 Data Protection Dept. — SDB Bank ApS, Denmark</div>
          <div class="lp-contact-item">💬 In-app support: Available 24/7</div>
        </div>
      </section>

    </div>
  </div>
</div>
</template>

<style scoped>
.lp{direction:ltr}
.lp-hero{background:linear-gradient(135deg,#0a1628 0%,#132743 50%,#0d2137 100%);padding:80px 20px 60px;text-align:center;position:relative;overflow:hidden}
.lp-hero-glow{position:absolute;width:400px;height:400px;background:radial-gradient(circle,rgba(16,185,129,.15),transparent 70%);top:-100px;right:20%;pointer-events:none}
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
.lp-cards-3{grid-template-columns:repeat(3,1fr)}
.lp-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:14px;padding:20px}
.lp-card-ic{font-size:24px;margin-bottom:8px}
.lp-card-h{font-size:14px;font-weight:800;color:#0f172a;margin-bottom:6px}
.lp-card ul{padding-left:16px;margin:0}.lp-card li{font-size:13px;line-height:1.8;color:#64748b}
.lp-card p{font-size:13px;color:#64748b;margin:0}
.lp-alert{background:#ecfdf5;border:1px solid #a7f3d0;border-radius:10px;padding:12px 18px;font-size:14px;font-weight:700;color:#059669;margin-bottom:14px}
.lp-list{display:flex;flex-direction:column;gap:10px}
.lp-item{display:flex;gap:14px;padding:14px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px}
.lp-item-ic{font-size:20px;flex-shrink:0}
.lp-item strong{color:#0f172a;font-size:14px}
.lp-item div{font-size:13px;color:#64748b;line-height:1.6}
.lp-shields{display:flex;flex-wrap:wrap;gap:10px}
.lp-shield{background:linear-gradient(135deg,#0f172a,#1e293b);color:#fff;padding:10px 18px;border-radius:10px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:8px}
.lp-contact{display:flex;flex-direction:column;gap:8px}
.lp-contact-item{font-size:15px;color:#334155;font-weight:600;padding:10px 0;border-bottom:1px solid #f1f5f9}
.lp-contact-item:last-child{border:none}
@media(max-width:768px){.lp-h1{font-size:28px}.lp-cards,.lp-cards-3{grid-template-columns:1fr}.lp-shields{flex-direction:column}}
</style>
