import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'translations_extra.dart';

/// All translatable strings for the SDB app
class AppStrings {
  // Login / Register
  final String welcomeBack;
  final String createAccount;
  final String loginSubtitle;
  final String registerSubtitle;
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final String login;
  final String register;
  final String forgotPassword;
  final String noAccount;
  final String hasAccount;
  final String openAccount;
  final String signIn;
  final String orDivider;
  final String biometricSignIn;
  final String termsAgree;
  final String fillAllFields;
  final String passwordMismatch;
  final String connectionError;
  final String selectCountry;

  // Dashboard
  final String totalBalance;
  final String thisMonth;
  final String send;
  final String receive;
  final String addMoney;
  final String exchange;
  final String myWallets;
  final String seeAll;
  final String recentTransactions;
  final String noTransactions;
  final String today;
  final String yesterday;
  final String pending;
  final String goodMorning;
  final String goodAfternoon;
  final String goodEvening;
  final String receiveMoneyTitle;
  final String yourAccountDetails;
  final String account;
  final String currency;
  final String bank;
  final String copyDetails;
  final String detailsCopied;
  final String newStr;
  final String details;

  // Bottom Nav
  final String navHome;
  final String navPayments;
  final String navCards;
  final String navActivity;
  final String navProfile;

  // Cards
  final String myCards;
  final String issueCard;
  final String freezeCard;
  final String unfreezeCard;
  final String cardFrozen;
  final String cardActive;
  final String noCards;
  final String issueFirstCard;
  final String addToWallet;

  // Transactions
  final String transactions;
  final String all;
  final String incoming;
  final String outgoing;
  final String noTransactionsYet;

  // Transfer
  final String sendMoney;
  final String recipientUsername;
  final String amount;
  final String description;
  final String sendTransfer;
  final String transferSuccess;

  // Exchange
  final String exchangeCurrency;
  final String from;
  final String to;
  final String rate;
  final String exchangeNow;

  // Deposit
  final String deposit;
  final String depositAmount;
  final String depositMethod;

  // Profile / More
  final String personalInfo;
  final String username;
  final String verification;
  final String biometricLogin;
  final String twoFactorAuth;
  final String changePassword;
  final String notifications;
  final String language;
  final String defaultCurrency;
  final String helpCenter;
  final String contactSupport;
  final String signOut;
  final String signOutConfirm;
  final String cancel;
  final String save;
  final String editProfile;
  final String profileUpdated;
  final String passwordChanged;
  final String selectLanguage;
  final String enabled;
  final String disabled;
  final String verified;
  final String member;
  final String kyc;

  // Notifications
  final String notificationsTitle;
  final String noNotifications;

  // KYC
  final String verifyIdentity;

  // Splash
  final String appName;
  final String appSubtitle;

  // Section Headers
  final String sectionAccount;
  final String sectionSecurity;
  final String sectionPreferences;
  final String sectionSupport;
  final String biometricSubtitle;
  final String twoFactorSubtitle;
  final String comingSoon;

  // Contacts
  final String contacts;
  final String sdbMember;
  final String inviteToSdb;
  final String sendViaPhone;
  final String noContactsFound;
  final String searchContacts;
  final String inviteMessage;

  // QR Code
  final String myQrCode;
  final String scanQr;
  final String shareQr;
  final String scanToPayMe;

  // Cards extra
  final String cardDetails;
  final String cardSettings;
  final String resetPin;
  final String replaceCard;
  final String deleteCard;
  final String spendingLimits;
  final String requestCard;
  final String digitalCard;
  final String viewPin;
  final String freeze;
  final String unfreeze;

  // Transfer extras
  final String scheduled;
  final String exchangeRate;
  final String continueBtn;
  final String transferFee;
  final String free;
  final String arrives;
  final String instantly;
  final String confirmSend;

  // Dashboard extras
  final String explore;
  final String howCanIHelp;
  final String askAssistant;

  // Settings
  final String appSettings;
  final String security;
  final String changePasswordTitle;
  final String currentPassword;
  final String newPassword;
  final String confirmPasswordShort;
  final String passwordsNotMatch;
  final String passwordChangedSuccess;
  final String change;
  final String appearanceAndSound;
  final String appTheme;
  final String light;
  final String dark;
  final String customizeAppIcon;
  final String appSounds;
  final String chooseIcon;
  final String iconChangeFailed;
  final String biometricNotAvailable;
  final String biometricEnabled;
  final String biometricDisabled;
  final String errorTryAgain;

