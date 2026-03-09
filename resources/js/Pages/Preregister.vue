<script setup>
import { Head, useForm, Link } from '@inertiajs/vue3';
import { ref, computed, watch } from 'vue';

const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');

const form = useForm({ full_name:'', email:'', phone:'', country:'', governorate:'', employment:'', referral:'' });
const submit = () => form.post('/preregister');

const isSyria = computed(() => form.country === 'SY');

const countries = [
  {code:'SY',ar:'سوريا 🇸🇾',en:'Syria 🇸🇾'},
  {code:'TR',ar:'تركيا 🇹🇷',en:'Turkey 🇹🇷'},
  {code:'DE',ar:'ألمانيا 🇩🇪',en:'Germany 🇩🇪'},
  {code:'SE',ar:'السويد 🇸🇪',en:'Sweden 🇸🇪'},
  {code:'DK',ar:'الدنمارك 🇩🇰',en:'Denmark 🇩🇰'},
  {code:'NL',ar:'هولندا 🇳🇱',en:'Netherlands 🇳🇱'},
  {code:'AT',ar:'النمسا 🇦🇹',en:'Austria 🇦🇹'},
  {code:'BE',ar:'بلجيكا 🇧🇪',en:'Belgium 🇧🇪'},
  {code:'FR',ar:'فرنسا 🇫🇷',en:'France 🇫🇷'},
  {code:'GB',ar:'بريطانيا 🇬🇧',en:'United Kingdom 🇬🇧'},
  {code:'US',ar:'أمريكا 🇺🇸',en:'United States 🇺🇸'},
  {code:'CA',ar:'كندا 🇨🇦',en:'Canada 🇨🇦'},
  {code:'SA',ar:'السعودية 🇸🇦',en:'Saudi Arabia 🇸🇦'},
  {code:'AE',ar:'الإمارات 🇦🇪',en:'UAE 🇦🇪'},
  {code:'QA',ar:'قطر 🇶🇦',en:'Qatar 🇶🇦'},
  {code:'KW',ar:'الكويت 🇰🇼',en:'Kuwait 🇰🇼'},
  {code:'JO',ar:'الأردن 🇯🇴',en:'Jordan 🇯🇴'},
  {code:'LB',ar:'لبنان 🇱🇧',en:'Lebanon 🇱🇧'},
  {code:'IQ',ar:'العراق 🇮🇶',en:'Iraq 🇮🇶'},
  {code:'EG',ar:'مصر 🇪🇬',en:'Egypt 🇪🇬'},
  {code:'LY',ar:'ليبيا 🇱🇾',en:'Libya 🇱🇾'},
  {code:'NO',ar:'النرويج 🇳🇴',en:'Norway 🇳🇴'},
  {code:'FI',ar:'فنلندا 🇫🇮',en:'Finland 🇫🇮'},
  {code:'IT',ar:'إيطاليا 🇮🇹',en:'Italy 🇮🇹'},
  {code:'ES',ar:'إسبانيا 🇪🇸',en:'Spain 🇪🇸'},
  {code:'GR',ar:'اليونان 🇬🇷',en:'Greece 🇬🇷'},
  {code:'AU',ar:'أستراليا 🇦🇺',en:'Australia 🇦🇺'},
  {code:'OTHER',ar:'دولة أخرى 🌍',en:'Other country 🌍'},
];

const governorates = [
  {ar:'دمشق',en:'Damascus'},
  {ar:'ريف دمشق',en:'Rif Dimashq'},
  {ar:'حلب',en:'Aleppo'},
  {ar:'حمص',en:'Homs'},
  {ar:'حماة',en:'Hama'},
  {ar:'اللاذقية',en:'Latakia'},
  {ar:'طرطوس',en:'Tartus'},
  {ar:'إدلب',en:'Idlib'},
  {ar:'الحسكة',en:'Al-Hasakah'},
  {ar:'دير الزور',en:'Deir ez-Zor'},
  {ar:'الرقة',en:'Raqqa'},
  {ar:'السويداء',en:'As-Suwayda'},
  {ar:'درعا',en:'Daraa'},
  {ar:'القنيطرة',en:'Quneitra'},
];

watch(() => form.country, (v) => { if(v !== 'SY') form.governorate = ''; });

