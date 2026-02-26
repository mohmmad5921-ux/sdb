<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Currency extends Model
{
    protected $fillable = [
        'code', 'name', 'name_ar', 'symbol', 'type',
        'exchange_rate_to_eur', 'is_active', 'is_default',
        'decimal_places', 'flag_icon', 'sort_order',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'is_default' => 'boolean',
        'exchange_rate_to_eur' => 'decimal:8',
    ];

    public function accounts()
    {
        return $this->hasMany(Account::class);
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }
    public function scopeFiat($query)
    {
        return $query->where('type', 'fiat');
    }
    public function scopeCrypto($query)
    {
        return $query->where('type', 'crypto');
    }

    public function isFiat(): bool
    {
        return $this->type === 'fiat';
    }
    public function isCrypto(): bool
    {
        return $this->type === 'crypto';
    }
}