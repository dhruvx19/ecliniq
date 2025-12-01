import 'dart:convert';
import 'dart:io';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

/// Service wrapper for PhonePe Payment SDK
class PhonePeService {
  static final PhonePeService _instance = PhonePeService._internal();
  factory PhonePeService() => _instance;
  PhonePeService._internal();

  bool _isInitialized = false;
  String _environment = 'SANDBOX';
  String _packageName = 'com.phonepe.simulator';

  /// Initialize PhonePe SDK
  /// [isProduction] - Set true for production, false for sandbox
  /// [merchantId] - Your PhonePe merchant ID
  /// [flowId] - Unique user ID or session identifier
  /// [enableLogs] - Enable SDK logging (recommended false for production)
  Future<bool> initialize({
    required bool isProduction,
    required String merchantId,
    required String flowId,
    bool enableLogs = false,
  }) async {
    if (_isInitialized) return true;

    // Validate required parameters
    if (merchantId.isEmpty) {
      throw PhonePeException('merchantId cannot be empty');
    }
    if (flowId.isEmpty) {
      throw PhonePeException('flowId cannot be empty. Pass a unique user/session identifier.');
    }

    try {
      _environment = isProduction ? 'PRODUCTION' : 'SANDBOX';
      _packageName = isProduction ? 'com.phonepe.app' : 'com.phonepe.simulator';

      final isInitialized = await PhonePePaymentSdk.init(
        _environment,
        merchantId,
        flowId,
        enableLogs,
      );

      _isInitialized = isInitialized ?? false;
      return _isInitialized;
    } catch (e) {
      throw PhonePeException('Failed to initialize PhonePe SDK: $e');
    }
  }

  /// Start payment transaction
  /// [request] - The base64 encoded payment request payload
  /// [appSchema] - Your app's custom URL scheme for callback
  Future<PhonePePaymentResult> startPayment({
    required String request,
    required String appSchema,
    String? packageName,
  }) async {
    if (!_isInitialized) {
      throw PhonePeException('PhonePe SDK not initialized. Call initialize() first.');
    }

    print('========== PHONEPE SERVICE: START PAYMENT ==========');
    print('Request (base64) length: ${request.length}');
    print('Request (first 100 chars): ${request.substring(0, request.length > 100 ? 100 : request.length)}');
    try {
      print('Starting payment with PhonePe...');
      print('Request (token) length: ${request.length}');
      print('App schema: $appSchema');
      print('Package name: ${packageName ?? "default"}');
      
      // Call PhonePe SDK to start payment
      // This will open the selected UPI app or PhonePe app for user to complete payment
      final response = await PhonePePaymentSdk.startTransaction(
        request, // base64 token from backend
        appSchema, // callback URL schema
        null, // checksum - not needed as token is already signed
        packageName, // specific UPI app or null for PhonePe
      );

      print('PhonePe SDK response: $response');
      
      return PhonePePaymentResult.fromSdkResult(response);
    } catch (e) {
      print('PhonePe payment error: $e');
      throw PhonePeException('Failed to start payment: $e');
    }
  }

  /// Get list of installed UPI apps
  /// Returns list of UPI apps that can be used for payment
  Future<List<UpiApp>> getInstalledUpiApps() async {
    try {
      // Get UPI apps list from PhonePe SDK
      final apps = await PhonePePaymentSdk.getInstalledUpiApps();
      
      if (apps == null || apps.isEmpty) {
        print('No UPI apps found');
        return [];
      }

      print('Found ${apps.length} UPI apps');
      
      // Parse the apps list
      final upiApps = <UpiApp>[];
      for (final app in apps) {
        if (app is Map) {
          final appMap = Map<String, dynamic>.from(app);
          upiApps.add(UpiApp.fromJson(appMap));
        }
      }
      
      return upiApps;
    } catch (e) {
      print('Error getting UPI apps: $e');
      return [];
    }
  }

  /// Check if PhonePe app is installed
  Future<bool> isPhonePeInstalled() async {
    try {
      final result = await PhonePePaymentSdk.isPhonePeInstalled();
      return result == 'true' || result == true;
    } catch (e) {
      print('Error checking PhonePe installation: $e');
      return false;
    }
  }

  /// Get the current environment
  String? get environment => _environment;

  /// Get the package name
  String? get packageName => _packageName;

  /// Check if SDK is initialized
  bool get isInitialized => _isInitialized;
}

/// UPI App information
class UpiApp {
  final String name;
  final String packageName;
  final String? version;
  final String? icon;

  UpiApp({
    required this.name,
    required this.packageName,
    this.version,
    this.icon,
  });

  factory UpiApp.fromJson(Map<String, dynamic> json) {
    return UpiApp(
      name: json['applicationName'] ?? json['name'] ?? 'Unknown',
      packageName: json['packageName'] ?? '',
      version: json['version'],
      icon: json['icon'],
    );
  }

  /// Common UPI app identifiers
  bool get isPhonePe => packageName.toLowerCase().contains('phonepe');
  bool get isGPay => packageName.toLowerCase().contains('google') || 
                     packageName.toLowerCase().contains('gpay');
  bool get isPaytm => packageName.toLowerCase().contains('paytm');
  bool get isBhim => packageName.toLowerCase().contains('bhim');

  @override
  String toString() => 'UpiApp($name, $packageName)';
}

/// Payment result from PhonePe SDK
class PhonePePaymentResult {
  final bool success;
  final String status;
  final String? error;
  final dynamic data;

  PhonePePaymentResult({
    required this.success,
    required this.status,
    this.error,
    this.data,
  });

  factory PhonePePaymentResult.fromSdkResult(dynamic result) {
    print('Parsing SDK result: $result');
    print('Result type: ${result.runtimeType}');
    
    // PhonePe SDK returns different formats:
    // - String: "SUCCESS", "FAILURE", "INCOMPLETE"
    // - Map: {"status": "SUCCESS", ...}
    
    if (result == null) {
      return PhonePePaymentResult(
        success: false,
        status: 'INCOMPLETE',
        error: 'Payment was cancelled or failed',
      );
    }

    String status = 'INCOMPLETE';
    String? error;
    
    if (result is String) {
      status = result.toUpperCase();
    } else if (result is Map) {
      status = (result['status'] ?? result['STATUS'] ?? 'INCOMPLETE').toString().toUpperCase();
      error = result['error']?.toString();
    } else {
      status = result.toString().toUpperCase();
    }

    // Normalize status
    final success = status.contains('SUCCESS') || status == 'COMPLETED';
    
    return PhonePePaymentResult(
      success: success,
      status: status,
      error: error,
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