const t = computed(() => isAr.value ? {
  title:'التسجيل المسبق — SDB Bank',
  h1:'كن من الأوائل.',
  sub:'سجّل الآن وكن من أوائل المستخدمين لأول بنك إلكتروني سوري. سنبلغك فور الإطلاق.',
  feats:['💳 بطاقات ماستركارد فورية','💱 أكثر من 30 عملة','⚡ تحويلات لـ 150+ دولة','💰 استلام المعاشات','🛡️ أمان بمعايير أوروبية','🧾 دفع الفواتير (قريباً)'],
  step1:'المعلومات الشخصية', step2:'الموقع', step3:'التفاصيل',
  cardT:'سجّل مكانك',
  cardS:'بدون التزام — سنبلغك عند الإطلاق.',
  name:'الاسم الكامل *',namePh:'أحمد محمد',
  email:'البريد الإلكتروني *',emailPh:'ahmed@example.com',
  phone:'رقم الهاتف',phonePh:'+963...',
  country:'بلد الإقامة *',countryPh:'اختر بلدك...',
  gov:'المحافظة *',govPh:'اختر المحافظة...',
  emp:'الحالة الوظيفية',empPh:'اختر...',
  empOpts:[{v:'employed',l:'موظف'},{v:'self_employed',l:'عمل حر'},{v:'student',l:'طالب'},{v:'unemployed',l:'غير موظف'},{v:'retired',l:'متقاعد'},{v:'other',l:'أخرى'}],
  ref:'كود الإحالة',refPh:'إذا عندك كود...',refOpt:'اختياري',
  btn:'سجّل الآن ←',btnL:'جاري التسجيل...',
  note:'بالتسجيل توافق على',terms:'الشروط',and:'و',privacy:'سياسة الخصوصية',
  trusted:'موثوق من قبل 50,000+ سوري حول العالم',
} : {
  title:'Early Access — SDB Bank',
  h1:'Be among the first.',
  sub:'Sign up now and be among the first users of the first Syrian digital bank. We\'ll notify you at launch.',
  feats:['💳 Instant Mastercard','💱 30+ Currencies','⚡ 150+ Countries','💰 Salary Deposits','🛡️ European Security','🧾 Bill Payments (Soon)'],
  step1:'Personal Info', step2:'Location', step3:'Details',
  cardT:'Reserve your spot',
  cardS:'No commitment — we\'ll notify you at launch.',
  name:'Full Name *',namePh:'John Smith',
  email:'Email Address *',emailPh:'john@example.com',
  phone:'Phone Number',phonePh:'+45...',
  country:'Country of Residence *',countryPh:'Select your country...',
  gov:'Governorate *',govPh:'Select governorate...',
  emp:'Employment Status',empPh:'Select...',
  empOpts:[{v:'employed',l:'Employed'},{v:'self_employed',l:'Self-employed'},{v:'student',l:'Student'},{v:'unemployed',l:'Unemployed'},{v:'retired',l:'Retired'},{v:'other',l:'Other'}],
  ref:'Referral Code',refPh:'If you have one...',refOpt:'optional',
  btn:'Join the waitlist →',btnL:'Joining...',
  note:'By joining you agree to our',terms:'Terms',and:'and',privacy:'Privacy Policy',
  trusted:'Trusted by 50,000+ Syrians worldwide',
});
</script>
<template>
<Head :title="t.title"><link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" /></Head>
<div class="pr-page" :class="{rtl:isAr}" :dir="isAr?'rtl':'ltr'">
  <div class="pr-wrap">
    <div class="pr-left">
      <div class="pr-top-row">
        <a href="/" class="pr-mark">SDB<span class="pr-dot">.</span></a>
        <button @click="lang=lang==='ar'?'en':'ar'" class="pr-lang">{{ isAr?'EN':'عربي' }}</button>
      </div>
      <h1 class="pr-h1">{{ t.h1 }}</h1>
      <p class="pr-sub">{{ t.sub }}</p>
      <div class="pr-features"><div v-for="f in t.feats" :key="f" class="pr-feat">{{ f }}</div></div>
      <div class="pr-trusted">{{ t.trusted }}</div>
    </div>
    <div class="pr-right"><div class="pr-card">
      <h2 class="pr-card-t">{{ t.cardT }}</h2>
      <p class="pr-card-s">{{ t.cardS }}</p>

      <!-- Progress indicator -->
      <div class="pr-steps"><span class="pr-step-dot active"></span><span class="pr-step-line"></span><span class="pr-step-dot active"></span><span class="pr-step-line"></span><span class="pr-step-dot active"></span></div>
      <div class="pr-step-labels"><span>{{ t.step1 }}</span><span>{{ t.step2 }}</span><span>{{ t.step3 }}</span></div>

      <form @submit.prevent="submit" class="pr-form">
        <!-- Name & Email -->
        <div class="pr-field"><label class="pr-label">{{ t.name }}</label><input v-model="form.full_name" type="text" class="pr-input" :placeholder="t.namePh" required /><div v-if="form.errors.full_name" class="pr-err">{{ form.errors.full_name }}</div></div>
        <div class="pr-field"><label class="pr-label">{{ t.email }}</label><input v-model="form.email" type="email" class="pr-input" :placeholder="t.emailPh" required /><div v-if="form.errors.email" class="pr-err">{{ form.errors.email }}</div></div>

        <!-- Phone -->
        <div class="pr-field"><label class="pr-label">{{ t.phone }}</label><input v-model="form.phone" type="tel" class="pr-input" :placeholder="t.phonePh" /></div>

        <!-- Country -->
        <div class="pr-field">
          <label class="pr-label">{{ t.country }}</label>
          <select v-model="form.country" class="pr-input pr-select" required>
            <option value="" disabled>{{ t.countryPh }}</option>
            <option v-for="c in countries" :key="c.code" :value="c.code">{{ isAr ? c.ar : c.en }}</option>
          </select>
          <div v-if="form.errors.country" class="pr-err">{{ form.errors.country }}</div>
        </div>

        <!-- Governorate (Syria only) -->
        <Transition name="slide">
        <div v-if="isSyria" class="pr-field">
          <label class="pr-label">{{ t.gov }}</label>
          <select v-model="form.governorate" class="pr-input pr-select" required>
            <option value="" disabled>{{ t.govPh }}</option>
            <option v-for="g in governorates" :key="g.en" :value="g.en">{{ isAr ? g.ar : g.en }}</option>
          </select>
        </div>
        </Transition>

        <!-- Employment -->
        <div class="pr-field">
          <label class="pr-label">{{ t.emp }}</label>
          <select v-model="form.employment" class="pr-input pr-select">
            <option value="" disabled>{{ t.empPh }}</option>
            <option v-for="o in t.empOpts" :key="o.v" :value="o.v">{{ o.l }}</option>
          </select>
        </div>

        <!-- Referral -->
        <div class="pr-field"><label class="pr-label">{{ t.ref }} <span class="pr-opt">({{ t.refOpt }})</span></label><input v-model="form.referral" type="text" class="pr-input" :placeholder="t.refPh" /></div>

        <button type="submit" class="pr-btn" :disabled="form.processing">{{ form.processing ? t.btnL : t.btn }}</button>
        <p class="pr-note">{{ t.note }} <a href="/terms">{{ t.terms }}</a> {{ t.and }} <a href="/privacy">{{ t.privacy }}</a>.</p>
      </form>
    </div></div>
  </div>
