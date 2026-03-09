<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class BusinessAccountController extends Controller
{
    // ═══════════════════════════════════════════════
    // DASHBOARD — Business overview stats
    // ═══════════════════════════════════════════════
    public function dashboard()
    {
        $stats = [
            'total' => DB::table('business_accounts')->count(),
            'active' => DB::table('business_accounts')->where('status', 'active')->count(),
            'pending' => DB::table('business_accounts')->where('status', 'pending')->count(),
            'suspended' => DB::table('business_accounts')->where('status', 'suspended')->count(),
            'rejected' => DB::table('business_accounts')->where('status', 'rejected')->count(),
        ];

        // By size
        $bySize = DB::table('business_accounts')
            ->selectRaw("size, COUNT(*) as count")
            ->groupBy('size')->get();

        // By category
        $byCategory = DB::table('business_accounts')
            ->selectRaw("category, COUNT(*) as count")
            ->groupBy('category')->orderByDesc('count')->get();

        // Total volume — sum balances of linked accounts
        $totalBalance = 0;
        $todayVolume = 0;
        $monthlyVolume = 0;
        try {
            $totalBalance = DB::table('business_accounts')
                ->join('accounts', 'business_accounts.account_id', '=', 'accounts.id')
                ->sum('accounts.balance');
            $todayVolume = DB::table('business_accounts')
                ->join('accounts', 'business_accounts.account_id', '=', 'accounts.id')
                ->join('transactions', 'transactions.from_account_id', '=', 'accounts.id')
                ->whereDate('transactions.created_at', today())
                ->where('transactions.status', 'completed')
                ->sum('transactions.amount');
            $monthlyVolume = DB::table('business_accounts')
                ->join('accounts', 'business_accounts.account_id', '=', 'accounts.id')
                ->join('transactions', 'transactions.from_account_id', '=', 'accounts.id')
                ->where('transactions.created_at', '>=', now()->startOfMonth())
                ->where('transactions.status', 'completed')
                ->sum('transactions.amount');
        } catch (\Throwable $e) {
        }

        // Total invoices
        $invoiceStats = [
            'total' => DB::table('business_invoices')->count(),
            'paid' => DB::table('business_invoices')->where('status', 'paid')->count(),
            'pending' => DB::table('business_invoices')->whereIn('status', ['draft', 'sent'])->count(),
            'total_amount' => round(DB::table('business_invoices')->where('status', 'paid')->sum('total_amount'), 2),
        ];

        // Total employees
        $totalEmployees = DB::table('business_employees')->where('status', 'active')->count();

        // Recent businesses
        $recent = DB::table('business_accounts')
            ->leftJoin('users', 'business_accounts.user_id', '=', 'users.id')
            ->select('business_accounts.*', 'users.full_name as owner_full_name', 'users.email as owner_email')
            ->orderBy('business_accounts.created_at', 'desc')
            ->limit(10)->get();

        return Inertia::render('Admin/BusinessDashboard', [
            'stats' => $stats,
            'bySize' => $bySize,
            'byCategory' => $byCategory,
            'totalBalance' => round($totalBalance, 2),
            'todayVolume' => round($todayVolume, 2),
            'monthlyVolume' => round($monthlyVolume, 2),
            'invoiceStats' => $invoiceStats,
            'totalEmployees' => $totalEmployees,
            'recent' => $recent,
        ]);
    }

    // ═══════════════════════════════════════════════
    // INDEX — List all businesses with search & filter
    // ═══════════════════════════════════════════════
    public function index(Request $request)
    {
        $query = DB::table('business_accounts')
            ->leftJoin('users', 'business_accounts.user_id', '=', 'users.id')
            ->leftJoin('accounts', 'business_accounts.account_id', '=', 'accounts.id')
            ->select(
                'business_accounts.*',
                'users.full_name as owner_full_name',
                'users.email as owner_email',
                'accounts.balance',
                'accounts.account_number'
            );

        if ($request->search) {
            $s = '%' . $request->search . '%';
            $query->where(function ($q) use ($s) {
                $q->where('business_accounts.business_name', 'like', $s)
                    ->orWhere('business_accounts.commercial_register', 'like', $s)
                    ->orWhere('business_accounts.email', 'like', $s)
                    ->orWhere('business_accounts.owner_name', 'like', $s);
            });
        }
        if ($request->status)
            $query->where('business_accounts.status', $request->status);
        if ($request->size)
            $query->where('business_accounts.size', $request->size);
        if ($request->category)
            $query->where('business_accounts.category', $request->category);

        $businesses = $query->orderBy('business_accounts.created_at', 'desc')->paginate(20)->withQueryString();

        return Inertia::render('Admin/BusinessAccounts', [
            'businesses' => $businesses,
            'filters' => $request->only(['search', 'status', 'size', 'category']),
        ]);
    }

    // ═══════════════════════════════════════════════
    // SHOW — Business detail page
    // ═══════════════════════════════════════════════
    public function show($id)
    {
        $business = DB::table('business_accounts')
            ->leftJoin('users', 'business_accounts.user_id', '=', 'users.id')
            ->leftJoin('accounts', 'business_accounts.account_id', '=', 'accounts.id')
            ->leftJoin('currencies', 'accounts.currency_id', '=', 'currencies.id')
            ->select(
                'business_accounts.*',
                'users.full_name as owner_full_name',
                'users.email as owner_email',
                'users.phone_number as owner_phone_number',
                'accounts.balance',
                'accounts.available_balance',
                'accounts.account_number',
                'accounts.iban',
                'accounts.status as account_status',
                'currencies.code as currency_code',
                'currencies.symbol as currency_symbol'
            )
            ->where('business_accounts.id', $id)->first();

        if (!$business)
            abort(404);

        // Employees
        $employees = DB::table('business_employees')
            ->join('users', 'business_employees.user_id', '=', 'users.id')
            ->select('business_employees.*', 'users.full_name', 'users.email', 'users.phone_number')
            ->where('business_employees.business_account_id', $id)
            ->get();

        // Transactions (via linked account)
        $transactions = [];
        if ($business->account_id ?? null) {
            $transactions = DB::table('transactions')
                ->where('from_account_id', $business->account_id)
                ->orWhere('to_account_id', $business->account_id)
                ->orderBy('created_at', 'desc')
                ->limit(50)->get();
        }

        // Invoices
        $invoices = DB::table('business_invoices')
            ->where('business_account_id', $id)
            ->orderBy('created_at', 'desc')
            ->limit(50)->get();

        // Daily sales (last 30 days)
        $dailySales = [];
        try {
            if ($business->account_id ?? null) {
                $dailySales = DB::table('transactions')
                    ->where('to_account_id', $business->account_id)
                    ->where('status', 'completed')
                    ->where('created_at', '>=', now()->subDays(30))
                    ->selectRaw("date(created_at) as day, COUNT(*) as count, SUM(amount) as total")
                    ->groupByRaw("date(created_at)")
                    ->orderBy('day')->get();
            }
        } catch (\Throwable $e) {
        }

        // Incoming payments
        $incomingPayments = 0;
        $todaySales = 0;
        try {
            if ($business->account_id ?? null) {
                $incomingPayments = DB::table('transactions')
                    ->where('to_account_id', $business->account_id)
                    ->where('status', 'completed')
                    ->sum('amount');
                $todaySales = DB::table('transactions')
                    ->where('to_account_id', $business->account_id)
                    ->where('status', 'completed')
                    ->whereDate('created_at', today())
                    ->sum('amount');
            }
        } catch (\Throwable $e) {
        }

        return Inertia::render('Admin/BusinessDetail', [
            'business' => $business,
            'employees' => $employees,
            'transactions' => $transactions,
            'invoices' => $invoices,
            'dailySales' => $dailySales,
            'incomingPayments' => round($incomingPayments, 2),
            'todaySales' => round($todaySales, 2),
        ]);
    }

    // ═══════════════════════════════════════════════
    // ACTIONS — Activate, Suspend, Reject, Update
    // ═══════════════════════════════════════════════
    public function activate($id)
    {
        DB::table('business_accounts')->where('id', $id)->update([
            'status' => 'active',
            'activated_at' => now(),
            'updated_at' => now()
        ]);
        return back()->with('success', 'تم تفعيل حساب الشركة');
    }

    public function suspend(Request $request, $id)
    {
        DB::table('business_accounts')->where('id', $id)->update([
            'status' => 'suspended',
            'suspended_at' => now(),
            'suspension_reason' => $request->reason ?? 'تم التعليق بواسطة الإدارة',
            'updated_at' => now()
        ]);
        return back()->with('success', 'تم تعليق حساب الشركة');
    }

    public function reject($id)
    {
        DB::table('business_accounts')->where('id', $id)->update([
            'status' => 'rejected',
            'updated_at' => now()
        ]);
        return back()->with('success', 'تم رفض حساب الشركة');
    }

    public function updateLimits(Request $request, $id)
    {
        DB::table('business_accounts')->where('id', $id)->update([
            'transfer_limit_daily' => $request->transfer_limit_daily,
            'transfer_limit_monthly' => $request->transfer_limit_monthly,
            'fee_percentage' => $request->fee_percentage,
            'fee_fixed' => $request->fee_fixed,
            'updated_at' => now()
        ]);
        return back()->with('success', 'تم تحديث الحدود والرسوم');
    }

    public function sendNotification(Request $request, $id)
    {
        // In production this would send email/SMS — for now just flash success
        return back()->with('success', 'تم إرسال الإشعار للشركة');
    }

    // ═══════════════════════════════════════════════
    // EMPLOYEE MANAGEMENT
    // ═══════════════════════════════════════════════
    public function updateEmployeeRole(Request $request, $id, $employeeId)
    {
        DB::table('business_employees')->where('id', $employeeId)->update([
            'role' => $request->role,
            'permissions' => json_encode($request->permissions ?? []),
            'updated_at' => now()
        ]);
        return back()->with('success', 'تم تحديث صلاحيات الموظف');
    }

    public function removeEmployee($id, $employeeId)
    {
        DB::table('business_employees')->where('id', $employeeId)->update([
            'status' => 'inactive',
            'updated_at' => now()
        ]);
        return back()->with('success', 'تم إزالة الموظف');
    }

    // ═══════════════════════════════════════════════
    // FREEZE LINKED BANK ACCOUNT
    // ═══════════════════════════════════════════════
    public function freezeAccount($id)
    {
        $biz = DB::table('business_accounts')->where('id', $id)->first();
        if ($biz && $biz->account_id) {
            DB::table('accounts')->where('id', $biz->account_id)->update(['status' => 'frozen', 'updated_at' => now()]);
        }
        DB::table('business_accounts')->where('id', $id)->update(['status' => 'suspended', 'suspended_at' => now(), 'updated_at' => now()]);
        return back()->with('success', 'تم تجميد حساب الشركة');
    }

    public function unfreezeAccount($id)
    {
        $biz = DB::table('business_accounts')->where('id', $id)->first();
        if ($biz && $biz->account_id) {
            DB::table('accounts')->where('id', $biz->account_id)->update(['status' => 'active', 'updated_at' => now()]);
        }
        DB::table('business_accounts')->where('id', $id)->update(['status' => 'active', 'updated_at' => now()]);
        return back()->with('success', 'تم إلغاء تجميد حساب الشركة');
    }
}
