<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\Request;
use Inertia\Inertia;

class NotificationController extends Controller
{
    public function index()
    {
        $notifications = auth()->user()->notifications()
            ->orderByDesc('created_at')
            ->paginate(20);

        $unreadCount = auth()->user()->notifications()->where('is_read', false)->count();

        return Inertia::render('Banking/Notifications', [
            'notifications' => $notifications,
            'unreadCount' => $unreadCount,
        ]);
    }

    public function markRead($id)
    {
        $notification = auth()->user()->notifications()->findOrFail($id);
        $notification->update(['is_read' => true, 'read_at' => now()]);

        return back();
    }

    public function markAllRead()
    {
        auth()->user()->notifications()->where('is_read', false)->update([
            'is_read' => true,
            'read_at' => now(),
        ]);

        return back()->with('success', 'تم تعليم جميع الإشعارات كمقروءة');
    }
}