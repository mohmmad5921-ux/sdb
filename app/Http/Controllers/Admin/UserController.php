<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Account;
use App\Models\Currency;
use App\Models\AdminActivityLog;
use App\Models\AdminNote;
use App\Services\AccountService;
use App\Services\FcmService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Inertia\Inertia;

class UserController extends Controller
{
    public function index(Request $request)
    {
        $query = User::where('role', 'customer')
            ->withCount(['accounts', 'cards']);

        if ($request->search) {
            $query->where(function ($q) use ($request) {
                $q->where('full_name', 'like', "%{$request->search}%")
                    ->orWhere('email', 'like', "%{$request->search}%")
                    ->orWhere('phone', 'like', "%{$request->search}%")
                    ->orWhere('customer_number', 'like', "%{$request->search}%");
            });
        }
        if ($request->status) {
            $query->where('status', $request->status);
        }
        if ($request->kyc_status) {
            $query->where('kyc_status', $request->kyc_status);
        }

        return Inertia::render('Admin/Users', [
            'users' => $query->orderByDesc('created_at')->paginate(20)->withQueryString(),
            'filters' => $request->only(['search', 'status', 'kyc_status']),
        ]);
    }

    public function show(User $user)
    {
        $user->load(['accounts.currency', 'cards.account.currency', 'kycDocuments']);

        $accountIds = $user->accounts->pluck('id');

        // All transactions for this user
        $transactions = \App\Models\Transaction::where(function ($q) use ($accountIds) {
            $q->whereIn('from_account_id', $accountIds)
                ->orWhereIn('to_account_id', $accountIds);
        })
            ->with(['currency', 'fromAccount.currency', 'toAccount.currency'])
            ->orderByDesc('created_at')
            ->limit(50)
            ->get();

        // Card transactions (purchases)
        $cardIds = $user->cards->pluck('id');
        $cardTransactions = [];
        try {
            $cardTransactions = \App\Models\CardTransaction::whereIn('card_id', $cardIds)
                ->orderByDesc('created_at')
                ->limit(50)
                ->get();
        } catch (\Exception $e) {
        }

        // Total balance in EUR
        $totalBalance = $user->accounts->sum(function ($a) {
            return $a->balance * ($a->currency->exchange_rate_to_eur ?: 1);
        });

        // Login history
        $loginHistory = [];
        try {
            $loginHistory = \App\Models\LoginHistory::where('user_id', $user->id)
                ->orderByDesc('created_at')
                ->limit(20)
                ->get();
        } catch (\Exception $e) {
        }

        // Admin notes
        $adminNotes = AdminNote::where('user_id', $user->id)
            ->with('admin')
            ->orderByDesc('is_pinned')
            ->orderByDesc('created_at')
            ->get();

        return Inertia::render('Admin/UserDetail', [
            'user' => $user,
            'accounts' => $user->accounts,
            'cards' => $user->cards,
            'kycDocuments' => $user->kycDocuments,
            'transactions' => $transactions,
            'cardTransactions' => $cardTransactions,
            'totalBalance' => round($totalBalance, 2),
            'loginHistory' => $loginHistory,
            'adminNotes' => $adminNotes,
        ]);
    }

    public function updateStatus(Request $request, User $user)
    {
        $request->validate(['status' => 'required|in:pending,active,suspended,blocked,subscription_required']);
        $old = $user->status;
        $user->update(['status' => $request->status]);

        // When activating a pending user → create bank accounts + notify
        if ($old === 'pending' && $request->status === 'active' && $user->accounts()->count() === 0) {
            $this->createUserAccounts($user);

            // Send activation notification + push + email
            try {
                $t = 'تم تفعيل حسابك ✅';
                $b = 'تهانينا! تمت الموافقة على حسابك وتفعيله بنجاح. يمكنك الآن استخدام جميع خدمات SDB Bank.';
                \App\Models\Notification::create(['user_id' => $user->id, 'title' => $t, 'body' => $b, 'type' => 'system']);
                FcmService::sendToUser($user->id, $t, $b);
                Mail::to($user->email)->send(new \App\Mail\AccountActivated($user));
            } catch (\Exception $e) {}
        }

        AdminActivityLog::log('user.status_change', 'user', $user->id, ['old' => $old, 'new' => $request->status, 'user_name' => $user->full_name]);
        return back()->with('success', 'تم تحديث حالة المستخدم');
    }

