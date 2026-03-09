<!DOCTYPE html>
<html dir="rtl">

<head>
    <meta charset="UTF-8">
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #F0F9FF;
            font-family: 'Segoe UI', sans-serif
        }

        .c {
            max-width: 600px;
            margin: 0 auto;
            padding: 40px 24px
        }

        .card {
            background: #fff;
            border-radius: 20px;
            padding: 48px 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, .06);
            text-align: center
        }

        .logo {
            font-size: 32px;
            font-weight: 900;
            color: #0284C7
        }

        .dot {
            color: #0EA5E9
        }

        .emoji {
            font-size: 48px;
            margin: 24px 0 16px
        }

        h1 {
            font-size: 22px;
            color: #0C4A6E;
            margin-bottom: 12px
        }

        p {
            font-size: 15px;
            color: rgba(10, 10, 10, .6);
            line-height: 1.8;
            margin-bottom: 20px
        }

        .btn {
            display: inline-block;
            padding: 16px 40px;
            background: linear-gradient(135deg, #0284C7, #0EA5E9);
            color: #fff !important;
            font-size: 16px;
            font-weight: 800;
            border-radius: 14px;
            text-decoration: none
        }

        .cards {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: center;
            margin: 20px 0
        }

        .card-mini {
            padding: 12px 16px;
            background: #F0F9FF;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 700;
            color: #0C4A6E
        }

        .footer {
            text-align: center;
            margin-top: 32px;
            font-size: 12px;
            color: rgba(10, 10, 10, .4)
        }
    </style>
</head>

<body>
    <div class="c">
        <div class="card">
            <div class="logo">SDB<span class="dot">.</span></div>
            <div class="emoji">💳</div>
            <h1>اكتشف بطاقات SDB</h1>
            <p>4 مستويات من البطاقات مصممة لتناسب احتياجاتك:</p>
            <div class="cards">
                <div class="card-mini">🆓 Standard — مجاني</div>
                <div class="card-mini">💜 Plus — CVV ديناميكي</div>
                <div class="card-mini">💗 Premium — تأمين سفر</div>
                <div class="card-mini">🥇 Elite — VIP lounges</div>
            </div>
            <p>كل بطاقة تعمل مع Apple Pay و Google Pay في أي مكان بالعالم.</p>
            <a href="https://sdb-bank.com/cards" class="btn">تعرّف على البطاقات →</a>
        </div>
        <div class="footer">
            <p>SDB Bank — أول بنك إلكتروني سوري 🇸🇾</p>
        </div>
    </div>
</body>

</html>