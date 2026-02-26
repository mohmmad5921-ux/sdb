<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LoginHistory extends Model
{
    public $timestamps = false;
    protected $table = 'login_history';
    protected $fillable = ['user_id', 'ip_address', 'user_agent', 'device_type', 'browser', 'os', 'country', 'city', 'is_successful'];
    protected $casts = ['is_successful' => 'boolean', 'created_at' => 'datetime'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public static function record($userId, $request, $successful = true): self
    {
        $ua = $request->userAgent() ?? '';
        $device = str_contains(strtolower($ua), 'mobile') ? 'mobile' : (str_contains(strtolower($ua), 'tablet') ? 'tablet' : 'desktop');
        $browser = 'Unknown';
        if (str_contains($ua, 'Chrome'))
            $browser = 'Chrome';
        elseif (str_contains($ua, 'Safari'))
            $browser = 'Safari';
        elseif (str_contains($ua, 'Firefox'))
            $browser = 'Firefox';
        elseif (str_contains($ua, 'Edge'))
            $browser = 'Edge';

        $os = 'Unknown';
        if (str_contains($ua, 'Windows'))
            $os = 'Windows';
        elseif (str_contains($ua, 'Mac'))
            $os = 'macOS';
        elseif (str_contains($ua, 'Linux'))
            $os = 'Linux';
        elseif (str_contains($ua, 'Android'))
            $os = 'Android';
        elseif (str_contains($ua, 'iPhone') || str_contains($ua, 'iPad'))
            $os = 'iOS';

        return self::create([
            'user_id' => $userId,
            'ip_address' => $request->ip(),
            'user_agent' => substr($ua, 0, 500),
            'device_type' => $device,
            'browser' => $browser,
            'os' => $os,
            'is_successful' => $successful,
        ]);
    }
}