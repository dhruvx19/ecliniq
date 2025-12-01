import 'dart:async';
import 'package:ecliniq/ecliniq_api/payment_service.dart';
import 'package:ecliniq/ecliniq_api/models/payment.dart';
import 'package:ecliniq/ecliniq_api/appointment_service.dart';
import 'package:ecliniq/ecliniq_api/models/appointment.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/booking_confirmed_screen.dart';
import 'package:ecliniq/ecliniq_services/phonepe_service.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final String appointmentId;
  final String merchantTransactionId;
  final String token;
  final double totalAmount;
  final double walletAmount;
  final double gatewayAmount;
  final String provider;
  
  // Appointment details for success screen
  final String? doctorName;
  final String? doctorSpecialization;
  final String? selectedSlot;
  final String? selectedDate;
  final String? hospitalAddress;
  final String? patientName;
  final String? patientSubtitle;
  final String? patientBadge;

  const PaymentProcessingScreen({
    super.key,
    required this.appointmentId,
    required this.merchantTransactionId,
    required this.token,
    required this.totalAmount,
    required this.walletAmount,
    required this.gatewayAmount,
    required this.provider,
    this.doctorName,
    this.doctorSpecialization,
    this.selectedSlot,
    this.selectedDate,
    this.hospitalAddress,
    this.patientName,
    this.patientSubtitle,
    this.patientBadge,
  });

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  final PaymentService _paymentService = PaymentService();
  final AppointmentService _appointmentService = AppointmentService();
  final PhonePeService _phonePeService = PhonePeService();

  PaymentStatus _currentStatus = PaymentStatus.initiating;
  String _statusMessage = 'Initializing payment...';
  String? _errorMessage;
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _loadAuthToken();
    _initiatePayment();
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
  }

  Future<void> _initiatePayment() async {
    try {
      setState(() {
        _currentStatus = PaymentStatus.initiating;
        _statusMessage = 'Starting PhonePe payment...';
      });

      // Wait a moment for UI to update
      await Future.delayed(const Duration(milliseconds: 500));

      // Start PhonePe payment
      final packageName = _phonePeService.getPackageName();
      final result = await _phonePeService.startPayment(
        token: widget.token,
        packageName: packageName,
      );

      // After PhonePe SDK returns, start verification
      await _verifyPayment();
    } catch (e) {
      setState(() {
        _currentStatus = PaymentStatus.failed;
        _statusMessage = 'Payment initiation failed';
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _verifyPayment() async {
    setState(() {
      _currentStatus = PaymentStatus.verifying;
      _statusMessage = 'Verifying payment...';
    });

    try {
      // Poll payment status
      final statusData = await _paymentService.pollPaymentUntilComplete(
        widget.merchantTransactionId,
        onStatusUpdate: (status) {
          setState(() {
            _statusMessage = 'Checking payment status: ${status.status}';
          });
        },
      );

      if (statusData == null) {
        // Timeout
        setState(() {
          _currentStatus = PaymentStatus.timeout;
          _statusMessage = 'Payment verification timed out';
          _errorMessage =
              'Unable to verify payment status. Please check My Visits or contact support.';
        });
        return;
      }

      if (statusData.isSuccess) {
        // Payment successful - verify appointment
        await _verifyAppointment();
      } else {
        // Payment failed
        setState(() {
          _currentStatus = PaymentStatus.failed;
          _statusMessage = 'Payment ${statusData.status.toLowerCase()}';
          _errorMessage = _getPaymentErrorMessage(statusData.status);
        });
      }
    } catch (e) {
      setState(() {
        _currentStatus = PaymentStatus.failed;
        _statusMessage = 'Verification failed';
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _verifyAppointment() async {
    setState(() {
      _statusMessage = 'Confirming appointment...';
    });

    try {
      final verifyRequest = VerifyAppointmentRequest(
        appointmentId: widget.appointmentId,
        merchantTransactionId: widget.merchantTransactionId,
      );

      final response = await _appointmentService.verifyAppointment(
        request: verifyRequest,
        authToken: _authToken,
      );

      if (response.success && response.data != null) {
        setState(() {
          _currentStatus = PaymentStatus.success;
          _statusMessage = 'Payment successful!';
        });

        // Navigate to success screen after a delay
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentRequestScreen(
                doctorName: widget.doctorName,
                doctorSpecialization: widget.doctorSpecialization,
                selectedSlot: widget.selectedSlot ?? '',
                selectedDate: widget.selectedDate ?? '',
                hospitalAddress: widget.hospitalAddress,
                tokenNumber: response.data!.tokenNo.toString(),
                patientName: widget.patientName ?? '',
                patientSubtitle: widget.patientSubtitle ?? '',
                patientBadge: widget.patientBadge ?? '',
                // Payment details
                merchantTransactionId: widget.merchantTransactionId,
                paymentMethod: widget.provider,
                totalAmount: widget.totalAmount,
                walletAmount: widget.walletAmount,
                gatewayAmount: widget.gatewayAmount,
              ),
            ),
          );
        }
      } else {
        setState(() {
          _currentStatus = PaymentStatus.failed;
          _statusMessage = 'Appointment verification failed';
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      setState(() {
        _currentStatus = PaymentStatus.failed;
        _statusMessage = 'Appointment verification failed';
        _errorMessage = e.toString();
      });
    }
  }

  String _getPaymentErrorMessage(String status) {
    switch (status) {
      case 'FAILED':
        return widget.walletAmount > 0
            ? 'Payment failed. Wallet amount of ₹${widget.walletAmount.toStringAsFixed(0)} will be refunded.'
            : 'Payment failed. Please try again.';
      case 'CANCELLED':
        return 'Payment was cancelled. You can try booking again.';
      case 'EXPIRED':
        return 'Payment link expired. Please book again.';
      default:
        return 'Payment could not be completed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation during processing
        return _currentStatus == PaymentStatus.success ||
            _currentStatus == PaymentStatus.failed ||
            _currentStatus == PaymentStatus.timeout;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: _currentStatus == PaymentStatus.success ||
                  _currentStatus == PaymentStatus.failed ||
                  _currentStatus == PaymentStatus.timeout
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          automaticallyImplyLeading: false,
          title: Text(
            'Payment Processing',
            style: EcliniqTextStyles.headlineMedium.copyWith(
              color: const Color(0xff424242),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusIcon(),
                  const SizedBox(height: 32),
                  Text(
                    _statusMessage,
                    style: EcliniqTextStyles.headlineLarge.copyWith(
                      color: const Color(0xff424242),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: EcliniqTextStyles.headlineXMedium.copyWith(
                          color: const Color(0xFFD32F2F),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (_currentStatus == PaymentStatus.failed ||
                      _currentStatus == PaymentStatus.timeout) ...[
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: EcliniqTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  _buildPaymentBreakdown(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (_currentStatus) {
      case PaymentStatus.success:
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            color: Color(0xFF4CAF50),
            size: 80,
          ),
        );
      case PaymentStatus.failed:
      case PaymentStatus.timeout:
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFD32F2F).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error,
            color: Color(0xFFD32F2F),
            size: 80,
          ),
        );
      default:
        return const SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
          ),
        );
    }
  }

  Widget _buildPaymentBreakdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Details',
            style: EcliniqTextStyles.headlineMedium.copyWith(
              color: const Color(0xff424242),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentRow('Total Amount', widget.totalAmount),
          if (widget.walletAmount > 0) ...[
            const SizedBox(height: 8),
            _buildPaymentRow('Wallet', widget.walletAmount, isSubItem: true),
          ],
          if (widget.gatewayAmount > 0) ...[
            const SizedBox(height: 8),
            _buildPaymentRow('Gateway', widget.gatewayAmount, isSubItem: true),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, double amount,
      {bool isSubItem = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isSubItem ? '  • $label' : label,
          style: EcliniqTextStyles.headlineXMedium.copyWith(
            color: const Color(0xff626060),
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: EcliniqTextStyles.headlineXMedium.copyWith(
            color: const Color(0xff424242),
            fontWeight: isSubItem ? FontWeight.normal : FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

enum PaymentStatus {
  initiating,
  processing,
  verifying,
  success,
  failed,
  timeout,
}
