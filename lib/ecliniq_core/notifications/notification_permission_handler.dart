import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';


class NotificationPermissionHandler {
  
  
  static Future<bool> hasPermission() async {
    try {
      
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      final isGranted = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      
      if (await Permission.notification.isGranted) {
        return isGranted;
      }

      return isGranted;
    } catch (e) {
      log('Error checking notification permission: $e');
      return false;
    }
  }

  
  
  
  static Future<bool> requestPermission({bool openSettings = true}) async {
    try {
      
      if (await hasPermission()) {
        return true;
      }

      
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      
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

  
  
  static Future<bool> isPermanentlyDenied() async {
    try {
      final status = await Permission.notification.status;
      return status.isPermanentlyDenied;
    } catch (e) {
      log('Error checking if permission is permanently denied: $e');
      return false;
    }
  }

  
  
  static Future<void> _openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      log('Error opening app settings: $e');
    }
  }
}

