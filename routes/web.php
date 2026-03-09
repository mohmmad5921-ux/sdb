<?php

use App\Http\Controllers\Admin\DashboardController as AdminDashboard;
use App\Http\Controllers\Admin\UserController as AdminUsers;
use App\Http\Controllers\Admin\TransactionController as AdminTransactions;
use App\Http\Controllers\Admin\MerchantController as AdminMerchants;
use App\Http\Controllers\Admin\CurrencyController as AdminCurrencies;
use App\Http\Controllers\Admin\SystemController as AdminSystem;
use App\Http\Controllers\Admin\KycReviewController;
use App\Http\Controllers\Admin\SupportAdminController;
use App\Http\Controllers\Admin\ReportsController as AdminReports;
use App\Http\Controllers\Admin\RiskController as AdminRisk;
use App\Http\Controllers\Banking\AnalyticsController;
use App\Http\Controllers\Banking\BankingController;
use App\Http\Controllers\Banking\BeneficiaryController;
use App\Http\Controllers\Banking\CardDetailsController;
use App\Http\Controllers\Banking\CryptoController;
use App\Http\Controllers\Banking\KycController;
use App\Http\Controllers\Banking\NotificationController;
use App\Http\Controllers\Banking\ReferralController;
use App\Http\Controllers\Banking\SecurityController;
use App\Http\Controllers\Banking\SupportController;
use App\Http\Controllers\Banking\TransactionHistoryController;
use App\Http\Controllers\CheckoutController;
use App\Http\Controllers\MoonPayController;
use App\Http\Controllers\PreregistrationController;
use App\Http\Controllers\ProfileController;
use App\Http\Middleware\AdminMiddleware;
use App\Http\Middleware\KycRequiredMiddleware;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

// Landing Page
Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
    ]);
});

// Legal & Info Pages
Route::get('/terms', fn() => Inertia::render('Legal/Terms'))->name('terms');
Route::get('/privacy', fn() => Inertia::render('Legal/Privacy'))->name('privacy');
Route::get('/about', fn() => Inertia::render('Legal/About'))->name('about');
Route::get('/faq', fn() => Inertia::render('Legal/Faq'))->name('faq');
Route::get('/support', fn() => Inertia::render('Legal/Support'))->name('support.public');
Route::get('/currencies', fn() => Inertia::render('Legal/Currencies'))->name('currencies.public');
Route::get('/cards-info', fn() => Inertia::render('Legal/CardsInfo'))->name('cards.info');
Route::get('/transfers-info', fn() => Inertia::render('Legal/TransfersInfo'))->name('transfers.info');
Route::get('/salary', fn() => Inertia::render('Legal/Salary'))->name('salary');
Route::get('/digital-id', fn() => Inertia::render('Legal/DigitalID'))->name('digital-id');
Route::get('/wallet-guide', fn() => Inertia::render('Legal/WalletGuide'))->name('wallet-guide');
Route::get('/personal', fn() => Inertia::render('Legal/Personal'))->name('personal');
Route::get('/business', fn() => Inertia::render('Legal/Business'))->name('business');
Route::get('/plans', fn() => Inertia::render('Legal/Plans'))->name('plans');
Route::get('/security', fn() => Inertia::render('Legal/Security'))->name('security');
Route::get('/app', fn() => Inertia::render('Legal/AppDownload'))->name('app');
Route::get('/exchange-rates', fn() => Inertia::render('Legal/ExchangeRates'))->name('exchange-rates');
Route::get('/compliance', fn() => Inertia::render('Legal/Compliance'))->name('compliance');
Route::get('/bills', fn() => Inertia::render('Legal/Bills'))->name('bills');
Route::get('/cards/standard', fn() => Inertia::render('Legal/CardStandard'))->name('cards.standard');
Route::get('/cards/plus', fn() => Inertia::render('Legal/CardPlus'))->name('cards.plus');
Route::get('/cards/premium', fn() => Inertia::render('Legal/CardPremium'))->name('cards.premium');
Route::get('/cards/elite', fn() => Inertia::render('Legal/CardElite'))->name('cards.elite');
Route::get('/family', fn() => Inertia::render('Legal/Family'))->name('family');
Route::get('/savings', fn() => Inertia::render('Legal/Savings'))->name('savings');
Route::get('/analytics', fn() => Inertia::render('Legal/Analytics'))->name('analytics');
Route::get('/careers', fn() => Inertia::render('Legal/Careers'))->name('careers');
Route::get('/blog', fn() => Inertia::render('Legal/Blog'))->name('blog');
Route::get('/partners', fn() => Inertia::render('Legal/Partners'))->name('partners');
Route::get('/press', fn() => Inertia::render('Legal/Press'))->name('press');
Route::get('/report-fraud', fn() => Inertia::render('Legal/ReportFraud'))->name('report-fraud');
Route::get('/syrian-lira', fn() => Inertia::render('Legal/SyrianLira'))->name('syrian-lira');
Route::get('/crypto', fn() => Inertia::render('Legal/CryptoInfo'))->name('crypto-info');
Route::get('/invite', fn() => Inertia::render('Legal/Referral'))->name('referral.public');
Route::get('/referral', fn() => Inertia::render('Legal/Referral'))->name('referral');
Route::get('/compare', fn() => Inertia::render('Legal/Compare'))->name('compare');
Route::get('/status', fn() => Inertia::render('Legal/Status'))->name('status');

