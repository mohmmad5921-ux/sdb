<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed, onMounted, onUnmounted } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const lang = inject('lang', ref('ar'));
const isAr = inject('isAr', computed(() => true));
const launchDate = new Date('2026-03-22T00:00:00');
const cd = ref({ d:0, h:0, m:0, s:0 });
let ti;
function tick(){const x=launchDate-new Date();if(x<=0)return;cd.value={d:Math.floor(x/864e5),h:Math.floor(x%864e5/36e5),m:Math.floor(x%36e5/6e4),s:Math.floor(x%6e4/1e3)}}
const em = ref('');const done = ref(false);
let obs;
onMounted(()=>{tick();ti=setInterval(tick,1e3);obs=new IntersectionObserver(e=>e.forEach(x=>{if(x.isIntersecting)x.target.classList.add('vi')}),{threshold:.06});document.querySelectorAll('.an').forEach(el=>obs.observe(el))});
onUnmounted(()=>{clearInterval(ti);obs?.disconnect()});
const t = computed(() => isAr.value ? {
  tag:'أول بنك إلكتروني سوري',hd1:'سوريا تدخل',hd2:'عصر البنوك الرقمية',
  sub:'افتح حسابك من سوريا أو من أي مكان بالعالم. استلم معاشك، حوّل أموالك، وادفع فواتيرك — كل شيء من تطبيق واحد.',
  days:'يوم',hrs:'ساعة',min:'دقيقة',sec:'ثانية',
  emailPh:'بريدك الإلكتروني...',notify:'سجّل الآن',emailDone:'✓ تم! سنبلغك فور الإطلاق.',
  trust:['🇩🇰 مرخّص في الدنمارك','🇸🇾 مصمم للسوريين','🔒 تشفير 256-بت','🏦 ماستركارد معتمد'],
  everyTitle:'لكل سوري',everyFade:'بالعالم.',
  everyDesc:'سواء كنت بدمشق أو برلين، بحلب أو إسطنبول — حسابك البنكي الرقمي جاهز بدقائق. لا فروع، لا طوابير، لا بيروقراطية.',
  everyCards:[
    {ic:'🇸🇾',t:'داخل سوريا',d:'افتح حسابك وأنت بسوريا واستفد من كل خدماتنا البنكية. لا حاجة للسفر أو زيارة فرع.'},
    {ic:'🌍',t:'خارج سوريا',d:'أي سوري بالعالم يقدر يفتح حساب ويحوّل لأهله بأقل الرسوم. 150+ دولة مدعومة.'},
    {ic:'📱',t:'بدقائق',d:'تسجيل سريع وتحقق رقمي — حسابك جاهز خلال دقائق. KYC رقمي بالكامل بدون أوراق.'},
    {ic:'🏦',t:'IBAN دولي',d:'رقم حساب IBAN دولي حقيقي. استلم حوالات وأرسل لأي بنك بالعالم.'},
    {ic:'💼',t:'حساب تجاري',d:'للشركات والمتاجر. حساب تجاري متكامل لإدارة أعمالك المالية.'},
    {ic:'👨‍👩‍👧‍👦',t:'حساب عائلي',d:'شارك حسابك مع عائلتك. بطاقات فرعية للأطفال مع حدود مصاريف.'},
  ],
  featTitle:'خدمات شاملة.',featFade:'لا شيء ينقصك.',
  features:[
    {ic:'💰',t:'استلام المعاشات',d:'معاشك يوصل مباشرة لحسابك الرقمي. بدون تأخير، بدون وسطاء. إشعار فوري عند الوصول. تحليل ذكي لمصاريفك الشهرية مع تصنيف تلقائي.',tag:'رواتب',href:'/salary'},
    {ic:'💳',t:'بطاقات ماستركارد',d:'بطاقة افتراضية فورية مجانية عند التسجيل. بطاقة معدنية فاخرة. 4 مستويات: Standard مجاني، Plus، Premium، Elite. ادفع بـ Apple Pay و Google Pay.',tag:'بطاقات',href:'/cards-info'},
    {ic:'💱',t:'أكثر من 30 عملة',d:'احتفظ وحوّل بأسعار السوق الحقيقية. يورو، دولار، جنيه إسترليني، ليرة تركية، درهم إماراتي والمزيد. بدون هوامش ربح مخفية.',tag:'عملات',href:'/currencies'},
    {ic:'⚡',t:'تحويلات فورية',d:'تحويلات داخلية مجانية بالكامل. دولية بـ 0.5% فقط. SEPA أوروبي فوري. SWIFT لأي بنك بالعالم. أرسل لأهلك بسوريا.',tag:'تحويلات',href:'/transfers-info'},
    {ic:'🛡️',t:'أمان لا يُخترق',d:'تشفير بنكي AES-256. مصادقة بالوجه والبصمة. فريق مراقبة احتيال 24/7. حماية المشتريات. CVV ديناميكي. 3D Secure.',tag:'أمان',href:'/about'},
    {ic:'🧾',t:'دفع الفواتير',d:'قريباً: ادفع فواتير الكهرباء والماء والإنترنت والهاتف والإيجار والأقساط مباشرة من التطبيق. بدون طوابير.',tag:'قريباً',href:'#'},
    {ic:'🪪',t:'الهوية الرقمية',d:'Syria Digital ID — تحقق من هويتك رقمياً بدون أوراق. مسح الوثائق بالذكاء الاصطناعي. تعرّف على الوجه فوري.',tag:'جديد',href:'/digital-id'},
    {ic:'📱',t:'المحفظة الرقمية',d:'أضف بطاقتك لـ Apple Wallet أو Google Wallet وادفع بهاتفك أو ساعتك الذكية بأي مكان بالعالم.',tag:'محفظة',href:'/wallet-guide'},
    {ic:'📊',t:'تحليلات مالية',d:'تتبع مصاريفك بذكاء اصطناعي. تصنيف تلقائي، ميزانيات شهرية، تقارير مفصّلة، وأهداف ادخار ذكية.',tag:'ذكاء',href:'#'},
  ],
  techTag:'التأخر التكنولوجي انتهى',techTitle:'تكنولوجيا أوروبية.',techFade:'بروح سورية.',
  techDesc:'سنوات الحرب خلّفت فجوة تكنولوجية هائلة في القطاع المالي السوري. SDB Bank يسد هذه الفجوة بتقنيات أوروبية متقدمة — بنك رقمي بالكامل، بدون فروع، بدون ورق، بدون طوابير.',
  techFeats:[
    {ic:'☁️',t:'بنية سحابية',d:'خوادم أوروبية آمنة بأعلى معايير الحماية. تكرار البيانات في مراكز متعددة. وقت تشغيل 99.99%.'},
    {ic:'🔐',t:'تشفير AES-256',d:'نفس التقنية المستخدمة بأكبر البنوك العالمية. بياناتك مشفّرة أثناء النقل والتخزين.'},
    {ic:'📲',t:'تطبيق ذكي',d:'iOS و Android — كل شيء من هاتفك. واجهة عربية بالكامل مع دعم RTL. تحديثات مستمرة.'},
    {ic:'🪪',t:'تحقق رقمي KYC',d:'تحقق من هويتك بدقائق بدون أوراق أو زيارة فرع. مسح الوثائق بالذكاء الاصطناعي.'},
    {ic:'🤖',t:'ذكاء اصطناعي',d:'تحليل المصاريف تلقائياً. كشف الاحتيال فوري. توصيات مالية ذكية مخصصة.'},
    {ic:'🔄',t:'API مفتوح',d:'تكامل مع أنظمة المحاسبة وأنظمة الرواتب. واجهة برمجة تطبيقات للشركات.'},
    {ic:'🌐',t:'شبكة SWIFT/SEPA',d:'متصلون بشبكات SWIFT و SEPA لتحويلات دولية فورية وموثوقة.'},
    {ic:'📡',t:'إشعارات فورية',d:'تنبيهات لحظية لكل عملية. تخصيص كامل للإشعارات حسب رغبتك.'},
  ],
  appTitle:'كل شي بتطبيق واحد.',appFade:'بسيط وقوي.',
  appDesc:'صمّمنا تطبيقاً بسيطاً وقوياً يجمع كل خدماتك البنكية بمكان واحد. واجهة عربية بالكامل مع تجربة استخدام سلسة.',
  appFeats:['لوحة تحكم ذكية','إدارة بطاقات متعددة','تحويلات فورية','أسعار صرف حية','إشعارات مخصصة','تجميد البطاقة فوراً','تحليل المصاريف','أهداف ادخار','دعم فني مباشر','ملف شخصي آمن','سجل العمليات الكامل','تحقق بالبصمة والوجه'],
  cardsTitle:'بطاقات تليق بك.',cardsFade:'4 مستويات فاخرة.',
  cardsDesc:'اختر البطاقة اللي تناسب أسلوب حياتك. من Standard المجاني لـ Elite الفاخر. كل بطاقة بمميزات حصرية.',
  cardTiers:[
    {n:'Standard',p:'مجاني',c:'#2563EB',f:['بطاقة افتراضية فورية','Apple Pay و Google Pay','حد سحب €500 يومي','إشعارات فورية']},
    {n:'Plus',p:'€3.99/شهر',c:'#7C3AED',f:['بطاقة معدنية فاخرة','حماية مشتريات €1,000','حد سحب €2,000','CVV ديناميكي']},
    {n:'Premium',p:'€7.99/شهر',c:'#DB2777',f:['صرف عملات بلا حدود','تأمين سفر شامل','صالات مطار','شريحة eSIM 3GB']},
    {n:'Elite',p:'€14.99/شهر',c:'#B45309',f:['صالات VIP بلا حدود','مدير حساب شخصي','استرداد 1%','تأمين صحي']},
  ],
  cardsBtn:'اكتشف كل البطاقات ←',
  salTitle:'معاشك.',salFade:'بين يديك فوراً.',
  salDesc:'استلم معاشك مباشرة في حسابك البنكي الرقمي. بدون وسطاء، بدون تأخير. إشعار فوري لحظة الوصول.',
  salCards:[
    {ic:'📥',t:'إيداع مباشر',d:'معاشك يصل تلقائياً لحسابك فور تحويله من صاحب العمل'},
    {ic:'🔔',t:'إشعار لحظي',d:'تنبيه فوري على هاتفك لحظة وصول الراتب مع المبلغ'},
    {ic:'🆓',t:'بدون رسوم',d:'صفر رسوم على استلام الراتب. لا رسوم شهرية مخفية'},
    {ic:'📊',t:'تحليل ذكي',d:'تتبع مصاريفك تلقائياً مع تصنيف احترافي وتقارير شهرية'},
    {ic:'🔄',t:'تحويل تلقائي',d:'حدد نسبة من راتبك تروح للتوفير أو لحساب ثاني'},
    {ic:'💳',t:'سحب فوري',d:'اسحب من أي صراف آلي بالعالم ببطاقة ماستركارد'},
  ],
  salBtn:'تفاصيل المعاشات ←',
  trTitle:'حوّل لأهلك.',trFade:'بأقل الرسوم.',
  trDesc:'تحويلات داخلية مجانية بالكامل. دولية بـ 0.5% فقط. حتى من خارج سوريا تقدر تحوّل بلحظات. أسرع وأرخص طريقة لإرسال الأموال.',
  trFeats:[
    {v:'مجاني',l:'تحويل داخلي',d:'بين حسابات SDB — فوري ومجاني بالكامل'},
    {v:'0.5%',l:'تحويل دولي',d:'SWIFT لأي بنك بالعالم — أقل رسوم بالسوق'},
    {v:'فوري',l:'SEPA أوروبي',d:'يوصل بثوانٍ داخل أوروبا بدون رسوم'},
    {v:'150+',l:'دولة مدعومة',d:'أرسل لأي مكان — سوريا، تركيا، الخليج، أوروبا'},
  ],
  trBtn:'تفاصيل التحويلات ←',
  secTitle:'أمانك.',secFade:'أولويتنا القصوى.',
  secDesc:'نستخدم أعلى تقنيات الحماية المتاحة بالعالم. أموالك وبياناتك محمية بمعايير أوروبية صارمة.',
  secFeats:[
    {ic:'🔐',t:'تشفير AES-256',d:'تشفير بنكي من الدرجة العسكرية. كل بياناتك مشفّرة أثناء النقل والتخزين.'},
    {ic:'👆',t:'مصادقة بيومترية',d:'بصمة الإصبع أو التعرف على الوجه لفتح التطبيق وتأكيد العمليات.'},
    {ic:'🛡️',t:'حماية المشتريات',d:'حماية تصل لـ €10,000 على مشترياتك حسب مستوى بطاقتك.'},
    {ic:'🔄',t:'CVV ديناميكي',d:'رمز أمان يتغير تلقائياً كل ساعة لحماية مشترياتك الإلكترونية.'},
    {ic:'❄️',t:'تجميد فوري',d:'جمّد بطاقتك فوراً من التطبيق إذا فقدتها أو شككت بنشاط مريب.'},
    {ic:'🔔',t:'تنبيهات احتيال',d:'نظام ذكاء اصطناعي يكشف النشاط المريب فوراً وينبّهك.'},
    {ic:'🔑',t:'مصادقة ثنائية',d:'طبقة أمان إضافية بكل عملية حساسة — كود SMS أو التطبيق.'},
    {ic:'📋',t:'3D Secure',d:'تحقق إضافي عند الدفع إلكترونياً يحميك من الاستخدام غير المصرح.'},
  ],
  soonTitle:'قريباً.',soonFade:'دفع الفواتير.',
  soonDesc:'ادفع فواتيرك من التطبيق — كهرباء، ماء، إنترنت، هاتف، إيجار، أقساط. بدون طوابير، بدون تأخير.',
  soonItems:['⚡ فواتير الكهرباء','💧 فواتير المياه','🌐 فواتير الإنترنت','📱 شحن الهاتف','🏠 إيجار المنزل','🎓 أقساط جامعية','📺 اشتراكات رقمية','🏥 فواتير طبية'],
  acctTitle:'حسابات لكل حاجة.',
  acctTypes:[
    {ic:'👤',t:'حساب شخصي',d:'حساب يومي لإدارة أموالك. بطاقة فورية، تحويلات، صرف عملات.', f:['IBAN دولي','بطاقة ماستركارد مجانية','تحويلات داخلية مجانية','تطبيق ذكي كامل']},
    {ic:'👨‍👩‍👧‍👦',t:'حساب عائلي',d:'شارك حسابك مع عائلتك. بطاقات فرعية مع حدود مصاريف للأطفال.', f:['حتى 5 بطاقات فرعية','حدود مصاريف قابلة للتعديل','إشعارات فورية للعائلة','حماية المشتريات']},
    {ic:'💼',t:'حساب تجاري',d:'للشركات والمتاجر. إدارة مالية متكاملة مع أدوات محاسبة.', f:['فواتير إلكترونية','تكامل مع أنظمة المحاسبة','تقارير مالية تفصيلية','بطاقات لكل موظف']},
    {ic:'🏦',t:'حساب توفير',d:'ادّخر بذكاء. أهداف ادخار، تحويل تلقائي، وعوائد تنافسية.', f:['أهداف ادخار ذكية','تحويل تلقائي شهري','تقارير نمو الادخار','سحب بأي وقت']},
  ],
  stats:[{v:'30+',l:'عملة مدعومة'},{v:'150+',l:'دولة'},{v:'24/7',l:'دعم فني'},{v:'0',l:'رسوم مخفية'},{v:'<60',l:'ثانية للتحويل'},{v:'4',l:'مستويات بطاقات'}],
  ctaTag:'جاهز؟',ctaTitle:'مستقبلك المالي يبدأ هنا.',
  ctaSub:'افتح حسابك المجاني بدقيقتين. بدون فروع، بدون أوراق. أول بنك إلكتروني سوري مصمم لخدمتك.',
  ctaBtn:'افتح حسابك المجاني ←',ctaBtn2:'تواصل معنا',
} : {
  tag:'The First Syrian Digital Bank',hd1:'Syria enters the',hd2:'digital banking era',
  sub:'Open your account from Syria or anywhere in the world. Receive your salary, transfer money, and pay your bills — all from one app.',
  days:'Days',hrs:'Hrs',min:'Min',sec:'Sec',
  emailPh:'Your email...',notify:'Sign up',emailDone:'✓ Done! We\'ll notify you at launch.',
  trust:['🇩🇰 Licensed in Denmark','🇸🇾 Built for Syrians','🔒 256-bit encrypted','🏦 Mastercard certified'],
  everyTitle:'For every Syrian.',everyFade:'Worldwide.',
  everyDesc:'Whether you\'re in Damascus or Berlin, Aleppo or Istanbul — your digital bank account is ready in minutes. No branches, no queues, no bureaucracy.',
  everyCards:[
    {ic:'🇸🇾',t:'Inside Syria',d:'Open your account while in Syria and access all our banking services. No travel or branch visits needed.'},
    {ic:'🌍',t:'Outside Syria',d:'Any Syrian worldwide can open an account and send money home at the lowest fees. 150+ countries supported.'},
    {ic:'📱',t:'In Minutes',d:'Quick registration and digital verification — your account is ready in minutes. Fully digital KYC, no paperwork.'},
    {ic:'🏦',t:'International IBAN',d:'A real international IBAN number. Receive and send transfers to any bank worldwide.'},
    {ic:'💼',t:'Business Account',d:'For companies and shops. A complete business account for managing your finances.'},
    {ic:'👨‍👩‍👧‍👦',t:'Family Account',d:'Share your account with family. Sub-cards for kids with spending limits.'},
  ],
  featTitle:'Complete services.',featFade:'Nothing missing.',
  features:[
    {ic:'💰',t:'Salary Deposits',d:'Your salary arrives directly. No delays, no middlemen. Instant notification. Smart spending analytics with auto-categorization.',tag:'SALARY',href:'/salary'},
    {ic:'💳',t:'Mastercard Cards',d:'Free instant virtual card on signup. Premium metal card. 4 tiers: Standard Free, Plus, Premium, Elite. Apple Pay & Google Pay.',tag:'CARDS',href:'/cards-info'},
    {ic:'💱',t:'30+ Currencies',d:'Hold and convert at real market rates. EUR, USD, GBP, TRY, AED and more. No hidden markup or spreads.',tag:'FX',href:'/currencies'},
    {ic:'⚡',t:'Instant Transfers',d:'Free domestic transfers. International at only 0.5%. SEPA instant in Europe. SWIFT to any bank. Send to family in Syria.',tag:'TRANSFERS',href:'/transfers-info'},
    {ic:'🛡️',t:'Unbreakable Security',d:'AES-256 encryption. Face ID & fingerprint auth. 24/7 fraud monitoring. Purchase protection. Dynamic CVV. 3D Secure.',tag:'SECURITY',href:'/about'},
    {ic:'🧾',t:'Bill Payments',d:'Coming soon: Pay electricity, water, internet, phone, rent, and tuition directly from the app. No queues.',tag:'SOON',href:'#'},
    {ic:'🪪',t:'Digital Identity',d:'Syria Digital ID — verify digitally without paperwork. AI document scanning. Instant facial recognition.',tag:'NEW',href:'/digital-id'},
    {ic:'📱',t:'Digital Wallet',d:'Add your card to Apple Wallet or Google Wallet. Pay with your phone or smartwatch anywhere worldwide.',tag:'WALLET',href:'/wallet-guide'},
    {ic:'📊',t:'Financial Analytics',d:'AI-powered spending tracking. Auto-categorization, monthly budgets, detailed reports, and smart savings goals.',tag:'AI',href:'#'},
  ],
  techTag:'The tech gap ends here',techTitle:'European technology.',techFade:'Syrian soul.',
  techDesc:'Years of war left a massive technological gap in Syria\'s financial sector. SDB Bank bridges this gap with advanced European technology — a fully digital bank, no branches, no paper, no queues.',
  techFeats:[
    {ic:'☁️',t:'Cloud Infrastructure',d:'Secure European servers with highest protection. Multi-datacenter redundancy. 99.99% uptime.'},
    {ic:'🔐',t:'AES-256 Encryption',d:'Same technology used by the world\'s largest banks. Data encrypted in transit and at rest.'},
    {ic:'📲',t:'Smart App',d:'iOS & Android — everything from your phone. Full Arabic interface with RTL support. Continuous updates.'},
    {ic:'🪪',t:'Digital KYC',d:'Verify identity in minutes without paperwork or branch visits. AI-powered document scanning.'},
    {ic:'🤖',t:'Artificial Intelligence',d:'Automatic spending analysis. Instant fraud detection. Personalized smart financial recommendations.'},
    {ic:'🔄',t:'Open API',d:'Integration with accounting and payroll systems. Enterprise API for businesses.'},
    {ic:'🌐',t:'SWIFT/SEPA Network',d:'Connected to SWIFT and SEPA for instant, reliable international transfers.'},
    {ic:'📡',t:'Real-time Notifications',d:'Instant alerts for every transaction. Fully customizable notification preferences.'},
  ],
  appTitle:'Everything in one app.',appFade:'Simple yet powerful.',
  appDesc:'We designed a simple, powerful app that brings all your banking services together. Full Arabic interface with seamless user experience.',
  appFeats:['Smart dashboard','Multi-card management','Instant transfers','Live exchange rates','Custom notifications','Instant card freeze','Spending analytics','Savings goals','Live support','Secure profile','Full transaction history','Biometric authentication'],
  cardsTitle:'Cards that match your style.',cardsFade:'4 premium tiers.',
  cardsDesc:'Choose the card that fits your lifestyle. From free Standard to premium Elite. Each card with exclusive features.',
  cardTiers:[
    {n:'Standard',p:'Free',c:'#2563EB',f:['Instant virtual card','Apple Pay & Google Pay','€500 daily ATM','Instant notifications']},
    {n:'Plus',p:'€3.99/mo',c:'#7C3AED',f:['Premium metal card','€1,000 purchase protection','€2,000 daily ATM','Dynamic CVV']},
    {n:'Premium',p:'€7.99/mo',c:'#DB2777',f:['Unlimited FX','Travel insurance','Airport lounges','3GB eSIM']},
    {n:'Elite',p:'€14.99/mo',c:'#B45309',f:['Unlimited VIP lounges','Personal manager','1% cashback','Health insurance']},
  ],
  cardsBtn:'See all cards ←',
  salTitle:'Your salary.',salFade:'Instantly yours.',
  salDesc:'Receive your salary directly into your digital bank account. No middlemen, no delays. Instant notification the moment it arrives.',
  salCards:[
    {ic:'📥',t:'Direct Deposit',d:'Salary arrives automatically the moment your employer sends it'},
    {ic:'🔔',t:'Instant Alert',d:'Real-time phone notification the moment salary arrives with amount'},
    {ic:'🆓',t:'Zero Fees',d:'No fees on salary reception. No hidden monthly charges'},
    {ic:'📊',t:'Smart Analytics',d:'Auto-categorize spending with professional classification and monthly reports'},
    {ic:'🔄',t:'Auto-Transfer',d:'Set a percentage of salary to auto-transfer to savings or another account'},
    {ic:'💳',t:'Instant Withdrawal',d:'Withdraw from any ATM worldwide with your Mastercard'},
  ],
  salBtn:'Salary details ←',
  trTitle:'Send to family.',trFade:'Lowest fees.',
  trDesc:'Free domestic transfers. International at only 0.5%. Even from outside Syria, transfer in seconds. Fastest and cheapest way to send money.',
  trFeats:[
    {v:'Free',l:'Domestic',d:'Between SDB accounts — instant and completely free'},
    {v:'0.5%',l:'International',d:'SWIFT to any bank worldwide — lowest market fees'},
    {v:'Instant',l:'SEPA Europe',d:'Arrives in seconds within Europe, no fees'},
    {v:'150+',l:'Countries',d:'Send anywhere — Syria, Turkey, Gulf, Europe'},
  ],
  trBtn:'Transfer details ←',
  secTitle:'Your security.',secFade:'Our top priority.',
  secDesc:'We use the highest protection technologies available. Your money and data are protected by strict European standards.',
  secFeats:[
    {ic:'🔐',t:'AES-256 Encryption',d:'Military-grade bank encryption. All data encrypted in transit and at rest.'},
    {ic:'👆',t:'Biometric Auth',d:'Fingerprint or facial recognition to unlock the app and confirm transactions.'},
    {ic:'🛡️',t:'Purchase Protection',d:'Protection up to €10,000 on your purchases depending on your card tier.'},
    {ic:'🔄',t:'Dynamic CVV',d:'Security code that changes automatically every hour for online shopping protection.'},
    {ic:'❄️',t:'Instant Freeze',d:'Freeze your card instantly from the app if lost or suspicious activity detected.'},
    {ic:'🔔',t:'Fraud Alerts',d:'AI system detects suspicious activity instantly and alerts you.'},
    {ic:'🔑',t:'Two-Factor Auth',d:'Extra security layer on every sensitive operation — SMS code or app.'},
    {ic:'📋',t:'3D Secure',d:'Additional verification during online payments protects against unauthorized use.'},
  ],
  soonTitle:'Coming soon.',soonFade:'Bill payments.',
  soonDesc:'Pay your bills from the app — electricity, water, internet, phone, rent, tuition. No queues, no delays.',
  soonItems:['⚡ Electricity bills','💧 Water bills','🌐 Internet bills','📱 Phone top-up','🏠 Rent payments','🎓 University tuition','📺 Digital subscriptions','🏥 Medical bills'],
  acctTitle:'Accounts for every need.',
  acctTypes:[
    {ic:'👤',t:'Personal Account',d:'Daily account for managing your finances. Instant card, transfers, FX.', f:['International IBAN','Free Mastercard','Free domestic transfers','Full smart app']},
    {ic:'👨‍👩‍👧‍👦',t:'Family Account',d:'Share your account with family. Sub-cards with spending limits for kids.', f:['Up to 5 sub-cards','Adjustable spending limits','Family instant notifications','Purchase protection']},
    {ic:'💼',t:'Business Account',d:'For companies and shops. Complete financial management with accounting tools.', f:['E-invoicing','Accounting integration','Detailed financial reports','Employee cards']},
    {ic:'🏦',t:'Savings Account',d:'Save smart. Savings goals, auto-transfer, competitive returns.', f:['Smart savings goals','Monthly auto-transfer','Growth tracking reports','Withdraw anytime']},
  ],
  stats:[{v:'30+',l:'Currencies'},{v:'150+',l:'Countries'},{v:'24/7',l:'Support'},{v:'0',l:'Hidden Fees'},{v:'<60',l:'Sec to Transfer'},{v:'4',l:'Card Tiers'}],
  ctaTag:'Ready?',ctaTitle:'Your financial future starts here.',
  ctaSub:'Open your free account in 2 minutes. No branches, no paperwork. The first Syrian digital bank designed to serve you.',
  ctaBtn:'Open free account →',ctaBtn2:'Contact us',
});
</script>
<template>
<Head :title="isAr?'SDB Bank — أول بنك إلكتروني سوري':'SDB Bank — First Syrian Digital Bank'"><meta :content="isAr?'SDB Bank — أول بنك إلكتروني سوري':'SDB Bank — First Syrian Digital Bank'" name="description"/></Head>

