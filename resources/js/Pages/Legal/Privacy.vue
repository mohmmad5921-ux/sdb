<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Privacy Policy — SDB Bank" />
    <div class="lg-root">
        <header class="lg-header">
            <div class="max-w-5xl mx-auto px-6 flex justify-between items-center">
                <Link href="/" class="lg-mark">SDB<span class="sdb-flag"></span></Link>
                <div class="flex gap-3">
                    <Link href="/terms" class="lg-link">Terms</Link>
                    <Link href="/about" class="lg-link">About</Link>
                    <Link href="/faq" class="lg-link">FAQ</Link>
                    <Link href="/support" class="lg-link">Support</Link>
                </div>
            </div>
        </header>

        <main class="max-w-4xl mx-auto px-6 py-12">
            <h1 class="text-3xl font-black text-[#0B1F3A] mb-2">Privacy Policy</h1>
            <p class="text-sm text-gray-400 mb-10">Last updated: February 2026</p>

            <div class="lg-content">
                <section class="lg-section">
                    <h2>1. Our Commitment to Privacy</h2>
                    <p>At SDB Bank ApS, we take our customers' privacy seriously. This policy explains how we collect, use, protect and share your personal information when using our banking services.</p>
                    <p>We maintain the highest data protection standards and comply with the General Data Protection Regulation (GDPR) and applicable local laws.</p>
                </section>

                <section class="lg-section">
                    <h2>2. Data We Collect</h2>
                    <h3>Personal Data</h3>
                    <ul>
                        <li>Full name, date of birth, nationality</li>
                        <li>Email address and phone number</li>
                        <li>Residential address and residency information</li>
                        <li>Identity documents (passport, national ID)</li>
                    </ul>
                    <h3>Financial Data</h3>
                    <ul>
                        <li>Bank account information and balances</li>
                        <li>Transaction and transfer history</li>
                        <li>Card information</li>
                        <li>Income sources and employment</li>
                    </ul>
                    <h3>Technical Data</h3>
                    <ul>
                        <li>IP address, browser type and device</li>
                        <li>Login and activity logs</li>
                        <li>Geolocation data (with your consent)</li>
                        <li>Cookies</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>3. How We Use Your Data</h2>
                    <ul>
                        <li><strong>Service Delivery:</strong> Managing your account and processing transactions</li>
                        <li><strong>Identity Verification:</strong> Compliance with KYC and AML requirements</li>
                        <li><strong>Security:</strong> Fraud detection and prevention of suspicious activities</li>
                        <li><strong>Improvement:</strong> Developing and enhancing our services and user experience</li>
                        <li><strong>Communication:</strong> Sending important notifications about your account</li>
                        <li><strong>Legal Compliance:</strong> Responding to regulatory and legal requests</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>4. Data Sharing</h2>
                    <p>We never sell your personal data. We may share your data only in the following cases:</p>
                    <ul>
                        <li><strong>Service Providers:</strong> Payment processors and trusted technology partners</li>
                        <li><strong>Regulators:</strong> Central bank and relevant supervisory authorities</li>
                        <li><strong>Legal Requirements:</strong> Court orders and binding legal requests</li>
                        <li><strong>Fraud Prevention:</strong> With financial crime prevention institutions</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>5. Data Protection</h2>
                    <p>We implement comprehensive security measures to protect your data:</p>
                    <ul>
                        <li>TLS 256-bit encryption for all data in transit and at rest</li>
                        <li>Secure, ISO 27001 certified data centres</li>
                        <li>24/7 security monitoring</li>
                        <li>Regular penetration testing and independent security audits</li>
                        <li>Need-based access permissions</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>6. Your Rights</h2>
                    <p>You have the following rights regarding your personal data:</p>
                    <ul>
                        <li><strong>Right of Access:</strong> Request a copy of your stored data</li>
                        <li><strong>Right to Rectification:</strong> Update or correct inaccurate data</li>
                        <li><strong>Right to Erasure:</strong> Request deletion of your data (subject to legal requirements)</li>
                        <li><strong>Right to Portability:</strong> Receive your data in a machine-readable format</li>
                        <li><strong>Right to Object:</strong> Refuse use of your data for marketing purposes</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>7. Cookies</h2>
                    <p>We use cookies to improve your experience:</p>
                    <ul>
                        <li><strong>Essential:</strong> Necessary for site operation (login, security)</li>
                        <li><strong>Functional:</strong> Remember your preferences (language, timezone)</li>
                        <li><strong>Analytical:</strong> Understand usage to improve the service</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>8. Data Retention</h2>
                    <p>We retain your data as long as your account is active, and for a minimum of 5 years after account closure in accordance with anti-money laundering regulatory requirements.</p>
                </section>

                <section class="lg-section">
                    <h2>9. Changes</h2>
                    <p>We reserve the right to amend this policy. You will be notified of any material changes via email or in-app notification at least 30 days before they take effect.</p>
                </section>

                <section class="lg-section">
                    <h2>10. Contact the Data Protection Officer</h2>
                    <ul>
                        <li>Email: dpo@sdb-bank.com</li>
                        <li>Address: Data Protection Department — SDB Bank ApS, Denmark</li>
                        <li>In-app support: Available 24/7</li>
                    </ul>
                </section>
            </div>
        </main>

        <footer class="lg-footer">
            <div class="max-w-4xl mx-auto px-6 flex justify-between items-center">
                <span class="text-sm text-[#0B1F3A]/40">© 2026 SDB Bank ApS. All rights reserved.</span>
                <div class="flex gap-4"><Link href="/terms" class="lg-flink">Terms</Link><Link href="/privacy" class="lg-flink">Privacy</Link><Link href="/support" class="lg-flink">Support</Link><Link href="/" class="lg-flink">Home</Link></div>
            </div>
        </footer>
    </div>
</template>

<style scoped>
.lg-root{min-height:100vh;background:#fff;font-family:'Inter',system-ui,sans-serif}
.lg-header{padding:16px 0;border-bottom:1px solid rgba(11,31,58,0.06);position:sticky;top:0;background:rgba(255,255,255,0.95);backdrop-filter:blur(10px);z-index:10}
.lg-mark{font-size:24px;font-weight:900;color:#0a0a0a;text-decoration:none;letter-spacing:-1.5px}
.lg-dot{color:#2563EB;font-size:28px;line-height:0}
.lg-link{font-size:13px;color:rgba(11,31,58,0.5);text-decoration:none;font-weight:500}.lg-link:hover{color:#2563EB}
.lg-section{margin-bottom:32px;padding-bottom:24px;border-bottom:1px solid rgba(11,31,58,0.05)}
.lg-section:last-child{border:none}
.lg-section h2{font-size:18px;font-weight:800;color:#0B1F3A;margin-bottom:12px}
.lg-section h3{font-size:15px;font-weight:700;color:#2563EB;margin:12px 0 6px}
.lg-section p{font-size:14px;line-height:1.8;color:rgba(11,31,58,0.6);margin-bottom:10px}
.lg-section ul{padding-left:20px;margin:10px 0}
.lg-section li{font-size:14px;line-height:2;color:rgba(11,31,58,0.6);list-style:disc}
.lg-section li strong{color:#0B1F3A}
.lg-footer{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
.lg-flink{font-size:12px;color:rgba(11,31,58,0.4);text-decoration:none}.lg-flink:hover{color:#2563EB}
</style>
