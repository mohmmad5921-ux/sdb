<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="About — SDB Bank" />
    <div class="lg-root">
        <header class="lg-header">
            <div class="max-w-5xl mx-auto px-6 flex justify-between items-center">
                <Link href="/" class="lg-mark">SDB<span class="lg-dot">.</span></Link>
                <div class="flex gap-4">
                    <Link href="/terms" class="lg-link">Terms</Link>
                    <Link href="/privacy" class="lg-link">Privacy</Link>
                    <Link href="/faq" class="lg-link">FAQ</Link>
                    <Link href="/support" class="lg-link">Support</Link>
                </div>
            </div>
        </header>

        <main class="max-w-4xl mx-auto px-6 py-12">
            <div class="text-center mb-12">
                <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#2563EB]/8 text-[#2563EB] text-xs font-semibold mb-4">🏦 About SDB Bank</div>
                <h1 class="text-4xl font-black text-[#0B1F3A] mb-3">Your Smart Digital Bank</h1>
                <p class="text-lg text-[#0B1F3A]/60 max-w-xl mx-auto">Redefining banking through advanced technology and smart design</p>
            </div>

            <div class="ab-card ab-card-blue mb-8">
                <h2 class="text-xl font-black text-[#0B1F3A] mb-3">🎯 Our Mission</h2>
                <p class="text-sm text-[#0B1F3A]/65 leading-7">At SDB Bank, we strive to provide a comprehensive digital banking experience that combines high security with ease of use. Our goal is to make banking accessible to everyone regardless of location, and to offer smart financial tools that help our customers manage their money efficiently.</p>
            </div>

            <h2 class="text-xl font-bold text-[#0B1F3A] mb-4">💎 Core Values</h2>
            <div class="grid grid-cols-2 gap-4 mb-8">
                <div class="ab-card"><div class="text-3xl mb-3">🔒</div><h3 class="font-bold text-[#0B1F3A] mb-2">Security First</h3><p class="text-sm text-[#0B1F3A]/60">We use AES-256 encryption and cutting-edge biometric authentication to protect our customers' assets and information around the clock.</p></div>
                <div class="ab-card"><div class="text-3xl mb-3">⚡</div><h3 class="font-bold text-[#0B1F3A] mb-2">Speed & Efficiency</h3><p class="text-sm text-[#0B1F3A]/60">Instant 24/7 transfers, instant card issuance, and account opening in minutes.</p></div>
                <div class="ab-card"><div class="text-3xl mb-3">🌍</div><h3 class="font-bold text-[#0B1F3A] mb-2">Borderless Banking</h3><p class="text-sm text-[#0B1F3A]/60">Multi-currency accounts (DKK, USD, EUR, GBP), SWIFT international transfers, and cards accepted in 150+ countries.</p></div>
                <div class="ab-card"><div class="text-3xl mb-3">💡</div><h3 class="font-bold text-[#0B1F3A] mb-2">Continuous Innovation</h3><p class="text-sm text-[#0B1F3A]/60">We constantly evolve our services to meet the changing needs of our customers using the latest financial technology.</p></div>
            </div>

            <h2 class="text-xl font-bold text-[#0B1F3A] mb-4">🚀 What Sets Us Apart</h2>
            <div class="grid grid-cols-3 gap-4 mb-8">
                <div class="ab-feat"><span class="text-2xl">💳</span><div><div class="font-bold text-[#0B1F3A] text-sm">Mastercard Cards</div><div class="text-xs text-[#0B1F3A]/50">Instant virtual & physical</div></div></div>
                <div class="ab-feat"><span class="text-2xl">💱</span><div><div class="font-bold text-[#0B1F3A] text-sm">Currency Exchange</div><div class="text-xs text-[#0B1F3A]/50">Live competitive rates</div></div></div>
                <div class="ab-feat"><span class="text-2xl">🔔</span><div><div class="font-bold text-[#0B1F3A] text-sm">Instant Notifications</div><div class="text-xs text-[#0B1F3A]/50">For every transaction</div></div></div>
                <div class="ab-feat"><span class="text-2xl">📊</span><div><div class="font-bold text-[#0B1F3A] text-sm">Financial Analytics</div><div class="text-xs text-[#0B1F3A]/50">Smart spending insights</div></div></div>
                <div class="ab-feat"><span class="text-2xl">🪪</span><div><div class="font-bold text-[#0B1F3A] text-sm">Digital KYC</div><div class="text-xs text-[#0B1F3A]/50">Smart identity verification</div></div></div>
                <div class="ab-feat"><span class="text-2xl">🎧</span><div><div class="font-bold text-[#0B1F3A] text-sm">24/7 Support</div><div class="text-xs text-[#0B1F3A]/50">Dedicated team always</div></div></div>
            </div>

            <div class="ab-card ab-card-green mb-8">
                <h2 class="text-xl font-black text-[#0B1F3A] mb-3">✅ Compliance & Licensing</h2>
                <ul class="space-y-2">
                    <li class="flex items-start gap-2 text-sm text-[#0B1F3A]/65"><span class="text-emerald-500 font-bold mt-0.5">✓</span> Registered in Denmark as a financial services company</li>
                    <li class="flex items-start gap-2 text-sm text-[#0B1F3A]/65"><span class="text-emerald-500 font-bold mt-0.5">✓</span> Compliant with European AML/CFT standards</li>
                    <li class="flex items-start gap-2 text-sm text-[#0B1F3A]/65"><span class="text-emerald-500 font-bold mt-0.5">✓</span> ISO 27001 information security certified</li>
                    <li class="flex items-start gap-2 text-sm text-[#0B1F3A]/65"><span class="text-emerald-500 font-bold mt-0.5">✓</span> GDPR compliant</li>
                </ul>
            </div>

            <div class="ab-card">
                <h2 class="text-xl font-black text-[#0B1F3A] mb-3">📬 Contact Us</h2>
                <div class="grid grid-cols-3 gap-4">
                    <div><div class="text-sm font-bold text-[#0B1F3A] mb-1">📧 Email</div><div class="text-xs text-[#0B1F3A]/55">info@sdb-bank.com</div></div>
                    <div><div class="text-sm font-bold text-[#0B1F3A] mb-1">📞 Phone</div><div class="text-xs text-[#0B1F3A]/55">+45 42 80 55 94</div></div>
                    <div><div class="text-sm font-bold text-[#0B1F3A] mb-1">📍 Location</div><div class="text-xs text-[#0B1F3A]/55">Denmark 🇩🇰</div></div>
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
.ab-card{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:16px;padding:24px;transition:all .3s}.ab-card:hover{border-color:rgba(37,99,235,0.15)}
.ab-card-blue{background:linear-gradient(135deg,rgba(37,99,235,0.02),rgba(0,194,255,0.02));border-color:rgba(37,99,235,0.1)}
.ab-card-green{background:rgba(16,185,129,0.02);border-color:rgba(16,185,129,0.1)}
.ab-feat{display:flex;align-items:center;gap:12px;background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:12px;padding:14px 16px;transition:all .3s}.ab-feat:hover{border-color:rgba(37,99,235,0.2);transform:translateY(-2px)}
.lg-footer{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
.lg-flink{font-size:12px;color:rgba(11,31,58,0.4);text-decoration:none}.lg-flink:hover{color:#2563EB}
</style>
