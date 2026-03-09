<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));
const t = computed(() => isAr.value ? {
  title:'العملات الرقمية — SDB Bank',tag:'🪙 العملات الرقمية',
  heroH:'ادخل عالم',heroEm:'العملات الرقمية.',
  heroP:'اشترِ، بِع، واحتفظ بأشهر العملات الرقمية مباشرة من حسابك البنكي. بسيط، آمن، وبدون تعقيد.',
  coinsTitle:'العملات الرقمية المدعومة',
  coins:[
    {sym:'BTC',name:'بيتكوين',en:'Bitcoin',ic:'₿',color:'#F7931A',price:'96,850',change:'+2.4%',cap:'1.9T $',desc:'العملة الرقمية الأولى والأكبر. مخزن قيمة رقمي يُلقّب بالذهب الرقمي.'},
    {sym:'ETH',name:'إيثيريوم',en:'Ethereum',ic:'Ξ',color:'#627EEA',price:'3,420',change:'+1.8%',cap:'411B $',desc:'منصة العقود الذكية الأكبر. تشغّل التطبيقات اللامركزية وعالم DeFi.'},
    {sym:'USDT',name:'تيثر',en:'Tether',ic:'₮',color:'#26A17B',price:'1.00',change:'0.0%',cap:'120B $',desc:'عملة مستقرة مربوطة بالدولار 1:1. مثالية لتخزين القيمة بدون تقلبات.'},
    {sym:'USDC',name:'يو إس دي سي',en:'USD Coin',ic:'$',color:'#2775CA',price:'1.00',change:'0.0%',cap:'45B $',desc:'عملة مستقرة صادرة من Circle. مدعومة بالكامل باحتياطي دولاري.'},
    {sym:'BNB',name:'بينانس كوين',en:'BNB',ic:'◆',color:'#F0B90B',price:'580',change:'+3.1%',cap:'86B $',desc:'عملة منصة Binance. تستخدم لتخفيض رسوم التداول والمشاركة بالنظام البيئي.'},
    {sym:'SOL',name:'سولانا',en:'Solana',ic:'◎',color:'#9945FF',price:'188',change:'+4.2%',cap:'82B $',desc:'بلوكتشين فائق السرعة. معاملات بأجزاء من الثانية وتكلفة شبه معدومة.'},
    {sym:'XRP',name:'ريبل',en:'XRP',ic:'✕',color:'#23292F',price:'2.35',change:'+1.5%',cap:'135B $',desc:'شبكة مدفوعات عالمية. مصممة للتحويلات البنكية الدولية السريعة.'},
    {sym:'ADA',name:'كاردانو',en:'Cardano',ic:'₳',color:'#0033AD',price:'0.68',change:'+2.1%',cap:'24B $',desc:'بلوكتشين أكاديمي مبني على أبحاث محكّمة. يركز على الاستدامة والأمان.'},
    {sym:'DOGE',name:'دوج كوين',en:'Dogecoin',ic:'Ð',color:'#C2A633',price:'0.32',change:'+5.8%',cap:'47B $',desc:'عملة الإنترنت الشعبية. بدأت كمزحة وأصبحت ظاهرة عالمية.'},
    {sym:'DOT',name:'بولكادوت',en:'Polkadot',ic:'●',color:'#E6007A',price:'7.85',change:'+1.9%',cap:'10B $',desc:'بروتوكول يربط بلوكتشينات مختلفة معاً. يتيح نقل البيانات والأصول بين الشبكات.'},
    {sym:'AVAX',name:'أفالانش',en:'Avalanche',ic:'▲',color:'#E84142',price:'35.40',change:'+3.5%',cap:'14B $',desc:'منصة عقود ذكية فائقة السرعة. تنهي المعاملات بأقل من ثانية.'},
    {sym:'MATIC',name:'بوليغون',en:'Polygon',ic:'⬡',color:'#8247E5',price:'0.92',change:'+2.7%',cap:'9B $',desc:'حل توسيع لإيثيريوم. يوفر معاملات سريعة ورخيصة على شبكة إيثيريوم.'},
  ],
  howTitle:'كيف تتداول مع SDB؟',
  howSteps:[
    {n:'1',t:'افتح حسابك',d:'سجّل بدقائق وتحقق من هويتك. حسابك جاهز فوراً.'},
    {n:'2',t:'موّل حسابك',d:'أضف رصيد بالليرة السورية أو أي عملة مدعومة — تحويل بنكي أو بطاقة.'},
    {n:'3',t:'اختر العملة',d:'تصفّح العملات الرقمية المدعومة واطلع على الأسعار والرسوم البيانية.'},
    {n:'4',t:'اشترِ فوراً',d:'اضغط شراء — العملة تُضاف لمحفظتك فوراً. بِع بأي وقت بضغطة واحدة.'},
  ],
  featTitle:'مميزات التداول مع SDB',
  feats:[
    {ic:'🏦',t:'من حسابك البنكي',d:'لا حاجة لمنصة خارجية — اشترِ وبِع مباشرة من حساب SDB.'},
    {ic:'💱',t:'شراء بالليرة السورية',d:'أول بنك يتيح شراء العملات الرقمية بالليرة السورية الجديدة.'},
    {ic:'📊',t:'رسوم بيانية حية',d:'تتبع الأسعار لحظياً مع رسوم بيانية متقدمة ومؤشرات فنية.'},
    {ic:'🔔',t:'تنبيهات الأسعار',d:'حدد سعرك المستهدف وسنبلّغك فوراً لاقتناص الفرصة.'},
    {ic:'🔒',t:'تخزين آمن',d:'محفظة حراسة (custodial) مؤمنة بتشفير بنكي ومصادقة بيومترية.'},
    {ic:'📱',t:'تطبيق واحد',d:'أسهم، عملات رقمية، حساب بنكي — كل شيء بتطبيق SDB.'},
    {ic:'🔄',t:'تحويل فوري',d:'حوّل بين العملات الرقمية والعملات التقليدية فوراً.'},
    {ic:'📈',t:'بدون حد أدنى',d:'ابدأ من 500 ل.س فقط — لا حاجة لمبالغ كبيرة.'},
    {ic:'💡',t:'محتوى تعليمي',d:'دروس ومقالات تعليمية لفهم العملات الرقمية قبل الاستثمار.'},
  ],
  riskTitle:'⚠️ تحذير المخاطر',
  riskText:'العملات الرقمية استثمار عالي المخاطر. يمكن أن تخسر كل رأس مالك. لا تستثمر أكثر مما يمكنك تحمّل خسارته. الأداء السابق لا يضمن النتائج المستقبلية. SDB Bank لا يقدم نصائح استثمارية.',
  glossaryTitle:'مصطلحات أساسية',
  glossary:[
    {t:'بلوكتشين',d:'سجل رقمي موزّع وآمن يسجّل كل المعاملات بدون وسيط مركزي.'},
    {t:'محفظة رقمية',d:'تطبيق أو جهاز يخزّن مفاتيحك الخاصة ويتيح لك إرسال واستقبال العملات.'},
    {t:'عملة مستقرة',d:'عملة رقمية مربوطة بأصل تقليدي (عادة الدولار) لتقليل التقلبات.'},
    {t:'DeFi',d:'تمويل لامركزي — خدمات مالية تعمل على البلوكتشين بدون بنوك تقليدية.'},
    {t:'NFT',d:'رمز غير قابل للاستبدال — أصل رقمي فريد يمثل ملكية رقمية.'},
    {t:'Mining (تعدين)',d:'عملية التحقق من المعاملات وتأمين الشبكة مقابل مكافآت بالعملة.'},
  ],
  ctaTitle:'ابدأ رحلتك الرقمية',ctaSub:'اشترِ أول عملة رقمية بالليرة السورية — من حسابك البنكي مباشرة.',ctaBtn:'افتح حسابك ←',
} : {
  title:'Crypto Currencies — SDB Bank',tag:'🪙 Crypto Currencies',
  heroH:'Enter the world of',heroEm:'digital currencies.',
  heroP:'Buy, sell, and hold the most popular cryptocurrencies directly from your bank account. Simple, secure, and hassle-free.',
  coinsTitle:'Supported Cryptocurrencies',
  coins:[
    {sym:'BTC',name:'Bitcoin',en:'Bitcoin',ic:'₿',color:'#F7931A',price:'96,850',change:'+2.4%',cap:'1.9T $',desc:'The first and largest cryptocurrency. A digital store of value nicknamed digital gold.'},
    {sym:'ETH',name:'Ethereum',en:'Ethereum',ic:'Ξ',color:'#627EEA',price:'3,420',change:'+1.8%',cap:'411B $',desc:'The largest smart contract platform. Powers decentralized apps and the DeFi world.'},
    {sym:'USDT',name:'Tether',en:'Tether',ic:'₮',color:'#26A17B',price:'1.00',change:'0.0%',cap:'120B $',desc:'Stablecoin pegged 1:1 to the US Dollar. Ideal for value storage without volatility.'},
    {sym:'USDC',name:'USD Coin',en:'USD Coin',ic:'$',color:'#2775CA',price:'1.00',change:'0.0%',cap:'45B $',desc:'Stablecoin issued by Circle. Fully backed by dollar reserves.'},
    {sym:'BNB',name:'BNB',en:'BNB',ic:'◆',color:'#F0B90B',price:'580',change:'+3.1%',cap:'86B $',desc:'Binance ecosystem token. Used for trading fee discounts and ecosystem participation.'},
    {sym:'SOL',name:'Solana',en:'Solana',ic:'◎',color:'#9945FF',price:'188',change:'+4.2%',cap:'82B $',desc:'Ultra-fast blockchain. Sub-second transactions at near-zero cost.'},
    {sym:'XRP',name:'XRP',en:'XRP',ic:'✕',color:'#23292F',price:'2.35',change:'+1.5%',cap:'135B $',desc:'Global payments network. Designed for fast international bank transfers.'},
    {sym:'ADA',name:'Cardano',en:'Cardano',ic:'₳',color:'#0033AD',price:'0.68',change:'+2.1%',cap:'24B $',desc:'Academic blockchain built on peer-reviewed research. Focuses on sustainability and security.'},
    {sym:'DOGE',name:'Dogecoin',en:'Dogecoin',ic:'Ð',color:'#C2A633',price:'0.32',change:'+5.8%',cap:'47B $',desc:'The internet\'s favorite cryptocurrency. Started as a joke, became a global phenomenon.'},
    {sym:'DOT',name:'Polkadot',en:'Polkadot',ic:'●',color:'#E6007A',price:'7.85',change:'+1.9%',cap:'10B $',desc:'Protocol connecting different blockchains. Enables data and asset transfer between networks.'},
    {sym:'AVAX',name:'Avalanche',en:'Avalanche',ic:'▲',color:'#E84142',price:'35.40',change:'+3.5%',cap:'14B $',desc:'Ultra-fast smart contract platform. Finalizes transactions in under one second.'},
    {sym:'MATIC',name:'Polygon',en:'Polygon',ic:'⬡',color:'#8247E5',price:'0.92',change:'+2.7%',cap:'9B $',desc:'Ethereum scaling solution. Provides fast and cheap transactions on the Ethereum network.'},
  ],
  howTitle:'How to trade with SDB?',
  howSteps:[
    {n:'1',t:'Open your account',d:'Register in minutes and verify your identity. Your account is ready instantly.'},
    {n:'2',t:'Fund your account',d:'Add funds in Syrian Lira or any supported currency — bank transfer or card.'},
    {n:'3',t:'Choose your coin',d:'Browse supported cryptocurrencies and view prices and charts.'},
    {n:'4',t:'Buy instantly',d:'Tap buy — the coin is added to your wallet instantly. Sell anytime with one tap.'},
  ],
  featTitle:'SDB Trading Features',
  feats:[
    {ic:'🏦',t:'From your bank account',d:'No need for external platforms — buy and sell directly from your SDB account.'},
    {ic:'💱',t:'Buy with Syrian Lira',d:'First bank enabling crypto purchases with the new Syrian Lira.'},
    {ic:'📊',t:'Live charts',d:'Track prices in real-time with advanced charts and technical indicators.'},
    {ic:'🔔',t:'Price alerts',d:'Set your target price and we\'ll notify you instantly to seize the opportunity.'},
    {ic:'🔒',t:'Secure storage',d:'Custodial wallet secured with bank encryption and biometric authentication.'},
    {ic:'📱',t:'One app',d:'Stocks, crypto, bank account — everything in one SDB app.'},
    {ic:'🔄',t:'Instant conversion',d:'Convert between crypto and fiat currencies instantly.'},
    {ic:'📈',t:'No minimum',d:'Start from just 500 SYP — no need for large amounts.'},
    {ic:'💡',t:'Educational content',d:'Lessons and articles to understand crypto before investing.'},
  ],
  riskTitle:'⚠️ Risk Warning',
  riskText:'Cryptocurrencies are a high-risk investment. You can lose all your capital. Never invest more than you can afford to lose. Past performance does not guarantee future results. SDB Bank does not provide investment advice.',
  glossaryTitle:'Key Terms',
  glossary:[
    {t:'Blockchain',d:'A distributed, secure digital ledger that records all transactions without a central intermediary.'},
    {t:'Digital Wallet',d:'An app or device that stores your private keys and allows you to send and receive currencies.'},
    {t:'Stablecoin',d:'A cryptocurrency pegged to a traditional asset (usually the dollar) to reduce volatility.'},
    {t:'DeFi',d:'Decentralized Finance — financial services operating on blockchain without traditional banks.'},
    {t:'NFT',d:'Non-Fungible Token — a unique digital asset representing digital ownership.'},
    {t:'Mining',d:'The process of verifying transactions and securing the network in exchange for currency rewards.'},
  ],
  ctaTitle:'Start your crypto journey',ctaSub:'Buy your first cryptocurrency with Syrian Lira — directly from your bank account.',ctaBtn:'Open your account →',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}<br><span class="p-hero-em">{{ t.heroEm }}</span></h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<!-- Coins Grid -->
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.coinsTitle }}</h2><div class="coins-grid"><div v-for="c in t.coins" :key="c.sym" class="coin-c"><div class="coin-top"><span class="coin-ic" :style="{background:c.color}">{{ c.ic }}</span><div><div class="coin-sym">{{ c.sym }}</div><div class="coin-name">{{ isAr?c.name:c.en }}</div></div><div class="coin-right"><div class="coin-price">${{ c.price }}</div><div class="coin-change" :class="{'coin-up':c.change.startsWith('+'),'coin-neutral':c.change==='0.0%'}">{{ c.change }}</div></div></div><p class="coin-desc">{{ c.desc }}</p><div class="coin-cap">{{ isAr?'القيمة السوقية':'Market cap' }}: {{ c.cap }}</div></div></div></div></section>

