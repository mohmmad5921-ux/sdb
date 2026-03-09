<!DOCTYPE html>
<html dir="rtl" lang="ar">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #F0F9FF;
            font-family: 'Segoe UI', Tahoma, sans-serif;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 40px 24px;
        }

        .card {
            background: #fff;
            border-radius: 20px;
            padding: 48px 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, .06);
            text-align: center;
        }

        .logo {
            font-size: 32px;
            font-weight: 900;
            color: #0284C7;
            margin-bottom: 8px;
        }

        .dot {
            color: #0EA5E9;
        }

        .emoji {
            font-size: 48px;
            margin: 24px 0 16px;
        }

        h1 {
            font-size: 24px;
            color: #0C4A6E;
            margin-bottom: 12px;
        }

        p {
            font-size: 15px;
            color: rgba(10, 10, 10, .6);
            line-height: 1.8;
            margin-bottom: 20px;
        }

        .btn {
            display: inline-block;
            padding: 16px 40px;
            background: linear-gradient(135deg, #0284C7, #0EA5E9);
            color: #fff !important;
            font-size: 16px;
            font-weight: 800;
            border-radius: 14px;
            text-decoration: none;
        }

        .footer {
            text-align: center;
            margin-top: 32px;
            font-size: 12px;
            color: rgba(10, 10, 10, .4);
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="card">
            <div class="logo">SDB<span class="dot">.</span></div>
            <div class="emoji">🚀</div>
            <h1>!أهلاً بك في قائمة الانتظار</h1>
            <p>تم تسجيل بريدك <strong>{{ $entry->email }}</strong> بنجاح.</p>
            <p>سنبلغك فور إطلاق SDB Bank — أول بنك إلكتروني سوري. كن من أوائل المستخدمين!</p>
            <a href="https://sdb-bank.com/preregister" class="btn">سجّل الآن للحصول على مزايا إضافية →</a>
        </div>
        <div class="footer">
            <p>SDB Bank — أول بنك إلكتروني سوري 🇸🇾<br>مرخّص بالدنمارك 🇩🇰</p>
        </div>
    </div>
</body>

</html>