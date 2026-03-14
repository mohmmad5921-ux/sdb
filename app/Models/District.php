<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class District extends Model
{
    protected $fillable = ['governorate_id', 'name_ar', 'name_en', 'is_active'];
    protected $casts = ['is_active' => 'boolean'];

    public function governorate() { return $this->belongsTo(Governorate::class); }
    public function agents() { return $this->hasMany(Agent::class); }
    public function scopeActive($q) { return $q->where('is_active', true); }
}
