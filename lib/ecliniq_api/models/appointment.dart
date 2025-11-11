class BookAppointmentRequest {
  final String patientId;
  final String doctorId;
  final String doctorSlotScheduleId;
  final String? reason;
  final String? referBy;
  final String bookedFor;

  BookAppointmentRequest({
    required this.patientId,
    required this.doctorId,
    required this.doctorSlotScheduleId,
    this.reason,
    this.referBy,
    required this.bookedFor,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorSlotScheduleId': doctorSlotScheduleId,
      if (reason != null && reason!.isNotEmpty) 'reason': reason,
      if (referBy != null && referBy!.isNotEmpty) 'referBy': referBy,
      'bookedFor': bookedFor,
    };
  }
}

class AppointmentData {
  final String id;
  final String patientId;
  final String? dependentId;
  final String bookedFor;
  final String doctorId;
  final String doctorSlotScheduleId;
  final int tokenNo;
  final String? reason;
  final String status;
  final String? referBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentData({
    required this.id,
    required this.patientId,
    this.dependentId,
    required this.bookedFor,
    required this.doctorId,
    required this.doctorSlotScheduleId,
    required this.tokenNo,
    this.reason,
    required this.status,
    this.referBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    // Helper to safely convert to string
    final toString = (dynamic value, String defaultValue) {
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    };
    
    // Helper to safely convert to int
    final toInt = (dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      if (value is double) return value.toInt();
      return defaultValue;
    };
    
    // Helper to safely parse DateTime
    final parseDateTime = (dynamic value, DateTime defaultValue) {
      if (value == null) return defaultValue;
      try {
        final timeStr = value is String ? value : value.toString();
        return DateTime.parse(timeStr);
      } catch (e) {
        return defaultValue;
      }
    };
    
    final defaultDate = DateTime.utc(1970, 1, 1);
    
    return AppointmentData(
      id: toString(json['id'], ''),
      patientId: toString(json['patientId'], ''),
      dependentId: json['dependentId'] != null ? toString(json['dependentId'], '') : null,
      bookedFor: toString(json['bookedFor'], ''),
      doctorId: toString(json['doctorId'], ''),
      doctorSlotScheduleId: toString(json['doctorSlotScheduleId'], ''),
      tokenNo: toInt(json['tokenNo'], 0),
      reason: json['reason'] != null ? toString(json['reason'], '') : null,
      status: toString(json['status'], ''),
      referBy: json['referBy'] != null ? toString(json['referBy'], '') : null,
      createdAt: parseDateTime(json['createdAt'], defaultDate),
      updatedAt: parseDateTime(json['updatedAt'], defaultDate),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      if (dependentId != null) 'dependentId': dependentId,
      'bookedFor': bookedFor,
      'doctorId': doctorId,
      'doctorSlotScheduleId': doctorSlotScheduleId,
      'tokenNo': tokenNo,
      if (reason != null) 'reason': reason,
      'status': status,
      if (referBy != null) 'referBy': referBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class BookAppointmentResponse {
  final bool success;
  final String message;
  final AppointmentData? data;
  final dynamic errors;
  final dynamic meta;
  final String timestamp;

  BookAppointmentResponse({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
    required this.meta,
    required this.timestamp,
  });

  factory BookAppointmentResponse.fromJson(Map<String, dynamic> json) {
    return BookAppointmentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? AppointmentData.fromJson(json['data'])
          : null,
      errors: json['errors'],
      meta: json['meta'],
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
      'errors': errors,
      'meta': meta,
      'timestamp': timestamp,
    };
  }
}

