import 'package:ecliniq/ecliniq_api/appointment_service.dart';
import 'package:ecliniq/ecliniq_api/doctor_service.dart';
import 'package:ecliniq/ecliniq_api/hospital_service.dart';
import 'package:ecliniq/ecliniq_api/models/appointment.dart';
import 'package:ecliniq/ecliniq_api/models/doctor.dart';
import 'package:ecliniq/ecliniq_api/models/patient.dart';
import 'package:ecliniq/ecliniq_api/patient_service.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/request_sent.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/appointment_detail_item.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/clinic_location_card.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/doctor_info_card.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/top_bar_widgets/easy_way_book.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/widgets/common.dart'
    hide DoctorInfoCard, ClinicLocationCard;
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/button/button.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/shimmer/shimmer_loading.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/snackbar/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewDetailsScreen extends StatefulWidget {
  final String selectedSlot;
  final String selectedDate;
  final String doctorId;
  final String? hospitalId;
  final String? clinicId;
  final String slotId;
  final String? doctorName;
  final String? doctorSpecialization;
  final String? appointmentId;
  final AppointmentDetailModel? previousAppointment;
  final bool isReschedule;
  final Doctor? doctor; // Pass doctor data from previous screen to avoid API call
  final String? locationName;
  final String? locationAddress;
  final String? locationDistance;

  const ReviewDetailsScreen({
    super.key,
    required this.selectedSlot,
    required this.selectedDate,
    required this.doctorId,
    this.hospitalId,
    this.clinicId,
    required this.slotId,
    this.doctorName,
    this.doctorSpecialization,
    this.appointmentId,
    this.previousAppointment,
    this.isReschedule = false,
    this.doctor,
    this.locationName,
    this.locationAddress,
    this.locationDistance,
  }) : assert(
         hospitalId != null || clinicId != null,
         'Either hospitalId or clinicId must be provided',
       );

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  final HospitalService _hospitalService = HospitalService();
  final DoctorService _doctorService = DoctorService();
  final PatientService _patientService = PatientService();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _referByController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool receiveUpdates = true;
  bool _isBooking = false;
  String? _patientId;
  String? _authToken;
  String? _hospitalAddress;
  DependentData? _selectedDependent;
  
  Doctor? _doctor;
  String? _currentLocationName;
  String? _currentLocationAddress;
  String? _currentDistance;
  bool _isLoadingDoctorDetails = false;
  
  PatientDetailsData? _currentUserDetails;
  bool _isLoadingUserDetails = false;

  // Reason bottom sheet removed; using free-text field instead.

  @override
  void initState() {
    super.initState();
    _loadPatientId();
    _fetchHospitalAddress();
    _fetchCurrentUserDetails();
    
    // Use passed doctor data if available, otherwise fetch
    if (widget.doctor != null) {
      _doctor = widget.doctor;
      _currentLocationName = widget.locationName;
      _currentLocationAddress = widget.locationAddress;
      _currentDistance = widget.locationDistance;
      _updateCurrentLocationDetails();
    } else {
      _fetchDoctorDetails();
    }
    
    _reasonController.addListener(() {
      setState(() {});
    });

    // Pre-fill reason from previous appointment if rescheduling
    if (widget.isReschedule && widget.previousAppointment != null) {
      // The reason might be stored in the appointment, but it's not in AppointmentDetailModel
      // So we'll leave it empty for now
    }
  }

  Future<void> _fetchHospitalAddress() async {
    // Only fetch hospital address if hospitalId is provided (not for clinics)
    if (widget.hospitalId == null || widget.hospitalId!.isEmpty) return;

    try {
      final response = await _hospitalService.getHospitalDetails(
        hospitalId: widget.hospitalId!,
      );

      if (mounted && response.success && response.data != null) {
        final hospitalDetail = response.data!;
        final address = hospitalDetail.address;
        final parts = <String>[];

        if (address.street != null && address.street!.isNotEmpty) {
          parts.add(address.street!);
        }
        if (address.blockNo != null && address.blockNo!.isNotEmpty) {
          parts.add(address.blockNo!);
        }
        if (hospitalDetail.city.isNotEmpty) {
          parts.add(hospitalDetail.city);
        }
        if (hospitalDetail.state.isNotEmpty) {
          parts.add(hospitalDetail.state);
        }
        if (address.landmark != null && address.landmark!.isNotEmpty) {
          parts.add('Near ${address.landmark}');
        }

        setState(() {
          _hospitalAddress = parts.isEmpty
              ? 'Address not available'
              : parts.join(', ');
        });
      }
    } catch (e) {
      // Silently fail - address will be null
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _referByController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientId() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    setState(() {
      _authToken = authToken;
      // Patient ID will be set from _currentUserDetails after API fetch
      // Try to get from SharedPreferences as fallback
      _patientId = prefs.getString('patient_id') ??
        prefs.getString('patientId') ??
        prefs.getString('user_id');
    });
  }

  Future<void> _fetchCurrentUserDetails() async {
    setState(() {
      _isLoadingUserDetails = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

      if (authToken == null || authToken.isEmpty) {
    setState(() {
          _isLoadingUserDetails = false;
        });
        return;
      }

      final response = await _patientService.getPatientDetails(
        authToken: authToken,
      );

      if (mounted) {
        setState(() {
          if (response.success && response.data != null) {
            _currentUserDetails = response.data;
            // Set patient ID from API response
            _patientId = response.data!.userId;
          }
          _isLoadingUserDetails = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingUserDetails = false;
        });
      }
      debugPrint('Failed to fetch current user details: $e');
    }
  }

  String _formatUserSubtitle() {
    if (_currentUserDetails == null) {
      return ''; // Return empty if no data available
    }

    final user = _currentUserDetails!;
    final parts = <String>[];

    // Gender - not available in API, skip for now
    // TODO: Add gender to API response

    // Date of birth
    if (user.dob != null) {
      final dob = user.dob!;
      final day = dob.day.toString().padLeft(2, '0');
      final month = dob.month.toString().padLeft(2, '0');
      parts.add('$day/$month/${dob.year}');
    }

    // Age
    final age = user.age;
    if (age != null) {
      parts.add('($age)');
    }

    return parts.join(', ');
  }

  String _getCurrentUserName() {
    if (_selectedDependent != null) {
      return _selectedDependent!.fullName;
    }
    return _currentUserDetails?.fullName ?? 'User';
  }

  String _getCurrentUserSubtitle() {
    if (_selectedDependent != null) {
      return _formatDependentSubtitle(_selectedDependent!);
    }
    return _formatUserSubtitle();
  }

  Future<void> _fetchDoctorDetails() async {
    setState(() {
      _isLoadingDoctorDetails = true;
    });

    try {
      // Get auth token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token');

      final response = await _doctorService.getDoctorDetailsForBooking(
        doctorId: widget.doctorId,
        authToken: authToken,
      );

      if (mounted) {
        if (response.success && response.data != null) {
          setState(() {
            _doctor = response.data;
            _updateCurrentLocationDetails();
            _isLoadingDoctorDetails = false;
          });
        } else {
          setState(() {
            _isLoadingDoctorDetails = false;
          });
          debugPrint('Failed to fetch doctor details: ${response.message}');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDoctorDetails = false;
        });
      }
      debugPrint('Failed to fetch doctor details: $e');
    }
  }

  void _updateCurrentLocationDetails() {
    if (_doctor == null) return;

    if (widget.hospitalId != null) {
      final hospital = _doctor!.hospitals.firstWhere(
        (h) => h.id == widget.hospitalId,
        orElse: () => _doctor!.hospitals.isNotEmpty
            ? _doctor!.hospitals.first
            : DoctorHospital(id: '', name: ''),
      );
      if (hospital.id.isNotEmpty) {
        _currentLocationName = hospital.name;
        _currentLocationAddress =
            '${hospital.city ?? ""}, ${hospital.state ?? ""}';
        _currentDistance = hospital.distance?.toStringAsFixed(1);
      }
    } else if (widget.clinicId != null) {
      final clinic = _doctor!.clinics.firstWhere(
        (c) => c.id == widget.clinicId,
        orElse: () => _doctor!.clinics.isNotEmpty
            ? _doctor!.clinics.first
            : DoctorClinic(id: '', name: ''),
      );
      if (clinic.id.isNotEmpty) {
        _currentLocationName = clinic.name;
        _currentLocationAddress = '${clinic.city ?? ""}, ${clinic.state ?? ""}';
        _currentDistance = clinic.distance?.toStringAsFixed(1);
      }
    }
  }

  Widget _buildDoctorInfoShimmer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar shimmer
                  ShimmerLoading(
                    width: 70,
                    height: 70,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name shimmer
                        ShimmerLoading(
                          width: 200,
                          height: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        // Specialization shimmer
                        ShimmerLoading(
                          width: 150,
                          height: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 6),
                        // Education shimmer
                        ShimmerLoading(
                          width: 180,
                          height: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Experience and rating shimmer
              Row(
                children: [
                  ShimmerLoading(
                    width: 100,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(width: 8),
                  ShimmerLoading(
                    width: 60,
                    height: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Location shimmer
              Row(
                children: [
                  ShimmerLoading(
                    width: 150,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Address shimmer
              Row(
                children: [
                  ShimmerLoading(
                    width: 200,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Token banner shimmer
        Container(
          width: double.infinity,
          color: const Color(0xffF8FAFF),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              ShimmerLoading(
                width: 16,
                height: 16,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 8),
              ShimmerLoading(
                width: 30,
                height: 20,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(width: 8),
              ShimmerLoading(
                width: 200,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        const Divider(height: 2, thickness: 0.3, color: Colors.grey),
        const SizedBox(height: 14),
      ],
    );
  }

  // Bottom sheet for selecting reason has been removed.

  String _formatDependentSubtitle(DependentData d) {
    String capitalize(String s) => s.isEmpty
        ? s
        : s[0].toUpperCase() +
              (s.length > 1 ? s.substring(1).toLowerCase() : '');

    final gender = capitalize(d.gender);
    String dobStr = '';
    if (d.dob != null) {
      final dd = d.dob!;
      final day = dd.day.toString().padLeft(2, '0');
      final month = dd.month.toString().padLeft(2, '0');
      dobStr = '$day/$month/${dd.year}';
    }
    final parts = <String>[];
    if (gender.isNotEmpty) parts.add(gender);
    if (dobStr.isNotEmpty) parts.add(dobStr);
    final age = d.age != null ? ' (${d.age})' : '';
    return parts.join(', ') + age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.isReschedule ? 'Reschedule' : 'Review Details',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              clipBehavior: Clip.none,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    child: _isLoadingDoctorDetails
                        ? _buildDoctorInfoShimmer()
                        : DoctorInfoCard(
                            doctor: _doctor,
                            doctorName: widget.doctorName,
                            specialization: widget.doctorSpecialization,
                            locationName: _currentLocationName,
                            locationAddress: _currentLocationAddress,
                            locationDistance: _currentDistance,
                          ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Appointment Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff424242),
                      ),
                    ),
                  ),
                  RepaintBoundary(
                    child: AppointmentDetailItem(
                      iconAssetPath: EcliniqIcons.user.assetPath,
                      title: _selectedDependent?.fullName ?? 
                          (_currentUserDetails?.fullName ?? 'User'),
                      subtitle: _selectedDependent != null
                          ? _formatDependentSubtitle(_selectedDependent!)
                          : _formatUserSubtitle(),
                      badge: _selectedDependent?.relation ?? 'You',
                      showEdit: true,
                      onDependentSelected: (dep) {
                        setState(() {
                          _selectedDependent = dep;
                        });
                      },
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Color(0xffB8B8B8),
                    indent: 15,
                    endIndent: 15,
                  ),
                  RepaintBoundary(
                    child: AppointmentDetailItem(
                      iconAssetPath: EcliniqIcons.calendar.assetPath,
                      title: widget.selectedSlot,
                      subtitle: widget.selectedDate,
                      showEdit: false,
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Color(0xffB8B8B8),
                    indent: 15,
                    endIndent: 15,
                  ),
                  RepaintBoundary(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ClinicLocationCard(
                        hospitalId: widget.hospitalId ?? '',
                        clinicId: widget.clinicId,
                        locationName: _currentLocationName ?? widget.locationName,
                        locationAddress: _currentLocationAddress ?? widget.locationAddress,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Reason for Visit',
                      style: EcliniqTextStyles.headlineXMedium.copyWith(
                        color: Color(0xff626060),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return TextFormField(
                          key: const ValueKey('reason_field'),
                          controller: _reasonController,
                          maxLength: 150,
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Enter Reason for Visit',
                            hintStyle: const TextStyle(
                              color: Color(0xffD6D6D6),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xff626060),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xff626060),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            counterText: '',
                            suffixText: '${_reasonController.text.length}/150',
                            suffixStyle: const TextStyle(
                              color: Color(0xff8E8E8E),
                              fontSize: 12,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Refer By',
                      style: EcliniqTextStyles.headlineXMedium.copyWith(
                        color: Color(0xff626060),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      key: const ValueKey('refer_by_field'),
                      controller: _referByController,
                      decoration: InputDecoration(
                        hintText: 'Enter Who Refer you',
                        hintStyle: const TextStyle(color: Color(0xffD6D6D6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xff626060),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xff626060),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RepaintBoundary(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Details',
                            style: EcliniqTextStyles.headlineLarge.copyWith(
                              color: Color(0xff424242),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Consultation Fee',
                                style: EcliniqTextStyles.headlineXMedium
                                    .copyWith(color: Color(0xff626060)),
                              ),
                              Text(
                                'Pay at Clinic',
                                style: EcliniqTextStyles.headlineXMedium
                                    .copyWith(color: Color(0xff424242)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Service Fee & Tax',
                                    style: EcliniqTextStyles.headlineXMedium
                                        .copyWith(color: Color(0xff626060)),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: Color(0xff424242),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '₹49',
                                    style: EcliniqTextStyles.headlineXLMedium
                                        .copyWith(color: Color(0xff8E8E8E)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Free',
                                    style: EcliniqTextStyles.headlineMedium
                                        .copyWith(color: Color(0xff54B955)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'We care for you and provide a free booking',
                            style: EcliniqTextStyles.buttonSmall.copyWith(
                              color: Color(0xff54B955),
                            ),
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Payable',
                                style: EcliniqTextStyles.headlineLarge.copyWith(
                                  color: Color(0xff424242),
                                ),
                              ),
                              Text(
                                'Pay at Clinic',
                                style: EcliniqTextStyles.headlineLarge.copyWith(
                                  color: Color(0xff424242),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RepaintBoundary(child: const EasyWayToBookWidget()),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(child: _buildConfirmVisitButton()),
          ),
        ],
      ),
    );
  }

  Future<void> _onConfirmVisit() async {
    if (_isBooking) {
      return;
    }

    // Reason is only required for new appointments, not for reschedule
    if (!widget.isReschedule && _reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomErrorSnackBar(
          context: context,
          title: 'Reason required',
          subtitle: 'Please enter a reason for visit',
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    await _loadPatientId();
    
    // Get patient ID from current user details (API) or fallback to stored value
    final finalPatientId = _currentUserDetails?.userId ?? _patientId;
    
    if (finalPatientId == null || finalPatientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomErrorSnackBar(
          context: context,
          title: 'Patient ID Required',
          subtitle: 'Unable to get patient information. Please try again.',
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    try {
      if (widget.isReschedule && widget.appointmentId != null) {

        final rescheduleRequest = RescheduleAppointmentRequest(
          appointmentId: widget.appointmentId!,
          newSlotId: widget.slotId,
        );

        final response = await _appointmentService.rescheduleAppointment(
          request: rescheduleRequest,
          authToken: _authToken,
        );

        if (mounted) {
          if (response.success && response.data != null) {
            final tokenNumber = response.data!.tokenNo.toString();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentRequestScreen(
                  doctorName: widget.doctorName,
                  doctorSpecialization: widget.doctorSpecialization,
                  selectedSlot: widget.selectedSlot,
                  selectedDate: widget.selectedDate,
                  hospitalAddress: _hospitalAddress,
                  tokenNumber: tokenNumber,
                  patientName: _getCurrentUserName(),
                  patientSubtitle: _getCurrentUserSubtitle(),
                  patientBadge: _selectedDependent?.relation ?? 'You',
                ),
              ),
            );
          } else {
            setState(() {
              _isBooking = false;
            });

            // Extract error message from response
            String errorMessage = 'Failed to reschedule appointment';
            if (response.errors != null && response.errors.toString().isNotEmpty) {
              errorMessage = response.errors.toString();
            } else if (response.message.isNotEmpty) {
              errorMessage = response.message;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              CustomErrorSnackBar(
                context: context,
                title: 'Reschedule Failed',
                subtitle: errorMessage,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      } else {
        // Book new appointment
        final isDependent = _selectedDependent != null;
        final request = BookAppointmentRequest(
          patientId: finalPatientId,
          doctorId: widget.doctorId,
          doctorSlotScheduleId: widget.slotId,
          reason: _reasonController.text.trim(),
          referBy: _referByController.text.trim().isEmpty
              ? null
              : _referByController.text.trim(),
          bookedFor: isDependent ? 'DEPENDENT' : 'SELF',
          dependentId: isDependent ? _selectedDependent!.id : null,
        );

        final response = await _appointmentService.bookAppointment(
          request: request,
          authToken: _authToken,
        );

        if (mounted) {
          if (response.success && response.data != null) {
            final appointmentId = response.data!.id;

            // Verify appointment payment
            final verifyRequest = VerifyAppointmentRequest(
              appointmentId: appointmentId,
              paymentStatus: 'COMPLETED',
            );

            await _appointmentService.verifyAppointment(
              request: verifyRequest,
              authToken: _authToken,
            );

            final tokenNumber = response.data!.tokenNo.toString();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentRequestScreen(
                  doctorName: widget.doctorName,
                  doctorSpecialization: widget.doctorSpecialization,
                  selectedSlot: widget.selectedSlot,
                  selectedDate: widget.selectedDate,
                  hospitalAddress: _hospitalAddress,
                  tokenNumber: tokenNumber,
                  patientName: _getCurrentUserName(),
                  patientSubtitle: _getCurrentUserSubtitle(),
                  patientBadge: _selectedDependent?.relation ?? 'You',
                ),
              ),
            );
          } else {
            setState(() {
              _isBooking = false;
            });

            // Extract error message from response
            String errorMessage = 'Failed to book appointment';
            if (response.errors != null && response.errors.toString().isNotEmpty) {
              errorMessage = response.errors.toString();
            } else if (response.message.isNotEmpty) {
              errorMessage = response.message;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              CustomErrorSnackBar(
                context: context,
                title: 'Booking Failed',
                subtitle: errorMessage,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          CustomErrorSnackBar(
            context: context,
            title: widget.isReschedule ? 'Reschedule Failed' : 'Booking Failed',
            subtitle: e.toString().replaceFirst('Exception: ', ''),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Widget _buildConfirmVisitButton() {
    final isButtonEnabled = !_isBooking;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isButtonEnabled ? _onConfirmVisit : null,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: isButtonEnabled
                ? EcliniqButtonType.brandPrimary.backgroundColor(context)
                : EcliniqButtonType.brandPrimary.disabledBackgroundColor(
                    context,
                  ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isBooking)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else ...[
                Text(
                  widget.isReschedule ? 'Confirm Reschedule' : 'Confirm Visit',
                  style: EcliniqTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
