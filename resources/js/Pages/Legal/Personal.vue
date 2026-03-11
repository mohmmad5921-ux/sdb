<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'الحساب الشخصي — SDB Bank',tag:'حساب شخصي',
  heroH:'حسابك الشخصي.',heroEm:'بمعايير عالمية.',
  heroP:'أكثر من مجرد حساب بنكي — منصة مالية متكاملة تمنحك بطاقة ماستركارد فورية، تحويلات مجانية، صرف عملات بأسعار حقيقية، وتحكم كامل من هاتفك.',
  heroBtn:'افتح حسابك مجاناً ←',
  whyTitle:'لماذا SDB؟',whyFade:'الفرق واضح.',
  whyCards:[
    {ic:'⚡',t:'فتح فوري',d:'حساب جاهز خلال 5 دقائق. لا فروع، لا أوراق، لا مواعيد. فقط هاتفك وإثبات هوية.'},
    {ic:'🆓',t:'مجاني بالكامل',d:'لا رسوم شهرية، لا رسوم فتح، لا رسوم صيانة. حسابك مجاني للأبد مع باقة Standard.'},
    {ic:'🌍',t:'150+ دولة',d:'أرسل واستلم أموال من وإلى أكثر من 150 دولة. IBAN دولي حقيقي يعمل بكل مكان.'},
    {ic:'💳',t:'بطاقة فورية',d:'بطاقة ماستركارد افتراضية فورية لحظة فتح الحساب. ادفع أونلاين أو أضفها لـ Apple Pay.'},
    {ic:'🔒',t:'أمان بنكي',d:'تشفير AES-256، مصادقة بيومترية، CVV ديناميكي، تجميد فوري، مراقبة احتيال 24/7.'},
    {ic:'📊',t:'تحليلات ذكية',d:'تتبع مصاريفك بالذكاء الاصطناعي. تصنيف تلقائي، ميزانيات، تقارير شهرية مفصّلة.'},
  ],
  inclTitle:'ماذا يتضمن حسابك؟',
  inclSections:[
    {cat:'الأساسيات',items:['IBAN دولي حقيقي','بطاقة ماستركارد افتراضية مجانية','تطبيق ذكي iOS و Android','واجهة عربية كاملة RTL','إشعارات فورية لكل عملية','دعم فني 24/7']},
    {cat:'التحويلات',items:['تحويلات داخلية مجانية غير محدودة','تحويلات SEPA أوروبية مجانية','تحويلات SWIFT دولية بـ 0.5%','تحويلات فورية بين عملاء SDB','جدولة تحويلات تلقائية','تتبع التحويلات لحظياً']},
    {cat:'العملات',items:['دعم 30+ عملة','صرف بأسعار السوق الحقيقية','تحويل بين العملات فوري','لا هوامش ربح مخفية','تنبيهات أسعار الصرف','محافظ متعددة العملات']},
    {cat:'الأمان',items:['تشفير AES-256','مصادقة Face ID / بصمة','CVV ديناميكي يتغير كل ساعة','تجميد/إلغاء تجميد فوري','3D Secure للمشتريات','مراقبة احتيال بالذكاء الاصطناعي']},
  ],
  stepsTitle:'افتح حسابك بـ 3 خطوات',
  steps:[
    {n:'01',ic:'📱',t:'حمّل التطبيق',d:'حمّل تطبيق SDB Bank من App Store أو Google Play وابدأ التسجيل.'},
    {n:'02',ic:'🪪',t:'تحقق من هويتك',d:'صوّر هويتك أو جواز سفرك + صورة سيلفي. نظام KYC الرقمي يتحقق خلال دقائق.'},
    {n:'03',ic:'🎉',t:'حسابك جاهز!',d:'بطاقتك الافتراضية جاهزة فوراً. ابدأ بالتحويل، الدفع، وإدارة أموالك.'},
  ],
  compTitle:'SDB مقارنة بالبنوك التقليدية',
  compHeaders:['الميزة','SDB Bank','بنك تقليدي'],
  compRows:[
    ['فتح حساب','5 دقائق ✅','3-7 أيام ❌'],['رسوم شهرية','مجاني ✅','€5-15/شهر ❌'],['بطاقة ماستركارد','فورية ✅','7-14 يوم ❌'],
    ['تحويل داخلي','مجاني فوري ✅','€1-5 رسوم ❌'],['تحويل دولي','0.5% ✅','2-5% ❌'],['صرف عملات','سعر السوق ✅','هامش 3%+ ❌'],
    ['تطبيق ذكي','كامل ✅','محدود ❌'],['دعم 24/7','✅','❌'],['KYC رقمي','✅','زيارة فرع ❌'],['Apple/Google Pay','✅','حسب البنك'],
  ],
  limitsTitle:'الحدود والرسوم',
  limits:[
    {t:'سحب ATM',v:'€500/يوم مجاناً',d:'Standard — يزيد مع الباقات الأعلى'},
    {t:'تحويل شهري',v:'€5,000',d:'Standard — حتى €200,000 مع Elite'},
    {t:'صرف عملات',v:'€1,000/شهر مجاناً',d:'Standard — غير محدود مع Premium+'},
    {t:'عدد البطاقات',v:'1 افتراضية + 1 فعلية',d:'Standard — حتى 5 مع Elite'},
  ],
  upgradeTitle:'تبي أكثر؟',upgradeFade:'اكتشف باقاتنا.',
  upgradeDesc:'ارتقِ لـ Plus أو Premium أو Elite واحصل على مميزات حصرية: بطاقة معدنية، صالات مطار، تأمين سفر، cashback والمزيد.',
  upgradeBtn:'قارن الباقات ←',
  testimTitle:'ماذا يقول عملاؤنا',
  testims:[
    {name:'أحمد محمد',loc:'برلين 🇩🇪',q:'أخيراً بنك يفهم احتياجات السوريين بأوروبا. فتحت حسابي بـ 3 دقائق وحوّلت لأهلي بسوريا بنفس اليوم.'},
    {name:'سارة الخطيب',loc:'إسطنبول 🇹🇷',q:'أسعار الصرف أفضل بكتير من البنوك التقليدية. وبطاقة ماستركارد شغّلتها بـ Apple Pay فوراً.'},
    {name:'عمر يوسف',loc:'كوبنهاغن 🇩🇰',q:'التطبيق بالعربي وسهل الاستخدام. أستلم معاشي مباشرة ويصلني إشعار فوري.'},
  ],
  faqTitle:'أسئلة شائعة',
  faqs:[
    {q:'من يقدر يفتح حساب؟',a:'أي شخص عمره 18+ بوثيقة هوية سارية. سواء بسوريا أو بأي دولة بالعالم.'},
    {q:'كم يستغرق فتح الحساب؟',a:'عادة 3-5 دقائق. التحقق من الهوية يتم رقمياً بدون زيارة فرع.'},
    {q:'هل في رسوم مخفية؟',a:'لا — باقة Standard مجانية بالكامل. بدون رسوم شهرية أو رسوم فتح أو صيانة.'},
    {q:'هل الحساب حقيقي؟',a:'نعم — تحصل على IBAN دولي حقيقي مسجل بالدنمارك ويعمل مع أي بنك بالعالم.'},
    {q:'كيف أحوّل لأهلي بسوريا؟',a:'من التطبيق مباشرة — أضف مستفيد، حدد المبلغ، وأرسل. يوصل خلال 1-3 أيام عمل بـ 0.5% فقط.'},
    {q:'هل التطبيق بالعربي؟',a:'نعم — واجهة عربية كاملة مع دعم RTL. يمكنك التبديل بين العربية والإنجليزية بأي وقت.'},
  ],
  ctaTitle:'جاهز تبدأ؟',ctaSub:'افتح حسابك الشخصي المجاني بدقائق. بدون أوراق، بدون فروع.',ctaBtn:'افتح حسابك المجاني ←',ctaBtn2:'قارن الباقات',
} : {
  title:'Personal Account — SDB Bank',tag:'Personal Account',
  heroH:'Your personal account.',heroEm:'World-class standards.',
  heroP:'More than just a bank account — a complete financial platform with instant Mastercard, free transfers, real exchange rates, and full control from your phone.',
  heroBtn:'Open your free account →',
  whyTitle:'Why SDB?',whyFade:'The difference is clear.',
  whyCards:[
    {ic:'⚡',t:'Instant Opening',d:'Account ready in 5 minutes. No branches, no paperwork, no appointments. Just your phone and an ID.'},
    {ic:'🆓',t:'Completely Free',d:'No monthly fees, no opening fees, no maintenance fees. Your account is free forever with Standard plan.'},
    {ic:'🌍',t:'150+ Countries',d:'Send and receive money from 150+ countries. A real international IBAN that works everywhere.'},
    {ic:'💳',t:'Instant Card',d:'Free virtual Mastercard the moment you open your account. Pay online or add to Apple Pay.'},
    {ic:'🔒',t:'Bank Security',d:'AES-256 encryption, biometric auth, dynamic CVV, instant freeze, 24/7 fraud monitoring.'},
    {ic:'📊',t:'Smart Analytics',d:'AI-powered spending tracking. Auto-categorization, budgets, detailed monthly reports.'},
  ],
  inclTitle:'What\'s included?',
  inclSections:[
    {cat:'Basics',items:['Real international IBAN','Free virtual Mastercard','Smart iOS & Android app','Full Arabic RTL interface','Instant notifications','24/7 support']},
    {cat:'Transfers',items:['Unlimited free internal transfers','Free SEPA European transfers','0.5% SWIFT international transfers','Instant SDB-to-SDB transfers','Scheduled auto-transfers','Real-time transfer tracking']},
    {cat:'Currencies',items:['30+ currencies supported','Real market exchange rates','Instant currency conversion','No hidden markup','Rate alerts','Multi-currency wallets']},
    {cat:'Security',items:['AES-256 encryption','Face ID / fingerprint auth','Dynamic CVV (hourly)','Instant freeze/unfreeze','3D Secure for purchases','AI fraud monitoring']},
  ],
  stepsTitle:'Open your account in 3 steps',
  steps:[
    {n:'01',ic:'📱',t:'Download the app',d:'Download SDB Bank from App Store or Google Play and start registration.'},
    {n:'02',ic:'🪪',t:'Verify your identity',d:'Photo your ID or passport + a selfie. Digital KYC verifies in minutes.'},
    {n:'03',ic:'🎉',t:'You\'re all set!',d:'Virtual card ready instantly. Start transferring, paying, and managing your finances.'},
  ],
  compTitle:'SDB vs Traditional Banks',
  compHeaders:['Feature','SDB Bank','Traditional Bank'],
  compRows:[
    ['Account opening','5 minutes ✅','3-7 days ❌'],['Monthly fees','Free ✅','€5-15/mo ❌'],['Mastercard','Instant ✅','7-14 days ❌'],
    ['Domestic transfer','Free instant ✅','€1-5 fee ❌'],['International','0.5% ✅','2-5% ❌'],['FX rates','Market rate ✅','3%+ markup ❌'],
    ['Smart app','Full ✅','Limited ❌'],['24/7 support','✅','❌'],['Digital KYC','✅','Branch visit ❌'],['Apple/Google Pay','✅','Varies'],
  ],
  limitsTitle:'Limits & Fees',
  limits:[
    {t:'ATM withdrawal',v:'€500/day free',d:'Standard — increases with higher plans'},
    {t:'Monthly transfer',v:'€5,000',d:'Standard — up to €200,000 with Elite'},
    {t:'FX exchange',v:'€1,000/mo free',d:'Standard — unlimited with Premium+'},
    {t:'Number of cards',v:'1 virtual + 1 physical',d:'Standard — up to 5 with Elite'},
  ],
  upgradeTitle:'Want more?',upgradeFade:'Discover our plans.',
  upgradeDesc:'Upgrade to Plus, Premium, or Elite for exclusive features: metal card, airport lounges, travel insurance, cashback and more.',
  upgradeBtn:'Compare plans →',
  testimTitle:'What our customers say',
  testims:[
    {name:'Ahmed M.',loc:'Berlin 🇩🇪',q:'Finally a bank that understands Syrians in Europe. Opened my account in 3 minutes and sent money to family in Syria the same day.'},
    {name:'Sara K.',loc:'Istanbul 🇹🇷',q:'Exchange rates much better than traditional banks. And the Mastercard works with Apple Pay instantly.'},
    {name:'Omar Y.',loc:'Copenhagen 🇩🇰',q:'The app is in Arabic and easy to use. I receive my salary directly with instant notifications.'},
  ],
  faqTitle:'FAQ',
  faqs:[
    {q:'Who can open an account?',a:'Anyone 18+ with a valid ID. Whether in Syria or anywhere in the world.'},
    {q:'How long does it take?',a:'Usually 3-5 minutes. Identity verification is fully digital, no branch visits.'},
    {q:'Are there hidden fees?',a:'No — Standard plan is completely free. No monthly, opening, or maintenance fees.'},
    {q:'Is the account real?',a:'Yes — you get a real international IBAN registered in Denmark that works with any bank worldwide.'},
    {q:'How do I send to family in Syria?',a:'Directly from the app — add beneficiary, set amount, and send. Arrives in 1-3 business days at only 0.5%.'},
    {q:'Is the app in Arabic?',a:'Yes — full Arabic interface with RTL support. Switch between Arabic and English anytime.'},
  ],
  ctaTitle:'Ready to start?',ctaSub:'Open your free personal account in minutes. No paperwork, no branches.',ctaBtn:'Open free account →',ctaBtn2:'Compare plans',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p><a href="/preregister" class="hero-btn">{{ t.heroBtn }}</a></div></section>

<section class="sec"><div class="sw"><div class="sec-hdr"><h2 class="t2">{{ t.whyTitle }}<br><span class="t2-em">{{ t.whyFade }}</span></h2></div><div class="g3"><div v-for="c in t.whyCards" :key="c.t" class="wcard"><span class="wcard-ic">{{ c.ic }}</span><h3 class="wcard-t">{{ c.t }}</h3><p class="wcard-d">{{ c.d }}</p></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.inclTitle }}</h2><div class="incl-g"><div v-for="s in t.inclSections" :key="s.cat" class="incl-box"><h3 class="incl-cat">{{ s.cat }}</h3><ul class="incl-list"><li v-for="i in s.items" :key="i">✓ {{ i }}</li></ul></div></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.stepsTitle }}</h2><div class="g3"><div v-for="s in t.steps" :key="s.n" class="step"><div class="step-n">{{ s.n }}</div><div class="step-ic">{{ s.ic }}</div><h3 class="step-t">{{ s.t }}</h3><p class="step-d">{{ s.d }}</p></div></div></div></section>

