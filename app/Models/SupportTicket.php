<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SupportTicket extends Model
{
    protected $fillable = ['user_id', 'assigned_to', 'subject', 'description', 'priority', 'status', 'category', 'ticket_number', 'resolved_at'];

    protected $casts = ['resolved_at' => 'datetime'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function assignee()
    {
        return $this->belongsTo(User::class, 'assigned_to');
    }
    public function replies()
    {
        return $this->hasMany(TicketReply::class, 'ticket_id');
    }

    public static function generateNumber(): string
    {
        return 'TK-' . strtoupper(substr(md5(uniqid()), 0, 8));
    }
}