  // Cards extra 2
  final String pinCode;
  final String yourPinCode;
  final String dontSharePin;
  final String resetPinConfirm;
  final String resetPinSuccess;
  final String reset;
  final String replaceCardConfirm;
  final String replace;
  final String deleteCardConfirm;
  final String deletePermanently;
  final String addingToWallet;
  final String addedToWallet;
  final String walletNotAvailable;
  final String connectionErrorShort;
  final String settingUpdateFailed;
  final String cardsTitle;

  // Wallet & Card request
  final String requestNewCard;
  final String mastercardDigital;
  final String linkCardToWallet;
  final String hasCard;
  final String agreeTermsCard;
  final String issueCardBtn;
  final String manageCard;
  final String cardFrozenLabel;
  final String noWalletsAvailable;
  final String oneCardPerWallet;

  // Insights
  final String insights;
  final String selectPeriod;
  final String timePeriod;
  final String categories;
  final String accounts;
  final String allAccounts;
  final String noDataPeriod;
  final String noData;
  final String recurringOps;
  final String recipients;
  final String nOps;

  // Transfer extras 2
  final String scheduleTransfer;
  final String scheduleAutoTransfer;
  final String repetition;
  final String transferScheduled;
  final String selectAccount;
  final String sendVia;
  final String phoneNumber;
  final String selectTheme;
  final String settings;

