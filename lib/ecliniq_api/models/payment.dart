/// Payment models for PhonePe integration
/// Supports wallet, gateway, and hybrid payment methods

/// Payment data returned from booking API
class BookingPaymentData {
  final String appointmentId;
  final String? paymentId;
  final String merchantTransactionId;
  final double totalAmount;
  final double walletAmount;
  final double gatewayAmount;
  final String provider; // WALLET, GATEWAY, HYBRID
  final String? token;
  final String? orderId;
  final String? expiresAt;
  final bool requiresGateway;

  BookingPaymentData({
    required this.appointmentId,
    this.paymentId,
    required this.merchantTransactionId,
    required this.totalAmount,
    required this.walletAmount,
    required this.gatewayAmount,
    required this.provider,
    this.token,
    this.orderId,
    this.expiresAt,
    required this.requiresGateway,
  });

  factory BookingPaymentData.fromJson(Map<String, dynamic> json) {
    final toDouble = (dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    };

    final toBool = (dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      if (value is int) return value != 0;
      return false;
    };

    return BookingPaymentData(
      appointmentId: json['appointmentId']?.toString() ?? '',
      paymentId: json['paymentId']?.toString(),
      merchantTransactionId: json['merchantTransactionId']?.toString() ?? '',
      totalAmount: toDouble(json['totalAmount']),
      walletAmount: toDouble(json['walletAmount']),
      gatewayAmount: toDouble(json['gatewayAmount']),
      provider: json['provider']?.toString() ?? 'GATEWAY',
      token: json['token']?.toString(),
      orderId: json['orderId']?.toString(),
      expiresAt: json['expiresAt']?.toString(),
      requiresGateway: toBool(json['requiresGateway']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      if (paymentId != null) 'paymentId': paymentId,
      'merchantTransactionId': merchantTransactionId,
      'totalAmount': totalAmount,
      'walletAmount': walletAmount,
      'gatewayAmount': gatewayAmount,
      'provider': provider,
      if (token != null) 'token': token,
      if (orderId != null) 'orderId': orderId,
      if (expiresAt != null) 'expiresAt': expiresAt,
      'requiresGateway': requiresGateway,
    };
  }
}

/// Payment status data
class PaymentStatusData {
  final String? paymentId;
  final String merchantTransactionId;
  final String status; // PENDING, PROCESSING, SUCCEEDED, COMPLETED, FAILED, EXPIRED, CANCELLED
  final String? appointmentId;
  final double amount;
  final String checkedAt;

  PaymentStatusData({
    this.paymentId,
    required this.merchantTransactionId,
    required this.status,
    this.appointmentId,
    required this.amount,
    required this.checkedAt,
  });

  factory PaymentStatusData.fromJson(Map<String, dynamic> json) {
    final toDouble = (dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    };

    return PaymentStatusData(
      paymentId: json['paymentId']?.toString(),
      merchantTransactionId: json['merchantTransactionId']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING',
      appointmentId: json['appointmentId']?.toString(),
      amount: toDouble(json['amount']),
      checkedAt: json['checkedAt']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (paymentId != null) 'paymentId': paymentId,
      'merchantTransactionId': merchantTransactionId,
      'status': status,
      if (appointmentId != null) 'appointmentId': appointmentId,
      'amount': amount,
      'checkedAt': checkedAt,
    };
  }

  /// Check if payment is in a terminal state
  bool get isTerminal {
    return ['SUCCEEDED', 'COMPLETED', 'FAILED', 'EXPIRED', 'CANCELLED']
        .contains(status);
  }

  /// Check if payment was successful
  bool get isSuccess {
    return status == 'SUCCEEDED' || status == 'COMPLETED';
  }
}

/// Payment status response
class PaymentStatusResponse {
  final bool success;
  final String message;
  final PaymentStatusData? data;
  final dynamic errors;
  final dynamic meta;
  final String timestamp;

  PaymentStatusResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.meta,
    required this.timestamp,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? PaymentStatusData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'],
      meta: json['meta'],
      timestamp: json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
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

/// Payment detail data
class PaymentDetailData {
  final String id;
  final String merchantTransactionId;
  final double totalAmount;
  final double walletAmount;
  final double gatewayAmount;
  final String provider;
  final String status;
  final String? gatewayName;
  final String? gatewayOrderId;
  final String? gatewayTransactionId;
  final String? processedAt;
  final String? expiresAt;

  PaymentDetailData({
    required this.id,
    required this.merchantTransactionId,
    required this.totalAmount,
    required this.walletAmount,
    required this.gatewayAmount,
    required this.provider,
    required this.status,
    this.gatewayName,
    this.gatewayOrderId,
    this.gatewayTransactionId,
    this.processedAt,
    this.expiresAt,
  });

  factory PaymentDetailData.fromJson(Map<String, dynamic> json) {
    final toDouble = (dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    };

    return PaymentDetailData(
      id: json['id']?.toString() ?? '',
      merchantTransactionId: json['merchantTransactionId']?.toString() ?? '',
      totalAmount: toDouble(json['totalAmount']),
      walletAmount: toDouble(json['walletAmount']),
      gatewayAmount: toDouble(json['gatewayAmount']),
      provider: json['provider']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      gatewayName: json['gatewayName']?.toString(),
      gatewayOrderId: json['gatewayOrderId']?.toString(),
      gatewayTransactionId: json['gatewayTransactionId']?.toString(),
      processedAt: json['processedAt']?.toString(),
      expiresAt: json['expiresAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantTransactionId': merchantTransactionId,
      'totalAmount': totalAmount,
      'walletAmount': walletAmount,
      'gatewayAmount': gatewayAmount,
      'provider': provider,
      'status': status,
      if (gatewayName != null) 'gatewayName': gatewayName,
      if (gatewayOrderId != null) 'gatewayOrderId': gatewayOrderId,
      if (gatewayTransactionId != null) 'gatewayTransactionId': gatewayTransactionId,
      if (processedAt != null) 'processedAt': processedAt,
      if (expiresAt != null) 'expiresAt': expiresAt,
    };
  }
}

/// Payment details response
class PaymentDetailResponse {
  final bool success;
  final String message;
  final PaymentDetailData? data;
  final dynamic errors;
  final dynamic meta;
  final String timestamp;

  PaymentDetailResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.meta,
    required this.timestamp,
  });

  factory PaymentDetailResponse.fromJson(Map<String, dynamic> json) {
    return PaymentDetailResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? PaymentDetailData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'],
      meta: json['meta'],
      timestamp: json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
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
