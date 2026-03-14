<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Inertia\Inertia;
use App\Services\FcmService;

class RemittanceController extends Controller
{
    /**
     * List all governorates
     */
    public function governorates()
    {
        $governorates = DB::table('governorates')
            ->where('is_active', true)
            ->select('id', 'name_ar', 'name_en', 'code')
            ->orderBy('name_ar')
            ->get();

        return response()->json(['governorates' => $governorates]);
    }

    /**
     * Districts in a governorate
     */
    public function districts($governorateId)
    {
        $districts = DB::table('districts')
            ->where('governorate_id', $governorateId)
            ->where('is_active', true)
            ->select('id', 'name_ar', 'name_en')
            ->orderBy('name_ar')
            ->get();

        return response()->json(['districts' => $districts]);
    }

    /**
     * Agents in a district
     */
    public function agents($districtId)
    {
        $agents = DB::table('agents')
            ->where('district_id', $districtId)
            ->where('is_active', true)
            ->select('id', 'name_ar', 'name_en', 'phone', 'address_ar', 'address_en')
            ->orderBy('name_ar')
            ->get();

        return response()->json(['agents' => $agents]);
    }

    /**
     * Create a new remittance
     */
    public function store(Request $request)
    {
        $request->validate([
            'agent_id' => 'required|exists:agents,id',
            'recipient_name' => 'required|string|max:255',
            'recipient_phone' => 'required|string|max:20',
            'amount' => 'required|numeric|min:1',
            'send_currency' => 'string|max:5',
            'notes' => 'nullable|string|max:500',
        ]);

        // Generate unique notification code (8 digits)
        do {
            $code = str_pad(random_int(10000000, 99999999), 8, '0', STR_PAD_LEFT);
        } while (DB::table('remittances')->where('notification_code', $code)->exists());

        $qrToken = Str::uuid()->toString();

        // Get exchange rate (EUR -> SYP) — using a static rate for now
        $exchangeRate = 14500; // 1 EUR = 14,500 SYP approximately
        $receiveAmount = round($request->amount * $exchangeRate, 0);
        $fee = round($request->amount * 0.02, 2); // 2% fee

        $id = DB::table('remittances')->insertGetId([
            'user_id' => auth()->id(),
            'agent_id' => $request->agent_id,
            'recipient_name' => $request->recipient_name,
            'recipient_phone' => $request->recipient_phone,
            'amount' => $request->amount,
            'send_currency' => $request->send_currency ?? 'EUR',
            'receive_amount' => $receiveAmount,
            'receive_currency' => 'SYP',
            'exchange_rate' => $exchangeRate,
            'fee' => $fee,
            'status' => 'ready',
            'notification_code' => $code,
            'qr_token' => $qrToken,
            'notes' => $request->notes,
            'expires_at' => now()->addDays(7),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'remittance' => [
                'id' => $id,
                'notification_code' => $code,
                'qr_token' => $qrToken,
                'amount' => $request->amount,
                'receive_amount' => $receiveAmount,
                'fee' => $fee,
                'url' => url("/remittance/{$qrToken}"),
            ],
        ]);
    }

    /**
     * Get remittance details (authenticated)
     */
    public function show($id)
    {
        $remittance = DB::table('remittances')
            ->join('agents', 'remittances.agent_id', '=', 'agents.id')
            ->join('districts', 'agents.district_id', '=', 'districts.id')
            ->join('governorates', 'districts.governorate_id', '=', 'governorates.id')
            ->where('remittances.id', $id)
            ->where('remittances.user_id', auth()->id())
            ->select(
                'remittances.*',
                'agents.name_ar as agent_name_ar', 'agents.name_en as agent_name_en',
                'agents.phone as agent_phone', 'agents.address_ar as agent_address',
                'districts.name_ar as district_ar', 'districts.name_en as district_en',
                'governorates.name_ar as governorate_ar', 'governorates.name_en as governorate_en'
            )
            ->first();

        if (!$remittance) {
            return response()->json(['error' => 'Not found'], 404);
        }

        return response()->json(['remittance' => $remittance]);
    }

