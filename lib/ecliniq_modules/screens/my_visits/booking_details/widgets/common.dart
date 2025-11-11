


import 'package:ecliniq/ecliniq_ui/scripts/ecliniq_ui.dart';
import 'package:flutter/material.dart';

class AppointmentDetailModel {
  final String id;
  final String status;
  final String? tokenNumber;
  final String? expectedTime;
  final String? currentTokenNumber;
  final DoctorInfo doctor;
  final PatientInfo patient;
  final AppointmentTimeInfo timeInfo;
  final ClinicInfo clinic;
  final PaymentInfo payment;
  final int? rating;

  AppointmentDetailModel({
    required this.id,
    required this.status,
    this.tokenNumber,
    this.expectedTime,
    this.currentTokenNumber,
    required this.doctor,
    required this.patient,
    required this.timeInfo,
    required this.clinic,
    required this.payment,
    this.rating,
  });

  factory AppointmentDetailModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailModel(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      tokenNumber: json['token_number'],
      expectedTime: json['expected_time'],
      currentTokenNumber: json['current_token_number'],
      doctor: DoctorInfo.fromJson(json['doctor'] ?? {}),
      patient: PatientInfo.fromJson(json['patient'] ?? {}),
      timeInfo: AppointmentTimeInfo.fromJson(json['time_info'] ?? {}),
      clinic: ClinicInfo.fromJson(json['clinic'] ?? {}),
      payment: PaymentInfo.fromJson(json['payment'] ?? {}),
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'token_number': tokenNumber,
      'expected_time': expectedTime,
      'current_token_number': currentTokenNumber,
      'doctor': doctor.toJson(),
      'patient': patient.toJson(),
      'time_info': timeInfo.toJson(),
      'clinic': clinic.toJson(),
      'payment': payment.toJson(),
      'rating': rating,
    };
  }
}

class DoctorInfo {
  final String name;
  final String specialization;
  final String qualification;
  final double rating;
  final int yearsOfExperience;
  final String? profileImage;

  DoctorInfo({
    required this.name,
    required this.specialization,
    required this.qualification,
    required this.rating,
    required this.yearsOfExperience,
    this.profileImage,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      qualification: json['qualification'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      yearsOfExperience: json['years_of_experience'] ?? 0,
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialization': specialization,
      'qualification': qualification,
      'rating': rating,
      'years_of_experience': yearsOfExperience,
      'profile_image': profileImage,
    };
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'D';
  }
}

class PatientInfo {
  final String name;
  final String gender;
  final String dateOfBirth;
  final int age;
  final bool isSelf;

  PatientInfo({
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.age,
    required this.isSelf,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      age: json['age'] ?? 0,
      isSelf: json['is_self'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'age': age,
      'is_self': isSelf,
    };
  }

  String get displayName => isSelf ? '$name (You)' : name;

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'P';
  }
}

class AppointmentTimeInfo {
  final String date;
  final String time;
  final String displayDate;
  final String consultationType;

  AppointmentTimeInfo({
    required this.date,
    required this.time,
    required this.displayDate,
    required this.consultationType,
  });

  factory AppointmentTimeInfo.fromJson(Map<String, dynamic> json) {
    return AppointmentTimeInfo(
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      displayDate: json['display_date'] ?? '',
      consultationType: json['consultation_type'] ?? 'In-Clinic Consultation',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'display_date': displayDate,
      'consultation_type': consultationType,
    };
  }

  String get fullDateTime => time;
}

class ClinicInfo {
  final String name;
  final String address;
  final String city;
  final String pincode;
  final double latitude;
  final double longitude;
  final double distanceKm;

  ClinicInfo({
    required this.name,
    required this.address,
    required this.city,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
  });

