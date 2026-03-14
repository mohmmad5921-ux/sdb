<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Agent extends Model
{
    protected $fillable = ['district_id', 'name_ar', 'name_en', 'phone', 'address_ar', 'address_en', 'commission_rate', 'is_active'];
    protected $casts = ['is_active' => 'boolean', 'commission_rate' => 'decimal:2'];

    public function district() { return $this->belongsTo(District::class); }
    public function remittances() { return $this->hasMany(Remittance::class); }
    public function scopeActive($q) { return $q->where('is_active', true); }
}
