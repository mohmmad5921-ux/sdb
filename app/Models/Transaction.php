<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    protected $fillable = [
        'reference_number', 'from_account_id', 'to_account_id', 'currency_id',
        'amount', 'fee', 'exchange_rate', 'original_amount', 'original_currency_id',
        'type', 'status', 'description', 'beneficiary_name', 'beneficiary_iban',
        'metadata', 'completed_at',
    ];

    protected $casts = [
        'amount' => 'decimal:4',
        'fee' => 'decimal:4',
        'exchange_rate' => 'decimal:8',
        'original_amount' => 'decimal:4',
        'metadata' => 'array',
        'completed_at' => 'datetime',
    ];

    public function fromAccount()
    {
        return $this->belongsTo(Account::class , 'from_account_id');
    }
    public function toAccount()
    {
        return $this->belongsTo(Account::class , 'to_account_id');
    }
    public function currency()
    {
        return $this->belongsTo(Currency::class);
    }
    public function originalCurrency()
    {
        return $this->belongsTo(Currency::class , 'original_currency_id');
    }

    public function scopePending($query)
    {
        return $query->where('status', 'pending');
    }
    public function scopeCompleted($query)
    {
        return $query->where('status', 'completed');
    }

    public function isCompleted(): bool
    {
        return $this->status === 'completed';
    }
    public function isPending(): bool
    {
        return $this->status === 'pending';
    }

    public function getFormattedAmount(): string
    {
        $sign = in_array($this->type, ['withdrawal', 'card_payment', 'fee']) ? '-' : '+';
        return $sign . number_format($this->amount, 2) . ' ' . $this->currency->symbol;
    }

    public static function generateReference(): string
    {
        return 'SDB-' . strtoupper(bin2hex(random_bytes(4))) . '-' . now()->format('ymd');
    }
}