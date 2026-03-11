<script setup>
import { Head, useForm, Link } from '@inertiajs/vue3';
import { inject, ref, computed, watch } from 'vue';

const lang = ref('ar');
const isAr = computed(() => lang.value === 'ar');
const isBiz = inject('isBiz', computed(() => false));

const form = useForm({ full_name:'', email:'', phone:'', country:'', governorate:'', employment:'', referral:'', account_type:'personal' });
const bizForm = useForm({ company_name:'', registration_number:'', company_type:'', authorized_person:'', email:'', phone:'', country:'', referral:'', account_type:'business' });
const submit = () => { if(isBiz.value) bizForm.post('/preregister'); else form.post('/preregister'); };
const isSyria = computed(() => form.country === 'SY');

/* ── Country-specific registration labels (EU27 + Arab22 + others) ── */
const regLabels = {
  DK:{ar:'رقم CVR *',en:'CVR Number *',ph:'12345678'},
  DE:{ar:'رقم Handelsregister *',en:'Handelsregister Number *',ph:'HRB 12345'},
  SE:{ar:'رقم Organisationsnummer *',en:'Organisationsnummer *',ph:'556123-4567'},
  NL:{ar:'رقم KvK *',en:'KvK Number *',ph:'12345678'},
  AT:{ar:'رقم Firmenbuch *',en:'Firmenbuch Number *',ph:'FN 123456a'},
  FR:{ar:'رقم SIRET *',en:'SIRET Number *',ph:'123 456 789 00012'},
  BE:{ar:'رقم BCE *',en:'BCE Number *',ph:'0123.456.789'},
  IT:{ar:'رقم Partita IVA *',en:'Partita IVA *',ph:'IT12345678901'},
  ES:{ar:'رقم CIF *',en:'CIF Number *',ph:'B12345678'},
  FI:{ar:'رقم Y-tunnus *',en:'Y-tunnus *',ph:'1234567-8'},
  GR:{ar:'رقم GEMI *',en:'GEMI Number *',ph:'123456789'},
  PT:{ar:'رقم NIPC *',en:'NIPC Number *',ph:'123456789'},
  IE:{ar:'رقم CRO *',en:'CRO Number *',ph:'123456'},
  PL:{ar:'رقم KRS *',en:'KRS Number *',ph:'0000123456'},
  CZ:{ar:'رقم IČO *',en:'IČO Number *',ph:'12345678'},
  RO:{ar:'رقم CUI *',en:'CUI Number *',ph:'RO12345678'},
  BG:{ar:'رقم EIK *',en:'EIK Number *',ph:'123456789'},
  HR:{ar:'رقم OIB *',en:'OIB Number *',ph:'12345678901'},
  HU:{ar:'رقم Cégjegyzékszám *',en:'Cégjegyzékszám *',ph:'01-09-123456'},
  SK:{ar:'رقم IČO *',en:'IČO Number *',ph:'12345678'},
  SI:{ar:'رقم Matična *',en:'Registration Number *',ph:'1234567000'},
  LT:{ar:'رقم Įmonės kodas *',en:'Company Code *',ph:'123456789'},
  LV:{ar:'رقم Reģ. Nr. *',en:'Registration Nr. *',ph:'40003123456'},
  EE:{ar:'رقم Äriregistri kood *',en:'Registry Code *',ph:'12345678'},
  CY:{ar:'رقم HE *',en:'HE Number *',ph:'HE 123456'},
  MT:{ar:'رقم C- *',en:'Company Number *',ph:'C 12345'},
  LU:{ar:'رقم RCS *',en:'RCS Number *',ph:'B123456'},
  GB:{ar:'رقم Companies House *',en:'Companies House Number *',ph:'12345678'},
  NO:{ar:'رقم Organisasjonsnummer *',en:'Organisasjonsnummer *',ph:'123 456 789'},
  CH:{ar:'رقم CHE *',en:'CHE Number *',ph:'CHE-123.456.789'},
  SY:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  SA:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'1010123456'},
  AE:{ar:'رقم الرخصة التجارية *',en:'Trade License Number *',ph:'123456'},
  QA:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  KW:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  BH:{ar:'رقم السجل التجاري *',en:'CR Number *',ph:'12345-1'},
  OM:{ar:'رقم السجل التجاري *',en:'CR Number *',ph:'1234567'},
  JO:{ar:'رقم السجل التجاري *',en:'Company Register No. *',ph:'12345'},
  LB:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  IQ:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  EG:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  LY:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  TN:{ar:'رقم السجل التجاري *',en:'Registre de Commerce *',ph:'B1234562019'},
  DZ:{ar:'رقم السجل التجاري *',en:'Registre de Commerce *',ph:'12/00-1234567B19'},
  MA:{ar:'رقم السجل التجاري *',en:'Registre de Commerce *',ph:'12345'},
  MR:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  SD:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  SO:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  DJ:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  KM:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  PS:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  YE:{ar:'رقم السجل التجاري *',en:'Commercial Register No. *',ph:'12345'},
  TR:{ar:'رقم Vergi *',en:'Tax Number (Vergi) *',ph:'1234567890'},
  US:{ar:'رقم EIN *',en:'EIN Number *',ph:'12-3456789'},
  CA:{ar:'رقم Business Number *',en:'Business Number (BN) *',ph:'123456789RC0001'},
  AU:{ar:'رقم ABN *',en:'ABN *',ph:'12 345 678 901'},
};
const defaultReg = {ar:'رقم تسجيل الشركة *',en:'Company Registration No. *',ph:'123456'};
const regLabel = computed(() => { const r = regLabels[bizForm.country] || defaultReg; return { label: isAr.value ? r.ar : r.en, ph: r.ph }; });

