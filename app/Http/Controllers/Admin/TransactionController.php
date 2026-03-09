<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class TransactionController extends Controller
{
    public function index(Request $request)
    {
        $query = Transaction::with(['fromAccount.user', 'fromAccount.currency', 'toAccount.user', 'toAccount.currency', 'currency']);

        if ($request->type)
            $query->where('type', $request->type);
        if ($request->status)
            $query->where('status', $request->status);
        if ($request->search) {
            $query->where(function ($q) use ($request) {
                $q->where('reference_number', 'like', "%{$request->search}%")
                    ->orWhere('description', 'like', "%{$request->search}%");
            });
        }
        if ($request->from_date)
            $query->whereDate('created_at', '>=', $request->from_date);
        if ($request->to_date)
            $query->whereDate('created_at', '<=', $request->to_date);
        if ($request->min_amount)
            $query->where('amount', '>=', $request->min_amount);
        if ($request->max_amount)
            $query->where('amount', '<=', $request->max_amount);

        // Transaction summary stats
        $stats = [
            'total' => DB::table('transactions')->count(),
            'completed' => DB::table('transactions')->where('status', 'completed')->count(),
            'pending' => DB::table('transactions')->where('status', 'pending')->count(),
            'failed' => DB::table('transactions')->where('status', 'failed')->count(),
            'cancelled' => DB::table('transactions')->where('status', 'cancelled')->count(),
            'totalVolume' => round(DB::table('transactions')->where('status', 'completed')->sum('amount'), 2),
            'todayVolume' => round(DB::table('transactions')->whereDate('created_at', today())->where('status', 'completed')->sum('amount'), 2),
        ];

        return Inertia::render('Admin/Transactions', [
            'transactions' => $query->orderByDesc('created_at')->paginate(20)->withQueryString(),
            'filters' => $request->only(['search', 'type', 'status', 'from_date', 'to_date', 'min_amount', 'max_amount']),
            'stats' => $stats,
        ]);
    }

    public function show($id)
    {
        $tx = Transaction::with(['fromAccount.user', 'fromAccount.currency', 'toAccount.user', 'toAccount.currency', 'currency'])->findOrFail($id);
        return Inertia::render('Admin/TransactionDetail', ['transaction' => $tx]);
    }

    public function cancel($id)
    {
        $tx = Transaction::findOrFail($id);
        if ($tx->status !== 'pending') {
            return back()->withErrors(['msg' => 'يمكن إلغاء المعاملات المعلّقة فقط']);
        }
        $tx->update(['status' => 'cancelled']);
        DB::table('system_changelog')->insert([
            'admin_id' => auth()->id(),
            'category' => 'transaction',
            'action' => 'cancel',
            'target' => "Transaction #{$id}",
            'old_value' => 'pending',
            'new_value' => 'cancelled',
            'ip_address' => request()->ip(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        return back()->with('success', 'تم إلغاء المعاملة');
    }

    public function refund($id)
    {
        $tx = Transaction::findOrFail($id);
        if ($tx->status !== 'completed') {
            return back()->withErrors(['msg' => 'يمكن استرجاع المعاملات المكتملة فقط']);
        }
        // Reverse the transaction
        if ($tx->from_account_id) {
            DB::table('accounts')->where('id', $tx->from_account_id)->increment('balance', (float) $tx->amount);
        }
        if ($tx->to_account_id) {
            DB::table('accounts')->where('id', $tx->to_account_id)->decrement('balance', (float) $tx->amount);
        }
        $tx->update(['status' => 'refunded']);
        DB::table('system_changelog')->insert([
            'admin_id' => auth()->id(),
            'category' => 'transaction',
            'action' => 'refund',
            'target' => "Transaction #{$id}",
            'old_value' => json_encode(['amount' => $tx->amount]),
            'new_value' => 'refunded',
            'ip_address' => request()->ip(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        return back()->with('success', 'تم استرجاع المبلغ');
    }

    public function updateStatus(Request $request, $id)
    {
        $tx = Transaction::findOrFail($id);
        $old = $tx->status;
        $tx->update(['status' => $request->status]);
        DB::table('system_changelog')->insert([
            'admin_id' => auth()->id(),
            'category' => 'transaction',
            'action' => 'status_change',
            'target' => "Transaction #{$id}",
            'old_value' => $old,
            'new_value' => $request->status,
            'ip_address' => request()->ip(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        return back()->with('success', 'تم تحديث الحالة');
    }
}