<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SupportTicket extends Model
{
    protected $fillable = ['user_id', 'subject', 'category', 'priority', 'status', 'ticket_number', 'assigned_to', 'resolved_at'];
    protected $casts = ['resolved_at' => 'datetime'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function assignee()
    {
        return $this->belongsTo(User::class , 'assigned_to');
    }
    public function messages()
    {
        return $this->hasMany(SupportMessage::class , 'ticket_id');
    }

    public static function generateTicketNumber(): string
    {
        return 'TKT-' . strtoupper(substr(md5(uniqid()), 0, 8));
    }
}