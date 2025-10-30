import 'package:flutter/material.dart';

class CustomSuccessSnackBar extends SnackBar {
  CustomSuccessSnackBar({
    required String title,
    required String subtitle,
    Duration duration = const Duration(seconds: 3),
  }) : super(
          content: _SuccessSnackBarContent(
            title: title,
            subtitle: subtitle,
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          padding: EdgeInsets.zero,
          elevation: 8,
          duration: duration,
        );
}

class _SuccessSnackBarContent extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SuccessSnackBarContent({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE0E0E0), // Dark gray outer ring
                    width: 2,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50), // Light green
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50), // Green
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 8),
          // Green stripe at the bottom
          Container(
            height: 3,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50), // Green
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