<section class="sec sec-sky"><div class="sw"><h2 class="t2 t2-w tc">{{ t.compTitle }}</h2><div class="tbl-wrap"><table class="tbl"><thead><tr><th v-for="h in t.compHeaders" :key="h">{{ h }}</th></tr></thead><tbody><tr v-for="r in t.compRows" :key="r[0]"><td v-for="(c,i) in r" :key="i" :class="{'tbl-feat':i===0}">{{ c }}</td></tr></tbody></table></div></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.limitsTitle }}</h2><div class="g4"><div v-for="l in t.limits" :key="l.t" class="lim-c"><div class="lim-t">{{ l.t }}</div><div class="lim-v">{{ l.v }}</div><div class="lim-d">{{ l.d }}</div></div></div></div></section>

<section class="sec sec-alt"><div class="sw sec-hdr tc"><h2 class="t2">{{ t.upgradeTitle }}<br><span class="t2-em">{{ t.upgradeFade }}</span></h2><p class="t2-sub tc" style="margin:0 auto 24px">{{ t.upgradeDesc }}</p><Link href="/plans" class="link-btn-lg">{{ t.upgradeBtn }}</Link></div></section>

<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.testimTitle }}</h2><div class="g3"><div v-for="ts in t.testims" :key="ts.name" class="test-c"><p class="test-q">"{{ ts.q }}"</p><div class="test-who"><strong>{{ ts.name }}</strong><span class="test-loc">{{ ts.loc }}</span></div></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.faqTitle }}</h2><div class="faqs"><div v-for="f in t.faqs" :key="f.q" class="faq-c"><h4 class="faq-q">{{ f.q }}</h4><p class="faq-a">{{ f.a }}</p></div></div></div></section>

