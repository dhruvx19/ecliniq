import 'package:ecliniq/ecliniq_modules/screens/profile/add_dependent/widgets/relation_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/colors.g.dart';
import 'package:intl/intl.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:provider/provider.dart';
import '../../../../../ecliniq_utils/responsive_helper.dart';
import '../../../details/widgets/date_picker_sheet.dart';
import '../provider/dependent_provider.dart';
import 'blood_group_selection.dart';
import 'gender_selection.dart';

class PersonalDetailsWidget extends StatefulWidget {
  const PersonalDetailsWidget({super.key,});

  @override
  State<PersonalDetailsWidget> createState() => _PersonalDetailsWidgetState();
}

class _PersonalDetailsWidgetState extends State<PersonalDetailsWidget> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final provider = Provider.of<AddDependentProvider>(context, listen: false);
    final DateTime? picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DatePickerBottomSheet(
        initialDate: provider.dateOfBirth ?? DateTime.now(),
      ),
    );
    if (picked != null) {
      provider.setDateOfBirth(picked);
    }
  }


  @override
  Widget build(BuildContext context) {

    final screenSize = ResponsiveHelper.getScreenSize(context);
    final provider = Provider.of<AddDependentProvider>(context);
    return Container(
        margin: EdgeInsets.symmetric(
          vertical: screenSize.getResponsiveValue(
            mobile: 8.0,
            mobileSmall: 6.0,
            mobileMedium: 8.0,
            mobileLarge: 10.0,
          ),
        ),
        decoration: BoxDecoration(
          color: EcliniqColors.light.bgContainerNonInteractiveNeutralExtraSubtle,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenSize.getResponsiveValue(
            mobile: 8.0,
            mobileSmall: 6.0,
            mobileMedium: 8.0,
            mobileLarge: 10.0,
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: screenSize.getResponsiveValue(
                    mobile: 8.0,
                    mobileSmall: 6.0,
                    mobileMedium: 8.0,
                    mobileLarge: 10.0,
                  ),
                ),
                height: screenSize.getResponsiveValue(
                  mobile: 30.0,
                  mobileSmall: 28.0,
                  mobileMedium: 30.0,
                  mobileLarge: 32.0,
                ),
                child: _buildTextField(
                  label: 'First Name',
                  isRequired: true,
                  hint: 'Enter First Name',
                  controller: _firstNameController,
                  onChanged: provider.setFirstName,
                ),
              ),
              Divider(
                color: EcliniqColors.light.strokeNeutralExtraSubtle,
                thickness: 1,
                height: 0,
              ),

              Container(
                margin: EdgeInsets.symmetric(
                  vertical: screenSize.getResponsiveValue(
                    mobile: 8.0,
                    mobileSmall: 6.0,
                    mobileMedium: 8.0,
                    mobileLarge: 10.0,
                  ),
                ),
                height: screenSize.getResponsiveValue(
                  mobile: 30.0,
                  mobileSmall: 28.0,
                  mobileMedium: 30.0,
                  mobileLarge: 32.0,
                ),
                child: _buildTextField(
                  label: 'Last Name',
                  isRequired: true,
                  hint: 'Enter Last Name',
                  controller: _lastNameController,
                  onChanged: provider.setLastName,
                ),
              ),

              Divider(
                color: EcliniqColors.light.strokeNeutralExtraSubtle,
                thickness: 1,
                height: 0,
              ),

              // Gender
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: screenSize.getResponsiveValue(
                    mobile: 8.0,
                    mobileSmall: 6.0,
                    mobileMedium: 8.0,
                    mobileLarge: 10.0,
                  ),
                ),
                height: screenSize.getResponsiveValue(
                  mobile: 30.0,
                  mobileSmall: 28.0,
                  mobileMedium: 30.0,
                  mobileLarge: 32.0,
                ),
                child:  _buildSelectField(
                  label: 'Gender',
                  isRequired: true,
                  hint: 'Select Gender',
                  value: provider.gender,
                  onTap: () async {
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const GenderSelectionSheet(),
                    );
                    if (selected != null) {
                      provider.setGender(selected);
                    }
                  },
                ),
              ),

              Divider(
                color: EcliniqColors.light.strokeNeutralExtraSubtle,
                thickness: 1,
                height: 0,
              ),

              // Date of Birth
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: screenSize.getResponsiveValue(
                    mobile: 8.0,
                    mobileSmall: 6.0,
                    mobileMedium: 8.0,
                    mobileLarge: 10.0,
                  ),
                ),
                height: screenSize.getResponsiveValue(
                  mobile: 30.0,
                  mobileSmall: 28.0,
                  mobileMedium: 30.0,
                  mobileLarge: 32.0,
                ),
                child: _buildSelectField(
                  label: 'Date of Birth',
                  isRequired: true,
                  hint: 'Select Date',
                  value: provider.dateOfBirth != null
                      ? DateFormat('dd MMM yyyy').format(provider.dateOfBirth!)
                      : null,
                  onTap: () => _selectDate(context),
                ),
              ),

              Divider(
                color: EcliniqColors.light.strokeNeutralExtraSubtle,
                thickness: 1,
                height: 0,
              ),

              Container(
                  margin: EdgeInsets.symmetric(
                    vertical: screenSize.getResponsiveValue(
                      mobile: 8.0,
                      mobileSmall: 6.0,
                      mobileMedium: 8.0,
                      mobileLarge: 10.0,
                    ),
                  ),
                  height: screenSize.getResponsiveValue(
                    mobile: 30.0,
                    mobileSmall: 28.0,
                    mobileMedium: 30.0,
                    mobileLarge: 32.0,
                  ),
                  child: _buildSelectField(
                    label: 'Relation',
                    isRequired: true,
                    hint: 'Select Relation',
                    value: provider.relation,
                    onTap: () async {
                      final selected = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const RelationSelectionSheet(),
                      );
                      if (selected != null) {
                        provider.setRelation(selected);
                      }
                    },
                  )
              ),

              Divider(
                color: EcliniqColors.light.strokeNeutralExtraSubtle,
                thickness: 1,
                height: 0,
              ),

              Container(
                margin: EdgeInsets.symmetric(
                  vertical: screenSize.getResponsiveValue(
                    mobile: 8.0,
                    mobileSmall: 6.0,
                    mobileMedium: 8.0,
                    mobileLarge: 10.0,
                  ),
                ),
                height: screenSize.getResponsiveValue(
                  mobile: 30.0,
                  mobileSmall: 28.0,
                  mobileMedium: 30.0,
                  mobileLarge: 32.0,
                ),
                child: _buildTextField(
                  label: 'Contact Number',
                  isRequired: true,
                  hint: 'Enter Phone Number',
                  controller: _contactController,
                  keyboardType: TextInputType.phone,
                  onChanged: provider.setContactNumber,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
              ),

              Divider(
                color: EcliniqColors.light.strokeNeutralExtraSubtle,
                thickness: 1,
                height: 0,
              ),

              Container(
                margin: EdgeInsets.symmetric(
                  vertical: screenSize.getResponsiveValue(
                    mobile: 8.0,
                    mobileSmall: 6.0,
                    mobileMedium: 8.0,
                    mobileLarge: 10.0,
                  ),
                ),
                height: screenSize.getResponsiveValue(
                  mobile: 30.0,
                  mobileSmall: 28.0,
                  mobileMedium: 30.0,
                  mobileLarge: 32.0,
                ),
                child: _buildTextField(
                  label: 'Email',
                  isRequired: false,
                  hint: 'Enter Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: provider.setEmail,
                ),
              ),

              Divider(
                color: EcliniqColors.light.strokeNeutralExtraSubtle,
                thickness: 1,
                height: 0,
              ),

              Container(
                margin: EdgeInsets.symmetric(
                  vertical: screenSize.getResponsiveValue(
                    mobile: 8.0,
                    mobileSmall: 6.0,
                    mobileMedium: 8.0,
                    mobileLarge: 10.0,
                  ),
                ),
                height: screenSize.getResponsiveValue(
                  mobile: 30.0,
                  mobileSmall: 28.0,
                  mobileMedium: 30.0,
                  mobileLarge: 32.0,
                ),
                child: _buildSelectField(
                  label: 'Blood Group',
                  isRequired: false,
                  hint: 'Select Blood Group',
                  value: provider.bloodGroup,
                  onTap: () async {
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const BloodGroupSelectionSheet(),
                    );
                    if (selected != null) {
                      provider.setBloodGroup(selected);
                    }
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}

Widget _buildTextField({
  required String label,
  required bool isRequired,
  required String hint,
  required TextEditingController controller,
  TextInputType? keyboardType,
  required Function(String) onChanged,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Row(
          children: [
            Text(
              label,
              style: EcliniqTextStyles.headlineXMedium.copyWith(
                color: EcliniqColors.light.textSecondary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: EcliniqTextStyles.headlineXMedium.copyWith(
                  color: EcliniqColors.light.textDestructive,
                ),
              ),
          ],
        ),
      ),

      Expanded(
        flex: 1,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          textAlign: TextAlign.right,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: EcliniqTextStyles.headlineXMedium.copyWith(
              color: EcliniqColors.light.textPlaceholder,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          style: EcliniqTextStyles.headlineXMedium.copyWith(
            color: EcliniqColors.light.textPrimary,
          ),
        ),
      ),
    ],
  );
}

Widget _buildSelectField({
  required String label,
  required bool isRequired,
  required String hint,
  required String? value,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Text(
                label,
                style: EcliniqTextStyles.headlineXMedium.copyWith(
                  color: EcliniqColors.light.textSecondary,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: EcliniqTextStyles.headlineXMedium.copyWith(
                    color: EcliniqColors.light.textDestructive,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value ?? hint,
              textAlign: TextAlign.right,
              style: EcliniqTextStyles.headlineXMedium.copyWith(
                color: value != null ? EcliniqColors.light.textSecondary : EcliniqColors.light.textPlaceholder,
                fontWeight: value != null ? FontWeight.w400 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

