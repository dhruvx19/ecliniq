import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  
  Future<Position?> getCurrentPosition() async {
    try {
      
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      
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

      
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  
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

  
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  
  Future<bool> isPermissionPermanentlyDenied() async {
    LocationPermission permission = await checkLocationPermission();
    return permission == LocationPermission.deniedForever;
  }
}
