import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentDetailItem extends StatelessWidget {
  final String iconAssetPath; // Changed from IconData to String for asset path
  final String title;
  final String subtitle;
  final String? badge;
  final bool showEdit;

  const AppointmentDetailItem({
    super.key,
    required this.iconAssetPath, // Now expects asset path string
    required this.title,
    required this.subtitle,
    this.badge,
    required this.showEdit,
  });

  static final Color _primaryColor = const Color(0xFF1565C0);
  static final Color _badgeColor = _primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          SvgPicture.asset(iconAssetPath, width: 32, height: 32),
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
                        color: Color(0xff424242),
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
                          color: _badgeColor,
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
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: EcliniqTextStyles.titleXLarge.copyWith(
                    color: Color(0xff8E8E8E),
                  ),
                ),
              ],
            ),
          ),
          if (showEdit)
            SvgPicture.asset(
              EcliniqIcons.editIcon.assetPath,
              width: 48,
              height: 48,
            ),
        ],
      ),
    );
  }
}
