<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { inject, ref, computed } from 'vue';
import SiteLayout from '@/Layouts/SiteLayout.vue';
defineOptions({ layout: SiteLayout });
const isAr = inject('isAr', computed(() => true));

/* Live Chat */
const chatOpen = ref(false);
const chatMsg = ref('');
const chatMessages = ref([]);
const chatSend = () => {
  if (!chatMsg.value.trim()) return;
  chatMessages.value.push({ from:'user', text: chatMsg.value, time: new Date().toLocaleTimeString('en',{hour:'2-digit',minute:'2-digit'}) });
  const msg = chatMsg.value;
  chatMsg.value = '';
  setTimeout(() => {
    chatMessages.value.push({ from:'bot', text: isAr.value ? 'شكراً لتواصلك! فريقنا سيرد عليك قريباً. لأسئلة شائعة تفضل بزيارة صفحة الأسئلة الشائعة.' : 'Thanks for reaching out! Our team will respond shortly. For common questions, visit our FAQ page.', time: new Date().toLocaleTimeString('en',{hour:'2-digit',minute:'2-digit'}) });
  }, 1000);
};

const t = computed(() => isAr.value ? {
  title:'الدعم — SDB Bank',tag:'مركز المساعدة',
  heroH:'كيف نقدر نساعدك؟',heroP:'فريقنا متواجد على مدار الساعة لمساعدتك. اختر طريقة التواصل المناسبة لك.',
  cards:[
    {ic:'💬',t:'دردشة مباشرة',d:'تحدث مع فريق الدعم مباشرة. متواجدون 24/7 لمساعدتك فوراً.',btn:'ابدأ المحادثة',action:'chat'},
    {ic:'📧',t:'البريد الإلكتروني',d:'أرسل لنا رسالة وسنرد خلال ساعات. للاستفسارات التفصيلية.',btn:'info@sdb-bank.com',href:'mailto:info@sdb-bank.com'},
    {ic:'📞',t:'الهاتف',d:'اتصل بنا مباشرة خلال ساعات العمل أو 24/7 للطوارئ.',btn:'+45 42 80 55 94',href:'tel:+4542805594'},
    {ic:'❓',t:'الأسئلة الشائعة',d:'إجابات فورية لأكثر الأسئلة شيوعاً عن خدماتنا.',btn:'تصفح الأسئلة',href:'/faq'},
    {ic:'🐦',t:'تويتر / X',d:'تابعنا على تويتر للأخبار والتحديثات والدعم السريع.',btn:'@SDBBank',href:'#'},
    {ic:'📱',t:'واتساب',d:'تواصل معنا عبر واتساب — أسرع طريقة للحصول على مساعدة.',btn:'أرسل رسالة',href:'#'},
  ],
  topicsTitle:'مواضيع شائعة',
  topics:[
    {ic:'🏦',t:'فتح حساب',d:'كيف أفتح حساب؟ ما الوثائق المطلوبة؟ كم يستغرق؟',href:'/faq'},
    {ic:'💳',t:'مشاكل البطاقة',d:'بطاقتي لا تعمل، أريد تجميدها، أو طلب بديل.',href:'/cards-info'},
    {ic:'💸',t:'التحويلات',d:'تحويلي متأخر، كيف أتابع التحويل، رسوم التحويل.',href:'/transfers-info'},
    {ic:'🔐',t:'الأمان',d:'نشاط مريب على حسابي، نسيت كلمة المرور، قفل الحساب.',href:'/about'},
    {ic:'💰',t:'الرواتب',d:'كيف أستلم راتبي عبر SDB، إعداد الإيداع المباشر.',href:'/salary'},
    {ic:'💱',t:'العملات',d:'أسعار الصرف، تحويل العملات، العملات المدعومة.',href:'/currencies'},
  ],
  hoursTitle:'ساعات العمل',
  hours:[{d:'الاثنين – الجمعة',h:'9:00 صباحاً – 6:00 مساءً (CET)'},{d:'السبت – الأحد',h:'10:00 صباحاً – 2:00 ظهراً (CET)'}],
  hoursNote:'خدمات الطوارئ (تجميد البطاقة والحساب) متاحة 24/7 عبر الهاتف والتطبيق.',
  addrTitle:'العنوان',addr:'SDB Bank ApS\nDenmark 🇩🇰',
  chatTitle:'دردشة مباشرة',chatPh:'اكتب رسالتك...',chatSend:'إرسال',chatWelcome:'مرحباً! كيف نقدر نساعدك اليوم؟ 👋',
} : {
  title:'Support — SDB Bank',tag:'Help Centre',
  heroH:'How can we help?',heroP:'Our team is available around the clock. Choose your preferred way to reach us.',
  cards:[
    {ic:'💬',t:'Live Chat',d:'Talk to our support team directly. Available 24/7 for instant help.',btn:'Start chat',action:'chat'},
    {ic:'📧',t:'Email',d:'Send us a message and we\'ll respond within hours. For detailed inquiries.',btn:'info@sdb-bank.com',href:'mailto:info@sdb-bank.com'},
    {ic:'📞',t:'Phone',d:'Call us during business hours or 24/7 for emergencies.',btn:'+45 42 80 55 94',href:'tel:+4542805594'},
    {ic:'❓',t:'FAQ',d:'Instant answers to the most common questions about our services.',btn:'Browse FAQ',href:'/faq'},
    {ic:'🐦',t:'Twitter / X',d:'Follow us on Twitter for news, updates, and quick support.',btn:'@SDBBank',href:'#'},
    {ic:'📱',t:'WhatsApp',d:'Reach us on WhatsApp — the fastest way to get help.',btn:'Send message',href:'#'},
  ],
  topicsTitle:'Popular topics',
  topics:[
    {ic:'🏦',t:'Open Account',d:'How to open an account? Required documents? How long?',href:'/faq'},
    {ic:'💳',t:'Card Issues',d:'Card not working, want to freeze it, or request a replacement.',href:'/cards-info'},
    {ic:'💸',t:'Transfers',d:'Transfer delayed, tracking, fees.',href:'/transfers-info'},
    {ic:'🔐',t:'Security',d:'Suspicious activity, forgot password, account lock.',href:'/about'},
    {ic:'💰',t:'Salary',d:'How to receive salary via SDB, direct deposit setup.',href:'/salary'},
    {ic:'💱',t:'Currencies',d:'Exchange rates, conversion, supported currencies.',href:'/currencies'},
  ],
  hoursTitle:'Business Hours',
  hours:[{d:'Monday – Friday',h:'9:00 AM – 6:00 PM (CET)'},{d:'Saturday – Sunday',h:'10:00 AM – 2:00 PM (CET)'}],
  hoursNote:'Emergency services (card & account freeze) are available 24/7 via phone and in-app.',
  addrTitle:'Address',addr:'SDB Bank ApS\nDenmark 🇩🇰',
  chatTitle:'Live Chat',chatPh:'Type your message...',chatSend:'Send',chatWelcome:'Hello! How can we help you today? 👋',
});
</script>
<template>
<Head :title="t.title" />
<section class="p-hero"><div class="sw tc"><div class="p-hero-tag">{{ t.tag }}</div><h1 class="p-hero-h">{{ t.heroH }}</h1><p class="p-hero-p">{{ t.heroP }}</p></div></section>