<!-- HERO -->
<section class="hero"><div class="sw hero-inner">
  <div class="hero-tag an">{{ t.tag }}</div>
  <h1 class="hero-h an"><span class="hero-h1">{{ t.hd1 }}</span><span class="hero-h2">{{ t.hd2 }}</span></h1>
  <p class="hero-p an">{{ t.sub }}</p>
  <div class="hero-cd an"><div v-for="(lb,k) in {d:t.days,h:t.hrs,m:t.min,s:t.sec}" :key="k" class="cd-b"><div class="cd-n">{{ String(cd[k]).padStart(2,'0') }}</div><div class="cd-l">{{ lb }}</div></div></div>
  <div class="hero-eml an"><template v-if="!done"><input v-model="em" type="email" :placeholder="t.emailPh" class="eml-i" @keyup.enter="done=!!em"/><button @click="done=!!em" class="eml-b">{{ t.notify }}</button></template><div v-else class="eml-ok">{{ t.emailDone }}</div></div>
  <div class="hero-trust an"><span v-for="tr in t.trust" :key="tr" class="trust-i">{{ tr }}</span></div>
</div></section>

<div class="mq"><div class="mq-track"><span v-for="(p,i) in ['SDB Bank','Mastercard','Apple Pay','Google Pay','SWIFT','SEPA','Syria 🇸🇾','Damascus','Berlin','Istanbul','SDB Bank','Mastercard','Apple Pay','Google Pay','SWIFT','SEPA','Syria 🇸🇾','Damascus','Berlin','Istanbul']" :key="i" class="mq-i">{{ p }}</span></div></div>

