<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Inertia\Inertia;

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
                'agents.name_ar as agent_name_ar',
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
        ];

        return Inertia::render('Admin/Remittances', [
            'remittances' => $remittances,
            'stats' => $stats,
        ]);
    }
}
