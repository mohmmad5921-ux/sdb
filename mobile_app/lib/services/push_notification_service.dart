import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../main.dart' show navigatorKey;
import 'api_service.dart';

class PushNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Initialize push notifications: request permission, get token, listen for messages
  static Future<void> initialize() async {
    try {
      // Request permission (iOS)
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('🔔 Push permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('🔔 Push notifications denied by user');
        return;
      }

      // On iOS, wait for APNS token before getting FCM token
      if (Platform.isIOS) {
        String? apnsToken;
        for (int i = 0; i < 10; i++) {
          apnsToken = await _fcm.getAPNSToken();
          if (apnsToken != null) break;
          debugPrint('🔔 Waiting for APNS token... attempt ${i + 1}');
          await Future.delayed(const Duration(seconds: 1));
        }
        if (apnsToken == null) {
          debugPrint('🔔 APNS token not available after 10s — push may not work');
        } else {
          debugPrint('🔔 APNS token ready');
        }
      }

      // Get APNS token for iOS (to send directly via APNs)
      String? apnsTokenStr;
      if (Platform.isIOS) {
        apnsTokenStr = await _fcm.getAPNSToken();
        if (apnsTokenStr != null) {
          debugPrint('🔔 APNS Token: ${apnsTokenStr.substring(0, 20)}...');
        }
      }

      // Get FCM token
      final token = await _fcm.getToken();
      if (token != null) {
        debugPrint('🔔 FCM Token: ${token.substring(0, 20)}...');
        await _sendTokenToServer(token, apnsToken: apnsTokenStr);
      } else {
        debugPrint('🔔 FCM Token is null — sending APNs token only');
        // Still send APNs token even without FCM token
        if (apnsTokenStr != null) {
          await _sendTokenToServer(null, apnsToken: apnsTokenStr);
        }
      }

      // Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) async {
        debugPrint('🔔 FCM Token refreshed');
        String? newApns;
        if (Platform.isIOS) {
          newApns = await _fcm.getAPNSToken();
        }
        _sendTokenToServer(newToken, apnsToken: newApns);
      });

      // Handle foreground messages — show a snackbar/banner
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('🔔 Foreground message: ${message.notification?.title}');
        _showInAppNotification(message);
      });

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('🔔 Message opened app: ${message.notification?.title}');
        _navigateToNotifications();
      });

      // Handle notification tap when app was terminated
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('🔔 App launched from notification: ${initialMessage.notification?.title}');
        // Delay navigation to allow app to finish initializing
        Future.delayed(const Duration(seconds: 2), () {
          _navigateToNotifications();
        });
      }

    } catch (e) {
      debugPrint('🔔 Push init error: $e');
    }
  }

  /// Send FCM token to the backend
  static Future<void> _sendTokenToServer(String? token, {String? apnsToken}) async {
    try {
      final platform = Platform.isIOS ? 'ios' : 'android';
      await ApiService.updateFcmToken(token, platform: platform, apnsToken: apnsToken);
      debugPrint('🔔 FCM token sent to server (platform: $platform, fcm: ${token != null}, apns: ${apnsToken != null})');
    } catch (e) {
      debugPrint('🔔 Failed to send FCM token: $e');
    }
  }

  /// Navigate to the notifications screen
  static void _navigateToNotifications() {
    try {
      final nav = navigatorKey.currentState;
      if (nav != null) {
        nav.pushNamed('/notifications');
        debugPrint('🔔 Navigated to /notifications');
      } else {
        debugPrint('🔔 Navigator not available yet');
      }
    } catch (e) {
      debugPrint('🔔 Navigation error: $e');
    }
  }

  /// Show an in-app notification banner when a message arrives while app is open
  static void _showInAppNotification(RemoteMessage message) {
    final nav = navigatorKey.currentState;
    if (nav == null) return;

    final context = nav.context;
    final title = message.notification?.title ?? 'SDB';
    final body = message.notification?.body ?? '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            _navigateToNotifications();
          },
          child: Row(
            children: [
              const Icon(Icons.notifications_active, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                    if (body.isNotEmpty)
                      Text(body, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white70, size: 20),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A3A5C),
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }
}
