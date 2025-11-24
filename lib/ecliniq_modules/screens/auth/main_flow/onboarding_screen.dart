import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/main_flow/phone_input.dart';
import 'package:ecliniq/ecliniq_modules/screens/login/login_trouble.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EcliniqWelcomeScreen extends StatefulWidget {
  const EcliniqWelcomeScreen({super.key});

  @override
  State<EcliniqWelcomeScreen> createState() => _EcliniqWelcomeScreenState();
}

class _EcliniqWelcomeScreenState extends State<EcliniqWelcomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  bool _showFullScreenInput = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _openFullScreenInput() {
    setState(() {
      _showFullScreenInput = true;
    });
    _animationController.forward();
  }

  void _closeFullScreenInput() {
    _animationController.reverse().then((_) {
      setState(() {
        _showFullScreenInput = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return EcliniqScaffold(
      backgroundColor: EcliniqScaffold.primaryBlue,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [_buildHeader(), _buildWelcomeText()],
                  ),
                ),
              ),

              Expanded(flex: 1, child: _buildPhoneInputSection()),
            ],
          ),

          if (_showFullScreenInput)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      MediaQuery.of(context).size.height *
                          _slideAnimation.value,
                    ),
                    child: PhoneInputScreen(
                      phoneController: _phoneController,
                      onClose: _closeFullScreenInput,
                      fadeAnimation: _fadeAnimation,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        'eClinic-Q',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          // Optimize: Use cacheWidth/cacheHeight for better performance
          Image.asset(
            EcliniqIcons.main.assetPath,
            width: 280,
            height: 280,
            cacheWidth: 560,
            cacheHeight: 560,
            filterQuality: FilterQuality.medium,
          ),
          const Text(
            'Welcome To eClinic-Q',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your Turn, Your Time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Track Appointments in Real-Time!',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 20),

          // Optimize: Pre-build list items instead of generating on each build
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildIndicatorDots(),
          ),
        ],
      ),
    );
  }

  // Cache indicator dots to avoid rebuilding
  List<Widget> _buildIndicatorDots() {
    return List.generate(5, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: index == 0 ? 12 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: index == 0 ? Colors.white : Colors.white38,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    });
  }

  Widget _buildPhoneInputSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                EcliniqText(
                  'Enter Your Mobile Number',
                  style: EcliniqTextStyles.headlineXMedium.copyWith(
                    color: Color(0xff626060),
                  ),
                ),
                const SizedBox(height: 6),

                GestureDetector(
                  onTap: _openFullScreenInput,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xff626060), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '+91',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff424242),
                                ),
                              ),
                              const SizedBox(width: 4),
                              SvgPicture.asset(
                                EcliniqIcons.arrowDown.assetPath,
                                width: 20,
                                height: 20,
                             
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Text(
                              _phoneController.text.isEmpty
                                  ? 'Mobile Number'
                                  : _phoneController.text,
                              style: TextStyle(
                                fontSize: 16,
                                color: _phoneController.text.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    EcliniqRouter.push(LoginTroublePage());
                  },
                  child: EcliniqText(
                    'Trouble signing in ?',
                    style: EcliniqTextStyles.headlineXMedium.copyWith(
                      color: Color(0xff424242),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