const countries = [
  {code:'SY',ar:'سوريا 🇸🇾',en:'Syria 🇸🇾'},{code:'PS',ar:'فلسطين 🇵🇸',en:'Palestine 🇵🇸'},
  {code:'JO',ar:'الأردن 🇯🇴',en:'Jordan 🇯🇴'},{code:'LB',ar:'لبنان 🇱🇧',en:'Lebanon 🇱🇧'},
  {code:'IQ',ar:'العراق 🇮🇶',en:'Iraq 🇮🇶'},{code:'SA',ar:'السعودية 🇸🇦',en:'Saudi Arabia 🇸🇦'},
  {code:'AE',ar:'الإمارات 🇦🇪',en:'UAE 🇦🇪'},{code:'QA',ar:'قطر 🇶🇦',en:'Qatar 🇶🇦'},
  {code:'KW',ar:'الكويت 🇰🇼',en:'Kuwait 🇰🇼'},{code:'BH',ar:'البحرين 🇧🇭',en:'Bahrain 🇧🇭'},
  {code:'OM',ar:'عُمان 🇴🇲',en:'Oman 🇴🇲'},{code:'YE',ar:'اليمن 🇾🇪',en:'Yemen 🇾🇪'},
  {code:'EG',ar:'مصر 🇪🇬',en:'Egypt 🇪🇬'},{code:'SD',ar:'السودان 🇸🇩',en:'Sudan 🇸🇩'},
  {code:'LY',ar:'ليبيا 🇱🇾',en:'Libya 🇱🇾'},{code:'TN',ar:'تونس 🇹🇳',en:'Tunisia 🇹🇳'},
  {code:'DZ',ar:'الجزائر 🇩🇿',en:'Algeria 🇩🇿'},{code:'MA',ar:'المغرب 🇲🇦',en:'Morocco 🇲🇦'},
  {code:'MR',ar:'موريتانيا 🇲🇷',en:'Mauritania 🇲🇷'},{code:'SO',ar:'الصومال 🇸🇴',en:'Somalia 🇸🇴'},
  {code:'DJ',ar:'جيبوتي 🇩🇯',en:'Djibouti 🇩🇯'},{code:'KM',ar:'جزر القمر 🇰🇲',en:'Comoros 🇰🇲'},
  {code:'DK',ar:'الدنمارك 🇩🇰',en:'Denmark 🇩🇰'},{code:'DE',ar:'ألمانيا 🇩🇪',en:'Germany 🇩🇪'},
  {code:'FR',ar:'فرنسا 🇫🇷',en:'France 🇫🇷'},{code:'NL',ar:'هولندا 🇳🇱',en:'Netherlands 🇳🇱'},
  {code:'BE',ar:'بلجيكا 🇧🇪',en:'Belgium 🇧🇪'},{code:'LU',ar:'لوكسمبورغ 🇱🇺',en:'Luxembourg 🇱🇺'},
  {code:'IT',ar:'إيطاليا 🇮🇹',en:'Italy 🇮🇹'},{code:'ES',ar:'إسبانيا 🇪🇸',en:'Spain 🇪🇸'},
  {code:'PT',ar:'البرتغال 🇵🇹',en:'Portugal 🇵🇹'},{code:'AT',ar:'النمسا 🇦🇹',en:'Austria 🇦🇹'},
  {code:'SE',ar:'السويد 🇸🇪',en:'Sweden 🇸🇪'},{code:'FI',ar:'فنلندا 🇫🇮',en:'Finland 🇫🇮'},
  {code:'IE',ar:'أيرلندا 🇮🇪',en:'Ireland 🇮🇪'},{code:'GR',ar:'اليونان 🇬🇷',en:'Greece 🇬🇷'},
  {code:'PL',ar:'بولندا 🇵🇱',en:'Poland 🇵🇱'},{code:'CZ',ar:'التشيك 🇨🇿',en:'Czech Republic 🇨🇿'},
  {code:'RO',ar:'رومانيا 🇷🇴',en:'Romania 🇷🇴'},{code:'BG',ar:'بلغاريا 🇧🇬',en:'Bulgaria 🇧🇬'},
  {code:'HR',ar:'كرواتيا 🇭🇷',en:'Croatia 🇭🇷'},{code:'HU',ar:'المجر 🇭🇺',en:'Hungary 🇭🇺'},
  {code:'SK',ar:'سلوفاكيا 🇸🇰',en:'Slovakia 🇸🇰'},{code:'SI',ar:'سلوفينيا 🇸🇮',en:'Slovenia 🇸🇮'},
  {code:'LT',ar:'ليتوانيا 🇱🇹',en:'Lithuania 🇱🇹'},{code:'LV',ar:'لاتفيا 🇱🇻',en:'Latvia 🇱🇻'},
  {code:'EE',ar:'إستونيا 🇪🇪',en:'Estonia 🇪🇪'},{code:'CY',ar:'قبرص 🇨🇾',en:'Cyprus 🇨🇾'},
  {code:'MT',ar:'مالطا 🇲🇹',en:'Malta 🇲🇹'},
  {code:'GB',ar:'بريطانيا 🇬🇧',en:'United Kingdom 🇬🇧'},{code:'NO',ar:'النرويج 🇳🇴',en:'Norway 🇳🇴'},
  {code:'CH',ar:'سويسرا 🇨🇭',en:'Switzerland 🇨🇭'},{code:'TR',ar:'تركيا 🇹🇷',en:'Turkey 🇹🇷'},
  {code:'US',ar:'أمريكا 🇺🇸',en:'United States 🇺🇸'},{code:'CA',ar:'كندا 🇨🇦',en:'Canada 🇨🇦'},
  {code:'AU',ar:'أستراليا 🇦🇺',en:'Australia 🇦🇺'},{code:'OTHER',ar:'دولة أخرى 🌍',en:'Other country 🌍'},
];
const governorates = [
  {ar:'دمشق',en:'Damascus'},{ar:'ريف دمشق',en:'Rif Dimashq'},{ar:'حلب',en:'Aleppo'},
  {ar:'حمص',en:'Homs'},{ar:'حماة',en:'Hama'},{ar:'اللاذقية',en:'Latakia'},
  {ar:'طرطوس',en:'Tartus'},{ar:'إدلب',en:'Idlib'},{ar:'الحسكة',en:'Al-Hasakah'},
  {ar:'دير الزور',en:'Deir ez-Zor'},{ar:'الرقة',en:'Raqqa'},{ar:'السويداء',en:'As-Suwayda'},
  {ar:'درعا',en:'Daraa'},{ar:'القنيطرة',en:'Quneitra'},
];
watch(() => form.country, v => { if(v !== 'SY') form.governorate = ''; });

