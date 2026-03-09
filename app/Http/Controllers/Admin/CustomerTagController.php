<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class CustomerTagController extends Controller
{
    public function index()
    {
        $tags = DB::table('customer_tags')->get()->map(function ($tag) {
            $tag->user_count = DB::table('customer_tag_user')->where('tag_id', $tag->id)->count();
            return $tag;
        });
        return Inertia::render('Admin/CustomerTags', ['tags' => $tags]);
    }

    public function store(Request $request)
    {
        $request->validate(['name' => 'required']);
        DB::table('customer_tags')->insert(['name' => $request->name, 'color' => $request->color ?? '#2563eb', 'description' => $request->description, 'created_at' => now(), 'updated_at' => now()]);
        return back()->with('success', 'تم إنشاء التاغ');
    }

    public function assignTag(Request $request)
    {
        DB::table('customer_tag_user')->updateOrInsert(['user_id' => $request->user_id, 'tag_id' => $request->tag_id], ['created_at' => now(), 'updated_at' => now()]);
        return back();
    }

    public function removeTag($userId, $tagId)
    {
        DB::table('customer_tag_user')->where('user_id', $userId)->where('tag_id', $tagId)->delete();
        return back();
    }
}
