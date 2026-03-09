<?php

namespace App\Mail;

use App\Models\WaitlistEmail;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class WaitlistConfirmation extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(public WaitlistEmail $entry)
    {
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Welcome to the SDB Bank Waitlist! 🚀',
        );
    }

    public function content(): Content
    {
        return new Content(view: 'emails.waitlist');
    }
}