const t = computed(() => isAr.value ? {
  title:'التسجيل المسبق — SDB Bank',h1:'كن من الأوائل.',
  sub:'سجّل الآن وكن من أوائل المستخدمين لأول بنك إلكتروني سوري. سنبلغك فور الإطلاق.',
  feats:['💳 بطاقات ماستركارد فورية','💱 أكثر من 30 عملة','⚡ تحويلات لـ 150+ دولة','💰 استلام المعاشات','🛡️ أمان بمعايير أوروبية','🧾 دفع الفواتير (قريباً)'],
  step1:'المعلومات الشخصية',step2:'الموقع',step3:'التفاصيل',
  cardT:'سجّل مكانك',cardS:'بدون التزام — سنبلغك عند الإطلاق.',
  name:'الاسم الكامل *',namePh:'أحمد محمد',email:'البريد الإلكتروني *',emailPh:'ahmed@example.com',
  phone:'رقم الهاتف',phonePh:'+963...',country:'بلد الإقامة *',countryPh:'اختر بلدك...',
  gov:'المحافظة *',govPh:'اختر المحافظة...',emp:'الحالة الوظيفية',empPh:'اختر...',
  empOpts:[{v:'employed',l:'موظف'},{v:'self_employed',l:'عمل حر'},{v:'student',l:'طالب'},{v:'unemployed',l:'غير موظف'},{v:'retired',l:'متقاعد'},{v:'other',l:'أخرى'}],
  ref:'كود الإحالة',refPh:'إذا عندك كود...',refOpt:'اختياري',
  btn:'سجّل الآن ←',btnL:'جاري التسجيل...',
  note:'بالتسجيل توافق على',terms:'الشروط',and:'و',privacy:'سياسة الخصوصية',
  trusted:'موثوق من قبل 50,000+ سوري حول العالم',
} : {
  title:'Early Access — SDB Bank',h1:'Be among the first.',
  sub:'Sign up now and be among the first users of the first Syrian digital bank. We\'ll notify you at launch.',
  feats:['💳 Instant Mastercard','💱 30+ Currencies','⚡ 150+ Countries','💰 Salary Deposits','🛡️ European Security','🧾 Bill Payments (Soon)'],
  step1:'Personal Info',step2:'Location',step3:'Details',
  cardT:'Reserve your spot',cardS:'No commitment — we\'ll notify you at launch.',
  name:'Full Name *',namePh:'John Smith',email:'Email Address *',emailPh:'john@example.com',
  phone:'Phone Number',phonePh:'+45...',country:'Country of Residence *',countryPh:'Select your country...',
  gov:'Governorate *',govPh:'Select governorate...',emp:'Employment Status',empPh:'Select...',
  empOpts:[{v:'employed',l:'Employed'},{v:'self_employed',l:'Self-employed'},{v:'student',l:'Student'},{v:'unemployed',l:'Unemployed'},{v:'retired',l:'Retired'},{v:'other',l:'Other'}],
  ref:'Referral Code',refPh:'If you have one...',refOpt:'optional',
  btn:'Join the waitlist →',btnL:'Joining...',
  note:'By joining you agree to our',terms:'Terms',and:'and',privacy:'Privacy Policy',
  trusted:'Trusted by 50,000+ Syrians worldwide',
});

