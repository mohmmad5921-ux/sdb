<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MerchantApiKey extends Model
{
    protected $fillable = [
        'merchant_id', 'name', 'public_key', 'secret_key_hash',
        'secret_key_prefix', 'environment', 'is_active', 'last_used_at',
    ];

    protected $casts = ['is_active' => 'boolean', 'last_used_at' => 'datetime'];
    protected $hidden = ['secret_key_hash'];

    public function merchant()
    {
        return $this->belongsTo(Merchant::class);
    }

    public static function generateKeyPair(): array
    {
        $publicKey = 'pk_' . bin2hex(random_bytes(24));
        $secretKey = 'sk_' . bin2hex(random_bytes(24));
        return [
            'public_key' => $publicKey,
            'secret_key' => $secretKey,
            'secret_key_hash' => hash('sha256', $secretKey),
            'secret_key_prefix' => substr($secretKey, 0, 12),
        ];
    }

    public function verifySecretKey(string $key): bool
    {
        return hash('sha256', $key) === $this->secret_key_hash;
    }
}