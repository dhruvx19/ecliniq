import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/my_files.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/recently_uploaded.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/upload_bottom_sheet.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/upload_timeline.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/top_bar_widgets/search_bar.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HealthFiles extends StatefulWidget {
  const HealthFiles({super.key});

  @override
  State<HealthFiles> createState() => _HealthFilesState();
}

class _HealthFilesState extends State<HealthFiles> {
  int _currentIndex = 2;
  bool isLoading = false;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index != 2) {

    }
  }

  void _showUploadBottomSheet(BuildContext context) {
    EcliniqBottomSheet.show(context: context, child: UploadBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        EcliniqScaffold(
          backgroundColor: EcliniqScaffold.primaryBlue,
          body: SizedBox.expand(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        EcliniqIcons.nameLogo.assetPath,
                        height: 28,
                        width: 140,
                      ),
                      const Spacer(),
                      Image.asset(
                        EcliniqIcons.bell.assetPath,
                        height: 32,
                        width: 32,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SearchBarWidget(
                                  hintText: 'Search File',
                                  onSearch: (query) {

                                  },
                                  onClear: () {

                                  },
                                  onVoiceSearch: () {

                                  },
                                ),
                                const MyFilesWidget(),
                                const RecentlyUploadedWidget(),
                                UploadTimeline(),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                        Container(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _onTabTapped(0),
                                      behavior: HitTestBehavior.opaque,
                                      child: _buildNavItem(
                                        iconPath: EcliniqIcons.home.assetPath,
                                        isSelected: _currentIndex == 0,
                                        label: 'Explore',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _onTabTapped(1),
                                      behavior: HitTestBehavior.opaque,
                                      child: _buildNavItem(
                                        iconPath:
                                            EcliniqIcons.appointment.assetPath,
                                        isSelected: _currentIndex == 1,
                                        label: 'My Visits',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _onTabTapped(2),
                                      behavior: HitTestBehavior.opaque,
                                      child: _buildNavItem(
                                        iconPath:
                                            EcliniqIcons.library.assetPath,
                                        isSelected: _currentIndex == 2,
                                        label: 'Health Files',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _onTabTapped(3),
                                      behavior: HitTestBehavior.opaque,
                                      child: _buildNavItem(
                                        iconPath: EcliniqIcons.user.assetPath,
                                        isSelected: _currentIndex == 3,
                                        label: 'Profile',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          right: 20,
          bottom: 120,
          child: GestureDetector(
            onTap: () => _showUploadBottomSheet(context),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: EcliniqScaffold.darkBlue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.upload_file, color: Colors.white, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (isLoading)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required bool isSelected,
    required String label,
  }) {
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
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: Colors.white.withOpacity(isSelected ? 1.0 : 0.7),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(isSelected ? 1.0 : 0.7),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
