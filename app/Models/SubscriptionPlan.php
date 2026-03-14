<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SubscriptionPlan extends Model
{
    protected $fillable = [
        'slug', 'name_en', 'name_ar', 'price_monthly', 'price_yearly',
        'currency', 'features', 'max_wallets', 'max_transfers_monthly',
        'has_virtual_card', 'has_physical_card', 'has_remittance',
        'cashback_pct', 'is_active', 'sort_order',
    ];

    protected $casts = [
        'features' => 'array',
        'is_active' => 'boolean',
        'has_virtual_card' => 'boolean',
        'has_physical_card' => 'boolean',
        'has_remittance' => 'boolean',
        'cashback_pct' => 'decimal:2',
    ];

    public function subscriptions() { return $this->hasMany(Subscription::class, 'plan_id'); }

    public function isFree(): bool { return $this->price_monthly === 0; }
}
