import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:permission_handler/permission_handler.dart';

/// Manager to handle media permissions (camera, photos, files) for health files upload
class MediaPermissionManager {
  /// Request all media permissions upfront
  /// This should be called when user enters the health files page
  static Future<MediaPermissionStatus> requestAllPermissions() async {
    if (kIsWeb) {
      return MediaPermissionStatus.allGranted;
    }

    try {
      // On iOS, request permissions one at a time to avoid conflicts
      // Request camera permission first
      final cameraStatus = await _requestCameraPermission();
      
      // Add a small delay on iOS to ensure system dialogs don't conflict
      if (Platform.isIOS) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
      
      // Request photos permission
      final photosStatus = await _requestPhotosPermission();
      
      // Files permission is handled by file_picker itself, no need to request here
      
      // Determine overall status
      if (cameraStatus == MediaPermissionResult.granted && 
          photosStatus == MediaPermissionResult.granted) {
        return MediaPermissionStatus.allGranted;
      } else if (cameraStatus == MediaPermissionResult.permanentlyDenied ||
                 photosStatus == MediaPermissionResult.permanentlyDenied) {
        return MediaPermissionStatus.somePermanentlyDenied;
      } else if (cameraStatus == MediaPermissionResult.denied ||
                 photosStatus == MediaPermissionResult.denied) {
        return MediaPermissionStatus.someDenied;
      } else {
        return MediaPermissionStatus.partialGranted;
      }
    } catch (e) {
      debugPrint('Error in requestAllPermissions: $e');
      return MediaPermissionStatus.error;
    }
  }

  /// Request camera permission
  static Future<MediaPermissionResult> _requestCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      
      debugPrint('Camera permission current status: $status');
      
      // If already granted or limited, return granted
      if (status.isGranted || status.isLimited) {
        return MediaPermissionResult.granted;
      }
      
      // If permanently denied, return permanently denied (user must go to Settings)
      if (status.isPermanentlyDenied) {
        debugPrint('Camera permission is permanently denied');
        return MediaPermissionResult.permanentlyDenied;
      }
      
      // On iOS, if status is denied (was denied before), requesting again might make it permanently denied
      // So we should only request if status is notDetermined (never asked)
      // On Android, we can request even if denied
      if (Platform.isIOS && status.isDenied) {
        // On iOS, if already denied once, don't request again to avoid permanent denial
        // Instead, return denied so the caller can handle it appropriately
        debugPrint('Camera permission was previously denied on iOS. User must grant in Settings.');
        return MediaPermissionResult.denied;
      }
      
      // Request permission - this will show the system dialog
      // This will only happen if status is notDetermined (first time request) or on Android
      debugPrint('Requesting camera permission. Current status: $status, isNotDetermined:');
      final newStatus = await Permission.camera.request();
      debugPrint('Camera permission request result: $newStatus');
      
