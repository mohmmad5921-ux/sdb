<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class AccountController extends Controller
{
    public function index(Request $request)
    {
        $query = DB::table('accounts')
            ->leftJoin('users', 'accounts.user_id', '=', 'users.id')
            ->leftJoin('currencies', 'accounts.currency_id', '=', 'currencies.id')
            ->select(
                'accounts.*',
                'users.full_name as user_name',
                'users.email as user_email',
                'currencies.code as currency_code',
                'currencies.symbol as currency_symbol'
            );

        if ($request->search) {
            $s = '%'.$request->search.'%';
            $query->where(function ($q) use ($s) {
                $q->where('accounts.account_number', 'like', $s)
                    ->orWhere('accounts.iban', 'like', $s)
                    ->orWhere('users.full_name', 'like', $s)
                    ->orWhere('users.email', 'like', $s);
            });
        }
        if ($request->status) $query->where('accounts.status', $request->status);
        if ($request->currency) $query->where('currencies.code', $request->currency);

        $accounts = $query->orderBy('accounts.created_at', 'desc')->paginate(20)->withQueryString();

        $stats = [
            'total' => DB::table('accounts')->count(),
            'active' => DB::table('accounts')->where('status', 'active')->count(),
            'frozen' => DB::table('accounts')->where('status', 'frozen')->count(),
            'totalBalance' => round(DB::table('accounts')->where('status', 'active')->sum('balance'), 2),
        ];

        $currencies = DB::table('currencies')->where('is_active', true)->select('code', 'symbol')->get();

        return Inertia::render('Admin/Accounts', [
            'accounts' => $accounts,
            'filters' => $request->only(['search', 'status', 'currency']),
            'stats' => $stats,
            'currencies' => $currencies,
        ]);
    }

    public function freeze($id)
    {
        DB::table('accounts')->where('id', $id)->update(['status' => 'frozen', 'updated_at' => now()]);
        return back()->with('success', 'تم تجميد الحساب');
    }

    public function unfreeze($id)
    {
        DB::table('accounts')->where('id', $id)->update(['status' => 'active', 'updated_at' => now()]);
        return back()->with('success', 'تم إلغاء تجميد الحساب');
    }
}
