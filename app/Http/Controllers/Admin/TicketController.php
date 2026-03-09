<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\SupportTicket;
use App\Models\TicketReply;
use App\Models\AdminActivityLog;
use Illuminate\Http\Request;
use Inertia\Inertia;

class TicketController extends Controller
{
    public function index(Request $request)
    {
        $query = SupportTicket::with(['user', 'assignee'])
            ->withCount('replies');

        if ($request->status && $request->status !== 'all') {
            $query->where('status', $request->status);
        }
        if ($request->priority) {
            $query->where('priority', $request->priority);
        }
        if ($request->search) {
            $query->where(function ($q) use ($request) {
                $q->where('subject', 'like', "%{$request->search}%")
                    ->orWhere('ticket_number', 'like', "%{$request->search}%");
            });
        }

        $stats = [
            'open' => SupportTicket::where('status', 'open')->count(),
            'in_progress' => SupportTicket::where('status', 'in_progress')->count(),
            'waiting' => SupportTicket::where('status', 'waiting')->count(),
            'resolved' => SupportTicket::where('status', 'resolved')->count(),
            'total' => SupportTicket::count(),
        ];

        return Inertia::render('Admin/Tickets', [
            'tickets' => $query->orderByRaw("FIELD(priority, 'urgent', 'high', 'normal', 'low')")->orderByDesc('created_at')->paginate(20)->withQueryString(),
            'filters' => $request->only(['status', 'priority', 'search']),
            'stats' => $stats,
        ]);
    }

    public function show(SupportTicket $ticket)
    {
        $ticket->load(['user', 'assignee', 'replies.user']);

        return Inertia::render('Admin/TicketDetail', [
            'ticket' => $ticket,
            'replies' => $ticket->replies->sortBy('created_at')->values(),
        ]);
    }

    public function reply(Request $request, SupportTicket $ticket)
    {
        $request->validate(['message' => 'required|string|max:2000']);

        TicketReply::create([
            'ticket_id' => $ticket->id,
            'user_id' => auth()->id(),
            'message' => $request->message,
            'is_admin' => true,
        ]);

        if ($ticket->status === 'open') {
            $ticket->update(['status' => 'in_progress', 'assigned_to' => auth()->id()]);
        }

        return back()->with('success', 'تم إرسال الرد');
    }

    public function updateStatus(Request $request, SupportTicket $ticket)
    {
        $request->validate(['status' => 'required|in:open,in_progress,waiting,resolved,closed']);
        $old = $ticket->status;
        $ticket->update([
            'status' => $request->status,
            'resolved_at' => $request->status === 'resolved' ? now() : $ticket->resolved_at,
        ]);

        AdminActivityLog::log('ticket.status_change', 'ticket', $ticket->id, [
            'old' => $old,
            'new' => $request->status,
            'ticket' => $ticket->ticket_number,
        ]);

        return back()->with('success', 'تم تحديث حالة التذكرة');
    }

    public function updatePriority(Request $request, SupportTicket $ticket)
    {
        $request->validate(['priority' => 'required|in:low,normal,high,urgent']);
        $ticket->update(['priority' => $request->priority]);
        return back()->with('success', 'تم تحديث الأولوية');
    }
}