    /**
     * User's sent remittances
     */
    public function myRemittances()
    {
        $remittances = DB::table('remittances')
            ->join('agents', 'remittances.agent_id', '=', 'agents.id')
            ->join('districts', 'agents.district_id', '=', 'districts.id')
            ->join('governorates', 'districts.governorate_id', '=', 'governorates.id')
            ->where('remittances.user_id', auth()->id())
            ->select(
                'remittances.*',
                'agents.name_ar as agent_name_ar',
                'districts.name_ar as district_ar',
                'governorates.name_ar as governorate_ar'
            )
            ->orderBy('remittances.created_at', 'desc')
            ->limit(50)
            ->get();

        return response()->json(['remittances' => $remittances]);
    }

    /**
     * Verify remittance by notification code (agent use)
     */
    public function verify($code)
    {
        $remittance = DB::table('remittances')
            ->join('agents', 'remittances.agent_id', '=', 'agents.id')
            ->join('districts', 'agents.district_id', '=', 'districts.id')
            ->join('governorates', 'districts.governorate_id', '=', 'governorates.id')
            ->join('users', 'remittances.user_id', '=', 'users.id')
            ->where('remittances.notification_code', $code)
            ->select(
                'remittances.*',
                'users.full_name as sender_name',
                'agents.name_ar as agent_name_ar', 'agents.name_en as agent_name_en',
                'agents.address_ar as agent_address',
                'districts.name_ar as district_ar',
                'governorates.name_ar as governorate_ar'
            )
            ->first();

        if (!$remittance) {
            return response()->json(['error' => 'رمز غير صالح', 'valid' => false], 404);
        }

        if ($remittance->status === 'collected') {
            return response()->json(['error' => 'تم سحب هذه الحوالة مسبقاً', 'valid' => false, 'remittance' => $remittance], 400);
        }

        if ($remittance->status === 'expired' || ($remittance->expires_at && now()->gt($remittance->expires_at))) {
            return response()->json(['error' => 'انتهت صلاحية هذه الحوالة', 'valid' => false], 400);
        }

        return response()->json(['valid' => true, 'remittance' => $remittance]);
    }

