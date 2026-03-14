<?php

namespace Database\Seeders;

use App\Models\Governorate;
use App\Models\District;
use App\Models\Agent;
use Illuminate\Database\Seeder;

class SyriaDataSeeder extends Seeder
{
    public function run(): void
    {
        $data = [
            ['name_ar' => 'دمشق', 'name_en' => 'Damascus', 'code' => 'DAM', 'districts' => [
                ['name_ar' => 'المزة', 'name_en' => 'Mezzeh', 'agents' => [
                    ['name_ar' => 'مكتب الأمانة للحوالات', 'name_en' => 'Al-Amana Exchange', 'phone' => '+963111234567', 'address_ar' => 'شارع المزة، بجانب صيدلية الحياة'],
                    ['name_ar' => 'مكتب الثقة للصرافة', 'name_en' => 'Al-Thiqa Exchange', 'phone' => '+963111234568', 'address_ar' => 'المزة جبل، مقابل مسجد الرحمن'],
                ]],
                ['name_ar' => 'الشعلان', 'name_en' => 'Shaalan', 'agents' => [
                    ['name_ar' => 'مكتب الشام للحوالات', 'name_en' => 'Al-Sham Exchange', 'phone' => '+963112345678', 'address_ar' => 'شارع الشعلان الرئيسي'],
                ]],
                ['name_ar' => 'باب توما', 'name_en' => 'Bab Touma', 'agents' => [
                    ['name_ar' => 'مكتب النور للصرافة', 'name_en' => 'Al-Nour Exchange', 'phone' => '+963113456789', 'address_ar' => 'شارع باب توما، مقابل كنيسة المريمية'],
                ]],
                ['name_ar' => 'ركن الدين', 'name_en' => 'Rukn al-Din', 'agents' => [
                    ['name_ar' => 'مكتب الوفاء للحوالات', 'name_en' => 'Al-Wafaa Exchange', 'phone' => '+963114567890', 'address_ar' => 'شارع ركن الدين الرئيسي'],
                ]],
                ['name_ar' => 'المالكي', 'name_en' => 'Malki', 'agents' => [
                    ['name_ar' => 'مكتب المالكي للصرافة', 'name_en' => 'Malki Exchange', 'phone' => '+963115678901', 'address_ar' => 'شارع أبو رمانة'],
                ]],
            ]],
            ['name_ar' => 'ريف دمشق', 'name_en' => 'Damascus Countryside', 'code' => 'RIF', 'districts' => [
                ['name_ar' => 'جرمانا', 'name_en' => 'Jaramana', 'agents' => [
                    ['name_ar' => 'مكتب الجرمانا للحوالات', 'name_en' => 'Jaramana Exchange', 'phone' => '+963116789012', 'address_ar' => 'شارع الرئيسي، جرمانا'],
                    ['name_ar' => 'مكتب الأهل للصرافة', 'name_en' => 'Al-Ahl Exchange', 'phone' => '+963116789013', 'address_ar' => 'ساحة جرمانا'],
                ]],
                ['name_ar' => 'صحنايا', 'name_en' => 'Sahnaya', 'agents' => [
                    ['name_ar' => 'مكتب صحنايا للحوالات', 'name_en' => 'Sahnaya Exchange', 'phone' => '+963117890123', 'address_ar' => 'شارع صحنايا الرئيسي'],
                ]],
                ['name_ar' => 'داريا', 'name_en' => 'Darayya', 'agents' => [
                    ['name_ar' => 'مكتب داريا للصرافة', 'name_en' => 'Darayya Exchange', 'phone' => '+963118901234', 'address_ar' => 'شارع داريا الرئيسي'],
                ]],
                ['name_ar' => 'معضمية الشام', 'name_en' => 'Moadamiyeh', 'agents' => [
                    ['name_ar' => 'مكتب المعضمية للحوالات', 'name_en' => 'Moadamiyeh Exchange', 'phone' => '+963119012345', 'address_ar' => 'سوق المعضمية'],
                ]],
            ]],
            ['name_ar' => 'حلب', 'name_en' => 'Aleppo', 'code' => 'ALP', 'districts' => [
                ['name_ar' => 'العزيزية', 'name_en' => 'Aziziyeh', 'agents' => [
                    ['name_ar' => 'مكتب حلب للحوالات', 'name_en' => 'Aleppo Exchange', 'phone' => '+963211234567', 'address_ar' => 'شارع العزيزية الرئيسي'],
                    ['name_ar' => 'مكتب الشهباء للصرافة', 'name_en' => 'Al-Shahba Exchange', 'phone' => '+963211234568', 'address_ar' => 'حي العزيزية'],
                ]],
                ['name_ar' => 'السليمانية', 'name_en' => 'Sulaymaniyah', 'agents' => [
                    ['name_ar' => 'مكتب السليمانية للحوالات', 'name_en' => 'Sulaymaniyah Exchange', 'phone' => '+963212345678', 'address_ar' => 'شارع السليمانية'],
                ]],
                ['name_ar' => 'الجميلية', 'name_en' => 'Jamiliyeh', 'agents' => [
                    ['name_ar' => 'مكتب الجميلية للصرافة', 'name_en' => 'Jamiliyeh Exchange', 'phone' => '+963213456789', 'address_ar' => 'ساحة الجميلية'],
                ]],
                ['name_ar' => 'صلاح الدين', 'name_en' => 'Salah al-Din', 'agents' => [
                    ['name_ar' => 'مكتب صلاح الدين للحوالات', 'name_en' => 'Salah al-Din Exchange', 'phone' => '+963214567890', 'address_ar' => 'حي صلاح الدين'],
                ]],
            ]],
            ['name_ar' => 'حمص', 'name_en' => 'Homs', 'code' => 'HMS', 'districts' => [
                ['name_ar' => 'الإنشاءات', 'name_en' => 'Inshaaat', 'agents' => [
                    ['name_ar' => 'مكتب حمص للحوالات', 'name_en' => 'Homs Exchange', 'phone' => '+963311234567', 'address_ar' => 'حي الإنشاءات'],
                ]],
                ['name_ar' => 'الحمراء', 'name_en' => 'Hamra', 'agents' => [
                    ['name_ar' => 'مكتب الحمراء للصرافة', 'name_en' => 'Hamra Exchange', 'phone' => '+963312345678', 'address_ar' => 'شارع الحمراء'],
                ]],
                ['name_ar' => 'باب السباع', 'name_en' => 'Bab al-Sibaa', 'agents' => [
                    ['name_ar' => 'مكتب السباع للحوالات', 'name_en' => 'Al-Sibaa Exchange', 'phone' => '+963313456789', 'address_ar' => 'باب السباع'],
                ]],
            ]],
            ['name_ar' => 'حماة', 'name_en' => 'Hama', 'code' => 'HAM', 'districts' => [
                ['name_ar' => 'وسط المدينة', 'name_en' => 'City Center', 'agents' => [
                    ['name_ar' => 'مكتب حماة للحوالات', 'name_en' => 'Hama Exchange', 'phone' => '+963331234567', 'address_ar' => 'شارع النواعير'],
                ]],
                ['name_ar' => 'السلحبية', 'name_en' => 'Salamiyah', 'agents' => [
                    ['name_ar' => 'مكتب سلمية للصرافة', 'name_en' => 'Salamiyah Exchange', 'phone' => '+963332345678', 'address_ar' => 'سوق سلمية'],
                ]],
            ]],
            ['name_ar' => 'اللاذقية', 'name_en' => 'Latakia', 'code' => 'LAT', 'districts' => [
                ['name_ar' => 'وسط المدينة', 'name_en' => 'City Center', 'agents' => [
                    ['name_ar' => 'مكتب اللاذقية للحوالات', 'name_en' => 'Latakia Exchange', 'phone' => '+963411234567', 'address_ar' => 'شارع بغداد'],
                    ['name_ar' => 'مكتب الساحل للصرافة', 'name_en' => 'Al-Sahel Exchange', 'phone' => '+963411234568', 'address_ar' => 'شارع 8 آذار'],
                ]],
                ['name_ar' => 'جبلة', 'name_en' => 'Jableh', 'agents' => [
                    ['name_ar' => 'مكتب جبلة للحوالات', 'name_en' => 'Jableh Exchange', 'phone' => '+963412345678', 'address_ar' => 'سوق جبلة'],
                ]],
            ]],
            ['name_ar' => 'طرطوس', 'name_en' => 'Tartous', 'code' => 'TAR', 'districts' => [
                ['name_ar' => 'وسط المدينة', 'name_en' => 'City Center', 'agents' => [
                    ['name_ar' => 'مكتب طرطوس للحوالات', 'name_en' => 'Tartous Exchange', 'phone' => '+963431234567', 'address_ar' => 'شارع الكورنيش'],
                ]],
                ['name_ar' => 'بانياس', 'name_en' => 'Banias', 'agents' => [
                    ['name_ar' => 'مكتب بانياس للصرافة', 'name_en' => 'Banias Exchange', 'phone' => '+963432345678', 'address_ar' => 'سوق بانياس'],
                ]],
            ]],
            ['name_ar' => 'إدلب', 'name_en' => 'Idlib', 'code' => 'IDL', 'districts' => [
                ['name_ar' => 'وسط المدينة', 'name_en' => 'City Center', 'agents' => [
                    ['name_ar' => 'مكتب إدلب للحوالات', 'name_en' => 'Idlib Exchange', 'phone' => '+963231234567', 'address_ar' => 'سوق إدلب'],
                ]],
                ['name_ar' => 'معرة النعمان', 'name_en' => 'Maarat al-Numan', 'agents' => [
                    ['name_ar' => 'مكتب المعرة للصرافة', 'name_en' => 'Maarat Exchange', 'phone' => '+963232345678', 'address_ar' => 'سوق المعرة'],
                ]],
            ]],
            ['name_ar' => 'الرقة', 'name_en' => 'Raqqa', 'code' => 'RAQ', 'districts' => [
                ['name_ar' => 'وسط المدينة', 'name_en' => 'City Center', 'agents' => [
                    ['name_ar' => 'مكتب الرقة للحوالات', 'name_en' => 'Raqqa Exchange', 'phone' => '+963221234567', 'address_ar' => 'شارع الرقة الرئيسي'],
                ]],
            ]],
            ['name_ar' => 'دير الزور', 'name_en' => 'Deir ez-Zor', 'code' => 'DEZ', 'districts' => [
                ['name_ar' => 'وسط المدينة', 'name_en' => 'City Center', 'agents' => [
                    ['name_ar' => 'مكتب الفرات للحوالات', 'name_en' => 'Al-Furat Exchange', 'phone' => '+963511234567', 'address_ar' => 'شارع الفرات'],
                ]],
                ['name_ar' => 'الميادين', 'name_en' => 'Mayadin', 'agents' => [
                    ['name_ar' => 'مكتب الميادين للصرافة', 'name_en' => 'Mayadin Exchange', 'phone' => '+963512345678', 'address_ar' => 'سوق الميادين'],
                ]],
            ]],
            ['name_ar' => 'الحسكة', 'name_en' => 'Al-Hasakah', 'code' => 'HAS', 'districts' => [
                ['name_ar' => 'وسط المدينة', 'name_en' => 'City Center', 'agents' => [
                    ['name_ar' => 'مكتب الحسكة للحوالات', 'name_en' => 'Hasakah Exchange', 'phone' => '+963521234567', 'address_ar' => 'شارع الحسكة الرئيسي'],
                ]],
                ['name_ar' => 'القامشلي', 'name_en' => 'Qamishli', 'agents' => [
                    ['name_ar' => 'مكتب القامشلي للصرافة', 'name_en' => 'Qamishli Exchange', 'phone' => '+963522345678', 'address_ar' => 'سوق القامشلي'],
                ]],
            ]],
            ['name_ar' => 'السويداء', 'name_en' => 'As-Suwayda', 'code' => 'SWD', 'districts' => [
                ['name_ar' => 'وسط المدينة', 'name_en' => 'City Center', 'agents' => [
                    ['name_ar' => 'مكتب السويداء للحوالات', 'name_en' => 'Suwayda Exchange', 'phone' => '+963161234567', 'address_ar' => 'سوق السويداء'],
                ]],
            ]],
            ['name_ar' => 'درعا', 'name_en' => 'Daraa', 'code' => 'DAR', 'districts' => [
                ['name_ar' => 'وسط المدينة', 'name_en' => 'City Center', 'agents' => [
                    ['name_ar' => 'مكتب درعا للحوالات', 'name_en' => 'Daraa Exchange', 'phone' => '+963151234567', 'address_ar' => 'شارع درعا الرئيسي'],
                ]],
                ['name_ar' => 'نوى', 'name_en' => 'Nawa', 'agents' => [
                    ['name_ar' => 'مكتب نوى للصرافة', 'name_en' => 'Nawa Exchange', 'phone' => '+963152345678', 'address_ar' => 'سوق نوى'],
                ]],
            ]],
            ['name_ar' => 'القنيطرة', 'name_en' => 'Quneitra', 'code' => 'QUN', 'districts' => [
                ['name_ar' => 'خان أرنبة', 'name_en' => 'Khan Arnabeh', 'agents' => [
                    ['name_ar' => 'مكتب القنيطرة للحوالات', 'name_en' => 'Quneitra Exchange', 'phone' => '+963141234567', 'address_ar' => 'خان أرنبة'],
                ]],
            ]],
        ];

        foreach ($data as $gov) {
            $governorate = Governorate::updateOrCreate(
                ['code' => $gov['code']],
                ['name_ar' => $gov['name_ar'], 'name_en' => $gov['name_en'], 'is_active' => true]
            );

            foreach ($gov['districts'] as $dist) {
                $district = District::updateOrCreate(
                    ['governorate_id' => $governorate->id, 'name_ar' => $dist['name_ar']],
                    ['name_en' => $dist['name_en'], 'is_active' => true]
                );

                foreach ($dist['agents'] as $ag) {
                    Agent::updateOrCreate(
                        ['district_id' => $district->id, 'name_ar' => $ag['name_ar']],
                        [
                            'name_en' => $ag['name_en'],
                            'phone' => $ag['phone'],
                            'address_ar' => $ag['address_ar'] ?? null,
                            'address_en' => $ag['address_en'] ?? null,
                            'commission_rate' => 1.5,
                            'is_active' => true,
                        ]
                    );
                }
            }
        }

        $this->command->info('✅ Seeded 14 governorates, ' . District::count() . ' districts, ' . Agent::count() . ' agents');
    }
}