// Waitlist (hero email form)
Route::post('/waitlist', [\App\Http\Controllers\WaitlistController::class, 'store'])->middleware('throttle:10,1');

// Pre-registration
Route::get('/preregister', [PreregistrationController::class, 'show'])->name('preregister');
Route::post('/preregister', [PreregistrationController::class, 'store'])->middleware('throttle:5,1');
// Payment Gateway Checkout
Route::get('/checkout/{sessionId}', [CheckoutController::class, 'show'])->name('checkout.pay');
Route::post('/checkout/{sessionId}/pay', [CheckoutController::class, 'pay'])->name('checkout.process')->middleware('auth');

// Customer Routes (auth required)
Route::middleware(['auth', 'verified'])->group(function () {
    // Always accessible (no KYC required)
    Route::get('/kyc', [KycController::class, 'index'])->name('banking.kyc');
    Route::post('/kyc/upload', [KycController::class, 'upload'])->name('banking.kyc.upload');
    Route::delete('/kyc/{document}', [KycController::class, 'delete'])->name('banking.kyc.delete');

    Route::get('/notifications', [NotificationController::class, 'index'])->name('banking.notifications');
    Route::post('/notifications/{notification}/read', [NotificationController::class, 'markRead'])->name('banking.notifications.read');
    Route::post('/notifications/read-all', [NotificationController::class, 'markAllRead'])->name('banking.notifications.read-all');

    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    // MoonPay (Crypto Purchases)
    Route::post('/moonpay/sign', [MoonPayController::class, 'signUrl'])->name('moonpay.sign');

    // Banking features — KYC REQUIRED
    Route::middleware([KycRequiredMiddleware::class])->group(
        function () {
            Route::get(
                '/dashboard',
                function () {
                    if (auth()->user()->isAdmin())
                        return redirect()->route('admin.dashboard');
                    return app(BankingController::class)->dashboard();
                }
            )->name('dashboard');

            // Core Banking
            Route::post('/banking/transfer', [BankingController::class, 'transfer'])->name('banking.transfer');
            Route::post('/banking/exchange', [BankingController::class, 'exchange'])->name('banking.exchange');
            Route::post('/banking/cards/issue', [BankingController::class, 'issueCard'])->name('banking.cards.issue');
            Route::post('/banking/cards/{card}/toggle-freeze', [BankingController::class, 'toggleCardFreeze'])->name('banking.cards.toggle-freeze');
            Route::post('/banking/deposit', [BankingController::class, 'deposit'])->name('banking.deposit');

            // Transfer System (lookup + QR)
            Route::post('/banking/transfer/lookup', [\App\Http\Controllers\TransferController::class, 'lookup'])->name('banking.transfer.lookup');
            Route::post('/banking/transfer/qr-lookup', [\App\Http\Controllers\TransferController::class, 'qrLookup'])->name('banking.transfer.qr-lookup');
            Route::post('/banking/transfer/execute', [\App\Http\Controllers\TransferController::class, 'transfer'])->name('banking.transfer.execute');
            Route::get('/banking/transfer/my-accounts', [\App\Http\Controllers\TransferController::class, 'myAccounts'])->name('banking.transfer.accounts');

            // Beneficiaries
            Route::get('/beneficiaries', [BeneficiaryController::class, 'index'])->name('banking.beneficiaries');
            Route::post('/beneficiaries', [BeneficiaryController::class, 'store'])->name('banking.beneficiaries.store');
            Route::patch('/beneficiaries/{id}', [BeneficiaryController::class, 'update'])->name('banking.beneficiaries.update');
            Route::delete('/beneficiaries/{id}', [BeneficiaryController::class, 'destroy'])->name('banking.beneficiaries.destroy');
            Route::post('/beneficiaries/{id}/favorite', [BeneficiaryController::class, 'toggleFavorite'])->name('banking.beneficiaries.favorite');

            // Transaction History
            Route::get('/transactions', [TransactionHistoryController::class, 'index'])->name('banking.transactions');
            Route::get('/transactions/export', [TransactionHistoryController::class, 'exportCsv'])->name('banking.transactions.export');

            // Analytics
            Route::get('/analytics', [AnalyticsController::class, 'index'])->name('banking.analytics');

            // Card Management
            Route::get('/cards/{card}', [CardDetailsController::class, 'show'])->name('banking.cards.show');
            Route::post('/cards/{card}/toggle-online', [CardDetailsController::class, 'toggleOnline'])->name('banking.cards.toggle-online');
            Route::post('/cards/{card}/toggle-atm', [CardDetailsController::class, 'toggleAtm'])->name('banking.cards.toggle-atm');
            Route::post('/cards/{card}/toggle-contactless', [CardDetailsController::class, 'toggleContactless'])->name('banking.cards.toggle-contactless');
            Route::patch('/cards/{card}/limits', [CardDetailsController::class, 'updateLimits'])->name('banking.cards.limits');
            Route::post('/cards/{card}/freeze', [CardDetailsController::class, 'freeze'])->name('banking.cards.freeze');
            Route::post('/cards/{card}/unfreeze', [CardDetailsController::class, 'unfreeze'])->name('banking.cards.unfreeze');

            // Support (customer tickets)
            Route::get('/help-desk', [SupportController::class, 'index'])->name('banking.support');
            Route::get('/help-desk/{id}', [SupportController::class, 'show'])->name('banking.support.show');
            Route::post('/help-desk', [SupportController::class, 'store'])->name('banking.support.store');
            Route::post('/help-desk/{id}/reply', [SupportController::class, 'reply'])->name('banking.support.reply');

            // Security
            Route::get('/security', [SecurityController::class, 'index'])->name('banking.security');
            Route::delete('/security/sessions/{token}', [SecurityController::class, 'revokeSession'])->name('banking.security.revoke');
            Route::delete('/security/sessions', [SecurityController::class, 'revokeAllSessions'])->name('banking.security.revoke-all');

            // Referral
            Route::get('/referral', [ReferralController::class, 'index'])->name('banking.referral');

            // Crypto Trading
            Route::get('/crypto', [CryptoController::class, 'index'])->name('banking.crypto');
            Route::get('/crypto/prices', [CryptoController::class, 'prices'])->name('banking.crypto.prices');
            Route::post('/crypto/buy', [CryptoController::class, 'buy'])->name('banking.crypto.buy');
            Route::post('/crypto/sell', [CryptoController::class, 'sell'])->name('banking.crypto.sell');
        }
    );
});

