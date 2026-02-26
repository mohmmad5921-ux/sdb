<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'full_name', 'email', 'phone', 'password', 'status', 'kyc_status',
        'nationality', 'date_of_birth', 'address', 'city', 'country',
        'postal_code', 'profile_photo', 'role', 'preferred_language',
        'last_login_at', 'last_login_ip', 'referral_code', 'referred_by',
        'customer_number',
    ];

    protected static function booted(): void
    {
        static::creating(function ($user) {
            if (!$user->customer_number) {
                do {
                    $number = str_pad(mt_rand(0, 9999999999), 10, '0', STR_PAD_LEFT);
                } while (static::where('customer_number', $number)->exists());
                $user->customer_number = $number;
            }
        });
    }

    protected $hidden = ['password', 'remember_token'];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'last_login_at' => 'datetime',
            'date_of_birth' => 'date',
            'password' => 'hashed',
        ];
    }

    public function accounts()
    {
        return $this->hasMany(Account::class);
    }
    public function cards()
    {
        return $this->hasMany(Card::class);
    }
    public function kycDocuments()
    {
        return $this->hasMany(KycDocument::class);
    }
    public function beneficiaries()
    {
        return $this->hasMany(Beneficiary::class);
    }
    public function notifications()
    {
        return $this->hasMany(Notification::class);
    }
    public function supportTickets()
    {
        return $this->hasMany(SupportTicket::class);
    }
    public function loginHistory()
    {
        return $this->hasMany(LoginHistory::class);
    }
    public function referrals()
    {
        return $this->hasMany(Referral::class , 'referrer_id');
    }

    public function isAdmin(): bool
    {
        return in_array($this->role, ['admin', 'super_admin']);
    }
    public function isSuperAdmin(): bool
    {
        return $this->role === 'super_admin';
    }
    public function isActive(): bool
    {
        return $this->status === 'active';
    }
    public function isKycVerified(): bool
    {
        return $this->kyc_status === 'verified';
    }

    public function getDefaultAccount(string $currencyCode = 'EUR')
    {
        return $this->accounts()
            ->whereHas('currency', fn($q) => $q->where('code', $currencyCode))
            ->where('is_default', true)
            ->first();
    }
}