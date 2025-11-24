// ignore_for_file: empty_catches

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecliniq/ecliniq_core/location/location_service.dart';

/// Manager to handle location permissions and avoid repeated requests
class LocationPermissionManager {
  static const String _keyLocationPermissionAsked = 'location_permission_asked';
  static const String _keyLocationPermissionGranted = 'location_permission_granted';
  static const String _keyLocationPermissionDeniedForever = 'location_permission_denied_forever';

  final LocationService _locationService = LocationService();

  /// Check if location permission has been asked before
  static Future<bool> hasAskedForPermission() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyLocationPermissionAsked) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check if location permission is granted
  static Future<bool> isPermissionGranted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getBool(_keyLocationPermissionGranted);
      
      if (stored != null) {
        return stored;
      }
      
      // If not stored, check actual permission status
      final permission = await Geolocator.checkPermission();
      final isGranted = permission == LocationPermission.whileInUse || 
                       permission == LocationPermission.always;
      
      // Store the result
      await prefs.setBool(_keyLocationPermissionGranted, isGranted);
      
      return isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Check if location permission is permanently denied
  static Future<bool> isPermissionDeniedForever() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getBool(_keyLocationPermissionDeniedForever);
      
      if (stored != null) {
        return stored;
      }
      
      // Check actual permission status
      final permission = await Geolocator.checkPermission();
      final isDeniedForever = permission == LocationPermission.deniedForever;
      
      // Store the result
      await prefs.setBool(_keyLocationPermissionDeniedForever, isDeniedForever);
      
      return isDeniedForever;
    } catch (e) {
      return false;
    }
  }

  /// Request location permission (only if not already asked or denied forever)
  static Future<LocationPermissionStatus> requestPermissionIfNeeded() async {
    try {
      // Check if permission is already granted
      final isGranted = await isPermissionGranted();
      if (isGranted) {
        return LocationPermissionStatus.granted;
      }

      // Check if permanently denied
      final isDeniedForever = await isPermissionDeniedForever();
      if (isDeniedForever) {
        return LocationPermissionStatus.deniedForever;
      }

      // Check if we've asked before
      
      // Request permission
      final permission = await Geolocator.requestPermission();
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool(_keyLocationPermissionAsked, true);
      
      final isGrantedNow = permission == LocationPermission.whileInUse || 
                          permission == LocationPermission.always;
      final isDeniedForeverNow = permission == LocationPermission.deniedForever;
      
      await prefs.setBool(_keyLocationPermissionGranted, isGrantedNow);
      await prefs.setBool(_keyLocationPermissionDeniedForever, isDeniedForeverNow);
      
      if (isGrantedNow) {
        return LocationPermissionStatus.granted;
      } else if (isDeniedForeverNow) {
        return LocationPermissionStatus.deniedForever;
      } else {
        return LocationPermissionStatus.denied;
      }
    } catch (e) {
      return LocationPermissionStatus.error;
    }
  }

  /// Get current location if permission is granted
  Future<Position?> getCurrentLocationIfGranted() async {
    try {
      final isGranted = await isPermissionGranted();
      if (!isGranted) {
        return null;
      }
      
      return await _locationService.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  /// Reset permission status (useful for testing or if user changes settings)
  static Future<void> resetPermissionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyLocationPermissionAsked);
      await prefs.remove(_keyLocationPermissionGranted);
      await prefs.remove(_keyLocationPermissionDeniedForever);
    } catch (e) {
    }
  }
}

/// Status of location permission
enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  error,
}

