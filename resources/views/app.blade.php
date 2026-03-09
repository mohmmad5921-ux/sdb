<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description"
        content="SDB Bank — أول بنك إلكتروني سوري. حسابات متعددة العملات، بطاقات ماستركارد، تحويلات دولية، عملات رقمية. مرخّص بالدنمارك.">
    <meta name="theme-color" content="#0EA5E9">
    <link rel="manifest" href="/manifest.json">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="apple-mobile-web-app-title" content="SDB Bank">

    <!-- Open Graph / Facebook / WhatsApp -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://sdb-bank.com/">
    <meta property="og:title" content="SDB Bank — أول بنك إلكتروني سوري">
    <meta property="og:description"
        content="حوّل، ادفع، ووفّر بدون رسوم مخفية. حسابات متعددة العملات، بطاقات ماستركارد فورية، تحويلات لـ 150+ دولة.">
    <meta property="og:image" content="https://sdb-bank.com/images/og-cover.png">
    <meta property="og:locale" content="ar_SY">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="SDB Bank — أول بنك إلكتروني سوري">
    <meta name="twitter:description" content="حوّل، ادفع، ووفّر بدون رسوم مخفية. مرخّص بالدنمارك 🇩🇰">
    <meta name="twitter:image" content="https://sdb-bank.com/images/og-cover.png">

    <title inertia>{{ config('app.name', 'Laravel') }}</title>

    <!-- Fonts (preload for performance) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />

    <!-- Multi-language SEO -->
    <link rel="alternate" hreflang="ar" href="https://sdb-bank.com/">
    <link rel="alternate" hreflang="en" href="https://sdb-bank.com/">
    <link rel="alternate" hreflang="x-default" href="https://sdb-bank.com/">

    <!-- Canonical -->
    <link rel="canonical" href="https://sdb-bank.com/">

    <!-- Scripts -->
    @routes
    @vite(['resources/js/app.js', "resources/js/Pages/{$page['component']}.vue"])
    @inertiaHead
</head>

<body class="font-sans antialiased">
    @inertia

    <!-- Service Worker Registration -->
    <script>
        if ('serviceWorker' in navigator) { navigator.serviceWorker.register('/sw.js').catch(() => { }); }
    </script>

    <!-- Analytics (Plausible — privacy-friendly, no cookies) -->
    <script defer data-domain="sdb-bank.com" src="https://plausible.io/js/script.js"></script>
</body>

</html>