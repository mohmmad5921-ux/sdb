<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
  cryptoBalances: Array,
  eurBalance: Number,
  recentTrades: Array,
  spreadPercent: Number,
});

const flash = computed(() => usePage().props.flash || {});
const user = computed(() => usePage().props.auth?.user);

// UI State
const showBuy = ref(false);
const showSell = ref(false);
const selectedCrypto = ref(null);
const pricesRefreshing = ref(false);
const livePrices = ref({});

// Forms
const buyForm = useForm({ crypto_code: '', eur_amount: '' });
const sellForm = useForm({ crypto_code: '', crypto_amount: '' });

// Nav
const navItems = [
  { label: 'الرئيسية', icon: '🏦', route: 'dashboard' },
  { label: 'العملات الرقمية', icon: '🪙', route: 'banking.crypto', active: true },
  { label: 'المعاملات', icon: '💸', route: 'banking.transactions' },
  { label: 'التحليلات', icon: '📊', route: 'banking.analytics' },
  { label: 'المستفيدون', icon: '👥', route: 'banking.beneficiaries' },
  { label: 'الأمان', icon: '🔒', route: 'banking.security' },
  { label: 'الدعم', icon: '🎧', route: 'banking.support' },
];

// Crypto icons & colors
const cryptoMeta = {
  BTC: { icon: '₿', color: '#F7931A', name: 'Bitcoin' },
  ETH: { icon: '⟠', color: '#627EEA', name: 'Ethereum' },
  USDT: { icon: '₮', color: '#26A17B', name: 'Tether' },
  SOL: { icon: '◎', color: '#9945FF', name: 'Solana' },
  XRP: { icon: '✕', color: '#23292F', name: 'Ripple' },
  ADA: { icon: '⬡', color: '#3CC8C8', name: 'Cardano' },
};

// Computed
const totalCryptoValueEur = computed(() =>
  props.cryptoBalances?.reduce((sum, c) => sum + c.value_eur, 0) || 0
);

const getPrice = (code) => livePrices.value[code]?.price || props.cryptoBalances?.find(c => c.code === code)?.price || 0;
const getChange = (code) => livePrices.value[code]?.change_24h || props.cryptoBalances?.find(c => c.code === code)?.change_24h || 0;

// Buy preview
const buyPreview = computed(() => {
  if (!buyForm.eur_amount || !buyForm.crypto_code) return null;
  const price = getPrice(buyForm.crypto_code);
  const spread = props.spreadPercent / 100;
  const buyPrice = price * (1 + spread);
  const cryptoAmount = buyForm.eur_amount / buyPrice;
  return {
    cryptoAmount: cryptoAmount.toFixed(8),
    pricePerUnit: buyPrice.toFixed(2),
    fee: (buyForm.eur_amount * spread).toFixed(2),
  };
});

// Sell preview
const sellPreview = computed(() => {
  if (!sellForm.crypto_amount || !sellForm.crypto_code) return null;
  const price = getPrice(sellForm.crypto_code);
  const spread = props.spreadPercent / 100;
  const sellPrice = price * (1 - spread);
  const eurAmount = sellForm.crypto_amount * sellPrice;
  return {
    eurAmount: eurAmount.toFixed(2),
    pricePerUnit: sellPrice.toFixed(2),
    fee: (sellForm.crypto_amount * price * spread).toFixed(2),
  };
});

// Actions
function openBuy(crypto) {
  selectedCrypto.value = crypto;
  buyForm.crypto_code = crypto.code;
  buyForm.eur_amount = '';
  showBuy.value = true;
}
function openSell(crypto) {
  selectedCrypto.value = crypto;
  sellForm.crypto_code = crypto.code;
  sellForm.crypto_amount = '';
  showSell.value = true;
}
const submitBuy = () => buyForm.post(route('banking.crypto.buy'), {
  onSuccess: () => { showBuy.value = false; buyForm.reset(); },
});
const submitSell = () => sellForm.post(route('banking.crypto.sell'), {
  onSuccess: () => { showSell.value = false; sellForm.reset(); },
});

// Live price refresh
let priceInterval;
async function refreshPrices() {
  pricesRefreshing.value = true;
  try {
    const res = await fetch(route('banking.crypto.prices'));
    livePrices.value = await res.json();
  } catch (e) { /* silent */ }
  pricesRefreshing.value = false;
}

