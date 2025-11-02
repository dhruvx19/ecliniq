import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EcliniqBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const EcliniqBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: EcliniqScaffold.primaryBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(0),
                  behavior: HitTestBehavior.opaque,
                  child: _buildNavItem(
                    iconPath: EcliniqIcons.explore.assetPath,
                    isSelected: currentIndex == 0,
                    label: 'Explore',
                    isSvg: true,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(1),
                  behavior: HitTestBehavior.opaque,
                  child: _buildNavItem(
                    iconPath: EcliniqIcons.myVisits.assetPath,
                    isSelected: currentIndex == 1,
                    label: 'My Visits',
                    isSvg: true,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(2),
                  behavior: HitTestBehavior.opaque,
                  child: _buildNavItem(
                    iconPath: EcliniqIcons.healthfile.assetPath,
                    isSelected: currentIndex == 2,
                    label: 'Health Files',
                    isSvg: true,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(3),
                  behavior: HitTestBehavior.opaque,
                  child: _buildNavItem(
                    iconPath: EcliniqIcons.profile.assetPath,
                    isSelected: currentIndex == 3,
                    label: 'Profile',
                    isSvg: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required bool isSelected,
    required String label,
    required bool isSvg,
  }) {
    // Selected colors
    const selectedIconColor = Color(0xFF96BFFF);
    const selectedTextColor = Color(0xFFF2F7FF);
    // Unselected colors
    const unselectedIconColor = Colors.white;
    const unselectedTextColor = Colors.white;

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0E4395) : Colors.transparent,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 90,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF96BFFF) : Colors.transparent,
            ),
          ),
          const SizedBox(height: 8),

          SvgPicture.asset(
            iconPath,
            width: 32,
            height: 32,
            colorFilter: isSelected
                ? ColorFilter.mode(
                    selectedIconColor,
                    BlendMode.srcIn,
                  )
                : ColorFilter.mode(
                    unselectedIconColor,
                    BlendMode.srcIn,
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedTextColor : unselectedTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
