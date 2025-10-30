import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check permission
      LocationPermission permission = await checkLocationPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestLocationPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get location name from coordinates
  Future<String?> getLocationName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String locationName = '';
        
        if (place.locality != null && place.locality!.isNotEmpty) {
          locationName = place.locality!;
        } else if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
          locationName = place.subAdministrativeArea!;
        } else if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          locationName = place.administrativeArea!;
        }
        
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          locationName = '$locationName, ${place.subLocality}';
        }
        
        return locationName.isNotEmpty ? locationName : 'Current Location';
      }
      
      return 'Current Location';
    } catch (e) {
      return 'Current Location';
    }
  }

  /// Open app settings for permission
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  /// Check if permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied() async {
    LocationPermission permission = await checkLocationPermission();
    return permission == LocationPermission.deniedForever;
  }
}
