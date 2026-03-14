<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>تم تفعيل حسابك</title>
</head>
<body style="margin:0;padding:0;background:#ffffff;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif">
    <table width="100%" cellpadding="0" cellspacing="0" style="background:#ffffff;padding:30px 20px">
        <tr>
            <td align="center">
                <table width="560" cellpadding="0" cellspacing="0" style="background:#ffffff">

                    <!-- Logo -->
                    <tr>
                        <td style="padding:30px 40px 20px;text-align:center;border-bottom:2px solid #1a6b3c;background:#ffffff">
                            <div style="background:#ffffff;display:inline-block;padding:10px 20px;border-radius:8px">
                                <img src="https://sdb-bank.com/images/sdb-email-icon.png" alt="SDB Bank" width="80" style="display:block;margin:0 auto;border-radius:16px">
                            </div>
                        </td>
                    </tr>

                    <!-- Body -->
                    <tr>
                        <td style="padding:30px 40px">
                            <h1 style="font-size:24px;font-weight:800;color:#1a1a1a;margin:0 0 20px;text-align:center">تهانينا، {{ $user->full_name }}! 🎉</h1>

                            <p style="font-size:15px;color:#333;line-height:1.8;margin:0 0 20px;text-align:right">
                                يسعدنا إبلاغك بأنه تمت الموافقة على حسابك في <strong>SDB Bank</strong> وتفعيله بنجاح. يمكنك الآن استخدام جميع خدماتنا المصرفية الرقمية.
                            </p>

                            <!-- Active Badge -->
                            <div style="text-align:center;margin-bottom:24px">
                                <span style="display:inline-block;background:#e8f5e9;color:#2e7d32;padding:10px 24px;border-radius:6px;font-size:15px;font-weight:700;border:1px solid #a5d6a7">✅ حسابك نشط الآن</span>
                            </div>

                            <!-- Getting Started -->
                            <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:24px;border:1px solid #e5e5e5;border-radius:8px;overflow:hidden">
                                <tr><td style="padding:14px 20px;background:#f9f9f9;font-size:14px;font-weight:700;color:#1a6b3c;text-align:center">🚀 ابدأ الآن</td></tr>
                                <tr><td style="padding:10px 20px;font-size:14px;color:#333;border-top:1px solid #eee"><strong>1.</strong> افتح التطبيق وسجل الدخول</td></tr>
                                <tr><td style="padding:10px 20px;font-size:14px;color:#333;border-top:1px solid #eee"><strong>2.</strong> أكمل التحقق من هويتك</td></tr>
                                <tr><td style="padding:10px 20px;font-size:14px;color:#333;border-top:1px solid #eee"><strong>3.</strong> اطلب بطاقتك المصرفية</td></tr>
                                <tr><td style="padding:10px 20px;font-size:14px;color:#333;border-top:1px solid #eee"><strong>4.</strong> ابدأ بالإيداع والتحويل</td></tr>
                            </table>

                            <!-- Account Info -->
                            <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:20px;border:1px solid #e5e5e5;border-radius:8px;overflow:hidden">
                                <tr>
                                    <td style="padding:10px 20px;font-size:13px;color:#666;background:#f9f9f9;border-bottom:1px solid #eee;text-align:right">البريد الإلكتروني</td>
                                    <td style="padding:10px 20px;font-size:13px;color:#1a1a1a;font-weight:700;background:#f9f9f9;border-bottom:1px solid #eee;text-align:left">{{ $user->email }}</td>
                                </tr>
                                <tr>
                                    <td style="padding:10px 20px;font-size:13px;color:#666;text-align:right">رقم العميل</td>
                                    <td style="padding:10px 20px;font-size:13px;color:#1a1a1a;font-weight:700;text-align:left">{{ $user->customer_number ?? '—' }}</td>
                                </tr>
                            </table>

                            <p style="font-size:13px;color:#888;line-height:1.6;margin:0;text-align:center">
                                إذا لم تقم بإنشاء هذا الحساب، يرجى التواصل معنا فوراً.
                            </p>
                        </td>
                    </tr>

                    <!-- Footer -->
                    <tr>
                        <td style="padding:20px 40px;border-top:1px solid #eee;text-align:center">
                            <p style="font-size:11px;color:#aaa;line-height:1.6;margin:0">
                                SDB Bank · Syrian Digital Bank · © 2026
                            </p>
                        </td>
                    </tr>

                </table>
            </td>
        </tr>
    </table>
</body>
</html>
