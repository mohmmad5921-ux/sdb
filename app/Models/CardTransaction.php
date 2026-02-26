<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CardTransaction extends Model
{
    protected $fillable = ['card_id', 'transaction_id', 'amount', 'currency_code', 'merchant_name', 'merchant_category', 'merchant_country', 'status', 'decline_reason'];
    protected $casts = ['amount' => 'decimal:4'];
    public function card()
    {
        return $this->belongsTo(Card::class);
    }
    public function transaction()
    {
        return $this->belongsTo(Transaction::class);
    }
}