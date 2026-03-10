<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class CardController extends Controller
{
    public function index(Request $request)
    {
        $query = DB::table('cards')
            ->leftJoin('users', 'cards.user_id', '=', 'users.id')
            ->select('cards.*', 'users.full_name as user_name', 'users.email as user_email');

        if ($request->search) {
            $s = '%'.$request->search.'%';
            $query->where(function ($q) use ($s) {
                $q->where('cards.card_number', 'like', $s)
                    ->orWhere('users.full_name', 'like', $s)
                    ->orWhere('users.email', 'like', $s);
            });
        }
        if ($request->status) $query->where('cards.status', $request->status);
        if ($request->type) $query->where('cards.card_type', $request->type);

        $cards = $query->orderBy('cards.created_at', 'desc')->paginate(20)->withQueryString();

        $stats = [
            'total' => DB::table('cards')->count(),
            'active' => DB::table('cards')->where('status', 'active')->count(),
            'frozen' => DB::table('cards')->where('status', 'frozen')->count(),
            'blocked' => DB::table('cards')->where('status', 'blocked')->count(),
        ];

        return Inertia::render('Admin/Cards', [
            'cards' => $cards,
            'filters' => $request->only(['search', 'status', 'type']),
            'stats' => $stats,
        ]);
    }

    public function freeze($id)
    {
        DB::table('cards')->where('id', $id)->update(['status' => 'frozen', 'updated_at' => now()]);
        return back()->with('success', 'تم تجميد البطاقة');
    }

    public function unfreeze($id)
    {
        DB::table('cards')->where('id', $id)->update(['status' => 'active', 'updated_at' => now()]);
        return back()->with('success', 'تم إلغاء تجميد البطاقة');
    }

    public function block($id)
    {
        DB::table('cards')->where('id', $id)->update(['status' => 'blocked', 'updated_at' => now()]);
        return back()->with('success', 'تم حظر البطاقة');
    }
}
