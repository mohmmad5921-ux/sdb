<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f8f9fa; margin: 0; padding: 20px; direction: rtl; }
        .container { max-width: 520px; margin: 0 auto; background: #fff; border-radius: 16px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.06); }
        .header { background: linear-gradient(135deg, #1E5EFF, #0D47A1); padding: 28px 24px; text-align: center; }
        .header img { width: 120px; }
        .header h1 { color: #fff; font-size: 18px; margin: 12px 0 0; font-weight: 700; }
        .body { padding: 28px 24px; }
        .alert-box { background: #FEF3C7; border: 1px solid #F59E0B; border-radius: 12px; padding: 16px; margin-bottom: 20px; display: flex; align-items: flex-start; gap: 10px; }
        .alert-icon { font-size: 24px; line-height: 1; }
        .alert-text { font-size: 14px; color: #92400E; line-height: 1.6; }
        .detail-box { background: #F1F5F9; border-radius: 12px; padding: 16px; margin: 16px 0; }
        .detail-row { display: flex; justify-content: space-between; padding: 6px 0; font-size: 13px; }
        .detail-label { color: #64748B; }
        .detail-value { color: #0F172A; font-weight: 600; font-family: monospace; direction: ltr; }
        p { color: #475569; font-size: 14px; line-height: 1.7; margin: 12px 0; }
        .cta { display: inline-block; background: #1E5EFF; color: #fff; text-decoration: none; padding: 12px 28px; border-radius: 12px; font-weight: 700; font-size: 14px; margin: 16px 0; }
        .footer { padding: 20px 24px; border-top: 1px solid #E2E8F0; text-align: center; }
        .footer p { font-size: 11px; color: #94A3B8; margin: 4px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <img src="https://sdb-bank.com/images/sdb-logo-white.png" alt="SDB Bank">
            <h1>⚠️ تنبيه أمني</h1>
        </div>
        <div class="body">
            <p>مرحباً <strong>{{ $userName }}</strong>،</p>

            <div class="alert-box">
                <span class="alert-icon">⚠️</span>
                <span class="alert-text">
                    تم محاولة إنشاء حساب جديد باستخدام بياناتك المسجلة لدينا. إذا لم تكن أنت من قام بهذا، فلا داعي للقلق — حسابك آمن ولم يتأثر.
                </span>
            </div>

            <div class="detail-box">
                <div class="detail-row">
                    <span class="detail-label">الحقل المكرر:</span>
                    <span class="detail-value">{{ $duplicateField }}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">القيمة المستخدمة:</span>
                    <span class="detail-value">{{ $attemptValue }}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">عنوان IP:</span>
                    <span class="detail-value">{{ $attemptIp }}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">الوقت:</span>
                    <span class="detail-value">{{ $attemptTime }}</span>
                </div>
            </div>

            <p>إذا كنت تحاول فتح حساب ثانٍ، يرجى العلم أنه لا يمكن ربط نفس البريد الإلكتروني أو رقم الهاتف بأكثر من حساب واحد.</p>

            <p>إذا كنت بحاجة إلى مساعدة، تواصل مع فريق الدعم:</p>

            <center><a href="mailto:support@sdb-bank.com" class="cta">التواصل مع الدعم</a></center>
        </div>
        <div class="footer">
            <p>هذا البريد تم إرساله تلقائياً من نظام SDB Bank</p>
            <p>© {{ date('Y') }} SDB Bank. جميع الحقوق محفوظة.</p>
        </div>
    </div>
</body>
</html>
