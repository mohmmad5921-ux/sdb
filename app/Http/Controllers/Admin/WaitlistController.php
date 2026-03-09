<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\WaitlistEmail;
use App\Models\Preregistration;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Carbon\Carbon;

class WaitlistController extends Controller
{
    public function index(Request $request)
    {
        $tab = $request->get('tab', 'waitlist');
        $search = $request->get('search', '');
        $dateFrom = $request->get('from');
        $dateTo = $request->get('to');
        $source = $request->get('source');

        // Waitlist
        $waitlistQuery = WaitlistEmail::query()->orderByDesc('created_at');
        if ($search)
            $waitlistQuery->where('email', 'like', "%$search%");
        if ($dateFrom)
            $waitlistQuery->whereDate('created_at', '>=', $dateFrom);
        if ($dateTo)
            $waitlistQuery->whereDate('created_at', '<=', $dateTo);
        if ($source)
            $waitlistQuery->where('source', $source);

        // Preregistrations
        $preregQuery = Preregistration::query()->orderByDesc('created_at');
        if ($search)
            $preregQuery->where(function ($q) use ($search) {
                $q->where('email', 'like', "%$search%")
                    ->orWhere('full_name', 'like', "%$search%")
                    ->orWhere('phone', 'like', "%$search%");
            });
        if ($dateFrom)
            $preregQuery->whereDate('created_at', '>=', $dateFrom);
        if ($dateTo)
            $preregQuery->whereDate('created_at', '<=', $dateTo);

        // Stats
        $today = Carbon::today();
        $weekAgo = Carbon::now()->subDays(7);

        return Inertia::render('Admin/Waitlist', [
            'tab' => $tab,
            'filters' => ['search' => $search, 'from' => $dateFrom, 'to' => $dateTo, 'source' => $source],
            'waitlist' => $waitlistQuery->paginate(20)->withQueryString(),
            'preregistrations' => $preregQuery->paginate(20)->withQueryString(),
            'stats' => [
                'waitlist_total' => WaitlistEmail::count(),
                'waitlist_today' => WaitlistEmail::whereDate('created_at', $today)->count(),
                'waitlist_week' => WaitlistEmail::where('created_at', '>=', $weekAgo)->count(),
                'prereg_total' => Preregistration::count(),
                'prereg_today' => Preregistration::whereDate('created_at', $today)->count(),
                'prereg_week' => Preregistration::where('created_at', '>=', $weekAgo)->count(),
            ],
            'sources' => WaitlistEmail::select('source')->distinct()->pluck('source'),
        ]);
    }

    public function destroy(Request $request, $type, $id)
    {
        if ($type === 'waitlist') {
            WaitlistEmail::findOrFail($id)->delete();
        } else {
            Preregistration::findOrFail($id)->delete();
        }
        return back()->with('success', 'تم الحذف بنجاح');
    }

    public function bulkDelete(Request $request)
    {
        $request->validate(['ids' => 'required|array', 'type' => 'required|in:waitlist,prereg']);

        if ($request->type === 'waitlist') {
            WaitlistEmail::whereIn('id', $request->ids)->delete();
        } else {
            Preregistration::whereIn('id', $request->ids)->delete();
        }

        return back()->with('success', 'تم حذف ' . count($request->ids) . ' سجل');
    }
}
