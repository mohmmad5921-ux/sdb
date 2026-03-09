<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AdminActivityLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class ApprovalController extends Controller
{
    public function index(Request $request)
    {
        $query = DB::table('pending_approvals')
            ->leftJoin('users as u', 'pending_approvals.user_id', '=', 'u.id')
            ->leftJoin('users as r', 'pending_approvals.reviewed_by', '=', 'r.id')
            ->select('pending_approvals.*', 'u.full_name as user_name', 'u.email as user_email', 'r.full_name as reviewer_name');

        if ($request->status && $request->status !== 'all') {
            $query->where('pending_approvals.status', $request->status);
        } else {
            $query->where('pending_approvals.status', 'pending');
        }

        $approvals = $query->orderByDesc('pending_approvals.created_at')->paginate(20);

        $stats = [
            'pending' => DB::table('pending_approvals')->where('status', 'pending')->count(),
            'approved' => DB::table('pending_approvals')->where('status', 'approved')->count(),
            'rejected' => DB::table('pending_approvals')->where('status', 'rejected')->count(),
        ];

        return Inertia::render('Admin/Approvals', [
            'approvals' => $approvals,
            'filters' => $request->only('status'),
            'stats' => $stats,
        ]);
    }

    public function review(Request $request, $id)
    {
        $request->validate([
            'action' => 'required|in:approve,reject',
            'note' => 'nullable|string|max:500',
        ]);

        DB::table('pending_approvals')->where('id', $id)->update([
            'status' => $request->action === 'approve' ? 'approved' : 'rejected',
            'reviewed_by' => auth()->id(),
            'review_note' => $request->note,
            'reviewed_at' => now(),
            'updated_at' => now(),
        ]);

        AdminActivityLog::log("approval.{$request->action}", 'approval', $id, ['note' => $request->note]);
        return back()->with('success', $request->action === 'approve' ? 'تمت الموافقة' : 'تم الرفض');
    }
}
