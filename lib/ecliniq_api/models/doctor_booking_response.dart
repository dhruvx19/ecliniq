
class DoctorBookingDetailsResponse {
  final bool success;
  final String message;
  final Doctor? data;
  final dynamic errors;
  final dynamic meta;
  final String timestamp;

  DoctorBookingDetailsResponse({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
    required this.meta,
    required this.timestamp,
  });

  factory DoctorBookingDetailsResponse.fromJson(Map<String, dynamic> json) {
    return DoctorBookingDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? Doctor.fromJson(json['data']) : null,
      errors: json['errors'],
      meta: json['meta'],
      timestamp: json['timestamp'] ?? '',
    );
  }
}