<!-- FOR EVERY SYRIAN -->
<section class="sec"><div class="sw"><div class="sec-hdr an"><h2 class="t2">{{ t.everyTitle }}<br><span class="t2-em">{{ t.everyFade }}</span></h2><p class="t2-sub">{{ t.everyDesc }}</p></div><div class="g6 an"><div v-for="(c,i) in t.everyCards" :key="i" class="ev-card" :style="{transitionDelay:(i*60)+'ms'}"><span class="ev-ic">{{ c.ic }}</span><h3 class="ev-t">{{ c.t }}</h3><p class="ev-d">{{ c.d }}</p></div></div></div></section>

<!-- FEATURES 9 cards -->
<section class="sec sec-alt"><div class="sw"><div class="sec-hdr an"><h2 class="t2">{{ t.featTitle }}<br><span class="t2-fade">{{ t.featFade }}</span></h2></div><div class="fg an"><Link v-for="(f,i) in t.features" :key="i" :href="f.href||'#'" class="fc" :style="{transitionDelay:(i*40)+'ms'}"><div class="fc-top"><span class="fc-tag">{{ f.tag }}</span><span class="fc-ic">{{ f.ic }}</span></div><h3 class="fc-t">{{ f.t }}</h3><p class="fc-p">{{ f.d }}</p></Link></div></div></section>

