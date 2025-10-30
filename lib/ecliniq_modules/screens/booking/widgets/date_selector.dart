import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final String selectedDate;
  final Function(String) onDateChanged;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dates = [
      {'label': 'Today, 2 Mar', 'tokens': 25},
      {'label': 'Tom, 3 Mar', 'tokens': 75},
      {'label': 'Tue, 4 Mar', 'tokens': 100},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dates.map((date) {
          final isSelected = selectedDate == date['label'];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onDateChanged(date['label'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1565C0) : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1565C0)
                        : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      date['label'] as String,
                      style: EcliniqTextStyles.titleXBLarge.copyWith(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date['tokens']} Tokens Available',
                      style: EcliniqTextStyles.bodySmall
                      .copyWith(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
