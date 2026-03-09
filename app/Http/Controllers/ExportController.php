<?php

namespace App\Http\Controllers;

use App\Models\Preregistration;
use App\Models\WaitlistEmail;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

class ExportController extends Controller
{
    public function preregistrations(Request $request)
    {
        return new StreamedResponse(function () {
            $handle = fopen('php://output', 'w');
            fputcsv($handle, ['ID', 'Name', 'Email', 'Phone', 'Country', 'Governorate', 'Employment', 'Referral', 'IP', 'Date']);

            Preregistration::orderBy('created_at', 'desc')->chunk(100, function ($rows) use ($handle) {
                foreach ($rows as $row) {
                    fputcsv($handle, [
                        $row->id,
                        $row->full_name,
                        $row->email,
                        $row->phone,
                        $row->country,
                        $row->governorate,
                        $row->employment,
                        $row->referral,
                        $row->ip_address,
                        $row->created_at->format('Y-m-d H:i'),
                    ]);
                }
            });

            fclose($handle);
        }, 200, [
            'Content-Type' => 'text/csv',
            'Content-Disposition' => 'attachment; filename="preregistrations-' . date('Y-m-d') . '.csv"',
        ]);
    }

    public function waitlist(Request $request)
    {
        return new StreamedResponse(function () {
            $handle = fopen('php://output', 'w');
            fputcsv($handle, ['ID', 'Email', 'Source', 'IP', 'Date']);

            WaitlistEmail::orderBy('created_at', 'desc')->chunk(100, function ($rows) use ($handle) {
                foreach ($rows as $row) {
                    fputcsv($handle, [
                        $row->id,
                        $row->email,
                        $row->source,
                        $row->ip_address,
                        $row->created_at->format('Y-m-d H:i'),
                    ]);
                }
            });

            fclose($handle);
        }, 200, [
            'Content-Type' => 'text/csv',
            'Content-Disposition' => 'attachment; filename="waitlist-' . date('Y-m-d') . '.csv"',
        ]);
    }
}