<!-- APP MOCKUP -->
<section class="sec"><div class="sw app-row an"><div class="app-text"><h2 class="t2">{{ t.appTitle }}<br><span class="t2-em">{{ t.appFade }}</span></h2><p class="t2-sub">{{ t.appDesc }}</p><div class="app-feats"><span v-for="f in t.appFeats" :key="f" class="app-feat">✓ {{ f }}</span></div></div><div class="app-img"><img src="/images/app-mockup.png" alt="SDB Bank App" loading="lazy"/></div></div></section>

<!-- CARDS SECTION -->
<section class="sec sec-alt"><div class="sw"><div class="sec-hdr an"><h2 class="t2">{{ t.cardsTitle }}<br><span class="t2-em">{{ t.cardsFade }}</span></h2><p class="t2-sub">{{ t.cardsDesc }}</p></div><div class="app-img-center an"><img src="/images/cards-lineup.png" alt="SDB Cards" loading="lazy" style="max-width:700px;width:100%;border-radius:20px"/></div><div class="tiers an"><div v-for="c in t.cardTiers" :key="c.n" class="tier-mini"><div class="tier-bar" :style="{background:c.c}"></div><h4 class="tier-n">{{ c.n }} <span class="tier-p">{{ c.p }}</span></h4><ul class="tier-f"><li v-for="f in c.f" :key="f">{{ f }}</li></ul></div></div><div class="tc an" style="margin-top:32px"><Link href="/cards-info" class="link-btn">{{ t.cardsBtn }}</Link></div></div></section>