<!-- How to Trade -->
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.howTitle }}</h2><div class="steps-row"><div v-for="s in t.howSteps" :key="s.n" class="step-c"><div class="step-n">{{ s.n }}</div><h4 class="step-t">{{ s.t }}</h4><p class="step-d">{{ s.d }}</p></div></div></div></section>

<!-- Features -->
<section class="sec"><div class="sw"><h2 class="t2 tc">{{ t.featTitle }}</h2><div class="g3"><div v-for="f in t.feats" :key="f.t" class="feat-c"><span class="feat-ic">{{ f.ic }}</span><h4 class="feat-t">{{ f.t }}</h4><p class="feat-d">{{ f.d }}</p></div></div></div></section>

<!-- Risk Warning -->
<section class="sec sec-risk"><div class="sw tc"><h2 class="t2">{{ t.riskTitle }}</h2><p class="risk-text">{{ t.riskText }}</p></div></section>

<!-- Glossary -->
<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.glossaryTitle }}</h2><div class="g3"><div v-for="g in t.glossary" :key="g.t" class="gloss-c"><h4 class="gloss-t">{{ g.t }}</h4><p class="gloss-d">{{ g.d }}</p></div></div></div></section>

<!-- CTA -->
<section class="sec sec-crypto tc"><div class="sw"><h2 class="t2 t2-w">{{ t.ctaTitle }}</h2><p class="t2-sub t2-sub-w tc" style="margin:0 auto 28px">{{ t.ctaSub }}</p><a href="/preregister" class="cta-btn">{{ t.ctaBtn }}</a></div></section>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#F5F3FF}.sec-risk{background:#FEF2F2;padding:40px 0}
.sec-crypto{background:linear-gradient(135deg,#1E1B4B 0%,#312E81 50%,#4F46E5 100%);color:#fff}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:32px}.t2-w{color:#fff}
.t2-sub{font-size:16px;line-height:1.8;max-width:540px}.t2-sub-w{color:rgba(255,255,255,.4)}
.p-hero{padding:160px 0 60px;background:linear-gradient(135deg,#1E1B4B 0%,#312E81 50%,#4F46E5 100%);color:#fff}
.p-hero-tag{font-size:12px;font-weight:800;letter-spacing:2px;color:rgba(255,255,255,.7);margin-bottom:24px}
.p-hero-h{font-size:clamp(2.2rem,5vw,3.8rem);font-weight:900;line-height:1.1;margin-bottom:16px}.p-hero-em{color:#A78BFA}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.55);max-width:560px;margin:0 auto;line-height:1.8}
.coins-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.coin-c{padding:24px;background:#fff;border:1px solid rgba(79,70,229,.06);border-radius:18px;transition:all .3s}.coin-c:hover{transform:translateY(-3px);box-shadow:0 12px 28px rgba(79,70,229,.08)}
.coin-top{display:flex;align-items:center;gap:12px;margin-bottom:14px}
.coin-ic{width:40px;height:40px;display:flex;align-items:center;justify-content:center;border-radius:12px;font-size:18px;font-weight:900;color:#fff;flex-shrink:0}
.coin-sym{font-size:16px;font-weight:900;color:#1E1B4B}.coin-name{font-size:11px;color:rgba(10,10,10,.35)}
.coin-right{margin-inline-start:auto;text-align:end}
.coin-price{font-size:16px;font-weight:900;color:#1E1B4B}
.coin-change{font-size:12px;font-weight:700;color:#059669}.coin-up{color:#059669}.coin-neutral{color:rgba(10,10,10,.3)}
.coin-desc{font-size:12px;color:rgba(10,10,10,.4);line-height:1.7;margin-bottom:10px}
.coin-cap{font-size:11px;font-weight:700;color:rgba(79,70,229,.4);padding-top:10px;border-top:1px solid rgba(79,70,229,.06)}
.steps-row{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.step-c{padding:28px;background:#fff;border:1px solid rgba(79,70,229,.08);border-radius:18px;text-align:center;position:relative}
.step-n{width:36px;height:36px;display:flex;align-items:center;justify-content:center;background:linear-gradient(135deg,#4F46E5,#7C3AED);color:#fff;font-size:16px;font-weight:900;border-radius:50%;margin:0 auto 14px}
.step-t{font-size:14px;font-weight:800;color:#1E1B4B;margin-bottom:6px}.step-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.7}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.feat-c{padding:24px;background:#fff;border:1px solid rgba(79,70,229,.06);border-radius:16px;text-align:center;transition:all .3s}.feat-c:hover{transform:translateY(-2px);box-shadow:0 8px 20px rgba(79,70,229,.06)}
.feat-ic{font-size:28px;display:block;margin-bottom:10px}.feat-t{font-size:13px;font-weight:800;color:#1E1B4B;margin-bottom:6px}.feat-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.7}
.risk-text{font-size:14px;color:#991B1B;line-height:1.8;max-width:600px;margin:0 auto;font-weight:600}
.gloss-c{padding:20px;background:#fff;border:1px solid rgba(79,70,229,.06);border-radius:14px}
.gloss-t{font-size:14px;font-weight:800;color:#4F46E5;margin-bottom:6px}.gloss-d{font-size:12px;color:rgba(10,10,10,.4);line-height:1.7}
.cta-btn{display:inline-block;padding:16px 44px;background:#fff;color:#1E1B4B;font-size:15px;font-weight:800;border-radius:12px;text-decoration:none;transition:all .2s}.cta-btn:hover{transform:translateY(-2px)}
@media(max-width:900px){.coins-grid{grid-template-columns:repeat(2,1fr)}.steps-row,.g3{grid-template-columns:repeat(2,1fr)}}
@media(max-width:600px){.coins-grid,.steps-row,.g3{grid-template-columns:1fr}}
</style>
