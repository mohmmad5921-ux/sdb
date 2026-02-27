<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Account;
use App\Models\Card;
use App\Models\Notification;
use App\Models\Transaction;
use App\Models\Currency;
use App\Models\KycDocument;
use App\Services\AccountService;
use App\Services\CardService;
use App\Services\CurrencyService;
use App\Services\DepositService;
use App\Services\TransactionService;
use Illuminate\Http\Request;

class MobileApiController extends Controller
{
    public function __construct(
        private AccountService $accountService,
        private TransactionService $transactionService,
        private CardService $cardService,
        private CurrencyService $currencyService,
        private DepositService $depositService,
    ) {}

    /* ==================== AUTH ==================== */

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
            'device_name' => 'required|string',
        ]);

        $user = \App\Models\User::where('email', $request->email)->first();

        if (!$user || !\Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        if (!$user->isActive()) {
            return response()->json(['message' => 'Account is suspended'], 403);
        }

        $user->update(['last_login_at' => now(), 'last_login_ip' => $request->ip()]);

        $token = $user->createToken($request->device_name)->plainTextToken;

        return response()->json([
            'token' => $token,
            'user' => $this->formatUser($user),
        ]);
    }

    public function register(Request $request)
    {
        $request->validate([
            'full_name' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
            'phone' => 'nullable|string|max:20',
            'password' => 'required|min:8|confirmed',
            'device_name' => 'required|string',
        ]);

        $user = \App\Models\User::create([
            'full_name' => $request->full_name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => $request->password,
            'status' => 'active',
            'kyc_status' => 'pending',
            'role' => 'customer',
        ]);

        // Create default EUR + USD accounts
        $eur = Currency::where('code', 'EUR')->first();
        $usd = Currency::where('code', 'USD')->first();
        if ($eur) $this->accountService->createAccount($user, $eur, true);
        if ($usd) $this->accountService->createAccount($user, $usd);

        $token = $user->createToken($request->device_name)->plainTextToken;

        return response()->json([
            'token' => $token,
            'user' => $this->formatUser($user),
        ], 201);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out']);
    }

    /* ==================== PROFILE ==================== */

    public function profile(Request $request)
    {
        return response()->json(['user' => $this->formatUser($request->user())]);
    }

    public function updateProfile(Request $request)
    {
        $request->validate([
            'full_name' => 'sometimes|string|max:255',
            'phone' => 'sometimes|string|max:20',
            'nationality' => 'sometimes|string|max:100',
            'date_of_birth' => 'sometimes|date',
            'address' => 'sometimes|string|max:500',
            'city' => 'sometimes|string|max:100',
            'country' => 'sometimes|string|max:100',
            'preferred_language' => 'sometimes|in:ar,en',
        ]);

        $request->user()->update($request->only([
            'full_name', 'phone', 'nationality', 'date_of_birth',
            'address', 'city', 'country', 'preferred_language',
        ]));

        return response()->json(['user' => $this->formatUser($request->user()->fresh())]);
    }

    /* ==================== KYC ==================== */

    public function kycStatus(Request $request)
    {
        $user = $request->user();
        $docs = KycDocument::where('user_id', $user->id)->get();

        return response()->json([
            'kyc_status' => $user->kyc_status,
            'documents' => $docs->map(fn($d) => [
                'id' => $d->id,
                'type' => $d->document_type,
                'status' => $d->status,
                'rejection_reason' => $d->rejection_reason,
                'uploaded_at' => $d->created_at->toDateTimeString(),
                'reviewed_at' => $d->reviewed_at?->toDateTimeString(),
            ]),
        ]);
    }

    public function uploadKyc(Request $request)
    {
        $request->validate([
            'id_front' => 'required|image|max:10240',
            'id_back' => 'required|image|max:10240',
            'selfie' => 'required|image|max:10240',
            'address_proof' => 'nullable|file|max:10240',
        ]);

        $user = $request->user();

        // Delete old pending/rejected documents
        KycDocument::where('user_id', $user->id)
            ->whereIn('status', ['pending', 'rejected'])
            ->delete();

        $uploads = [
            'id_front' => 'id_card',
            'id_back' => 'id_card',
            'selfie' => 'selfie',
            'address_proof' => 'address_proof',
        ];

        $created = [];
        foreach ($uploads as $field => $docType) {
            if ($request->hasFile($field)) {
                $file = $request->file($field);
                $path = $file->store("kyc/{$user->id}", 'local');
                $created[] = KycDocument::create([
                    'user_id' => $user->id,
                    'document_type' => $docType,
                    'file_path' => $path,
                    'original_filename' => $field . '_' . $file->getClientOriginalName(),
                    'status' => 'pending',
                ]);
            }
        }

        // Update user KYC status to submitted
        $user->update(['kyc_status' => 'submitted']);

        return response()->json([
            'message' => 'Documents uploaded successfully. Pending admin review.',
            'kyc_status' => 'submitted',
            'documents_count' => count($created),
        ]);
    }

    /* ==================== DASHBOARD ==================== */

    public function dashboard(Request $request)
    {
        $user = $request->user();
        $accounts = $user->accounts()->with('currency')->get();
        $cards = $user->cards()->with('account.currency')->get();

        $accountIds = $accounts->pluck('id');
        $recentTransactions = Transaction::where(function ($q) use ($accountIds) {
            $q->whereIn('from_account_id', $accountIds)
              ->orWhereIn('to_account_id', $accountIds);
        })
            ->with(['currency', 'fromAccount.currency', 'toAccount.currency'])
            ->orderByDesc('created_at')
            ->limit(10)
            ->get();

        $totalBalanceEur = $accounts->sum(function ($a) {
            return $a->balance * ($a->currency->exchange_rate_to_eur ?: 1);
        });

        $unreadNotifications = $user->notifications()->where('is_read', false)->count();

        return response()->json([
            'user' => $this->formatUser($user),
            'accounts' => $accounts,
            'cards' => $cards->map(fn($c) => [
                'id' => $c->id,
                'card_number_masked' => $c->card_number_masked,
                'card_holder_name' => $c->card_holder_name,
                'expiry_date' => $c->expiry_date,
                'status' => $c->status,
                'daily_limit' => $c->daily_limit,
                'account' => $c->account,
            ]),
            'recentTransactions' => $recentTransactions,
            'totalBalanceEur' => round($totalBalanceEur, 2),
            'unreadNotifications' => $unreadNotifications,
            'kycStatus' => $user->kyc_status,
        ]);
    }

    /* ==================== ACCOUNTS ==================== */

    public function accounts(Request $request)
    {
        return response()->json([
            'accounts' => $request->user()->accounts()->with('currency')->get(),
        ]);
    }

    /* ==================== TRANSACTIONS ==================== */

    public function transactions(Request $request)
    {
        $accounts = $request->user()->accounts()->pluck('id');

        $transactions = Transaction::where(function ($q) use ($accounts) {
            $q->whereIn('from_account_id', $accounts)
              ->orWhereIn('to_account_id', $accounts);
        })
            ->with(['currency', 'fromAccount.currency', 'toAccount.currency'])
            ->orderByDesc('created_at')
            ->paginate(20);

        return response()->json($transactions);
    }

    public function transfer(Request $request)
    {
        // Gate behind KYC
        if ($request->user()->kyc_status !== 'verified') {
            return response()->json(['message' => 'يجب التحقق من الهوية قبل إجراء التحويلات', 'kyc_required' => true], 403);
        }

        $request->validate([
            'from_account_id' => 'required|exists:accounts,id',
            'to_iban' => 'required|string',
            'amount' => 'required|numeric|min:0.01',
            'description' => 'nullable|string|max:255',
        ]);

        $fromAccount = Account::where('id', $request->from_account_id)
            ->where('user_id', $request->user()->id)->firstOrFail();

        $toAccount = Account::where('iban', str_replace(' ', '', $request->to_iban))->first();
        if (!$toAccount) {
            return response()->json(['message' => 'Recipient not found'], 404);
        }

        try {
            $transaction = $this->transactionService->transfer(
                $fromAccount, $toAccount, $request->amount, $request->description ?? ''
            );
            return response()->json(['transaction' => $transaction, 'message' => 'Transfer completed']);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    public function exchange(Request $request)
    {
        $request->validate([
            'from_account_id' => 'required|exists:accounts,id',
            'to_account_id' => 'required|exists:accounts,id',
            'amount' => 'required|numeric|min:0.01',
            'rate' => 'nullable|numeric|min:0.0001',
        ]);

        $from = Account::where('id', $request->from_account_id)
            ->where('user_id', $request->user()->id)->firstOrFail();
        $to = Account::where('id', $request->to_account_id)
            ->where('user_id', $request->user()->id)->firstOrFail();

        try {
            // Use client-provided live rate if available, otherwise fallback to server rate
            $rate = $request->rate
                ? (float) $request->rate
                : $this->currencyService->getRate($from->currency_id, $to->currency_id);

            $transaction = $this->transactionService->exchange($from, $to, $request->amount, $rate);
            return response()->json([
                'transaction' => $transaction,
                'rate' => $rate,
                'converted_amount' => round($request->amount * $rate, 2),
                'message' => 'Exchange completed',
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    /* ==================== DEPOSIT ==================== */

    public function deposit(Request $request)
    {
        // Gate behind KYC
        if ($request->user()->kyc_status !== 'verified') {
            return response()->json(['message' => 'يجب التحقق من الهوية قبل الإيداع', 'kyc_required' => true], 403);
        }

        $request->validate([
            'account_id' => 'required|exists:accounts,id',
            'amount' => 'required|numeric|min:1|max:50000',
            'payment_method' => 'required|in:card,apple_pay,google_pay',
            'card_number' => 'required_if:payment_method,card|nullable|string',
            'card_holder' => 'required|string|max:255',
            'card_expiry' => 'required|string|max:5',
            'card_cvv' => 'required_if:payment_method,card|nullable|string|max:4',
        ]);

        $account = Account::where('id', $request->account_id)
            ->where('user_id', $request->user()->id)->firstOrFail();

        try {
            $cardNumber = $request->card_number;
            if ($request->payment_method === 'apple_pay') {
                $cardNumber = '4' . str_pad(mt_rand(0, 999999999999999), 15, '0', STR_PAD_LEFT);
            } elseif ($request->payment_method === 'google_pay') {
                $cardNumber = '5' . str_pad(mt_rand(0, 99999999999999), 14, '0', STR_PAD_LEFT) . '1';
            }

            $deposit = $this->depositService->depositViaCard(
                $account, (float) $request->amount, $cardNumber,
                $request->card_holder, $request->card_expiry,
                $request->card_cvv ?? '000', $request->ip(),
            );

            return response()->json(['deposit' => $deposit, 'message' => 'Deposit completed']);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    /* ==================== CARDS ==================== */

    public function cards(Request $request)
    {
        return response()->json([
            'cards' => $request->user()->cards()->with('account.currency')->get(),
        ]);
    }

    public function issueCard(Request $request)
    {
        // Gate behind KYC
        if ($request->user()->kyc_status !== 'verified') {
            return response()->json(['message' => 'يجب التحقق من الهوية قبل إصدار بطاقة', 'kyc_required' => true], 403);
        }

        $request->validate(['account_id' => 'nullable|exists:accounts,id']);

        $user = $request->user();

        if ($request->account_id) {
            $account = Account::where('id', $request->account_id)
                ->where('user_id', $user->id)->firstOrFail();
        } else {
            // Auto-create default EUR account if user has none
            $account = $user->accounts()->first();
            if (!$account) {
                $eur = Currency::where('code', 'EUR')->first();
                $account = Account::create([
                    'user_id' => $user->id,
                    'currency_id' => $eur ? $eur->id : 1,
                    'account_number' => 'SDB' . strtoupper(bin2hex(random_bytes(6))),
                    'balance' => 0,
                    'status' => 'active',
                ]);
            }
        }

        try {
            $card = $this->cardService->issueCard($user, $account);
            return response()->json(['card' => $card->load('account.currency'), 'message' => 'Card issued']);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }
    }

    public function toggleCardFreeze(Request $request, $cardId)
    {
        $card = $request->user()->cards()->findOrFail($cardId);

        if ($card->isActive()) {
            $this->cardService->freeze($card);
            return response()->json(['message' => 'Card frozen', 'status' => 'frozen']);
        } else {
            $this->cardService->unfreeze($card);
            return response()->json(['message' => 'Card activated', 'status' => 'active']);
        }
    }

    /* ==================== NOTIFICATIONS ==================== */

    public function notifications(Request $request)
    {
        return response()->json(
            $request->user()->notifications()->orderByDesc('created_at')->paginate(20)
        );
    }

    public function markNotificationRead(Request $request, $id)
    {
        $request->user()->notifications()->findOrFail($id)->update([
            'is_read' => true, 'read_at' => now(),
        ]);
        return response()->json(['message' => 'Marked as read']);
    }

    /* ==================== CURRENCIES ==================== */

    public function currencies()
    {
        return response()->json([
            'currencies' => Currency::active()->get(),
            'exchangeRates' => \App\Models\ExchangeRate::with(['fromCurrency', 'toCurrency'])->where('is_active', true)->get(),
        ]);
    }

    /* ==================== HELPERS ==================== */

    private function formatUser($user): array
    {
        return [
            'id' => $user->id,
            'full_name' => $user->full_name,
            'email' => $user->email,
            'phone' => $user->phone,
            'status' => $user->status,
            'kyc_status' => $user->kyc_status,
            'nationality' => $user->nationality,
            'date_of_birth' => $user->date_of_birth?->toDateString(),
            'address' => $user->address,
            'city' => $user->city,
            'country' => $user->country,
            'preferred_language' => $user->preferred_language,
            'role' => $user->role,
        ];
    }
}