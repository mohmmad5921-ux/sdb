<?php

namespace App\Console\Commands;

use App\Models\WaitlistEmail;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Mail;

class SendDripEmails extends Command
{
    protected $signature = 'drip:send';
    protected $description = 'Send drip campaign emails to waitlist subscribers (Day 1, 3, 7)';

    public function handle()
    {
        // Day 1 — Welcome recap (24 hours after signup)
        $day1 = WaitlistEmail::where('created_at', '<=', now()->subHours(24))
            ->where('created_at', '>', now()->subHours(48))
            ->get();

        foreach ($day1 as $entry) {
            try {
                Mail::send('emails.drip-day1', ['entry' => $entry], function ($m) use ($entry) {
                    $m->to($entry->email)->subject('🏦 SDB Bank — Your journey starts here');
                });
                $this->info("Day 1 sent to: {$entry->email}");
            } catch (\Exception $e) {
                $this->warn("Failed: {$entry->email} — {$e->getMessage()}");
            }
        }

        // Day 3 — Features highlight
        $day3 = WaitlistEmail::where('created_at', '<=', now()->subDays(3))
            ->where('created_at', '>', now()->subDays(4))
            ->get();

        foreach ($day3 as $entry) {
            try {
                Mail::send('emails.drip-day3', ['entry' => $entry], function ($m) use ($entry) {
                    $m->to($entry->email)->subject('💳 Discover SDB Bank Features');
                });
                $this->info("Day 3 sent to: {$entry->email}");
            } catch (\Exception $e) {
                $this->warn("Failed: {$entry->email} — {$e->getMessage()}");
            }
        }

        // Day 7 — Urgency / referral
        $day7 = WaitlistEmail::where('created_at', '<=', now()->subDays(7))
            ->where('created_at', '>', now()->subDays(8))
            ->get();

        foreach ($day7 as $entry) {
            try {
                Mail::send('emails.drip-day7', ['entry' => $entry], function ($m) use ($entry) {
                    $m->to($entry->email)->subject('🚀 SDB Bank launches soon — invite your friends!');
                });
                $this->info("Day 7 sent to: {$entry->email}");
            } catch (\Exception $e) {
                $this->warn("Failed: {$entry->email} — {$e->getMessage()}");
            }
        }

        $this->info('Drip campaign completed.');
        return Command::SUCCESS;
    }
}
