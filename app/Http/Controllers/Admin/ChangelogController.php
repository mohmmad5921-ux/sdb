<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class ChangelogController extends Controller
{
    public function index(Request $request)
    {
        $query = DB::table('system_changelog')
            ->join('users', 'system_changelog.admin_id', '=', 'users.id')
            ->select('system_changelog.*', 'users.full_name as admin_name');

        if ($request->category) {
            $query->where('system_changelog.category', $request->category);
        }

        $logs = $query->orderBy('system_changelog.created_at', 'desc')->limit(200)->get();

        $categories = DB::table('system_changelog')->distinct()->pluck('category');

        return Inertia::render('Admin/Changelog', [
            'logs' => $logs,
            'categories' => $categories,
            'filter' => $request->category ?? 'all',
        ]);
    }
}
