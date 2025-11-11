import 'dart:convert';

import 'package:ecliniq/ecliniq_api/models/slot.dart';
import 'package:ecliniq/ecliniq_api/src/endpoints.dart';
import 'package:http/http.dart' as http;

class SlotService {
  Future<SlotResponse> findSlotsByDoctorAndDate({
    required String doctorId,
    required String date,
    required String hospitalId,
  }) async {
    try {
      final url = Uri.parse(Endpoints.getSlotsByDate);

      final requestBody = FindSlotsRequest(
        doctorId: '03be03b0-9843-4ece-a2fd-4d56b08749a5',
        date: "2025-11-03",
        hospitalId: '883a6789-fe62-4849-9e71-cf013bb564a8',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return SlotResponse.fromJson(responseData);
      } else {
        return SlotResponse(
          success: false,
          message: 'Failed to fetch slots: ${response.statusCode}',
          data: [],
          errors: response.body,
          meta: null,
          timestamp: DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      return SlotResponse(
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

