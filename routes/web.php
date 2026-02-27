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
use App\Http\Controllers\Banking\KycController;
use App\Http\Controllers\Banking\NotificationController;
use App\Http\Controllers\Banking\ReferralController;
use App\Http\Controllers\Banking\SecurityController;
use App\Http\Controllers\Banking\SupportController;
use App\Http\Controllers\Banking\TransactionHistoryController;
use App\Http\Controllers\CheckoutController;
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

// Payment Gateway Checkout
Route::get('/checkout/{sessionId}', [CheckoutController::class , 'show'])->name('checkout.pay');
Route::post('/checkout/{sessionId}/pay', [CheckoutController::class , 'pay'])->name('checkout.process')->middleware('auth');

// Customer Routes (auth required)
Route::middleware(['auth', 'verified'])->group(function () {
    // Always accessible (no KYC required)
    Route::get('/kyc', [KycController::class , 'index'])->name('banking.kyc');
    Route::post('/kyc/upload', [KycController::class , 'upload'])->name('banking.kyc.upload');
    Route::delete('/kyc/{document}', [KycController::class , 'delete'])->name('banking.kyc.delete');

    Route::get('/notifications', [NotificationController::class , 'index'])->name('banking.notifications');
    Route::post('/notifications/{notification}/read', [NotificationController::class , 'markRead'])->name('banking.notifications.read');
    Route::post('/notifications/read-all', [NotificationController::class , 'markAllRead'])->name('banking.notifications.read-all');

    Route::get('/profile', [ProfileController::class , 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class , 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class , 'destroy'])->name('profile.destroy');

    // Banking features — KYC REQUIRED
    Route::middleware([KycRequiredMiddleware::class])->group(function () {
            Route::get('/dashboard', function () {
                    if (auth()->user()->isAdmin())
                        return redirect()->route('admin.dashboard');
                    return app(BankingController::class)->dashboard();
                }
                )->name('dashboard');

                // Core Banking
                Route::post('/banking/transfer', [BankingController::class , 'transfer'])->name('banking.transfer');
                Route::post('/banking/exchange', [BankingController::class , 'exchange'])->name('banking.exchange');
                Route::post('/banking/cards/issue', [BankingController::class , 'issueCard'])->name('banking.cards.issue');
                Route::post('/banking/cards/{card}/toggle-freeze', [BankingController::class , 'toggleCardFreeze'])->name('banking.cards.toggle-freeze');
                Route::post('/banking/deposit', [BankingController::class , 'deposit'])->name('banking.deposit');

                // Beneficiaries
                Route::get('/beneficiaries', [BeneficiaryController::class , 'index'])->name('banking.beneficiaries');
                Route::post('/beneficiaries', [BeneficiaryController::class , 'store'])->name('banking.beneficiaries.store');
                Route::patch('/beneficiaries/{id}', [BeneficiaryController::class , 'update'])->name('banking.beneficiaries.update');
                Route::delete('/beneficiaries/{id}', [BeneficiaryController::class , 'destroy'])->name('banking.beneficiaries.destroy');
                Route::post('/beneficiaries/{id}/favorite', [BeneficiaryController::class , 'toggleFavorite'])->name('banking.beneficiaries.favorite');

                // Transaction History
                Route::get('/transactions', [TransactionHistoryController::class , 'index'])->name('banking.transactions');
                Route::get('/transactions/export', [TransactionHistoryController::class , 'exportCsv'])->name('banking.transactions.export');

                // Analytics
                Route::get('/analytics', [AnalyticsController::class , 'index'])->name('banking.analytics');

                // Card Management
                Route::get('/cards/{card}', [CardDetailsController::class , 'show'])->name('banking.cards.show');
                Route::post('/cards/{card}/toggle-online', [CardDetailsController::class , 'toggleOnline'])->name('banking.cards.toggle-online');
                Route::post('/cards/{card}/toggle-atm', [CardDetailsController::class , 'toggleAtm'])->name('banking.cards.toggle-atm');
                Route::post('/cards/{card}/toggle-contactless', [CardDetailsController::class , 'toggleContactless'])->name('banking.cards.toggle-contactless');
                Route::patch('/cards/{card}/limits', [CardDetailsController::class , 'updateLimits'])->name('banking.cards.limits');
                Route::post('/cards/{card}/freeze', [CardDetailsController::class , 'freeze'])->name('banking.cards.freeze');
                Route::post('/cards/{card}/unfreeze', [CardDetailsController::class , 'unfreeze'])->name('banking.cards.unfreeze');

                // Support
                Route::get('/support', [SupportController::class , 'index'])->name('banking.support');
                Route::get('/support/{id}', [SupportController::class , 'show'])->name('banking.support.show');
                Route::post('/support', [SupportController::class , 'store'])->name('banking.support.store');
                Route::post('/support/{id}/reply', [SupportController::class , 'reply'])->name('banking.support.reply');

                // Security
                Route::get('/security', [SecurityController::class , 'index'])->name('banking.security');
                Route::delete('/security/sessions/{token}', [SecurityController::class , 'revokeSession'])->name('banking.security.revoke');
                Route::delete('/security/sessions', [SecurityController::class , 'revokeAllSessions'])->name('banking.security.revoke-all');

                // Referral
                Route::get('/referral', [ReferralController::class , 'index'])->name('banking.referral');
            }
            );
        });