  factory ClinicInfo.fromJson(Map<String, dynamic> json) {
    return ClinicInfo(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      distanceKm: (json['distance_km'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'distance_km': distanceKm,
    };
  }

  String get fullAddress => '$address, $city - $pincode';
}

class PaymentInfo {
  final double consultationFee;
  final double serviceFee;
  final double totalPayable;
  final bool isServiceFeeWaived;
  final String waiverMessage;

  PaymentInfo({
    required this.consultationFee,
    required this.serviceFee,
    required this.totalPayable,
    required this.isServiceFeeWaived,
    required this.waiverMessage,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      consultationFee: (json['consultation_fee'] ?? 0).toDouble(),
      serviceFee: (json['service_fee'] ?? 0).toDouble(),
      totalPayable: (json['total_payable'] ?? 0).toDouble(),
      isServiceFeeWaived: json['is_service_fee_waived'] ?? false,
      waiverMessage:
          json['waiver_message'] ??
          'We care for you and provide a free booking',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consultation_fee': consultationFee,
      'service_fee': serviceFee,
      'total_payable': totalPayable,
      'is_service_fee_waived': isServiceFeeWaived,
      'waiver_message': waiverMessage,
    };
  }
}

class StatusHeader extends StatelessWidget {
  final String status;
  final String? tokenNumber;
  final String? expectedTime;
  final String? currentTokenNumber;

  const StatusHeader({
    super.key,
    required this.status,
    this.tokenNumber,
    this.expectedTime,
    this.currentTokenNumber,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: _buildContent(config),
    );
  }

  Widget _buildContent(_StatusConfig config) {
    if (status == 'confirmed') {
      return Column(
        children: [
          Text(
            config.title,
            style: EcliniqTextStyles.headlineBMedium.copyWith(
              color: config.textColor,
            ),
          ),
          if (tokenNumber != null) ...[
            const SizedBox(height: 4),
            Text(
              'Your Token Number',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              tokenNumber!,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: config.textColor,
              ),
            ),
            if (expectedTime != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(0xFFB8B8B8)),
                ),
                child: Text(
                  'Expected Time - $expectedTime',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ],
            if (currentTokenNumber != null) ...[
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Token Number Currently Running',
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        currentTokenNumber!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      );
    } else if (status == 'requested') {
      return Column(
        children: [
          Text(
            config.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: config.textColor,
            ),
          ),
          if (currentTokenNumber != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Token Number Currently Running',
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    currentTokenNumber!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    } else {
      return Center(
        child: Text(
          config.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: config.textColor,
          ),
        ),
      );
    }
  }

  _StatusConfig _getStatusConfig() {
    switch (status) {
      case 'confirmed':
        return _StatusConfig(
          title: 'Booking Confirmed',
          backgroundColor: const Color(0xFFE8F5E9),
          textColor: const Color(0xFF2E7D32),
        );
      case 'completed':
        return _StatusConfig(
          title: 'Your Appointment is Completed',
          backgroundColor: const Color(0xFFE3F2FD),
          textColor: const Color(0xFF1976D2),
        );
      case 'cancelled':
        return _StatusConfig(
          title: 'Your booking has been cancelled',
          backgroundColor: const Color(0xFFFFEBEE),
          textColor: const Color(0xFFD32F2F),
        );
      case 'requested':
        return _StatusConfig(
          title: 'Requested',
          backgroundColor: const Color(0xFFFFF3E0),
          textColor: const Color(0xFFF57C00),
        );
      default:
        return _StatusConfig(
          title: status,
          backgroundColor: Colors.grey[200]!,
          textColor: Colors.grey[800]!,
        );
    }
  }
}

class _StatusConfig {
  final String title;
  final Color backgroundColor;
  final Color textColor;

  _StatusConfig({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });
}

class DoctorInfoCard extends StatelessWidget {
  final DoctorInfo doctor;

  const DoctorInfoCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Center(
            child: Text(
              doctor.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                doctor.specialization,
                style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 2),
              Text(
                doctor.qualification,
                style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DoctorStatsRow extends StatelessWidget {
  final DoctorInfo doctor;
  final ClinicInfo clinic;

  const DoctorStatsRow({super.key, required this.doctor, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatItem(
          icon: Icons.calendar_today_outlined,
          text: '${doctor.yearsOfExperience}yrs of exp',
        ),
        const SizedBox(width: 4),
        _buildStatItem(
          icon: Icons.star,
          text: doctor.rating.toString(),
          iconColor: Colors.amber,
        ),
        const Spacer(),
        _buildStatItem(
          icon: Icons.location_on_outlined,
          text: '${clinic.distanceKm} Km',
          textColor: const Color(0xFF2372EC),
        ),
        TextButton(
          onPressed: () {

          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 20),
          ),
          child: const Text(
            'Change',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2372EC),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String text,
    Color? iconColor,
    Color? textColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor ?? const Color(0xFF666666)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: textColor ?? const Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}

class AppointmentDetailsSection extends StatelessWidget {
  final PatientInfo patient;
  final AppointmentTimeInfo timeInfo;

  const AppointmentDetailsSection({
    super.key,
    required this.patient,
    required this.timeInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Appointment Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow(
          icon: Icons.person_outline,
          text: patient.displayName,
          subtitle:
              '${patient.gender}, ${patient.dateOfBirth} (${patient.age}Y)',
        ),
        const SizedBox(height: 12),
        _buildDetailRow(icon: Icons.access_time, text: timeInfo.fullDateTime),
        const SizedBox(height: 12),
        _buildDetailRow(
          icon: Icons.medical_services_outlined,
          text: timeInfo.consultationType,
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
    String? subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF666666)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(fontSize: 18, color: Color(0xFF424242)),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
              Divider(color: Colors.grey[300]),
            ],
          ),
        ),
      ],
    );
  }
}

class ClinicLocationCard extends StatelessWidget {
  final ClinicInfo clinic;

  const ClinicLocationCard({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_city, size: 24, color: Color(0xFF666666)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                clinic.fullAddress,
                style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Center(child: Icon(Icons.map, size: 48, color: Colors.grey[400])),
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Tap to get the clinic direction'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2372EC),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PaymentDetailsCard extends StatelessWidget {
  final PaymentInfo payment;

  const PaymentDetailsCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        _buildPaymentRow('Consultation Fee', payment.consultationFee),
        const SizedBox(height: 12),
        _buildPaymentRow(
          'Service Fee & Tax',
          payment.serviceFee,
          originalAmount: payment.isServiceFeeWaived ? 40 : null,
          isFree: payment.isServiceFeeWaived,
          subtitle: payment.isServiceFeeWaived ? payment.waiverMessage : null,
        ),
        const Divider(height: 24),
        _buildPaymentRow('Total Payable', payment.totalPayable, isBold: true),
      ],
    );
  }

  Widget _buildPaymentRow(
    String label,
    double amount, {
    double? originalAmount,
    bool isFree = false,
    String? subtitle,
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                    color: const Color(0xFF333333),
                  ),
                ),
                if (isFree)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Color(0xFF666666),
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                if (originalAmount != null)
                  Text(
                    '₹${originalAmount.toInt()}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                if (originalAmount != null) const SizedBox(width: 8),
                Text(
                  isFree ? 'Free' : '₹${amount.toInt()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                    color: isFree
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF4CAF50)),
          ),
        ],
      ],
    );
  }
}

