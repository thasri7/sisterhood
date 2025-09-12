import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AppLock {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _pinKey = 'app_pin_hash';
  static const String _lockEnabledKey = 'app_lock_enabled';
  static const String _lockTimeoutKey = 'lock_timeout';
  
  // Default timeout: 5 minutes
  static const int defaultTimeoutMinutes = 5;

  // Set up PIN
  static Future<bool> setupPin(String pin) async {
    try {
      if (pin.length < 4) return false;

      // Hash the PIN for security
      final bytes = utf8.encode(pin);
      final digest = sha256.convert(bytes);
      final pinHash = digest.toString();

      // Store hashed PIN
      await _secureStorage.write(key: _pinKey, value: pinHash);
      
      // Enable app lock
      await _secureStorage.write(key: _lockEnabledKey, value: 'true');
      
      // Set default timeout
      await _secureStorage.write(
        key: _lockTimeoutKey, 
        value: defaultTimeoutMinutes.toString(),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  // Verify PIN
  static Future<bool> verifyPin(String pin) async {
    try {
      final String? storedHash = await _secureStorage.read(key: _pinKey);
      if (storedHash == null) return false;

      // Hash the input PIN
      final bytes = utf8.encode(pin);
      final digest = sha256.convert(bytes);
      final inputHash = digest.toString();

      return inputHash == storedHash;
    } catch (e) {
      return false;
    }
  }

  // Check if app lock is enabled
  static Future<bool> isLockEnabled() async {
    try {
      final String? enabled = await _secureStorage.read(key: _lockEnabledKey);
      return enabled == 'true';
    } catch (e) {
      return false;
    }
  }

  // Disable app lock
  static Future<void> disableLock() async {
    await _secureStorage.delete(key: _lockEnabledKey);
    await _secureStorage.delete(key: _pinKey);
  }

  // Change PIN
  static Future<bool> changePin(String oldPin, String newPin) async {
    try {
      // Verify old PIN first
      final bool isValid = await verifyPin(oldPin);
      if (!isValid) return false;

      // Set up new PIN
      return await setupPin(newPin);
    } catch (e) {
      return false;
    }
  }

  // Get lock timeout in minutes
  static Future<int> getLockTimeout() async {
    try {
      final String? timeout = await _secureStorage.read(key: _lockTimeoutKey);
      if (timeout != null) {
        return int.tryParse(timeout) ?? defaultTimeoutMinutes;
      }
      return defaultTimeoutMinutes;
    } catch (e) {
      return defaultTimeoutMinutes;
    }
  }

  // Set lock timeout
  static Future<void> setLockTimeout(int minutes) async {
    await _secureStorage.write(
      key: _lockTimeoutKey, 
      value: minutes.toString(),
    );
  }

  // Check if app should be locked
  static Future<bool> shouldLockApp() async {
    try {
      final bool isEnabled = await isLockEnabled();
      if (!isEnabled) return false;

      // Check if PIN is set
      final String? pinHash = await _secureStorage.read(key: _pinKey);
      if (pinHash == null) return false;

      // Check last unlock time
      final String? lastUnlock = await _secureStorage.read(key: 'last_unlock_time');
      if (lastUnlock == null) return true;

      final DateTime lastUnlockTime = DateTime.parse(lastUnlock);
      final int timeoutMinutes = await getLockTimeout();
      final DateTime timeoutTime = lastUnlockTime.add(Duration(minutes: timeoutMinutes));

      return DateTime.now().isAfter(timeoutTime);
    } catch (e) {
      return true; // On error, lock the app for security
    }
  }

  // Record successful unlock
  static Future<void> recordUnlock() async {
    await _secureStorage.write(
      key: 'last_unlock_time', 
      value: DateTime.now().toIso8601String(),
    );
  }

  // Lock the app immediately
  static Future<void> lockApp() async {
    await _secureStorage.delete(key: 'last_unlock_time');
  }

  // Get lock status info
  static Future<Map<String, dynamic>> getLockStatus() async {
    try {
      final bool isEnabled = await isLockEnabled();
      final bool shouldLock = await shouldLockApp();
      final int timeout = await getLockTimeout();
      final bool hasPin = await _secureStorage.read(key: _pinKey) != null;

      return {
        'isEnabled': isEnabled,
        'shouldLock': shouldLock,
        'timeoutMinutes': timeout,
        'hasPin': hasPin,
      };
    } catch (e) {
      return {
        'isEnabled': false,
        'shouldLock': false,
        'timeoutMinutes': defaultTimeoutMinutes,
        'hasPin': false,
      };
    }
  }
}
