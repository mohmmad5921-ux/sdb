<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Subscription;
use App\Models\SubscriptionPlan;
use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SubscriptionController extends Controller
{
    /**
     * Subscribe to a plan (free plans: instant activation)
     */
    public function subscribe(Request $request)
    {
        $request->validate(['plan_id' => 'required|string']);

        $user = $request->user();
        $plan = SubscriptionPlan::where('slug', $request->plan_id)->where('is_active', true)->first();

        if (!$plan) {
            return response()->json(['message' => 'الخطة غير موجودة'], 404);
        }

        // Check if user already has an active subscription
        $existing = Subscription::where('user_id', $user->id)
            ->where('status', 'active')
            ->first();

        if ($existing) {
            return response()->json(['message' => 'لديك اشتراك نشط بالفعل'], 409);
        }

        // Free plan — instant activation
        if ($plan->isFree()) {
            return $this->activateSubscription($user, $plan);
        }

        return response()->json(['message' => 'يرجى استخدام عملية الدفع للخطط المدفوعة'], 400);
    }

    /**
     * Create Stripe PaymentIntent for paid subscription
     */
    public function createIntent(Request $request)
    {
        $request->validate(['plan_id' => 'required|string']);

        $user = $request->user();
        $plan = SubscriptionPlan::where('slug', $request->plan_id)->where('is_active', true)->first();

        if (!$plan) {
            return response()->json(['message' => 'الخطة غير موجودة'], 404);
        }

        if ($plan->isFree()) {
            return response()->json(['message' => 'الخطة المجانية لا تحتاج دفع'], 400);
        }

        try {
            $stripe = new \Stripe\StripeClient(config('services.stripe.secret'));

            $intent = $stripe->paymentIntents->create([
                'amount' => $plan->price_monthly,
                'currency' => strtolower($plan->currency),
                'metadata' => [
                    'user_id' => $user->id,
                    'plan_slug' => $plan->slug,
                    'type' => 'subscription',
                ],
                'description' => "SDB Bank — {$plan->name_en} subscription for {$user->full_name}",
            ]);

            return response()->json([
                'client_secret' => $intent->client_secret,
                'payment_intent_id' => $intent->id,
                'amount' => $plan->price_monthly,
                'currency' => $plan->currency,
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'فشل إنشاء عملية الدفع: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Confirm subscription after payment
     */
    public function confirm(Request $request)
    {
        $request->validate([
            'payment_intent_id' => 'required|string',
            'plan_id' => 'required|string',
        ]);

        $user = $request->user();
        $plan = SubscriptionPlan::where('slug', $request->plan_id)->first();

        if (!$plan) {
            return response()->json(['message' => 'الخطة غير موجودة'], 404);
        }

        try {
            $stripe = new \Stripe\StripeClient(config('services.stripe.secret'));
            $intent = $stripe->paymentIntents->retrieve($request->payment_intent_id);

            if ($intent->status !== 'succeeded') {
                return response()->json(['message' => 'الدفعة لم تكتمل بعد'], 400);
            }

            // Verify the intent belongs to this user
            if (($intent->metadata->user_id ?? '') != $user->id) {
                return response()->json(['message' => 'عملية دفع غير صالحة'], 403);
            }

            return $this->activateSubscription($user, $plan, $request->payment_intent_id);
        } catch (\Exception $e) {
            return response()->json(['message' => 'فشل تأكيد الدفع: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Activate subscription and set user to active
     */
    private function activateSubscription($user, SubscriptionPlan $plan, ?string $paymentIntentId = null)
    {
        DB::beginTransaction();
        try {
            // Create subscription record
            $sub = Subscription::create([
                'user_id' => $user->id,
                'plan_id' => $plan->id,
                'status' => 'active',
                'billing_cycle' => 'monthly',
                'stripe_payment_intent_id' => $paymentIntentId,
                'starts_at' => now(),
                'ends_at' => $plan->isFree() ? null : now()->addMonth(),
            ]);

            // Activate user account
            $user->update(['status' => 'active']);

            // Create default wallet if user has none
            $hasAccounts = DB::table('accounts')->where('user_id', $user->id)->exists();
            if (!$hasAccounts) {
                DB::table('accounts')->insert([
                    'user_id' => $user->id,
                    'currency' => 'DKK',
                    'balance' => 0,
                    'status' => 'active',
                    'is_default' => true,
                    'account_number' => 'SDB-' . str_pad($user->id, 6, '0', STR_PAD_LEFT) . '-DKK',
                    'account_type' => $plan->slug === 'business' ? 'business' : 'personal',
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }

            // Send welcome notification
            Notification::create([
                'user_id' => $user->id,
                'title' => '🎉 مرحباً بك في SDB Bank!',
                'body' => "تم تفعيل اشتراكك في باقة {$plan->name_ar} بنجاح. يمكنك الآن استخدام جميع خدمات البنك.",
                'type' => 'system',
            ]);

            DB::commit();

            return response()->json([
                'message' => 'تم تفعيل الاشتراك بنجاح',
                'subscription' => $sub->load('plan'),
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'فشل تفعيل الاشتراك: ' . $e->getMessage()], 500);
        }
    }
}
