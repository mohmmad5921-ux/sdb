<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use Illuminate\Http\Request;
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

        return Inertia::render('Admin/Transactions', [
            'transactions' => $query->orderByDesc('created_at')->paginate(20)->withQueryString(),
            'filters' => $request->only(['search', 'type', 'status', 'from_date', 'to_date']),
        ]);
    }
}