<!-- SALARY -->
<section class="sec"><div class="sw"><div class="sec-hdr an"><h2 class="t2">{{ t.salTitle }}<br><span class="t2-em">{{ t.salFade }}</span></h2><p class="t2-sub">{{ t.salDesc }}</p></div><div class="g6 an"><div v-for="c in t.salCards" :key="c.t" class="sal-c"><span class="sal-ic">{{ c.ic }}</span><h4 class="sal-t">{{ c.t }}</h4><p class="sal-d">{{ c.d }}</p></div></div><div class="tc an" style="margin-top:32px"><Link href="/salary" class="link-btn">{{ t.salBtn }}</Link></div></div></section>

<!-- TRANSFERS + IMAGE -->
<section class="sec sec-dark"><div class="sw"><div class="sec-hdr an"><h2 class="t2 t2-w">{{ t.trTitle }}<br><span class="t2-em-w">{{ t.trFade }}</span></h2><p class="t2-sub t2-sub-w">{{ t.trDesc }}</p></div><div class="app-img-center an"><img src="/images/transfer-globe.png" alt="Global Transfers" loading="lazy" style="max-width:500px;width:100%;border-radius:20px;margin-bottom:32px"/></div><div class="g4 an"><div v-for="f in t.trFeats" :key="f.v" class="tr-card"><div class="tr-v">{{ f.v }}</div><div class="tr-l">{{ f.l }}</div><div class="tr-d">{{ f.d }}</div></div></div><div class="tc an" style="margin-top:32px"><Link href="/transfers-info" class="link-btn link-btn-w">{{ t.trBtn }}</Link></div></div></section>

