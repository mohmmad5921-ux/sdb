<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Account;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
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
        }
        catch (\Exception $e) {
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
        }
        catch (\Exception $e) {
        }

        return Inertia::render('Admin/UserDetail', [
            'user' => $user,
            'accounts' => $user->accounts,
            'cards' => $user->cards,
            'kycDocuments' => $user->kycDocuments,
            'transactions' => $transactions,
            'cardTransactions' => $cardTransactions,
            'totalBalance' => round($totalBalance, 2),
            'loginHistory' => $loginHistory,
        ]);
    }

    public function updateStatus(Request $request, User $user)
    {
        $request->validate(['status' => 'required|in:pending,active,suspended,blocked']);
        $user->update(['status' => $request->status]);
        return back()->with('success', 'تم تحديث حالة المستخدم');
    }

    public function updateKycStatus(Request $request, User $user)
    {
        $request->validate(['kyc_status' => 'required|in:pending,submitted,verified,rejected']);
        $user->update(['kyc_status' => $request->kyc_status]);
        if ($request->kyc_status === 'verified' && $user->status === 'pending') {
            $user->update(['status' => 'active']);
        }
        return back()->with('success', 'تم تحديث حالة KYC');
    }

    // Reset user password
    public function resetPassword(Request $request, User $user)
    {
        $newPassword = 'SDB@' . rand(1000, 9999) . '!';
        $user->update(['password' => Hash::make($newPassword)]);
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
        ]);
        $user->update($request->only(['full_name', 'email', 'phone', 'nationality', 'address', 'city', 'country']));
        return back()->with('success', 'تم تحديث بيانات العميل');
    }

    // Freeze all user accounts
    public function freezeAllAccounts(User $user)
    {
        $user->accounts()->update(['status' => 'frozen']);
        $user->cards()->where('status', 'active')->update(['status' => 'frozen']);
        return back()->with('success', 'تم تجميد جميع حسابات وبطاقات العميل');
    }

    // Unfreeze all user accounts
    public function unfreezeAllAccounts(User $user)
    {
        $user->accounts()->where('status', 'frozen')->update(['status' => 'active']);
        $user->cards()->where('status', 'frozen')->update(['status' => 'active']);
        return back()->with('success', 'تم إلغاء تجميد جميع حسابات وبطاقات العميل');
    }

    // Send admin note (stored in session flash)
    public function sendNote(Request $request, User $user)
    {
        $request->validate(['note' => 'required|string|max:1000']);
        // In a real app, this would create a notification record
        try {
            \App\Models\Notification::create([
                'user_id' => $user->id,
                'title' => 'رسالة من الإدارة',
                'message' => $request->note,
                'type' => 'admin_notice',
            ]);
        }
        catch (\Exception $e) {
        }
        return back()->with('success', 'تم إرسال الإشعار للعميل');
    }
}