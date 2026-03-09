<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Account extends Model
{
    protected $fillable = [
        'user_id',
        'currency_id',
        'account_number',
        'iban',
        'balance',
        'available_balance',
        'held_balance',
        'status',
        'is_default',
        'account_name',
        'business_code',
        'qr_data',
        'account_type',
    ];

    protected $casts = [
        'balance' => 'decimal:4',
        'available_balance' => 'decimal:4',
        'held_balance' => 'decimal:4',
        'is_default' => 'boolean',
    ];

    protected static function booted()
    {
        static::creating(function ($account) {
            if (empty($account->account_number)) {
                $account->account_number = \App\Services\AccountNumberService::generateAccountNumber();
            }
            if (empty($account->iban)) {
                $account->iban = \App\Services\AccountNumberService::generateIban($account->account_number);
            }
            if ($account->account_type === 'business' && empty($account->business_code)) {
                $account->business_code = \App\Services\AccountNumberService::generateBusinessCode();
            }
        });

        static::created(function ($account) {
            if (empty($account->qr_data)) {
                $account->update(['qr_data' => \App\Services\AccountNumberService::generateQrData($account)]);
            }
        });
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function currency()
    {
        return $this->belongsTo(Currency::class);
    }
    public function cards()
    {
        return $this->hasMany(Card::class);
    }

    public function outgoingTransactions()
    {
        return $this->hasMany(Transaction::class, 'from_account_id');
    }
    public function incomingTransactions()
    {
        return $this->hasMany(Transaction::class, 'to_account_id');
    }

    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    public function isActive(): bool
    {
        return $this->status === 'active';
    }

    public function getFormattedBalance(): string
    {
        return number_format($this->balance, $this->currency->decimal_places ?? 2) . ' ' . $this->currency->symbol;
    }

    public function getMaskedIban(): string
    {
        return substr($this->iban, 0, 4) . ' **** **** ' . substr($this->iban, -4);
    }
}