<?php
namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class FrozenAccountController extends Controller
{
    public function index()
    {
        $frozen = DB::table('frozen_accounts')
            ->join('users', 'frozen_accounts.user_id', '=', 'users.id')
            ->select('frozen_accounts.*', 'users.full_name as user_name', 'users.email as user_email')
            ->orderBy('frozen_accounts.created_at', 'desc')
            ->limit(100)
            ->get();

        $activeFrozen = DB::table('users')->where('status', 'frozen')->count();

        return Inertia::render('Admin/FrozenAccounts', [
            'history' => $frozen,
            'activeFrozen' => $activeFrozen,
        ]);
    }

    public function freeze(Request $request)
    {
        $request->validate(['user_id' => 'required|exists:users,id', 'reason' => 'required|string|max:255']);

        DB::table('users')->where('id', $request->user_id)->update(['status' => 'frozen']);

        DB::table('frozen_accounts')->insert([
            'user_id' => $request->user_id,
            'action' => 'freeze',
            'reason' => $request->reason,
            'notes' => $request->notes,
            'admin_id' => auth()->id(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return back()->with('success', 'تم تجميد الحساب');
    }

    public function unfreeze(Request $request, $userId)
    {
        DB::table('users')->where('id', $userId)->update(['status' => 'active']);

        DB::table('frozen_accounts')->insert([
            'user_id' => $userId,
            'action' => 'unfreeze',
            'reason' => $request->reason ?? 'Admin unfreeze',
            'admin_id' => auth()->id(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return back()->with('success', 'تم فك التجميد');
    }
}
