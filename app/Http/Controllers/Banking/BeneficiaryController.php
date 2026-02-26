<?php

namespace App\Http\Controllers\Banking;

use App\Http\Controllers\Controller;
use App\Models\Beneficiary;
use Illuminate\Http\Request;
use Inertia\Inertia;

class BeneficiaryController extends Controller
{
    public function index()
    {
        $beneficiaries = auth()->user()->beneficiaries()
            ->orderByDesc('is_favorite')
            ->orderBy('name')
            ->get();

        return Inertia::render('Banking/Beneficiaries', [
            'beneficiaries' => $beneficiaries,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'iban' => 'required|string|max:34',
            'bank_name' => 'nullable|string|max:255',
            'swift_code' => 'nullable|string|max:11',
            'country' => 'nullable|string|max:100',
        ]);

        auth()->user()->beneficiaries()->create($request->only(['name', 'iban', 'bank_name', 'swift_code', 'country']));

        return back()->with('success', 'تم حفظ المستفيد بنجاح');
    }

    public function update(Request $request, $id)
    {
        $beneficiary = auth()->user()->beneficiaries()->findOrFail($id);
        $beneficiary->update($request->only(['name', 'iban', 'bank_name', 'swift_code', 'country']));

        return back()->with('success', 'تم تحديث المستفيد');
    }

    public function destroy($id)
    {
        auth()->user()->beneficiaries()->findOrFail($id)->delete();
        return back()->with('success', 'تم حذف المستفيد');
    }

    public function toggleFavorite($id)
    {
        $b = auth()->user()->beneficiaries()->findOrFail($id);
        $b->update(['is_favorite' => !$b->is_favorite]);
        return back();
    }
}