<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Terms & Conditions — SDB Bank" />
    <div class="lg-root">
        <header class="lg-header">
            <div class="max-w-5xl mx-auto px-6 flex justify-between items-center">
                <Link href="/" class="lg-mark">SDB<span class="sdb-flag"></span></Link>
                <div class="flex gap-3">
                    <Link href="/privacy" class="lg-link">Privacy</Link>
                    <Link href="/about" class="lg-link">About</Link>
                    <Link href="/faq" class="lg-link">FAQ</Link>
                    <Link href="/support" class="lg-link">Support</Link>
                </div>
            </div>
        </header>

        <main class="max-w-4xl mx-auto px-6 py-12">
            <h1 class="text-3xl font-black text-[#0B1F3A] mb-2">Terms & Conditions</h1>
            <p class="text-sm text-gray-400 mb-10">Last updated: February 2026</p>

            <div class="lg-content">
                <section class="lg-section">
                    <h2>1. Introduction</h2>
                    <p>Welcome to SDB Bank ApS. By using our digital banking services, you agree to comply with these Terms and Conditions. Please read them carefully before opening an account or using any of our services.</p>
                    <p>SDB Bank is a digital financial institution registered in Denmark, operating in accordance with applicable European banking laws and regulations. We are subject to oversight by the relevant regulatory authorities and maintain the highest standards of financial compliance.</p>
                </section>

                <section class="lg-section">
                    <h2>2. Account Opening & Registration</h2>
                    <p>To open an account with SDB, you must:</p>
                    <ul>
                        <li>Be at least 18 years of age</li>
                        <li>Provide accurate and truthful personal information</li>
                        <li>Successfully complete identity verification (KYC)</li>
                        <li>Submit valid identity documents (passport, national ID)</li>
                        <li>Agree to these Terms and our Privacy Policy</li>
                    </ul>
                    <p>The bank reserves the right to decline any account opening request without stating reasons, in accordance with internal compliance policies and anti-money laundering requirements.</p>
                </section>

                <section class="lg-section">
                    <h2>3. Banking Accounts</h2>
                    <p>SDB offers several types of banking accounts:</p>
                    <ul>
                        <li><strong>Current Account:</strong> For day-to-day money management and transactions</li>
                        <li><strong>Multi-Currency Account:</strong> Supports multiple currencies with competitive exchange rates</li>
                        <li><strong>Savings Account:</strong> With competitive interest rates</li>
                    </ul>
                    <p>Each account receives a unique IBAN and an internal 10-digit account number.</p>
                </section>

                <section class="lg-section">
                    <h2>4. Cards</h2>
                    <p>SDB offers Mastercard cards in two types:</p>
                    <ul>
                        <li><strong>Virtual Card:</strong> Issued instantly for online use</li>
                        <li><strong>Physical Card:</strong> Shipped to your registered address</li>
                    </ul>
                    <p>Cards are subject to daily and monthly spending limits which can be adjusted through the app. You can temporarily freeze your card at any time for security reasons.</p>
                </section>

                <section class="lg-section">
                    <h2>5. Transfers & Transactions</h2>
                    <ul>
                        <li>Internal transfers between SDB accounts are instant and free</li>
                        <li>External transfers are subject to fees and processing timelines</li>
                        <li>Currency exchange is executed at live market rates with a competitive margin</li>
                        <li>All transactions are final once confirmed and cannot be reversed</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>6. Fees & Charges</h2>
                    <p>Banking service fees:</p>
                    <ul>
                        <li>Card deposit fee: 1.5% + €0.50</li>
                        <li>Internal transfers: Free</li>
                        <li>Virtual card issuance: Free</li>
                        <li>Physical card issuance: Depends on selected plan</li>
                        <li>Currency exchange: 0.5% – 2% margin</li>
                    </ul>
                    <p>The bank reserves the right to modify fees with at least 30 days' prior notice to customers.</p>
                </section>

                <section class="lg-section">
                    <h2>7. Security & Responsibilities</h2>
                    <ul>
                        <li>You are responsible for maintaining the confidentiality of your login credentials</li>
                        <li>You must notify us immediately of any suspicious activity on your account</li>
                        <li>We use TLS 256-bit encryption to protect all data</li>
                        <li>Two-factor authentication (2FA) is available and recommended</li>
                        <li>The bank reserves the right to temporarily freeze accounts upon suspicion of illicit activity</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>8. Anti-Money Laundering (AML)</h2>
                    <p>SDB complies with anti-money laundering and counter-terrorism financing laws. We may require:</p>
                    <ul>
                        <li>Enhanced identity verification for large transactions</li>
                        <li>Additional information on the source of funds</li>
                        <li>Reporting of suspicious transactions to relevant authorities</li>
                    </ul>
                </section>

                <section class="lg-section">
                    <h2>9. Termination</h2>
                    <p>You may close your account at any time, provided all obligations are settled. The bank reserves the right to close any account that violates these Terms or is used for unlawful purposes.</p>
                </section>

                <section class="lg-section">
                    <h2>10. Governing Law</h2>
                    <p>These Terms are governed by the laws of the Kingdom of Denmark and the European Union. In case of any dispute, resolution will first be attempted through mediation, then arbitration before the competent Danish courts if necessary.</p>
                </section>

                <section class="lg-section">
                    <h2>11. Contact Us</h2>
                    <p>For any enquiries regarding these Terms:</p>
                    <ul>
                        <li>Email: legal@sdb-bank.com</li>
                        <li>Phone: +45 42 80 55 94</li>
                        <li>In-app support: Available 24/7</li>
                        <li>Address: Denmark 🇩🇰</li>
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
.lg-section p{font-size:14px;line-height:1.8;color:rgba(11,31,58,0.6);margin-bottom:10px}
.lg-section ul{padding-left:20px;margin:10px 0}
.lg-section li{font-size:14px;line-height:2;color:rgba(11,31,58,0.6);list-style:disc}
.lg-section li strong{color:#0B1F3A}
.lg-footer{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
.lg-flink{font-size:12px;color:rgba(11,31,58,0.4);text-decoration:none}.lg-flink:hover{color:#2563EB}
</style>