  const AppStrings({
    required this.welcomeBack,
    required this.createAccount,
    required this.loginSubtitle,
    required this.registerSubtitle,
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.login,
    required this.register,
    required this.forgotPassword,
    required this.noAccount,
    required this.hasAccount,
    required this.openAccount,
    required this.signIn,
    required this.orDivider,
    required this.biometricSignIn,
    required this.termsAgree,
    required this.fillAllFields,
    required this.passwordMismatch,
    required this.connectionError,
    required this.selectCountry,
    required this.totalBalance,
    required this.thisMonth,
    required this.send,
    required this.receive,
    required this.addMoney,
    required this.exchange,
    required this.myWallets,
    required this.seeAll,
    required this.recentTransactions,
    required this.noTransactions,
    required this.today,
    required this.yesterday,
    required this.pending,
    required this.goodMorning,
    required this.goodAfternoon,
    required this.goodEvening,
    required this.receiveMoneyTitle,
    required this.yourAccountDetails,
    required this.account,
    required this.currency,
    required this.bank,
    required this.copyDetails,
    required this.detailsCopied,
    required this.newStr,
    required this.details,
    required this.navHome,
    required this.navPayments,
    required this.navCards,
    required this.navActivity,
    required this.navProfile,
    required this.myCards,
    required this.issueCard,
    required this.freezeCard,
    required this.unfreezeCard,
    required this.cardFrozen,
    required this.cardActive,
    required this.noCards,
    required this.issueFirstCard,
    required this.addToWallet,
    required this.transactions,
    required this.all,
    required this.incoming,
    required this.outgoing,
    required this.noTransactionsYet,
    required this.sendMoney,
    required this.recipientUsername,
    required this.amount,
    required this.description,
    required this.sendTransfer,
    required this.transferSuccess,
    required this.exchangeCurrency,
    required this.from,
    required this.to,
    required this.rate,
    required this.exchangeNow,
    required this.deposit,
    required this.depositAmount,
    required this.depositMethod,
    required this.personalInfo,
    required this.username,
    required this.verification,
    required this.biometricLogin,
    required this.twoFactorAuth,
    required this.changePassword,
    required this.notifications,
    required this.language,
    required this.defaultCurrency,
    required this.helpCenter,
    required this.contactSupport,
    required this.signOut,
    required this.signOutConfirm,
    required this.cancel,
    required this.save,
    required this.editProfile,
    required this.profileUpdated,
    required this.passwordChanged,
    required this.selectLanguage,
    required this.enabled,
    required this.disabled,
    required this.verified,
    required this.member,
    required this.kyc,
    required this.notificationsTitle,
    required this.noNotifications,
    required this.verifyIdentity,
    required this.appName,
    required this.appSubtitle,
    required this.sectionAccount,
    required this.sectionSecurity,
    required this.sectionPreferences,
    required this.sectionSupport,
    required this.biometricSubtitle,
    required this.twoFactorSubtitle,
    required this.comingSoon,
    required this.contacts,
    required this.sdbMember,
    required this.inviteToSdb,
    required this.sendViaPhone,
    required this.noContactsFound,
    required this.searchContacts,
    required this.inviteMessage,
    required this.myQrCode,
    required this.scanQr,
    required this.shareQr,
    required this.scanToPayMe,
    required this.cardDetails,
    required this.cardSettings,
    required this.resetPin,
    required this.replaceCard,
    required this.deleteCard,
    required this.spendingLimits,
    required this.requestCard,
    required this.digitalCard,
    required this.viewPin,
    required this.freeze,
    required this.unfreeze,
    required this.scheduled,
    required this.exchangeRate,
    required this.continueBtn,
    required this.transferFee,
    required this.free,
    required this.arrives,
    required this.instantly,
    required this.confirmSend,
    required this.explore,
    required this.howCanIHelp,
    required this.askAssistant,
    required this.appSettings,
    required this.security,
    required this.changePasswordTitle,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPasswordShort,
    required this.passwordsNotMatch,
    required this.passwordChangedSuccess,
    required this.change,
    required this.appearanceAndSound,
    required this.appTheme,
    required this.light,
    required this.dark,
    required this.customizeAppIcon,
    required this.appSounds,
    required this.chooseIcon,
    required this.iconChangeFailed,
    required this.biometricNotAvailable,
    required this.biometricEnabled,
    required this.biometricDisabled,
    required this.errorTryAgain,
    required this.pinCode,
    required this.yourPinCode,
    required this.dontSharePin,
    required this.resetPinConfirm,
    required this.resetPinSuccess,
    required this.reset,
    required this.replaceCardConfirm,
    required this.replace,
    required this.deleteCardConfirm,
    required this.deletePermanently,
    required this.addingToWallet,
    required this.addedToWallet,
    required this.walletNotAvailable,
    required this.connectionErrorShort,
    required this.settingUpdateFailed,
    required this.cardsTitle,
    required this.requestNewCard,
    required this.mastercardDigital,
    required this.linkCardToWallet,
    required this.hasCard,
    required this.agreeTermsCard,
    required this.issueCardBtn,
    required this.manageCard,
    required this.cardFrozenLabel,
    required this.noWalletsAvailable,
    required this.oneCardPerWallet,
    required this.insights,
    required this.selectPeriod,
    required this.timePeriod,
    required this.categories,
    required this.accounts,
    required this.allAccounts,
    required this.noDataPeriod,
    required this.noData,
    required this.recurringOps,
    required this.recipients,
    required this.nOps,
    required this.scheduleTransfer,
    required this.scheduleAutoTransfer,
    required this.repetition,
    required this.transferScheduled,
    required this.selectAccount,
    required this.sendVia,
    required this.phoneNumber,
    required this.selectTheme,
    required this.settings,
  });
}

