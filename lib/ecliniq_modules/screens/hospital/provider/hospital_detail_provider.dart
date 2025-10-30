import 'package:ecliniq/ecliniq_api/hospital_service.dart';
import 'package:ecliniq/ecliniq_api/models/hospital.dart';
import 'package:flutter/material.dart';

class HospitalDetailProvider with ChangeNotifier {
  final HospitalService _hospitalService = HospitalService();

  bool _isLoading = false;
  String? _errorMessage;
  HospitalDetail? _hospitalDetail;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  HospitalDetail? get hospitalDetail => _hospitalDetail;
  bool get hasHospitalDetail => _hospitalDetail != null;

  Future<void> fetchHospitalDetails({
    required String hospitalId,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _hospitalService.getHospitalDetails(
        hospitalId: hospitalId,
      );

      if (response.success && response.data != null) {
        _hospitalDetail = response.data;
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
        _hospitalDetail = null;
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch hospital details: $e';
      _hospitalDetail = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _hospitalDetail = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> retry({required String hospitalId}) async {
    await fetchHospitalDetails(hospitalId: hospitalId);
  }
}

