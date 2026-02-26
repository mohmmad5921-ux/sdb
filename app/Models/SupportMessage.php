<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SupportMessage extends Model
{
    protected $fillable = ['ticket_id', 'user_id', 'message', 'is_admin', 'attachment_path', 'attachment_name'];
    protected $casts = ['is_admin' => 'boolean'];

    public function ticket()
    {
        return $this->belongsTo(SupportTicket::class , 'ticket_id');
    }
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}