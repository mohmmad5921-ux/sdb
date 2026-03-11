<script setup>
import { Head } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'دفع الفواتير — SDB Bank',tag:'قريباً',
  heroH:'ادفع فواتيرك.',heroEm:'من التطبيق.',
  heroP:'قريباً: ادفع كل فواتيرك من تطبيق SDB Bank مباشرة. كهرباء، ماء، إنترنت، هاتف، إيجار — بدون طوابير وبدون تأخير.',
  catTitle:'أنواع الفواتير المدعومة',
  categories:[
    {ic:'⚡',t:'الكهرباء',d:'ادفع فاتورة الكهرباء بضغطة واحدة. تذكير تلقائي قبل موعد الاستحقاق. سجل كامل بكل الفواتير السابقة.',status:'قريباً'},
    {ic:'💧',t:'المياه',d:'فواتير المياه والصرف الصحي. دفع فوري مع إيصال رقمي. إشعار لحظة تسجيل الفاتورة الجديدة.',status:'قريباً'},
    {ic:'🌐',t:'الإنترنت',d:'ادفع لمزود الإنترنت مباشرة. دعم كل مزودي الخدمة. تجديد تلقائي اختياري.',status:'قريباً'},
    {ic:'📱',t:'شحن الهاتف',d:'اشحن خطك أو ادفع فاتورتك الشهرية. دعم كل شركات الاتصالات. شحن دولي متاح.',status:'قريباً'},
    {ic:'🏠',t:'الإيجار',d:'ادفع إيجار منزلك أو محلك مباشرة لحساب المؤجر. جدولة شهرية تلقائية متاحة.',status:'قريباً'},
    {ic:'🎓',t:'الأقساط الجامعية',d:'ادفع رسوم جامعتك مباشرة. دعم الجامعات السورية والدولية. تقسيط متاح.',status:'قريباً'},
    {ic:'📺',t:'الاشتراكات الرقمية',d:'Netflix, Spotify, Apple Music, YouTube Premium وأكثر. ادفع من رصيدك مباشرة.',status:'قريباً'},
    {ic:'🏥',t:'الفواتير الطبية',d:'ادفع فواتير المستشفيات والعيادات والصيدليات. حفظ تلقائي للإيصالات.',status:'قريباً'},
    {ic:'🚗',t:'التأمين والمركبات',d:'تأمين السيارة، تجديد الرخصة، مخالفات المرور. كل شيء من مكان واحد.',status:'قريباً'},
    {ic:'🏢',t:'خدمات حكومية',d:'رسوم حكومية، طوابع، ضرائب. دفع فوري مع إيصال رسمي رقمي.',status:'قريباً'},
    {ic:'💝',t:'تبرعات',d:'تبرع لجمعيات خيرية موثوقة مباشرة من التطبيق. إيصال ضريبي تلقائي.',status:'قريباً'},
    {ic:'🎮',t:'ألعاب وترفيه',d:'اشحن ألعابك المفضلة — PlayStation, Xbox, Steam, وأكثر.',status:'قريباً'},
  ],
  howTitle:'كيف يعمل؟',
  steps:[
    {n:'1',t:'اختر الفاتورة',d:'حدد نوع الفاتورة من القائمة أو امسح الباركود.'},
    {n:'2',t:'أدخل البيانات',d:'رقم الحساب أو رقم العداد أو أي معرّف مطلوب.'},
    {n:'3',t:'ادفع',d:'تأكيد بالبصمة أو الوجه — تمّ! إيصال رقمي فوري.'},
  ],
  featTitle:'مميزات الخدمة',
  feats:[
    {ic:'🔄',t:'دفع تلقائي',d:'جدول فواتيرك للدفع تلقائياً. لن تنسى فاتورة أبداً.'},
    {ic:'🔔',t:'تذكيرات',d:'تنبيه قبل موعد الاستحقاق. اختر المدة المناسبة.'},
    {ic:'📋',t:'سجل كامل',d:'كل فواتيرك محفوظة. ابحث، صدّر، أو شاركها.'},
    {ic:'🆓',t:'بدون رسوم',d:'لا رسوم إضافية على دفع الفواتير. المبلغ الأصلي فقط.'},
  ],
  notifyTitle:'كن أول من يعرف',notifySub:'سجّل لنبلّغك فور إطلاق خدمة دفع الفواتير.',notifyBtn:'أبلغني عند الإطلاق ←',
} : {
  title:'Bill Payments — SDB Bank',tag:'Coming Soon',
  heroH:'Pay your bills.',heroEm:'From the app.',
  heroP:'Coming soon: Pay all your bills directly from the SDB Bank app. Electricity, water, internet, phone, rent — no queues, no delays.',
  catTitle:'Supported Bill Types',
  categories:[
    {ic:'⚡',t:'Electricity',d:'Pay electricity bill with one tap. Auto-reminder before due date. Full history of past bills.',status:'Soon'},
    {ic:'💧',t:'Water',d:'Water and sewage bills. Instant payment with digital receipt. Notification when new bill posted.',status:'Soon'},
    {ic:'🌐',t:'Internet',d:'Pay your ISP directly. All providers supported. Optional auto-renewal.',status:'Soon'},
    {ic:'📱',t:'Phone Top-up',d:'Top up your line or pay monthly bill. All carriers supported. International top-up available.',status:'Soon'},
    {ic:'🏠',t:'Rent',d:'Pay home or shop rent directly to landlord\'s account. Monthly auto-schedule available.',status:'Soon'},
    {ic:'🎓',t:'University Tuition',d:'Pay university fees directly. Syrian and international universities. Installments available.',status:'Soon'},
    {ic:'📺',t:'Digital Subscriptions',d:'Netflix, Spotify, Apple Music, YouTube Premium and more. Pay from your balance directly.',status:'Soon'},
    {ic:'🏥',t:'Medical Bills',d:'Pay hospital, clinic, and pharmacy bills. Automatic receipt storage.',status:'Soon'},
    {ic:'🚗',t:'Insurance & Vehicles',d:'Car insurance, license renewal, traffic fines. Everything from one place.',status:'Soon'},
    {ic:'🏢',t:'Government Services',d:'Government fees, stamps, taxes. Instant payment with official digital receipt.',status:'Soon'},
    {ic:'💝',t:'Donations',d:'Donate to verified charities directly from the app. Automatic tax receipt.',status:'Soon'},
    {ic:'🎮',t:'Games & Entertainment',d:'Top up your favorite games — PlayStation, Xbox, Steam, and more.',status:'Soon'},
  ],
  howTitle:'How it works',
  steps:[
    {n:'1',t:'Select bill',d:'Choose bill type from the list or scan the barcode.'},
    {n:'2',t:'Enter details',d:'Account number, meter number, or any required identifier.'},
    {n:'3',t:'Pay',d:'Confirm with fingerprint or face — done! Instant digital receipt.'},
  ],
  featTitle:'Service Features',
  feats:[
    {ic:'🔄',t:'Auto-pay',d:'Schedule bills for automatic payment. Never forget a bill again.'},
    {ic:'🔔',t:'Reminders',d:'Alert before due date. Choose your preferred notice period.'},
    {ic:'📋',t:'Full History',d:'All your bills saved. Search, export, or share them.'},
    {ic:'🆓',t:'No Fees',d:'No extra fees on bill payments. Only the original amount.'},
  ],
  notifyTitle:'Be the first to know',notifySub:'Register to be notified when bill payments launch.',notifyBtn:'Notify me at launch →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.catTitle }}</h2><div class="g4"><div v-for="c in t.categories" :key="c.t" class="bill-c"><span class="bill-ic">{{ c.ic }}</span><h3 class="bill-t">{{ c.t }}</h3><p class="bill-d">{{ c.d }}</p><span class="bill-st">{{ c.status }}</span></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.howTitle }}</h2><div class="g3"><div v-for="s in t.steps" :key="s.n" class="step-c"><div class="step-n">{{ s.n }}</div><h3 class="step-t">{{ s.t }}</h3><p class="step-d">{{ s.d }}</p></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.featTitle }}</h2><div class="g4"><div v-for="f in t.feats" :key="f.t" class="feat-c"><span class="feat-ic">{{ f.ic }}</span><h4 class="feat-t">{{ f.t }}</h4><p class="feat-d">{{ f.d }}</p></div></div></div></section>

<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.notifyTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.notifySub }}</p><a href="/preregister" class="cta-btn">{{ t.notifyBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F9F3}.sec-sky{background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;margin-bottom:48px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 60px;background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.6);text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#9FE870}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:560px;margin:0 auto;line-height:1.8}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:14px}
.bill-c{padding:24px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:16px;text-align:center;transition:all .3s;position:relative}.bill-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(159,232,112,.06)}
.bill-ic{font-size:28px;display:block;margin-bottom:10px}.bill-t{font-size:14px;font-weight:800;color:#163300;margin-bottom:6px}.bill-d{font-size:11.5px;color:rgba(10,10,10,.4);line-height:1.7;margin-bottom:10px}
.bill-st{font-size:10px;font-weight:800;color:#9FE870;background:rgba(159,232,112,.06);padding:4px 10px;border-radius:6px}
.step-c{padding:32px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:18px;text-align:center}
.step-n{font-size:48px;font-weight:900;color:rgba(159,232,112,.1);line-height:1;margin-bottom:12px}
.step-t{font-size:16px;font-weight:800;color:#163300;margin-bottom:6px}.step-d{font-size:13px;color:rgba(10,10,10,.4);line-height:1.7}
.feat-c{padding:24px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:16px;text-align:center}
.feat-ic{font-size:24px;display:block;margin-bottom:8px}.feat-t{font-size:14px;font-weight:800;color:#163300;margin-bottom:6px}.feat-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.7}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:768px){.g3{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}}
</style>
