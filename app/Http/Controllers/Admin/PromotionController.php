<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class PromotionController extends Controller
{
    public function index()
    {
        $promos = DB::table('promotions')->orderBy('created_at', 'desc')->get();
        return Inertia::render('Admin/Promotions', ['promotions' => $promos]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:100',
            'code' => 'required|string|max:30|unique:promotions',
            'type' => 'required|in:percentage,fixed,free_transfer',
            'value' => 'required|numeric|min:0',
            'applies_to' => 'required|string',
            'max_uses' => 'nullable|integer|min:1',
            'starts_at' => 'nullable|date',
            'expires_at' => 'nullable|date',
        ]);

        DB::table('promotions')->insert([
            ...$request->only('name', 'code', 'type', 'value', 'applies_to', 'max_uses', 'starts_at', 'expires_at'),
            'active' => true,
            'used_count' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return back()->with('success', 'تم إنشاء العرض');
    }

    public function toggle($id)
    {
        $promo = DB::table('promotions')->find($id);
        DB::table('promotions')->where('id', $id)->update(['active' => !$promo->active, 'updated_at' => now()]);
        return back();
    }

    public function destroy($id)
    {
        DB::table('promotions')->where('id', $id)->delete();
        return back()->with('success', 'تم حذف العرض');
    }
}
