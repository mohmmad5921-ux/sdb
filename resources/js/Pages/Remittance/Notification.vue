<script setup>
import { Head } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';
const p = defineProps({ remittance: Object });
const r = computed(() => p.remittance);
const f = n => Number(n||0).toLocaleString('en');

const isExpired = computed(() => r.value.status === 'expired' || (r.value.expires_at && new Date(r.value.expires_at) < new Date()));
const isCollected = computed(() => r.value.status === 'collected');
const isActive = computed(() => r.value.status === 'ready' && !isExpired.value);

const statusText = computed(() => {
  if (isCollected.value) return { ar: 'تم الاستلام', en: 'Collected', color: '#22c55e', bg: 'rgba(34,197,94,.12)' };
  if (isExpired.value) return { ar: 'منتهية الصلاحية', en: 'Expired', color: '#ef4444', bg: 'rgba(239,68,68,.12)' };
  return { ar: 'جاهزة للاستلام', en: 'Ready for Pickup', color: '#10b981', bg: 'rgba(16,185,129,.12)' };
});

const timeLeft = ref('');
const updateTimer = () => {
  if (!r.value.expires_at || isCollected.value || isExpired.value) return;
  const diff = new Date(r.value.expires_at) - new Date();
  if (diff <= 0) { timeLeft.value = 'انتهت الصلاحية'; return; }
  const d = Math.floor(diff / 86400000);
  const h = Math.floor((diff % 86400000) / 3600000);
  const m = Math.floor((diff % 3600000) / 60000);
  timeLeft.value = `${d}d ${h}h ${m}m`;
};

const qrUrl = computed(() => `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${encodeURIComponent(window.location.href)}`);

const shareWhatsApp = () => {
  const msg = `🏦 SDB Bank — إشعار حوالة\n\n💰 المبلغ: €${f(r.value.amount)}\n📥 المستلم: ${r.value.recipient_name}\n📍 الوكيل: ${r.value.agent_name_ar}\n📍 ${r.value.governorate_ar} — ${r.value.district_ar}\n🔢 رقم الإشعار: ${r.value.notification_code}\n\n🔗 رابط الإشعار:\n${window.location.href}\n\n✅ يرجى إبراز هذا الإشعار أو رقم الكود عند الوكيل لاستلام الحوالة`;
  window.open(`https://wa.me/?text=${encodeURIComponent(msg)}`, '_blank');
};

onMounted(() => { updateTimer(); setInterval(updateTimer, 60000); });
</script>

