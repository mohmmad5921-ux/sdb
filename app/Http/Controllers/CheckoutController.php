<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\PaymentSession;
use App\Services\PaymentGatewayService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CheckoutController extends Controller
{
    public function __construct(private PaymentGatewayService $gateway)
    {
    }

    /**
     * Show checkout page for a payment session
     */
    public function show(string $sessionId)
    {
        $session = PaymentSession::where('session_id', $sessionId)
            ->with('merchant')
            ->first();

        if (!$session) {
            abort(404, 'Payment session not found');
        }

        if ($session->isExpired()) {
            $session->update(['status' => 'expired']);
        }

        $accounts = [];
        if (auth()->check()) {
            $accounts = auth()->user()->accounts()
                ->with('currency')
                ->where('status', 'active')
                ->get();
        }

        return Inertia::render('Checkout/Pay', [
            'session' => [
                'session_id' => $session->session_id,
                'amount' => $session->amount,
                'currency_code' => $session->currency_code,
                'description' => $session->description,
                'order_id' => $session->order_id,
                'status' => $session->status,
                'expires_at' => $session->expires_at->toISOString(),
                'merchant' => [
                    'name' => $session->merchant->business_name,
                    'name_ar' => $session->merchant->business_name_ar,
                    'logo' => $session->merchant->logo,
                    'category' => $session->merchant->category,
                ],
            ],
            'accounts' => $accounts,
            'isAuthenticated' => auth()->check(),
        ]);
    }

    /**
     * Process payment from checkout page
     */
    public function pay(Request $request, string $sessionId)
    {
        if (!auth()->check()) {
            return redirect()->route('login')->with('error', 'Please login to pay');
        }

        $request->validate([
            'account_id' => 'required|exists:accounts,id',
        ]);

        $session = PaymentSession::where('session_id', $sessionId)->firstOrFail();

        $account = Account::where('id', $request->account_id)
            ->where('user_id', auth()->id())
            ->firstOrFail();

        try {
            $paidSession = $this->gateway->processPayment($session, $account);

            if ($paidSession->success_url) {
                return Inertia::location($paidSession->success_url . '?session_id=' . $paidSession->session_id);
            }

            return Inertia::render('Checkout/Success', [
                'session' => $paidSession->load('merchant'),
            ]);
        }
        catch (\Exception $e) {
            return back()->withErrors(['payment' => $e->getMessage()]);
        }
    }
}