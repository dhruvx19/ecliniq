import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/widgets/common.dart';
import 'package:flutter/material.dart';

class BookingCancelledDetail extends StatelessWidget {
  final AppointmentDetailModel appointment;

  const BookingCancelledDetail({
    Key? key,
    required this.appointment,
  }) : super(key: key);

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
                  AppointmentDetailsSection(
                    patient: appointment.patient,
                    timeInfo: appointment.timeInfo,
                  ),
                  const SizedBox(height: 24),
                  ClinicLocationCard(clinic: appointment.clinic),
                  const SizedBox(height: 24),
                  PaymentDetailsCard(payment: appointment.payment),
                  const SizedBox(height: 24),
                  _buildCallbackSection(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildCallbackSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Easy Way to book',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.phone_callback,
              color: Color(0xFF2372EC),
            ),
            title: const Text(
              'Request a Callback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Assisted booking with expert',
              style: TextStyle(fontSize: 14),
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2372EC),
              ),
              child: const Text('Call Us'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
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
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2372EC),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Book Again',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}