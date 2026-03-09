<!DOCTYPE html>
<html dir="rtl">

<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: #f8fafc;
            padding: 20px;
            direction: rtl;
            color: #0f172a
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            background: #fff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, .08)
        }

        .header {
            background: linear-gradient(135deg, #10b981, #059669);
            padding: 28px;
            text-align: center;
            color: #fff
        }

        .header h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 800
        }

        .header p {
            margin: 8px 0 0;
            font-size: 14px;
            opacity: .85
        }

        .content {
            padding: 28px
        }

        .stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 20px
        }

        .stat {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 16px;
            text-align: center
        }

        .stat-value {
            font-size: 28px;
            font-weight: 800;
            color: #10b981
        }

        .stat-label {
            font-size: 12px;
            color: #64748b;
            margin-top: 4px
        }

        .stat-compare {
            font-size: 11px;
            color: #94a3b8;
            margin-top: 4px
        }

        .alerts {
            margin-top: 16px
        }

        .alert {
            background: #fffbeb;
            border: 1px solid #fde68a;
            border-radius: 10px;
            padding: 10px 14px;
            margin-bottom: 8px;
            font-size: 13px;
            color: #92400e
        }

        .alert-red {
            background: #fef2f2;
            border-color: #fecaca;
            color: #991b1b
        }

        .footer {
            background: #f8fafc;
            padding: 16px;
            text-align: center;
            font-size: 12px;
            color: #94a3b8;
            border-top: 1px solid #e2e8f0
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="header">
            <h1>📊 SDB Bank — تقرير يومي</h1>
            <p>{{ $data['date'] }}</p>
        </div>
        <div class="content">
            <div class="stats">
                <div class="stat">
                    <div class="stat-value">{{ $data['new_users_today'] }}</div>
                    <div class="stat-label">عملاء جدد اليوم</div>
                    <div class="stat-compare">الأمس: {{ $data['new_users_yesterday'] }}</div>
                </div>
                <div class="stat">
                    <div class="stat-value" style="color:#3b82f6">{{ $data['transactions_today'] }}</div>
                    <div class="stat-label">معاملات اليوم</div>
                    <div class="stat-compare">الأمس: {{ $data['transactions_yesterday'] }}</div>
                </div>
                <div class="stat">
                    <div class="stat-value" style="color:#8b5cf6">€{{ number_format($data['volume_today'], 0) }}</div>
                    <div class="stat-label">حجم اليوم</div>
                    <div class="stat-compare">الأمس: €{{ number_format($data['volume_yesterday'], 0) }}</div>
                </div>
                <div class="stat">
                    <div class="stat-value" style="color:#0f172a">{{ $data['total_users'] }}</div>
                    <div class="stat-label">إجمالي العملاء</div>
                    <div class="stat-compare">{{ $data['total_transactions'] }} معاملة كلية</div>
                </div>
            </div>

            <div class="alerts">
                @if($data['pending_kyc'] > 0)
                    <div class="alert">⚠️ {{ $data['pending_kyc'] }} طلب KYC معلّق بانتظار المراجعة</div>
                @endif
                @if($data['failed_transactions'] > 0)
                    <div class="alert alert-red">🚨 {{ $data['failed_transactions'] }} معاملة فاشلة اليوم</div>
                @endif
                @if($data['pending_kyc'] == 0 && $data['failed_transactions'] == 0)
                    <div class="alert" style="background:#ecfdf5;border-color:#a7f3d0;color:#059669">✅ لا توجد تنبيهات — كل
                        شيء يعمل بشكل طبيعي</div>
                @endif
            </div>
        </div>
        <div class="footer">
            SDB Bank — لوحة التحكم: <a href="https://sdb-bank.com/admin/dashboard"
                style="color:#10b981">sdb-bank.com</a>
        </div>
    </div>
</body>

</html>