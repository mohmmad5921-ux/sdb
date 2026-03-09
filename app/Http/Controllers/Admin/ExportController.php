<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Transaction;
use App\Models\AdminActivityLog;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

class ExportController extends Controller
{
    /**
     * Export users as CSV
     */
    public function users(Request $request): StreamedResponse
    {
        $query = User::where('role', 'customer');
        if ($request->status)
            $query->where('status', $request->status);
        if ($request->kyc_status)
            $query->where('kyc_status', $request->kyc_status);

        $users = $query->orderByDesc('created_at')->get();

        AdminActivityLog::log('export.users', null, null, ['count' => $users->count()]);

        return $this->streamCsv('sdb_users_' . date('Y-m-d') . '.csv', [
            'رقم العميل',
            'الاسم',
            'البريد',
            'الهاتف',
            'الحالة',
            'KYC',
            'الدولة',
            'المحافظة',
            'المدينة',
            'الوظيفة',
            'الجنسية',
            'تاريخ الميلاد',
            'تاريخ التسجيل',
        ], $users->map(fn($u) => [
                        $u->customer_number,
                        $u->full_name,
                        $u->email,
                        $u->phone,
                        $u->status,
                        $u->kyc_status,
                        $u->country,
                        $u->governorate,
                        $u->city,
                        $u->employment,
                        $u->nationality,
                        $u->date_of_birth?->format('Y-m-d'),
                        $u->created_at?->format('Y-m-d H:i'),
                    ]));
    }

    /**
     * Export transactions as CSV
     */
    public function transactions(Request $request): StreamedResponse
    {
        $query = Transaction::with(['currency', 'fromAccount.user', 'toAccount.user']);
        if ($request->from)
            $query->whereDate('created_at', '>=', $request->from);
        if ($request->to)
            $query->whereDate('created_at', '<=', $request->to);
        if ($request->status)
            $query->where('status', $request->status);
        if ($request->type)
            $query->where('type', $request->type);

        $txs = $query->orderByDesc('created_at')->limit(5000)->get();

        AdminActivityLog::log('export.transactions', null, null, ['count' => $txs->count()]);

        return $this->streamCsv('sdb_transactions_' . date('Y-m-d') . '.csv', [
            'المرجع',
            'النوع',
            'المبلغ',
            'العملة',
            'من',
            'إلى',
            'الحالة',
            'التاريخ',
        ], $txs->map(fn($t) => [
                        $t->reference_number,
                        $t->type,
                        $t->amount,
                        $t->currency?->code,
                        $t->fromAccount?->user?->full_name ?? '—',
                        $t->toAccount?->user?->full_name ?? '—',
                        $t->status,
                        $t->created_at?->format('Y-m-d H:i'),
                    ]));
    }

    /**
     * Export waitlist as CSV
     */
    public function waitlist(Request $request): StreamedResponse
    {
        $entries = \App\Models\WaitlistEmail::orderByDesc('created_at')->get();

        AdminActivityLog::log('export.waitlist', null, null, ['count' => $entries->count()]);

        return $this->streamCsv('sdb_waitlist_' . date('Y-m-d') . '.csv', [
            'الاسم',
            'البريد',
            'الهاتف',
            'الدولة',
            'المصدر',
            'التاريخ',
        ], $entries->map(fn($w) => [
                        $w->full_name ?? $w->name ?? '',
                        $w->email,
                        $w->phone ?? '',
                        $w->country ?? '',
                        $w->source ?? '',
                        $w->created_at?->format('Y-m-d H:i'),
                    ]));
    }

    /**
     * Export preregistrations as CSV
     */
    public function preregistrations(Request $request): StreamedResponse
    {
        $entries = \App\Models\Preregistration::orderByDesc('created_at')->get();

        AdminActivityLog::log('export.preregistrations', null, null, ['count' => $entries->count()]);

        return $this->streamCsv('sdb_preregistrations_' . date('Y-m-d') . '.csv', [
            'الاسم',
            'البريد',
            'الهاتف',
            'الدولة',
            'التاريخ',
        ], $entries->map(fn($p) => [
                        $p->full_name,
                        $p->email,
                        $p->phone,
                        $p->country,
                        $p->created_at?->format('Y-m-d H:i'),
                    ]));
    }

    /**
     * Helper: stream CSV response
     */
    private function streamCsv(string $filename, array $headers, $rows): StreamedResponse
    {
        return response()->streamDownload(function () use ($headers, $rows) {
            $handle = fopen('php://output', 'w');
            // BOM for Excel UTF-8
            fwrite($handle, "\xEF\xBB\xBF");
            fputcsv($handle, $headers);
            foreach ($rows as $row) {
                fputcsv($handle, $row instanceof \Illuminate\Support\Collection ? $row->toArray() : (array) $row);
            }
            fclose($handle);
        }, $filename, ['Content-Type' => 'text/csv; charset=UTF-8']);
    }
}
