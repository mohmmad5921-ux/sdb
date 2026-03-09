<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class CustomerMapController extends Controller
{
    public function index()
    {
        // Country distribution
        $countries = DB::table('users')
            ->where('role', '!=', 'admin')
            ->selectRaw("COALESCE(country, 'Unknown') as country, COUNT(*) as count")
            ->groupBy('country')
            ->orderBy('count', 'desc')
            ->get();

        $totalUsers = DB::table('users')->where('role', '!=', 'admin')->count();

        // City distribution (top 20)
        $cities = DB::table('users')
            ->where('role', '!=', 'admin')
            ->whereNotNull('city')
            ->selectRaw("city, country, COUNT(*) as count")
            ->groupBy('city', 'country')
            ->orderBy('count', 'desc')
            ->limit(20)
            ->get();

        // Registration by country last 30 days
        $recentByCountry = DB::table('users')
            ->where('role', '!=', 'admin')
            ->where('created_at', '>=', now()->subDays(30))
            ->selectRaw("COALESCE(country, 'Unknown') as country, COUNT(*) as count")
            ->groupBy('country')
            ->orderBy('count', 'desc')
            ->limit(10)
            ->get();

        return Inertia::render('Admin/CustomerMap', [
            'countries' => $countries,
            'cities' => $cities,
            'recentByCountry' => $recentByCountry,
            'totalUsers' => $totalUsers,
        ]);
    }
}
