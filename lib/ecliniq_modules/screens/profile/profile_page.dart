import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/provider/auth_provider.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/my_doctors/my_doctor.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/personal_details/personal_detail.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/security_settings/security_settings.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/widgets/account_card.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/widgets/basic_info.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/widgets/dependent.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/widgets/more_card.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/widgets/notification_card.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/widgets/physical_card.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/widgets/user_info.dart'
    hide BasicInfoCards, ProfileHeader;
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSettings() {}

  void _handleAddDependent() {}

  void _handleDependentTap(Dependent dependent) {}

  void _handleAppUpdate() {}

  void _navigateToPersonalDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonalDetails(),
      ));
  }

  void _onMyDoctorsPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyDoctors(),
        ));
  }

  void _navigateToSecuritySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SecuritySettingsOptions(),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userName = "Ketan Patni";
        final userPhone = "+91 91753 67487";
        final userEmail = "ketanpatni@gmail.com";
        final isPhoneVerified = true;
        final age = "29y 3m";
        final gender = "Male";
        final bloodGroup = "B+";
        final healthStatus = "Healthy";
        final bmi = 22.5;
        final height = "180.3 cm";
        final weight = "69 kg";
        final currentVersion = "v1.0.0";
        final newVersion = "v1.0.1";
        final dependents = [
          Dependent(id: "1", name: "Father's Name", relation: "Father"),
        ];
        double topMargin = MediaQuery.of(context).size.height * 0.19;
        double radius = 60;
        return EcliniqScaffold(
          body: Stack(
            children: [
              Container(
                height: topMargin * 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2372EC), Color(0xFFF3F5FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Background pattern
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: (MediaQuery.of(context).size.height / 3),
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    EcliniqIcons.lottie.assetPath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Profile Header
              ProfileHeader(onSettingsPressed: _handleSettings),


              Positioned(
                top: topMargin,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipPath(
                  clipper: TopCircleCutClipper(radius: 50, topCut: 30),
                  child: Container(
                    padding: const EdgeInsets.only(top: 90),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          UserInfoSection(
                            name: userName,
                            phone: userPhone,
                            email: userEmail,
                            isPhoneVerified: isPhoneVerified,
                          ),

                          const SizedBox(height: 30),

                          BasicInfoCards(
                            age: age,
                            gender: gender,
                            bloodGroup: bloodGroup,
                          ),

                          const SizedBox(height: 30),

                          PhysicalHealthCard(
                            status: healthStatus,
                            bmi: bmi,
                            height: height,
                            weight: weight,
                          ),

                          const SizedBox(height: 30),

                          DependentsSection(
                            dependents: dependents,
                            onAddDependent: _handleAddDependent,
                            onDependentTap: _handleDependentTap,
                          ),

                          const SizedBox(height: 30),

                          AppUpdateBanner(
                            currentVersion: currentVersion,
                            newVersion: newVersion,
                            onUpdate: _handleAppUpdate,
                          ),

                          const SizedBox(height: 20),

                          AccountSettingsMenu(
                            onPersonalDetailsPressed:
                                _navigateToPersonalDetails,
                            onMyDoctorsPressed: _onMyDoctorsPressed,
                            onSecuritySettingsPressed:
                                _navigateToSecuritySettings,
                          ),

                          const SizedBox(height: 20),

                          NotificationsSettingsWidget(
                            onSettingsChanged: (settings) {},
                          ),

                          const SizedBox(height: 20),

                          MoreSettingsMenuWidget(
                            appVersion: 'v1.0.0',
                            supportEmail: 'Support@eclinicq.com',
                            onReferEarnPressed: () {},
                            onHelpSupportPressed: () {},
                            onTermsPressed: () {},
                            onPrivacyPressed: () {},
                            onFaqPressed: () {},
                            onAboutPressed: () {},
                            onLogoutPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text(
                                    'Are you sure you want to logout?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDeleteAccountPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Account'),
                                  content: const Text(
                                    'Are you sure you want to delete your account? This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),


              Positioned(
                top: topMargin - 13,
                left: MediaQuery.of(context).size.width / 2 - 43,
                child: Container(
                  height: 86,
                  width: 86,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFDFE8FF),
                    child: SvgPicture.asset(
                      'lib/ecliniq_icons/assets/Group.svg',

                      width: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TopCircleCutClipper extends CustomClipper<Path> {
  final double radius;
  final double topCut;

  TopCircleCutClipper({required this.radius, required this.topCut});

  @override
  Path getClip(Size size) {
    final rectPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, topCut, size.width, size.height - topCut),
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
        ),
      );

    final circlePath = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(size.width / 2, topCut), radius: radius),
      );

    final finalPath = Path.combine(
      PathOperation.difference,
      rectPath,
      circlePath,
    );

    return finalPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
