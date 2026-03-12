<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Cache;

class GeminiService
{
    private static function getApiKey(): ?string
    {
        return config('services.gemini.api_key');
    }

    /**
     * Build the system prompt with full admin knowledge
     */
    private static function buildSystemPrompt(): string
    {
        return <<<'PROMPT'
أنت المساعد الذكي لـ SDB Bank — بنك رقمي حديث. اسمك "مساعد SDB".
أنت تعمل داخل لوحة تحكم الأدمن وتساعد فريق الإدارة في جميع المهام.

## معلوماتك عن النظام:

### الأقسام الرئيسية:
- **لوحة التحكم**: نظرة عامة على إجمالي المستخدمين، الحسابات النشطة، المعاملات، والإيرادات
- **إدارة العملاء**: العملاء، الحسابات، البطاقات، المعاملات، KYC، تصنيف العملاء، الحسابات المجمّدة
- **الأعمال والشركات**: لوحة الشركات، حسابات الشركات، التجار، الموافقات
- **الدعم والتواصل**: تذاكر الدعم، إشعارات جماعية، سجل التواصل، طلبات خاصة
- **المالية والتحليلات**: العملات (EUR, USD, SYP, DKK, GBP, SEK, TRY)، أسعار الصرف، الرسوم، حدود الحسابات، التحليلات
- **أمان ومخاطر**: مراقبة المعاملات، كشف الاحتيال، مكافحة غسل الأموال، المخاطر والامتثال
- **إعدادات**: إعدادات عامة، قوالب البريد، إدارة API، سجل التدقيق، الأمان

### التحقق من الهوية (KYC):
- **المستندات المطلوبة**: صورة الهوية (أمامية وخلفية)، صورة شخصية (سيلفي)، إثبات عنوان
- **حالات KYC**: pending (معلق)، submitted (مقدم)، verified (مؤكد)، rejected (مرفوض)
- **خطوات التحقق**:
  1. مراجعة صورة الهوية (اسم، رقم، تاريخ)
  2. مقارنة الصورة الشخصية مع صورة الهوية
  3. التحقق من إثبات العنوان
  4. التأكد من تطابق البيانات المدخلة مع المستندات
- **أسباب الرفض الشائعة**: صورة غير واضحة، بيانات غير متطابقة، مستند منتهي الصلاحية، صورة شخصية لا تتطابق

### المحافظ والعملات:
- كل مستخدم يحصل على محفظة افتراضية بعملة بلده + محفظة ليرة سورية (SYP)
- يمكن للمستخدم فتح محافظ إضافية بأي عملة متاحة
- التحويلات بين المحافظ متاحة بأسعار صرف محدثة

### البطاقات:
- بطاقات افتراضية ومادية
- أنواع: Standard, Plus, Premium, Elite
- يمكن تجميد/إلغاء تجميد البطاقات

### الأمان:
- حسابات مجمّدة: يمكن تجميد حسابات مشبوهة
- مراقبة المعاملات: تنبيهات للمعاملات المشبوهة
- سجل التدقيق: جميع الإجراءات مسجلة

## تعليماتك:
- أجب بالعربية دائماً
- كن مختصراً ومفيداً
- عند السؤال عن KYC، قدم نصائح عملية
- لا تكشف معلومات حساسة عن العملاء
- عند الشك، اطلب من الأدمن التحقق يدوياً
- استخدم إيموجي لتسهيل القراءة
PROMPT;
    }

    /**
     * Chat with Gemini AI
     */
    public static function chat(string $message, array $history = [], ?array $context = null): string
    {
        $apiKey = self::getApiKey();
        if (!$apiKey) {
            return '⚠️ مفتاح Gemini API غير مُعدّ. يرجى إضافة GEMINI_API_KEY في ملف .env';
        }

        try {
            // Build conversation history
            $contents = [];

            // Add system instruction via first user message
            $systemPrompt = self::buildSystemPrompt();
            if ($context) {
                $systemPrompt .= "\n\n## سياق الصفحة الحالية:\n" . json_encode($context, JSON_UNESCAPED_UNICODE);
            }

            // Add history
            foreach ($history as $msg) {
                $contents[] = [
                    'role' => $msg['role'] === 'assistant' ? 'model' : 'user',
                    'parts' => [['text' => $msg['content']]],
                ];
            }

            // Add current message
            $contents[] = [
                'role' => 'user',
                'parts' => [['text' => $message]],
            ];

            $response = Http::timeout(30)->post(
                "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={$apiKey}",
                [
                    'system_instruction' => [
                        'parts' => [['text' => $systemPrompt]],
                    ],
                    'contents' => $contents,
                    'generationConfig' => [
                        'temperature' => 0.7,
                        'maxOutputTokens' => 1024,
                    ],
                ]
            );

            if ($response->successful()) {
                $data = $response->json();
                return $data['candidates'][0]['content']['parts'][0]['text']
                    ?? '❌ لم أتمكن من إنشاء رد';
            }

            Log::warning('Gemini API error: ' . $response->body());
            return '❌ حدث خطأ في الاتصال بالذكاء الاصطناعي. حاول مرة أخرى.';

        } catch (\Exception $e) {
            Log::error('Gemini Exception: ' . $e->getMessage());
            return '❌ خطأ: ' . $e->getMessage();
        }
    }

    /**
     * Analyze KYC document for verification assistance
     */
    public static function analyzeKyc(array $userData, array $kycData): string
    {
        $context = [
            'task' => 'KYC Review',
            'user' => [
                'name' => $userData['full_name'] ?? '',
                'nationality' => $userData['nationality'] ?? '',
                'dob' => $userData['date_of_birth'] ?? '',
            ],
            'kyc' => $kycData,
        ];

        $message = "ساعدني في مراجعة ملف KYC لهذا العميل. قدم لي ملخص سريع وتوصياتك.";
        return self::chat($message, [], $context);
    }
}
