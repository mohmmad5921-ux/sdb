<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Http;
use Inertia\Inertia;

class ApiDashboardController extends Controller
{
    public function index()
    {
        $services = [];

        // CoinGecko API
        try {
            $start = microtime(true);
            $response = Http::timeout(5)->get('https://api.coingecko.com/api/v3/ping');
            $latency = round((microtime(true) - $start) * 1000);
            $services[] = [
                'name' => 'CoinGecko API',
                'icon' => '🪙',
                'status' => $response->ok() ? 'online' : 'error',
                'response_time' => $latency,
                'last_check' => now()->toIso8601String(),
                'details' => $response->ok() ? 'Connected' : 'Status: ' . $response->status(),
            ];
        } catch (\Exception $e) {
            $services[] = ['name' => 'CoinGecko API', 'icon' => '🪙', 'status' => 'offline', 'response_time' => 0, 'last_check' => now()->toIso8601String(), 'details' => $e->getMessage()];
        }

        // MoonPay API
        try {
            $start = microtime(true);
            $response = Http::timeout(5)->get('https://api.moonpay.com/v3/currencies');
            $latency = round((microtime(true) - $start) * 1000);
            $services[] = [
                'name' => 'MoonPay API',
                'icon' => '🌙',
                'status' => $response->ok() ? 'online' : 'error',
                'response_time' => $latency,
                'last_check' => now()->toIso8601String(),
                'details' => $response->ok() ? 'Connected' : 'Status: ' . $response->status(),
            ];
        } catch (\Exception $e) {
            $services[] = ['name' => 'MoonPay API', 'icon' => '🌙', 'status' => 'offline', 'response_time' => 0, 'last_check' => now()->toIso8601String(), 'details' => $e->getMessage()];
        }

        // SMTP Check
        $smtpStatus = 'unknown';
        try {
            $mailConfig = config('mail.mailers.smtp');
            $smtpStatus = $mailConfig['host'] ? 'configured' : 'not_configured';
            $services[] = [
                'name' => 'SMTP Email',
                'icon' => '📧',
                'status' => $smtpStatus === 'configured' ? 'online' : 'warning',
                'response_time' => 0,
                'last_check' => now()->toIso8601String(),
                'details' => $mailConfig['host'] . ':' . $mailConfig['port'],
            ];
        } catch (\Exception $e) {
            $services[] = ['name' => 'SMTP Email', 'icon' => '📧', 'status' => 'error', 'response_time' => 0, 'last_check' => now()->toIso8601String(), 'details' => $e->getMessage()];
        }

        // Database
        try {
            $start = microtime(true);
            \DB::connection()->getPdo();
            $latency = round((microtime(true) - $start) * 1000);
            $services[] = [
                'name' => 'Database',
                'icon' => '🗄️',
                'status' => 'online',
                'response_time' => $latency,
                'last_check' => now()->toIso8601String(),
                'details' => config('database.default') . ' — ' . config('database.connections.' . config('database.default') . '.database'),
            ];
        } catch (\Exception $e) {
            $services[] = ['name' => 'Database', 'icon' => '🗄️', 'status' => 'offline', 'response_time' => 0, 'last_check' => now()->toIso8601String(), 'details' => $e->getMessage()];
        }

        // Storage
        $services[] = [
            'name' => 'Storage',
            'icon' => '💾',
            'status' => is_writable(storage_path()) ? 'online' : 'error',
            'response_time' => 0,
            'last_check' => now()->toIso8601String(),
            'details' => 'Free: ' . round(disk_free_space(storage_path()) / 1073741824, 1) . ' GB',
        ];

        // System info
        $systemInfo = [
            'php_version' => PHP_VERSION,
            'laravel_version' => app()->version(),
            'server_time' => now()->toIso8601String(),
            'timezone' => config('app.timezone'),
            'env' => config('app.env'),
            'debug' => config('app.debug'),
        ];

        return Inertia::render('Admin/ApiDashboard', [
            'services' => $services,
            'systemInfo' => $systemInfo,
        ]);
    }
}
