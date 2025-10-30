import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/booking_confirmed_screen.dart';
import 'package:ecliniq/ecliniq_ui/scripts/ecliniq_ui.dart';
import 'package:flutter/material.dart';

class AppointmentRequestScreen extends StatefulWidget {
  const AppointmentRequestScreen({super.key});

  @override
  State<AppointmentRequestScreen> createState() =>
      _AppointmentRequestScreenState();
}

class _AppointmentRequestScreenState extends State<AppointmentRequestScreen> {
  @override
  void initState() {
    super.initState();
    _makeApiCall();
  }

  Future<void> _makeApiCall() async {
    
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BookingConfirmedScreen(),
        ),
      );
    }
  }

  void _handleOkPressed() {

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),


              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  EcliniqIcons.appointment1.assetPath,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),


              const Text(
                'Appointment Request',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),


              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'sent to ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Dr. Milind Chauhan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xfff0d47a1),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),


              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFA726), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Color(0xFF1565C0),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Your booking request will be confirmed once the doctor approves it. You will receive your token number details via WhatsApp and SMS.',
                        style: EcliniqTextStyles.titleXLarge.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),


              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      Icons.person_outline,
                      'Ketan Patni',
                      'Male, 02/02/1996 (29Y)',
                      badge: 'You',
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      Icons.calendar_today_outlined,
                      '10:00am - 12:00pm',
                      'Today, 2 March 2025',
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      Icons.business_outlined,
                      'In-Clinic Consultation',
                      'Amore Clinic, 15, Indrayani River Road, Pune - 411047',
                    ),
                  ],
                ),
              ),

              const Spacer(),


              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleOkPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Ok',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String subtitle, {
    String? badge,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          
          child: Icon(icon, color: const Color(0xFF1565C0), size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: EcliniqTextStyles.headlineMedium.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: EcliniqTextStyles.titleXLarge.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
