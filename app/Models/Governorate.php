<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Governorate extends Model
{
    protected $fillable = ['name_ar', 'name_en', 'code', 'is_active'];
    protected $casts = ['is_active' => 'boolean'];

    public function districts() { return $this->hasMany(District::class); }
    public function scopeActive($q) { return $q->where('is_active', true); }
}
