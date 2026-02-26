<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\PaymentGatewayService;
use App\Models\PaymentSession;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class PaymentApiController extends Controller
{
    public function __construct(private PaymentGatewayService $gateway) {}

    /**
     * POST /api/v1/checkout/sessions
     * Create a new checkout session
     */
    public function createSession(Request $request): JsonResponse
    {
        $merchant = $this->gateway->authenticateMerchant($request->bearerToken() ?? '');
        if (!$merchant) {
            return response()->json(['error' => 'Invalid API key'], 401);
        }

        $validated = $request->validate([
            'amount' => 'required|numeric|min:0.01',
            'currency' => 'nullable|string|max:10',
            'description' => 'nullable|string|max:255',
            'order_id' => 'nullable|string|max:100',
            'customer_email' => 'nullable|email',
            'customer_name' => 'nullable|string|max:255',
            'success_url' => 'nullable|url',
            'cancel_url' => 'nullable|url',
            'webhook_url' => 'nullable|url',
            'metadata' => 'nullable|array',
        ]);

        try {
            $session = $this->gateway->createSession($merchant, $validated);
            return response()->json([
                'id' => $session->session_id,
                'checkout_url' => route('checkout.pay', $session->session_id),
                'amount' => $session->amount,
                'currency' => $session->currency_code,
                'status' => $session->status,
                'expires_at' => $session->expires_at->toISOString(),
            ], 201);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 400);
        }
    }

    /**
     * GET /api/v1/checkout/sessions/{sessionId}
     * Get session status
     */
    public function getSession(Request $request, string $sessionId): JsonResponse
    {
        $merchant = $this->gateway->authenticateMerchant($request->bearerToken() ?? '');
        if (!$merchant) {
            return response()->json(['error' => 'Invalid API key'], 401);
        }

        $session = PaymentSession::where('session_id', $sessionId)
            ->where('merchant_id', $merchant->id)
            ->first();

        if (!$session) {
            return response()->json(['error' => 'Session not found'], 404);
        }

        return response()->json([
            'id' => $session->session_id,
            'amount' => $session->amount,
            'currency' => $session->currency_code,
            'status' => $session->status,
            'order_id' => $session->order_id,
            'customer_email' => $session->customer_email,
            'paid_at' => $session->paid_at?->toISOString(),
            'metadata' => $session->metadata,
        ]);
    }

    /**
     * POST /api/v1/checkout/sessions/{sessionId}/refund
     */
    public function refundSession(Request $request, string $sessionId): JsonResponse
    {
        $merchant = $this->gateway->authenticateMerchant($request->bearerToken() ?? '');
        if (!$merchant) {
            return response()->json(['error' => 'Invalid API key'], 401);
        }

        $session = PaymentSession::where('session_id', $sessionId)
            ->where('merchant_id', $merchant->id)
            ->first();

        if (!$session) {
            return response()->json(['error' => 'Session not found'], 404);
        }

        try {
            $session = $this->gateway->refundPayment($session);
            return response()->json(['status' => $session->status, 'message' => 'Refund processed']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 400);
        }
    }
}