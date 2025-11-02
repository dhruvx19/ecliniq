import 'dart:convert';

import 'package:ecliniq/ecliniq_api/models/appointment.dart';
import 'package:ecliniq/ecliniq_api/src/endpoints.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  Future<BookAppointmentResponse> bookAppointment({
    required BookAppointmentRequest request,
    String? authToken,
  }) async {
    try {
      final url = Uri.parse(Endpoints.bookAppointment);

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      
      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
        headers['x-access-token'] = authToken;
      }

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return BookAppointmentResponse.fromJson(responseData);
      } else {
        final responseData = jsonDecode(response.body);
        return BookAppointmentResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to book appointment: ${response.statusCode}',
          data: null,
          errors: response.body,
          meta: null,
          timestamp: DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      return BookAppointmentResponse(
        success: false,
        message: 'Network error: $e',
        data: null,
        errors: e.toString(),
        meta: null,
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }
}