<section class="sec sec-sky tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><div class="cta-row"><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a><Link href="/plans" class="cta-btn2">{{ t.ctaBtn2 }}</Link></div></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:100px 0}.sec-alt{background:#F5F9F3}.sec-sky{background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff}
.sec-hdr{margin-bottom:48px}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.t2-w{color:#fff}.t2-em{color:#9FE870}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 80px;background:linear-gradient(135deg,#163300 0%,#1a3d00 50%,#9FE870 100%);color:#fff;text-align:center}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.6);text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:20px}
.p-hero-em{color:#9FE870}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.5);max-width:600px;margin:0 auto 32px;line-height:1.8}
.hero-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s;box-shadow:0 4px 16px rgba(0,0,0,.1)}.hero-btn:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,.2)}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.wcard{padding:32px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:20px;transition:all .3s}.wcard:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(159,232,112,.08)}
.wcard-ic{font-size:32px;display:block;margin-bottom:14px}.wcard-t{font-size:16px;font-weight:800;margin-bottom:8px;color:#163300}.wcard-d{font-size:13px;color:rgba(10,10,10,.4);line-height:1.75}
.incl-g{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.incl-box{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:18px}
.incl-cat{font-size:14px;font-weight:800;color:#9FE870;margin-bottom:14px;padding-bottom:10px;border-bottom:2px solid rgba(159,232,112,.1)}
.incl-list{list-style:none;padding:0;display:flex;flex-direction:column;gap:8px}.incl-list li{font-size:12.5px;color:rgba(10,10,10,.5);line-height:1.5}
.step{padding:36px 24px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:20px;text-align:center;transition:all .3s}.step:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(159,232,112,.08)}
.step-n{font-size:48px;font-weight:900;color:rgba(159,232,112,.08);line-height:1;margin-bottom:8px}
.step-ic{font-size:36px;margin-bottom:12px}.step-t{font-size:16px;font-weight:800;margin-bottom:8px;color:#163300}.step-d{font-size:13px;color:rgba(10,10,10,.4);line-height:1.75}
.tbl-wrap{overflow-x:auto;border-radius:16px;border:1px solid rgba(255,255,255,.1)}
.tbl{width:100%;border-collapse:collapse;background:rgba(255,255,255,.05)}
.tbl th{padding:14px 20px;text-align:right;font-size:13px;font-weight:800;color:rgba(255,255,255,.6);border-bottom:1px solid rgba(255,255,255,.08);background:rgba(255,255,255,.03)}
.tbl td{padding:12px 20px;font-size:13px;color:rgba(255,255,255,.7);border-bottom:1px solid rgba(255,255,255,.04)}
.tbl-feat{font-weight:700;color:#fff}
.ltr .tbl th,.ltr .tbl td{text-align:left}
.lim-c{padding:24px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:16px;text-align:center}
.lim-t{font-size:12px;font-weight:700;color:#9FE870;margin-bottom:8px;text-transform:uppercase;letter-spacing:.5px}
.lim-v{font-size:24px;font-weight:900;color:#163300;margin-bottom:6px}.lim-d{font-size:11px;color:rgba(10,10,10,.3)}
.link-btn-lg{font-size:15px;font-weight:700;color:#9FE870;text-decoration:none;transition:opacity .2s}.link-btn-lg:hover{opacity:.7}
.test-c{padding:28px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:18px}
.test-q{font-size:14px;color:rgba(10,10,10,.5);line-height:1.8;font-style:italic;margin-bottom:16px}
.test-who{display:flex;justify-content:space-between;align-items:center}.test-who strong{font-size:13px;color:#163300}.test-loc{font-size:12px;color:rgba(10,10,10,.3)}
.faqs{max-width:700px;margin:0 auto;display:flex;flex-direction:column;gap:12px}
.faq-c{padding:24px;background:#fff;border:1px solid rgba(159,232,112,.08);border-radius:16px}
.faq-q{font-size:15px;font-weight:800;margin-bottom:8px;color:#163300}.faq-a{font-size:13px;color:rgba(10,10,10,.4);line-height:1.8}
.cta-row{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#163300;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
.cta-btn2{display:inline-block;padding:16px 44px;background:transparent;color:#fff;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;border:2px solid rgba(255,255,255,.2);transition:all .2s}.cta-btn2:hover{border-color:rgba(255,255,255,.5)}
@media(max-width:768px){.g3,.incl-g{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}}
</style>
