import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
        debugPrint('🔔 FCM Token is null');
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

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('🔔 Foreground message: ${message.notification?.title}');
        // Could show a local notification here
      });

      // Handle background/terminated message taps
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('🔔 Message opened app: ${message.notification?.title}');
      });

    } catch (e) {
      debugPrint('🔔 Push init error: $e');
    }
  }

  /// Send FCM token to the backend
  static Future<void> _sendTokenToServer(String token, {String? apnsToken}) async {
    try {
      final platform = Platform.isIOS ? 'ios' : 'android';
      await ApiService.updateFcmToken(token, platform: platform, apnsToken: apnsToken);
      debugPrint('🔔 FCM token sent to server (platform: $platform)');
    } catch (e) {
      debugPrint('🔔 Failed to send FCM token: $e');
    }
  }
}