    /**
     * Create default bank accounts for a newly activated user.
     */
    private function createUserAccounts(User $user): void
    {
        $accountService = app(AccountService::class);

        $countryToCurrency = [
            'DK' => 'DKK', 'SE' => 'SEK', 'GB' => 'GBP', 'US' => 'USD',
            'TR' => 'TRY', 'SY' => 'SYP', 'DE' => 'EUR', 'FR' => 'EUR',
            'NL' => 'EUR', 'IT' => 'EUR', 'ES' => 'EUR', 'AT' => 'EUR',
            'BE' => 'EUR', 'FI' => 'EUR', 'IE' => 'EUR', 'PT' => 'EUR',
            'GR' => 'EUR', 'LU' => 'EUR', 'LB' => 'USD', 'JO' => 'JOD',
            'IQ' => 'IQD', 'SA' => 'SAR', 'AE' => 'AED', 'EG' => 'EGP',
            'KW' => 'KWD', 'QA' => 'QAR', 'BH' => 'BHD', 'OM' => 'OMR',
            'NO' => 'NOK', 'CH' => 'CHF', 'CA' => 'CAD',
        ];

        // Detect country from phone prefix
        $phone = $user->phone ?? '';
        $countryCode = 'DK'; // default
        $prefixes = ['+963' => 'SY', '+961' => 'LB', '+962' => 'JO', '+964' => 'IQ', '+966' => 'SA', '+971' => 'AE', '+20' => 'EG', '+965' => 'KW', '+974' => 'QA', '+973' => 'BH', '+968' => 'OM', '+45' => 'DK', '+49' => 'DE', '+46' => 'SE', '+47' => 'NO', '+31' => 'NL', '+33' => 'FR', '+44' => 'GB', '+43' => 'AT', '+41' => 'CH', '+32' => 'BE', '+39' => 'IT', '+34' => 'ES', '+90' => 'TR', '+1' => 'US'];
        foreach ($prefixes as $prefix => $code) {
            if (str_starts_with($phone, $prefix)) { $countryCode = $code; break; }
        }
        $defaultCurrencyCode = $countryToCurrency[$countryCode] ?? 'EUR';

        // 1. Create default account in user's country currency
        $defaultCurrency = Currency::where('code', $defaultCurrencyCode)->first()
                         ?? Currency::where('code', 'EUR')->first();
        if ($defaultCurrency) {
            $accountService->createAccount($user, $defaultCurrency, true);
        }

        // 2. Always create SYP account (unless already the default)
        if ($defaultCurrencyCode !== 'SYP') {
            $syp = Currency::where('code', 'SYP')->first();
            if ($syp) $accountService->createAccount($user, $syp);
        }
    }

    public function updateKycStatus(Request $request, User $user)
    {
        $request->validate(['kyc_status' => 'required|in:pending,submitted,verified,rejected']);
        $old = $user->kyc_status;
        $user->update(['kyc_status' => $request->kyc_status]);
        if ($request->kyc_status === 'verified' && $user->status === 'pending') {
            $user->update(['status' => 'subscription_required']);

            // Create bank accounts for the user
            if ($user->accounts()->count() === 0) {
                $this->createUserAccounts($user);
            }
        }

        // Send notification + push + email to customer
        try {
            if ($request->kyc_status === 'verified') {
                $t = 'تم تفعيل حسابك ✅';
                $b = 'تهانينا! تم التحقق من هويتك وتفعيل حسابك بنجاح. يمكنك الآن استخدام جميع خدمات SDB Bank.';
                \App\Models\Notification::create(['user_id' => $user->id, 'title' => $t, 'body' => $b, 'type' => 'system']);
                FcmService::sendToUser($user->id, $t, $b);
                Mail::to($user->email)->send(new \App\Mail\AccountActivated($user));
            } elseif ($request->kyc_status === 'rejected') {
                $t = 'يرجى تحديث مستنداتك ⚠️';
                $b = 'لم نتمكن من التحقق من هويتك. يرجى مراجعة المستندات المرفوعة والتأكد من صحتها ثم إعادة المحاولة.';
                \App\Models\Notification::create(['user_id' => $user->id, 'title' => $t, 'body' => $b, 'type' => 'security']);
                FcmService::sendToUser($user->id, $t, $b);
                Mail::to($user->email)->send(new \App\Mail\KycRejected($user));
            }
        } catch (\Exception $e) {}

        AdminActivityLog::log('user.kyc_update', 'user', $user->id, ['old' => $old, 'new' => $request->kyc_status, 'user_name' => $user->full_name]);
        return back()->with('success', 'تم تحديث حالة KYC');
    }

    // Reset user password
    public function resetPassword(Request $request, User $user)
    {
        $newPassword = 'SDB@' . rand(1000, 9999) . '!';
        $user->update(['password' => Hash::make($newPassword)]);
        AdminActivityLog::log('user.password_reset', 'user', $user->id, ['user_name' => $user->full_name]);
        return back()->with('success', "تم إعادة تعيين كلمة المرور: {$newPassword}");
    }

