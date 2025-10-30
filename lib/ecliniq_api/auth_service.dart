import 'dart:convert';
import 'package:ecliniq/ecliniq_api/models/otp_verification_model.dart';
import 'package:ecliniq/ecliniq_api/src/endpoints.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> loginOrRegisterUser(String phone) async {
    final url = Uri.parse(Endpoints.loginOrRegisterUser);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'challengeId': responseData['data']['challengeId'],
          'phone': responseData['data']['phone'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to send OTP',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to connect to the server: $e',
      };
    }
  }

Future<OTPVerificationResponse> verifyOTP(String challengeId, String phone, String otp) async {
  final url = Uri.parse(Endpoints.verifyUser);
  
  try {
    // Debug logging
    print('🔍 Verifying OTP with: challengeId=$challengeId, phone=$phone, otp=$otp');
    
    final requestBody = {
      'challengeId': challengeId,
      'phone': phone,
      'otp': otp,
    };
    
    print('📤 Sending request to: $url');
    print('📤 Request body: ${jsonEncode(requestBody)}');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    print('📥 Response status: ${response.statusCode}');
    print('📥 Response body: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return OTPVerificationResponse.success(responseData);
    } else {
      // Try to get the actual error message from the server
      String errorMessage = 'Invalid OTP or verification failed';
      
      if (responseData is Map<String, dynamic>) {
        // Try different common error message formats
        errorMessage = responseData['message'] ?? 
                      responseData['error'] ?? 
                      responseData['data']?['message'] ??
                      'Invalid OTP or verification failed';
        
        // Log specific error details
        print('❌ Error details: $responseData');
      }
      
      return OTPVerificationResponse.error(errorMessage);
    }
  } catch (e) {
    print('❌ Exception during OTP verification: $e');
    return OTPVerificationResponse.error('Failed to connect to the server: $e');
  }
}

}