onMounted(() => {
  refreshPrices();
  priceInterval = setInterval(refreshPrices, 15000);
});
onUnmounted(() => clearInterval(priceInterval));

const fmt = (a) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
const fmtCrypto = (a) => Number(a).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 8 });
</script>

<template>
  <Head title="العملات الرقمية - Crypto" />
  <AuthenticatedLayout>
    <div class="bd-root">
      <!-- Sidebar -->
      <aside class="bd-sidebar">
        <div class="bd-logo"><div class="text-lg font-black">SDB</div><div class="text-[10px] text-gray-500">Crypto</div></div>
        <nav class="bd-nav">
          <template v-for="n in navItems" :key="n.route">
            <Link :href="route(n.route)" :class="['bd-nav-item', n.active ? 'bd-nav-active' : '']">
              <span>{{ n.icon }}</span><span class="flex-1">{{ n.label }}</span>
            </Link>
          </template>
        </nav>
      </aside>

      <!-- Main -->
      <main class="bd-main">
        <header class="bd-topbar">
          <div>
            <h1 class="text-lg font-bold text-white">🪙 العملات الرقمية</h1>
            <p class="text-xs text-gray-500">اشترِ وبِع العملات الرقمية مباشرة من حسابك</p>
          </div>
          <div class="flex items-center gap-3">
            <button @click="refreshPrices" class="cr-refresh-btn" :class="{ 'animate-spin': pricesRefreshing }">🔄</button>
            <div class="text-xs text-gray-500">الأسعار تُحدَّث كل 15 ثانية</div>
          </div>
        </header>

        <div v-if="flash.success" class="mx-6 mt-4"><div class="bg-emerald-500/10 border border-emerald-500/20 rounded-xl px-4 py-3 text-emerald-400 text-sm">✓ {{ flash.success }}</div></div>
        <div v-if="buyForm.errors.eur_amount || sellForm.errors.crypto_amount" class="mx-6 mt-4"><div class="bg-red-500/10 border border-red-500/20 rounded-xl px-4 py-3 text-red-400 text-sm">⚠ {{ buyForm.errors.eur_amount || sellForm.errors.crypto_amount }}</div></div>

        <div class="bd-content">
          <!-- Portfolio Summary -->
          <div class="grid grid-cols-3 gap-4">
            <div class="cr-summary-card">
              <div class="text-xs text-gray-500 mb-1">رصيدك من EUR</div>
              <div class="text-2xl font-black text-white">€{{ fmt(eurBalance) }}</div>
              <div class="text-[10px] text-gray-600 mt-1">متاح للشراء</div>
            </div>
            <div class="cr-summary-card">
              <div class="text-xs text-gray-500 mb-1">قيمة الكريبتو</div>
              <div class="text-2xl font-black text-purple-400">€{{ fmt(totalCryptoValueEur) }}</div>
              <div class="text-[10px] text-gray-600 mt-1">{{ cryptoBalances.filter(c => c.balance > 0).length }} عملات</div>
            </div>
            <div class="cr-summary-card">
              <div class="text-xs text-gray-500 mb-1">العمولة</div>
              <div class="text-2xl font-black text-amber-400">{{ spreadPercent }}%</div>
              <div class="text-[10px] text-gray-600 mt-1">على كل عملية شراء/بيع</div>
            </div>
          </div>

          <!-- Crypto Cards -->
          <h2 class="text-sm font-bold text-white">📊 الأسعار والأرصدة</h2>
          <div class="grid grid-cols-2 gap-4">
            <div v-for="c in cryptoBalances" :key="c.code" class="cr-coin-card">
              <div class="flex items-center gap-3 mb-4">
                <div class="cr-coin-icon" :style="{ background: (cryptoMeta[c.code]?.color || '#666') + '20', color: cryptoMeta[c.code]?.color }">
                  {{ cryptoMeta[c.code]?.icon || '●' }}
                </div>
                <div class="flex-1">
                  <div class="font-bold text-white text-sm">{{ c.name }} <span class="text-gray-500 text-xs">{{ c.code }}</span></div>
                  <div class="text-xs text-gray-500">{{ c.name_ar }}</div>
                </div>
                <div class="text-left">
                  <div class="font-black text-white text-sm">€{{ fmt(getPrice(c.code)) }}</div>
                  <div class="text-xs font-semibold" :class="getChange(c.code) >= 0 ? 'text-emerald-400' : 'text-red-400'">
                    {{ getChange(c.code) >= 0 ? '+' : '' }}{{ getChange(c.code) }}%
                  </div>
                </div>
              </div>

              <!-- Balance -->
              <div class="cr-balance-row">
                <div>
                  <div class="text-[10px] text-gray-600">رصيدك</div>
                  <div class="text-sm font-bold text-white">{{ fmtCrypto(c.balance) }} {{ c.code }}</div>
                </div>
                <div class="text-left">
                  <div class="text-[10px] text-gray-600">القيمة</div>
                  <div class="text-sm font-bold text-purple-400">€{{ fmt(c.balance * getPrice(c.code)) }}</div>
                </div>
              </div>

              <!-- Actions -->
              <div class="flex gap-2 mt-3">
                <button @click="openBuy(c)" class="cr-btn-buy">اشترِ</button>
                <button @click="openSell(c)" class="cr-btn-sell" :disabled="c.balance <= 0">بِع</button>
              </div>
            </div>
          </div>

          <!-- Recent Trades -->
          <div class="cr-trades-card">
            <div class="flex justify-between items-center px-5 py-3 border-b border-white/5">
              <h3 class="text-sm font-bold text-white">📋 آخر عمليات الكريبتو</h3>
            </div>
            <div class="divide-y divide-white/5">
              <div v-for="t in recentTrades" :key="t.id" class="px-5 py-3 flex items-center justify-between hover:bg-white/[0.02] transition">
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-lg flex items-center justify-center text-sm"
                    :class="t.metadata?.trade_type === 'crypto_buy' ? 'bg-emerald-500/20 text-emerald-400' : 'bg-red-500/20 text-red-400'">
                    {{ t.metadata?.trade_type === 'crypto_buy' ? '📈' : '📉' }}
                  </div>
                  <div>
                    <div class="text-sm font-medium text-white">{{ t.metadata?.trade_type === 'crypto_buy' ? 'شراء' : 'بيع' }} {{ t.metadata?.crypto_code }}</div>
                    <div class="text-[10px] text-gray-600">{{ t.reference_number }} · {{ new Date(t.created_at).toLocaleDateString('ar-EG',{day:'numeric',month:'short',hour:'2-digit',minute:'2-digit'}) }}</div>
                  </div>
                </div>
                <div class="text-right">
                  <div class="text-sm font-bold" :class="t.metadata?.trade_type === 'crypto_buy' ? 'text-emerald-400' : 'text-red-400'">
                    {{ t.metadata?.trade_type === 'crypto_buy' ? '-' : '+' }}€{{ fmt(t.amount) }}
                  </div>
                  <div class="text-[10px] text-gray-500">{{ fmtCrypto(t.original_amount) }} {{ t.metadata?.crypto_code }}</div>
                </div>
              </div>
              <div v-if="!recentTrades?.length" class="px-6 py-10 text-center text-gray-600">لا توجد عمليات تداول بعد — ابدأ بشراء عملتك الأولى!</div>
            </div>
          </div>
        </div>
      </main>
    </div>

    <!-- ======= BUY MODAL ======= -->
    <Teleport to="body">
      <div v-if="showBuy" class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm" @click.self="showBuy = false">
        <div class="bg-[#0f1629] border border-white/10 rounded-2xl w-full max-w-lg p-6 shadow-2xl">
          <div class="flex items-center gap-3 mb-6">
            <div class="cr-coin-icon" :style="{ background: (cryptoMeta[selectedCrypto?.code]?.color || '#666') + '20', color: cryptoMeta[selectedCrypto?.code]?.color }">
              {{ cryptoMeta[selectedCrypto?.code]?.icon }}
            </div>
            <div>
              <h3 class="text-xl font-bold text-white">شراء {{ selectedCrypto?.name }}</h3>
              <p class="text-gray-400 text-xs">Buy {{ selectedCrypto?.code }} with EUR</p>
            </div>
          </div>

          <form @submit.prevent="submitBuy" class="space-y-5">
            <div>
              <label class="block text-sm text-gray-400 mb-1.5">المبلغ بالـ EUR</label>
              <input v-model="buyForm.eur_amount" type="number" step="0.01" min="10" placeholder="100.00" class="bd-input text-xl font-bold" />
              <div class="text-xs text-gray-600 mt-1">الحد الأدنى €10</div>
            </div>

            <!-- Quick amounts -->
            <div class="flex gap-2">
              <button v-for="a in [50, 100, 250, 500, 1000]" :key="a" type="button" @click="buyForm.eur_amount = a"
                class="flex-1 py-2 text-xs font-bold rounded-lg border transition"
                :class="Number(buyForm.eur_amount) === a ? 'border-emerald-500 bg-emerald-500/10 text-emerald-400' : 'border-white/10 text-gray-400 hover:text-white'">
                €{{ a }}
              </button>
            </div>

            <!-- Preview -->
            <div v-if="buyPreview" class="bg-white/[0.03] border border-white/5 rounded-xl p-4 space-y-2">
              <div class="flex justify-between text-sm"><span class="text-gray-400">ستحصل على</span><span class="text-white font-bold">{{ buyPreview.cryptoAmount }} {{ buyForm.crypto_code }}</span></div>
              <div class="flex justify-between text-sm"><span class="text-gray-400">سعر الشراء</span><span class="text-white">€{{ buyPreview.pricePerUnit }}</span></div>
              <div class="flex justify-between text-sm"><span class="text-gray-400">العمولة ({{ spreadPercent }}%)</span><span class="text-amber-400">€{{ buyPreview.fee }}</span></div>
            </div>

            <div class="text-xs text-gray-600 flex items-center gap-1">💡 رصيدك: <span class="text-emerald-400 font-semibold">€{{ fmt(eurBalance) }}</span></div>

            <div class="flex gap-3">
              <button type="submit" :disabled="buyForm.processing" class="flex-1 bg-emerald-600 hover:bg-emerald-500 py-3.5 rounded-xl font-bold text-sm text-white disabled:opacity-50 transition">
                {{ buyForm.processing ? 'جاري الشراء...' : `شراء ${selectedCrypto?.code}` }}
              </button>
              <button type="button" @click="showBuy = false" class="flex-1 bg-white/5 hover:bg-white/10 py-3.5 rounded-xl text-sm text-white transition">إلغاء</button>
            </div>
          </form>
        </div>
      </div>
    </Teleport>

    <!-- ======= SELL MODAL ======= -->
    <Teleport to="body">
      <div v-if="showSell" class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm" @click.self="showSell = false">
        <div class="bg-[#0f1629] border border-white/10 rounded-2xl w-full max-w-lg p-6 shadow-2xl">
          <div class="flex items-center gap-3 mb-6">
            <div class="cr-coin-icon" :style="{ background: (cryptoMeta[selectedCrypto?.code]?.color || '#666') + '20', color: cryptoMeta[selectedCrypto?.code]?.color }">
              {{ cryptoMeta[selectedCrypto?.code]?.icon }}
            </div>
            <div>
              <h3 class="text-xl font-bold text-white">بيع {{ selectedCrypto?.name }}</h3>
              <p class="text-gray-400 text-xs">Sell {{ selectedCrypto?.code }} for EUR</p>
            </div>
          </div>

          <form @submit.prevent="submitSell" class="space-y-5">
            <div>
              <label class="block text-sm text-gray-400 mb-1.5">الكمية</label>
              <input v-model="sellForm.crypto_amount" type="number" step="0.00000001" min="0.00000001" placeholder="0.001" class="bd-input text-xl font-bold" />
              <div class="text-xs text-gray-600 mt-1">رصيدك: <span class="text-purple-400 font-semibold">{{ fmtCrypto(selectedCrypto?.balance || 0) }} {{ selectedCrypto?.code }}</span></div>
            </div>

            <!-- Quick sell percentages -->
            <div class="flex gap-2">
              <button v-for="p in [25, 50, 75, 100]" :key="p" type="button"
                @click="sellForm.crypto_amount = ((selectedCrypto?.balance || 0) * p / 100).toFixed(8)"
                class="flex-1 py-2 text-xs font-bold rounded-lg border border-white/10 text-gray-400 hover:text-white hover:border-red-500/30 transition">
                {{ p }}%
              </button>
            </div>

            <!-- Preview -->
            <div v-if="sellPreview" class="bg-white/[0.03] border border-white/5 rounded-xl p-4 space-y-2">
              <div class="flex justify-between text-sm"><span class="text-gray-400">ستحصل على</span><span class="text-white font-bold">€{{ sellPreview.eurAmount }}</span></div>
              <div class="flex justify-between text-sm"><span class="text-gray-400">سعر البيع</span><span class="text-white">€{{ sellPreview.pricePerUnit }}</span></div>
              <div class="flex justify-between text-sm"><span class="text-gray-400">العمولة ({{ spreadPercent }}%)</span><span class="text-amber-400">€{{ sellPreview.fee }}</span></div>
            </div>

            <div class="flex gap-3">
              <button type="submit" :disabled="sellForm.processing" class="flex-1 bg-red-600 hover:bg-red-500 py-3.5 rounded-xl font-bold text-sm text-white disabled:opacity-50 transition">
                {{ sellForm.processing ? 'جاري البيع...' : `بيع ${selectedCrypto?.code}` }}
              </button>
              <button type="button" @click="showSell = false" class="flex-1 bg-white/5 hover:bg-white/10 py-3.5 rounded-xl text-sm text-white transition">إلغاء</button>
            </div>
          </form>
        </div>
      </div>
    </Teleport>
  </AuthenticatedLayout>
