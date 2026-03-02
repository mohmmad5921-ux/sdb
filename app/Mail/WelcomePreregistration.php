<?php

namespace App\Mail;

use App\Models\Preregistration;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class WelcomePreregistration extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(public Preregistration $registration)
    {
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Welcome to SDB Bank — You\'re on the list! 🎉',
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.welcome-preregistration',
        );
    }
}
