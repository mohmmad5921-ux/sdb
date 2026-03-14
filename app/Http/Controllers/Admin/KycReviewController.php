<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\KycDocument;
use App\Models\AdminActivityLog;
use App\Models\Notification;
use App\Models\User;
use App\Services\FcmService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
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

        // Build user queue with enhanced data
        $userQueue = [];
        if (!$request->status || $request->status === 'pending') {
            $pendingDocs = KycDocument::with('user')
                ->where('status', 'pending')
                ->orderBy('created_at')
                ->get()
                ->groupBy('user_id');

            foreach ($pendingDocs as $userId => $docs) {
                $user = $docs->first()->user;
                if (!$user) continue;

                // Detect duplicate/suspicious accounts
                $duplicates = $this->findDuplicates($user);

                $userQueue[] = [
                    'user_id' => $userId,
                    'user_name' => $user->full_name,
                    'user_email' => $user->email,
                    'user_phone' => $user->phone,
                    'user_status' => $user->status,
                    'kyc_status' => $user->kyc_status,
                    'nationality' => $user->nationality,
                    'country' => $user->country,
                    'city' => $user->city,
                    'address' => $user->address,
                    'postal_code' => $user->postal_code,
                    'date_of_birth' => $user->date_of_birth?->format('Y-m-d'),
                    'document_number' => $user->document_number,
                    'document_type' => $user->document_type,
                    'document_expiry' => $user->document_expiry?->format('Y-m-d'),
                    'sex' => $user->sex,
                    'registered_at' => $user->created_at?->toDateTimeString(),
                    'registered_ago' => $user->created_at?->diffForHumans(),
                    'last_login' => $user->last_login_at ? Carbon::parse($user->last_login_at)->diffForHumans() : null,
                    'preferred_language' => $user->preferred_language ?? 'ar',
                    'docs_count' => $docs->count(),
                    'doc_types' => $docs->pluck('document_type')->toArray(),
                    'documents_detail' => $docs->map(fn($d) => [
                        'id' => $d->id,
                        'type' => $d->document_type,
                        'status' => $d->status,
                        'created' => $d->created_at?->diffForHumans(),
                    ])->values()->toArray(),
                    'new_since_1h' => $docs->filter(fn($d) => $d->created_at && $d->created_at->gte(Carbon::now()->subHour()))->count(),
                    'oldest' => $docs->min('created_at'),
                    'waiting_text' => Carbon::parse($docs->min('created_at'))->diffForHumans(),
                    'hours_waiting' => Carbon::parse($docs->min('created_at'))->diffInHours(now()),
                    'is_overdue' => Carbon::parse($docs->min('created_at'))->diffInHours(now()) > 48,
                    'last_message' => Notification::where('user_id', $userId)
                        ->where('type', 'system')
                        ->orderByDesc('created_at')
                        ->first(['title', 'body', 'created_at'])?->toArray(),
                    'duplicates' => $duplicates,
                    'has_alerts' => count($duplicates) > 0,
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

    /**
     * Find duplicate or previously suspended accounts
     */
    private function findDuplicates(User $user): array
    {
        $alerts = [];

        // Check for same name (different account)
        $nameDups = User::where('id', '!=', $user->id)
            ->where('full_name', 'LIKE', $user->full_name)
            ->get();
        foreach ($nameDups as $dup) {
            $alerts[] = [
                'type' => $dup->status === 'suspended' ? 'suspended' : ($dup->status === 'closed' ? 'closed' : 'duplicate_name'),
                'user_id' => $dup->id,
                'full_name' => $dup->full_name,
                'email' => $dup->email,
                'status' => $dup->status,
                'message' => $dup->status === 'suspended'
                    ? "⚠️ حساب موقوف بنفس الاسم: {$dup->email}"
                    : ($dup->status === 'closed'
                        ? "🔒 حساب مغلق بنفس الاسم: {$dup->email}"
                        : "👤 حساب آخر بنفس الاسم: {$dup->email}"),
            ];
        }

        // Check for same phone
        if ($user->phone) {
            $phoneDups = User::where('id', '!=', $user->id)
                ->where('phone', $user->phone)
                ->get();
            foreach ($phoneDups as $dup) {
                $alerts[] = [
                    'type' => $dup->status === 'suspended' ? 'suspended' : 'duplicate_phone',
                    'user_id' => $dup->id,
                    'full_name' => $dup->full_name,
                    'email' => $dup->email,
                    'status' => $dup->status,
                    'message' => "📱 نفس رقم الهاتف مسجل لـ: {$dup->full_name} ({$dup->email})",
                ];
            }
        }

        // Check for similar name (partial match)
        $nameParts = explode(' ', $user->full_name);
        if (count($nameParts) >= 2) {
            $firstName = $nameParts[0];
            $lastName = end($nameParts);
            $similarUsers = User::where('id', '!=', $user->id)
                ->whereIn('status', ['suspended', 'closed'])
                ->where(function ($q) use ($firstName, $lastName) {
                    $q->where('full_name', 'LIKE', "%{$firstName}%")
                      ->orWhere('full_name', 'LIKE', "%{$lastName}%");
                })
                ->limit(5)
                ->get();
            foreach ($similarUsers as $sim) {
                if (!collect($alerts)->contains('user_id', $sim->id)) {
                    $alerts[] = [
                        'type' => 'similar_suspended',
                        'user_id' => $sim->id,
                        'full_name' => $sim->full_name,
                        'email' => $sim->email,
                        'status' => $sim->status,
                        'message' => "🔍 اسم مشابه لحساب {$sim->status}: {$sim->full_name}",
                    ];
                }
            }
        }

        return $alerts;
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
            $user->update(['kyc_status' => 'verified', 'status' => 'active']);

            // Send approval notification
            Notification::create([
                'user_id' => $user->id,
                'title' => '✅ تم التحقق من هويتك',
                'body' => 'تمت الموافقة على مستنداتك. يرجى اختيار باقة الاشتراك لتفعيل حسابك.',
                'type' => 'system',
            ]);

            // Send push notification
            FcmService::sendToUser($user->id, '✅ تم التحقق من هويتك', 'يرجى اختيار باقة الاشتراك لتفعيل حسابك.');
        } elseif ($request->action === 'reject') {
            $user->update(['kyc_status' => 'pending']);

            // Send rejection notification
            Notification::create([
                'user_id' => $user->id,
                'title' => '❌ تم رفض المستند',
                'body' => 'السبب: ' . ($request->rejection_reason ?? 'غير محدد') . '. يرجى إعادة رفع المستندات.',
                'type' => 'system',
            ]);
        }

        AdminActivityLog::log("kyc.{$request->action}", 'kyc_document', $document->id, [
            'document_type' => $document->document_type,
            'customer' => $user->full_name,
            'reason' => $request->rejection_reason,
        ]);

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
        } catch (\Exception $e) {}

        $msg = $request->action === 'approve' ? 'تم اعتماد المستند' : 'تم رفض المستند';
        return back()->with('success', $msg);
    }

    /**
     * Send a quick notification to the KYC applicant
     */
    public function sendQuickMessage(Request $request, User $user)
    {
        $request->validate([
            'message_type' => 'required|in:approved,request_docs,custom',
            'custom_message' => 'nullable|string|max:500',
            'doc_types' => 'nullable|array',
        ]);

        $lang = $user->preferred_language ?? 'ar';
        $isAr = $lang === 'ar';

        // Build document types list for request_docs
        $docTypeNames = [
            'id_front' => $isAr ? 'الهوية (أمام)' : 'ID Card (Front)',
            'id_back' => $isAr ? 'الهوية (خلف)' : 'ID Card (Back)',
            'passport' => $isAr ? 'جواز السفر' : 'Passport',
            'selfie' => $isAr ? 'صورة شخصية' : 'Selfie Photo',
            'proof_of_address' => $isAr ? 'إثبات عنوان' : 'Proof of Address',
        ];

        $docList = '';
        if ($request->message_type === 'request_docs' && $request->doc_types) {
            $names = array_map(fn($t) => $docTypeNames[$t] ?? $t, $request->doc_types);
            $docList = "\n" . implode("\n", array_map(fn($n) => "• {$n}", $names));
        }

        $messages = [
            'approved' => [
                'title' => $isAr ? '✅ تمت الموافقة على حسابك' : '✅ Your Account Has Been Approved',
                'body' => $isAr
                    ? 'مرحباً! تم التحقق من هويتك بنجاح. يمكنك الآن استخدام جميع خدمات SDB Bank.'
                    : 'Hello! Your identity has been verified. You can now use all SDB Bank services.',
            ],
            'request_docs' => [
                'title' => $isAr ? '📄 مطلوب مستندات إضافية' : '📄 Additional Documents Required',
                'body' => ($isAr
                    ? 'نحتاج إلى مستندات إضافية لإكمال عملية التحقق. يرجى رفع المستندات التالية:'
                    : 'We need additional documents to complete verification. Please upload the following:')
                    . $docList,
            ],
            'custom' => [
                'title' => $isAr ? '📫 رسالة من SDB Bank' : '📫 Message from SDB Bank',
                'body' => $request->custom_message ?? '',
            ],
        ];

        $msg = $messages[$request->message_type] ?? $messages['custom'];

        Notification::create([
            'user_id' => $user->id,
            'title' => $msg['title'],
            'body' => $msg['body'],
            'type' => 'system',
        ]);

        // Send email notification
        if ($user->email) {
            try {
                Mail::send([], [], function ($mail) use ($user, $msg) {
                    $htmlBody = '<div style="font-family:Arial,sans-serif;direction:rtl;text-align:right;max-width:600px;margin:0 auto;padding:20px;">'
                        . '<div style="background:#0f172a;border-radius:12px;padding:24px;margin-bottom:20px;">'
                        . '<h1 style="color:#fff;font-size:20px;margin:0;">SDB Bank</h1>'
                        . '</div>'
                        . '<h2 style="color:#0f172a;font-size:18px;">' . e($msg['title']) . '</h2>'
                        . '<p style="color:#334155;font-size:14px;line-height:1.8;white-space:pre-line;">' . e($msg['body']) . '</p>'
                        . '<hr style="border:none;border-top:1px solid #e2e8f0;margin:20px 0;">'
                        . '<p style="color:#94a3b8;font-size:12px;">SDB Bank — Digital Banking</p>'
                        . '</div>';
                    $mail->to($user->email)
                         ->subject($msg['title'])
                         ->html($htmlBody);
                });
            } catch (\Exception $e) {
                // Log email failure but don't block the notification
                \Log::warning('KYC email failed for user ' . $user->id . ': ' . $e->getMessage());
            }
        }

        // Send push notification
        FcmService::sendToUser($user->id, $msg['title'], $msg['body']);

        AdminActivityLog::log('kyc.message', 'user', $user->id, [
            'message_type' => $request->message_type,
            'doc_types' => $request->doc_types,
            'customer' => $user->full_name,
        ]);

        return back()->with('success', 'تم إرسال الرسالة إلى ' . $user->full_name);
    }

    /**
     * Approve all pending documents for a user at once
     */
    public function approveAll(Request $request, User $user)
    {
        $pending = $user->kycDocuments()->where('status', 'pending')->get();

        foreach ($pending as $doc) {
            $doc->update([
                'status' => 'approved',
                'reviewed_by' => auth()->id(),
                'reviewed_at' => now(),
            ]);
        }

        $user->update(['kyc_status' => 'verified', 'status' => 'subscription_required']);

        Notification::create([
            'user_id' => $user->id,
            'title' => '✅ تم التحقق من هويتك',
            'body' => 'تمت الموافقة على جميع مستنداتك. يرجى اختيار باقة الاشتراك لتفعيل حسابك.',
            'type' => 'system',
        ]);

        FcmService::sendToUser($user->id, '✅ تم التحقق من هويتك', 'يرجى اختيار باقة الاشتراك لتفعيل حسابك.');

        AdminActivityLog::log('kyc.approve_all', 'user', $user->id, [
            'docs_count' => $pending->count(),
            'customer' => $user->full_name,
        ]);

        return back()->with('success', "تم اعتماد جميع مستندات {$user->full_name} ✅");
    }

    public function viewDocument(KycDocument $document)
    {
        // Laravel 11 stores in storage/app/private/ by default
        $path = storage_path("app/private/{$document->file_path}");
        if (!file_exists($path)) {
            // Fallback to old path
            $path = storage_path("app/{$document->file_path}");
        }
        if (!file_exists($path)) {
            abort(404, 'Document file not found');
        }
        return response()->file($path);
    }
}