const enStrings = AppStrings(
  welcomeBack: 'Welcome Back',
  createAccount: 'Create Account',
  loginSubtitle: 'Sign in to access your account',
  registerSubtitle: 'Open your digital account in minutes',
  fullName: 'Full Name',
  email: 'Email',
  password: 'Password',
  confirmPassword: 'Confirm Password',
  phone: 'Phone Number',
  login: 'Sign In',
  register: 'Create Account',
  forgotPassword: 'Forgot Password?',
  noAccount: "Don't have an account? ",
  hasAccount: 'Already have an account? ',
  openAccount: 'Open Account',
  signIn: 'Sign In',
  orDivider: 'or',
  biometricSignIn: 'Sign in with Face ID',
  termsAgree: 'By signing up you agree to the Terms and Privacy Policy',
  fillAllFields: 'Please fill all fields',
  passwordMismatch: 'Passwords do not match',
  connectionError: 'Server connection error',
  selectCountry: 'Select Country',
  totalBalance: 'Total balance',
  thisMonth: '+2.4% this month',
  send: 'Send',
  receive: 'Receive',
  addMoney: 'Add Money',
  exchange: 'Exchange',
  myWallets: 'My Wallets',
  seeAll: 'See all',
  recentTransactions: 'Recent Transactions',
  noTransactions: 'No transactions yet',
  today: 'Today',
  yesterday: 'Yesterday',
  pending: 'Pending',
  goodMorning: 'Good morning',
  goodAfternoon: 'Good afternoon',
  goodEvening: 'Good evening',
  receiveMoneyTitle: 'Receive Money',
  yourAccountDetails: 'Your Account Details',
  account: 'Account',
  currency: 'Currency',
  bank: 'Bank',
  copyDetails: 'Copy Details',
  detailsCopied: 'Account details copied ✓',
  newStr: 'New',
  details: 'Details',
  navHome: 'Home',
  navPayments: 'Payments',
  navCards: 'Cards',
  navActivity: 'Activity',
  navProfile: 'Profile',
  myCards: 'My Cards',
  issueCard: 'Issue New Card',
  freezeCard: 'Freeze Card',
  unfreezeCard: 'Unfreeze Card',
  cardFrozen: 'Frozen',
  cardActive: 'Active',
  noCards: 'No cards yet',
  issueFirstCard: 'Issue your first card',
  addToWallet: 'Add to Wallet',
  transactions: 'Transactions',
  all: 'All',
  incoming: 'Incoming',
  outgoing: 'Outgoing',
  noTransactionsYet: 'No transactions yet',
  sendMoney: 'Send Money',
  recipientUsername: 'Recipient username',
  amount: 'Amount',
  description: 'Description',
  sendTransfer: 'Send',
  transferSuccess: 'Transfer successful ✓',
  exchangeCurrency: 'Exchange Currency',
  from: 'From',
  to: 'To',
  rate: 'Rate',
  exchangeNow: 'Exchange Now',
  deposit: 'Deposit',
  depositAmount: 'Amount',
  depositMethod: 'Method',
  personalInfo: 'Personal Information',
  username: 'Username',
  verification: 'Verification',
  biometricLogin: 'Biometric Login',
  twoFactorAuth: 'Two-Factor Auth',
  changePassword: 'Change Password',
  notifications: 'Notifications',
  language: 'Language',
  defaultCurrency: 'Default Currency',
  helpCenter: 'Help Center',
  contactSupport: 'Contact Support',
  signOut: 'Sign Out',
  signOutConfirm: 'Are you sure you want to sign out?',
  cancel: 'Cancel',
  save: 'Save Changes',
  editProfile: 'Edit Profile',
  profileUpdated: 'Profile updated ✓',
  passwordChanged: 'Password changed ✓',
  selectLanguage: 'Select Language',
  enabled: 'Enabled',
  disabled: 'Disabled',
  verified: 'Verified',
  member: 'Member',
  kyc: 'KYC',
  notificationsTitle: 'Notifications',
  noNotifications: 'No notifications yet',
  verifyIdentity: 'Verify Identity',
  appName: 'SDB Bank',
  appSubtitle: 'Syrian Digital Bank',
  sectionAccount: 'ACCOUNT',
  sectionSecurity: 'SECURITY',
  sectionPreferences: 'PREFERENCES',
  sectionSupport: 'SUPPORT',
  biometricSubtitle: 'Face ID / Fingerprint',
  twoFactorSubtitle: 'SMS',
  comingSoon: 'Coming soon',
  contacts: 'Contacts',
  sdbMember: 'SDB Member',
  inviteToSdb: 'Invite to SDB',
  sendViaPhone: 'Send via phone',
  noContactsFound: 'No contacts found',
  searchContacts: 'Search contacts...',
  inviteMessage: 'Join SDB Bank — the first Syrian digital bank! Download the app: https://sdb-bank.com/download',
  myQrCode: 'My QR Code',
  scanQr: 'Scan QR',
  shareQr: 'Share QR',
  scanToPayMe: 'Scan to pay me',
  cardDetails: 'Card Details',
  cardSettings: 'Card Settings',
  resetPin: 'Reset PIN',
  replaceCard: 'Replace Card',
  deleteCard: 'Delete Card',
  spendingLimits: 'Spending Limits',
  requestCard: 'Request Card',
  digitalCard: 'Digital Card',
  viewPin: 'View PIN',
  freeze: 'Freeze',
  unfreeze: 'Unfreeze',
  scheduled: 'Scheduled',
  exchangeRate: 'Exchange Rate',
  continueBtn: 'Continue',
  transferFee: 'Transfer Fee',
  free: 'Free',
  arrives: 'Arrives',
  instantly: 'Instantly',
  confirmSend: 'Confirm & Send',
  explore: 'Explore',
  howCanIHelp: 'How can I help you?',
  askAssistant: 'Ask SDB smart assistant about your account',
  appSettings: 'App Settings',
  security: 'Security',
  changePasswordTitle: 'Change Password',
  currentPassword: 'Current Password',
  newPassword: 'New Password',
  confirmPasswordShort: 'Confirm Password',
  passwordsNotMatch: 'Passwords do not match',
  passwordChangedSuccess: 'Password changed ✓',
  change: 'Change',
  appearanceAndSound: 'Appearance & Sound',
  appTheme: 'App Theme',
  light: 'Light',
  dark: 'Dark',
  customizeAppIcon: 'Customize App Icon',
  appSounds: 'In-app Sounds',
  chooseIcon: 'Choose Icon',
  iconChangeFailed: 'Failed to change icon',
  biometricNotAvailable: 'Biometric authentication not available',
  biometricEnabled: 'Biometric login enabled ✓',
  biometricDisabled: 'Biometric login disabled',
  errorTryAgain: 'An error occurred — try again',
  pinCode: 'PIN Code',
  yourPinCode: 'Your card PIN code',
  dontSharePin: 'Do not share your PIN with anyone',
  resetPinConfirm: 'A new PIN will be generated for your card',
  resetPinSuccess: 'PIN reset successfully ✅',
  reset: 'Reset',
  replaceCardConfirm: 'Your current card will be cancelled and a new card with a different number will be issued',
  replace: 'Replace',
  deleteCardConfirm: 'Are you sure? This action cannot be undone.\nThe card will be permanently cancelled.',
  deletePermanently: 'Delete Permanently',
  addingToWallet: 'Adding to Apple Wallet...',
  addedToWallet: 'Added to Apple Wallet! ✅',
  walletNotAvailable: 'Apple Wallet not available',
  connectionErrorShort: 'Connection error',
  settingUpdateFailed: 'Setting update failed',
  cardsTitle: 'Cards',
  requestNewCard: 'Request New Card',
  mastercardDigital: 'Digital Mastercard for online and in-store payments',
  linkCardToWallet: 'Link Card to Wallet',
  hasCard: 'Has card',
  agreeTermsCard: 'I agree to the card issuance terms and conditions and privacy policy',
  issueCardBtn: 'Issue Card',
  manageCard: 'Manage Card',
  cardFrozenLabel: 'Card Frozen',
  noWalletsAvailable: 'No wallets available',
  oneCardPerWallet: '⚠️ Each wallet is entitled to only one card',
  insights: 'Insights',
  selectPeriod: 'Select Period',
  timePeriod: 'Time Period',
  categories: 'Categories',
  accounts: 'Accounts',
  allAccounts: 'All Accounts',
  noDataPeriod: 'No data for this period',
  noData: 'No data',
  recurringOps: 'Recurring Operations',
  recipients: 'Recipients',
  nOps: 'operations',
  scheduleTransfer: 'Schedule Transfer',
  scheduleAutoTransfer: 'Schedule automatic transfer',
  repetition: 'Repetition',
  transferScheduled: 'Transfer scheduled ✅',
  selectAccount: 'Select Account',
  sendVia: 'Send via',
  phoneNumber: 'Phone Number',
  selectTheme: 'Select Theme',
  settings: 'Settings',
);

