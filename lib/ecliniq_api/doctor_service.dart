import 'dart:convert';

import 'package:ecliniq/ecliniq_api/models/doctor.dart';
import 'package:ecliniq/ecliniq_api/src/endpoints.dart';
import 'package:http/http.dart' as http;

class DoctorService {
  Future<TopDoctorsResponse> getTopDoctors({
    required double latitude,
    required double longitude,

    
  }) async {
      const double defaultLatitude = 28.6139;
      const double defaultLongitude = 77.209;
    try {
      final url = Uri.parse(Endpoints.topDoctors);

      final requestBody = TopDoctorsRequest(
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