const tb = computed(() => isAr.value ? {
  title:'تسجيل حساب أعمال — SDB Business',h1:'سجّل شركتك.',
  sub:'افتح حساب أعمال احترافي. نت بنك متكامل مع تحويلات SWIFT وإدارة فريق.',
  feats:['🖥️ نت بنك متطور','👥 إدارة الفريق والصلاحيات','💱 محافظ متعددة العملات','🌐 تحويلات SWIFT دولية','📊 تقارير مالية متقدمة','🔐 أمان مؤسسي'],
  step1:'بيانات الشركة',step2:'المسؤول',step3:'التفاصيل',
  cardT:'سجّل شركتك',cardS:'سنتواصل معك لإكمال فتح الحساب.',
  companyName:'اسم الشركة *',companyNamePh:'شركة المثال التجارية',
  companyType:'نوع الشركة *',companyTypePh:'اختر نوع الشركة...',
  companyTypes:[{v:'llc',l:'شركة ذات مسؤولية محدودة'},{v:'jsc',l:'شركة مساهمة'},{v:'sole',l:'مؤسسة فردية'},{v:'partnership',l:'شركة تضامنية'},{v:'ngo',l:'منظمة غير ربحية'},{v:'other',l:'أخرى'}],
  authPerson:'اسم المسؤول المفوض *',authPersonPh:'أحمد محمد',
  email:'البريد الإلكتروني للشركة *',emailPh:'info@company.com',
  phone:'رقم هاتف الشركة',phonePh:'+963...',
  country:'بلد تسجيل الشركة *',countryPh:'اختر البلد...',
  ref:'كود الإحالة',refPh:'إذا عندك كود...',refOpt:'اختياري',
  btn:'سجّل شركتك ←',btnL:'جاري التسجيل...',
  note:'بالتسجيل توافق على',terms:'الشروط',and:'و',privacy:'سياسة الخصوصية',
  trusted:'أكثر من 500 شركة تثق بنا',
} : {
  title:'Business Account — SDB Business',h1:'Register your company.',
  sub:'Open a professional business account. Net banking with SWIFT transfers and team management.',
  feats:['🖥️ Advanced Net Banking','👥 Team & Permissions','💱 Multi-Currency Wallets','🌐 SWIFT Transfers','📊 Advanced Reports','🔐 Enterprise Security'],
  step1:'Company Info',step2:'Contact Person',step3:'Details',
  cardT:'Register your company',cardS:'We\'ll contact you to complete setup.',
  companyName:'Company Name *',companyNamePh:'Example Trading Co.',
  companyType:'Company Type *',companyTypePh:'Select company type...',
  companyTypes:[{v:'llc',l:'LLC'},{v:'jsc',l:'Joint Stock'},{v:'sole',l:'Sole Proprietorship'},{v:'partnership',l:'Partnership'},{v:'ngo',l:'Non-Profit'},{v:'other',l:'Other'}],
  authPerson:'Authorized Person *',authPersonPh:'John Smith',
  email:'Company Email *',emailPh:'info@company.com',
  phone:'Company Phone',phonePh:'+45...',
  country:'Country of Registration *',countryPh:'Select country...',
  ref:'Referral Code',refPh:'If you have one...',refOpt:'optional',
  btn:'Register your company →',btnL:'Registering...',
  note:'By registering you agree to our',terms:'Terms',and:'and',privacy:'Privacy Policy',
  trusted:'Trusted by 500+ businesses',
});
const tx = computed(() => isBiz.value ? tb.value : t.value);
</script>
<template>
<Head :title="tx.title"><link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" /></Head>
<div class="pr-page" :class="{rtl:isAr}" :dir="isAr?'rtl':'ltr'">
  <div class="pr-wrap">
    <div class="pr-left">
      <div class="pr-top-row">
        <a href="/" class="pr-mark">SDB<span class="sdb-flag"></span></a>
        <button @click="lang=lang==='ar'?'en':'ar'" class="pr-lang">{{ isAr?'EN':'عربي' }}</button>
      </div>
      <h1 class="pr-h1">{{ tx.h1 }}</h1>
      <p class="pr-sub">{{ tx.sub }}</p>
      <div class="pr-features"><div v-for="f in tx.feats" :key="f" class="pr-feat">{{ f }}</div></div>
      <div class="pr-trusted">{{ tx.trusted }}</div>
    </div>
    <div class="pr-right"><div class="pr-card">
      <h2 class="pr-card-t">{{ tx.cardT }}</h2>
      <p class="pr-card-s">{{ tx.cardS }}</p>
      <div class="pr-steps"><span class="pr-step-dot active"></span><span class="pr-step-line"></span><span class="pr-step-dot active"></span><span class="pr-step-line"></span><span class="pr-step-dot active"></span></div>
      <div class="pr-step-labels"><span>{{ tx.step1 }}</span><span>{{ tx.step2 }}</span><span>{{ tx.step3 }}</span></div>

      <!-- ═══ BUSINESS FORM ═══ -->
      <form v-if="isBiz" @submit.prevent="submit" class="pr-form">
        <div class="pr-field"><label class="pr-label">{{ tb.companyName }}</label><input v-model="bizForm.company_name" type="text" class="pr-input" :placeholder="tb.companyNamePh" required /><div v-if="bizForm.errors.company_name" class="pr-err">{{ bizForm.errors.company_name }}</div></div>
        <div class="pr-field">
          <label class="pr-label">{{ tb.country }}</label>
          <select v-model="bizForm.country" class="pr-input pr-select" required>
            <option value="" disabled>{{ tb.countryPh }}</option>
            <option v-for="c in countries" :key="c.code" :value="c.code">{{ isAr ? c.ar : c.en }}</option>
          </select>
        </div>
        <Transition name="slide"><div v-if="bizForm.country" class="pr-field">
          <label class="pr-label">{{ regLabel.label }}</label>
          <input v-model="bizForm.registration_number" type="text" class="pr-input" :placeholder="regLabel.ph" required />
          <div v-if="bizForm.errors.registration_number" class="pr-err">{{ bizForm.errors.registration_number }}</div>
        </div></Transition>
        <div class="pr-field">
          <label class="pr-label">{{ tb.companyType }}</label>
          <select v-model="bizForm.company_type" class="pr-input pr-select" required>
            <option value="" disabled>{{ tb.companyTypePh }}</option>
            <option v-for="o in tb.companyTypes" :key="o.v" :value="o.v">{{ o.l }}</option>
          </select>
        </div>
        <div class="pr-field"><label class="pr-label">{{ tb.authPerson }}</label><input v-model="bizForm.authorized_person" type="text" class="pr-input" :placeholder="tb.authPersonPh" required /></div>
        <div class="pr-field"><label class="pr-label">{{ tb.email }}</label><input v-model="bizForm.email" type="email" class="pr-input" :placeholder="tb.emailPh" required /><div v-if="bizForm.errors.email" class="pr-err">{{ bizForm.errors.email }}</div></div>
        <div class="pr-field"><label class="pr-label">{{ tb.phone }}</label><input v-model="bizForm.phone" type="tel" class="pr-input" :placeholder="tb.phonePh" /></div>
        <div class="pr-field"><label class="pr-label">{{ tb.ref }} <span class="pr-opt">({{ tb.refOpt }})</span></label><input v-model="bizForm.referral" type="text" class="pr-input" :placeholder="tb.refPh" /></div>
        <button type="submit" class="pr-btn pr-btn-biz" :disabled="bizForm.processing">{{ bizForm.processing ? tb.btnL : tb.btn }}</button>
        <p class="pr-note">{{ tb.note }} <a href="/terms">{{ tb.terms }}</a> {{ tb.and }} <a href="/privacy">{{ tb.privacy }}</a>.</p>
      </form>

      <!-- ═══ PERSONAL FORM ═══ -->
      <form v-else @submit.prevent="submit" class="pr-form">
        <div class="pr-field"><label class="pr-label">{{ t.name }}</label><input v-model="form.full_name" type="text" class="pr-input" :placeholder="t.namePh" required /><div v-if="form.errors.full_name" class="pr-err">{{ form.errors.full_name }}</div></div>
        <div class="pr-field"><label class="pr-label">{{ t.email }}</label><input v-model="form.email" type="email" class="pr-input" :placeholder="t.emailPh" required /><div v-if="form.errors.email" class="pr-err">{{ form.errors.email }}</div></div>
        <div class="pr-field"><label class="pr-label">{{ t.phone }}</label><input v-model="form.phone" type="tel" class="pr-input" :placeholder="t.phonePh" /></div>
        <div class="pr-field">
          <label class="pr-label">{{ t.country }}</label>
          <select v-model="form.country" class="pr-input pr-select" required>
            <option value="" disabled>{{ t.countryPh }}</option>
            <option v-for="c in countries" :key="c.code" :value="c.code">{{ isAr ? c.ar : c.en }}</option>
          </select>
          <div v-if="form.errors.country" class="pr-err">{{ form.errors.country }}</div>
        </div>
        <Transition name="slide"><div v-if="isSyria" class="pr-field">
          <label class="pr-label">{{ t.gov }}</label>
          <select v-model="form.governorate" class="pr-input pr-select" required>
            <option value="" disabled>{{ t.govPh }}</option>
            <option v-for="g in governorates" :key="g.en" :value="g.en">{{ isAr ? g.ar : g.en }}</option>
          </select>
        </div></Transition>
        <div class="pr-field">
          <label class="pr-label">{{ t.emp }}</label>
          <select v-model="form.employment" class="pr-input pr-select">
            <option value="" disabled>{{ t.empPh }}</option>
            <option v-for="o in t.empOpts" :key="o.v" :value="o.v">{{ o.l }}</option>
          </select>
        </div>
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
.pr-page{min-height:100vh;background:linear-gradient(-45deg,#F5F9F3,#E8F5E0,#E8F5E0,#F5F9F3);background-size:400% 400%;animation:prGrad 15s ease infinite;font-family:'Inter',sans-serif;display:flex;align-items:center;justify-content:center;padding:40px 24px}
@keyframes prGrad{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
.pr-wrap{display:flex;gap:60px;max-width:1000px;width:100%;align-items:flex-start}
.pr-left{flex:1;padding-top:40px}
.pr-top-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:48px}
.pr-mark{font-size:28px;font-weight:900;color:#163300;text-decoration:none;letter-spacing:-1.5px}
.pr-lang{font-size:13px;font-weight:600;color:#163300;background:rgba(255,255,255,.5);border:1.5px solid rgba(22,51,0,.15);padding:6px 14px;border-radius:8px;cursor:pointer;font-family:inherit;transition:all .2s;backdrop-filter:blur(4px)}.pr-lang:hover{border-color:#9FE870;color:#9FE870}
.pr-h1{font-size:clamp(2.4rem,5vw,3.8rem);font-weight:900;line-height:1.08;letter-spacing:-.04em;color:#163300;margin-bottom:20px}
.pr-sub{font-size:16px;color:rgba(22,51,0,.55);line-height:1.8;margin-bottom:40px;max-width:380px}
.pr-features{display:flex;flex-direction:column;gap:8px;margin-bottom:32px}
.pr-feat{font-size:14px;font-weight:600;color:rgba(22,51,0,.6);padding:10px 0;border-bottom:1px solid rgba(159,232,112,.08)}
.pr-trusted{font-size:13px;font-weight:700;color:#059669;padding:12px 16px;background:rgba(45,106,0,.06);border-radius:10px;display:inline-block}
.pr-right{flex:1;max-width:450px}
.pr-card{padding:36px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:24px;box-shadow:0 16px 48px rgba(0,0,0,.06)}
.pr-card-t{font-size:24px;font-weight:900;color:#163300;margin-bottom:4px;letter-spacing:-.03em}
.pr-card-s{font-size:13px;color:rgba(22,51,0,.4);margin-bottom:24px}
.pr-steps{display:flex;align-items:center;justify-content:center;gap:0;margin-bottom:8px}
.pr-step-dot{width:10px;height:10px;border-radius:50%;background:#E8F5E0;transition:all .3s}
.pr-step-dot.active{background:#9FE870}
.pr-step-line{flex:1;height:2px;background:#E8F5E0;max-width:60px}
.pr-step-labels{display:flex;justify-content:space-between;margin-bottom:24px;font-size:10px;font-weight:700;color:rgba(22,51,0,.3);text-transform:uppercase;letter-spacing:.5px}
.rtl .pr-step-labels{letter-spacing:0}
.pr-form{display:flex;flex-direction:column;gap:16px}
.pr-field{display:flex;flex-direction:column;gap:5px}
.pr-label{font-size:12px;font-weight:700;color:rgba(22,51,0,.55);letter-spacing:.3px}
.pr-opt{font-weight:400;opacity:.6}
.pr-input{padding:13px 16px;border:1.5px solid rgba(159,232,112,.1);border-radius:12px;font-size:14px;font-family:inherit;outline:none;color:#163300;transition:all .2s;background:#F8FAFC}.pr-input:focus{border-color:#9FE870;background:#fff;box-shadow:0 0 0 3px rgba(159,232,112,.08)}.pr-input::placeholder{color:#E8F5E0}
.pr-select{cursor:pointer;appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath d='M6 8L1 3h10z' fill='%230EA5E9'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 16px center;background-size:12px}
.rtl .pr-select{background-position:left 16px center}
.pr-err{font-size:12px;color:#ef4444;font-weight:600}
.pr-btn{padding:16px;background:linear-gradient(135deg,#2D6A00,#9FE870);color:#fff;border:none;border-radius:14px;font-size:16px;font-weight:800;cursor:pointer;font-family:inherit;transition:all .2s;margin-top:4px}.pr-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(159,232,112,.25)}.pr-btn:disabled{opacity:.5;cursor:not-allowed;transform:none}
.pr-btn-biz{background:linear-gradient(135deg,#163300,#2D6A00)}
.pr-note{font-size:11px;color:rgba(22,51,0,.3);text-align:center;line-height:1.5}.pr-note a{color:#9FE870;text-decoration:underline;font-weight:600}
.slide-enter-active,.slide-leave-active{transition:all .3s ease;overflow:hidden}
.slide-enter-from,.slide-leave-to{opacity:0;max-height:0;margin:0}.slide-enter-to,.slide-leave-from{opacity:1;max-height:80px}
@media(max-width:768px){
  .pr-wrap{flex-direction:column;gap:32px;padding:0 16px}
  .pr-left{padding-top:0;text-align:center}
  .pr-right{max-width:100%;width:100%}
  .pr-card{padding:28px 20px}
  .pr-feat{font-size:14px;padding:12px 0}
}
</style>
