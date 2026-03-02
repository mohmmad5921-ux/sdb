<?php

namespace App\Http\Controllers;

use App\Models\Preregistration;
use App\Mail\WelcomePreregistration;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Inertia\Inertia;

class PreregistrationController extends Controller
{
    public function show()
    {
        return Inertia::render('Preregister');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'full_name' => 'required|string|max:255',
            'email' => 'required|email|unique:preregistrations,email',
            'phone' => 'nullable|string|max:20',
            'country' => 'nullable|string|max:100',
        ]);

        $reg = Preregistration::create([
            ...$validated,
            'ip_address' => $request->ip(),
        ]);

        // Send welcome email
        try {
            Mail::to($reg->email)->send(new WelcomePreregistration($reg));
        } catch (\Exception $e) {
            // Don't fail if email doesn't send
            \Log::warning('Preregistration email failed: ' . $e->getMessage());
        }

        return Inertia::render('PreregisterThankYou', [
            'name' => $reg->full_name,
            'email' => $reg->email,
        ]);
    }
}