<template>
<Head :title="'إشعار حوالة #' + r.notification_code + ' — SDB Bank'" />
<div class="rn">
  <!-- Background -->
  <div class="rn-bg">
    <div class="rn-glow rn-glow-1"></div>
    <div class="rn-glow rn-glow-2"></div>
  </div>

  <div class="rn-container">
    <!-- Header -->
    <div class="rn-header">
      <div class="rn-logo">
        <div class="rn-logo-icon">SDB</div>
        <div class="rn-logo-text">
          <div class="rn-logo-name">SDB Bank</div>
          <div class="rn-logo-sub">Secure Remittance</div>
        </div>
      </div>
      <div class="rn-status" :style="{background: statusText.bg, color: statusText.color}">
        {{ statusText.ar }} / {{ statusText.en }}
      </div>
    </div>

    <!-- SDB Secure Badge -->
    <div class="rn-badge-section">
      <div class="rn-secure-badge">
        <div class="rn-badge-ring">
          <div class="rn-badge-inner">
            <div class="rn-badge-text">SDB</div>
            <div class="rn-badge-sub">SECURE</div>
          </div>
        </div>
      </div>
      <div class="rn-badge-label">SDB Verified Transfer</div>
    </div>

    <!-- Amount Card -->
    <div class="rn-amount-card">
      <div class="rn-amount-label">المبلغ المرسل / Amount Sent</div>
      <div class="rn-amount">€{{ f(r.amount) }}</div>
      <div class="rn-exchange">
        <span class="rn-ex-arrow">→</span>
        <span class="rn-ex-amount">{{ f(r.receive_amount) }} {{ r.receive_currency }}</span>
      </div>
      <div class="rn-rate">سعر الصرف: {{ f(r.exchange_rate) }} SYP/EUR · رسوم: €{{ r.fee }}</div>
    </div>

    <!-- Details Grid -->
    <div class="rn-details">
      <div class="rn-detail-card">
        <div class="rn-dc-ic">👤</div>
        <div class="rn-dc-label">المرسل / Sender</div>
        <div class="rn-dc-value">{{ r.sender_name }}</div>
      </div>
      <div class="rn-detail-card">
        <div class="rn-dc-ic">📥</div>
        <div class="rn-dc-label">المستلم / Recipient</div>
        <div class="rn-dc-value">{{ r.recipient_name }}</div>
        <div class="rn-dc-sub">{{ r.recipient_phone }}</div>
      </div>
      <div class="rn-detail-card">
        <div class="rn-dc-ic">🏢</div>
        <div class="rn-dc-label">الوكيل / Agent</div>
        <div class="rn-dc-value">{{ r.agent_name_ar }}</div>
        <div class="rn-dc-sub">{{ r.agent_address }}</div>
      </div>
      <div class="rn-detail-card">
        <div class="rn-dc-ic">📍</div>
        <div class="rn-dc-label">الموقع / Location</div>
        <div class="rn-dc-value">{{ r.governorate_ar }} — {{ r.district_ar }}</div>
        <div class="rn-dc-sub">{{ r.governorate_en }} — {{ r.district_en }}</div>
      </div>
    </div>

    <!-- QR + Code Section -->
    <div class="rn-code-section" v-if="isActive">
      <div class="rn-qr-wrap">
        <img :src="qrUrl" alt="QR Code" class="rn-qr" />
        <div class="rn-qr-label">QR Code</div>
      </div>
      <div class="rn-code-wrap">
        <div class="rn-code-label">رقم الإشعار / Notification Code</div>
        <div class="rn-code">{{ r.notification_code }}</div>
        <div class="rn-code-warn">⚠️ أظهر هذا الرقم للوكيل عند الاستلام</div>
        <div class="rn-code-warn-en">Show this code to the agent upon pickup</div>
      </div>
    </div>

    <!-- Collected/Expired -->
    <div v-if="isCollected" class="rn-collected">
      <div class="rn-collected-ic">✅</div>
      <div class="rn-collected-text">تم استلام الحوالة بنجاح</div>
      <div class="rn-collected-date">{{ r.collected_at ? new Date(r.collected_at).toLocaleString('ar') : '' }}</div>
    </div>

    <div v-if="isExpired && !isCollected" class="rn-expired">
      <div class="rn-expired-ic">⏰</div>
      <div class="rn-expired-text">انتهت صلاحية هذه الحوالة</div>
    </div>

    <!-- Timer -->
    <div v-if="isActive && timeLeft" class="rn-timer">
      <span>⏱️</span> صالحة لمدة: {{ timeLeft }}
    </div>

    <!-- Actions -->
    <div class="rn-actions" v-if="isActive">
      <button class="rn-wa-btn" @click="shareWhatsApp">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
        شارك عبر واتساب / Share via WhatsApp
      </button>
    </div>

    <!-- Footer -->
    <div class="rn-footer">
      <div class="rn-footer-logo">SDB Bank</div>
      <div class="rn-footer-text">Syria's First Digital Bank · أول بنك إلكتروني سوري</div>
      <div class="rn-footer-text">sdb-bank.com</div>
    </div>
  </div>
</div>
</template>

