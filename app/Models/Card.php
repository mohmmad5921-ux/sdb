<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Card extends Model
{
    protected $fillable = [
        'user_id', 'account_id', 'card_number_masked', 'card_number_encrypted',
        'card_type', 'card_holder_name', 'status', 'spending_limit',
        'daily_limit', 'monthly_limit', 'expiry_date', 'cvv_hash',
        'billing_address', 'online_payment_enabled', 'contactless_enabled',
        'stripe_card_id',
    ];

    protected $casts = [
        'spending_limit' => 'decimal:4',
        'daily_limit' => 'decimal:4',
        'monthly_limit' => 'decimal:4',
        'expiry_date' => 'date',
        'online_payment_enabled' => 'boolean',
        'contactless_enabled' => 'boolean',
    ];

    protected $hidden = ['card_number_encrypted', 'cvv_hash'];

    protected $appends = ['formatted_expiry'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function account()
    {
        return $this->belongsTo(Account::class);
    }
    public function cardTransactions()
    {
        return $this->hasMany(CardTransaction::class);
    }

    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    public function isActive(): bool
    {
        return $this->status === 'active';
    }
    public function isFrozen(): bool
    {
        return $this->status === 'frozen';
    }
    public function isExpired(): bool
    {
        return $this->expiry_date->isPast();
    }

    public function getFormattedCardNumber(): string
    {
        return implode(' ', str_split($this->card_number_masked, 4));
    }

    public function getFormattedExpiryAttribute(): string
    {
        return $this->expiry_date ? $this->expiry_date->format('m/y') : '';
    }
}