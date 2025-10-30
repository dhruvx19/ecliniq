import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/widgets/common.dart';
import 'package:flutter/material.dart';

class BookingRequestedDetail extends StatelessWidget {
  final AppointmentDetailModel appointment;

  const BookingRequestedDetail({super.key, required this.appointment});

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
            StatusHeader(
              status: appointment.status,
              currentTokenNumber: appointment.currentTokenNumber,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorInfoCard(doctor: appointment.doctor),
                  const SizedBox(height: 12),
                  DoctorStatsRow(
                    doctor: appointment.doctor,
                    clinic: appointment.clinic,
                  ),
                  const SizedBox(height: 24),
                  _buildRequestNote(),
                  const SizedBox(height: 24),
                  AppointmentDetailsSection(
                    patient: appointment.patient,
                    timeInfo: appointment.timeInfo,
                  ),
                  const SizedBox(height: 24),
                  ClinicLocationCard(clinic: appointment.clinic),
                  const SizedBox(height: 24),
                  PaymentDetailsCard(payment: appointment.payment),
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

  Widget _buildRequestNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF57C00)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF0D47A1)),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showCancelDialog(context);
                },
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancel Booking'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD32F2F),
                  side: const BorderSide(color: Color(0xFFD32F2F)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You can cancel your booking up to 30min before the scheduled time.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep it'),
          ),
          ElevatedButton(
            onPressed: () {

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
