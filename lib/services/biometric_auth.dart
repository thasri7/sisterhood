import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricAuth {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Check if biometric authentication is available
  static Future<bool> isAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  // Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  // Authenticate with biometric
  static Future<bool> authenticate({
    required String reason,
    String? cancelButton,
  }) async {
    try {
      final bool isAvailable = await BiometricAuth.isAvailable();
      if (!isAvailable) return false;

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: reason,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Biometric Authentication',
            cancelButton: 'Cancel',
            deviceCredentialsRequiredTitle: 'Device Credentials Required',
            deviceCredentialsSetupDescription: 'Device credentials are not set up on your device. Go to \'Settings > Security\' to set up a screen lock.',
            goToSettingsButton: 'Go to Settings',
            goToSettingsDescription: 'Please set up a screen lock on your device.',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
            goToSettingsButton: 'Go to Settings',
            goToSettingsMessage: 'Please set up Touch ID or Face ID on your device.',
            lockOut: 'Please reenable your Touch ID or Face ID',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }

  // Set up biometric authentication for the app
  static Future<bool> setupBiometricAuth() async {
    try {
      final bool isAvailable = await BiometricAuth.isAvailable();
      if (!isAvailable) return false;

      // Test authentication
      final bool didAuthenticate = await authenticate(
        reason: 'Set up biometric authentication for Sisterhood App',
      );

      if (didAuthenticate) {
        // Save biometric preference
        await _secureStorage.write(
          key: 'biometric_enabled',
          value: 'true',
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Check if biometric is enabled
  static Future<bool> isBiometricEnabled() async {
    try {
      final String? enabled = await _secureStorage.read(key: 'biometric_enabled');
      return enabled == 'true';
    } catch (e) {
      return false;
    }
  }

  // Disable biometric authentication
  static Future<void> disableBiometricAuth() async {
    await _secureStorage.delete(key: 'biometric_enabled');
  }

  // Authenticate for app access
  static Future<bool> authenticateForAppAccess() async {
    try {
      final bool isEnabled = await isBiometricEnabled();
      if (!isEnabled) return true; // If not enabled, allow access

      final bool isAvailable = await BiometricAuth.isAvailable();
      if (!isAvailable) return true; // If not available, allow access

      return await authenticate(
        reason: 'Access Sisterhood App',
        cancelButton: 'Cancel',
      );
    } catch (e) {
      return true; // On error, allow access
    }
  }

  // Authenticate for sensitive operations
  static Future<bool> authenticateForSensitiveOperation(String operation) async {
    try {
      final bool isEnabled = await isBiometricEnabled();
      if (!isEnabled) return true;

      final bool isAvailable = await BiometricAuth.isAvailable();
      if (!isAvailable) return true;

      return await authenticate(
        reason: 'Authenticate for $operation',
        cancelButton: 'Cancel',
      );
    } catch (e) {
      return true;
    }
  }
}
