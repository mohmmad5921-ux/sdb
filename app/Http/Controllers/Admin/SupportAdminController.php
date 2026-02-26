<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\SupportTicket;
use App\Models\SupportMessage;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SupportAdminController extends Controller
{
    public function index(Request $request)
    {
        $query = SupportTicket::with(['user', 'assignee'])->withCount('messages');

        if ($request->status && $request->status !== 'all') {
            $query->where('status', $request->status);
        }
        else {
            $query->whereIn('status', ['open', 'in_progress', 'waiting_customer']);
        }

        $tickets = $query->orderByDesc('updated_at')->paginate(20)->withQueryString();

        $stats = [
            'open' => SupportTicket::where('status', 'open')->count(),
            'in_progress' => SupportTicket::where('status', 'in_progress')->count(),
            'waiting' => SupportTicket::where('status', 'waiting_customer')->count(),
            'resolved' => SupportTicket::where('status', 'resolved')->count(),
        ];

        return Inertia::render('Admin/SupportTickets', [
            'tickets' => $tickets,
            'filters' => $request->only(['status']),
            'stats' => $stats,
        ]);
    }

    public function show($id)
    {
        $ticket = SupportTicket::with(['user', 'messages.user', 'assignee'])->findOrFail($id);

        return Inertia::render('Admin/SupportTicketDetail', [
            'ticket' => $ticket,
        ]);
    }

    public function reply(Request $request, $id)
    {
        $request->validate(['message' => 'required|string|max:2000']);

        $ticket = SupportTicket::findOrFail($id);

        SupportMessage::create([
            'ticket_id' => $ticket->id,
            'user_id' => auth()->id(),
            'message' => $request->message,
            'is_admin' => true,
        ]);

        $ticket->update([
            'status' => 'waiting_customer',
            'assigned_to' => auth()->id(),
        ]);

        return back()->with('success', 'تم إرسال الرد');
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate(['status' => 'required|in:open,in_progress,waiting_customer,resolved,closed']);

        $ticket = SupportTicket::findOrFail($id);
        $update = ['status' => $request->status];
        if ($request->status === 'resolved') {
            $update['resolved_at'] = now();
        }
        $ticket->update($update);

        return back()->with('success', 'تم تحديث حالة التذكرة');
    }
}