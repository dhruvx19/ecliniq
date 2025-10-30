import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';

class TimeSlotCard extends StatelessWidget {
  final String title;
  final String time;
  final int available;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeSlotCard({
    super.key,
    required this.title,
    required this.time,
    required this.available,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  Color _getAvailabilityColor() {
    if (available <= 2) return const Color(0xFfBE8B00);
    if (available <= 5) return const Color(0xFfBE8B00);
    return const Color(0xFF3EAf3f);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1565C0) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              
              child: Icon(icon, color: const Color(0xFF96bfff), size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title ($time)',
                    style: EcliniqTextStyles.headlineMedium.copyWith(
                      color: isSelected
                          ? const Color(0xFF1565C0)
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getAvailabilityColor().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$available Tokens Available',
                      style: EcliniqTextStyles.titleXLarge.copyWith(
                        color: _getAvailabilityColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
