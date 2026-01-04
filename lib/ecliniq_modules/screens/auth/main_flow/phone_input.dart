import 'package:ecliniq/ecliniq_core/auth/secure_storage.dart';
import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/main_flow/otp_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/provider/auth_provider.dart';
import 'package:ecliniq/ecliniq_modules/screens/login/login_trouble.dart';
import 'package:ecliniq/ecliniq_modules/screens/login/profile_help.dart';
import 'package:ecliniq/ecliniq_modules/screens/login/terms_and_conditions.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/button/button.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PhoneInputScreen extends StatefulWidget {
  final TextEditingController phoneController;
  final VoidCallback onClose;
  final Animation<double> fadeAnimation;
  final bool isForgotPinFlow;

  const PhoneInputScreen({
    super.key,
    required this.phoneController,
    required this.onClose,
    required this.fadeAnimation,
    this.isForgotPinFlow = false,
  });

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen>
    with WidgetsBindingObserver {
  bool _isPhoneNumberValid = false;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    widget.phoneController.addListener(_onPhoneNumberChanged);
    WidgetsBinding.instance.addObserver(this);
    _loadSavedPhoneNumber();
    _onPhoneNumberChanged();
  }

  /// Load saved phone number from secure storage and pre-fill the input
  Future<void> _loadSavedPhoneNumber() async {
    try {
      final savedPhone = await SecureStorageService.getPhoneNumber();
      if (savedPhone != null && savedPhone.isNotEmpty && mounted) {
        // Remove country code if present (e.g., +91 or 91)
        String phoneNumber = savedPhone
            .replaceAll(RegExp(r'^\+?91'), '')
            .trim();
        if (phoneNumber.length == 10) {
          widget.phoneController.text = phoneNumber;
          print('✅ Pre-filled phone number from storage: $phoneNumber');
        }
      }
    } catch (e) {
      print('⚠️ Error loading saved phone number: $e');
    }
  }

  @override
  void dispose() {
    widget.phoneController.removeListener(_onPhoneNumberChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isButtonPressed) {
      setState(() {
        _isButtonPressed = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isButtonPressed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isButtonPressed = false;
          });
        }
      });
    }
  }

  void _onPhoneNumberChanged() {
    final phone = widget.phoneController.text.trim();
    final isValid = phone.length == 10;

    if (_isPhoneNumberValid != isValid) {
      setState(() {
        _isPhoneNumberValid = isValid;
      });
    }
  }

  Future<void> _submitPhoneNumber() async {
    final phone = widget.phoneController.text.trim();

    if (phone.isEmpty || phone.length != 10) {
      _showSnackBar('Please enter a valid phone number');
      return;
    }

    setState(() {
      _isButtonPressed = true;
    });

    try {
      // Save phone number to secure storage for future use
      await SecureStorageService.storePhoneNumber(phone);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Use forget MPIN API if it's forget PIN flow, otherwise use normal login/register
      final success = widget.isForgotPinFlow
          ? await authProvider.forgetMpinSendOtp(phone)
          : await authProvider.loginOrRegisterUser(phone);

      if (mounted) {
        if (success) {
          EcliniqRouter.push(
            OtpInputScreen(isForgotPinFlow: widget.isForgotPinFlow),
          );
        } else {
          setState(() {
            _isButtonPressed = false;
          });
          _showSnackBar(
            authProvider.errorMessage ??
                (widget.isForgotPinFlow
                    ? 'Failed to send OTP'
                    : 'Login failed'),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isButtonPressed = false;
        });
        _showSnackBar('An error occurred. Please try again.');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildPhoneInputField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xff626060), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Color(0xffD6D6D6), width: 0.5),
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
                const SizedBox(width: 8),
                SvgPicture.asset(
                  EcliniqIcons.arrowDown.assetPath,
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.phoneController,
              keyboardType: TextInputType.phone,
              autofocus: true,
              maxLength: 10,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xff424242),
              ),
              decoration: const InputDecoration(
                hintText: 'Mobile Number',
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffD6D6D6),
                ),
                border: InputBorder.none,
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'By Continuing, you agree to our',
          style: EcliniqTextStyles.bodySmall.copyWith(color: Color(0xff8E8E8E)),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                EcliniqRouter.push(TermsAndConditionsPage());
              },
              child: Text(
                'Terms & Conditions',
                style: EcliniqTextStyles.headlineXMedium.copyWith(
                  color: Color(0xff424242),
                ),
              ),
            ),
            SizedBox(width: 4),
            Text(
              'and',
              style: EcliniqTextStyles.headlineLarge.copyWith(
                fontWeight: FontWeight.w400,
                color: Color(0xff8E8E8E),
              ),
            ),
            SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                EcliniqRouter.push(TermsAndConditionsPage());
              },
              child: Text(
                'Privacy Policy',
                style: EcliniqTextStyles.headlineXMedium.copyWith(
                  color: Color(0xff424242),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isButtonEnabled = _isPhoneNumberValid && !authProvider.isLoading;

        return SizedBox(
          width: double.infinity,
          height: 52,
          child: GestureDetector(
            onTap: isButtonEnabled ? _submitPhoneNumber : null,
            child: Container(
              decoration: BoxDecoration(
                color: _isButtonPressed
                    ? Color(0xFF0E4395)
                    : isButtonEnabled
                    ? EcliniqButtonType.brandPrimary.backgroundColor(context)
                    : EcliniqButtonType.brandPrimary.disabledBackgroundColor(
                        context,
                      ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: EcliniqTextStyles.headlineMedium.copyWith(
                      color: _isButtonPressed
                          ? Colors.white
                          : isButtonEnabled
                          ? Colors.white
                          : Color(0xffD6D6D6),
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    EcliniqIcons.arrowRightWhite.assetPath,
                    width: 24,
                    height: 24,
                    color: _isButtonPressed
                        ? Colors.white
                        : isButtonEnabled
                        ? Colors.white
                        : Color(0xff8E8E8E),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return EcliniqScaffold(
      backgroundColor: EcliniqScaffold.primaryBlue,
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Column(
          children: [
            const SizedBox(height: 52),

            Row(
              children: [
                IconButton(
                  onPressed: widget.onClose,
                  icon: SvgPicture.asset(
                    EcliniqIcons.reply.assetPath,
                    width: 32,
                    height: 32,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => EcliniqRouter.push(LoginTroublePage()),
                  child: FadeTransition(
                    opacity: widget.fadeAnimation,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          EcliniqIcons.questionCircleWhite.assetPath,
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Help',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: FadeTransition(
                  opacity: widget.fadeAnimation,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            top: 24,
                            left: 18,
                            right: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isForgotPinFlow
                                    ? 'Enter Your Mobile Number to Reset PIN'
                                    : 'Enter Your Mobile Number',
                                style: EcliniqTextStyles.headlineXMedium
                                    .copyWith(color: const Color(0xff626060)),
                              ),
                              const SizedBox(height: 4),
                              _buildPhoneInputField(),
                              const SizedBox(height: 24),
                              _buildTermsAndConditions(),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(right: 18, left: 18, bottom: 24),
                        child: _buildContinueButton(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
