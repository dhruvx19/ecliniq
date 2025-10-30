import 'package:flutter/material.dart';

class UploadTimeline extends StatelessWidget {
  const UploadTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Timeline',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xff424242),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 130,
                  left: 20,
                  right: 20,
                  child: Opacity(
                    opacity: 0.4,
                    child: Transform.scale(
                      scale: 0.95,
                      child: const PrescriptionCard(
                        day: '23',
                        month: 'May',
                        isOlder: true,
                        showShadow: false,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 65,
                  left: 12,
                  right: 12,
                  child: Opacity(
                    opacity: 0.8,
                    child: Transform.scale(
                      scale: 0.97,
                      child: const PrescriptionCard(day: '01', month: 'Aug'),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: const PrescriptionCard(day: '09', month: 'Aug'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrescriptionCard extends StatelessWidget {
  final String day;
  final String month;
  final bool isOlder;
  final bool showShadow;

  const PrescriptionCard({
    super.key,
    required this.day,
    required this.month,
    this.isOlder = false,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xffD6D6D6)),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: const Color(0x33000000),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isOlder ? Colors.grey[400] : Colors.black87,
                  ),
                ),
                Text(
                  month,
                  style: TextStyle(
                    fontSize: 14,
                    color: isOlder ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          Container(
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.medication, size: 10),
                        SizedBox(width: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Container(
                        height: 2,
                        width: double.infinity,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prescription.pdf',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isOlder ? Colors.grey[500] : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prescription',
                  style: TextStyle(
                    fontSize: 14,
                    color: isOlder ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isOlder ? Colors.grey[300] : Colors.orange[400],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.insert_drive_file,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
