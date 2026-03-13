<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Account;
use App\Models\Card;
use App\Models\AuditLog;
use App\Models\AdminActivityLog;
use App\Models\Setting;
use App\Models\Transaction;
use App\Services\AccountService;
use App\Services\CardService;
use App\Services\IbanService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SystemController extends Controller
{
    /**
     * Accounts management
     */
    public function accounts(Request $request)
    {
        $query = Account::with(['user', 'currency']);

        if ($request->search) {
            $query->where(function ($q) use ($request) {
                $q->where('iban', 'like', "%{$request->search}%")
                    ->orWhere('account_number', 'like', "%{$request->search}%")
                    ->orWhereHas('user', fn($uq) => $uq->where('full_name', 'like', "%{$request->search}%")
                        ->orWhere('customer_number', 'like', "%{$request->search}%"));
            });
        }
        if ($request->status)
            $query->where('status', $request->status);
        if ($request->currency)
            $query->whereHas('currency', fn($q) => $q->where('code', $request->currency));

        // Stats
        $stats = [
            'total' => Account::count(),
            'active' => Account::where('status', 'active')->count(),
            'frozen' => Account::where('status', 'frozen')->count(),
            'closed' => Account::where('status', 'closed')->count(),
            'total_balance_eur' => Account::with('currency')->get()->sum(fn($a) => $a->balance * ($a->currency->exchange_rate_to_eur ?? 1)),
        ];

        // Currencies for filter
        $currencies = \App\Models\Currency::where('is_active', true)->pluck('code');

        return Inertia::render('Admin/Accounts', [
            'accounts' => $query->orderByDesc('created_at')->paginate(20)->withQueryString(),
            'filters' => $request->only(['search', 'status', 'currency']),
            'stats' => $stats,
            'currencies' => $currencies,
        ]);
    }

    public function updateAccountStatus(Request $request, Account $account)
    {
        $request->validate(['status' => 'required|in:active,frozen,closed']);
        $oldStatus = $account->status;
        $account->update(['status' => $request->status]);

        AuditLog::create([
            'user_id' => auth()->id(),
            'action' => 'account_status_change',
            'entity_type' => 'account',
            'entity_id' => $account->id,
            'old_values' => ['status' => $oldStatus],
            'new_values' => ['status' => $request->status],
            'ip_address' => $request->ip(),
        ]);
        AdminActivityLog::log('account.status_change', 'account', $account->id, ['old' => $oldStatus, 'new' => $request->status, 'user_name' => $account->user->full_name ?? '']);

        return back()->with('success', 'تم تحديث حالة الحساب');
    }

    public function adjustBalance(Request $request, Account $account)
    {
        $request->validate([
            'amount' => 'required|numeric',
            'type' => 'required|in:credit,debit',
            'reason' => 'required|string|max:255',
        ]);

        $accountService = new AccountService(new IbanService());

        if ($request->type === 'credit') {
            $accountService->credit($account, abs($request->amount));
        } else {
            if (!$accountService->debit($account, abs($request->amount))) {
                return back()->withErrors(['amount' => 'رصيد غير كافٍ']);
            }
        }

        AuditLog::create([
            'user_id' => auth()->id(),
            'action' => 'admin_balance_adjustment',
            'entity_type' => 'account',
            'entity_id' => $account->id,
            'new_values' => ['type' => $request->type, 'amount' => $request->amount, 'reason' => $request->reason],
            'ip_address' => $request->ip(),
        ]);
        AdminActivityLog::log('account.balance_adjust', 'account', $account->id, ['type' => $request->type, 'amount' => $request->amount, 'reason' => $request->reason, 'user_name' => $account->user->full_name ?? '']);

        // Send push notification to customer
        $account->refresh();
        $user = $account->user;
        $currency = $account->currency;
        $symbol = $currency->symbol ?? $currency->code ?? '';
        $amount = number_format(abs($request->amount), 2);
        $newBalance = number_format($account->balance, 2);

        if ($request->type === 'credit') {
            $title = '💰 تم إضافة رصيد';
            $body = "تم إضافة {$amount} {$symbol} إلى حسابك. رصيدك الجديد: {$newBalance} {$symbol}";
        } else {
            $title = '💸 خصم من الرصيد';
            $body = "تم خصم {$amount} {$symbol} من حسابك. رصيدك الجديد: {$newBalance} {$symbol}";
        }

        // Create in-app notification
        \App\Models\Notification::create([
            'user_id' => $user->id,
            'title' => $title,
            'body' => $body,
            'type' => 'balance_update',
            'data' => json_encode(['account_id' => $account->id, 'type' => $request->type, 'amount' => $request->amount, 'currency' => $currency->code ?? '']),
        ]);

        // Send FCM push
        \App\Services\PushNotificationService::sendToUser($user, $title, $body, [
            'type' => 'balance_update',
            'account_id' => (string) $account->id,
            'amount' => (string) $request->amount,
        ]);

        return back()->with('success', 'تم تعديل الرصيد بنجاح');
    }

    /**
     * Cards management
     */
    public function cards(Request $request)
    {
        $query = Card::with(['user', 'account.currency']);

        if ($request->search) {
            $query->where(function ($q) use ($request) {
                $q->where('card_number_masked', 'like', "%{$request->search}%")
                    ->orWhere('card_holder_name', 'like', "%{$request->search}%")
                    ->orWhereHas('user', fn($uq) => $uq->where('full_name', 'like', "%{$request->search}%")
                        ->orWhere('customer_number', 'like', "%{$request->search}%"));
            });
        }
        if ($request->status)
            $query->where('status', $request->status);

        // Stats
        $stats = [
            'total' => Card::count(),
            'active' => Card::where('status', 'active')->count(),
            'frozen' => Card::where('status', 'frozen')->count(),
            'cancelled' => Card::where('status', 'cancelled')->count(),
            'expired' => Card::where('status', 'expired')->count(),
            'virtual' => Card::where('card_type', 'virtual')->count(),
            'physical' => Card::where('card_type', 'physical')->count(),
            'total_daily_limit' => Card::where('status', 'active')->sum('daily_limit'),
        ];

        return Inertia::render('Admin/Cards', [
            'cards' => $query->orderByDesc('created_at')->paginate(20)->withQueryString(),
            'filters' => $request->only(['search', 'status']),
            'stats' => $stats,
        ]);
    }

    public function updateCardStatus(Request $request, Card $card)
    {
        $request->validate(['status' => 'required|in:active,frozen,cancelled']);
        $oldStatus = $card->status;
        $card->update(['status' => $request->status]);

        AuditLog::create([
            'user_id' => auth()->id(),
            'action' => 'card_status_change',
            'entity_type' => 'card',
            'entity_id' => $card->id,
            'old_values' => ['status' => $oldStatus],
            'new_values' => ['status' => $request->status],
            'ip_address' => $request->ip(),
        ]);
        AdminActivityLog::log('card.status_change', 'card', $card->id, ['old' => $oldStatus, 'new' => $request->status, 'user_name' => $card->user->full_name ?? '']);

        return back()->with('success', 'تم تحديث حالة البطاقة');
    }

    public function updateCardLimits(Request $request, Card $card)
    {
        $request->validate([
            'daily_limit' => 'numeric|min:0',
            'monthly_limit' => 'numeric|min:0',
            'spending_limit' => 'numeric|min:0',
        ]);

        $card->update($request->only(['daily_limit', 'monthly_limit', 'spending_limit']));

        AuditLog::create([
            'user_id' => auth()->id(),
            'action' => 'card_limits_change',
            'entity_type' => 'card',
            'entity_id' => $card->id,
            'new_values' => $request->only(['daily_limit', 'monthly_limit', 'spending_limit']),
            'ip_address' => $request->ip(),
        ]);
        AdminActivityLog::log('card.limits_update', 'card', $card->id, ['limits' => $request->only(['daily_limit', 'monthly_limit', 'spending_limit']), 'user_name' => $card->user->full_name ?? '']);

        return back()->with('success', 'تم تحديث حدود البطاقة');
    }

    /**
     * Audit logs
     */
    public function auditLogs(Request $request)
    {
        $query = AdminActivityLog::with('admin');

        if ($request->action)
            $query->where('action', $request->action);
        if ($request->search) {
            $query->where(function ($q) use ($request) {
                $q->where('action', 'like', "%{$request->search}%")
                    ->orWhere('target_type', 'like', "%{$request->search}%")
                    ->orWhere('details', 'like', "%{$request->search}%");
            });
        }
        if ($request->from) {
            $query->whereDate('created_at', '>=', $request->from);
        }
        if ($request->to) {
            $query->whereDate('created_at', '<=', $request->to);
        }

        $actionLabels = AdminActivityLog::actionLabels();
        $actions = AdminActivityLog::distinct()->pluck('action')->filter();

        return Inertia::render('Admin/AuditLogs', [
            'logs' => $query->orderByDesc('created_at')->paginate(30)->withQueryString(),
            'filters' => $request->only(['search', 'action', 'from', 'to']),
            'actionLabels' => $actionLabels,
            'actions' => $actions,
        ]);
    }

    /**
     * Settings management
     */
    public function settings()
    {
        $settings = Setting::orderBy('group')->orderBy('key')->get()->groupBy('group');

        return Inertia::render('Admin/Settings', [
            'settings' => $settings,
        ]);
    }

    public function updateSettings(Request $request)
    {
        foreach ($request->all() as $key => $value) {
            Setting::setValue($key, $value);
        }
        return back()->with('success', 'تم تحديث الإعدادات');
    }
}