<section class="sec"><div class="sw"><div class="cards-g"><div v-for="c in t.cards" :key="c.t" class="sp-c" @click="c.action==='chat' ? chatOpen=true : null"><span class="sp-ic">{{ c.ic }}</span><h3 class="sp-t">{{ c.t }}</h3><p class="sp-d">{{ c.d }}</p><a v-if="c.href" :href="c.href" class="sp-btn" @click.stop>{{ c.btn }}</a><button v-else class="sp-btn" @click="chatOpen=true">{{ c.btn }}</button></div></div></div></section>

<section class="sec sec-alt"><div class="sw"><h2 class="t2 tc">{{ t.topicsTitle }}</h2><div class="topics-g"><Link v-for="tp in t.topics" :key="tp.t" :href="tp.href" class="tp-c"><span class="tp-ic">{{ tp.ic }}</span><h4 class="tp-t">{{ tp.t }}</h4><p class="tp-d">{{ tp.d }}</p></Link></div></div></section>

<section class="sec"><div class="sw info-row"><div class="info-box"><h2 class="info-h">{{ t.hoursTitle }}</h2><div v-for="h in t.hours" :key="h.d" class="info-r"><span class="info-day">{{ h.d }}</span><span class="info-time">{{ h.h }}</span></div><p class="info-note">{{ t.hoursNote }}</p></div><div class="info-box"><h2 class="info-h">{{ t.addrTitle }}</h2><p class="info-addr">{{ t.addr }}</p></div></div></section>

