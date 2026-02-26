import 'dart:convert';
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

  // Notifications
  static Future<Map<String, dynamic>> getNotifications() async {
    final r = await http.get(Uri.parse('$baseUrl/notifications'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  // Profile
  static Future<Map<String, dynamic>> getProfile() async {
    final r = await http.get(Uri.parse('$baseUrl/profile'), headers: await _headers());
    return {'success': r.statusCode == 200, 'data': jsonDecode(r.body)};
  }

  static Future<bool> isLoggedIn() async => await token != null;
}
