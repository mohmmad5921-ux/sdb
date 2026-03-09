<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class CmsController extends Controller
{
    public function index()
    {
        $contents = DB::table('cms_contents')->orderBy('section')->orderBy('key')->get();
        $sections = $contents->groupBy('section');
        return Inertia::render('Admin/Cms', ['sections' => $sections, 'contents' => $contents]);
    }

    public function update(Request $request, $id)
    {
        $request->validate(['value_en' => 'nullable|string', 'value_ar' => 'nullable|string']);

        $old = DB::table('cms_contents')->find($id);
        DB::table('cms_contents')->where('id', $id)->update([
            'value_en' => $request->value_en,
            'value_ar' => $request->value_ar,
            'updated_at' => now(),
        ]);

        // Log change
        DB::table('system_changelog')->insert([
            'admin_id' => auth()->id(),
            'category' => 'cms',
            'action' => 'update',
            'target' => $old->key,
            'old_value' => json_encode(['en' => $old->value_en, 'ar' => $old->value_ar]),
            'new_value' => json_encode(['en' => $request->value_en, 'ar' => $request->value_ar]),
            'ip_address' => $request->ip(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return back()->with('success', 'تم التحديث');
    }
}