      if (newStatus.isGranted || newStatus.isLimited) {
        return MediaPermissionResult.granted;
      } else if (newStatus.isPermanentlyDenied) {
        return MediaPermissionResult.permanentlyDenied;
      } else {
        return MediaPermissionResult.denied;
      }
    } catch (e) {
      // Log error for debugging
      debugPrint('Error requesting camera permission: $e');
      return MediaPermissionResult.error;
    }
  }

  /// Request photos permission
  static Future<MediaPermissionResult> _requestPhotosPermission() async {
    try {
      final status = await Permission.photos.status;
      
      debugPrint('Photos permission current status: $status');
      
      // If already granted or limited, return granted
      if (status.isGranted || status.isLimited) {
        return MediaPermissionResult.granted;
      }
      
      // If permanently denied, return permanently denied (user must go to Settings)
      if (status.isPermanentlyDenied) {
        debugPrint('Photos permission is permanently denied');
        return MediaPermissionResult.permanentlyDenied;
      }
      
      // On iOS, if status is denied (was denied before), requesting again might make it permanently denied
      // So we should only request if status is notDetermined (never asked)
      // On Android, we can request even if denied
      if (Platform.isIOS && status.isDenied) {
        // On iOS, if already denied once, don't request again to avoid permanent denial
        // Instead, return denied so the caller can handle it appropriately
        debugPrint('Photos permission was previously denied on iOS. User must grant in Settings.');
        return MediaPermissionResult.denied;
      }
      
      // Request permission - this will show the system dialog
      // This will only happen if status is notDetermined (first time request) or on Android
      debugPrint('Requesting photos permission. Current status: $status, isNotDetermined: ');
      final newStatus = await Permission.photos.request();
      debugPrint('Photos permission request result: $newStatus');
      
      if (newStatus.isGranted || newStatus.isLimited) {
        return MediaPermissionResult.granted;
      } else if (newStatus.isPermanentlyDenied) {
        return MediaPermissionResult.permanentlyDenied;
      } else {
        return MediaPermissionResult.denied;
      }
    } catch (e) {
      // Log error for debugging
      debugPrint('Error requesting photos permission: $e');
      return MediaPermissionResult.error;
    }
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraGranted() async {
    if (kIsWeb) return true;
    try {
      final status = await Permission.camera.status;
      return status.isGranted || status.isLimited;
    } catch (e) {
      return false;
    }
  }

  /// Check if photos permission is granted
  static Future<bool> isPhotosGranted() async {
    if (kIsWeb) return true;
    try {
      final status = await Permission.photos.status;
      return status.isGranted || status.isLimited;
    } catch (e) {
      return false;
    }
  }

  /// Check if a specific permission is permanently denied
  static Future<bool> isPermanentlyDenied(Permission permission) async {
    if (kIsWeb) return false;
    try {
      final status = await permission.status;
      return status.isPermanentlyDenied;
    } catch (e) {
      return false;
    }
  }

  /// Get permission status for a specific permission
  static Future<MediaPermissionResult> getPermissionStatus(Permission permission) async {
    if (kIsWeb) return MediaPermissionResult.granted;
    try {
      final status = await permission.status;
      if (status.isGranted || status.isLimited) {
        return MediaPermissionResult.granted;
      } else if (status.isPermanentlyDenied) {
        return MediaPermissionResult.permanentlyDenied;
      } else if (status.isDenied) {
        return MediaPermissionResult.denied;
      } else {
        return MediaPermissionResult.denied;
      }
    } catch (e) {
      return MediaPermissionResult.error;
    }
  }

  /// Request a specific permission
  static Future<MediaPermissionResult> requestPermission(Permission permission) async {
    if (kIsWeb) return MediaPermissionResult.granted;
    try {
      final status = await permission.status;
      
      debugPrint('Permission $permission current status: $status');
      
      // If already granted or limited, return granted
      if (status.isGranted || status.isLimited) {
        return MediaPermissionResult.granted;
      }
      
      // If permanently denied, return permanently denied (user must go to Settings)
      if (status.isPermanentlyDenied) {
        debugPrint('Permission $permission is permanently denied');
        return MediaPermissionResult.permanentlyDenied;
      }
      
      // On iOS, if status is denied (was denied before), requesting again might make it permanently denied
      // So we should only request if status is notDetermined (never asked)
      // On Android, we can request even if denied
      if (Platform.isIOS && status.isDenied) {
        // On iOS, if already denied once, don't request again to avoid permanent denial
        // Instead, return denied so the caller can show Settings dialog
        debugPrint('Permission $permission was previously denied on iOS. User must grant in Settings.');
        return MediaPermissionResult.denied;
      }
      
      // Request permission - this will show the system dialog
      // This will only happen if status is notDetermined (first time request) or on Android
      debugPrint('Requesting permission $permission. Current status: $status');
      final newStatus = await permission.request();
      debugPrint('Permission $permission request result: $newStatus');
      
      if (newStatus.isGranted || newStatus.isLimited) {
        return MediaPermissionResult.granted;
      } else if (newStatus.isPermanentlyDenied) {
        return MediaPermissionResult.permanentlyDenied;
      } else {
        return MediaPermissionResult.denied;
      }
    } catch (e) {
      debugPrint('Error requesting permission $permission: $e');
      return MediaPermissionResult.error;
    }
  }
}

/// Overall status of media permissions
enum MediaPermissionStatus {
  allGranted,
  partialGranted,
  someDenied,
  somePermanentlyDenied,
  error,
}

/// Result of a single permission request
enum MediaPermissionResult {
  granted,
  denied,
  permanentlyDenied,
  error,
}

