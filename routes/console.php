<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

// Run drip campaign emails daily at 9 AM
Schedule::command('drip:send')->dailyAt('09:00');

// Send daily admin report at 8 AM
Schedule::call(function () {
    \Illuminate\Support\Facades\Mail::to('admin@sdb.sy')
        ->send(new \App\Mail\DailyAdminReport());
})->dailyAt('08:00');

// Fetch live exchange rates every hour
Schedule::command('rates:fetch')->hourly();
