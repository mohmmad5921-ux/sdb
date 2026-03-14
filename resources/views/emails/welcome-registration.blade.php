<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>مرحباً بك في SDB Bank</title>
</head>
<body style="margin:0;padding:0;background:#f0f2f5;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif">
    <table width="100%" cellpadding="0" cellspacing="0" style="background:#f0f2f5;padding:40px 20px">
        <tr>
            <td align="center">
                <table width="560" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08)">

                    <!-- Header with Logo -->
                    <tr>
                        <td style="background:linear-gradient(135deg,#1a6b3c 0%,#2d8f52 50%,#1a6b3c 100%);padding:40px 48px;text-align:center">
                            <img src="https://sdb-bank.com/images/sdb-logo-white.png" alt="SDB Bank" width="80" style="margin-bottom:12px">
                            <div style="font-size:24px;font-weight:900;color:#ffffff;letter-spacing:-0.5px">مرحباً بك في SDB Bank</div>
                            <div style="font-size:13px;color:rgba(255,255,255,0.8);margin-top:6px">Syrian Digital Bank</div>
                        </td>
                    </tr>

                    <!-- Welcome Icon -->
                    <tr>
                        <td style="padding:40px 48px 0;text-align:center">
                            <div style="width:80px;height:80px;background:#e8f5e9;border-radius:50%;display:inline-block;line-height:80px;font-size:36px">🎉</div>
                        </td>
                    </tr>

                    <!-- Body -->
                    <tr>
                        <td style="padding:24px 48px 40px;text-align:right">
                            <h1 style="font-size:22px;font-weight:800;color:#1a1a1a;margin:0 0 16px;text-align:center">أهلاً وسهلاً، {{ $user->full_name }}!</h1>

                            <p style="font-size:15px;color:#555;line-height:1.9;margin:0 0 20px;text-align:right">
                                شكراً لتسجيلك في SDB Bank. حسابك الآن <strong style="color:#f59e0b">قيد المراجعة</strong> وسيتم تفعيله خلال وقت قصير.
                            </p>

                            <p style="font-size:15px;color:#555;line-height:1.9;margin:0 0 28px;text-align:right">
                                سنقوم بإرسال إشعار لك فور تفعيل حسابك حتى تتمكن من الاستفادة من جميع خدماتنا.
                            </p>

                            <!-- Features Box -->
                            <div style="background:#f8faf9;border-radius:12px;padding:24px;margin-bottom:28px;border:1px solid #e8f5e9">
                                <div style="font-size:14px;font-weight:800;color:#1a6b3c;margin-bottom:16px;text-align:center">✨ ماذا ينتظرك</div>
                                <table width="100%" cellpadding="0" cellspacing="0" dir="rtl">
                                    <tr><td style="padding:8px 0;font-size:14px;color:#444;text-align:right">💳 بطاقات ماستركارد فورية</td></tr>
                                    <tr><td style="padding:8px 0;font-size:14px;color:#444;text-align:right">💱 حسابات بأكثر من 30 عملة</td></tr>
                                    <tr><td style="padding:8px 0;font-size:14px;color:#444;text-align:right">🪙 تداول العملات الرقمية</td></tr>
                                    <tr><td style="padding:8px 0;font-size:14px;color:#444;text-align:right">⚡ تحويلات دولية سريعة</td></tr>
                                    <tr><td style="padding:8px 0;font-size:14px;color:#444;text-align:right">🛡️ حماية على مستوى البنوك</td></tr>
                                </table>
                            </div>

                            <!-- Status Badge -->
                            <div style="text-align:center;margin-bottom:24px">
                                <span style="display:inline-block;background:#fff3cd;color:#856404;padding:10px 24px;border-radius:50px;font-size:14px;font-weight:700">⏳ حسابك قيد المراجعة</span>
                            </div>

                            <p style="font-size:13px;color:#999;line-height:1.7;margin:0;text-align:center">
                                إذا كان لديك أي استفسار، لا تتردد بالرد على هذا الإيميل.
                            </p>
                        </td>
                    </tr>

                    <!-- Footer -->
                    <tr>
                        <td style="padding:28px 48px;background:#fafafa;border-top:1px solid #f0f0f0;text-align:center">
                            <img src="https://sdb-bank.com/images/sdb-logo-new.png" alt="SDB" width="40" style="opacity:0.3;margin-bottom:8px">
                            <p style="font-size:11px;color:#bbb;line-height:1.6;margin:0">
                                SDB Bank · Syrian Digital Bank<br>
                                © 2026 جميع الحقوق محفوظة
                            </p>
                        </td>
                    </tr>

                </table>
            </td>
        </tr>
    </table>
</body>
</html>
