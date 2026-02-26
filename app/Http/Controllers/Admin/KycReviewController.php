<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\KycDocument;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;

class KycReviewController extends Controller
{
    public function index(Request $request)
    {
        $query = KycDocument::with(['user', 'reviewer']);

        if ($request->status && $request->status !== 'all') {
            $query->where('status', $request->status);
        }
        else {
            $query->where('status', 'pending'); // default to pending
        }

        $documents = $query->orderByDesc('created_at')->paginate(20);

        $stats = [
            'pending' => KycDocument::where('status', 'pending')->count(),
            'approved' => KycDocument::where('status', 'approved')->count(),
            'rejected' => KycDocument::where('status', 'rejected')->count(),
        ];

        return Inertia::render('Admin/KycReview', [
            'documents' => $documents,
            'filters' => $request->only('status'),
            'stats' => $stats,
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

        // Check if all required docs are approved → auto-verify user
        $user = $document->user;
        $allApproved = $user->kycDocuments()->where('status', '!=', 'approved')->count() === 0;
        $hasMinDocs = $user->kycDocuments()->where('status', 'approved')->count() >= 2;

        if ($allApproved && $hasMinDocs) {
            $user->update(['kyc_status' => 'verified']);
        }
        elseif ($request->action === 'reject') {
            $user->update(['kyc_status' => 'pending']); // keep pending if rejected
        }

        // Audit log
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

        $msg = $request->action === 'approve' ? 'تم اعتماد المستند' : 'تم رفض المستند';
        return back()->with('success', $msg);
    }

    /**
     * View/download a KYC document
     */
    public function viewDocument(KycDocument $document)
    {
        $path = storage_path("app/public/{$document->file_path}");
        if (!file_exists($path)) {
            abort(404);
        }
        return response()->file($path);
    }
}