// Admin Routes
Route::middleware(['auth', 'verified', AdminMiddleware::class])->prefix('admin')->name('admin.')->group(function () {
    Route::get('/dashboard', [AdminDashboard::class , 'index'])->name('dashboard');

    Route::get('/users', [AdminUsers::class , 'index'])->name('users');
    Route::get('/users/{user}', [AdminUsers::class , 'show'])->name('users.show');
    Route::patch('/users/{user}/status', [AdminUsers::class , 'updateStatus'])->name('users.status');
    Route::patch('/users/{user}/kyc', [AdminUsers::class , 'updateKycStatus'])->name('users.kyc');
    Route::post('/users/{user}/reset-password', [AdminUsers::class , 'resetPassword'])->name('users.reset-password');
    Route::patch('/users/{user}/profile', [AdminUsers::class , 'updateProfile'])->name('users.update-profile');
    Route::post('/users/{user}/freeze-all', [AdminUsers::class , 'freezeAllAccounts'])->name('users.freeze-all');
    Route::post('/users/{user}/unfreeze-all', [AdminUsers::class , 'unfreezeAllAccounts'])->name('users.unfreeze-all');
    Route::post('/users/{user}/send-note', [AdminUsers::class , 'sendNote'])->name('users.send-note');

    Route::get('/transactions', [AdminTransactions::class , 'index'])->name('transactions');

    Route::get('/merchants', [AdminMerchants::class , 'index'])->name('merchants');
    Route::post('/merchants', [AdminMerchants::class , 'store'])->name('merchants.store');
    Route::get('/merchants/{merchant}', [AdminMerchants::class , 'show'])->name('merchants.show');
    Route::patch('/merchants/{merchant}', [AdminMerchants::class , 'update'])->name('merchants.update');
    Route::post('/merchants/{merchant}/api-key', [AdminMerchants::class , 'generateApiKey'])->name('merchants.api-key');
    Route::delete('/api-keys/{apiKey}', [AdminMerchants::class , 'revokeApiKey'])->name('api-keys.revoke');

    Route::get('/currencies', [AdminCurrencies::class , 'index'])->name('currencies');
    Route::post('/currencies', [AdminCurrencies::class , 'store'])->name('currencies.store');
    Route::patch('/currencies/{currency}', [AdminCurrencies::class , 'update'])->name('currencies.update');
    Route::post('/exchange-rates', [AdminCurrencies::class , 'updateRate'])->name('exchange-rates.update');

    Route::get('/accounts', [AdminSystem::class , 'accounts'])->name('accounts');
    Route::patch('/accounts/{account}/status', [AdminSystem::class , 'updateAccountStatus'])->name('accounts.status');
    Route::post('/accounts/{account}/adjust', [AdminSystem::class , 'adjustBalance'])->name('accounts.adjust');

    Route::get('/cards', [AdminSystem::class , 'cards'])->name('cards');
    Route::patch('/cards/{card}/status', [AdminSystem::class , 'updateCardStatus'])->name('cards.status');
    Route::patch('/cards/{card}/limits', [AdminSystem::class , 'updateCardLimits'])->name('cards.limits');

    Route::get('/kyc', [KycReviewController::class , 'index'])->name('kyc');
    Route::post('/kyc/{document}/review', [KycReviewController::class , 'review'])->name('kyc.review');
    Route::get('/kyc/{document}/view', [KycReviewController::class , 'viewDocument'])->name('kyc.view');

    // Support Admin
    Route::get('/support', [SupportAdminController::class , 'index'])->name('support');
    Route::get('/support/{id}', [SupportAdminController::class , 'show'])->name('support.show');
    Route::post('/support/{id}/reply', [SupportAdminController::class , 'reply'])->name('support.reply');
    Route::patch('/support/{id}/status', [SupportAdminController::class , 'updateStatus'])->name('support.status');

    Route::get('/audit-logs', [AdminSystem::class , 'auditLogs'])->name('audit-logs');
    Route::get('/settings', [AdminSystem::class , 'settings'])->name('settings');
    Route::post('/settings', [AdminSystem::class , 'updateSettings'])->name('settings.update');

    // Reports & Analytics
    Route::get('/reports', [AdminReports::class , 'index'])->name('reports');

    // Risk & Compliance
    Route::get('/risk', [AdminRisk::class , 'index'])->name('risk');
});

require __DIR__ . '/auth.php';