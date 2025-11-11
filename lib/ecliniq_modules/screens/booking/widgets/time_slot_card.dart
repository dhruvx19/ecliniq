import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeSlotCard extends StatefulWidget {
  final String title;
  final String time;
  final int available;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeSlotCard({
    super.key,
    required this.title,
    required this.time,
    required this.available,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<TimeSlotCard> createState() => _TimeSlotCardState();
}

class _TimeSlotCardState extends State<TimeSlotCard> {
  bool _isPressed = false;

  Color _getAvailabilityColor() {
    if (widget.available <= 2) return const Color(0xFFBE8B00);
    if (widget.available <= 5) return const Color(0xFFBE8B00);
    return const Color(0xFF3EAf3f);
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (_isPressed) {
      backgroundColor = const Color(0xFF2372EC);
      borderColor = const Color(0xFF2372EC);
      textColor = Colors.white;
    } else if (widget.isSelected) {
      backgroundColor = const Color(0xFFF8FAFF);
      borderColor = const Color(0xFF0D47A1);
      textColor = const Color(0xFF0D47A1);
    } else {
      backgroundColor = Colors.white;
      borderColor = Colors.grey[300]!;
      textColor = Colors.black87;
    }

    return Listener(
      onPointerDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onPointerUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onPointerCancel: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
              width: widget.isSelected ? 0.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  widget.iconPath,
                  width: 32,
                  height: 32,
                  colorFilter: _isPressed
                      ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.title} (${widget.time})',
                      style: EcliniqTextStyles.headlineMedium.copyWith(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _isPressed
                            ? Colors.white.withOpacity(0.9)
                            : _getAvailabilityColor().withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${widget.available} Tokens Available',
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
      ),
    );
  }
}
