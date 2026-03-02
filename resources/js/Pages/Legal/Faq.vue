<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref } from 'vue';

const openFaq = ref(null);
const toggle = (i) => openFaq.value = openFaq.value === i ? null : i;

const faqs = [
  { cat: '🏦 Account', items: [
    { q: 'How do I open an account with SDB?', a: 'You can open an account in minutes by registering on the website or app. You\'ll need to provide your personal details and a valid ID, then complete identity verification (KYC).' },
    { q: 'What documents are required to open an account?', a: 'You need a valid passport or national ID, plus a recent proof of address (bank statement, utility bill, or rental contract issued within the last 3 months).' },
    { q: 'Can I open more than one account?', a: 'Yes! You can open accounts in different currencies. Each account gets a unique IBAN and a 10-digit internal account number.' },
    { q: 'What is the customer number?', a: 'Your customer number is a 10-digit number assigned when you open your account. It\'s your unique identifier in our system and can be used to identify yourself when contacting support.' },
  ]},
  { cat: '💳 Cards', items: [
    { q: 'How do I get an SDB Mastercard?', a: 'You can issue a virtual card instantly from the dashboard. The virtual card works for online purchases and payments via Apple Pay & Google Pay. Physical cards are shipped to your address within 5-7 business days.' },
    { q: 'What is the difference between virtual and physical cards?', a: 'Virtual cards are issued instantly and used for online purchases only. Physical cards arrive at your address and can be used in stores, ATMs, and online.' },
    { q: 'How do I freeze my card?', a: 'You can freeze your card instantly from the app with one tap. Freezing prevents all transactions and you can unfreeze just as easily at any time.' },
    { q: 'What are the card limits?', a: 'Limits vary by plan. The basic daily limit is €5,000 and monthly €25,000. You can adjust limits from the card management page or contact support for higher limits.' },
  ]},
  { cat: '💸 Transfers', items: [
    { q: 'How long do transfers take?', a: 'Internal transfers between SDB accounts are instant and free. External (SWIFT) transfers take 1-3 business days depending on the recipient\'s bank.' },
    { q: 'Are there fees on transfers?', a: 'Internal transfers are completely free. External transfers are subject to fees starting from €2 depending on the destination and currency.' },
    { q: 'How do I exchange currencies?', a: 'From the dashboard, select "Exchange", choose the source and target account (in a different currency), enter the amount and the exchange will be executed at live market rates with a competitive spread.' },
  ]},
  { cat: '💰 Deposits', items: [
    { q: 'How do I deposit money into my account?', a: 'You can deposit via: an external Visa/Mastercard, Apple Pay, or Google Pay. The maximum single deposit is €50,000.' },
    { q: 'What are the deposit fees?', a: 'Deposit fees are 1.5% of the amount + €0.50 fixed fee. For example: depositing €100 = €2 in fees, €98 credited to your account.' },
    { q: 'When does the deposit appear in my account?', a: 'Card and Apple Pay / Google Pay deposits are instant. The amount appears in your account within seconds of payment confirmation.' },
  ]},
  { cat: '🔒 Security', items: [
    { q: 'How does SDB protect my money?', a: 'We use TLS 256-bit encryption, two-factor authentication (2FA), 24/7 security monitoring, and AI-powered fraud detection. Your account is protected by the highest banking security standards.' },
    { q: 'What should I do if I lose my phone?', a: 'Contact support immediately 24/7 to freeze your account and cards. You can also log in from another device and freeze your cards yourself.' },
    { q: 'What is KYC and why is it required?', a: 'KYC (Know Your Customer) is a mandatory regulatory process to verify customer identity. It involves providing an ID document and proof of address. This protects your account and helps combat money laundering and fraud.' },
  ]},
  { cat: '🎧 Support', items: [
    { q: 'How do I contact customer support?', a: 'You can reach us via: in-app live support (24/7), email at support@sdb-bank.com, or phone at +45 42 80 55 94. Our team is always available to help.' },
    { q: 'How long does it take to process support tickets?', a: 'We aim to respond to all tickets within 4 hours maximum. Urgent matters (such as fraud) are processed immediately.' },
  ]},
];

let faqIndex = 0;
const indexedFaqs = faqs.map(cat => ({ ...cat, items: cat.items.map(item => ({ ...item, index: faqIndex++ })) }));
</script>

