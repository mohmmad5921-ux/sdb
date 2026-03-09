<!DOCTYPE html>
<html lang="en" dir="rtl">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>404 — SDB Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
        rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(-45deg, #F0F9FF, #E0F2FE, #BAE6FD, #F0F9FF);
            background-size: 400% 400%;
            animation: bg 15s ease infinite;
            font-family: 'Inter', sans-serif
        }

        @keyframes bg {
            0% {
                background-position: 0% 50%
            }

            50% {
                background-position: 100% 50%
            }

            100% {
                background-position: 0% 50%
            }
        }

        .c {
            text-align: center;
            padding: 40px 24px;
            max-width: 520px
        }

        .code {
            font-size: clamp(6rem, 15vw, 10rem);
            font-weight: 900;
            color: #0C4A6E;
            line-height: 1;
            letter-spacing: -.06em;
            margin-bottom: 8px;
            background: linear-gradient(135deg, #0284C7, #0EA5E9, #38BDF8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text
        }

        .t {
            font-size: clamp(1.2rem, 3vw, 1.8rem);
            font-weight: 800;
            color: #0C4A6E;
            margin-bottom: 12px
        }

        .s {
            font-size: 15px;
            color: rgba(12, 74, 110, .5);
            line-height: 1.8;
            margin-bottom: 40px
        }

        .btn {
            display: inline-block;
            padding: 16px 40px;
            background: linear-gradient(135deg, #0284C7, #0EA5E9);
            color: #fff;
            text-decoration: none;
            font-size: 15px;
            font-weight: 800;
            border-radius: 14px;
            transition: all .2s;
            font-family: inherit
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(14, 165, 233, .3)
        }

        .emoji {
            font-size: 48px;
            margin-bottom: 24px;
            display: block
        }

        .links {
            margin-top: 32px;
            display: flex;
            gap: 16px;
            justify-content: center;
            flex-wrap: wrap
        }

        .links a {
            font-size: 13px;
            color: #0EA5E9;
            text-decoration: none;
            font-weight: 600;
            padding: 8px 16px;
            border: 1px solid rgba(14, 165, 233, .15);
            border-radius: 10px;
            transition: all .2s
        }

        .links a:hover {
            background: rgba(14, 165, 233, .05);
            border-color: #0EA5E9
        }
    </style>
</head>

<body>
    <div class="c">
        <span class="emoji">🔍</span>
        <div class="code">404</div>
        <h1 class="t">الصفحة غير موجودة</h1>
        <p class="s">الصفحة اللي تبحث عنها ممكن تكون انحذفت أو الرابط غلط.<br>Page not found — the page may have been
            removed or the link is incorrect.</p>
        <a href="/" class="btn">← العودة للرئيسية</a>
        <div class="links">
            <a href="/about">عنّا</a>
            <a href="/support">الدعم</a>
            <a href="/preregister">التسجيل</a>
            <a href="/faq">الأسئلة الشائعة</a>
        </div>
    </div>
</body>

</html>