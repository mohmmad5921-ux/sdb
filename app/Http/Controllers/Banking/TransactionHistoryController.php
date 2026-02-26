<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Inertia\Inertia;

class TransactionHistoryController extends Controller
{
    public function index(Request $request)
    {
        $user = auth()->user();
        $accountIds = $user->accounts()->pluck('id');

        $query = Transaction::where(function ($q) use ($accountIds) {
            $q->whereIn('from_account_id', $accountIds)
              ->orWhereIn('to_account_id', $accountIds);
        })->with(['currency', 'fromAccount.currency', 'toAccount.currency']);

        // Search
        if ($request->search) {
            $query->where(function ($q) use ($request) {
                $q->where('reference_number', 'like', "%{$request->search}%")
                  ->orWhere('description', 'like', "%{$request->search}%");
            });
        }

        // Type filter
        if ($request->type && $request->type !== 'all') {
            $query->where('type', $request->type);
        }

        // Status filter
        if ($request->status && $request->status !== 'all') {
            $query->where('status', $request->status);
        }

        // Date range
        if ($request->date_from) {
            $query->whereDate('created_at', '>=', $request->date_from);
        }
        if ($request->date_to) {
            $query->whereDate('created_at', '<=', $request->date_to);
        }

        // Date presets
        if ($request->period) {
            match ($request->period) {
                'today' => $query->whereDate('created_at', today()),
                '7d' => $query->where('created_at', '>=', now()->subDays(7)),
                '30d' => $query->where('created_at', '>=', now()->subDays(30)),
                '90d' => $query->where('created_at', '>=', now()->subDays(90)),
                default => null,
            };
        }

        $transactions = $query->orderByDesc('created_at')->paginate(20)->withQueryString();

        // Stats
        $totalIn = Transaction::whereIn('to_account_id', $accountIds)->where('status', 'completed')->sum('amount');
        $totalOut = Transaction::whereIn('from_account_id', $accountIds)->where('status', 'completed')->sum('amount');

        return Inertia::render('Banking/Transactions', [
            'transactions' => $transactions,
            'filters' => $request->only(['search', 'type', 'status', 'period', 'date_from', 'date_to']),
            'stats' => [
                'totalIn' => round($totalIn, 2),
                'totalOut' => round($totalOut, 2),
                'count' => $transactions->total(),
            ],
        ]);
    }

    public function exportCsv(Request $request)
    {
        $user = auth()->user();
        $accountIds = $user->accounts()->pluck('id');

        $transactions = Transaction::where(function ($q) use ($accountIds) {
            $q->whereIn('from_account_id', $accountIds)
              ->orWhereIn('to_account_id', $accountIds);
        })->with(['currency', 'fromAccount.currency', 'toAccount.currency'])
          ->orderByDesc('created_at')
          ->limit(500)
          ->get();

        $csv = "Date,Reference,Type,Amount,Currency,Status,Description\n";
        foreach ($transactions as $t) {
            $csv .= implode(',', [
                $t->created_at->format('Y-m-d H:i'),
                $t->reference_number,
                $t->type,
                $t->amount,
                $t->currency?->code ?? 'EUR',
                $t->status,
                '"' . str_replace('"', '""', $t->description ?? '') . '"',
            ]) . "\n";
        }

        return response($csv, 200, [
            'Content-Type' => 'text/csv',
            'Content-Disposition' => 'attachment; filename="sdb_statement_' . date('Y-m-d') . '.csv"',
        ]);
    }
}