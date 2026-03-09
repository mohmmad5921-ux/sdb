<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AdminActivityLog extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'admin_id',
        'action',
        'target_type',
        'target_id',
        'details',
        'ip_address',
        'created_at',
    ];

    protected $casts = [
        'details' => 'array',
        'created_at' => 'datetime',
    ];

    public function admin()
    {
        return $this->belongsTo(User::class, 'admin_id');
    }

    /**
     * Quick helper to log an admin action.
     */
    public static function log(string $action, ?string $targetType = null, $targetId = null, array $details = []): self
    {
        return static::create([
            'admin_id' => auth()->id(),
            'action' => $action,
            'target_type' => $targetType,
            'target_id' => $targetId,
            'details' => $details ?: null,
            'ip_address' => request()->ip(),
            'created_at' => now(),
        ]);
    }

    /**
     * Human-readable action labels (Arabic).
     */
    public static function actionLabels(): array
    {
        return [
            'user.status_change' => 'تغيير حالة العميل',
            'user.kyc_update' => 'تحديث حالة KYC',
            'user.password_reset' => 'إعادة تعيين كلمة المرور',
            'user.profile_update' => 'تعديل بيانات العميل',
            'user.freeze_all' => 'تجميد جميع الحسابات',
            'user.unfreeze_all' => 'إلغاء تجميد الحسابات',
            'user.send_note' => 'إرسال إشعار للعميل',
            'account.status_change' => 'تغيير حالة الحساب',
            'account.balance_adjust' => 'تعديل رصيد',
            'card.status_change' => 'تغيير حالة البطاقة',
            'card.limits_update' => 'تعديل حدود البطاقة',
            'broadcast.notification' => 'إشعار جماعي',
        ];
    }
}
