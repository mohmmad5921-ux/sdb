<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CardDeposit extends Model
{
    protected $fillable = [
        'reference', 'user_id', 'account_id', 'transaction_id',
        'amount', 'currency_code', 'fee_amount', 'net_amount',
        'card_brand', 'card_last_four', 'card_holder_name', 'card_expiry_masked',
        'status', 'processor_reference', 'failure_reason', 'ip_address', 'completed_at',
    ];

    protected $casts = [
        'amount' => 'decimal:4',
        'fee_amount' => 'decimal:4',
        'net_amount' => 'decimal:4',
        'completed_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function account()
    {
        return $this->belongsTo(Account::class);
    }
    public function transaction()
    {
        return $this->belongsTo(Transaction::class);
    }

    public static function generateReference(): string
    {
        return 'DEP' . strtoupper(bin2hex(random_bytes(8)));
    }
}