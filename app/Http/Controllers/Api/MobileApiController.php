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
            'username' => 'required|string|min:3|max:30|unique:users|regex:/^[a-zA-Z0-9._]+$/',
            'email' => 'required|email|unique:users',
            'phone' => 'nullable|string|max:20',
            'password' => 'required|min:8|confirmed',
            'device_name' => 'required|string',
        ]);

        $user = \App\Models\User::create([
            'full_name' => $request->full_name,
            'username' => strtolower($request->username),
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => $request->password,
            'status' => 'active',
            'kyc_status' => 'pending',
            'role' => 'customer',
        ]);

        // Country-to-currency mapping
        $countryToCurrency = [
            'DK' => 'DKK', 'SE' => 'SEK', 'GB' => 'GBP', 'US' => 'USD',
            'TR' => 'TRY', 'SY' => 'SYP', 'DE' => 'EUR', 'FR' => 'EUR',
            'NL' => 'EUR', 'IT' => 'EUR', 'ES' => 'EUR', 'AT' => 'EUR',
            'BE' => 'EUR', 'FI' => 'EUR', 'IE' => 'EUR', 'PT' => 'EUR',
            'GR' => 'EUR', 'LU' => 'EUR',
        ];

        // Detect country from phone prefix or nationality
        $countryCode = $this->detectCountry($request->phone, $request->nationality ?? null);
        $defaultCurrencyCode = $countryToCurrency[$countryCode] ?? 'EUR';

        // 1. Create default account in user's country currency
        $defaultCurrency = Currency::where('code', $defaultCurrencyCode)->first() 
                         ?? Currency::where('code', 'EUR')->first();
        if ($defaultCurrency) {
            $this->accountService->createAccount($user, $defaultCurrency, true);
        }

        // 2. Always create SYP account (unless already the default)
        if ($defaultCurrencyCode !== 'SYP') {
            $syp = Currency::where('code', 'SYP')->first();
            if ($syp) $this->accountService->createAccount($user, $syp);
        }

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
            'username' => 'sometimes|string|min:3|max:30|regex:/^[a-zA-Z0-9._]+$/|unique:users,username,'.$request->user()->id,
            'phone' => 'sometimes|string|max:20',
            'nationality' => 'sometimes|string|max:100',
            'date_of_birth' => 'sometimes|date',
            'address' => 'sometimes|string|max:500',
            'city' => 'sometimes|string|max:100',
            'country' => 'sometimes|string|max:100',
            'preferred_language' => 'sometimes|in:ar,en',
        ]);

        $data = $request->only([
            'full_name', 'phone', 'nationality', 'date_of_birth',
            'address', 'city', 'country', 'preferred_language',
        ]);
        if ($request->has('username')) $data['username'] = strtolower($request->username);
        $request->user()->update($data);

        return response()->json(['user' => $this->formatUser($request->user()->fresh())]);
    }

    /* ==================== KYC ==================== */

    public function kycStatus(Request $request)
    {
        $user = $request->user();
        $docs = KycDocument::where('user_id', $user->id)->get();

        return response()->json([
            'kyc_status' => $user->kyc_status,
            'full_name' => $user->full_name,
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
            'cards' => $request->user()->cards()
                ->whereNotIn('status', ['cancelled', 'deleted'])
                ->with('account.currency')->get(),
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
        try {
            $card = $request->user()->cards()->findOrFail($cardId);
            if ($card->isActive()) {
                $this->cardService->freeze($card);
                return response()->json(['message' => 'Card frozen', 'status' => 'frozen']);
            } else {
                $this->cardService->unfreeze($card);
                return response()->json(['message' => 'Card activated', 'status' => 'active']);
            }
        } catch (\Exception $e) {
            \Log::error('toggleCardFreeze error: ' . $e->getMessage());
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }

    public function deleteCard(Request $request, $cardId)
    {
        try {
            $card = $request->user()->cards()->findOrFail($cardId);
            // Try Stripe cancel but don't block on failure
            try { $this->cardService->cancel($card); } catch (\Exception $e) {}
            // Force delete from database
            $card->forceDelete();
            return response()->json(['message' => 'تم حذف البطاقة بنجاح', 'success' => true]);
        } catch (\Exception $e) {
            \Log::error('deleteCard error: ' . $e->getMessage());
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }

    public function updateCardSettings(Request $request, $cardId)
    {
        try {
            $card = $request->user()->cards()->findOrFail($cardId);
            $card->update($request->only(['online_payment_enabled', 'contactless_enabled']));
            return response()->json(['message' => 'تم تحديث الإعدادات', 'card' => $card->fresh()]);
        } catch (\Exception $e) {
            \Log::error('updateCardSettings error: ' . $e->getMessage());
            return response()->json(['message' => $e->getMessage()], 500);
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

    public function updateFcmToken(Request $request)
    {
        $request->validate(['fcm_token' => 'required|string']);

        $updateData = [
            'fcm_token' => $request->fcm_token,
        ];

        if ($request->has('device_platform')) {
            $updateData['device_platform'] = $request->device_platform;
        }

        if ($request->has('apns_token')) {
            $updateData['apns_token'] = $request->apns_token;
        }

        $request->user()->update($updateData);
        return response()->json(['message' => 'FCM token updated']);
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

    public function checkUsername(Request $request)
    {
        $request->validate(['username' => 'required|string|min:3|max:30|regex:/^[a-zA-Z0-9._]+$/']);
        $taken = \App\Models\User::where('username', strtolower($request->username))->exists();
        return response()->json(['available' => !$taken, 'username' => strtolower($request->username)]);
    }

    public function findByUsername($username)
    {
        $user = \App\Models\User::where('username', strtolower($username))->first();
        if (!$user) return response()->json(['message' => 'User not found'], 404);
        return response()->json([
            'id' => $user->id,
            'full_name' => $user->full_name,
            'username' => $user->username,
            'profile_photo' => $user->profile_photo,
        ]);
    }


    /* ==================== WALLETS ==================== */

    public function openWallet(Request $request)
    {
        $request->validate(['currency_code' => 'required|string|max:5']);
        $user = $request->user();
        $currency = Currency::where('code', strtoupper($request->currency_code))
                           ->where('is_active', true)->where('type', 'fiat')->first();

        if (!$currency) return response()->json(['message' => 'Currency not available'], 404);

        $existing = Account::where('user_id', $user->id)->where('currency_id', $currency->id)->first();
        if ($existing) return response()->json(['message' => 'You already have a ' . $currency->code . ' wallet'], 409);

        $account = $this->accountService->createAccount($user, $currency);
        return response()->json([
            'message' => $currency->code . ' wallet created',
            'account' => [
                'id' => $account->id, 'account_number' => $account->account_number,
                'iban' => $account->iban, 'balance' => '0.00',
                'currency' => ['code' => $currency->code, 'name' => $currency->name,
                    'name_ar' => $currency->name_ar, 'symbol' => $currency->symbol, 'flag_icon' => $currency->flag_icon],
            ],
        ], 201);
    }

    public function availableWallets(Request $request)
    {
        $existingIds = Account::where('user_id', $request->user()->id)->pluck('currency_id')->toArray();
        $available = Currency::where('is_active', true)->where('type', 'fiat')
            ->whereNotIn('id', $existingIds)->orderBy('sort_order')->get()
            ->map(fn($c) => ['code' => $c->code, 'name' => $c->name, 'name_ar' => $c->name_ar,
                'symbol' => $c->symbol, 'flag_icon' => $c->flag_icon]);
        return response()->json(['currencies' => $available]);
    }

    private function formatUser($user): array
    {
        return [
            'id' => $user->id, 'full_name' => $user->full_name,
            'username' => $user->username, 'email' => $user->email,
            'phone' => $user->phone, 'status' => $user->status,
            'kyc_status' => $user->kyc_status, 'nationality' => $user->nationality,
            'date_of_birth' => $user->date_of_birth?->toDateString(),
            'address' => $user->address, 'city' => $user->city,
            'country' => $user->country, 'preferred_language' => $user->preferred_language,
            'role' => $user->role,
        ];
    }

    private function detectCountry(?string $phone, ?string $nationality): string
    {
        $phonePrefixes = [
            '+45' => 'DK', '+46' => 'SE', '+44' => 'GB', '+1' => 'US',
            '+90' => 'TR', '+963' => 'SY', '+49' => 'DE', '+33' => 'FR',
            '+31' => 'NL', '+39' => 'IT', '+34' => 'ES', '+43' => 'AT',
            '+32' => 'BE', '+358' => 'FI', '+353' => 'IE', '+351' => 'PT',
            '+30' => 'GR', '+352' => 'LU', '+47' => 'NO', '+48' => 'PL',
            '+961' => 'LB', '+962' => 'JO', '+964' => 'IQ', '+20' => 'EG',
        ];

        if ($phone) {
            $phone = preg_replace('/\s+/', '', $phone);
            foreach (collect($phonePrefixes)->sortByDesc(fn($v, $k) => strlen($k)) as $prefix => $country) {
                if (str_starts_with($phone, $prefix)) return $country;
            }
        }

        $nationalityMap = [
            'Syrian' => 'SY', 'سوري' => 'SY', 'Danish' => 'DK', 'دنماركي' => 'DK',
            'Swedish' => 'SE', 'Turkish' => 'TR', 'British' => 'GB', 'American' => 'US',
        ];
        if ($nationality) {
            foreach ($nationalityMap as $nat => $country) {
                if (stripos($nationality, $nat) !== false) return $country;
            }
        }
        return 'EU';
    }

    /* ==================== AI CHAT ==================== */

    public function aiChat(Request $request)
    {
        $request->validate(['message' => 'required|string|max:2000']);
        $user = $request->user();

        // Build user context (only their own data)
        $accounts = $user->accounts()->with('currency')->get();
        $recentTx = Transaction::where(function ($q) use ($accounts) {
            $ids = $accounts->pluck('id');
            $q->whereIn('from_account_id', $ids)->orWhereIn('to_account_id', $ids);
        })->latest()->take(10)->get();

        $cards = Card::where('user_id', $user->id)->get();

        $context = [
            'user_name' => $user->full_name ?? ($user->first_name . ' ' . $user->last_name),
            'kyc_status' => $user->kyc_status ?? 'pending',
            'accounts' => $accounts->map(fn($a) => [
                'currency' => $a->currency->code ?? '',
                'balance' => $a->balance,
                'iban' => $a->iban,
            ])->toArray(),
            'recent_transactions' => $recentTx->map(fn($tx) => [
                'type' => $tx->type,
                'amount' => $tx->amount,
                'currency' => $tx->currency->code ?? '',
                'status' => $tx->status,
                'description' => $tx->description,
                'date' => $tx->created_at?->format('Y-m-d H:i'),
            ])->toArray(),
            'cards' => $cards->map(fn($c) => [
                'type' => $c->type,
                'last4' => $c->last_four ?? substr($c->card_number ?? '', -4),
                'status' => $c->is_frozen ? 'frozen' : 'active',
            ])->toArray(),
        ];

        $accountsJson = json_encode($context['accounts'], JSON_UNESCAPED_UNICODE);
        $txJson = json_encode($context['recent_transactions'], JSON_UNESCAPED_UNICODE);
        $cardsJson = json_encode($context['cards'], JSON_UNESCAPED_UNICODE);
        $userName = $context['user_name'];
        $kycStatus = $context['kyc_status'];

        $systemPrompt = <<<PROMPT
أنت "SDB AI" — المساعد الذكي لعملاء بنك SDB الرقمي.
أنت تتحدث مع العميل: {$userName}

## بيانات العميل الحالية:
- حالة التحقق: {$kycStatus}
- المحافظ: {$accountsJson}
- آخر المعاملات: {$txJson}
- البطاقات: {$cardsJson}

## تعليماتك:
- أجب بالعربية دائماً وبأسلوب ودود
- ساعد العميل بأسئلته عن حسابه: الرصيد، المعاملات، البطاقات، KYC
- لا تكشف بيانات حساسة كاملة (مثل IBAN كاملاً) — اعرض آخر 4 أرقام فقط
- إذا سأل عن شيء خارج حسابه، أجبه بشكل عام عن خدمات البنك
- اذا سأل عن رصيده أو محافظه، اعرضها بشكل مرتب وجميل
- كن مختصراً ومفيداً
- استخدم إيموجي
- لا تذكر أنك تستخدم Gemini — أنت "SDB AI"
PROMPT;

        $reply = \App\Services\GeminiService::chat(
            $request->message,
            $request->input('history', []),
            null // context is in system prompt
        );

        // Override system prompt for this call
        $apiKey = config('services.gemini.api_key');
        if ($apiKey) {
            $contents = [];
            foreach ($request->input('history', []) as $msg) {
                $contents[] = [
                    'role' => $msg['role'] === 'assistant' ? 'model' : 'user',
                    'parts' => [['text' => $msg['content']]],
                ];
            }
            $contents[] = ['role' => 'user', 'parts' => [['text' => $request->message]]];

            $models = ['gemini-2.0-flash', 'gemini-1.5-flash'];
            foreach ($models as $model) {
                $response = \Illuminate\Support\Facades\Http::timeout(30)->post(
                    "https://generativelanguage.googleapis.com/v1beta/models/{$model}:generateContent?key={$apiKey}",
                    [
                        'system_instruction' => ['parts' => [['text' => $systemPrompt]]],
                        'contents' => $contents,
                        'generationConfig' => ['temperature' => 0.7, 'maxOutputTokens' => 1024],
                    ]
                );
                if ($response->successful()) {
                    $reply = $response->json()['candidates'][0]['content']['parts'][0]['text'] ?? $reply;
                    break;
                }
                if ($response->status() !== 429) break;
            }
        }

        return response()->json(['reply' => $reply]);
    }
}