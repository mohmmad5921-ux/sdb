<?php

namespace App\Mail;

use App\Models\User;
use App\Models\Transaction;
use Carbon\Carbon;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class DailyAdminReport extends Mailable
{
    use Queueable, SerializesModels;

    public array $data;

    public function __construct()
    {
        $today = Carbon::today();
        $yesterday = Carbon::yesterday();

        $this->data = [
            'date' => $today->format('Y-m-d'),
            'new_users_today' => User::where('role', 'customer')->whereDate('created_at', $today)->count(),
            'new_users_yesterday' => User::where('role', 'customer')->whereDate('created_at', $yesterday)->count(),
            'transactions_today' => Transaction::whereDate('created_at', $today)->count(),
            'transactions_yesterday' => Transaction::whereDate('created_at', $yesterday)->count(),
            'volume_today' => Transaction::where('status', 'completed')->whereDate('created_at', $today)->sum('amount_in_eur'),
            'volume_yesterday' => Transaction::where('status', 'completed')->whereDate('created_at', $yesterday)->sum('amount_in_eur'),
            'pending_kyc' => User::where('role', 'customer')->where('kyc_status', 'pending')->count(),
            'failed_transactions' => Transaction::where('status', 'failed')->whereDate('created_at', $today)->count(),
            'total_users' => User::where('role', 'customer')->count(),
            'total_transactions' => Transaction::count(),
        ];
    }

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'SDB Bank — تقرير يومي ' . $this->data['date']);
    }

    public function content(): Content
    {
        return new Content(view: 'emails.daily-admin-report');
    }
}