<!-- TECH -->
<section class="sec"><div class="sw"><div class="sec-hdr an"><div class="tech-tag">{{ t.techTag }}</div><h2 class="t2">{{ t.techTitle }}<br><span class="t2-em">{{ t.techFade }}</span></h2><p class="t2-sub">{{ t.techDesc }}</p></div><div class="g4b an"><div v-for="(f,i) in t.techFeats" :key="i" class="tech-c" :style="{transitionDelay:(i*50)+'ms'}"><span class="tech-ic">{{ f.ic }}</span><h4 class="tech-t">{{ f.t }}</h4><p class="tech-d">{{ f.d }}</p></div></div></div></section>

<!-- SECURITY -->
<section class="sec sec-alt"><div class="sw"><div class="sec-hdr an"><h2 class="t2">{{ t.secTitle }}<br><span class="t2-em">{{ t.secFade }}</span></h2><p class="t2-sub">{{ t.secDesc }}</p></div><div class="g4b an"><div v-for="(f,i) in t.secFeats" :key="i" class="sec-c" :style="{transitionDelay:(i*50)+'ms'}"><span class="sec-ic">{{ f.ic }}</span><h4 class="sec-t">{{ f.t }}</h4><p class="sec-d">{{ f.d }}</p></div></div></div></section>

<!-- ACCOUNT TYPES -->
<section class="sec"><div class="sw"><div class="sec-hdr an"><h2 class="t2 tc">{{ t.acctTitle }}</h2></div><div class="g4b an"><div v-for="a in t.acctTypes" :key="a.t" class="acct-c"><span class="acct-ic">{{ a.ic }}</span><h4 class="acct-t">{{ a.t }}</h4><p class="acct-d">{{ a.d }}</p><ul class="acct-f"><li v-for="f in a.f" :key="f">✓ {{ f }}</li></ul></div></div></div></section>

