import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for handling notification permissions
class NotificationPermissionHandler {
  /// Check if notification permission is granted
  /// @returns true if permission is granted, false otherwise
  static Future<bool> hasPermission() async {
    try {
      // Check Firebase messaging permission status
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      final isGranted = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      // Also check system permission (Android 13+)
      if (await Permission.notification.isGranted) {
        return isGranted;
      }

      return isGranted;
    } catch (e) {
      log('Error checking notification permission: $e');
      return false;
    }
  }

  /// Request notification permission
  /// @param openSettings - If true, opens app settings if permission is permanently denied
  /// @returns true if permission granted, false otherwise
  static Future<bool> requestPermission({bool openSettings = true}) async {
    try {
      // First check if already granted
      if (await hasPermission()) {
        return true;
      }

      // Request Firebase messaging permission (iOS)
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Request system notification permission (Android 13+)
      if (!await Permission.notification.isGranted) {
        final status = await Permission.notification.request();
        
        if (status.isPermanentlyDenied && openSettings) {
          log('Notification permission permanently denied, opening settings');
          await _openAppSettings();
          return false;
        }

        if (!status.isGranted) {
          log('Notification permission denied');
          return false;
        }
      }

      final isGranted = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      log('Notification permission status: ${settings.authorizationStatus}');
      return isGranted;
    } catch (e) {
      log('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Check if permission is permanently denied
  /// @returns true if permission is permanently denied
  static Future<bool> isPermanentlyDenied() async {
    try {
      final status = await Permission.notification.status;
      return status.isPermanentlyDenied;
    } catch (e) {
      log('Error checking if permission is permanently denied: $e');
      return false;
    }
  }

  /// Open app settings
  /// Uses permission_handler's openAppSettings() function
  static Future<void> _openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      log('Error opening app settings: $e');
    }
  }
}