class RatingSection extends StatefulWidget {
  final int? initialRating;
  final Function(int) onRatingChanged;

  const RatingSection({
    super.key,
    this.initialRating,
    required this.onRatingChanged,
  });

  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate your Experience :',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                  widget.onRatingChanged(_rating);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 36,
                    color: index < _rating
                        ? Colors.amber
                        : const Color(0xFFE0E0E0),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}




class AppointmentApiService {

  static const String baseUrl = 'https://your-api-url.com/api/v1';


  Future<AppointmentDetailModel> fetchAppointmentDetail(
    String appointmentId,
  ) async {
    try {







      await Future.delayed(const Duration(seconds: 1));


      String status;
      String? tokenNumber;
      String? expectedTime;
      String? currentTokenNumber;

      switch (appointmentId) {
        case '1':
          status = 'confirmed';
          tokenNumber = '76';
          expectedTime = '2:30PM';
          currentTokenNumber = '67';
          break;
        case '2':
          status = 'requested';
          tokenNumber = null;
          expectedTime = null;
          currentTokenNumber = '67';
          break;
        case '3':
          status = 'cancelled';
          tokenNumber = null;
          expectedTime = null;
          currentTokenNumber = null;
          break;
        case '4':
          status = 'completed';
          tokenNumber = '45';
          expectedTime = null;
          currentTokenNumber = null;
          break;
        default:
          status = 'confirmed';
          tokenNumber = '76';
          expectedTime = '2:30PM';
          currentTokenNumber = '67';
      }

      final mockJson = {
        'id': appointmentId,
        'status': status,
        'token_number': tokenNumber,
        'expected_time': expectedTime,
        'current_token_number': currentTokenNumber,
        'doctor': {
          'name': 'Dr. Milind Chauhan',
          'specialization': 'General Physician',
          'qualification': 'MBBS, MD - General Medicine',
          'rating': 4.0,
          'years_of_experience': 27,
        },
        'patient': {
          'name': 'Ketan Patni',
          'gender': 'Male',
          'date_of_birth': '02/02/1996',
          'age': 29,
          'is_self': true,
        },
        'time_info': {
          'date': '2025-03-02',
          'time': '10:00am - 12:00pm',
          'display_date': 'Today, 2 March 2025',
          'consultation_type': 'In-Clinic Consultation',
        },
        'clinic': {
          'name': 'Sunrise Family Clinic',
          'address': 'Amore Clinic, 15, Indrayani River Road, Pune',
          'city': 'Pune',
          'pincode': '411047',
          'latitude': 18.5204,
          'longitude': 73.8567,
          'distance_km': 4.0,
        },
        'payment': {
          'consultation_fee': 700.0,
          'service_fee': 0.0,
          'total_payable': 700.0,
          'is_service_fee_waived': true,
          'waiver_message': 'We care for you and provide a free booking',
        },
        'rating': null,
      };

      return AppointmentDetailModel.fromJson(mockJson);
    } catch (e) {
      throw Exception('Failed to fetch appointment details: $e');
    }
  }


  Future<bool> cancelAppointment(String appointmentId) async {
    try {






      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }


  Future<bool> rescheduleAppointment(
    String appointmentId,
    String newDate,
    String newTime,
  ) async {
    try {







      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('Failed to reschedule appointment: $e');
    }
  }


  Future<bool> submitRating(String appointmentId, int rating) async {
    try {







      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      throw Exception('Failed to submit rating: $e');
    }
  }


  Future<bool> requestCallback(String appointmentId) async {
    try {

      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('Failed to request callback: $e');
    }
  }
}
