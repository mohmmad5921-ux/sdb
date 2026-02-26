<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Account extends Model
{
    protected $fillable = [
        'user_id', 'currency_id', 'account_number', 'iban',
        'balance', 'available_balance', 'held_balance',
        'status', 'is_default', 'account_name',
    ];

    protected $casts = [
        'balance' => 'decimal:4',
        'available_balance' => 'decimal:4',
        'held_balance' => 'decimal:4',
        'is_default' => 'boolean',
    ];

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
        return $this->hasMany(Transaction::class , 'from_account_id');
    }
    public function incomingTransactions()
    {
        return $this->hasMany(Transaction::class , 'to_account_id');
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