import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/profile/personal_details/provider/personal_details_provider.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/colors.g.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../add_dependent/provider/dependent_provider.dart';
import '../add_dependent/widgets/personal_details_card.dart';
import '../add_dependent/widgets/physical_info_card.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonalDetailsProvider()),
        ChangeNotifierProvider(create: (_) => AddDependentProvider()),
      ],
      child: Consumer<PersonalDetailsProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: SvgPicture.asset(
                  EcliniqIcons.arrowLeft.assetPath,
                  width: 32,
                  height: 32,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit Personal Details',
                  style: EcliniqTextStyles.headlineMedium.copyWith(
                    color: Color(0xff424242),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.2),
                child: Container(color: Color(0xFFB8B8B8), height: 1.0),
              ),
              actions: [
                Row(
                  children: [
                    SvgPicture.asset(
                      EcliniqIcons.questionCircle.assetPath,
                      width: 24,
                      height: 24,
                    ),
                    Text(
                      ' Help',
                      style: EcliniqTextStyles.titleXBLarge.copyWith(
                        color: EcliniqColors.light.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                padding: EdgeInsets.all(20),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: EcliniqColors.light.bgLightblue,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: SvgPicture.asset(
                                      'lib/ecliniq_icons/assets/Group.svg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 25,
                                right: -2,
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: SvgPicture.asset(
                                      'lib/ecliniq_icons/assets/Refresh.svg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.togglePersonalDetails();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Personal Details',
                                      style: EcliniqTextStyles.headlineMedium
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
                                  provider.isPersonalDetailsExpended
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: EcliniqColors.light.textTertiary,
                                ),
                              ],
                            ),
                          ),
                          if (provider.isPersonalDetailsExpended) ...[
                            const PersonalDetailsWidget(),
                          ],
                          SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              provider.toggleHealthInfo();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Health Info',
                                  style: EcliniqTextStyles.titleXBLarge
                                      .copyWith(
                                        color: EcliniqColors.light.textPrimary,
                                        fontSize: 18,
                                      ),
                                ),
                                Icon(
                                  provider.isHealthInfoExpended
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: EcliniqColors.light.textTertiary,
                                ),
                              ],
                            ),
                          ),
                          if (provider.isHealthInfoExpended) ...[
                            const PhysicalInfoCard(),
                          ],
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 84,
                        color: Colors.white,
                        alignment: Alignment.bottomCenter,
                        child: Consumer<AddDependentProvider>(
                          builder: (context, provider, child) {
                            return Container(
                              margin: EdgeInsets.all(6),
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.white),
                              child: SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed:
                                      (!provider.isFormValid ||
                                          provider.isLoading)
                                      ? null
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                         EcliniqColors
                                              .light
                                              .bgContainerInteractiveBrand,
                     
                                      
                                    disabledBackgroundColor: EcliniqColors
                                        .light
                                        .strokeNeutralSubtle
                                        .withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                          'Save',
                                          style: EcliniqTextStyles.titleXBLarge
                                              .copyWith(
                                                color: provider.isFormValid
                                                    ? EcliniqColors
                                                          .light
                                                          .textFixedLight
                                                    : EcliniqColors
                                                          .light
                                                          .textTertiary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
