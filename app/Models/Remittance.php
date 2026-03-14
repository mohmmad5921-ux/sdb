<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Remittance extends Model
{
    protected $fillable = [
        'user_id', 'agent_id', 'recipient_name', 'recipient_phone',
        'amount', 'send_currency', 'receive_amount', 'receive_currency',
        'exchange_rate', 'fee', 'status', 'notification_code', 'qr_token',
        'notes', 'collected_at', 'expires_at',
    ];

    protected $casts = [
        'amount' => 'decimal:2',
        'receive_amount' => 'decimal:2',
        'exchange_rate' => 'decimal:4',
        'fee' => 'decimal:2',
        'collected_at' => 'datetime',
        'expires_at' => 'datetime',
    ];

    public function user() { return $this->belongsTo(User::class); }
    public function agent() { return $this->belongsTo(Agent::class); }

    public function isExpired(): bool
    {
        return $this->expires_at && now()->gt($this->expires_at);
    }

    public function isCollectable(): bool
    {
        return $this->status === 'ready' && !$this->isExpired();
    }

    public static function generateCode(): string
    {
        do {
            $code = strtoupper(Str::random(8));
        } while (self::where('notification_code', $code)->exists());
        return $code;
    }

    public static function generateQrToken(): string
    {
        return (string) Str::uuid();
    }
}
