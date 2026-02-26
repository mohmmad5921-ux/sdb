<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Beneficiary extends Model
{
    protected $fillable = ['user_id', 'name', 'iban', 'account_number', 'bank_name', 'swift_code', 'country', 'is_favorite'];
    protected $casts = ['is_favorite' => 'boolean'];
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}