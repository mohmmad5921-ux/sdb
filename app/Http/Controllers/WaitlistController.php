<?php

namespace App\Http\Controllers;

use App\Models\WaitlistEmail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use App\Mail\WaitlistConfirmation;

class WaitlistController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'email' => 'required|email|max:255',
        ]);

        $existing = WaitlistEmail::where('email', $request->email)->first();

        if ($existing) {
            return response()->json(['message' => 'already_registered', 'success' => true]);
        }

        $entry = WaitlistEmail::create([
            'email' => $request->email,
            'source' => $request->input('source', 'hero'),
            'ip_address' => $request->ip(),
        ]);

        // Send confirmation email
        try {
            Mail::to($entry->email)->send(new WaitlistConfirmation($entry));
        } catch (\Exception $e) {
            \Log::warning('Waitlist email failed: ' . $e->getMessage());
        }

        return response()->json(['message' => 'registered', 'success' => true]);
    }
}
