import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HospitalBranchDetail extends StatelessWidget {
  final String? aboutDescription;

  const HospitalBranchDetail({super.key, this.aboutDescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: EcliniqTextStyles.getResponsiveEdgeInsetsAll(context, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: EcliniqTextStyles.getResponsiveSize(context, 64.0),
                  width: EcliniqTextStyles.getResponsiveSize(context, 64.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      EcliniqTextStyles.getResponsiveBorderRadius(
                        context,
                        32.0,
                      ),
                    ),
                    color: Color(0xffF8FAFF),
                    border: Border.all(color: Color(0xff96BFFF), width: 0.5),
                  ),
                  child: Padding(
                    padding: EcliniqTextStyles.getResponsiveEdgeInsetsAll(
                      context,
                      10.0,
                    ),
                    child: SvgPicture.asset(
                      EcliniqIcons.hospitalBuilding.assetPath,
                      width: EcliniqTextStyles.getResponsiveIconSize(
                        context,
                        44.0,
                      ),
                      height: EcliniqTextStyles.getResponsiveIconSize(
                        context,
                        44.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: EcliniqTextStyles.getResponsiveSpacing(context, 10.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sunrise Family Clinic',
                      style: EcliniqTextStyles.responsiveHeadlineLarge(
                        context,
                      ).copyWith(color: Color(0xff424242)),
                    ),
                    Text(
                      'Est. Date : Aug, 2015',
                      style: EcliniqTextStyles.responsiveTitleXLarge(
                        context,
                      ).copyWith(color: Color(0xff424242)),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showAboutBottomSheet(context);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Read About',
                            style: EcliniqTextStyles.responsiveBodySmall(
                              context,
                            ).copyWith(color: Color(0xff2372EC)),
                          ),
                          SvgPicture.asset(
                            EcliniqIcons.angleRight.assetPath,
                            width: EcliniqTextStyles.getResponsiveIconSize(
                              context,
                              16.0,
                            ),
                            height: EcliniqTextStyles.getResponsiveIconSize(
                              context,
                              16.0,
                            ),
                            color: Color(0xff2372EC),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: EcliniqTextStyles.getResponsiveSpacing(context, 16.0),
            ),
            Row(
              children: [
                Container(
                  height: EcliniqTextStyles.getResponsiveSize(context, 24.0),
                  width: EcliniqTextStyles.getResponsiveSize(context, 24.0),
                  decoration: BoxDecoration(
                    color: Color(0xfffff7f0),
                    border: Border.all(color: Color(0xffEC7600), width: 0.5),
                    borderRadius: BorderRadius.circular(
                      EcliniqTextStyles.getResponsiveBorderRadius(
                        context,
                        12.0,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "M",
                      style: EcliniqTextStyles.responsiveBodySmall(
                        context,
                      ).copyWith(color: Color(0xffEC7600)),
                    ),
                  ),
                ),
                SizedBox(
                  width: EcliniqTextStyles.getResponsiveSpacing(context, 10.0),
                ),
                Text(
                  'Dr. Milind Chauhan',
                  style: EcliniqTextStyles.responsiveTitleXLarge(
                    context,
                  ).copyWith(color: Color(0xff626060)),
                ),
              ],
            ),
            SizedBox(
              height: EcliniqTextStyles.getResponsiveSpacing(context, 4.0),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  EcliniqIcons.appointmentReminder.assetPath,
                  width: EcliniqTextStyles.getResponsiveIconSize(context, 24.0),
                  height: EcliniqTextStyles.getResponsiveIconSize(
                    context,
                    24.0,
                  ),
                ),
                SizedBox(
                  width: EcliniqTextStyles.getResponsiveSpacing(context, 10.0),
                ),
                Text(
                  '10am - 9:30pm (Mon - Sat)',
                  style: EcliniqTextStyles.responsiveTitleXLarge(
                    context,
                  ).copyWith(color: Color(0xff626060)),
                ),
              ],
            ),
            SizedBox(
              height: EcliniqTextStyles.getResponsiveSpacing(context, 4.0),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  EcliniqIcons.pointOnMap.assetPath,
                  width: EcliniqTextStyles.getResponsiveIconSize(context, 24.0),
                  height: EcliniqTextStyles.getResponsiveIconSize(
                    context,
                    24.0,
                  ),
                ),
                SizedBox(
                  width: EcliniqTextStyles.getResponsiveSpacing(context, 10.0),
                ),
                Flexible(
                  child: Text(
                    'Survey No 111/11/1, Veerbhadra Nagar Road, Mhalunge Main Road, Baner, Pune, Maharashtra - 411045.',
                    style: EcliniqTextStyles.responsiveTitleXLarge(
                      context,
                    ).copyWith(color: Color(0xff626060)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: EcliniqTextStyles.getResponsiveSpacing(context, 4.0),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  EcliniqIcons.mapPointBlue.assetPath,
                  width: EcliniqTextStyles.getResponsiveIconSize(context, 24.0),
                  height: EcliniqTextStyles.getResponsiveIconSize(
                    context,
                    24.0,
                  ),
                ),
                SizedBox(
                  width: EcliniqTextStyles.getResponsiveSpacing(context, 10.0),
                ),
                Text(
                  'Wakad, Pune',
                  style: EcliniqTextStyles.responsiveTitleXLarge(
                    context,
                  ).copyWith(color: Color(0xff626060)),
                ),
                SizedBox(
                  width: EcliniqTextStyles.getResponsiveSpacing(context, 10.0),
                ),
                Container(
                  height: EcliniqTextStyles.getResponsiveHeight(context, 30.0),
                  width: EcliniqTextStyles.getResponsiveWidth(context, 74.0),
                  decoration: BoxDecoration(
                    color: Color(0xffF9F9F9),
                    borderRadius: BorderRadius.circular(
                      EcliniqTextStyles.getResponsiveBorderRadius(context, 6.0),
                    ),
                    border: Border.all(color: Color(0xffB8B8B8), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: EcliniqTextStyles.getResponsiveSpacing(
                          context,
                          4.0,
                        ),
                      ),
                      Center(
                        child: Text(
                          '4KM ',
                          style: EcliniqTextStyles.responsiveTitleXLarge(
                            context,
                          ).copyWith(color: Color(0xff424242)),
                        ),
                      ),
                      SizedBox(
                        width: EcliniqTextStyles.getResponsiveSpacing(
                          context,
                          4.0,
                        ),
                      ),
                      SvgPicture.asset(
                        EcliniqIcons.mapArrow.assetPath,
                        width: EcliniqTextStyles.getResponsiveIconSize(
                          context,
                          18.0,
                        ),
                        height: EcliniqTextStyles.getResponsiveIconSize(
                          context,
                          18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: EcliniqTextStyles.getResponsiveSpacing(context, 16.0),
            ),
            Container(
              height: EcliniqTextStyles.getResponsiveHeight(context, 30.0),
              width: EcliniqTextStyles.getResponsiveWidth(context, 162.0),
              decoration: BoxDecoration(
                color: Color(0xffF2FFF3),
                borderRadius: BorderRadius.circular(
                  EcliniqTextStyles.getResponsiveBorderRadius(context, 6.0),
                ),
              ),
              child: Center(
                child: Text(
                  '25 Token Available',
                  style: EcliniqTextStyles.responsiveTitleXLarge(
                    context,
                  ).copyWith(color: Color(0xff3EAF3F)),
                ),
              ),
            ),
            SizedBox(
              height: EcliniqTextStyles.getResponsiveSpacing(context, 16.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    height: EcliniqTextStyles.getResponsiveButtonHeight(
                      context,
                      baseHeight: 52.0,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffF2FFF3),
                      borderRadius: BorderRadius.circular(
                        EcliniqTextStyles.getResponsiveBorderRadius(
                          context,
                          4.0,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _AnimatedDot(),
                          SizedBox(
                            width: EcliniqTextStyles.getResponsiveSpacing(
                              context,
                              4.0,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Queue Started',
                              style: EcliniqTextStyles.responsiveTitleXLarge(
                                context,
                              ).copyWith(color: Color(0xff3EAF3F)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: EcliniqTextStyles.getResponsiveSpacing(context, 8.0),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: EcliniqTextStyles.getResponsiveWidth(
                        context,
                        140.0,
                      ),
                    ),
                    height: EcliniqTextStyles.getResponsiveButtonHeight(
                      context,
                      baseHeight: 52.0,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x332372EC),
                          offset: const Offset(7, 4),
                          blurRadius: 5.3,
                          spreadRadius: 0,
                        ),
                      ],
                      color: Color(0xff2372EC),
                      borderRadius: BorderRadius.circular(
                        EcliniqTextStyles.getResponsiveBorderRadius(
                          context,
                          4.0,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Book Appointment',
                        style: EcliniqTextStyles.responsiveHeadlineMedium(
                          context,
                        ).copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutBottomSheet(BuildContext context) {
    EcliniqBottomSheet.show(
      context: context,
      child: Container(
        padding: EcliniqTextStyles.getResponsiveEdgeInsetsAll(context, 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Clinic',
              style: EcliniqTextStyles.responsiveHeadlineLarge(
                context,
              ).copyWith(fontWeight: FontWeight.w600, color: Color(0xff424242)),
            ),
            SizedBox(
              height: EcliniqTextStyles.getResponsiveSpacing(context, 8.0),
            ),
            Text(
              aboutDescription ??
                  'Sunrise Family Clinic is a well-established medical facility dedicated to providing comprehensive healthcare services to families. With experienced doctors and modern facilities, we strive to deliver quality care in a comfortable environment. Our clinic specializes in family medicine, preventive care, and treatment of common ailments.',
              style: EcliniqTextStyles.responsiveTitleXLarge(context).copyWith(
                color: Color(0xff626060),
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
            SizedBox(
              height: EcliniqTextStyles.getResponsiveSpacing(context, 24.0),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedDot extends StatefulWidget {
  const _AnimatedDot();

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Color(0xff3EAF3F),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
