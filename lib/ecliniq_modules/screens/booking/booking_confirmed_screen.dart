import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SizedBox(
                width: 250,
                height: 200,
                child: Image.asset(
                  EcliniqIcons.appointment2.assetPath,
                  fit: BoxFit.contain,
                ),
              ),

              const Text(
                'Booking Confirmed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'With ',
                  style: TextStyle(fontSize: 24, color: Colors.black),
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
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Your Token Number',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),

                    Text(
                      '76',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                height: 52,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1565C0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View Details',
                        style: EcliniqTextStyles.headlineMedium.copyWith(
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF1565C0),
                        size: 20,
                      ),
                    ],
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