<template>
    <Head title="FAQ — SDB Bank" />
    <div class="lg-root">
        <header class="lg-header">
            <div class="max-w-5xl mx-auto px-6 flex justify-between items-center">
                <Link href="/" class="lg-mark">SDB<span class="lg-dot">.</span></Link>
                <div class="flex gap-3">
                    <Link href="/terms" class="lg-link">Terms</Link>
                    <Link href="/privacy" class="lg-link">Privacy</Link>
                    <Link href="/about" class="lg-link">About</Link>
                    <Link href="/support" class="lg-link">Support</Link>
                </div>
            </div>
        </header>

        <main class="max-w-4xl mx-auto px-6 py-12">
            <div class="text-center mb-10">
                <h1 class="text-3xl font-black text-[#0B1F3A] mb-2">Frequently Asked Questions</h1>
                <p class="text-sm text-gray-400">Comprehensive answers to the most common questions about our services</p>
            </div>

            <div class="space-y-8">
                <div v-for="cat in indexedFaqs" :key="cat.cat">
                    <h2 class="text-lg font-bold text-[#0B1F3A] mb-3">{{ cat.cat }}</h2>
                    <div class="space-y-2">
                        <div v-for="item in cat.items" :key="item.index" class="fq-card" :class="openFaq === item.index ? 'fq-card-open' : ''">
                            <button class="fq-q" @click="toggle(item.index)">
                                <span>{{ item.q }}</span>
                                <span class="fq-arrow" :class="openFaq === item.index ? 'fq-arrow-open' : ''">›</span>
                            </button>
                            <div v-if="openFaq === item.index" class="fq-a">{{ item.a }}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="fq-cta">
                <div class="text-2xl mb-2">🤔</div>
                <h3 class="font-bold text-[#0B1F3A] text-lg mb-1">Didn't find your answer?</h3>
                <p class="text-sm text-gray-400 mb-4">Our support team is available 24/7 to help you</p>
                <div class="flex gap-3 justify-center">
                    <a href="mailto:support@sdb-bank.com" class="fq-btn">📧 Email us</a>
                    <Link href="/support" class="fq-btn fq-btn-blue">🎧 Live Support</Link>
                </div>
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
.fq-card{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:12px;overflow:hidden;transition:all .3s}
.fq-card:hover{border-color:rgba(37,99,235,0.15)}
.fq-card-open{border-color:rgba(37,99,235,0.2);background:rgba(37,99,235,0.01)}
.fq-q{width:100%;text-align:left;padding:14px 18px;display:flex;justify-content:space-between;align-items:center;cursor:pointer;font-size:14px;font-weight:600;color:#0B1F3A;background:none;border:none}
.fq-arrow{font-size:20px;color:rgba(37,99,235,0.5);transition:transform .2s;font-weight:300}
.fq-arrow-open{transform:rotate(90deg);color:#2563EB}
.fq-a{padding:0 18px 16px;font-size:13px;line-height:1.9;color:rgba(11,31,58,0.55);border-top:1px solid rgba(11,31,58,0.05);padding-top:12px;margin:0 18px;animation:fadeIn .2s}
@keyframes fadeIn{from{opacity:0;transform:translateY(-5px)}to{opacity:1;transform:translateY(0)}}
.fq-cta{text-align:center;padding:40px;background:linear-gradient(135deg,rgba(37,99,235,0.03),rgba(0,194,255,0.03));border:1.5px solid rgba(37,99,235,0.1);border-radius:20px;margin-top:40px}
.fq-btn{display:inline-flex;padding:10px 20px;border-radius:12px;font-size:13px;font-weight:600;color:rgba(11,31,58,0.5);border:1.5px solid rgba(11,31,58,0.1);text-decoration:none;transition:all .3s;background:#fff}.fq-btn:hover{border-color:#2563EB;color:#2563EB}
.fq-btn-blue{background:linear-gradient(135deg,#2563EB,#3B82F6)!important;color:#fff!important;border-color:#2563EB!important;box-shadow:0 4px 12px rgba(37,99,235,0.2)}.fq-btn-blue:hover{box-shadow:0 6px 20px rgba(37,99,235,0.3)}
.lg-footer{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
.lg-flink{font-size:12px;color:rgba(11,31,58,0.4);text-decoration:none}.lg-flink:hover{color:#2563EB}
</style>
