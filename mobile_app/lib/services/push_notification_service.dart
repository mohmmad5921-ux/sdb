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

      // Get FCM token
      final token = await _fcm.getToken();
      if (token != null) {
        debugPrint('🔔 FCM Token: ${token.substring(0, 20)}...');
        await _sendTokenToServer(token);
      }

      // Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        debugPrint('🔔 FCM Token refreshed');
        _sendTokenToServer(newToken);
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
  static Future<void> _sendTokenToServer(String token) async {
    try {
      await ApiService.updateFcmToken(token);
      debugPrint('🔔 FCM token sent to server');
    } catch (e) {
      debugPrint('🔔 Failed to send FCM token: $e');
    }
  }
}