</template>

<style scoped>
.bd-root{display:flex;min-height:100vh;background:#060b18;color:#fff}
.bd-sidebar{width:200px;background:#0a0f1f;border-left:1px solid rgba(255,255,255,0.05);flex-shrink:0;display:flex;flex-direction:column}
.bd-logo{padding:16px;border-bottom:1px solid rgba(255,255,255,0.05);text-align:center}
.bd-nav{padding:10px 8px;flex:1;display:flex;flex-direction:column;gap:2px}
.bd-nav-item{display:flex;align-items:center;gap:8px;padding:9px 12px;border-radius:10px;font-size:12px;color:rgba(255,255,255,0.4);text-decoration:none;font-weight:500;transition:all .2s}.bd-nav-item:hover{background:rgba(255,255,255,0.03);color:rgba(255,255,255,0.7)}
.bd-nav-active{background:rgba(168,85,247,0.15)!important;color:#a855f7!important;font-weight:700}
.bd-main{flex:1;display:flex;flex-direction:column;overflow-y:auto}
.bd-topbar{display:flex;justify-content:space-between;align-items:center;padding:14px 24px;border-bottom:1px solid rgba(255,255,255,0.05)}
.bd-content{padding:20px 24px;display:flex;flex-direction:column;gap:16px}
.bd-input{width:100%;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:12px;padding:10px 14px;color:#fff;outline:none;font-size:13px}.bd-input:focus{border-color:#a855f7}.bd-input::placeholder{color:rgba(255,255,255,0.2)}

/* Summary cards */
.cr-summary-card{background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.05);border-radius:14px;padding:16px}

/* Coin cards */
.cr-coin-card{background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.06);border-radius:16px;padding:16px;transition:all .2s}
.cr-coin-card:hover{border-color:rgba(168,85,247,0.2);box-shadow:0 4px 20px rgba(168,85,247,0.05)}
.cr-coin-icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:bold;flex-shrink:0}
.cr-balance-row{display:flex;justify-content:space-between;align-items:center;background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.04);border-radius:10px;padding:10px 12px}

/* Buttons */
.cr-btn-buy{flex:1;padding:8px;border-radius:10px;font-size:12px;font-weight:700;background:linear-gradient(135deg,#10b981,#059669);color:#fff;border:none;cursor:pointer;transition:all .2s}.cr-btn-buy:hover{filter:brightness(1.1)}
.cr-btn-sell{flex:1;padding:8px;border-radius:10px;font-size:12px;font-weight:700;background:rgba(239,68,68,0.1);color:#ef4444;border:1px solid rgba(239,68,68,0.2);cursor:pointer;transition:all .2s}.cr-btn-sell:hover{background:rgba(239,68,68,0.2)}.cr-btn-sell:disabled{opacity:0.3;cursor:not-allowed}

/* Trades card */
.cr-trades-card{background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.05);border-radius:16px;overflow:hidden}

/* Refresh */
.cr-refresh-btn{padding:6px 10px;border:1px solid rgba(255,255,255,0.05);border-radius:10px;font-size:14px;cursor:pointer;background:transparent;transition:all .2s}.cr-refresh-btn:hover{background:rgba(255,255,255,0.05)}
</style>