</div>
</template>
<style>
*{margin:0;padding:0;box-sizing:border-box}
.rtl{direction:rtl;text-align:right}
.pr-page{min-height:100vh;background:linear-gradient(-45deg,#F0F9FF,#E0F2FE,#BAE6FD,#F0F9FF);background-size:400% 400%;animation:prGrad 15s ease infinite;font-family:'Inter',sans-serif;display:flex;align-items:center;justify-content:center;padding:40px 24px}
@keyframes prGrad{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
.pr-wrap{display:flex;gap:60px;max-width:1000px;width:100%;align-items:flex-start}
.pr-left{flex:1;padding-top:40px}
.pr-top-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:48px}
.pr-mark{font-size:28px;font-weight:900;color:#0C4A6E;text-decoration:none;letter-spacing:-1.5px}
.pr-dot{color:#0EA5E9;font-size:32px;line-height:0}
.pr-lang{font-size:13px;font-weight:600;color:#0C4A6E;background:rgba(255,255,255,.5);border:1.5px solid rgba(12,74,110,.15);padding:6px 14px;border-radius:8px;cursor:pointer;font-family:inherit;transition:all .2s;backdrop-filter:blur(4px)}.pr-lang:hover{border-color:#0EA5E9;color:#0EA5E9}
.pr-h1{font-size:clamp(2.4rem,5vw,3.8rem);font-weight:900;line-height:1.08;letter-spacing:-.04em;color:#0C4A6E;margin-bottom:20px}
.pr-sub{font-size:16px;color:rgba(12,74,110,.55);line-height:1.8;margin-bottom:40px;max-width:380px}
.pr-features{display:flex;flex-direction:column;gap:8px;margin-bottom:32px}
.pr-feat{font-size:14px;font-weight:600;color:rgba(12,74,110,.6);padding:10px 0;border-bottom:1px solid rgba(14,165,233,.08)}
.pr-trusted{font-size:13px;font-weight:700;color:#059669;padding:12px 16px;background:rgba(5,150,105,.06);border-radius:10px;display:inline-block}
.pr-right{flex:1;max-width:450px}
.pr-card{padding:36px;background:#fff;border:1px solid rgba(14,165,233,.08);border-radius:24px;box-shadow:0 16px 48px rgba(0,0,0,.06)}
.pr-card-t{font-size:24px;font-weight:900;color:#0C4A6E;margin-bottom:4px;letter-spacing:-.03em}
.pr-card-s{font-size:13px;color:rgba(12,74,110,.4);margin-bottom:24px}

/* Steps indicator */
.pr-steps{display:flex;align-items:center;justify-content:center;gap:0;margin-bottom:8px}
.pr-step-dot{width:10px;height:10px;border-radius:50%;background:#BAE6FD;transition:all .3s}
.pr-step-dot.active{background:#0EA5E9}
.pr-step-line{flex:1;height:2px;background:#BAE6FD;max-width:60px}
.pr-step-labels{display:flex;justify-content:space-between;margin-bottom:24px;font-size:10px;font-weight:700;color:rgba(12,74,110,.3);text-transform:uppercase;letter-spacing:.5px}
.rtl .pr-step-labels{letter-spacing:0}

.pr-form{display:flex;flex-direction:column;gap:16px}
.pr-field{display:flex;flex-direction:column;gap:5px}
.pr-label{font-size:12px;font-weight:700;color:rgba(12,74,110,.55);letter-spacing:.3px}
.pr-opt{font-weight:400;opacity:.6}
.pr-input{padding:13px 16px;border:1.5px solid rgba(14,165,233,.1);border-radius:12px;font-size:14px;font-family:inherit;outline:none;color:#0C4A6E;transition:all .2s;background:#F8FAFC}.pr-input:focus{border-color:#0EA5E9;background:#fff;box-shadow:0 0 0 3px rgba(14,165,233,.08)}.pr-input::placeholder{color:#BAE6FD}
.pr-select{cursor:pointer;appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath d='M6 8L1 3h10z' fill='%230EA5E9'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 16px center;background-size:12px}
.rtl .pr-select{background-position:left 16px center}
.pr-err{font-size:12px;color:#ef4444;font-weight:600}
.pr-btn{padding:16px;background:linear-gradient(135deg,#0284C7,#0EA5E9);color:#fff;border:none;border-radius:14px;font-size:16px;font-weight:800;cursor:pointer;font-family:inherit;transition:all .2s;margin-top:4px}.pr-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(14,165,233,.25)}.pr-btn:disabled{opacity:.5;cursor:not-allowed;transform:none}
.pr-note{font-size:11px;color:rgba(12,74,110,.3);text-align:center;line-height:1.5}.pr-note a{color:#0EA5E9;text-decoration:underline;font-weight:600}

/* Slide transition for governorate */
.slide-enter-active,.slide-leave-active{transition:all .3s ease;overflow:hidden}
.slide-enter-from,.slide-leave-to{opacity:0;max-height:0;margin:0}.slide-enter-to,.slide-leave-from{opacity:1;max-height:80px}

@media(max-width:768px){.pr-wrap{flex-direction:column;gap:32px}.pr-left{padding-top:0}.pr-right{max-width:100%;width:100%}}
</style>
