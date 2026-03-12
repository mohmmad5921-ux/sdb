import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'https://sdb-bank.com/api/v1/mobile';
  static final _storage = const FlutterSecureStorage();

  static Future<String?> get token async => await _storage.read(key: 'auth_token');
  static Future<void> setToken(String t) async => await _storage.write(key: 'auth_token', value: t);
  static Future<void> clearToken() async => await _storage.delete(key: 'auth_token');

  static Future<Map<String, String>> _headers() async {
    final t = await token;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      if (t != null) 'Authorization': 'Bearer $t',
    };
  }

  // Auth
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final r = await http.post(Uri.parse('$baseUrl/auth/login'), headers: await _headers(), body: jsonEncode({'email': email, 'password': password, 'device_name': 'SDB Mobile App'}));
    final data = jsonDecode(r.body);
    if (r.statusCode == 200 && data['token'] != null) {
      await setToken(data['token']);
    }
    return {'success': r.statusCode == 200, 'data': data, 'status': r.statusCode};
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> fields) async {
    final r = await http.post(Uri.parse('$baseUrl/auth/register'), headers: await _headers(), body: jsonEncode(fields));
    final data = jsonDecode(r.body);
    if (r.statusCode == 201 && data['token'] != null) await setToken(data['token']);
    return {'success': r.statusCode == 201 || r.statusCode == 200, 'data': data, 'status': r.statusCode};
  }

  static Future<Map<String, dynamic>> checkUsername(String username) async {
    final r = await http.post(Uri.parse('$baseUrl/auth/check-username'), headers: await _headers(), body: jsonEncode({'username': username}));
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  static Future<Map<String, dynamic>> findByUsername(String username) async {
    final r = await http.get(Uri.parse('$baseUrl/users/@$username'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }


  static Future<void> logout() async {
    try { await http.post(Uri.parse('$baseUrl/auth/logout'), headers: await _headers()); } catch (_) {}
    await clearToken();
  }

  // Dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    final r = await http.get(Uri.parse('$baseUrl/dashboard'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // Accounts
  static Future<Map<String, dynamic>> getAccounts() async {
    final r = await http.get(Uri.parse('$baseUrl/accounts'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // Cards
  static Future<Map<String, dynamic>> getCards() async {
    final r = await http.get(Uri.parse('$baseUrl/cards'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // Transactions
  static Future<Map<String, dynamic>> getTransactions({int page = 1, String? type}) async {
    String url = '$baseUrl/transactions?page=$page';
    if (type != null) url += '&type=$type';
    final r = await http.get(Uri.parse(url), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // Transfer
  static Future<Map<String, dynamic>> transfer(Map<String, dynamic> data) async {
    final r = await http.post(Uri.parse('$baseUrl/transfer'), headers: await _headers(), body: jsonEncode(data));
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body), 'status': r.statusCode};
  }

  // Live Exchange Rate (Frankfurter API — ECB data, free, no key)
  static Future<Map<String, dynamic>> getLiveRate(String from, String to) async {
    try {
      final r = await http.get(Uri.parse('https://api.frankfurter.app/latest?from=$from&to=$to'));
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body);
        final rate = (data['rates'] as Map<String, dynamic>?)?[to];
        return {'success': true, 'rate': rate ?? 0.0, 'from': from, 'to': to, 'date': data['date'] ?? ''};
      }
    } catch (_) {}
    return {'success': false, 'rate': 0.0};
  }

  // Exchange (with locked rate)
  static Future<Map<String, dynamic>> exchange(Map<String, dynamic> data) async {
    final r = await http.post(Uri.parse('$baseUrl/exchange'), headers: await _headers(), body: jsonEncode(data));
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body), 'status': r.statusCode};
  }

  // Deposit
  static Future<Map<String, dynamic>> deposit(Map<String, dynamic> data) async {
    final r = await http.post(Uri.parse('$baseUrl/deposit'), headers: await _headers(), body: jsonEncode(data));
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body), 'status': r.statusCode};
  }

  // Stripe
  static Future<Map<String, dynamic>> getStripeConfig() async {
    final r = await http.get(Uri.parse('$baseUrl/stripe/config'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  static Future<Map<String, dynamic>> createStripeIntent(int accountId, double amount) async {
    final r = await http.post(Uri.parse('$baseUrl/stripe/create-intent'), headers: await _headers(),
      body: jsonEncode({'account_id': accountId, 'amount': amount}));
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body), 'status': r.statusCode};
  }

  static Future<Map<String, dynamic>> confirmStripeDeposit(String paymentIntentId, int accountId) async {
    final r = await http.post(Uri.parse('$baseUrl/stripe/confirm'), headers: await _headers(),
      body: jsonEncode({'payment_intent_id': paymentIntentId, 'account_id': accountId}));
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body), 'status': r.statusCode};
  }

  // Issue Card
  static Future<Map<String, dynamic>> issueCard(int accountId) async {
    final body = accountId > 0 ? {'account_id': accountId} : <String, dynamic>{};
    final r = await http.post(Uri.parse('$baseUrl/cards/issue'), headers: await _headers(), body: jsonEncode(body));
    return {'success': r.statusCode == 200 || r.statusCode == 201, 'data': jsonDecode(r.body), 'status': r.statusCode};
  }

  // Freeze/Unfreeze Card
  static Future<Map<String, dynamic>> toggleCardFreeze(int cardId) async {
    final r = await http.post(Uri.parse('$baseUrl/cards/$cardId/toggle-freeze'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // Delete Card
  static Future<Map<String, dynamic>> deleteCard(int cardId) async {
    final r = await http.post(Uri.parse('$baseUrl/cards/$cardId/delete'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // Update Card Settings
  static Future<Map<String, dynamic>> updateCardSettings(int cardId, Map<String, dynamic> settings) async {
    final r = await http.patch(Uri.parse('$baseUrl/cards/$cardId/settings'), headers: await _headers(), body: jsonEncode(settings));
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // Download Wallet Pass
  static Future<dynamic> downloadWalletPass(int cardId) async {
    try {
      final r = await http.get(Uri.parse('$baseUrl/cards/$cardId/wallet-pass'), headers: await _headers());
      return r.statusCode == 200 ? r.bodyBytes : null;
    } catch (_) { return null; }
  }

  // Notifications
  static Future<Map<String, dynamic>> getNotifications() async {
    final r = await http.get(Uri.parse('$baseUrl/notifications'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // Wallets
  static Future<Map<String, dynamic>> getAvailableWallets() async {
    final r = await http.get(Uri.parse('$baseUrl/wallets/available'), headers: await _headers());
    return {'success': r.statusCode == 200, ...jsonDecode(r.body)};
  }

  static Future<Map<String, dynamic>> openWallet(String currencyCode) async {
    final r = await http.post(Uri.parse('$baseUrl/wallets/open'),
      headers: await _headers(), body: jsonEncode({'currency_code': currencyCode}));
    return {'success': r.statusCode == 201, ...jsonDecode(r.body)};
  }

  // FCM Token
  static Future<void> updateFcmToken(String token, {String? platform, String? apnsToken}) async {
    try {
      final headers = await _headers();
      debugPrint('🔔 Sending FCM token to server...');
      debugPrint('🔔 Auth header present: ${headers.containsKey('Authorization')}');
      final body = {
        'fcm_token': token,
        'device_platform': platform ?? (Platform.isIOS ? 'ios' : 'android'),
      };
      if (apnsToken != null) {
        body['apns_token'] = apnsToken;
      }
      final r = await http.post(
        Uri.parse('$baseUrl/fcm-token'),
        headers: headers,
        body: jsonEncode(body),
      );
      debugPrint('🔔 FCM token update response: ${r.statusCode} - ${r.body}');
      if (r.statusCode != 200) {
        // Retry after delay (auth token might not be stored yet)
        await Future.delayed(const Duration(seconds: 3));
        final retryHeaders = await _headers();
        final r2 = await http.post(
          Uri.parse('$baseUrl/fcm-token'),
          headers: retryHeaders,
          body: jsonEncode(body),
        );
        debugPrint('🔔 FCM token retry response: ${r2.statusCode} - ${r2.body}');
      }
    } catch (e) {
      debugPrint('🔔 FCM token update error: $e');
    }
  }

  // Profile
  static Future<Map<String, dynamic>> getProfile() async {
    final r = await http.get(Uri.parse('$baseUrl/profile'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // Update Profile
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final r = await http.patch(Uri.parse('$baseUrl/profile'), headers: await _headers(), body: jsonEncode(data));
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // KYC
  static Future<Map<String, dynamic>> getKycStatus() async {
    final r = await http.get(Uri.parse('$baseUrl/kyc/status'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  static Future<Map<String, dynamic>> uploadKycDocuments({
    required String idFrontPath,
    required String idBackPath,
    required String selfiePath,
    String? addressProofPath,
  }) async {
    final t = await token;
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/kyc/upload'));
    request.headers.addAll({
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      if (t != null) 'Authorization': 'Bearer $t',
    });
    request.files.add(await http.MultipartFile.fromPath('id_front', idFrontPath));
    request.files.add(await http.MultipartFile.fromPath('id_back', idBackPath));
    request.files.add(await http.MultipartFile.fromPath('selfie', selfiePath));
    if (addressProofPath != null) {
      request.files.add(await http.MultipartFile.fromPath('address_proof', addressProofPath));
    }
    final response = await request.send();
    final body = await response.stream.bytesToString();
    return {'success': response.statusCode == 200, 'data': jsonDecode(body), 'status': response.statusCode};
  }


  // Generic POST (for new transfer lookup/execute endpoints)
  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async {
    final r = await http.post(Uri.parse('$baseUrl$path'), headers: await _headers(), body: jsonEncode(data));
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body), 'status': r.statusCode};
  }

  // Contacts
  static Future<Map<String, dynamic>> checkContacts(List<String> phones) async {
    try {
      final r = await http.post(Uri.parse('$baseUrl/contacts/check'), headers: await _headers(), body: jsonEncode({'phones': phones}));
      return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
    } catch (_) {
      return {'success': false, 'data': {'members': []}};
    }
  }

  static Future<Map<String, dynamic>> sendByPhone(String phone, double amount, String currency) async {
    final r = await http.post(Uri.parse('$baseUrl/transfer/by-phone'), headers: await _headers(), body: jsonEncode({
      'phone': phone, 'amount': amount, 'currency': currency,
    }));
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body), 'status': r.statusCode};
  }

  static Future<bool> isLoggedIn() async => await token != null;
}
