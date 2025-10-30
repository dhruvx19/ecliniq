import 'package:flutter/material.dart';

class ClinicLocationCard extends StatelessWidget {
  const ClinicLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: Color(0xFF1565C0),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'In-Clinic Consultation',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Amore Clinic, 15, Indrayani River Road, Pune - 411047',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 70,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.map_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child:  Text(
                      'Tap to get the clinic direction',
                      style: TextStyle(fontSize: 14),
                    ),
                
                ),
                SizedBox(height: 4,)
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
