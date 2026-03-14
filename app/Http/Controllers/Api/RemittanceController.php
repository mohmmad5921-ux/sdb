<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Agent;
use App\Models\Governorate;
use App\Models\Remittance;
use App\Services\AccountService;
use App\Services\IbanService;
use Illuminate\Http\Request;

class RemittanceController extends Controller
{
    /**
     * List all governorates with districts and agents
     */
    public function governorates()
    {
        $governorates = Governorate::active()
            ->with(['districts' => function ($q) {
                $q->active()->with(['agents' => fn($a) => $a->active()]);
            }])
            ->get();

        return response()->json(['governorates' => $governorates]);
    }

    /**
     * Send a remittance (create transfer + deduct balance)
     */
    public function send(Request $request)
    {
        $request->validate([
            'agent_id' => 'required|exists:agents,id',
            'account_id' => 'required|exists:accounts,id',
            'recipient_name' => 'required|string|max:255',
            'recipient_phone' => 'required|string|max:20',
            'amount' => 'required|numeric|min:1',
            'notes' => 'nullable|string|max:500',
        ]);

        $user = $request->user();

        // Verify the account belongs to the user
        $account = $user->accounts()->where('id', $request->account_id)->first();
        if (!$account) {
            return response()->json(['message' => 'الحساب غير موجود'], 403);
        }

        // Check balance
        if ($account->balance < $request->amount) {
            return response()->json(['message' => 'رصيد غير كافٍ'], 422);
        }

        $agent = Agent::with('district.governorate')->find($request->agent_id);
        if (!$agent || !$agent->is_active) {
            return response()->json(['message' => 'الوكيل غير متاح'], 422);
        }

        // Calculate fee (1.5% commission)
        $fee = round($request->amount * 0.02, 2);
        $totalDeduct = $request->amount + $fee;

        if ($account->balance < $totalDeduct) {
            return response()->json(['message' => 'رصيد غير كافٍ (المبلغ + العمولة)'], 422);
        }

        // Exchange rate EUR → SYP (use live rate from cache or fallback)
        $rates = \Illuminate\Support\Facades\Cache::get('live_rates');
        $sypRate = $rates['SYP'] ?? 13500;
        $sendCurrency = $account->currency->code ?? 'EUR';
        $receiveAmount = round($request->amount * $sypRate, 0);

        // Deduct balance
        $accountService = new AccountService(new IbanService());
        if (!$accountService->debit($account, $totalDeduct)) {
            return response()->json(['message' => 'فشل خصم الرصيد'], 500);
        }

        // Create remittance
        $remittance = Remittance::create([
            'user_id' => $user->id,
            'agent_id' => $request->agent_id,
            'recipient_name' => $request->recipient_name,
            'recipient_phone' => $request->recipient_phone,
            'amount' => $request->amount,
            'send_currency' => $sendCurrency,
            'receive_amount' => $receiveAmount,
            'receive_currency' => 'SYP',
            'exchange_rate' => $sypRate,
            'fee' => $fee,
            'status' => 'ready',
            'notification_code' => Remittance::generateCode(),
            'qr_token' => Remittance::generateQrToken(),
            'notes' => $request->notes,
            'expires_at' => now()->addHours(72),
        ]);

        // Create transaction record
        try {
            \App\Models\Transaction::create([
                'reference_number' => \App\Models\Transaction::generateReference(),
                'from_account_id' => $account->id,
                'currency_id' => $account->currency_id,
                'amount' => $request->amount,
                'fee' => $fee,
                'type' => 'transfer',
                'status' => 'completed',
                'description' => "حوالة سوريا — {$request->recipient_name} — {$agent->district->governorate->name_ar}",
                'completed_at' => now(),
            ]);
        } catch (\Exception $e) {
            \Log::error('Remittance transaction record failed: ' . $e->getMessage());
        }

        // Create in-app notification
        \App\Models\Notification::create([
            'user_id' => $user->id,
            'title' => '💸 تم إرسال الحوالة',
            'body' => "تم إرسال {$request->amount} {$sendCurrency} إلى {$request->recipient_name}. رقم الإشعار: {$remittance->notification_code}",
            'type' => 'transaction',
            'data' => json_encode(['remittance_id' => $remittance->id]),
        ]);

        // Send push notification
        try {
            \App\Services\FcmService::sendToUser($user->id,
                '💸 تم إرسال الحوالة',
                "تم إرسال {$request->amount} {$sendCurrency} إلى {$request->recipient_name}",
                ['type' => 'remittance', 'remittance_id' => (string) $remittance->id]
            );
        } catch (\Exception $e) {
            \Log::error('Remittance push failed: ' . $e->getMessage());
        }

        // Send email notification
        try {
            $govName = $agent->district->governorate->name_ar ?? '';
            $distName = $agent->district->name_ar ?? '';
            \Illuminate\Support\Facades\Mail::html("
                <div dir='rtl' style='font-family:Arial,sans-serif;max-width:600px;margin:auto;background:#f8fafc;padding:24px;border-radius:16px;'>
                    <div style='text-align:center;margin-bottom:20px;'>
                        <h1 style='color:#10b981;font-size:24px;'>💸 تم إرسال الحوالة بنجاح</h1>
                        <p style='color:#64748b;'>SDB Bank — Syria Digital Bank</p>
                    </div>
                    <div style='background:white;padding:20px;border-radius:12px;border:1px solid #e2e8f0;'>
                        <h3 style='color:#0f172a;border-bottom:1px solid #e2e8f0;padding-bottom:10px;'>تفاصيل الحوالة</h3>
                        <table style='width:100%;font-size:14px;color:#334155;'>
                            <tr><td style='padding:6px 0;color:#94a3b8;'>رقم الإشعار:</td><td style='text-align:left;font-weight:bold;color:#3b82f6;font-size:18px;letter-spacing:2px;'>{$remittance->notification_code}</td></tr>
                            <tr><td style='padding:6px 0;color:#94a3b8;'>المستلم:</td><td style='text-align:left;'>{$request->recipient_name}</td></tr>
                            <tr><td style='padding:6px 0;color:#94a3b8;'>هاتف المستلم:</td><td style='text-align:left;'>{$request->recipient_phone}</td></tr>
                            <tr><td style='padding:6px 0;color:#94a3b8;'>الموقع:</td><td style='text-align:left;'>{$govName} - {$distName}</td></tr>
                            <tr><td style='padding:6px 0;color:#94a3b8;'>مكتب الوكيل:</td><td style='text-align:left;'>{$agent->name_ar}</td></tr>
                            <tr><td colspan='2' style='border-top:1px solid #e2e8f0;padding:4px;'></td></tr>
                            <tr><td style='padding:6px 0;color:#94a3b8;'>المبلغ المرسل:</td><td style='text-align:left;'>{$request->amount} {$sendCurrency}</td></tr>
                            <tr><td style='padding:6px 0;color:#94a3b8;'>العمولة:</td><td style='text-align:left;'>{$fee} {$sendCurrency}</td></tr>
                            <tr><td style='padding:6px 0;color:#94a3b8;'>المستلم يحصل على:</td><td style='text-align:left;font-weight:bold;color:#10b981;font-size:16px;'>{$receiveAmount} SYP</td></tr>
                        </table>
                    </div>
                    <div style='text-align:center;margin-top:16px;padding:12px;background:#fef3c7;border-radius:8px;border:1px solid #fbbf24;'>
                        <p style='color:#92400e;font-size:13px;margin:0;'>⏱️ صلاحية الحوالة: 72 ساعة</p>
                    </div>
                    <p style='text-align:center;color:#94a3b8;font-size:12px;margin-top:16px;'>SDB Bank — أول بنك إلكتروني سوري 🇸🇾</p>
                </div>
            ", function ($msg) use ($user) {
                $msg->to($user->email)->subject('💸 SDB Bank — إيصال حوالة');
            });
        } catch (\Exception $e) {
            \Log::error('Remittance email failed: ' . $e->getMessage());
        }