<style scoped>
*{box-sizing:border-box;margin:0;padding:0}
.rn{min-height:100vh;background:#0a0f1c;font-family:'Inter','Segoe UI',sans-serif;display:flex;justify-content:center;padding:20px;position:relative;overflow:hidden}
.rn-bg{position:fixed;inset:0;pointer-events:none}
.rn-glow{position:absolute;border-radius:50%;filter:blur(80px)}
.rn-glow-1{width:300px;height:300px;background:rgba(16,185,129,.12);top:-50px;right:-50px}
.rn-glow-2{width:250px;height:250px;background:rgba(59,130,246,.08);bottom:10%;left:-30px}
.rn-container{max-width:480px;width:100%;position:relative;z-index:1}

.rn-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:24px}
.rn-logo{display:flex;align-items:center;gap:10px}
.rn-logo-icon{width:42px;height:42px;background:linear-gradient(135deg,#10b981,#059669);border-radius:12px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:900;font-size:13px;letter-spacing:1px}
.rn-logo-name{font-size:16px;font-weight:800;color:#fff}
.rn-logo-sub{font-size:10px;color:rgba(255,255,255,.4);font-weight:600}
.rn-status{font-size:11px;font-weight:700;padding:6px 14px;border-radius:20px}

.rn-badge-section{text-align:center;margin-bottom:24px}
.rn-secure-badge{display:inline-block;margin-bottom:8px}
.rn-badge-ring{width:100px;height:100px;border-radius:50%;background:linear-gradient(135deg,rgba(16,185,129,.3),rgba(6,95,70,.5));display:flex;align-items:center;justify-content:center;animation:badgePulse 3s ease infinite;border:2px solid rgba(16,185,129,.3)}
.rn-badge-inner{text-align:center}
.rn-badge-text{font-size:22px;font-weight:900;color:#10b981;letter-spacing:2px}
.rn-badge-sub{font-size:9px;font-weight:700;color:rgba(16,185,129,.7);letter-spacing:3px}
@keyframes badgePulse{0%,100%{box-shadow:0 0 0 0 rgba(16,185,129,.2)}50%{box-shadow:0 0 0 12px rgba(16,185,129,0)}}
.rn-badge-label{font-size:11px;color:rgba(255,255,255,.35);font-weight:600;letter-spacing:1px}

.rn-amount-card{background:linear-gradient(135deg,#0d2847,#132d50);border:1px solid rgba(16,185,129,.15);border-radius:20px;padding:28px;text-align:center;margin-bottom:16px}
.rn-amount-label{font-size:12px;color:rgba(255,255,255,.4);font-weight:600;margin-bottom:6px}
.rn-amount{font-size:44px;font-weight:900;color:#fff;margin-bottom:8px}
.rn-exchange{margin-bottom:8px}
.rn-ex-arrow{color:#10b981;font-size:14px;margin-left:6px}
.rn-ex-amount{font-size:18px;font-weight:800;color:#10b981}
.rn-rate{font-size:11px;color:rgba(255,255,255,.3)}

.rn-details{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:16px}
.rn-detail-card{background:rgba(255,255,255,.04);border:1px solid rgba(255,255,255,.06);border-radius:14px;padding:16px}
.rn-dc-ic{font-size:20px;margin-bottom:6px}
.rn-dc-label{font-size:10px;color:rgba(255,255,255,.35);font-weight:600;margin-bottom:4px}
.rn-dc-value{font-size:14px;font-weight:700;color:#fff}
.rn-dc-sub{font-size:11px;color:rgba(255,255,255,.35);margin-top:2px}

.rn-code-section{display:flex;gap:16px;align-items:center;background:rgba(255,255,255,.04);border:1px solid rgba(16,185,129,.15);border-radius:18px;padding:20px;margin-bottom:16px}
.rn-qr-wrap{flex-shrink:0;text-align:center}
.rn-qr{width:120px;height:120px;border-radius:10px;background:#fff;padding:6px}
.rn-qr-label{font-size:10px;color:rgba(255,255,255,.3);margin-top:4px}
.rn-code-wrap{flex:1;text-align:center}
.rn-code-label{font-size:11px;color:rgba(255,255,255,.4);margin-bottom:8px}
.rn-code{font-size:32px;font-weight:900;color:#10b981;letter-spacing:4px;font-family:'SF Mono','Fira Code',monospace;background:rgba(16,185,129,.08);border:2px dashed rgba(16,185,129,.2);border-radius:12px;padding:12px}
.rn-code-warn{font-size:11px;color:#f59e0b;margin-top:8px;font-weight:600}
.rn-code-warn-en{font-size:10px;color:rgba(255,255,255,.25)}

.rn-collected{text-align:center;background:rgba(34,197,94,.08);border:1px solid rgba(34,197,94,.2);border-radius:16px;padding:24px;margin-bottom:16px}
.rn-collected-ic{font-size:40px;margin-bottom:8px}
.rn-collected-text{font-size:18px;font-weight:800;color:#22c55e}
.rn-collected-date{font-size:12px;color:rgba(255,255,255,.3);margin-top:4px}

.rn-expired{text-align:center;background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);border-radius:16px;padding:24px;margin-bottom:16px}
.rn-expired-ic{font-size:40px;margin-bottom:8px}
.rn-expired-text{font-size:18px;font-weight:800;color:#ef4444}

.rn-timer{text-align:center;font-size:13px;color:rgba(255,255,255,.4);margin-bottom:16px;font-weight:600}

.rn-actions{margin-bottom:20px}
.rn-wa-btn{width:100%;display:flex;align-items:center;justify-content:center;gap:10px;padding:14px;border-radius:14px;background:#25d366;color:#fff;font-size:15px;font-weight:700;border:none;cursor:pointer;transition:all .2s}
.rn-wa-btn:hover{background:#1ebe5d;transform:translateY(-1px);box-shadow:0 6px 20px rgba(37,211,102,.3)}

.rn-footer{text-align:center;padding:20px 0;border-top:1px solid rgba(255,255,255,.05)}
.rn-footer-logo{font-size:18px;font-weight:900;color:rgba(255,255,255,.15);margin-bottom:4px}
.rn-footer-text{font-size:10px;color:rgba(255,255,255,.15)}

@media(max-width:500px){.rn-details{grid-template-columns:1fr}.rn-code-section{flex-direction:column}.rn-amount{font-size:36px}}
</style>
