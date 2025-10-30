import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/main_flow/otp_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/provider/auth_provider.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/button/button.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneInputScreen extends StatefulWidget {
  final TextEditingController phoneController;
  final VoidCallback onClose;
  final Animation<double> fadeAnimation;

  const PhoneInputScreen({
    super.key,
    required this.phoneController,
    required this.onClose,
    required this.fadeAnimation,
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
    _onPhoneNumberChanged();
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.loginOrRegisterUser(phone);

      if (mounted) {
        if (success) {
          EcliniqRouter.push(const OtpInputScreen());
        } else {
          setState(() {
            _isButtonPressed = false;
          });
          _showSnackBar(authProvider.errorMessage ?? 'Login failed');
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
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                const Text(
                  '+91',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                  size: 20,
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
              decoration: const InputDecoration(
                hintText: 'Mobile Number',
                border: InputBorder.none,
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                hintStyle: EcliniqTextStyles.bodyMedium,
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
          style: EcliniqTextStyles.bodySmall.copyWith(color: Colors.grey),
        ),
        Text('Terms & Conditions', style: EcliniqTextStyles.headlineMedium),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isButtonEnabled = _isPhoneNumberValid && !authProvider.isLoading;

        return SizedBox(
          width: double.infinity,
          height: 46,
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
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: EcliniqTextStyles.titleXLarge.copyWith(
                      color: _isButtonPressed
                          ? Colors.white
                          : isButtonEnabled
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    color: isButtonEnabled ? Colors.white : Colors.grey,
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
            const SizedBox(height: 40),

            Row(
              children: [
                IconButton(
                  onPressed: widget.onClose,
                  icon: Image.asset(
                    EcliniqIcons.arrowBack.assetPath,
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: widget.fadeAnimation,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.help_outline, color: Colors.white),
                    label: const Text(
                      'Help',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: FadeTransition(
                  opacity: widget.fadeAnimation,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Enter Your Mobile Number',
                                style: EcliniqTextStyles.headlineMedium,
                              ),
                              const SizedBox(height: 10),
                              _buildPhoneInputField(),
                              const SizedBox(height: 16),
                              _buildTermsAndConditions(),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(24),
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
