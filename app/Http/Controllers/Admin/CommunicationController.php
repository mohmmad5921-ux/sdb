<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class CommunicationController extends Controller
{
    public function index(Request $request)
    {
        $query = DB::table('communication_logs')
            ->leftJoin('users', 'communication_logs.user_id', '=', 'users.id')
            ->select('communication_logs.*', 'users.full_name', 'users.email');

        if ($request->channel)
            $query->where('communication_logs.channel', $request->channel);
        if ($request->search) {
            $query->where(function ($q) use ($request) {
                $q->where('communication_logs.subject', 'like', "%{$request->search}%")
                    ->orWhere('users.full_name', 'like', "%{$request->search}%");
            });
        }

        $logs = $query->orderByDesc('communication_logs.created_at')->paginate(20);

        $stats = [
            'email' => DB::table('communication_logs')->where('channel', 'email')->count(),
            'sms' => DB::table('communication_logs')->where('channel', 'sms')->count(),
            'push' => DB::table('communication_logs')->where('channel', 'push')->count(),
            'system' => DB::table('communication_logs')->where('channel', 'system')->count(),
            'total' => DB::table('communication_logs')->count(),
        ];

        // Email templates
        $templates = [
            ['name' => 'ترحيب', 'key' => 'welcome', 'subject' => 'مرحباً بك في SDB Bank'],
            ['name' => 'تأكيد KYC', 'key' => 'kyc_approved', 'subject' => 'تم التحقق من هويتك'],
            ['name' => 'رفض KYC', 'key' => 'kyc_rejected', 'subject' => 'يرجى تحديث مستنداتك'],
            ['name' => 'تجميد حساب', 'key' => 'account_frozen', 'subject' => 'تم تجميد حسابك مؤقتاً'],
            ['name' => 'معاملة كبيرة', 'key' => 'large_transaction', 'subject' => 'تنبيه: معاملة كبيرة'],
            ['name' => 'تحديث إجباري', 'key' => 'force_update', 'subject' => 'يرجى تحديث التطبيق'],
        ];

        return Inertia::render('Admin/Communications', [
            'logs' => $logs,
            'filters' => $request->only(['channel', 'search']),
            'stats' => $stats,
            'templates' => $templates,
        ]);
    }
}
