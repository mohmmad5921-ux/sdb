<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class DuplicateAccountAlert extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public string $userName,
        public string $duplicateField,
        public string $attemptValue,
        public string $attemptIp,
        public string $attemptTime,
    ) {}

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: '⚠️ SDB Bank — محاولة تسجيل حساب جديد بمعلوماتك',
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.duplicate-account-alert',
        );
    }
}
