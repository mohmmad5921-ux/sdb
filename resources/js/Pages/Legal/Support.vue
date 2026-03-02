<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Support — SDB Bank" />
    <div class="lg-root">
        <header class="lg-header">
            <div class="max-w-5xl mx-auto px-6 flex justify-between items-center">
                <Link href="/" class="lg-mark">SDB<span class="lg-dot">.</span></Link>
                <div class="flex gap-3">
                    <Link href="/terms" class="lg-link">Terms</Link>
                    <Link href="/privacy" class="lg-link">Privacy</Link>
                    <Link href="/about" class="lg-link">About</Link>
                    <Link href="/faq" class="lg-link">FAQ</Link>
                </div>
            </div>
        </header>

        <main class="max-w-4xl mx-auto px-6 py-12">
            <div class="text-center mb-10">
                <div class="text-4xl mb-3">🎧</div>
                <h1 class="text-3xl font-black text-[#0B1F3A] mb-2">Support</h1>
                <p class="text-sm text-gray-400">Our team is available around the clock to help you</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-10">
                <div class="sp-card">
                    <div class="sp-icon">📧</div>
                    <h3 class="sp-title">Email</h3>
                    <p class="sp-desc">Send us a message and we'll respond within hours</p>
                    <a href="mailto:info@sdb-bank.com" class="sp-action">info@sdb-bank.com</a>
                </div>
                <div class="sp-card">
                    <div class="sp-icon">📱</div>
                    <h3 class="sp-title">Phone</h3>
                    <p class="sp-desc">Call us during business hours</p>
                    <a href="tel:+4542805594" class="sp-action">+45 42 80 55 94</a>
                </div>
                <div class="sp-card">
                    <div class="sp-icon">💬</div>
                    <h3 class="sp-title">Live Chat</h3>
                    <p class="sp-desc">Chat with our support team directly</p>
                    <Link href="/login" class="sp-action">Log in to chat</Link>
                </div>
                <div class="sp-card">
                    <div class="sp-icon">❓</div>
                    <h3 class="sp-title">FAQ</h3>
                    <p class="sp-desc">Find quick answers</p>
                    <Link href="/faq" class="sp-action">Browse FAQ</Link>
                </div>
            </div>

            <div class="sp-info">
                <h2 class="font-bold text-[#0B1F3A] text-lg mb-4">Business Hours</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="sp-schedule">
                        <span class="sp-day">Monday – Friday</span>
                        <span class="sp-time">9:00 AM – 6:00 PM (CET)</span>
                    </div>
                    <div class="sp-schedule">
                        <span class="sp-day">Saturday – Sunday</span>
                        <span class="sp-time">10:00 AM – 2:00 PM (CET)</span>
                    </div>
                </div>
                <p class="text-xs text-gray-400 mt-4">Emergency services (card & account freeze) are available 24/7 via phone and in-app</p>
            </div>

            <div class="sp-address mt-8">
                <h2 class="font-bold text-[#0B1F3A] text-lg mb-3">Address</h2>
                <p class="text-sm text-gray-500 leading-7">
                    SDB Bank ApS<br>
                    Denmark 🇩🇰
                </p>
            </div>
        </main>

        <footer class="lg-footer">
            <div class="max-w-4xl mx-auto px-6 flex justify-between items-center">
                <span class="text-sm text-gray-400">© 2026 SDB Bank ApS. All rights reserved.</span>
                <div class="flex gap-4"><Link href="/terms" class="lg-flink">Terms</Link><Link href="/privacy" class="lg-flink">Privacy</Link><Link href="/" class="lg-flink">Home</Link></div>
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
.sp-card{background:#fff;border:1.5px solid rgba(11,31,58,0.06);border-radius:16px;padding:24px;text-align:center;transition:all .3s}
.sp-card:hover{border-color:rgba(37,99,235,0.2);box-shadow:0 8px 24px rgba(37,99,235,0.06);transform:translateY(-2px)}
.sp-icon{font-size:32px;margin-bottom:12px}
.sp-title{font-size:16px;font-weight:700;color:#0B1F3A;margin-bottom:6px}
.sp-desc{font-size:13px;color:rgba(11,31,58,0.45);margin-bottom:14px}
.sp-action{display:inline-block;padding:8px 16px;background:linear-gradient(135deg,#2563EB,#3B82F6);color:#fff;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;transition:all .3s}
.sp-action:hover{box-shadow:0 4px 12px rgba(37,99,235,0.3)}
.sp-info{background:linear-gradient(135deg,rgba(37,99,235,0.03),rgba(0,194,255,0.03));border:1.5px solid rgba(37,99,235,0.08);border-radius:18px;padding:24px}
.sp-schedule{display:flex;justify-content:space-between;padding:10px 0;border-bottom:1px solid rgba(11,31,58,0.05)}
.sp-day{font-size:14px;font-weight:600;color:#0B1F3A}
.sp-time{font-size:13px;color:rgba(11,31,58,0.5)}
.sp-address{background:#FAFBFC;border:1.5px solid rgba(11,31,58,0.05);border-radius:18px;padding:24px}
.lg-footer{padding:24px 0;border-top:1px solid rgba(11,31,58,0.06);background:#FAFBFC}
.lg-flink{font-size:12px;color:rgba(11,31,58,0.4);text-decoration:none}.lg-flink:hover{color:#2563EB}
</style>
