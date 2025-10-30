import 'package:ecliniq/ecliniq_api/doctor_service.dart';
import 'package:ecliniq/ecliniq_api/models/doctor.dart';
import 'package:flutter/material.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorService _doctorService = DoctorService();

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<Doctor> _doctors = [];
  double? _currentLatitude;
  double? _currentLongitude;
  String? _currentLocationName;


  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<Doctor> get doctors => _doctors;
  double? get currentLatitude => _currentLatitude;
  double? get currentLongitude => _currentLongitude;
  String? get currentLocationName => _currentLocationName;
  bool get hasDoctors => _doctors.isNotEmpty;
  bool get hasLocation => _currentLatitude != null && _currentLongitude != null;


  void setLocation({
    required double latitude,
    required double longitude,
    String? locationName,
  }) {
    _currentLatitude = latitude;
    _currentLongitude = longitude;
    _currentLocationName = locationName;
    notifyListeners();
  }


  void clearLocation() {
    _currentLatitude = null;
    _currentLongitude = null;
    _currentLocationName = null;
    notifyListeners();
  }


  Future<void> fetchTopDoctors({
    required double latitude,
    required double longitude,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _doctorService.getTopDoctors(
        latitude: latitude,
        longitude: longitude,
      );

      if (response.success) {
        if (isRefresh) {
          _doctors = response.data;
        } else {
          _doctors.addAll(response.data);
        }
        

        setLocation(
          latitude: latitude,
          longitude: longitude,
        );
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch doctors: $e';
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }


  Future<void> refreshDoctors() async {
    if (_currentLatitude != null && _currentLongitude != null) {
      await fetchTopDoctors(
        latitude: _currentLatitude!,
        longitude: _currentLongitude!,
        isRefresh: true,
      );
    }
  }


  void clearData() {
    _doctors.clear();
    _errorMessage = null;
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }


  Future<void> retry() async {
    if (_currentLatitude != null && _currentLongitude != null) {
      await fetchTopDoctors(
        latitude: _currentLatitude!,
        longitude: _currentLongitude!,
        isRefresh: true,
      );
    }
  }
}