    // Update user profile (admin edit)
    public function updateProfile(Request $request, User $user)
    {
        $request->validate([
            'full_name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $user->id,
            'phone' => 'nullable|string|max:20',
            'nationality' => 'nullable|string|max:100',
            'address' => 'nullable|string|max:500',
            'city' => 'nullable|string|max:100',
            'country' => 'nullable|string|max:100',
            'governorate' => 'nullable|string|max:100',
            'employment' => 'nullable|string|max:50',
            'date_of_birth' => 'nullable|date',
            'postal_code' => 'nullable|string|max:20',
        ]);
        $user->update($request->only(['full_name', 'email', 'phone', 'nationality', 'address', 'city', 'country', 'governorate', 'employment', 'date_of_birth', 'postal_code']));
        AdminActivityLog::log('user.profile_update', 'user', $user->id, ['user_name' => $user->full_name, 'fields' => array_keys($request->except('_method'))]);
        return back()->with('success', 'تم تحديث بيانات العميل');
    }

    // Freeze all user accounts
    public function freezeAllAccounts(User $user)
    {
        $user->accounts()->update(['status' => 'frozen']);
        $user->cards()->where('status', 'active')->update(['status' => 'frozen']);
        AdminActivityLog::log('user.freeze_all', 'user', $user->id, ['user_name' => $user->full_name]);
        return back()->with('success', 'تم تجميد جميع حسابات وبطاقات العميل');
    }

    // Unfreeze all user accounts
    public function unfreezeAllAccounts(User $user)
    {
        $user->accounts()->where('status', 'frozen')->update(['status' => 'active']);
        $user->cards()->where('status', 'frozen')->update(['status' => 'active']);
        AdminActivityLog::log('user.unfreeze_all', 'user', $user->id, ['user_name' => $user->full_name]);
        return back()->with('success', 'تم إلغاء تجميد جميع حسابات وبطاقات العميل');
    }

    // Send admin note to customer + push
    public function sendNote(Request $request, User $user)
    {
        $request->validate(['note' => 'required|string|max:1000']);
        $t = 'رسالة من الإدارة';
        try {
            \App\Models\Notification::create(['user_id' => $user->id, 'title' => $t, 'body' => $request->note, 'type' => 'system']);
            FcmService::sendToUser($user->id, $t, $request->note);
        } catch (\Exception $e) {}
        AdminActivityLog::log('user.send_note', 'user', $user->id, ['user_name' => $user->full_name, 'note_preview' => mb_substr($request->note, 0, 100)]);
        return back()->with('success', 'تم إرسال الإشعار للعميل');
    }

    // Broadcast notification page
    public function broadcastForm()
    {
        $stats = [
            'all' => User::where('role', 'customer')->count(),
            'active' => User::where('role', 'customer')->where('status', 'active')->count(),
            'verified' => User::where('role', 'customer')->where('kyc_status', 'verified')->count(),
        ];
        return Inertia::render('Admin/BroadcastNotification', ['stats' => $stats]);
    }

    // Send broadcast notification
    public function broadcastSend(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'message' => 'required|string|max:2000',
            'target' => 'required|in:all,active,verified',
        ]);

        $query = User::where('role', 'customer');
        if ($request->target === 'active')
            $query->where('status', 'active');
        if ($request->target === 'verified')
            $query->where('kyc_status', 'verified');

        $users = $query->get();
        $count = 0;

        foreach ($users as $user) {
            try {
                \App\Models\Notification::create(['user_id' => $user->id, 'title' => $request->title, 'body' => $request->message, 'type' => 'promotion']);
                FcmService::sendToUser($user->id, $request->title, $request->message);
                $count++;
            } catch (\Exception $e) {}
        }

        AdminActivityLog::log('broadcast.notification', null, null, [
            'title' => $request->title,
            'target' => $request->target,
            'sent_count' => $count,
        ]);

        return back()->with('success', "تم إرسال الإشعار إلى {$count} عميل");
    }

    // Internal Notes
    public function addNote(Request $request, User $user)
    {
        $request->validate([
            'content' => 'required|string|max:2000',
            'category' => 'required|in:general,kyc,support,risk',
        ]);
        AdminNote::create([
            'admin_id' => auth()->id(),
            'user_id' => $user->id,
            'content' => $request->content,
            'category' => $request->category,
        ]);
        return back()->with('success', 'تم إضافة الملاحظة');
    }

    public function deleteNote(AdminNote $note)
    {
        $note->delete();
        return back()->with('success', 'تم حذف الملاحظة');
    }

    public function togglePinNote(AdminNote $note)
    {
        $note->update(['is_pinned' => !$note->is_pinned]);
        return back()->with('success', $note->is_pinned ? 'تم تثبيت الملاحظة' : 'تم إلغاء التثبيت');
    }
}