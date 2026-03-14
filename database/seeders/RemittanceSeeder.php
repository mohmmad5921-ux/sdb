<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class RemittanceSeeder extends Seeder
{
    public function run(): void
    {
        $data = [
            ['code'=>'DAM','ar'=>'دمشق','en'=>'Damascus','districts'=>[
                ['ar'=>'المزة','en'=>'Al-Mazzeh','agents'=>[['ar'=>'مكتب الشام للحوالات','en'=>'Al-Sham Exchange','phone'=>'+963 11 611 0001','addr'=>'المزة — شارع الفيلات'],['ar'=>'صرافة النجمة','en'=>'Al-Najma Exchange','phone'=>'+963 11 611 0002','addr'=>'المزة — جاده']]],
                ['ar'=>'الشعلان','en'=>'Al-Shaalan','agents'=>[['ar'=>'حوالات أبو خليل','en'=>'Abu Khalil Exchange','phone'=>'+963 11 612 0001','addr'=>'الشعلان — مقابل ساحة الشعلان']]],
                ['ar'=>'باب توما','en'=>'Bab Touma','agents'=>[['ar'=>'صرافة الأمين','en'=>'Al-Amin Exchange','phone'=>'+963 11 613 0001','addr'=>'باب توما — الشارع المستقيم']]],
                ['ar'=>'ركن الدين','en'=>'Rukn al-Din','agents'=>[['ar'=>'مكتب الثقة','en'=>'Al-Thiqa Office','phone'=>'+963 11 614 0001','addr'=>'ركن الدين — بجانب الجامع الكبير']]],
                ['ar'=>'المهاجرين','en'=>'Al-Muhajirin','agents'=>[['ar'=>'صرافة الياسمين','en'=>'Yasmin Exchange','phone'=>'+963 11 615 0001','addr'=>'المهاجرين — شارع أبو رمانة']]],
            ]],
            ['code'=>'RIF','ar'=>'ريف دمشق','en'=>'Rural Damascus','districts'=>[
                ['ar'=>'جرمانا','en'=>'Jaramana','agents'=>[['ar'=>'حوالات الأمان','en'=>'Al-Aman Exchange','phone'=>'+963 11 621 0001','addr'=>'جرمانا — الشارع الرئيسي']]],
                ['ar'=>'صحنايا','en'=>'Sahnaya','agents'=>[['ar'=>'مكتب صحنايا','en'=>'Sahnaya Office','phone'=>'+963 11 622 0001','addr'=>'صحنايا — وسط البلد']]],
                ['ar'=>'داريا','en'=>'Darayya','agents'=>[['ar'=>'صرافة داريا','en'=>'Darayya Exchange','phone'=>'+963 11 623 0001','addr'=>'داريا — شارع الثورة']]],
                ['ar'=>'المعضمية','en'=>'Al-Moadamiyeh','agents'=>[['ar'=>'حوالات المعضمية','en'=>'Moadamiyeh Exchange','phone'=>'+963 11 624 0001','addr'=>'المعضمية — المركز']]],
            ]],
            ['code'=>'ALE','ar'=>'حلب','en'=>'Aleppo','districts'=>[
                ['ar'=>'العزيزية','en'=>'Al-Aziziyeh','agents'=>[['ar'=>'صرافة حلب الشهباء','en'=>'Aleppo Shahba Exchange','phone'=>'+963 21 211 0001','addr'=>'العزيزية — شارع النيل'],['ar'=>'حوالات الفرات','en'=>'Al-Furat Exchange','phone'=>'+963 21 211 0002','addr'=>'العزيزية — جانب البريد']]],
                ['ar'=>'السليمانية','en'=>'Al-Sulaymaniyeh','agents'=>[['ar'=>'مكتب السليمانية','en'=>'Sulaymaniyeh Office','phone'=>'+963 21 212 0001','addr'=>'السليمانية — ساحة سعد الله الجابري']]],
                ['ar'=>'الحمدانية','en'=>'Al-Hamdaniyeh','agents'=>[['ar'=>'حوالات الحمدانية','en'=>'Hamdaniyeh Exchange','phone'=>'+963 21 213 0001','addr'=>'الحمدانية — المدخل الرئيسي']]],
                ['ar'=>'الجميلية','en'=>'Al-Jamiliyeh','agents'=>[['ar'=>'صرافة الجميلية','en'=>'Jamiliyeh Exchange','phone'=>'+963 21 214 0001','addr'=>'الجميلية — وسط السوق']]],
            ]],
            ['code'=>'HOM','ar'=>'حمص','en'=>'Homs','districts'=>[
                ['ar'=>'الحمرا','en'=>'Al-Hamra','agents'=>[['ar'=>'حوالات حمص','en'=>'Homs Exchange','phone'=>'+963 31 211 0001','addr'=>'الحمرا — شارع الدبلان']]],
                ['ar'=>'باب السباع','en'=>'Bab al-Sibaa','agents'=>[['ar'=>'مكتب باب السباع','en'=>'Bab Sibaa Office','phone'=>'+963 31 212 0001','addr'=>'باب السباع — السوق']]],
                ['ar'=>'الوعر','en'=>'Al-Waer','agents'=>[['ar'=>'صرافة الوعر','en'=>'Waer Exchange','phone'=>'+963 31 213 0001','addr'=>'الوعر — المنطقة التجارية']]],
            ]],
            ['code'=>'HAM','ar'=>'حماة','en'=>'Hama','districts'=>[
                ['ar'=>'المدينة','en'=>'City Center','agents'=>[['ar'=>'حوالات النواعير','en'=>'Nawair Exchange','phone'=>'+963 33 211 0001','addr'=>'حماة — ساحة العاصي']]],
                ['ar'=>'طريق حلب','en'=>'Aleppo Road','agents'=>[['ar'=>'مكتب طريق حلب','en'=>'Aleppo Road Office','phone'=>'+963 33 212 0001','addr'=>'طريق حلب — بجانب المحطة']]],
                ['ar'=>'السلمية','en'=>'Al-Salamiyeh','agents'=>[['ar'=>'صرافة السلمية','en'=>'Salamiyeh Exchange','phone'=>'+963 33 213 0001','addr'=>'السلمية — الشارع العام']]],
            ]],
            ['code'=>'LAT','ar'=>'اللاذقية','en'=>'Latakia','districts'=>[
                ['ar'=>'الصليبة','en'=>'Al-Salibeh','agents'=>[['ar'=>'حوالات الساحل','en'=>'Coast Exchange','phone'=>'+963 41 211 0001','addr'=>'الصليبة — شارع بغداد']]],
                ['ar'=>'الرمل الشمالي','en'=>'Northern Raml','agents'=>[['ar'=>'صرافة اللاذقية','en'=>'Latakia Exchange','phone'=>'+963 41 212 0001','addr'=>'الرمل الشمالي — طريق الكورنيش']]],
                ['ar'=>'جبلة','en'=>'Jableh','agents'=>[['ar'=>'مكتب جبلة','en'=>'Jableh Office','phone'=>'+963 41 213 0001','addr'=>'جبلة — وسط المدينة']]],
            ]],
            ['code'=>'TAR','ar'=>'طرطوس','en'=>'Tartus','districts'=>[
                ['ar'=>'المدينة','en'=>'City Center','agents'=>[['ar'=>'حوالات طرطوس','en'=>'Tartus Exchange','phone'=>'+963 43 211 0001','addr'=>'طرطوس — الكورنيش']]],
                ['ar'=>'بانياس','en'=>'Baniyas','agents'=>[['ar'=>'صرافة بانياس','en'=>'Baniyas Exchange','phone'=>'+963 43 212 0001','addr'=>'بانياس — الشارع الرئيسي']]],
                ['ar'=>'صافيتا','en'=>'Safita','agents'=>[['ar'=>'مكتب صافيتا','en'=>'Safita Office','phone'=>'+963 43 213 0001','addr'=>'صافيتا — الساحة']]],
            ]],
            ['code'=>'IDL','ar'=>'إدلب','en'=>'Idlib','districts'=>[
                ['ar'=>'المدينة','en'=>'City Center','agents'=>[['ar'=>'حوالات إدلب','en'=>'Idlib Exchange','phone'=>'+963 23 211 0001','addr'=>'إدلب — الشارع العام']]],
                ['ar'=>'معرة النعمان','en'=>'Maarat al-Numan','agents'=>[['ar'=>'صرافة المعرة','en'=>'Maarat Exchange','phone'=>'+963 23 212 0001','addr'=>'معرة النعمان — السوق']]],
                ['ar'=>'أريحا','en'=>'Ariha','agents'=>[['ar'=>'مكتب أريحا','en'=>'Ariha Office','phone'=>'+963 23 213 0001','addr'=>'أريحا — المركز']]],
            ]],
            ['code'=>'DEZ','ar'=>'دير الزور','en'=>'Deir ez-Zor','districts'=>[
                ['ar'=>'المدينة','en'=>'City Center','agents'=>[['ar'=>'حوالات الفرات','en'=>'Euphrates Exchange','phone'=>'+963 51 211 0001','addr'=>'دير الزور — شارع الفرات']]],
                ['ar'=>'الميادين','en'=>'Al-Mayadin','agents'=>[['ar'=>'صرافة الميادين','en'=>'Mayadin Exchange','phone'=>'+963 51 212 0001','addr'=>'الميادين — الشارع العام']]],
                ['ar'=>'البوكمال','en'=>'Al-Bukamal','agents'=>[['ar'=>'مكتب البوكمال','en'=>'Bukamal Office','phone'=>'+963 51 213 0001','addr'=>'البوكمال — المركز']]],
            ]],
            ['code'=>'HAS','ar'=>'الحسكة','en'=>'Al-Hasakah','districts'=>[
                ['ar'=>'المدينة','en'=>'City Center','agents'=>[['ar'=>'حوالات الجزيرة','en'=>'Jazira Exchange','phone'=>'+963 52 211 0001','addr'=>'الحسكة — شارع القامشلي']]],
                ['ar'=>'القامشلي','en'=>'Qamishli','agents'=>[['ar'=>'صرافة القامشلي','en'=>'Qamishli Exchange','phone'=>'+963 52 212 0001','addr'=>'القامشلي — الشارع الرئيسي'],['ar'=>'مكتب الأمل','en'=>'Al-Amal Office','phone'=>'+963 52 212 0002','addr'=>'القامشلي — ساحة المحطة']]],
                ['ar'=>'رأس العين','en'=>'Ras al-Ain','agents'=>[['ar'=>'مكتب رأس العين','en'=>'Ras al-Ain Office','phone'=>'+963 52 213 0001','addr'=>'رأس العين — المركز']]],
            ]],
            ['code'=>'RAQ','ar'=>'الرقة','en'=>'Raqqa','districts'=>[
                ['ar'=>'المدينة','en'=>'City Center','agents'=>[['ar'=>'حوالات الرقة','en'=>'Raqqa Exchange','phone'=>'+963 22 211 0001','addr'=>'الرقة — شارع تل أبيض']]],
                ['ar'=>'الطبقة','en'=>'Al-Tabqa','agents'=>[['ar'=>'صرافة الطبقة','en'=>'Tabqa Exchange','phone'=>'+963 22 212 0001','addr'=>'الطبقة — بجانب السد']]],
            ]],
            ['code'=>'DAR','ar'=>'درعا','en'=>'Daraa','districts'=>[
                ['ar'=>'المدينة','en'=>'City Center','agents'=>[['ar'=>'حوالات حوران','en'=>'Houran Exchange','phone'=>'+963 15 211 0001','addr'=>'درعا — الشارع الرئيسي']]],
                ['ar'=>'نوى','en'=>'Nawa','agents'=>[['ar'=>'صرافة نوى','en'=>'Nawa Exchange','phone'=>'+963 15 212 0001','addr'=>'نوى — ساحة البلد']]],
                ['ar'=>'الصنمين','en'=>'Al-Sanamayn','agents'=>[['ar'=>'مكتب الصنمين','en'=>'Sanamayn Office','phone'=>'+963 15 213 0001','addr'=>'الصنمين — المدخل']]],
            ]],
            ['code'=>'SUW','ar'=>'السويداء','en'=>'As-Suwayda','districts'=>[
                ['ar'=>'المدينة','en'=>'City Center','agents'=>[['ar'=>'حوالات الجبل','en'=>'Mountain Exchange','phone'=>'+963 16 211 0001','addr'=>'السويداء — ساحة الكرامة']]],
                ['ar'=>'شهبا','en'=>'Shahba','agents'=>[['ar'=>'صرافة شهبا','en'=>'Shahba Exchange','phone'=>'+963 16 212 0001','addr'=>'شهبا — الشارع العام']]],
            ]],
            ['code'=>'QUN','ar'=>'القنيطرة','en'=>'Quneitra','districts'=>[
                ['ar'=>'المدينة','en'=>'City Center','agents'=>[['ar'=>'حوالات الجولان','en'=>'Golan Exchange','phone'=>'+963 14 211 0001','addr'=>'القنيطرة — المركز']]],
            ]],
        ];

        foreach ($data as $gov) {
            $govId = DB::table('governorates')->insertGetId([
                'name_ar' => $gov['ar'],
                'name_en' => $gov['en'],
                'code' => $gov['code'],
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            foreach ($gov['districts'] as $dist) {
                $distId = DB::table('districts')->insertGetId([
                    'governorate_id' => $govId,
                    'name_ar' => $dist['ar'],
                    'name_en' => $dist['en'],
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                foreach ($dist['agents'] as $agent) {
                    DB::table('agents')->insert([
                        'district_id' => $distId,
                        'name_ar' => $agent['ar'],
                        'name_en' => $agent['en'],
                        'phone' => $agent['phone'],
                        'address_ar' => $agent['addr'],
                        'address_en' => $agent['en'] . ' — ' . $dist['en'],
                        'is_active' => true,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }
        }
    }
}
