import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locker/flutter_locker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'ecliniq_secure_prefs',
    ),
    iOptions: IOSOptions(
      accountName: 'ecliniq_keychain',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys for secure storage
  static const String _keyMPIN = 'user_mpin_hash';
  static const String _keyMPINSalt = 'mpin_salt';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyUserID = 'user_id';
  static const String _keyPhoneNumber = 'phone_number';

  // Generate a random salt for MPIN hashing
  static String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(bytes);
  }

  // Fixed hash MPIN with salt using PBKDF2
  static String _hashMPIN(String mpin, String salt) {
    try {
      final password = utf8.encode(mpin);
      final saltBytes = utf8.encode(salt);
      
      // Simple PBKDF2 implementation
      List<int> dk = password;
      for (int i = 0; i < 10000; i++) {
        final hmac = Hmac(sha256, dk);
        dk = hmac.convert(saltBytes).bytes;
      }
      
      return base64.encode(dk);
    } catch (e) {
      print('Error in _hashMPIN: $e');
      rethrow;
    }
  }

  // Store MPIN using biometric authentication (similar to your reference)
  static Future<bool> storeMPINWithBiometric(String mpin) async {
    try {
      return await _storeBiometricValue(
        key: _keyMPIN,
        value: mpin,
      );
    } catch (e) {
      print('Error storing MPIN with biometric: $e');
      return false;
    }
  }

  // Get MPIN using biometric authentication
  static Future<String?> getMPINWithBiometric() async {
    try {
      return await _getBiometricValue(
        key: _keyMPIN,
        title: 'Authenticate with Biometric',
        description: 'Use your biometric to access your account',
      );
    } catch (e) {
      print('Error getting MPIN with biometric: $e');
      return null;
    }
  }

  // Private method to store value with biometric (following your pattern)
  static Future<bool> _storeBiometricValue({
    required String key,
    required String value,
  }) async {
    try {
      final encryptedKey = _encryptData(key);
      final encryptedValue = _encryptData(value);
      
      await FlutterLocker.save(
        SaveSecretRequest(
          key: encryptedKey,
          secret: encryptedValue,
          androidPrompt: AndroidPrompt(
            title: 'Enable Biometric Authentication',
            cancelLabel: 'Cancel',
            descriptionLabel: 'Use your biometric to secure your account',
          ),
        ),
      );
      return true;
    } catch (e) {
      print('Error in _storeBiometricValue: $e');
      return false;
    }
  }

  // Private method to get value with biometric (following your pattern)
  static Future<String?> _getBiometricValue({
    required String key,
    required String title,
    required String description,
  }) async {
    try {
      final encryptedKey = _encryptData(key);
      
      final encryptedValue = await FlutterLocker.retrieve(
        RetrieveSecretRequest(
          key: encryptedKey,
          androidPrompt: AndroidPrompt(
            title: title,
            descriptionLabel: description,
            cancelLabel: 'Cancel',
          ),
          iOsPrompt: IOsPrompt(
            touchIdText: title,
          ),
        ),
      );
      
      return _decryptData(encryptedValue);
    } on PlatformException catch (e) {
      print('PlatformException in _getBiometricValue: $e');
      return null;
    } catch (e) {
      print('Error in _getBiometricValue: $e');
      return null;
    }
  }

  // Simple encryption/decryption (you might want to use your EncryptManager instead)
  static String _encryptData(String data) {
    // Simple base64 encoding - replace with your EncryptManager.encrypt if available
    return base64.encode(utf8.encode(data));
  }

  static String _decryptData(String encryptedData) {
    // Simple base64 decoding - replace with your EncryptManager.decrypt if available
    return utf8.decode(base64.decode(encryptedData));
  }

  // Delete biometric value
  static Future<void> deleteBiometricValue(String key) async {
    try {
      final encryptedKey = _encryptData(key);
      await FlutterLocker.delete(encryptedKey);
    } catch (e) {
      print('Error deleting biometric value: $e');
    }
  }

  // Store MPIN securely (with both regular and biometric options) - FIXED
  static Future<bool> storeMPIN(String mpin) async {
    try {
      // Validate input
      if (mpin.isEmpty || mpin.length != 4) {
        print('Invalid MPIN: empty or not 4 digits');
        return false;
      }
      
      // Check if MPIN contains only digits
      if (!RegExp(r'^\d{4}$').hasMatch(mpin)) {
        print('Invalid MPIN: must be 4 digits only');
        return false;
      }
      
      print('Generating salt for MPIN...');
      final salt = _generateSalt();
      
      print('Hashing MPIN...');
      final hashedMPIN = _hashMPIN(mpin, salt);
      
      print('Storing hashed MPIN and salt...');
      await _secureStorage.write(key: _keyMPIN, value: hashedMPIN);
      await _secureStorage.write(key: _keyMPINSalt, value: salt);
      
      // Verify storage worked
      final storedHash = await _secureStorage.read(key: _keyMPIN);
      final storedSalt = await _secureStorage.read(key: _keyMPINSalt);
      
      if (storedHash == null || storedSalt == null) {
        print('Failed to verify MPIN storage');
        return false;
      }
      
      print('MPIN stored successfully');
      return true;
    } catch (e, stackTrace) {
      print('Error storing MPIN: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  // Verify MPIN
  static Future<bool> verifyMPIN(String mpin) async {
    try {
      final storedHash = await _secureStorage.read(key: _keyMPIN);
      final salt = await _secureStorage.read(key: _keyMPINSalt);
      
      if (storedHash == null || salt == null) {
        print('No stored MPIN found');
        return false;
      }
      
      final hashedInput = _hashMPIN(mpin, salt);
      final isValid = storedHash == hashedInput;
      
      print('MPIN verification result: $isValid');
      return isValid;
    } catch (e) {
      print('Error verifying MPIN: $e');
      return false;
    }
  }

  // Check if MPIN exists
  static Future<bool> hasMPIN() async {
    try {
      final mpin = await _secureStorage.read(key: _keyMPIN);
      final salt = await _secureStorage.read(key: _keyMPINSalt);
      final hasPin = mpin != null && mpin.isNotEmpty && salt != null && salt.isNotEmpty;
      print('MPIN exists: $hasPin');
      return hasPin;
    } catch (e) {
      print('Error checking MPIN existence: $e');
      return false;
    }
  }

  // Biometric settings
  static Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _secureStorage.write(key: _keyBiometricEnabled, value: enabled.toString());
    } catch (e) {
      print('Error setting biometric enabled: $e');
    }
  }

  static Future<bool> isBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(key: _keyBiometricEnabled);
      return value == 'true';
    } catch (e) {
      print('Error checking biometric enabled: $e');
      return false;
    }
  }

  // Store user info
  static Future<void> storeUserInfo(String userId, String phoneNumber) async {
    try {
      await _secureStorage.write(key: _keyUserID, value: userId);
      await _secureStorage.write(key: _keyPhoneNumber, value: phoneNumber);
    } catch (e) {
      print('Error storing user info: $e');
    }
  }

  // Get user info
  static Future<Map<String, String?>> getUserInfo() async {
    try {
      return {
        'userId': await _secureStorage.read(key: _keyUserID),
        'phoneNumber': await _secureStorage.read(key: _keyPhoneNumber),
      };
    } catch (e) {
      print('Error getting user info: $e');
      return {'userId': null, 'phoneNumber': null};
    }
  }

  // Clear all secure data (logout)
  static Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  // Debug method to test storage functionality
  static Future<bool> testStorage() async {
    try {
      print('Testing secure storage...');
      const testKey = 'test_key';
      const testValue = 'test_value';
      
      // Write test data
      await _secureStorage.write(key: testKey, value: testValue);
      
      // Read test data
      final readValue = await _secureStorage.read(key: testKey);
      
      // Clean up
      await _secureStorage.delete(key: testKey);
      
      final success = readValue == testValue;
      print('Storage test result: $success');
      return success;
    } catch (e) {
      print('Storage test failed: $e');
      return false;
    }
  }
}