const arStrings = AppStrings(
  welcomeBack: 'مرحباً بعودتك',
  createAccount: 'إنشاء حساب جديد',
  loginSubtitle: 'سجّل دخولك للوصول لحسابك',
  registerSubtitle: 'افتح حسابك الرقمي خلال دقائق',
  fullName: 'الاسم الكامل',
  email: 'البريد الإلكتروني',
  password: 'كلمة المرور',
  confirmPassword: 'تأكيد كلمة المرور',
  phone: 'رقم الهاتف',
  login: 'تسجيل الدخول',
  register: 'إنشاء حساب',
  forgotPassword: 'نسيت كلمة المرور؟',
  noAccount: 'ما عندك حساب؟ ',
  hasAccount: 'عندك حساب؟ ',
  openAccount: 'افتح حساب',
  signIn: 'سجّل دخول',
  orDivider: 'أو',
  biometricSignIn: 'تسجيل بالبصمة',
  termsAgree: 'بتسجيلك توافق على الشروط وسياسة الخصوصية',
  fillAllFields: 'يرجى ملء جميع الحقول',
  passwordMismatch: 'كلمة المرور غير متطابقة',
  connectionError: 'خطأ في الاتصال بالسيرفر',
  selectCountry: 'اختر الدولة',
  totalBalance: 'الرصيد الكلي',
  thisMonth: '+2.4% هذا الشهر',
  send: 'إرسال',
  receive: 'استلام',
  addMoney: 'إيداع',
  exchange: 'صرف',
  myWallets: 'محفظتي',
  seeAll: 'عرض الكل',
  recentTransactions: 'آخر العمليات',
  noTransactions: 'لا توجد عمليات بعد',
  today: 'اليوم',
  yesterday: 'أمس',
  pending: 'قيد الانتظار',
  goodMorning: 'صباح الخير',
  goodAfternoon: 'مساء الخير',
  goodEvening: 'مساء الخير',
  receiveMoneyTitle: 'استلام أموال',
  yourAccountDetails: 'تفاصيل حسابك',
  account: 'الحساب',
  currency: 'العملة',
  bank: 'البنك',
  copyDetails: 'نسخ التفاصيل',
  detailsCopied: 'تم نسخ تفاصيل الحساب ✓',
  newStr: 'جديد',
  details: 'تفاصيل',
  navHome: 'الرئيسية',
  navPayments: 'التحويلات',
  navCards: 'البطاقات',
  navActivity: 'العمليات',
  navProfile: 'حسابي',
  myCards: 'بطاقاتي',
  issueCard: 'إصدار بطاقة جديدة',
  freezeCard: 'تجميد البطاقة',
  unfreezeCard: 'تفعيل البطاقة',
  cardFrozen: 'مجمّدة',
  cardActive: 'نشطة',
  noCards: 'لا توجد بطاقات',
  issueFirstCard: 'أصدر بطاقتك الأولى',
  addToWallet: 'إضافة للمحفظة',
  transactions: 'العمليات',
  all: 'الكل',
  incoming: 'وارد',
  outgoing: 'صادر',
  noTransactionsYet: 'لا توجد عمليات بعد',
  sendMoney: 'إرسال أموال',
  recipientUsername: 'اسم المستخدم للمستلم',
  amount: 'المبلغ',
  description: 'الوصف',
  sendTransfer: 'إرسال',
  transferSuccess: 'تم التحويل بنجاح ✓',
  exchangeCurrency: 'صرف عملات',
  from: 'من',
  to: 'إلى',
  rate: 'السعر',
  exchangeNow: 'صرف الآن',
  deposit: 'إيداع',
  depositAmount: 'المبلغ',
  depositMethod: 'الطريقة',
  personalInfo: 'المعلومات الشخصية',
  username: 'اسم المستخدم',
  verification: 'التحقق',
  biometricLogin: 'تسجيل بالبصمة',
  twoFactorAuth: 'التحقق بخطوتين',
  changePassword: 'تغيير كلمة المرور',
  notifications: 'الإشعارات',
  language: 'اللغة',
  defaultCurrency: 'العملة الافتراضية',
  helpCenter: 'مركز المساعدة',
  contactSupport: 'تواصل مع الدعم',
  signOut: 'تسجيل الخروج',
  signOutConfirm: 'هل أنت متأكد من تسجيل الخروج؟',
  cancel: 'إلغاء',
  save: 'حفظ التغييرات',
  editProfile: 'تعديل الملف الشخصي',
  profileUpdated: 'تم تحديث الملف الشخصي ✓',
  passwordChanged: 'تم تغيير كلمة المرور ✓',
  selectLanguage: 'اختر اللغة',
  enabled: 'مفعّل',
  disabled: 'معطّل',
  verified: 'موثّق',
  member: 'عضو منذ',
  kyc: 'التحقق',
  notificationsTitle: 'الإشعارات',
  noNotifications: 'لا توجد إشعارات',
  verifyIdentity: 'تحقق من هويتك',
  appName: 'SDB Bank',
  appSubtitle: 'بنك سوريا الرقمي',
  sectionAccount: 'الحساب',
  sectionSecurity: 'الأمان',
  sectionPreferences: 'التفضيلات',
  sectionSupport: 'الدعم',
  biometricSubtitle: 'بصمة الوجه / الإصبع',
  twoFactorSubtitle: 'رسالة SMS',
  comingSoon: 'قريباً',
  contacts: 'جهات الاتصال',
  sdbMember: 'عضو SDB',
  inviteToSdb: 'دعوة إلى SDB',
  sendViaPhone: 'إرسال عبر الهاتف',
  noContactsFound: 'لم يتم العثور على جهات اتصال',
  searchContacts: 'بحث في جهات الاتصال...',
  inviteMessage: 'انضم إلى SDB Bank — أول بنك إلكتروني سوري! حمّل التطبيق: https://sdb-bank.com/download',
  myQrCode: 'رمز QR الخاص بي',
  scanQr: 'مسح QR',
  shareQr: 'مشاركة QR',
  scanToPayMe: 'امسح للدفع لي',
  cardDetails: 'تفاصيل البطاقة',
  cardSettings: 'إعدادات البطاقة',
  resetPin: 'إعادة تعيين PIN',
  replaceCard: 'استبدال البطاقة',
  deleteCard: 'حذف البطاقة',
  spendingLimits: 'حدود الإنفاق',
  requestCard: 'طلب بطاقة',
  digitalCard: 'بطاقة رقمية',
  viewPin: 'عرض PIN',
  freeze: 'تجميد',
  unfreeze: 'إلغاء التجميد',
  scheduled: 'مجدولة',
  exchangeRate: 'سعر الصرف',
  continueBtn: 'متابعة',
  transferFee: 'رسوم التحويل',
  free: 'مجاني',
  arrives: 'يصل',
  instantly: 'فوري',
  confirmSend: 'تأكيد وإرسال',
  explore: 'استكشف',
  howCanIHelp: 'كيف يمكنني مساعدتك؟',
  askAssistant: 'اسأل مساعد SDB الذكي عن حسابك',
  appSettings: 'إعدادات التطبيق',
  security: 'الأمان',
  changePasswordTitle: 'تغيير كلمة السر',
  currentPassword: 'كلمة السر الحالية',
  newPassword: 'كلمة السر الجديدة',
  confirmPasswordShort: 'تأكيد كلمة السر',
  passwordsNotMatch: 'كلمات السر غير متطابقة',
  passwordChangedSuccess: 'تم تغيير كلمة السر ✓',
  change: 'تغيير',
  appearanceAndSound: 'المظهر والصوت',
  appTheme: 'سمة التطبيق',
  light: 'فاتح',
  dark: 'داكن',
  customizeAppIcon: 'تخصيص أيقونة التطبيق',
  appSounds: 'الأصوات في التطبيق',
  chooseIcon: 'اختر أيقونة',
  iconChangeFailed: 'تعذّر تغيير الأيقونة',
  biometricNotAvailable: 'المصادقة البيومترية غير متوفرة',
  biometricEnabled: 'تم تفعيل تسجيل الدخول بالبصمة ✓',
  biometricDisabled: 'تم تعطيل تسجيل الدخول بالبصمة',
  errorTryAgain: 'حدث خطأ — حاول مرة أخرى',
  pinCode: 'رمز PIN',
  yourPinCode: 'رمز PIN الخاص ببطاقتك',
  dontSharePin: 'لا تشارك رمز PIN مع أي شخص',
  resetPinConfirm: 'سيتم إنشاء رمز PIN جديد لبطاقتك',
  resetPinSuccess: 'تم إعادة تعيين PIN بنجاح ✅',
  reset: 'إعادة تعيين',
  replaceCardConfirm: 'سيتم إلغاء بطاقتك الحالية وإصدار بطاقة جديدة برقم مختلف',
  replace: 'استبدال',
  deleteCardConfirm: 'هل أنت متأكد؟ لا يمكن التراجع عن هذا الإجراء.\nسيتم إلغاء البطاقة نهائياً.',
  deletePermanently: 'حذف نهائياً',
  addingToWallet: 'جاري الإضافة إلى Apple Wallet...',
  addedToWallet: 'تمت الإضافة إلى Apple Wallet! ✅',
  walletNotAvailable: 'Apple Wallet غير متاح حالياً',
  connectionErrorShort: 'خطأ اتصال',
  settingUpdateFailed: 'فشل تحديث الإعداد',
  cardsTitle: 'البطاقات',
  requestNewCard: 'طلب بطاقة جديدة',
  mastercardDigital: 'بطاقة Mastercard رقمية للدفع أونلاين وفي المتاجر',
  linkCardToWallet: 'ربط البطاقة بالمحفظة',
  hasCard: 'يوجد بطاقة',
  agreeTermsCard: 'أوافق على شروط وأحكام إصدار البطاقة وسياسة الخصوصية',
  issueCardBtn: 'إصدار البطاقة',
  manageCard: 'إدارة البطاقة',
  cardFrozenLabel: 'بطاقة مجمّدة',
  noWalletsAvailable: 'لا توجد محافظ متاحة',
  oneCardPerWallet: '⚠️ كل محفظة يحق لها بطاقة واحدة فقط',
  insights: 'الإحصائيات',
  selectPeriod: 'اختر الفترة',
  timePeriod: 'الفترة الزمنية',
  categories: 'الفئات',
  accounts: 'الحسابات',
  allAccounts: 'جميع الحسابات',
  noDataPeriod: 'لا توجد بيانات لهذه الفترة',
  noData: 'لا توجد بيانات',
  recurringOps: 'عمليات متكررة',
  recipients: 'المستلمون',
  nOps: 'عملية',
  scheduleTransfer: 'جدولة التحويل',
  scheduleAutoTransfer: 'جدولة تحويل تلقائي',
  repetition: 'التكرار',
  transferScheduled: 'تم جدولة التحويل ✅',
  selectAccount: 'اختر حساب',
  sendVia: 'إرسال عبر',
  phoneNumber: 'رقم هاتف',
  selectTheme: 'اختر المظهر',
  settings: 'الإعدادات',
);

