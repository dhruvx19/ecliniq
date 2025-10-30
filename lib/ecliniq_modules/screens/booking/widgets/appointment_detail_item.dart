import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';

class AppointmentDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final bool showEdit;

  const AppointmentDetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.showEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1565C0), size: 24),
          ),
          const SizedBox(width: 16),
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
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge!,
                          style: EcliniqTextStyles.titleXLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: EcliniqTextStyles.titleXLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (showEdit)
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () {},
              color: Colors.grey[600],
            ),
        ],
      ),
    );
  }
}