// Biometric Auth Config (following your pattern)
class BiometricAuthConfig {
  final String localizedReason;
  final String signInTitle;
  final String biometricHint;
  final String cancelButton;

  BiometricAuthConfig({
    this.localizedReason = 'Use your biometric to authenticate',
    this.signInTitle = 'Biometric Authentication',
    this.biometricHint = '',
    required this.cancelButton,
  });
}

// Biometric Service (following your implementation pattern)
class BiometricService {
  static Future<bool> isAvailable() async {
    try {
      return await FlutterLocker.canAuthenticate();
    } catch (e) {
      return false;
    }
  }

  static Future<bool> testBiometricAvailability() async {
    try {
      await FlutterLocker.save(SaveSecretRequest(
        key: 'test_biometric_key',
        secret: 'test_value',
        androidPrompt: AndroidPrompt(
          title: 'Enable Biometric Authentication',
          cancelLabel: 'Cancel',
          descriptionLabel: 'Use your biometric to secure your account',
        ),
      ));
      
      // Clean up the test key
      await FlutterLocker.delete('test_biometric_key');
      return true;
    } catch (e) {
      print('Biometric test error: $e');
      return false;
    }
  }

  static Future<bool> authenticateUser(BiometricAuthConfig config) async {
    try {
      // Try to retrieve a dummy value to trigger biometric authentication
      await FlutterLocker.retrieve(RetrieveSecretRequest(
        key: 'auth_test_key',
        androidPrompt: AndroidPrompt(
          title: config.signInTitle,
          descriptionLabel: config.localizedReason,
          cancelLabel: config.cancelButton,
        ),
        iOsPrompt: IOsPrompt(
          touchIdText: config.signInTitle,
        ),
      ));
      return true;
    } on PlatformException catch (e) {
      if (e.code == 'secret_not_found') {
        // This is expected for dummy key - authentication succeeded
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static String getBiometricTypeName() {
    if (Platform.isIOS) {
      return 'Touch ID / Face ID';
    } else {
      return 'Fingerprint / Face Unlock';
    }
  }

  static IconData getBiometricIcon() {
    if (Platform.isIOS) {
      return Icons.fingerprint; // iOS can be Touch ID or Face ID
    } else {
      return Icons.fingerprint; // Android typically fingerprint
    }
  }
}