        // Send WhatsApp message to recipient
        try {
            $govName = $agent->district->governorate->name_ar ?? '';
            $distName = $agent->district->name_ar ?? '';
            $waMessage = "🏦 *SDB Bank — إشعار حوالة*\n\n"
                . "مرحباً *{$request->recipient_name}*!\n"
                . "تم إرسال حوالة لك عبر بنك SDB 💰\n\n"
                . "📍 *الموقع:* {$govName} - {$distName}\n"
                . "🏬 *مكتب الوكيل:* {$agent->name_ar}\n"
                . "💵 *المبلغ:* {$receiveAmount} SYP\n\n"
                . "🔐 *رقم الإشعار:* {$remittance->notification_code}\n\n"
                . "✅ توجه لمكتب الوكيل وأعرض رقم الإشعار لسحب المبلغ\n"
                . "⏱️ صلاحية الحوالة: 72 ساعة\n\n"
                . "_SDB Bank — أول بنك إلكتروني سوري_ 🇸🇾";

            \App\Services\SmsService::sendWhatsApp($request->recipient_phone, $waMessage);
        } catch (\Exception $e) {
            \Log::error('Remittance WhatsApp failed: ' . $e->getMessage());
        }

        return response()->json([
            'success' => true,
            'remittance' => $remittance->load('agent.district.governorate'),
            'message' => 'تم إرسال الحوالة بنجاح',
        ]);
    }

    /**
     * Get user's remittance history
     */
    public function history(Request $request)
    {
        $remittances = Remittance::where('user_id', $request->user()->id)
            ->with('agent.district.governorate')
            ->orderByDesc('created_at')
            ->paginate(20);

        return response()->json($remittances);
    }

    /**
     * Get receipt details for a specific remittance
     */
    public function receipt(Request $request, Remittance $remittance)
    {
        if ($remittance->user_id !== $request->user()->id) {
            return response()->json(['message' => 'غير مصرح'], 403);
        }

        return response()->json([
            'remittance' => $remittance->load('agent.district.governorate'),
        ]);
    }

    /**
     * Verify a remittance by notification code or QR token (for agents)
     */
    public function verify(Request $request)
    {
        $request->validate([
            'code' => 'nullable|string',
            'qr_token' => 'nullable|string',
        ]);

        $remittance = null;
        if ($request->code) {
            $remittance = Remittance::where('notification_code', $request->code)->first();
        } elseif ($request->qr_token) {
            $remittance = Remittance::where('qr_token', $request->qr_token)->first();
        }

        if (!$remittance) {
            return response()->json(['valid' => false, 'message' => 'رقم الإشعار غير صحيح'], 404);
        }

        if ($remittance->status === 'collected') {
            return response()->json(['valid' => false, 'message' => 'تم سحب هذه الحوالة مسبقاً', 'status' => 'collected'], 410);
        }

        if ($remittance->isExpired()) {
            return response()->json(['valid' => false, 'message' => 'انتهت صلاحية الحوالة', 'status' => 'expired'], 410);
        }

        if ($remittance->status === 'cancelled') {
            return response()->json(['valid' => false, 'message' => 'تم إلغاء الحوالة', 'status' => 'cancelled'], 410);
        }

        return response()->json([
            'valid' => true,
            'remittance' => [
                'id' => $remittance->id,
                'notification_code' => $remittance->notification_code,
                'recipient_name' => $remittance->recipient_name,
                'recipient_phone' => $remittance->recipient_phone,
                'receive_amount' => $remittance->receive_amount,
                'receive_currency' => $remittance->receive_currency,
                'send_amount' => $remittance->amount,
                'send_currency' => $remittance->send_currency,
                'status' => $remittance->status,
                'created_at' => $remittance->created_at->toIso8601String(),
                'expires_at' => $remittance->expires_at?->toIso8601String(),
            ],
        ]);
    }

    /**
     * Mark remittance as collected (agent action)
     */
    public function collect(Request $request)
    {
        $request->validate([
            'code' => 'nullable|string',
            'qr_token' => 'nullable|string',
        ]);

        $remittance = null;
        if ($request->code) {
            $remittance = Remittance::where('notification_code', $request->code)->first();
        } elseif ($request->qr_token) {
            $remittance = Remittance::where('qr_token', $request->qr_token)->first();
        }

        if (!$remittance) {
            return response()->json(['success' => false, 'message' => 'الحوالة غير موجودة'], 404);
        }

        if (!$remittance->isCollectable()) {
            return response()->json(['success' => false, 'message' => 'لا يمكن سحب هذه الحوالة'], 422);
        }

        $remittance->update([
            'status' => 'collected',
            'collected_at' => now(),
        ]);

        // Notify sender
        try {
            \App\Services\FcmService::sendToUser($remittance->user_id,
                '✅ تم سحب الحوالة',
                "{$remittance->recipient_name} قام بسحب الحوالة بقيمة {$remittance->receive_amount} {$remittance->receive_currency}",
                ['type' => 'remittance_collected', 'remittance_id' => (string) $remittance->id]
            );

            \App\Models\Notification::create([
                'user_id' => $remittance->user_id,
                'title' => '✅ تم سحب الحوالة',
                'body' => "{$remittance->recipient_name} قام بسحب الحوالة بقيمة {$remittance->receive_amount} {$remittance->receive_currency}",
                'type' => 'transaction',
                'data' => json_encode(['remittance_id' => $remittance->id]),
            ]);
        } catch (\Exception $e) {
            \Log::error('Collect notification failed: ' . $e->getMessage());
        }

        return response()->json([
            'success' => true,
            'message' => 'تم تسجيل السحب بنجاح',
        ]);
    }
}
