<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WebhookDelivery extends Model
{
    protected $fillable = ['payment_session_id', 'url', 'event', 'payload', 'http_status', 'response_body', 'is_successful', 'attempt_number'];
    protected $casts = ['payload' => 'array', 'is_successful' => 'boolean'];
    public function paymentSession()
    {
        return $this->belongsTo(PaymentSession::class);
    }
}