<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PaymentSession extends Model
{
    protected $fillable = [
        'session_id', 'merchant_id', 'amount', 'currency_code', 'status',
        'description', 'order_id', 'customer_email', 'customer_name',
        'success_url', 'cancel_url', 'webhook_url', 'paid_by_user_id',
        'paid_from_account_id', 'transaction_id', 'metadata',
        'fee_amount', 'payment_method', 'ip_address', 'paid_at', 'expires_at',
    ];

    protected $casts = [
        'amount' => 'decimal:4',
        'fee_amount' => 'decimal:4',
        'metadata' => 'array',
        'paid_at' => 'datetime',
        'expires_at' => 'datetime',
    ];

    public function merchant()
    {
        return $this->belongsTo(Merchant::class);
    }
    public function paidByUser()
    {
        return $this->belongsTo(User::class , 'paid_by_user_id');
    }
    public function paidFromAccount()
    {
        return $this->belongsTo(Account::class , 'paid_from_account_id');
    }
    public function transaction()
    {
        return $this->belongsTo(Transaction::class);
    }
    public function webhookDeliveries()
    {
        return $this->hasMany(WebhookDelivery::class);
    }

    public function isPending(): bool
    {
        return $this->status === 'pending';
    }
    public function isPaid(): bool
    {
        return $this->status === 'paid';
    }
    public function isExpired(): bool
    {
        return $this->expires_at->isPast() && $this->status === 'pending';
    }

    public static function generateSessionId(): string
    {
        return 'cs_' . bin2hex(random_bytes(24));
    }
}