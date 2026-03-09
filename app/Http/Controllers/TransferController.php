<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class TransferController extends Controller
{
    /**
     * Look up recipient by account number, phone, or business code
     */
    public function lookup(Request $request)
    {
        $request->validate([
            'type' => 'required|in:account,phone,business',
            'value' => 'required|string',
        ]);

        $type = $request->type;
        $value = $request->value;
        $account = null;

        if ($type === 'account') {
            $account = Account::with('user', 'currency')
                ->where('account_number', $value)
                ->where('status', 'active')
                ->first();
        } elseif ($type === 'phone') {
            $user = User::where('phone', $value)->first();
            if ($user) {
                $account = $user->accounts()->where('is_default', true)->where('status', 'active')->first()
                    ?? $user->accounts()->where('status', 'active')->first();
                if ($account)
                    $account->load('user', 'currency');
            }
        } elseif ($type === 'business') {
            $account = Account::with('user', 'currency')
                ->where('business_code', $value)
                ->where('status', 'active')
                ->first();
        }

        if (!$account) {
            return response()->json(['found' => false, 'message' => 'الحساب غير موجود'], 404);
        }

        // Don't allow self-transfer lookup
        if ($account->user_id === Auth::id()) {
            return response()->json(['found' => false, 'message' => 'لا يمكنك التحويل لنفسك'], 400);
        }

        return response()->json([
            'found' => true,
            'recipient' => [
                'name' => $account->user->full_name,
                'account_number' => substr($account->account_number, 0, 4) . '****' . substr($account->account_number, -2),
                'currency' => $account->currency->code,
                'account_id' => $account->id,
            ],
        ]);
    }

    /**
     * QR code lookup — parse QR data and look up account
     */
    public function qrLookup(Request $request)
    {
        $request->validate(['qr_data' => 'required|string']);

        try {
            $data = json_decode($request->qr_data, true);
            if (!$data || !isset($data['acc'])) {
                return response()->json(['found' => false, 'message' => 'QR غير صالح'], 400);
            }

            $account = Account::with('user', 'currency')
                ->where('account_number', $data['acc'])
                ->where('status', 'active')
                ->first();

            if (!$account) {
                return response()->json(['found' => false, 'message' => 'الحساب غير موجود'], 404);
            }

            if ($account->user_id === Auth::id()) {
                return response()->json(['found' => false, 'message' => 'لا يمكنك التحويل لنفسك'], 400);
            }

            return response()->json([
                'found' => true,
                'recipient' => [
                    'name' => $account->user->full_name,
                    'account_number' => substr($account->account_number, 0, 4) . '****' . substr($account->account_number, -2),
                    'currency' => $account->currency->code,
                    'account_id' => $account->id,
                    'business_code' => $account->business_code,
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json(['found' => false, 'message' => 'خطأ في قراءة QR'], 400);
        }
    }

    /**
     * Execute a transfer between accounts
     */
    public function transfer(Request $request)
    {
        $request->validate([
            'from_account_id' => 'required|exists:accounts,id',
            'to_account_id' => 'required|exists:accounts,id',
            'amount' => 'required|numeric|min:0.01|max:100000',
            'note' => 'nullable|string|max:255',
        ]);

        $fromAccount = Account::findOrFail($request->from_account_id);
        $toAccount = Account::findOrFail($request->to_account_id);

        // Security checks
        if ($fromAccount->user_id !== Auth::id()) {
            return response()->json(['success' => false, 'message' => 'غير مصرّح'], 403);
        }

        if ($fromAccount->id === $toAccount->id) {
            return response()->json(['success' => false, 'message' => 'لا يمكن التحويل لنفس الحساب'], 400);
        }

        if (!$fromAccount->isActive() || !$toAccount->isActive()) {
            return response()->json(['success' => false, 'message' => 'أحد الحسابات غير نشط'], 400);
        }

        if ($fromAccount->available_balance < $request->amount) {
            return response()->json(['success' => false, 'message' => 'رصيد غير كافٍ'], 400);
        }

        // Different currency check
        if ($fromAccount->currency_id !== $toAccount->currency_id) {
            return response()->json(['success' => false, 'message' => 'لا يمكن التحويل بين عملات مختلفة. استخدم الصرف.'], 400);
        }

        try {
            DB::transaction(function () use ($fromAccount, $toAccount, $request) {
                $amount = $request->amount;

                // Debit sender
                $fromAccount->decrement('balance', $amount);
                $fromAccount->decrement('available_balance', $amount);

                // Credit receiver
                $toAccount->increment('balance', $amount);
                $toAccount->increment('available_balance', $amount);

                // Create transaction record
                Transaction::create([
                    'from_account_id' => $fromAccount->id,
                    'to_account_id' => $toAccount->id,
                    'currency_id' => $fromAccount->currency_id,
                    'type' => 'transfer',
                    'amount' => $amount,
                    'fee' => 0,
                    'status' => 'completed',
                    'description' => $request->note ?? 'تحويل داخلي',
                    'reference' => 'TRF-' . strtoupper(substr(md5(uniqid()), 0, 10)),
                ]);
            });

            return response()->json([
                'success' => true,
                'message' => 'تم التحويل بنجاح',
                'new_balance' => $fromAccount->fresh()->available_balance,
            ]);
        } catch (\Exception $e) {
            \Log::error('Transfer failed: ' . $e->getMessage());
            return response()->json(['success' => false, 'message' => 'فشل التحويل. حاول مجدداً.'], 500);
        }
    }

    /**
     * Get current user's accounts for transfer selection
     */
    public function myAccounts()
    {
        $accounts = Auth::user()->accounts()
            ->with('currency')
            ->where('status', 'active')
            ->get()
            ->map(function ($acc) {
                return [
                    'id' => $acc->id,
                    'account_number' => $acc->account_number,
                    'business_code' => $acc->business_code,
                    'currency' => $acc->currency->code,
                    'symbol' => $acc->currency->symbol,
                    'balance' => $acc->available_balance,
                    'name' => $acc->account_name ?? ($acc->currency->code . ' Account'),
                    'qr_data' => $acc->qr_data,
                    'type' => $acc->account_type ?? 'personal',
                ];
            });

        return response()->json($accounts);
    }
}
