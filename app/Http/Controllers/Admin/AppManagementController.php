<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AppSetting;
use App\Models\AdminActivityLog;
use Illuminate\Http\Request;
use Inertia\Inertia;

class AppManagementController extends Controller
{
    public function index()
    {
        $settings = AppSetting::all()->groupBy('group');
        return Inertia::render('Admin/AppManagement', [
            'settings' => $settings,
        ]);
    }

    public function update(Request $request)
    {
        $updates = $request->input('settings', []);
        $changes = [];

        foreach ($updates as $key => $value) {
            $setting = AppSetting::where('key', $key)->first();
            if ($setting) {
                $old = $setting->value;
                $setting->update(['value' => (string) $value]);
                if ($old !== (string) $value) {
                    $changes[$key] = ['old' => $old, 'new' => (string) $value];
                }
            }
        }

        if (!empty($changes)) {
            AdminActivityLog::log('app.settings_update', null, null, $changes);
        }

        return back()->with('success', 'تم حفظ الإعدادات بنجاح');
    }
}
