import 'package:ecliniq/ecliniq_api/appointment_service.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/provider/auth_provider.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/clinic_visit_slot_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/cancelled.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/widgets/cancel_bottom_sheet.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/widgets/cancellation_policy_bottom_sheet.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/widgets/common.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/widgets/reschedule_bottom_sheet.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/shimmer/shimmer_loading.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/snackbar/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BookingRequestedDetail extends StatefulWidget {
  final String appointmentId;
  final AppointmentDetailModel?
  appointment; // Optional for backward compatibility

  const BookingRequestedDetail({
    super.key,
    required this.appointmentId,
    this.appointment,
  });

  @override
  State<BookingRequestedDetail> createState() => _BookingRequestedDetailState();
}

class _BookingRequestedDetailState extends State<BookingRequestedDetail> {
  AppointmentDetailModel? _appointment;
  bool _isLoading = true;
  String? _errorMessage;
  final _appointmentService = AppointmentService();

  @override
  void initState() {
    super.initState();
    // If appointment is provided, use it directly (backward compatibility)
    if (widget.appointment != null) {
      _appointment = widget.appointment;
      _isLoading = false;
    } else {
      _loadAppointmentDetails();
    }
  }

  Future<void> _loadAppointmentDetails() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authToken = authProvider.authToken;

      if (authToken == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Authentication required. Please login again.';
          });
        }
        return;
      }

      final response = await _appointmentService.getAppointmentDetail(
        appointmentId: widget.appointmentId,
        authToken: authToken,
      );

      if (!mounted) return;

      if (!response.success || response.data == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = response.message;
        });
        return;
      }

      // Convert API response to UI model
      final appointmentDetail = AppointmentDetailModel.fromApiData(
        response.data!,
      );

      if (!mounted) return;

      setState(() {
        _appointment = appointmentDetail;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load appointment details: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            EcliniqIcons.backArrow.assetPath,
            width: 32,
            height: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Booking Detail',
            style: EcliniqTextStyles.headlineMedium.copyWith(
              color: Color(0xff424242),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.2),
          child: Container(color: Color(0xFFB8B8B8), height: 1.0),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, size: 24),
            label: Text(
              'Help',
              style: EcliniqTextStyles.headlineXMedium.copyWith(
                color: Color(0xff424242),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? _buildShimmerLoading()
          : _errorMessage != null
          ? _buildErrorWidget()
          : _appointment == null
          ? _buildErrorWidget()
          : _buildContent(),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Status header shimmer
          Container(
            height: 120,
            margin: const EdgeInsets.all(16),
            child: ShimmerLoading(borderRadius: BorderRadius.circular(12)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor info card shimmer
                SizedBox(
                  height: 150,
                  child: ShimmerLoading(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 24),
                // Request note shimmer
                SizedBox(
                  height: 100,
                  child: ShimmerLoading(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 24),
                // Appointment details shimmer
                SizedBox(
                  height: 200,
                  child: ShimmerLoading(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 24),
                // Clinic location shimmer
                SizedBox(
                  height: 120,
                  child: ShimmerLoading(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 24),
                // Payment details shimmer
                SizedBox(
                  height: 100,
                  child: ShimmerLoading(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Failed to load appointment details',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _loadAppointmentDetails();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          StatusHeader(
            status: _appointment!.status,
            currentTokenNumber: _appointment!.currentTokenNumber,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoctorInfoCard(
                  doctor: _appointment!.doctor,
                  clinic: _appointment!.clinic,
                  currentTokenNumber: _appointment!.currentTokenNumber,
                ),

                const SizedBox(height: 24),
                _buildRequestNote(),
                const SizedBox(height: 24),
                AppointmentDetailsSection(
                  patient: _appointment!.patient,
                  timeInfo: _appointment!.timeInfo,
                ),
                const SizedBox(height: 24),
                ClinicLocationCard(clinic: _appointment!.clinic),
                const SizedBox(height: 24),
                PaymentDetailsCard(payment: _appointment!.payment),
                const SizedBox(height: 24),
                _buildBottomButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9E6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBE8B00), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            EcliniqIcons.requestedIcon.assetPath,
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your booking request will be confirmed once the doctor approves it. You will receive your token number details via WhatsApp and SMS.',
              style: TextStyle(fontSize: 16, color: Color(0xFF0D47A1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BookingActionButton(
            label: 'Reschedule',
            icon: EcliniqIcons.rescheduleIcon,
            type: BookingButtonType.reschedule,
            onPressed: () async {
              // Check if appointment is already rescheduled
              final isAlreadyRescheduled = _appointment?.isRescheduled ?? false;
              if (isAlreadyRescheduled) {
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomErrorSnackBar(
                    context: context,
                    title: 'Cannot Reschedule',
                    subtitle: 'This appointment has already been rescheduled. You cannot reschedule it again.',
                    duration: const Duration(seconds: 3),
                  ),
                );
                return;
              }

              final result = await EcliniqBottomSheet.show<bool>(
                context: context,
                child: RescheduleBottomSheet(
                  appointment: _appointment!,
                ),
              );
              
              if (result == true && mounted && _appointment != null) {
                // Navigate to slot screen for reschedule
                final appointment = _appointment!;
                if (appointment.doctorId != null && 
                    (appointment.hospitalId != null || appointment.clinicId != null)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClinicVisitSlotScreen(
                        doctorId: appointment.doctorId!,
                        hospitalId: appointment.hospitalId,
                        clinicId: appointment.clinicId,
                        doctorName: appointment.doctor.name,
                        doctorSpecialization: appointment.doctor.specialization,
                        appointmentId: appointment.id,
                        previousAppointment: appointment,
                        isReschedule: true,
                      ),
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 8),
          BookingActionButton(
            label: 'Cancel Booking',
            icon: EcliniqIcons.rescheduleIcon,
            type: BookingButtonType.cancel,
            onPressed: () {
              EcliniqBottomSheet.show(
                context: context,
                child: CancelBottomSheet(
                  appointmentId: widget.appointmentId,
                  onCancelled: () async {
                    // Show shimmer loading state
                    if (mounted) {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                    }

                    // Reload appointment details to get updated status
                    await _loadAppointmentDetails();

                    // Check if status changed to cancelled
                    if (mounted &&
                        _appointment != null &&
                        (_appointment!.status.toLowerCase() == 'cancelled' ||
                            _appointment!.status.toLowerCase() == 'failed')) {
                      // Navigate to cancelled detail page
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => BookingCancelledDetail(
                            appointmentId: widget.appointmentId,
                            appointment: _appointment,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              EcliniqBottomSheet.show(
                context: context,
                child: const CancellationPolicyBottomSheet(),
              );
            },
            child: Text(
              'View Cancellation Policy',
              style: TextStyle(fontSize: 14, color: Color(0xff424242), fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
