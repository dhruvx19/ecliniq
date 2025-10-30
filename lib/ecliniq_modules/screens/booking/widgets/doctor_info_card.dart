import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';

class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1565C0).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'M',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF1565C0),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. Milind Chauhan',
                    style: EcliniqTextStyles.headlineLarge.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'General Physician',
                    style: EcliniqTextStyles.titleXLarge.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'MBBS, MD - General Medicine',
                    style: EcliniqTextStyles.titleXLarge.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.work_outline, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '27yrs of exp',
              style: EcliniqTextStyles.titleXLarge.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.star, size: 18, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              '4.0',
              style: EcliniqTextStyles.titleXLarge.copyWith(
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(
              Icons.business_outlined,
              size: 18,
              color: Color(0xFF1565C0),
            ),
            const SizedBox(width: 8),
            Text(
              'Sunrise Family Clinic',
              style: EcliniqTextStyles.titleXLarge.copyWith(
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Change',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1565C0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              'Vishnu Dev Nagar, Wakad',
              style: EcliniqTextStyles.titleXLarge.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '4 Km',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          
          color: Colors.grey.shade200,
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '69',
                style: EcliniqTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Token Number Currently Running',
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
