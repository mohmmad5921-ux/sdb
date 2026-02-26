<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Merchant;
use App\Models\MerchantApiKey;
use App\Models\PaymentSession;
use Illuminate\Http\Request;
use Inertia\Inertia;

class MerchantController extends Controller
{
    public function index(Request $request)
    {
        $query = Merchant::withCount('paymentSessions');

        if ($request->search) {
            $query->where(function ($q) use ($request) {
                $q->where('business_name', 'like', "%{$request->search}%")
                    ->orWhere('business_email', 'like', "%{$request->search}%");
            });
        }
        if ($request->status)
            $query->where('status', $request->status);

        return Inertia::render('Admin/Merchants', [
            'merchants' => $query->orderByDesc('created_at')->paginate(20)->withQueryString(),
            'filters' => $request->only(['search', 'status']),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'business_name' => 'required|string|max:255',
            'business_name_ar' => 'nullable|string|max:255',
            'business_email' => 'required|email',
            'business_phone' => 'nullable|string|max:20',
            'website_url' => 'nullable|url',
            'description' => 'nullable|string',
            'category' => 'required|in:ecommerce,retail,services,food,travel,education,healthcare,other',
            'fee_percentage' => 'required|numeric|min:0|max:100',
            'fee_fixed' => 'nullable|numeric|min:0',
            'settlement_currency' => 'required|string|max:10',
            'status' => 'required|in:pending,active,suspended,rejected',
        ]);

        $merchant = Merchant::create($validated);

        // Auto-generate API keys
        $keyPair = MerchantApiKey::generateKeyPair();
        $merchant->apiKeys()->create([
            'name' => 'Default',
            'public_key' => $keyPair['public_key'],
            'secret_key_hash' => $keyPair['secret_key_hash'],
            'secret_key_prefix' => $keyPair['secret_key_prefix'],
            'environment' => 'production',
        ]);

        return back()->with('success', 'Merchant created! Secret Key: ' . $keyPair['secret_key']);
    }

    public function show(Merchant $merchant)
    {
        $merchant->load(['apiKeys', 'settlementAccount.currency']);

        $sessions = PaymentSession::where('merchant_id', $merchant->id)
            ->with('paidByUser')
            ->orderByDesc('created_at')
            ->paginate(15);

        return Inertia::render('Admin/MerchantDetail', [
            'merchant' => $merchant,
            'apiKeys' => $merchant->apiKeys,
            'sessions' => $sessions,
        ]);
    }

    public function update(Request $request, Merchant $merchant)
    {
        $validated = $request->validate([
            'business_name' => 'string|max:255',
            'business_name_ar' => 'nullable|string|max:255',
            'business_email' => 'email',
            'business_phone' => 'nullable|string|max:20',
            'website_url' => 'nullable|url',
            'description' => 'nullable|string',
            'category' => 'in:ecommerce,retail,services,food,travel,education,healthcare,other',
            'fee_percentage' => 'numeric|min:0|max:100',
            'fee_fixed' => 'nullable|numeric|min:0',
            'status' => 'in:pending,active,suspended,rejected',
        ]);

        $merchant->update($validated);
        return back()->with('success', 'Merchant updated');
    }

    public function generateApiKey(Merchant $merchant)
    {
        $keyPair = MerchantApiKey::generateKeyPair();
        $merchant->apiKeys()->create([
            'name' => 'Key ' . ($merchant->apiKeys()->count() + 1),
            'public_key' => $keyPair['public_key'],
            'secret_key_hash' => $keyPair['secret_key_hash'],
            'secret_key_prefix' => $keyPair['secret_key_prefix'],
            'environment' => 'production',
        ]);

        return back()->with('success', 'New API Key generated! Secret: ' . $keyPair['secret_key']);
    }

    public function revokeApiKey(MerchantApiKey $apiKey)
    {
        $apiKey->update(['is_active' => false]);
        return back()->with('success', 'API key revoked');
    }
}