/// Provider to manage locale across the app
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');
  AppStrings _strings = arStrings;

  Locale get locale => _locale;
  AppStrings get strings => _strings;
  bool get isArabic => _locale.languageCode == 'ar';

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    // Always read iOS per-app language setting (system locale)
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    _applyByCode(systemLocale.languageCode);
    notifyListeners();
  }

  /// Called on app resume to pick up iOS Settings language changes
  void refreshFromSystem() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (systemLocale.languageCode != _locale.languageCode) {
      _applyByCode(systemLocale.languageCode);
      notifyListeners();
    }
  }

  void setLanguage(String languageName) async {
    _applyLanguage(languageName);
    notifyListeners();
  }

  void _applyByCode(String code) {
    switch (code) {
      case 'ar':
        _locale = const Locale('ar');
        _strings = arStrings;
        break;
      case 'tr':
        _locale = const Locale('tr');
        _strings = trStrings;
        break;
      case 'da':
        _locale = const Locale('da');
        _strings = daStrings;
        break;
      case 'de':
        _locale = const Locale('de');
        _strings = deStrings;
        break;
      case 'fr':
        _locale = const Locale('fr');
        _strings = frStrings;
        break;
      case 'sv':
        _locale = const Locale('sv');
        _strings = svStrings;
        break;
      case 'en':
        _locale = const Locale('en');
        _strings = enStrings;
        break;
      default:
        _locale = const Locale('ar');
        _strings = arStrings;
        break;
    }
  }

  void _applyLanguage(String languageName) {
    switch (languageName) {
      case 'English':
        _applyByCode('en');
        break;
      case 'Türkçe':
        _applyByCode('tr');
        break;
      case 'Dansk':
        _applyByCode('da');
        break;
      case 'Deutsch':
        _applyByCode('de');
        break;
      case 'Français':
        _applyByCode('fr');
        break;
      case 'Svenska':
        _applyByCode('sv');
        break;
      case 'العربية':
      default:
        _applyByCode('ar');
        break;
    }
  }
}

/// InheritedWidget to access strings anywhere
class L10n extends InheritedWidget {
  final AppStrings strings;
  final LocaleProvider provider;

  const L10n({
    super.key,
    required this.strings,
    required this.provider,
    required super.child,
  });

  static AppStrings of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<L10n>()!.strings;
  }

  static LocaleProvider providerOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<L10n>()!.provider;
  }

  @override
  bool updateShouldNotify(L10n oldWidget) => strings != oldWidget.strings;
}
