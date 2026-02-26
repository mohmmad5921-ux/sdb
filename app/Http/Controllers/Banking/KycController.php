<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\KycDocument;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class KycController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        $documents = $user->kycDocuments()->orderByDesc('created_at')->get();

        return Inertia::render('Banking/Kyc', [
            'documents' => $documents,
            'kycStatus' => $user->kyc_status,
            'requiredDocuments' => [
                ['type' => 'id_front', 'label' => 'صورة الهوية - الوجه الأمامي', 'label_en' => 'ID Card - Front'],
                ['type' => 'id_back', 'label' => 'صورة الهوية - الوجه الخلفي', 'label_en' => 'ID Card - Back'],
                ['type' => 'selfie', 'label' => 'صورة شخصية (سيلفي)', 'label_en' => 'Selfie with ID'],
                ['type' => 'proof_of_address', 'label' => 'إثبات عنوان السكن', 'label_en' => 'Proof of Address'],
            ],
        ]);
    }

    public function upload(Request $request)
    {
        $request->validate([
            'document_type' => 'required|in:id_front,id_back,selfie,proof_of_address,passport',
            'file' => 'required|file|mimes:jpg,jpeg,png,pdf|max:5120', // 5MB
        ]);

        $user = auth()->user();
        $file = $request->file('file');
        $path = $file->store("kyc/{$user->id}", 'public');

        // Remove existing doc of same type if re-uploading
        $existing = $user->kycDocuments()->where('document_type', $request->document_type)->first();
        if ($existing) {
            Storage::disk('public')->delete($existing->file_path);
            $existing->delete();
        }

        KycDocument::create([
            'user_id' => $user->id,
            'document_type' => $request->document_type,
            'file_path' => $path,
            'original_filename' => $file->getClientOriginalName(),
            'status' => 'pending',
        ]);

        // Update user KYC status to pending if not already
        if ($user->kyc_status === 'unverified') {
            $user->update(['kyc_status' => 'pending']);
        }

        return back()->with('success', 'تم رفع المستند بنجاح! سيتم مراجعته قريباً.');
    }

    public function delete($id)
    {
        $doc = auth()->user()->kycDocuments()->findOrFail($id);

        if ($doc->status === 'approved') {
            return back()->withErrors(['file' => 'لا يمكن حذف مستند معتمد']);
        }

        Storage::disk('public')->delete($doc->file_path);
        $doc->delete();

        return back()->with('success', 'تم حذف المستند');
    }
}