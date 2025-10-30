import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/widgets/common.dart';
import 'package:flutter/material.dart';

class BookingCompletedDetail extends StatefulWidget {
  final AppointmentDetailModel appointment;

  const BookingCompletedDetail({Key? key, required this.appointment})
    : super(key: key);

  @override
  State<BookingCompletedDetail> createState() => _BookingCompletedDetailState();
}

class _BookingCompletedDetailState extends State<BookingCompletedDetail> {
  int _userRating = 0;

  @override
  void initState() {
    super.initState();
    _userRating = widget.appointment.rating ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Align(
           alignment: Alignment.centerLeft,
          child: const Text(
            'Booking Detail',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
        
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StatusHeader(status: widget.appointment.status),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorInfoCard(doctor: widget.appointment.doctor),
                  const SizedBox(height: 12),
                  DoctorStatsRow(
                    doctor: widget.appointment.doctor,
                    clinic: widget.appointment.clinic,
                  ),
                  const SizedBox(height: 24),
                  RatingSection(
                    initialRating: _userRating,
                    onRatingChanged: (rating) {
                      setState(() {
                        _userRating = rating;
                      });
                      _submitRating(rating);
                    },
                  ),
                  const SizedBox(height: 24),
                  AppointmentDetailsSection(
                    patient: widget.appointment.patient,
                    timeInfo: widget.appointment.timeInfo,
                  ),
                  const SizedBox(height: 24),
                  ClinicLocationCard(clinic: widget.appointment.clinic),
                  const SizedBox(height: 24),
                  _buildPrescriptionSection(),
                  const SizedBox(height: 24),
                  PaymentDetailsCard(payment: widget.appointment.payment),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(context),
    );
  }

  Widget _buildPrescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, color: Color(0xFF2372EC), size: 32),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prescription Available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'View your consultation prescription',
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2372EC),
            ),
            child: const Text('View'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {

                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2372EC),
                  side: const BorderSide(color: Color(0xFF2372EC)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('View Prescription'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2372EC),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Book Follow-up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _submitRating(int rating) async {

    print('Submitting rating: $rating for appointment: ${widget.appointment.id}');
  }
}
