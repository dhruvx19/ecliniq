class OTPVerificationResponse {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;

  OTPVerificationResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory OTPVerificationResponse.success(Map<String, dynamic> data) {
    return OTPVerificationResponse(
      success: true,
      data: data,
    );
  }

  factory OTPVerificationResponse.error(String message) {
    return OTPVerificationResponse(
      success: false,
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }

  factory OTPVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OTPVerificationResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
    );
  }
}