<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ChatMessage;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;

class AdminChatController extends Controller
{
    public function index()
    {
        // Get users who have chat messages, with last message and unread count
        $conversations = ChatMessage::select('user_id')
            ->groupBy('user_id')
            ->get()
            ->map(function ($item) {
                $user = User::find($item->user_id);
                if (!$user) return null;

                $lastMsg = ChatMessage::where('user_id', $item->user_id)
                    ->orderByDesc('created_at')
                    ->first();

                $unread = ChatMessage::where('user_id', $item->user_id)
                    ->where('sender_type', 'user')
                    ->where('is_read', false)
                    ->count();

                return [
                    'user_id' => $user->id,
                    'user_name' => $user->full_name ?? $user->username ?? 'User',
                    'user_status' => $user->status,
                    'last_message' => $lastMsg?->content ?? '',
                    'last_message_at' => $lastMsg?->created_at?->toIso8601String(),
                    'sender_type' => $lastMsg?->sender_type,
                    'unread_count' => $unread,
                ];
            })
            ->filter()
            ->sortByDesc('last_message_at')
            ->values();

        return Inertia::render('Admin/Chat', [
            'conversations' => $conversations,
        ]);
    }

    public function show(User $user)
    {
        $messages = ChatMessage::where('user_id', $user->id)
            ->orderBy('created_at', 'asc')
            ->get()
            ->map(fn($m) => [
                'id' => $m->id,
                'sender_type' => $m->sender_type,
                'sender_name' => $m->sender_name,
                'content' => $m->content,
                'created_at' => $m->created_at->toIso8601String(),
            ]);

        // Mark user messages as read
        ChatMessage::where('user_id', $user->id)
            ->where('sender_type', 'user')
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return response()->json(['messages' => $messages, 'user' => [
            'id' => $user->id,
            'name' => $user->full_name ?? $user->username,
            'status' => $user->status,
        ]]);
    }

    public function reply(Request $request, User $user)
    {
        $request->validate(['message' => 'required|string|max:2000']);

        $msg = ChatMessage::create([
            'user_id' => $user->id,
            'sender_type' => 'admin',
            'sender_name' => $request->user()->full_name ?? 'Support',
            'admin_id' => $request->user()->id,
            'content' => $request->message,
        ]);

        return response()->json([
            'message' => [
                'id' => $msg->id,
                'sender_type' => 'admin',
                'sender_name' => $msg->sender_name,
                'content' => $msg->content,
                'created_at' => $msg->created_at->toIso8601String(),
            ],
        ]);
    }
}
