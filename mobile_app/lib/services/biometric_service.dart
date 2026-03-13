import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();
  static const _storage = FlutterSecureStorage();
  static const _enabledKey = 'biometric_enabled';

  /// Check if device supports biometrics
  static Future<bool> isAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } catch (e) {
      debugPrint('🔐 Biometric availability check error: $e');
      return false;
    }
  }

  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('🔐 Get biometrics error: $e');
      return [];
    }
  }

  /// Check if user has enabled biometric login
  static Future<bool> isEnabled() async {
    final val = await _storage.read(key: _enabledKey) ?? 'false';
    return val == 'true';
  }

  /// Enable or disable biometric login
  static Future<void> setEnabled(bool enabled) async {
    await _storage.write(key: _enabledKey, value: enabled.toString());
  }

  /// Authenticate with biometrics
  static Future<bool> authenticate({String reason = 'تحقق من هويتك للدخول'}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
          sensitiveTransaction: false,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('🔐 Biometric PlatformException: $e');
      return false;
    } catch (e) {
      debugPrint('🔐 Biometric general error: $e');
      return false;
    }
  }

  /// Check if Face ID
  static Future<bool> isFaceId() async {
    final types = await getAvailableBiometrics();
    return types.contains(BiometricType.face);
  }

  /// Get label
  static Future<String> getBiometricLabel() async {
    final types = await getAvailableBiometrics();
    if (types.contains(BiometricType.face)) return 'Face ID';
    if (types.contains(BiometricType.fingerprint)) return 'بصمة الإصبع';
    return 'المصادقة البيومترية';
  }
}
