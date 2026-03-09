<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Account;
use App\Models\Transaction;
use App\Models\Card;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    public function search(Request $request)
    {
        $q = $request->input('q', '');
        if (strlen($q) < 2)
            return response()->json(['results' => []]);

        $results = [];

        // Search users
        $users = User::where('role', 'customer')
            ->where(function ($query) use ($q) {
                $query->where('full_name', 'like', "%{$q}%")
                    ->orWhere('email', 'like', "%{$q}%")
                    ->orWhere('phone', 'like', "%{$q}%")
                    ->orWhere('customer_number', 'like', "%{$q}%");
            })
            ->limit(5)
            ->get(['id', 'full_name', 'email', 'customer_number', 'status']);

        foreach ($users as $u) {
            $results[] = [
                'type' => 'user',
                'icon' => '👤',
                'title' => $u->full_name,
                'subtitle' => $u->email . ' · ' . $u->customer_number,
                'url' => route('admin.users.show', $u->id),
                'status' => $u->status,
            ];
        }

        // Search accounts
        $accounts = Account::with('user')
            ->where(function ($query) use ($q) {
                $query->where('iban', 'like', "%{$q}%")
                    ->orWhere('account_number', 'like', "%{$q}%");
            })
            ->limit(5)
            ->get();

        foreach ($accounts as $a) {
            $results[] = [
                'type' => 'account',
                'icon' => '🏦',
                'title' => $a->iban ?: $a->account_number,
                'subtitle' => $a->user?->full_name . ' · ' . $a->status,
                'url' => route('admin.accounts'),
                'status' => $a->status,
            ];
        }

        // Search transactions
        $transactions = Transaction::with('currency')
            ->where(function ($query) use ($q) {
                $query->where('reference_number', 'like', "%{$q}%")
                    ->orWhere('description', 'like', "%{$q}%");
            })
            ->limit(5)
            ->get();

        foreach ($transactions as $t) {
            $results[] = [
                'type' => 'transaction',
                'icon' => '💸',
                'title' => $t->reference_number,
                'subtitle' => $t->amount . ' ' . ($t->currency?->code ?? '') . ' · ' . $t->type,
                'url' => route('admin.transactions'),
                'status' => $t->status,
            ];
        }

        // Search cards
        $cards = Card::with('user')
            ->where(function ($query) use ($q) {
                $query->where('card_number_masked', 'like', "%{$q}%")
                    ->orWhere('card_holder_name', 'like', "%{$q}%");
            })
            ->limit(3)
            ->get();

        foreach ($cards as $c) {
            $results[] = [
                'type' => 'card',
                'icon' => '💳',
                'title' => $c->card_number_masked,
                'subtitle' => $c->user?->full_name . ' · ' . $c->card_type,
                'url' => route('admin.cards'),
                'status' => $c->status,
            ];
        }

        return response()->json(['results' => $results]);
    }
}
