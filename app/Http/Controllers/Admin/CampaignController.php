<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class CampaignController extends Controller
{
    public function index()
    {
        $campaigns = DB::table('email_campaigns')
            ->join('users', 'email_campaigns.created_by', '=', 'users.id')
            ->select('email_campaigns.*', 'users.full_name as creator_name')
            ->orderBy('email_campaigns.created_at', 'desc')->get();
        return Inertia::render('Admin/Campaigns', ['campaigns' => $campaigns]);
    }

    public function store(Request $request)
    {
        $request->validate(['name' => 'required', 'subject' => 'required', 'body' => 'required']);
        $count = DB::table('users')->where('role', '!=', 'admin')->count();
        DB::table('email_campaigns')->insert([...$request->only('name', 'subject', 'body', 'target_segment', 'scheduled_at'), 'recipients_count' => $count, 'status' => 'draft', 'created_by' => auth()->id(), 'created_at' => now(), 'updated_at' => now()]);
        return back()->with('success', 'تم إنشاء الحملة');
    }
}
