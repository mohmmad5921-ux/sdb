<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class TaskController extends Controller
{
    public function index(Request $request)
    {
        $query = DB::table('admin_tasks')
            ->leftJoin('users as assignee', 'admin_tasks.assigned_to', '=', 'assignee.id')
            ->leftJoin('users as creator', 'admin_tasks.created_by', '=', 'creator.id')
            ->select('admin_tasks.*', 'assignee.name as assignee_name', 'creator.name as creator_name');
        if ($request->status)
            $query->where('admin_tasks.status', $request->status);
        $tasks = $query->orderByRaw("FIELD(priority,'urgent','high','medium','low')")->orderBy('due_date')->limit(100)->get();
        $admins = DB::table('users')->where('role', 'admin')->select('id', 'name')->get();
        return Inertia::render('Admin/Tasks', ['tasks' => $tasks, 'admins' => $admins, 'filter' => $request->status ?? 'all']);
    }

    public function store(Request $request)
    {
        $request->validate(['title' => 'required']);
        DB::table('admin_tasks')->insert([...$request->only('title', 'description', 'assigned_to', 'priority', 'category', 'related_user_id', 'due_date'), 'created_by' => auth()->id(), 'status' => 'pending', 'created_at' => now(), 'updated_at' => now()]);
        return back()->with('success', 'تم إنشاء المهمة');
    }

    public function updateStatus(Request $request, $id)
    {
        DB::table('admin_tasks')->where('id', $id)->update(['status' => $request->status, 'completed_at' => $request->status === 'completed' ? now() : null, 'updated_at' => now()]);
        return back();
    }
}
