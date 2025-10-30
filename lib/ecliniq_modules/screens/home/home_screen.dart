import 'package:ecliniq/ecliniq_core/router/navigation_helper.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/provider/auth_provider.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/provider/hospital_provider.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/easy_to_book.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/not_feeling_well.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/quick_actions.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/searched_specialities.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/top_bar_widgets/location_search.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/top_bar_widgets/search_bar.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/top_doctors.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/top_hospitals.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_navigation/bottom_navigation.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _currentIndex = 0;

  bool _hasShownLocationSheet = false;

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowLocationSheet();
    });
  }

  void _checkAndShowLocationSheet() {
    if (!_hasShownLocationSheet && mounted) {
      _hasShownLocationSheet = true;
      final hospitalProvider = Provider.of<HospitalProvider>(
        context,
        listen: false,
      );


      if (!hospitalProvider.hasLocation) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showLocationBottomSheet(context);
          }
        });
      }
    }
  }

  void _showLocationBottomSheet(BuildContext context) {
    EcliniqBottomSheet.show(
      context: context,
      child: const LocationBottomSheet(currentLocation: ''),
    );
  }

  void _onTabTapped(int index) {
    // Don't navigate if already on the same tab
    if (index == _currentIndex) {
      return;
    }

    // Navigate using the navigation helper with proper transitions
    NavigationHelper.navigateToTab(context, index, _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return EcliniqScaffold(
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
                LocationSelectorWidget(
                  currentLocation: 'Vishnu Dev Nagar, Wakad',
                ),
                SearchBarWidget(
                  hintText: 'Search Doctors',
                  onSearch: (query) {},
                  onClear: () {},
                  onVoiceSearch: () {},
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 26),
                                QuickActionsWidget(),
                                const SizedBox(height: 6),
                                TopDoctorsWidget(),
                                const SizedBox(height: 24),
                                MostSearchedSpecialities(),
                                const SizedBox(height: 30),
                                NotFeelingWell(),
                                const SizedBox(height: 30),
                                TopHospitalsWidget(),
                                const SizedBox(height: 30),
                                EasyWayToBookWidget(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),

                        EcliniqBottomNavigationBar(
                          currentIndex: _currentIndex,
                          onTap: _onTabTapped,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
