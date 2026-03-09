<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\KycDocument;
use App\Models\AdminActivityLog;
use App\Models\User;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Inertia\Inertia;

class KycReviewController extends Controller
{
    public function index(Request $request)
    {
        $query = KycDocument::with(['user', 'reviewer']);

        if ($request->status && $request->status !== 'all') {
            $query->where('status', $request->status);
        } else {
            $query->where('status', 'pending');
        }

        $documents = $query->orderByDesc('created_at')->paginate(20);

        // Add time elapsed to each document
        $documents->getCollection()->transform(function ($doc) {
            $doc->hours_elapsed = Carbon::parse($doc->created_at)->diffInHours(now());
            $doc->time_elapsed_text = Carbon::parse($doc->created_at)->diffForHumans();
            return $doc;
        });

        $stats = [
            'pending' => KycDocument::where('status', 'pending')->count(),
            'approved' => KycDocument::where('status', 'approved')->count(),
            'rejected' => KycDocument::where('status', 'rejected')->count(),
            'overdue' => KycDocument::where('status', 'pending')
                ->where('created_at', '<', Carbon::now()->subHours(48))->count(),
        ];

        // Group pending docs by user for the review queue
        $userQueue = [];
        if (!$request->status || $request->status === 'pending') {
            $pendingDocs = KycDocument::with('user')
                ->where('status', 'pending')
                ->orderBy('created_at')
                ->get()
                ->groupBy('user_id');

            foreach ($pendingDocs as $userId => $docs) {
                $user = $docs->first()->user;
                if (!$user)
                    continue;
                $userQueue[] = [
                    'user_id' => $userId,
                    'user_name' => $user->full_name,
                    'user_email' => $user->email,
                    'docs_count' => $docs->count(),
                    'doc_types' => $docs->pluck('document_type')->toArray(),
                    'oldest' => $docs->min('created_at'),
                    'hours_waiting' => Carbon::parse($docs->min('created_at'))->diffInHours(now()),
                    'is_overdue' => Carbon::parse($docs->min('created_at'))->diffInHours(now()) > 48,
                ];
            }
            usort($userQueue, fn($a, $b) => $b['hours_waiting'] - $a['hours_waiting']);
        }

        return Inertia::render('Admin/KycReview', [
            'documents' => $documents,
            'filters' => $request->only('status'),
            'stats' => $stats,
            'userQueue' => $userQueue,
        ]);
    }

    public function review(Request $request, KycDocument $document)
    {
        $request->validate([
            'action' => 'required|in:approve,reject',
            'rejection_reason' => 'required_if:action,reject|nullable|string|max:500',
        ]);

        $document->update([
            'status' => $request->action === 'approve' ? 'approved' : 'rejected',
            'rejection_reason' => $request->action === 'reject' ? $request->rejection_reason : null,
            'reviewed_by' => auth()->id(),
            'reviewed_at' => now(),
        ]);

        $user = $document->user;
        $allApproved = $user->kycDocuments()->where('status', '!=', 'approved')->count() === 0;
        $hasMinDocs = $user->kycDocuments()->where('status', 'approved')->count() >= 2;

        if ($allApproved && $hasMinDocs) {
            $user->update(['kyc_status' => 'verified']);
        } elseif ($request->action === 'reject') {
            $user->update(['kyc_status' => 'pending']);
        }

        // Activity log
        AdminActivityLog::log("kyc.{$request->action}", 'kyc_document', $document->id, [
            'document_type' => $document->document_type,
            'customer' => $user->full_name,
            'reason' => $request->rejection_reason,
        ]);

        // Legacy audit log
        try {
            AuditLog::create([
                'user_id' => auth()->id(),
                'action' => "kyc_{$request->action}",
                'entity_type' => 'kyc_document',
                'entity_id' => $document->id,
                'details' => [
                    'document_type' => $document->document_type,
                    'customer' => $user->full_name,
                    'reason' => $request->rejection_reason,
                ],
            ]);
        } catch (\Exception $e) {
        }

        $msg = $request->action === 'approve' ? 'تم اعتماد المستند' : 'تم رفض المستند';
        return back()->with('success', $msg);
    }

    public function viewDocument(KycDocument $document)
    {
        $path = storage_path("app/{$document->file_path}");
        if (!file_exists($path)) {
            abort(404, 'Document file not found');
        }
        return response()->file($path);
    }
}