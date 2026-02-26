<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\SupportTicket;
use App\Models\SupportMessage;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SupportController extends Controller
{
    public function index()
    {
        $tickets = auth()->user()->supportTickets()
            ->withCount('messages')
            ->orderByDesc('updated_at')
            ->paginate(15);

        return Inertia::render('Banking/Support', [
            'tickets' => $tickets,
        ]);
    }

    public function show($id)
    {
        $ticket = auth()->user()->supportTickets()->with(['messages.user'])->findOrFail($id);

        return Inertia::render('Banking/SupportTicket', [
            'ticket' => $ticket,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'subject' => 'required|string|max:255',
            'category' => 'required|in:general,account,card,transaction,technical',
            'message' => 'required|string|max:2000',
        ]);

        $ticket = SupportTicket::create([
            'user_id' => auth()->id(),
            'subject' => $request->subject,
            'category' => $request->category,
            'ticket_number' => SupportTicket::generateTicketNumber(),
        ]);

        SupportMessage::create([
            'ticket_id' => $ticket->id,
            'user_id' => auth()->id(),
            'message' => $request->message,
            'is_admin' => false,
        ]);

        return redirect()->route('banking.support.show', $ticket->id)->with('success', 'تم إرسال تذكرة الدعم — رقم: ' . $ticket->ticket_number);
    }

    public function reply(Request $request, $id)
    {
        $request->validate(['message' => 'required|string|max:2000']);

        $ticket = auth()->user()->supportTickets()->findOrFail($id);

        SupportMessage::create([
            'ticket_id' => $ticket->id,
            'user_id' => auth()->id(),
            'message' => $request->message,
            'is_admin' => false,
        ]);

        if ($ticket->status === 'waiting_customer') {
            $ticket->update(['status' => 'open']);
        }

        return back()->with('success', 'تم إرسال الرد');
    }
}