<!-- Live Chat Widget -->
<div v-if="chatOpen" class="chat-overlay" @click.self="chatOpen=false">
  <div class="chat-box">
    <div class="chat-header"><span class="chat-title">{{ t.chatTitle }}</span><button @click="chatOpen=false" class="chat-close">✕</button></div>
    <div class="chat-body">
      <div class="chat-welcome">{{ t.chatWelcome }}</div>
      <div v-for="(m,i) in chatMessages" :key="i" :class="['chat-msg', m.from==='user'?'chat-user':'chat-bot']">
        <div class="chat-bubble">{{ m.text }}</div>
        <span class="chat-time">{{ m.time }}</span>
      </div>
    </div>
    <div class="chat-footer"><input v-model="chatMsg" :placeholder="t.chatPh" class="chat-input" @keyup.enter="chatSend"/><button @click="chatSend" class="chat-send">{{ t.chatSend }}</button></div>
  </div>
</div>

<!-- Floating chat button -->
<button v-if="!chatOpen" @click="chatOpen=true" class="chat-fab">💬</button>
</template>
<style scoped>
.sw{max-width:1200px;margin:0 auto;padding:0 24px}.tc{text-align:center}
.sec{padding:80px 0}.sec-alt{background:#fafafa}
.t2{font-size:clamp(1.8rem,4vw,2.8rem);font-weight:900;line-height:1.1;margin-bottom:48px}
.p-hero{padding:150px 0 60px;background:linear-gradient(135deg,#163300,#1a3d00,#0f2600);color:#fff;position:relative;overflow:hidden}
.p-hero-tag{font-size:11px;font-weight:800;letter-spacing:2px;color:#9FE870;text-transform:uppercase;margin-bottom:24px}
.p-hero-h{font-size:clamp(2rem,5vw,3.5rem);font-weight:900;margin-bottom:16px}
.p-hero-p{font-size:17px;color:rgba(255,255,255,.45);max-width:500px;margin:0 auto;line-height:1.8}
.cards-g{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.sp-c{padding:32px;background:#fff;border:1px solid rgba(159,232,112,.1);border-radius:18px;text-align:center;cursor:pointer;transition:all .3s}.sp-c:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(159,232,112,.08);border-color:rgba(159,232,112,.3)}
.sp-ic{font-size:32px;display:block;margin-bottom:12px}.sp-t{font-size:16px;font-weight:800;color:#163300;margin-bottom:6px}.sp-d{font-size:13px;color:#666;line-height:1.7;margin-bottom:16px}
.sp-btn{display:inline-block;padding:10px 20px;background:#163300;color:#fff;border:none;border-radius:10px;font-size:13px;font-weight:700;text-decoration:none;cursor:pointer;font-family:inherit;transition:all .2s}.sp-btn:hover{background:#1e4400}
.topics-g{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.tp-c{padding:24px;background:#fff;border:1px solid rgba(159,232,112,.1);border-radius:16px;text-decoration:none;color:inherit;transition:all .3s}.tp-c:hover{transform:translateY(-3px);border-color:rgba(159,232,112,.3)}
.tp-ic{font-size:24px;display:block;margin-bottom:8px}.tp-t{font-size:14px;font-weight:800;color:#163300;margin-bottom:4px}.tp-d{font-size:12px;color:#666;line-height:1.7}
.info-row{display:grid;grid-template-columns:2fr 1fr;gap:24px}
.info-box{padding:28px;background:#F5F9F3;border:1px solid rgba(159,232,112,.1);border-radius:18px}
.info-h{font-size:16px;font-weight:800;color:#163300;margin-bottom:16px}
.info-r{display:flex;justify-content:space-between;padding:10px 0;border-bottom:1px solid rgba(10,10,10,.06)}
.info-day{font-size:14px;font-weight:600}.info-time{font-size:13px;color:rgba(10,10,10,.4)}
.info-note{font-size:11px;color:rgba(10,10,10,.3);margin-top:12px;line-height:1.6}
.info-addr{font-size:14px;color:rgba(10,10,10,.5);line-height:1.8;white-space:pre-line}
/* Chat Widget */
.chat-fab{position:fixed;bottom:24px;right:24px;width:60px;height:60px;border-radius:50%;background:#9FE870;color:#163300;border:none;font-size:28px;cursor:pointer;box-shadow:0 8px 24px rgba(159,232,112,.4);z-index:100;transition:all .2s}.chat-fab:hover{transform:scale(1.1)}
.rtl .chat-fab{right:auto;left:24px}
.chat-overlay{position:fixed;inset:0;background:rgba(0,0,0,.4);z-index:200;display:flex;align-items:flex-end;justify-content:flex-end;padding:24px}
.rtl .chat-overlay{justify-content:flex-start}
.chat-box{width:380px;max-height:520px;background:#fff;border-radius:20px;display:flex;flex-direction:column;overflow:hidden;box-shadow:0 24px 48px rgba(0,0,0,.15);animation:chatIn .3s ease}
@keyframes chatIn{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:none}}
.chat-header{background:linear-gradient(135deg,#163300,#1a3d00,#0f2600);color:#fff;padding:16px 20px;display:flex;justify-content:space-between;align-items:center}
.chat-title{font-size:15px;font-weight:800}.chat-close{background:none;border:none;color:rgba(255,255,255,.5);font-size:18px;cursor:pointer}
.chat-body{flex:1;padding:20px;overflow-y:auto;display:flex;flex-direction:column;gap:12px;min-height:300px}
.chat-welcome{background:rgba(14,165,233,.06);padding:12px 16px;border-radius:14px;font-size:13px;color:rgba(10,10,10,.5);line-height:1.6}
.chat-msg{display:flex;flex-direction:column;max-width:80%}
.chat-user{align-self:flex-end}.chat-bot{align-self:flex-start}
.chat-bubble{padding:10px 16px;border-radius:14px;font-size:13px;line-height:1.6}
.chat-user .chat-bubble{background:#163300;color:#fff;border-bottom-right-radius:4px}
.rtl .chat-user .chat-bubble{border-bottom-right-radius:14px;border-bottom-left-radius:4px}
.chat-bot .chat-bubble{background:#f3f4f6;color:#0a0a0a;border-bottom-left-radius:4px}
.rtl .chat-bot .chat-bubble{border-bottom-left-radius:14px;border-bottom-right-radius:4px}
.chat-time{font-size:10px;color:rgba(10,10,10,.2);margin-top:4px}
.chat-footer{padding:12px;border-top:1px solid rgba(10,10,10,.06);display:flex;gap:8px}
.chat-input{flex:1;padding:10px 14px;border:1px solid rgba(159,232,112,.2);border-radius:10px;font-size:13px;font-family:inherit;outline:none}.chat-input:focus{border-color:#9FE870}
.chat-send{padding:10px 18px;background:#163300;color:#fff;border:none;border-radius:10px;font-size:13px;font-weight:700;cursor:pointer;font-family:inherit}
@media(max-width:768px){.cards-g,.topics-g{grid-template-columns:1fr}.info-row{grid-template-columns:1fr}.chat-box{width:100%;max-height:100%;border-radius:0}.chat-overlay{padding:0}}
</style>
