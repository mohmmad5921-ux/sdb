<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ExchangeRate extends Model
{
    protected $fillable = ['from_currency_id', 'to_currency_id', 'rate', 'spread', 'buy_rate', 'sell_rate', 'is_active'];
    protected $casts = ['rate' => 'decimal:8', 'buy_rate' => 'decimal:8', 'sell_rate' => 'decimal:8', 'spread' => 'decimal:4', 'is_active' => 'boolean'];
    public function fromCurrency()
    {
        return $this->belongsTo(Currency::class , 'from_currency_id');
    }
    public function toCurrency()
    {
        return $this->belongsTo(Currency::class , 'to_currency_id');
    }
}