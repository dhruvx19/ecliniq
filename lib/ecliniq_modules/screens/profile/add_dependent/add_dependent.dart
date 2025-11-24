import 'dart:io';

import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/details/widgets/add_profile_sheet.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/add_dependent/provider/dependent_provider.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/add_dependent/widgets/personal_details_card.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/add_dependent/widgets/physical_info_card.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/colors.g.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../ecliniq_utils/responsive_helper.dart';

class AddDependentBottomSheet extends StatefulWidget {
  final VoidCallback? onDependentAdded;

  const AddDependentBottomSheet({super.key, this.onDependentAdded});

  @override
  State<AddDependentBottomSheet> createState() =>
      _AddDependentBottomSheetState();
}

class _AddDependentBottomSheetState extends State<AddDependentBottomSheet> {
  bool _isExpanded = true;
  bool _isExpandedPhysicalInfo = true;

  void _showCustomSnackBar(String title, String message, bool isSuccess) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: _CustomSnackBar(
            title: title,
            message: message,
            isSuccess: isSuccess,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  void _uploadPhoto(AddDependentProvider provider) async {
    final String? action = await EcliniqBottomSheet.show<String>(
      context: context,
      child: const ProfilePhotoSelector(),
    );

    if (action != null) {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile;

      try {
        if (action == 'take_photo') {
          pickedFile = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 85,
            maxWidth: 1024,
            maxHeight: 1024,
          );
        } else if (action == 'upload_photo') {
          pickedFile = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
            maxWidth: 1024,
            maxHeight: 1024,
          );
        }

        if (pickedFile != null && mounted) {
          provider.setSelectedProfilePhoto(File(pickedFile.path));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
        }
      }
    }
  }

  Future<void> _saveDependent(AddDependentProvider provider) async {
    print('💾 Save button clicked');
    print('🔍 Provider state check:');
    print('   First Name: "${provider.firstName}"');
    print('   Last Name: "${provider.lastName}"');
    print('   Gender: ${provider.gender}');
    print('   Date of Birth: ${provider.dateOfBirth}');
    print('   Relation: ${provider.relation}');
    print('   Contact Number: "${provider.contactNumber}"');

    // Check form validity before attempting save
    if (!provider.isFormValid) {
      print('❌ Form is not valid');
      final errorMessage = provider.getValidationErrorMessage();
      print('❌ Validation errors: $errorMessage');

      // Show detailed error snackbar
      _showCustomSnackBar('Validation Failed', errorMessage, false);
      return;
    }

    print('✅ Form is valid, proceeding with save...');

    try {
      final success = await provider.saveDependent(context);

      if (success) {
        print('✅ Dependent saved successfully');

        // Call callback to refresh dependents list immediately
        if (widget.onDependentAdded != null) {
          widget.onDependentAdded!();
        }

        // Show success message
        _showCustomSnackBar(
          'Dependent Details Saved Successfully',
          'Your changes have been saved successfully',
          true,
        );

        // Close bottom sheet after showing snackbar
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      } else {
        print('❌ Failed to save dependent: ${provider.errorMessage}');
        _showCustomSnackBar(
          'Failed to Add Dependent',
          provider.errorMessage ?? 'Please try again',
          false,
        );
      }
    } catch (e) {
      print('❌ Exception in _saveDependent: $e');
      _showCustomSnackBar('Error', 'An error occurred: $e', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveHelper.getScreenSize(context);

    // Responsive values for different mobile sizes
    final horizontalPadding = screenSize.getResponsiveValue(
      mobile: 14.0,
      mobileSmall: 12.0,
      mobileMedium: 14.0,
      mobileLarge: 16.0,
    );

    final photoSize = screenSize.getResponsiveValue(
      mobile: 100.0,
      mobileSmall: 90.0,
      mobileMedium: 100.0,
      mobileLarge: 110.0,
    );

    final iconSize = screenSize.getResponsiveValue(
      mobile: 32.0,
      mobileSmall: 28.0,
      mobileMedium: 32.0,
      mobileLarge: 36.0,
    );

    final titlePadding = screenSize.getResponsiveValue(
      mobile: 20.0,
      mobileSmall: 16.0,
      mobileMedium: 20.0,
      mobileLarge: 24.0,
    );

    final verticalSpacing = screenSize.getResponsiveValue(
      mobile: 24.0,
      mobileSmall: 20.0,
      mobileMedium: 24.0,
      mobileLarge: 28.0,
    );

    final buttonHeight = screenSize.getResponsiveValue(
      mobile: 50.0,
      mobileSmall: 48.0,
      mobileMedium: 50.0,
      mobileLarge: 52.0,
    );

    return ChangeNotifierProvider(
      key: const ValueKey('AddDependentProvider'),
      create: (_) => AddDependentProvider(),
      child: Consumer<AddDependentProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: BoxDecoration(
              color: EcliniqColors.light.bgBaseOverlay,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: EcliniqColors.light.strokeNeutralSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(titlePadding),
                  child: Text(
                    'Add Dependent',
                    style: EcliniqTextStyles.headlineLarge.copyWith(
                      color: Color(0xff424242),
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => _uploadPhoto(provider),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: EcliniqColors.light.bgLightblue,
                                width: 1,
                              ),
                              color: provider.selectedProfilePhoto == null
                                  ? EcliniqColors.light.bgLightblue.withOpacity(
                                      0.1,
                                    )
                                  : Colors.transparent,
                            ),
                            child: provider.selectedProfilePhoto == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        EcliniqIcons.add.assetPath,
                                        width: 48,
                                        height: 48,
                                        colorFilter: ColorFilter.mode(
                                          Color(0xff2372EC),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Upload\nPhoto',
                                        textAlign: TextAlign.center,
                                        style: EcliniqTextStyles.bodyXSmall
                                            .copyWith(
                                              color: Color(0xff2372EC),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipOval(
                                        child: Image.file(
                                          provider.selectedProfilePhoto!,
                                          fit: BoxFit.cover,
                                          width: photoSize,
                                          height: photoSize,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color:
                                                EcliniqColors.light.textBrand,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        SizedBox(height: verticalSpacing),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Personal Details',
                                    style: EcliniqTextStyles.headlineMedium
                                        .copyWith(color: Color(0xff424242)),
                                  ),
                                  Text(
                                    ' *',
                                    style: EcliniqTextStyles.titleXBLarge
                                        .copyWith(
                                          color: EcliniqColors
                                              .light
                                              .textDestructive,
                                        ),
                                  ),
                                ],
                              ),
                               
                              // Icon(
                              //   _isExpanded
                              //       ? Icons.keyboard_arrow_up
                              //       : Icons.keyboard_arrow_down,
                              //   color: EcliniqColors.light.textTertiary,
                              // ),
                            ],
                          ),
                        ),

                        if (_isExpanded) ...[PersonalDetailsWidget()],
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpandedPhysicalInfo =
                                  !_isExpandedPhysicalInfo;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Physical Info',
                                    style: EcliniqTextStyles.titleXBLarge
                                        .copyWith(
                                          color:
                                              EcliniqColors.light.textPrimary,
                                        ),
                                  ),
                                  Text(
                                    ' *',
                                    style: EcliniqTextStyles.titleXBLarge
                                        .copyWith(
                                          color: EcliniqColors
                                              .light
                                              .textDestructive,
                                        ),
                                  ),
                                ],
                              ),
                              Icon(
                                _isExpandedPhysicalInfo
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: EcliniqColors.light.textTertiary,
                              ),
                            ],
                          ),
                        ),
                        if (_isExpandedPhysicalInfo) ...[PhysicalInfoCard()],
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: screenSize.getResponsiveValue(
                      mobile: 20.0,
                      mobileSmall: 16.0,
                      mobileMedium: 20.0,
                      mobileLarge: 24.0,
                    ),
                    vertical: screenSize.getResponsiveValue(
                      mobile: 18.0,
                      mobileSmall: 16.0,
                      mobileMedium: 18.0,
                      mobileLarge: 20.0,
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: (!provider.isFormValid || provider.isLoading)
                          ? null
                          : () => _saveDependent(provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: provider.isFormValid
                            ? EcliniqColors.light.bgContainerInteractiveBrand
                            : EcliniqColors.light.strokeNeutralSubtle
                                  .withOpacity(0.5),
                        disabledBackgroundColor: EcliniqColors
                            .light
                            .strokeNeutralSubtle
                            .withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: provider.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: EcliniqColors.light.textFixedLight,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save',
                              style: EcliniqTextStyles.titleXBLarge.copyWith(
                                color: provider.isFormValid
                                    ? EcliniqColors.light.textFixedLight
                                    : EcliniqColors.light.textTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomSnackBar extends StatefulWidget {
  final String title;
  final String message;
  final bool isSuccess;

  const _CustomSnackBar({
    required this.title,
    required this.message,
    required this.isSuccess,
  });

  @override
  State<_CustomSnackBar> createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<_CustomSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.isSuccess
                ? const Color(0xFF10B981)
                : EcliniqColors.light.bgContainerInteractiveDestructive,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isSuccess ? Icons.check : Icons.error_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: EcliniqTextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.message,
                      style: EcliniqTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