// Admin Routes
Route::middleware(['auth', 'verified', AdminMiddleware::class])->prefix('admin')->name('admin.')->group(function () {
    Route::get('/dashboard', [AdminDashboard::class, 'index'])->name('dashboard');

    Route::get('/users', [AdminUsers::class, 'index'])->name('users');
    Route::get('/users/{user}', [AdminUsers::class, 'show'])->name('users.show');
    Route::patch('/users/{user}/status', [AdminUsers::class, 'updateStatus'])->name('users.status');
    Route::patch('/users/{user}/kyc', [AdminUsers::class, 'updateKycStatus'])->name('users.kyc');
    Route::post('/users/{user}/reset-password', [AdminUsers::class, 'resetPassword'])->name('users.reset-password');
    Route::patch('/users/{user}/profile', [AdminUsers::class, 'updateProfile'])->name('users.update-profile');
    Route::post('/users/{user}/freeze-all', [AdminUsers::class, 'freezeAllAccounts'])->name('users.freeze-all');
    Route::post('/users/{user}/unfreeze-all', [AdminUsers::class, 'unfreezeAllAccounts'])->name('users.unfreeze-all');
    Route::post('/users/{user}/send-note', [AdminUsers::class, 'sendNote'])->name('users.send-note');
    Route::post('/users/{user}/add-note', [AdminUsers::class, 'addNote'])->name('users.add-note');
    Route::delete('/notes/{note}', [AdminUsers::class, 'deleteNote'])->name('notes.delete');
    Route::patch('/notes/{note}/pin', [AdminUsers::class, 'togglePinNote'])->name('notes.pin');

    Route::get('/transactions', [AdminTransactions::class, 'index'])->name('transactions');
    Route::get('/transactions/{id}', [AdminTransactions::class, 'show'])->name('transactions.show');
    Route::post('/transactions/{id}/cancel', [AdminTransactions::class, 'cancel'])->name('transactions.cancel');
    Route::post('/transactions/{id}/refund', [AdminTransactions::class, 'refund'])->name('transactions.refund');
    Route::patch('/transactions/{id}/status', [AdminTransactions::class, 'updateStatus'])->name('transactions.status');

    Route::get('/merchants', [AdminMerchants::class, 'index'])->name('merchants');
    Route::post('/merchants', [AdminMerchants::class, 'store'])->name('merchants.store');
    Route::get('/merchants/{merchant}', [AdminMerchants::class, 'show'])->name('merchants.show');
    Route::patch('/merchants/{merchant}', [AdminMerchants::class, 'update'])->name('merchants.update');
    Route::post('/merchants/{merchant}/api-key', [AdminMerchants::class, 'generateApiKey'])->name('merchants.api-key');
    Route::delete('/api-keys/{apiKey}', [AdminMerchants::class, 'revokeApiKey'])->name('api-keys.revoke');

    Route::get('/currencies', [AdminCurrencies::class, 'index'])->name('currencies');
    Route::post('/currencies', [AdminCurrencies::class, 'store'])->name('currencies.store');
    Route::patch('/currencies/{currency}', [AdminCurrencies::class, 'update'])->name('currencies.update');
    Route::post('/exchange-rates', [AdminCurrencies::class, 'updateRate'])->name('exchange-rates.update');

    Route::get('/accounts', [AdminSystem::class, 'accounts'])->name('accounts');
    Route::patch('/accounts/{account}/status', [AdminSystem::class, 'updateAccountStatus'])->name('accounts.status');
    Route::post('/accounts/{account}/adjust', [AdminSystem::class, 'adjustBalance'])->name('accounts.adjust');

    Route::get('/cards', [AdminSystem::class, 'cards'])->name('cards');
    Route::patch('/cards/{card}/status', [AdminSystem::class, 'updateCardStatus'])->name('cards.status');
    Route::patch('/cards/{card}/limits', [AdminSystem::class, 'updateCardLimits'])->name('cards.limits');

    Route::get('/kyc', [KycReviewController::class, 'index'])->name('kyc');
    Route::post('/kyc/{document}/review', [KycReviewController::class, 'review'])->name('kyc.review');
    Route::get('/kyc/{document}/view', [KycReviewController::class, 'viewDocument'])->name('kyc.view');

    // Support Admin
    Route::get('/support', [SupportAdminController::class, 'index'])->name('support');
    Route::get('/support/{id}', [SupportAdminController::class, 'show'])->name('support.show');
    Route::post('/support/{id}/reply', [SupportAdminController::class, 'reply'])->name('support.reply');
    Route::patch('/support/{id}/status', [SupportAdminController::class, 'updateStatus'])->name('support.status');

    Route::get('/audit-logs', [AdminSystem::class, 'auditLogs'])->name('audit-logs');
    Route::get('/settings', [AdminSystem::class, 'settings'])->name('settings');
    Route::post('/settings', [AdminSystem::class, 'updateSettings'])->name('settings.update');

    // Reports & Analytics
    Route::get('/reports', [AdminReports::class, 'index'])->name('reports');

    // Risk & Compliance
    Route::get('/risk', [AdminRisk::class, 'index'])->name('risk');

    // Waitlist Management
    Route::get('/waitlist', [\App\Http\Controllers\Admin\WaitlistController::class, 'index'])->name('waitlist');
    Route::delete('/waitlist/{type}/{id}', [\App\Http\Controllers\Admin\WaitlistController::class, 'destroy'])->name('waitlist.delete');
    Route::post('/waitlist/bulk-delete', [\App\Http\Controllers\Admin\WaitlistController::class, 'bulkDelete'])->name('waitlist.bulk-delete');

    // Global Search
    Route::get('/search', [\App\Http\Controllers\Admin\SearchController::class, 'search'])->name('search');

    // Broadcast Notifications
    Route::get('/broadcast', [AdminUsers::class, 'broadcastForm'])->name('broadcast');
    Route::post('/broadcast', [AdminUsers::class, 'broadcastSend'])->name('broadcast.send');

    // App Management
    Route::get('/app-management', [\App\Http\Controllers\Admin\AppManagementController::class, 'index'])->name('app-management');
    Route::post('/app-management', [\App\Http\Controllers\Admin\AppManagementController::class, 'update'])->name('app-management.update');

    // Analytics
    Route::get('/analytics', [\App\Http\Controllers\Admin\AnalyticsController::class, 'index'])->name('analytics');

    // Support Tickets
    Route::get('/tickets', [\App\Http\Controllers\Admin\TicketController::class, 'index'])->name('tickets');
    Route::get('/tickets/{ticket}', [\App\Http\Controllers\Admin\TicketController::class, 'show'])->name('tickets.show');
    Route::post('/tickets/{ticket}/reply', [\App\Http\Controllers\Admin\TicketController::class, 'reply'])->name('tickets.reply');
    Route::patch('/tickets/{ticket}/status', [\App\Http\Controllers\Admin\TicketController::class, 'updateStatus'])->name('tickets.status');
    Route::patch('/tickets/{ticket}/priority', [\App\Http\Controllers\Admin\TicketController::class, 'updatePriority'])->name('tickets.priority');

    // API Dashboard
    Route::get('/api-status', [\App\Http\Controllers\Admin\ApiDashboardController::class, 'index'])->name('api-status');

    // Compliance
    Route::get('/compliance', [\App\Http\Controllers\Admin\ComplianceController::class, 'index'])->name('compliance');

    // Fee Management
    Route::get('/fees', [\App\Http\Controllers\Admin\FeeController::class, 'index'])->name('fees');
    Route::post('/fees', [\App\Http\Controllers\Admin\FeeController::class, 'update'])->name('fees.update');

    // Approvals
    Route::get('/approvals', [\App\Http\Controllers\Admin\ApprovalController::class, 'index'])->name('approvals');
    Route::post('/approvals/{id}/review', [\App\Http\Controllers\Admin\ApprovalController::class, 'review'])->name('approvals.review');

    // Communications
    Route::get('/communications', [\App\Http\Controllers\Admin\CommunicationController::class, 'index'])->name('communications');

    // Admin Security
    Route::get('/security', [\App\Http\Controllers\Admin\AdminSecurityController::class, 'index'])->name('security');

    // Rate Management
    Route::get('/rates', [\App\Http\Controllers\Admin\RateController::class, 'index'])->name('rates');
    Route::post('/rates/spread', [\App\Http\Controllers\Admin\RateController::class, 'updateSpread'])->name('rates.spread');

    // CSV Exports
    Route::get('/export/users', [\App\Http\Controllers\Admin\ExportController::class, 'users'])->name('export.users');
    Route::get('/export/transactions', [\App\Http\Controllers\Admin\ExportController::class, 'transactions'])->name('export.transactions');
    Route::get('/export/preregistrations', [\App\Http\Controllers\Admin\ExportController::class, 'preregistrations'])->name('export.preregistrations');
    Route::get('/export/waitlist', [\App\Http\Controllers\Admin\ExportController::class, 'waitlist'])->name('export.waitlist');

    // Phase 5: Advanced Features
    Route::get('/promotions', [\App\Http\Controllers\Admin\PromotionController::class, 'index'])->name('promotions');
    Route::post('/promotions', [\App\Http\Controllers\Admin\PromotionController::class, 'store'])->name('promotions.store');
    Route::post('/promotions/{id}/toggle', [\App\Http\Controllers\Admin\PromotionController::class, 'toggle'])->name('promotions.toggle');
    Route::delete('/promotions/{id}', [\App\Http\Controllers\Admin\PromotionController::class, 'destroy'])->name('promotions.destroy');

    Route::get('/cms', [\App\Http\Controllers\Admin\CmsController::class, 'index'])->name('cms');
    Route::patch('/cms/{id}', [\App\Http\Controllers\Admin\CmsController::class, 'update'])->name('cms.update');

    Route::get('/limits', [\App\Http\Controllers\Admin\LimitsController::class, 'index'])->name('limits');
    Route::post('/limits', [\App\Http\Controllers\Admin\LimitsController::class, 'update'])->name('limits.update');

    Route::get('/frozen-accounts', [\App\Http\Controllers\Admin\FrozenAccountController::class, 'index'])->name('frozen');
    Route::post('/frozen-accounts/freeze', [\App\Http\Controllers\Admin\FrozenAccountController::class, 'freeze'])->name('frozen.freeze');
    Route::post('/frozen-accounts/{userId}/unfreeze', [\App\Http\Controllers\Admin\FrozenAccountController::class, 'unfreeze'])->name('frozen.unfreeze');

    Route::get('/customer-map', [\App\Http\Controllers\Admin\CustomerMapController::class, 'index'])->name('customer-map');
    Route::get('/revenue', [\App\Http\Controllers\Admin\RevenueController::class, 'index'])->name('revenue');
    Route::get('/retention', [\App\Http\Controllers\Admin\RetentionController::class, 'index'])->name('retention');

    Route::get('/changelog', [\App\Http\Controllers\Admin\ChangelogController::class, 'index'])->name('changelog');

    Route::get('/alerts', [\App\Http\Controllers\Admin\AlertController::class, 'index'])->name('alerts');
    Route::post('/alerts/{id}/read', [\App\Http\Controllers\Admin\AlertController::class, 'markRead'])->name('alerts.read');
    Route::post('/alerts/{id}/resolve', [\App\Http\Controllers\Admin\AlertController::class, 'resolve'])->name('alerts.resolve');

    Route::get('/pdf-reports', [\App\Http\Controllers\Admin\ReportController::class, 'index'])->name('pdf-reports');

    // Phase 6: Advanced Features
    Route::get('/email-templates', [\App\Http\Controllers\Admin\EmailTemplateController::class, 'index'])->name('email-templates');
    Route::post('/email-templates', [\App\Http\Controllers\Admin\EmailTemplateController::class, 'store'])->name('email-templates.store');
    Route::patch('/email-templates/{id}', [\App\Http\Controllers\Admin\EmailTemplateController::class, 'update'])->name('email-templates.update');

    Route::get('/tasks', [\App\Http\Controllers\Admin\TaskController::class, 'index'])->name('tasks');
    Route::post('/tasks', [\App\Http\Controllers\Admin\TaskController::class, 'store'])->name('tasks.store');
    Route::patch('/tasks/{id}/status', [\App\Http\Controllers\Admin\TaskController::class, 'updateStatus'])->name('tasks.status');

    Route::get('/customer-tags', [\App\Http\Controllers\Admin\CustomerTagController::class, 'index'])->name('tags');
    Route::post('/customer-tags', [\App\Http\Controllers\Admin\CustomerTagController::class, 'store'])->name('tags.store');
    Route::post('/customer-tags/assign', [\App\Http\Controllers\Admin\CustomerTagController::class, 'assignTag'])->name('tags.assign');
    Route::delete('/customer-tags/{userId}/{tagId}', [\App\Http\Controllers\Admin\CustomerTagController::class, 'removeTag'])->name('tags.remove');

    Route::get('/live-kpi', [\App\Http\Controllers\Admin\LiveKpiController::class, 'index'])->name('live-kpi');

    Route::get('/special-requests', [\App\Http\Controllers\Admin\SpecialRequestController::class, 'index'])->name('special-requests');
    Route::post('/special-requests/{id}/handle', [\App\Http\Controllers\Admin\SpecialRequestController::class, 'handle'])->name('special-requests.handle');

    Route::get('/sessions', [\App\Http\Controllers\Admin\SessionController::class, 'index'])->name('sessions');
    Route::delete('/sessions/{id}', [\App\Http\Controllers\Admin\SessionController::class, 'destroy'])->name('sessions.destroy');

    Route::get('/ip-whitelist', [\App\Http\Controllers\Admin\IpWhitelistController::class, 'index'])->name('ip-whitelist');
    Route::post('/ip-whitelist', [\App\Http\Controllers\Admin\IpWhitelistController::class, 'store'])->name('ip-whitelist.store');
    Route::delete('/ip-whitelist/{id}', [\App\Http\Controllers\Admin\IpWhitelistController::class, 'destroy'])->name('ip-whitelist.destroy');

    Route::get('/referrals', [\App\Http\Controllers\Admin\ReferralController::class, 'index'])->name('referrals');

    Route::get('/campaigns', [\App\Http\Controllers\Admin\CampaignController::class, 'index'])->name('campaigns');
    Route::post('/campaigns', [\App\Http\Controllers\Admin\CampaignController::class, 'store'])->name('campaigns.store');

    // Phase 7: Security, Fraud, AML & Advanced Systems
    Route::get('/fraud', [\App\Http\Controllers\Admin\FraudController::class, 'index'])->name('fraud');
    Route::post('/fraud/rules', [\App\Http\Controllers\Admin\FraudController::class, 'storeRule'])->name('fraud.rules.store');
    Route::post('/fraud/rules/{id}/toggle', [\App\Http\Controllers\Admin\FraudController::class, 'toggleRule'])->name('fraud.rules.toggle');
    Route::patch('/fraud/incidents/{id}', [\App\Http\Controllers\Admin\FraudController::class, 'updateIncident'])->name('fraud.incidents.update');

    Route::get('/aml', [\App\Http\Controllers\Admin\AmlController::class, 'index'])->name('aml');
    Route::patch('/aml/{id}/review', [\App\Http\Controllers\Admin\AmlController::class, 'review'])->name('aml.review');
    Route::post('/aml/report', [\App\Http\Controllers\Admin\AmlController::class, 'createReport'])->name('aml.report');

    Route::get('/transaction-monitor', [\App\Http\Controllers\Admin\TransactionMonitorController::class, 'index'])->name('transaction-monitor');
    Route::get('/user-analytics', [\App\Http\Controllers\Admin\UserAnalyticsController::class, 'index'])->name('user-analytics');

    Route::get('/risk-dashboard', [\App\Http\Controllers\Admin\RiskDashboardController::class, 'index'])->name('risk-dashboard');
    Route::patch('/risk/{userId}', [\App\Http\Controllers\Admin\RiskDashboardController::class, 'updateRisk'])->name('risk.update');

    Route::get('/verification-logs', [\App\Http\Controllers\Admin\VerificationLogController::class, 'index'])->name('verification-logs');

    Route::get('/integrations', [\App\Http\Controllers\Admin\IntegrationController::class, 'index'])->name('integrations');
    Route::patch('/integrations/{id}', [\App\Http\Controllers\Admin\IntegrationController::class, 'update'])->name('integrations.update');

    Route::get('/data-management', [\App\Http\Controllers\Admin\DataManagementController::class, 'index'])->name('data-management');
    Route::post('/data-management/reports', [\App\Http\Controllers\Admin\DataManagementController::class, 'storeReport'])->name('data.reports.store');
    Route::post('/data-management/reports/{id}/toggle', [\App\Http\Controllers\Admin\DataManagementController::class, 'toggleReport'])->name('data.reports.toggle');

    Route::get('/report-center', [\App\Http\Controllers\Admin\ReportCenterController::class, 'index'])->name('report-center');

    // ═══ Phase 8: Business Accounts ═══
    Route::get('/businesses/dashboard', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'dashboard'])->name('businesses.dashboard');
    Route::get('/businesses', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'index'])->name('businesses.index');
    Route::get('/businesses/{id}', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'show'])->name('businesses.show');
    Route::post('/businesses/{id}/activate', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'activate'])->name('businesses.activate');
    Route::post('/businesses/{id}/suspend', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'suspend'])->name('businesses.suspend');
    Route::post('/businesses/{id}/reject', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'reject'])->name('businesses.reject');
    Route::post('/businesses/{id}/freeze', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'freezeAccount'])->name('businesses.freeze');
    Route::post('/businesses/{id}/unfreeze', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'unfreezeAccount'])->name('businesses.unfreeze');
    Route::post('/businesses/{id}/limits', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'updateLimits'])->name('businesses.updateLimits');
    Route::post('/businesses/{id}/notify', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'sendNotification'])->name('businesses.notify');
    Route::post('/businesses/{business}/employees/{employee}/role', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'updateEmployeeRole'])->name('businesses.updateEmployeeRole');
    Route::post('/businesses/{business}/employees/{employee}/remove', [\App\Http\Controllers\Admin\BusinessAccountController::class, 'removeEmployee'])->name('businesses.removeEmployee');
});

require __DIR__ . '/auth.php';