<!-- COMING SOON -->
<section class="sec sec-dark"><div class="sw"><div class="sec-hdr an"><h2 class="t2 t2-w">{{ t.soonTitle }}<br><span class="t2-em-w">{{ t.soonFade }}</span></h2><p class="t2-sub t2-sub-w">{{ t.soonDesc }}</p></div><div class="soon-grid an"><div v-for="s in t.soonItems" :key="s" class="soon-item">{{ s }}</div></div></div></section>

<!-- STATS -->
<section class="sec"><div class="sw"><div class="stats an"><div v-for="s in t.stats" :key="s.v" class="stat-i"><div class="stat-v">{{ s.v }}</div><div class="stat-l">{{ s.l }}</div></div></div></div></section>

<!-- CTA -->
<section class="sec sec-cta"><div class="sw tc"><div class="cta-tag an">{{ t.ctaTag }}</div><h2 class="t2 an">{{ t.ctaTitle }}</h2><p class="t2-sub an tc" style="margin:0 auto 32px;text-align:center">{{ t.ctaSub }}</p><div class="cta-row an"><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a><a href="/support" class="cta-btn2">{{ t.ctaBtn2 }}</a></div></div></section>
</template>

<style scoped>
.hero{padding:180px 0 100px;background:#fff;position:relative;overflow:hidden}
.hero::after{content:'';position:absolute;top:-30%;right:-15%;width:60%;height:160%;background:radial-gradient(ellipse,rgba(37,99,235,.04) 0%,transparent 65%);pointer-events:none}
.rtl .hero::after{right:auto;left:-15%}
.hero-inner{max-width:720px;position:relative;z-index:1}
.hero-tag{font-size:12px;font-weight:800;letter-spacing:3px;color:#2563EB;margin-bottom:28px;text-transform:uppercase}.rtl .hero-tag{letter-spacing:0}
.hero-h{margin-bottom:24px;line-height:1.05}
.hero-h1,.hero-h2{display:block;font-size:clamp(2.8rem,6.5vw,5rem);font-weight:900;letter-spacing:-.04em}.hero-h1{color:#0a0a0a}.hero-h2{color:#2563EB}.rtl .hero-h1,.rtl .hero-h2{letter-spacing:0}
.hero-p{font-size:17px;color:rgba(10,10,10,.35);line-height:1.9;margin-bottom:48px;max-width:560px}
.hero-cd{display:flex;gap:24px;margin-bottom:40px}
.cd-b{text-align:center;min-width:56px}.cd-n{font-size:48px;font-weight:900;color:#0a0a0a;line-height:1;font-variant-numeric:tabular-nums}.cd-l{font-size:10px;color:rgba(10,10,10,.18);margin-top:6px;font-weight:700;letter-spacing:1.2px;text-transform:uppercase}
.hero-eml{display:flex;gap:0;max-width:460px;border:2px solid #0a0a0a;border-radius:14px;overflow:hidden;margin-bottom:40px}
.eml-i{flex:1;padding:15px 20px;border:none;outline:none;font-size:15px;background:transparent;color:#0a0a0a;font-family:inherit}.eml-i::placeholder{color:#ccc}
.eml-b{padding:15px 28px;background:#0a0a0a;color:#fff;border:none;font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;transition:background .2s;white-space:nowrap}.eml-b:hover{background:#222}
.eml-ok{padding:15px;color:#2563EB;font-weight:700;font-size:15px}
.rtl .hero-eml{flex-direction:row-reverse}
.hero-trust{display:flex;gap:20px;flex-wrap:wrap}.trust-i{font-size:12px;color:rgba(10,10,10,.22);font-weight:600}
.mq{padding:18px 0;border-top:1px solid rgba(0,0,0,.04);border-bottom:1px solid rgba(0,0,0,.04);overflow:hidden;background:#fafafa}
.mq-track{display:flex;gap:48px;animation:mqs 25s linear infinite;white-space:nowrap}
.mq-i{font-size:13px;font-weight:800;color:rgba(10,10,10,.07);letter-spacing:3px;text-transform:uppercase}
@keyframes mqs{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}
.sec{padding:100px 0}.sec-alt{background:#fafafa}.sec-dark{background:#0a0a0a;color:#fff}.sec-cta{padding:120px 0;background:#fff}
.sec-hdr{margin-bottom:56px}.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.t2{font-size:clamp(2rem,4.5vw,3.2rem);font-weight:900;line-height:1.1;letter-spacing:-.03em;margin-bottom:16px}.rtl .t2{letter-spacing:0}
.t2-fade{opacity:.12}.t2-em{color:#2563EB}.t2-w{color:#fff}.t2-em-w{color:#60A5FA}
.t2-sub{font-size:16px;color:rgba(10,10,10,.35);line-height:1.85;max-width:560px;margin-top:8px}.t2-sub-w{color:rgba(255,255,255,.3)}.rtl .t2-sub{text-align:right}
.g6{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.ev-card{padding:32px 24px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:18px;transition:all .35s}.ev-card:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(0,0,0,.06)}
.ev-ic{font-size:32px;display:block;margin-bottom:12px}.ev-t{font-size:16px;font-weight:800;margin-bottom:6px}.ev-d{font-size:13px;color:rgba(10,10,10,.35);line-height:1.75}
.fg{display:grid;grid-template-columns:repeat(3,1fr);gap:1px;background:rgba(0,0,0,.06);border:1px solid rgba(0,0,0,.06);border-radius:20px;overflow:hidden}
.fc{padding:32px 24px;background:#fafafa;transition:background .3s;text-decoration:none;color:inherit;display:block}.fc:hover{background:#fff}
.fc-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:14px}.rtl .fc-top{flex-direction:row-reverse}
.fc-tag{font-size:10px;font-weight:800;letter-spacing:1.5px;color:#2563EB;opacity:.5;text-transform:uppercase}.rtl .fc-tag{letter-spacing:0}
.fc-ic{font-size:24px}.fc-t{font-size:15px;font-weight:800;margin-bottom:6px}.fc-p{font-size:12.5px;color:rgba(10,10,10,.3);line-height:1.8}
.app-row{display:flex;gap:48px;align-items:center}.app-text{flex:1}.app-img{flex:1;text-align:center}
.app-img img{max-width:380px;width:100%;border-radius:20px}
.app-feats{display:flex;flex-wrap:wrap;gap:8px;margin-top:24px}.app-feat{font-size:12px;font-weight:600;color:rgba(10,10,10,.4);padding:6px 14px;background:rgba(37,99,235,.04);border-radius:8px}
.app-img-center{text-align:center;margin-bottom:32px}
.tiers{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.tier-mini{padding:24px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px;position:relative;overflow:hidden}
.tier-bar{height:4px;position:absolute;top:0;left:0;right:0}.tier-n{font-size:18px;font-weight:900;margin-bottom:12px;margin-top:8px}
.tier-p{font-size:12px;font-weight:600;color:rgba(10,10,10,.3)}.tier-f{list-style:none;padding:0;display:flex;flex-direction:column;gap:6px}
.tier-f li{font-size:12px;color:rgba(10,10,10,.45);padding-bottom:4px;border-bottom:1px solid rgba(10,10,10,.04)}
.link-btn{font-size:14px;font-weight:700;color:#2563EB;text-decoration:none;transition:opacity .2s}.link-btn:hover{opacity:.7}
.link-btn-w{color:#60A5FA}
.sal-c{padding:28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px;text-align:center;transition:all .3s}.sal-c:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,.05)}
.sal-ic{font-size:24px;display:block;margin-bottom:8px}.sal-t{font-size:14px;font-weight:800;margin-bottom:4px}.sal-d{font-size:12px;color:rgba(10,10,10,.3);line-height:1.6}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.tr-card{padding:28px 20px;background:rgba(255,255,255,.04);border:1px solid rgba(255,255,255,.06);border-radius:16px;text-align:center;transition:all .3s}.tr-card:hover{background:rgba(255,255,255,.08)}
.tr-v{font-size:28px;font-weight:900;color:#60A5FA;margin-bottom:4px}.tr-l{font-size:13px;font-weight:700;color:#fff;margin-bottom:4px}.tr-d{font-size:11px;color:rgba(255,255,255,.25)}
.tech-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#2563EB;text-transform:uppercase;margin-bottom:20px}.rtl .tech-tag{letter-spacing:0}
.g4b{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.tech-c{padding:28px 20px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px;transition:all .3s}.tech-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.tech-ic{font-size:28px;display:block;margin-bottom:10px}.tech-t{font-size:13px;font-weight:800;margin-bottom:4px}.tech-d{font-size:11.5px;color:rgba(10,10,10,.3);line-height:1.7}
.sec-c{padding:24px 20px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:16px;transition:all .3s}.sec-c:hover{transform:translateY(-3px)}
.sec-ic{font-size:24px;display:block;margin-bottom:8px}.sec-t{font-size:13px;font-weight:800;margin-bottom:4px}.sec-d{font-size:11.5px;color:rgba(10,10,10,.3);line-height:1.7}
.acct-c{padding:28px;background:#fff;border:1px solid rgba(10,10,10,.06);border-radius:18px;transition:all .3s}.acct-c:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,.04)}
.acct-ic{font-size:28px;display:block;margin-bottom:10px}.acct-t{font-size:16px;font-weight:800;margin-bottom:6px}.acct-d{font-size:12.5px;color:rgba(10,10,10,.35);line-height:1.7;margin-bottom:14px}
.acct-f{list-style:none;padding:0;display:flex;flex-direction:column;gap:4px}.acct-f li{font-size:12px;color:rgba(10,10,10,.4);padding:4px 0;border-top:1px solid rgba(10,10,10,.04)}
.soon-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.soon-item{padding:18px 20px;background:rgba(255,255,255,.04);border:1px solid rgba(255,255,255,.06);border-radius:12px;font-size:14px;font-weight:600;color:rgba(255,255,255,.5);text-align:center;transition:all .3s}.soon-item:hover{background:rgba(255,255,255,.08);border-color:rgba(255,255,255,.12)}
.stats{display:grid;grid-template-columns:repeat(6,1fr);gap:1px;background:rgba(10,10,10,.06);border:1px solid rgba(10,10,10,.06);border-radius:16px;overflow:hidden}
.stat-i{padding:40px 20px;background:#fff;text-align:center}.stat-v{font-size:36px;font-weight:900;color:#0a0a0a;margin-bottom:4px}.stat-l{font-size:11px;color:rgba(10,10,10,.2);font-weight:600}
.cta-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#2563EB;text-transform:uppercase;margin-bottom:20px}.rtl .cta-tag{letter-spacing:0}
.cta-row{display:flex;gap:16px;justify-content:center;flex-wrap:wrap}
.cta-btn{display:inline-block;padding:18px 48px;background:#0a0a0a;color:#fff;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;transition:all .2s}.cta-btn:hover{background:#222;transform:translateY(-2px)}
.cta-btn2{display:inline-block;padding:18px 48px;background:transparent;color:#0a0a0a;font-size:16px;font-weight:800;border-radius:14px;text-decoration:none;border:2px solid rgba(10,10,10,.1);transition:all .2s}.cta-btn2:hover{border-color:rgba(10,10,10,.3)}
.an{opacity:0;transform:translateY(20px);transition:opacity .6s cubic-bezier(.25,.46,.45,.94),transform .6s cubic-bezier(.25,.46,.45,.94)}.an.vi{opacity:1;transform:none}
@media(max-width:900px){.tiers{grid-template-columns:repeat(2,1fr)}.stats{grid-template-columns:repeat(3,1fr)}.soon-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.hero{padding:130px 0 70px}.sec{padding:70px 0}.g6,.fg,.g4b{grid-template-columns:1fr}.g4{grid-template-columns:repeat(2,1fr)}.hero-cd{gap:14px}.cd-n{font-size:36px}.hero-trust{flex-direction:column;gap:8px}.app-row{flex-direction:column}.tiers{grid-template-columns:1fr}.stats{grid-template-columns:repeat(2,1fr)}.soon-grid{grid-template-columns:1fr}}
</style>
