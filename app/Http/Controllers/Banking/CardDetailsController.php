<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\Card;
use App\Models\CardTransaction;
use App\Services\CardService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CardDetailsController extends Controller
{
    public function __construct(private CardService $cardService)
    {
    }

    public function show($cardId)
    {
        $card = auth()->user()->cards()->with('account.currency')->findOrFail($cardId);

        $transactions = CardTransaction::where('card_id', $card->id)
            ->orderByDesc('created_at')
            ->limit(20)
            ->get();

        return Inertia::render('Banking/CardDetails', [
            'card' => $card,
            'transactions' => $transactions,
        ]);
    }

    public function toggleOnline(Request $request, $cardId)
    {
        $card = auth()->user()->cards()->findOrFail($cardId);
        $card->update(['online_payment_enabled' => !$card->online_payment_enabled]);
        return back()->with('success', $card->online_payment_enabled ? 'تم تفعيل الشراء أونلاين' : 'تم إيقاف الشراء أونلاين');
    }

    public function toggleAtm(Request $request, $cardId)
    {
        $card = auth()->user()->cards()->findOrFail($cardId);
        $card->update(['atm_enabled' => !$card->atm_enabled]);
        return back()->with('success', $card->atm_enabled ? 'تم تفعيل سحب ATM' : 'تم إيقاف سحب ATM');
    }

    public function toggleContactless(Request $request, $cardId)
    {
        $card = auth()->user()->cards()->findOrFail($cardId);
        $card->update(['contactless_enabled' => !$card->contactless_enabled]);
        return back()->with('success', $card->contactless_enabled ? 'تم تفعيل الدفع بدون تلامس' : 'تم إيقاف الدفع بدون تلامس');
    }

    public function updateLimits(Request $request, $cardId)
    {
        $request->validate([
            'daily_limit' => 'required|numeric|min:0|max:50000',
            'monthly_limit' => 'required|numeric|min:0|max:200000',
        ]);

        $card = auth()->user()->cards()->findOrFail($cardId);
        $card->update($request->only(['daily_limit', 'monthly_limit']));

        return back()->with('success', 'تم تحديث حدود الإنفاق');
    }

    public function freeze($cardId)
    {
        $card = auth()->user()->cards()->findOrFail($cardId);
        $this->cardService->freeze($card);
        return back()->with('success', 'تم تجميد البطاقة');
    }

    public function unfreeze($cardId)
    {
        $card = auth()->user()->cards()->findOrFail($cardId);
        $this->cardService->unfreeze($card);
        return back()->with('success', 'تم تفعيل البطاقة');
    }
}