    /**
     * Mark remittance as collected (agent use)
     */
    public function collect(Request $request, $id)
    {
        $remittance = DB::table('remittances')->where('id', $id)->first();

        if (!$remittance) {
            return response()->json(['error' => 'Not found'], 404);
        }

        if ($remittance->status === 'collected') {
            return response()->json(['error' => 'Already collected'], 400);
        }

        DB::table('remittances')->where('id', $id)->update([
            'status' => 'collected',
            'collected_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['success' => true, 'message' => 'تم تسليم الحوالة بنجاح']);
    }

    /**
     * Public notification page (Inertia)
     */
    public function notificationPage($qrToken)
    {
        $remittance = DB::table('remittances')
            ->join('agents', 'remittances.agent_id', '=', 'agents.id')
            ->join('districts', 'agents.district_id', '=', 'districts.id')
            ->join('governorates', 'districts.governorate_id', '=', 'governorates.id')
            ->join('users', 'remittances.user_id', '=', 'users.id')
            ->where('remittances.qr_token', $qrToken)
            ->select(
                'remittances.id', 'remittances.recipient_name', 'remittances.recipient_phone',
                'remittances.amount', 'remittances.send_currency', 'remittances.receive_amount',
                'remittances.receive_currency', 'remittances.exchange_rate', 'remittances.fee',
                'remittances.status', 'remittances.notification_code', 'remittances.qr_token',
                'remittances.expires_at', 'remittances.collected_at', 'remittances.created_at',
                'users.full_name as sender_name',
                'agents.name_ar as agent_name_ar', 'agents.name_en as agent_name_en',
                'agents.phone as agent_phone', 'agents.address_ar as agent_address',
                'districts.name_ar as district_ar', 'districts.name_en as district_en',
                'governorates.name_ar as governorate_ar', 'governorates.name_en as governorate_en'
            )
            ->first();

        if (!$remittance) {
            abort(404);
        }

        return Inertia::render('Remittance/Notification', [
            'remittance' => $remittance,
        ]);
    }

    /**
     * Admin: list all remittances
     */
    public function adminIndex()
    {
        $remittances = DB::table('remittances')
            ->join('agents', 'remittances.agent_id', '=', 'agents.id')
            ->join('districts', 'agents.district_id', '=', 'districts.id')
            ->join('governorates', 'districts.governorate_id', '=', 'governorates.id')
            ->join('users', 'remittances.user_id', '=', 'users.id')
            ->select(
                'remittances.*',
                'users.full_name as sender_name', 'users.email as sender_email',
                'agents.name_ar as agent_name_ar', 'agents.name_en as agent_name_en',
                'agents.phone as agent_phone', 'agents.address_ar as agent_address',
                'districts.name_ar as district_ar',
                'governorates.name_ar as governorate_ar'
            )
            ->orderBy('remittances.created_at', 'desc')
            ->get();

        $stats = [
            'total' => DB::table('remittances')->count(),
            'pending' => DB::table('remittances')->where('status', 'ready')->count(),
            'collected' => DB::table('remittances')->where('status', 'collected')->count(),
            'totalAmount' => DB::table('remittances')->where('status', '!=', 'cancelled')->sum('amount'),
            'today' => DB::table('remittances')->whereDate('created_at', today())->count(),
            'thisWeek' => DB::table('remittances')->where('created_at', '>=', now()->startOfWeek())->sum('amount'),
        ];

        return Inertia::render('Admin/Remittances', [
            'remittances' => $remittances,
            'stats' => $stats,
        ]);
    }

    /**
     * Admin: collect remittance on behalf of agent
     */
    public function adminCollect($id)
    {
        $remittance = DB::table('remittances')->where('id', $id)->first();
        if (!$remittance) return back()->with('error', 'حوالة غير موجودة');
        if ($remittance->status === 'collected') return back()->with('error', 'تم سحب هذه الحوالة مسبقاً');

        DB::table('remittances')->where('id', $id)->update([
            'status' => 'collected',
            'collected_at' => now(),
            'updated_at' => now(),
        ]);

        // Push notification to sender
        FcmService::sendToUser($remittance->user_id, '✅ تم تسليم حوالتك', 'تم استلام الحوالة رقم ' . $remittance->notification_code . ' بنجاح من قبل ' . $remittance->recipient_name);

        return back()->with('success', 'تم تسليم الحوالة بنجاح ✅');
    }

    /**
     * Admin: cancel a remittance
     */
    public function adminCancel($id)
    {
        $remittance = DB::table('remittances')->where('id', $id)->first();
        if (!$remittance) return back()->with('error', 'حوالة غير موجودة');
        if ($remittance->status === 'collected') return back()->with('error', 'لا يمكن إلغاء حوالة تم سحبها');

        DB::table('remittances')->where('id', $id)->update([
            'status' => 'cancelled',
            'updated_at' => now(),
        ]);

        // Push notification to sender
        FcmService::sendToUser($remittance->user_id, '❌ تم إلغاء حوالتك', 'تم إلغاء الحوالة رقم ' . $remittance->notification_code . '. يرجى التواصل مع الدعم لأي استفسار.');

        return back()->with('success', 'تم إلغاء الحوالة ✅');
    }

    // ═══════════════════════════════════════════════════════════
    // ADMIN: Agent Management
    // ═══════════════════════════════════════════════════════════

    /**
     * Admin: list all agents
     */
    public function adminAgents()
    {
        $agents = DB::table('agents')
            ->join('districts', 'agents.district_id', '=', 'districts.id')
            ->join('governorates', 'districts.governorate_id', '=', 'governorates.id')
            ->select(
                'agents.*',
                'districts.name_ar as district_ar', 'districts.name_en as district_en',
                'governorates.name_ar as governorate_ar', 'governorates.name_en as governorate_en',
                'governorates.id as governorate_id'
            )
            ->orderBy('governorates.name_ar')
            ->orderBy('districts.name_ar')
            ->get();

        $governorates = DB::table('governorates')->orderBy('name_ar')->get();
        $districts = DB::table('districts')->orderBy('name_ar')->get();

        $stats = [
            'total' => $agents->count(),
            'active' => $agents->where('is_active', true)->count(),
            'inactive' => $agents->where('is_active', false)->count(),
            'governorates' => $governorates->count(),
        ];

        // Count remittances per agent
        $remittanceCounts = DB::table('remittances')
            ->select('agent_id', DB::raw('count(*) as cnt'), DB::raw('sum(amount) as total_amount'))
            ->groupBy('agent_id')
            ->pluck('cnt', 'agent_id');

        return Inertia::render('Admin/Agents', [
            'agents' => $agents,
            'governorates' => $governorates,
            'districts' => $districts,
            'stats' => $stats,
            'remittanceCounts' => $remittanceCounts,
        ]);
    }

    /**
     * Admin: create agent
     */
    public function adminCreateAgent(Request $request)
    {
        $request->validate([
            'district_id' => 'required|exists:districts,id',
            'name_ar' => 'required|string|max:255',
            'name_en' => 'required|string|max:255',
            'phone' => 'nullable|string|max:30',
            'address_ar' => 'nullable|string|max:500',
            'address_en' => 'nullable|string|max:500',
            'commission_rate' => 'numeric|min:0|max:100',
        ]);

        DB::table('agents')->insert([
            'district_id' => $request->district_id,
            'name_ar' => $request->name_ar,
            'name_en' => $request->name_en,
            'phone' => $request->phone,
            'address_ar' => $request->address_ar,
            'address_en' => $request->address_en,
            'commission_rate' => $request->commission_rate ?? 0,
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return back()->with('success', 'تم إضافة الوكيل بنجاح ✅');
    }

    /**
     * Admin: update agent
     */
    public function adminUpdateAgent(Request $request, $id)
    {
        $agent = DB::table('agents')->where('id', $id)->first();
        if (!$agent) return back()->with('error', 'وكيل غير موجود');

        $data = ['updated_at' => now()];
        if ($request->has('name_ar')) $data['name_ar'] = $request->name_ar;
        if ($request->has('name_en')) $data['name_en'] = $request->name_en;
        if ($request->has('phone')) $data['phone'] = $request->phone;
        if ($request->has('address_ar')) $data['address_ar'] = $request->address_ar;
        if ($request->has('address_en')) $data['address_en'] = $request->address_en;
        if ($request->has('commission_rate')) $data['commission_rate'] = $request->commission_rate;
        if ($request->has('is_active')) $data['is_active'] = $request->boolean('is_active');

        DB::table('agents')->where('id', $id)->update($data);

        return back()->with('success', 'تم تحديث الوكيل ✅');
    }

    /**
     * Admin: toggle agent active status
     */
    public function adminToggleAgent($id)
    {
        $agent = DB::table('agents')->where('id', $id)->first();
        if (!$agent) return back()->with('error', 'وكيل غير موجود');

        DB::table('agents')->where('id', $id)->update([
            'is_active' => !$agent->is_active,
            'updated_at' => now(),
        ]);

        return back()->with('success', $agent->is_active ? 'تم تعطيل الوكيل' : 'تم تفعيل الوكيل ✅');
    }

    /**
     * Admin: delete agent
     */
    public function adminDeleteAgent($id)
    {
        $hasRemittances = DB::table('remittances')->where('agent_id', $id)->exists();
        if ($hasRemittances) {
            return back()->with('error', 'لا يمكن حذف وكيل لديه حوالات، قم بتعطيله بدلاً من ذلك');
        }

        DB::table('agents')->where('id', $id)->delete();
        return back()->with('success', 'تم حذف الوكيل ✅');
    }
}
