<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class EmailTemplateController extends Controller
{
    public function index()
    {
        $templates = DB::table('email_templates')->orderBy('type')->get();
        return Inertia::render('Admin/EmailTemplates', ['templates' => $templates]);
    }

    public function update(Request $request, $id)
    {
        DB::table('email_templates')->where('id', $id)->update([
            'subject_en' => $request->subject_en,
            'subject_ar' => $request->subject_ar,
            'body_en' => $request->body_en,
            'body_ar' => $request->body_ar,
            'active' => $request->boolean('active'),
            'updated_at' => now(),
        ]);
        return back()->with('success', 'تم التحديث');
    }

    public function store(Request $request)
    {
        $request->validate(['name' => 'required', 'slug' => 'required|unique:email_templates']);
        DB::table('email_templates')->insert([...$request->only('name', 'slug', 'subject_en', 'subject_ar', 'body_en', 'body_ar', 'type'), 'active' => true, 'created_at' => now(), 'updated_at' => now()]);
        return back()->with('success', 'تم الإنشاء');
    }
}
