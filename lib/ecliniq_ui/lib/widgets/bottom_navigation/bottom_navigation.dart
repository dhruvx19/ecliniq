import 'package:ecliniq/ecliniq_icons/icons.dart';
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
      decoration: BoxDecoration(color: Color(0xff0D47A1)),
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
                    selectedIconPath: EcliniqIcons.homeFilled.assetPath,
                    isSelected: currentIndex == 0,
                    label: 'Explore',
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(1),
                  behavior: HitTestBehavior.opaque,
                  child: _buildNavItem(
                    iconPath: EcliniqIcons.myVisits.assetPath,
                    selectedIconPath: EcliniqIcons.myVisitsFilled.assetPath,
                    isSelected: currentIndex == 1,
                    label: 'My Visits',
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(2),
                  behavior: HitTestBehavior.opaque,
                  child: _buildNavItem(
                    iconPath: EcliniqIcons.healthfile.assetPath,
                    selectedIconPath: EcliniqIcons.filesFilled.assetPath,
                    isSelected: currentIndex == 2,
                    label: 'Health Files',
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(3),
                  behavior: HitTestBehavior.opaque,
                  child: _buildNavItem(
                    iconPath: EcliniqIcons.profile.assetPath,
                    selectedIconPath: EcliniqIcons.userSelected.assetPath,
                    isSelected: currentIndex == 3,
                    label: 'Profile',
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
    required String selectedIconPath,
    required bool isSelected,
    required String label,
  }) {
    // Selected colors

    const selectedTextColor = Color(0xFFF2F7FF);
    // Unselected colors

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
            height: 3,
            width: 90,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFf96BFFF) : Colors.transparent,
            ),
          ),
          const SizedBox(height: 8),
          SvgPicture.asset(
            isSelected ? selectedIconPath : iconPath,
            width: 32,
            height: 32,
          ),

          Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedTextColor : unselectedTextColor,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
