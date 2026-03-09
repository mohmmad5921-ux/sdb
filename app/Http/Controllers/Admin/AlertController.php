<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class AlertController extends Controller
{
    public function index(Request $request)
    {
        $query = DB::table('smart_alerts');

        if ($request->severity) {
            $query->where('severity', $request->severity);
        }
        if ($request->status === 'unread') {
            $query->where('read', false);
        }

        $alerts = $query->orderBy('created_at', 'desc')->limit(100)->get();

        $stats = [
            'total' => DB::table('smart_alerts')->count(),
            'unread' => DB::table('smart_alerts')->where('read', false)->count(),
            'critical' => DB::table('smart_alerts')->where('severity', 'critical')->where('read', false)->count(),
            'today' => DB::table('smart_alerts')->whereDate('created_at', today())->count(),
        ];

        return Inertia::render('Admin/Alerts', [
            'alerts' => $alerts,
            'stats' => $stats,
        ]);
    }

    public function markRead($id)
    {
        DB::table('smart_alerts')->where('id', $id)->update(['read' => true]);
        return back();
    }

    public function resolve(Request $request, $id)
    {
        DB::table('smart_alerts')->where('id', $id)->update([
            'read' => true,
            'resolved_by' => auth()->id(),
            'resolved_at' => now(),
        ]);
        return back()->with('success', 'تم حل التنبيه');
    }
}
