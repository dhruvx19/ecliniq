import 'dart:convert';

import 'package:ecliniq/ecliniq_api/models/doctor.dart';
import 'package:ecliniq/ecliniq_api/models/hospital.dart';
import 'package:ecliniq/ecliniq_api/src/endpoints.dart';
import 'package:http/http.dart' as http;

class HospitalService {
  Future<TopHospitalsResponse> getTopHospitals({
    required double latitude,
    required double longitude,
  }) async {
    try {
      const double defaultLatitude = 28.6139;
      const double defaultLongitude = 77.209;

      final url = Uri.parse(Endpoints.topHospitals);

      final requestBody = TopHospitalsRequest(
        latitude: defaultLatitude,
        longitude: defaultLongitude,
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return TopHospitalsResponse.fromJson(responseData);
      } else {
        return TopHospitalsResponse(
          success: false,
          message: 'Failed to fetch hospitals: ${response.statusCode}',
          data: [],
          errors: response.body,
          meta: null,
          timestamp: DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      return TopHospitalsResponse(
        success: false,
        message: 'Network error: $e',
        data: [],
        errors: e.toString(),
        meta: null,
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<HospitalDetailsResponse> getHospitalDetails({
    required String hospitalId,
  }) async {
    try {
      final url = Uri.parse(Endpoints.hospitalDetails(hospitalId));

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return HospitalDetailsResponse.fromJson(responseData);
      } else {
        return HospitalDetailsResponse(
          success: false,
          message: 'Failed to fetch hospital details: ${response.statusCode}',
          data: null,
          errors: response.body,
          meta: null,
          timestamp: DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      return HospitalDetailsResponse(
        success: false,
        message: 'Network error: $e',
        data: null,
        errors: e.toString(),
        meta: null,
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<TopDoctorsResponse> getHospitalDoctors({
    required String hospitalId,
  }) async {
    try {
      final url = Uri.parse(Endpoints.getAllDoctorHospital(hospitalId));

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return TopDoctorsResponse.fromJson(responseData);
      } else {
        return TopDoctorsResponse(
          success: false,
          message: 'Failed to fetch doctors: ${response.statusCode}',
          data: [],
          errors: response.body,
          meta: null,
          timestamp: DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      return TopDoctorsResponse(
        success: false,
        message: 'Network error: $e',
        data: [],
        errors: e.toString(),
        meta: null,
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }
}
