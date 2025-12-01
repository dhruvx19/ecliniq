import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

/// Service wrapper for PhonePe Payment SDK
class PhonePeService {
  static final PhonePeService _instance = PhonePeService._internal();
  factory PhonePeService() => _instance;
  PhonePeService._internal();

  bool _isInitialized = false;

  /// Initialize PhonePe SDK
  /// Should be called once during app startup
  Future<void> initialize({
    required bool isProduction,
    String? merchantId,
    String? appId,
  }) async {
    if (_isInitialized) {
      return;
    }

    try {
      // Initialize PhonePe SDK with environment
      final environment = isProduction
          ? Environment.production
          : Environment.sandbox;

      // If merchantId and appId are provided, use them
      // Otherwise, PhonePe SDK will use values from configuration
      await PhonePeSdk.init(
        environment,
        merchantId ?? '',
        appId ?? '',
        enableLogging: !isProduction,
      );

      _isInitialized = true;
    } catch (e) {
      throw PhonePeException('Failed to initialize PhonePe SDK: $e');
    }
  }

  /// Start payment transaction with PhonePe SDK
  /// Returns the payment result
  Future<PhonePePaymentResult> startPayment({
    required String token,
    required String packageName,
  }) async {
    if (!_isInitialized) {
      throw PhonePeException('PhonePe SDK not initialized. Call initialize() first.');
    }

    try {
      // Start PhonePe payment transaction
      final result = await PhonePeSdk.startPGTransaction(
        token,
        packageName,
        null, // Optional callback URL
        null, // Optional headers
      );

      return PhonePePaymentResult.fromSdkResult(result);
    } catch (e) {
      throw PhonePeException('Failed to start payment: $e');
    }
  }

  /// Check if PhonePe app is installed
  Future<bool> isPhonePeInstalled() async {
    try {
      return await PhonePeSdk.isPhonePeInstalled() ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Get PhonePe package name for the current platform
  String getPackageName() {
    // For Android, use the app's package name
    // This should match the package name in AndroidManifest.xml
    return 'com.ecliniq.app'; // TODO: Update with actual package name
  }
}

/// Payment result from PhonePe SDK
class PhonePePaymentResult {
  final bool success;
  final String? message;
  final dynamic data;

  PhonePePaymentResult({
    required this.success,
    this.message,
    this.data,
  });

  factory PhonePePaymentResult.fromSdkResult(dynamic result) {
    // Parse SDK result
    // The exact structure depends on PhonePe SDK version
    if (result == null) {
      return PhonePePaymentResult(
        success: false,
        message: 'Payment was cancelled or failed',
      );
    }

    // Try to extract success status from result
    final isSuccess = result.toString().toLowerCase().contains('success') ||
        result.toString().toLowerCase().contains('completed');

    return PhonePePaymentResult(
      success: isSuccess,
      message: result.toString(),
      data: result,
    );
  }
}

/// Custom exception for PhonePe operations
class PhonePeException implements Exception {
  final String message;

  PhonePeException(this.message);

  @override
  String toString() => 'PhonePeException: $message';
}
