<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class MoonPayController extends Controller
{
    /**
     * Sign a MoonPay widget URL using HMAC-SHA256.
     *
     * The frontend generates the widget URL with all parameters,
     * sends it here, and we return the signature so the widget
     * can be displayed securely.
     */
    public function signUrl(Request $request)
    {
        $request->validate([
            'urlForSignature' => 'required|string',
        ]);

        $url = $request->input('urlForSignature');
        $secretKey = config('moonpay.secret_key');

        if (empty($secretKey)) {
            return response()->json(['error' => 'MoonPay secret key not configured'], 500);
        }

        // Extract the query string from the URL for signing
        $parsed = parse_url($url);
        $query = $parsed['query'] ?? '';

        $signature = hash_hmac('sha256', '?' . $query, $secretKey);

        return response()->json([
            'signature' => $signature,
        ]);
    }
}
