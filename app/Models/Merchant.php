<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Merchant extends Model
{
    protected $fillable = [
        'user_id', 'business_name', 'business_name_ar', 'business_email',
        'business_phone', 'website_url', 'description', 'logo', 'status',
        'category', 'fee_percentage', 'fee_fixed', 'settlement_account_id',
        'settlement_currency', 'total_volume', 'total_transactions',
        'allowed_currencies', 'webhook_urls',
    ];

    protected $casts = [
        'fee_percentage' => 'decimal:2',
        'fee_fixed' => 'decimal:2',
        'total_volume' => 'decimal:4',
        'allowed_currencies' => 'array',
        'webhook_urls' => 'array',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function settlementAccount()
    {
        return $this->belongsTo(Account::class , 'settlement_account_id');
    }
    public function apiKeys()
    {
        return $this->hasMany(MerchantApiKey::class);
    }
    public function paymentSessions()
    {
        return $this->hasMany(PaymentSession::class);
    }

    public function isActive(): bool
    {
        return $this->status === 'active';
    }

    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    public function calculateFee(float $amount): float
    {
        return round(($amount * $this->fee_percentage / 100) + $this->fee_fixed, 2);
    }
}