import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/clinic_visit_slot_screen.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/doctor_details.dart';

class DoctorInfoWidget extends StatefulWidget {
  final FavouriteDoctor doctor;

  const DoctorInfoWidget({super.key, required this.doctor});

  @override
  State<DoctorInfoWidget> createState() => _DoctorInfoWidgetState();
}

class _DoctorInfoWidgetState extends State<DoctorInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade800),
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: EcliniqText(
                          widget.doctor.profileInitial,
                          style: EcliniqTextStyles.bodyMedium.copyWith(
                            color: Colors.blue,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    if (widget.doctor.isVerified)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SvgPicture.asset(
                          'lib/ecliniq_icons/assets/Verified Check.svg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EcliniqText(
                      widget.doctor.name,
                      style: EcliniqTextStyles.bodyMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    EcliniqText(
                      widget.doctor.specialization,
                      style: EcliniqTextStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    EcliniqText(
                      widget.doctor.qualification,
                      style: EcliniqTextStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: widget.doctor.isFavorite
                        ? Colors.red.shade50
                        : Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      color: widget.doctor.isFavorite
                          ? Colors.red
                          : Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              spacing: 5,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    SvgPicture.asset(
                      EcliniqIcons.medicalKit.assetPath,
                      height: 24,
                      width: 24,
                    ),
                    EcliniqText(
                      '${widget.doctor.experienceYears} years of exp',
                      style: EcliniqTextStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Icon(Icons.circle, size: 7, color: Colors.grey),
                    Container(
                      height: 24,
                      width: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xffFEF9E6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          SvgPicture.asset('lib/ecliniq_icons/assets/Star.svg'),
                          EcliniqText(
                            '${widget.doctor.rating}',
                            style: EcliniqTextStyles.bodyMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffBE8B00),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.circle, size: 7, color: Colors.grey),
                    EcliniqText(
                      '₹${widget.doctor.fee}',
                      style: EcliniqTextStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    SvgPicture.asset(
                      'lib/ecliniq_icons/assets/Appointment Remindar.svg',
                      height: 24,
                      width: 24,
                    ),
                    EcliniqText(
                      widget.doctor.availableTime,
                      style: EcliniqTextStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    EcliniqText(
                      '(${widget.doctor.availableDays})',
                      style: EcliniqTextStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    SvgPicture.asset(
                      EcliniqIcons.mapPoint.assetPath,
                      height: 24,
                      width: 24,
                    ),
                    EcliniqText(
                      widget.doctor.location,
                      style: EcliniqTextStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.shade200,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: EcliniqText(
                          '  ${widget.doctor.distanceKm} km  ',
                          style: EcliniqTextStyles.bodyMedium.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.green.shade50,
              ),
              child: EcliniqText(
                '  ${widget.doctor.availableTokens} Token Available   ',
                style: EcliniqTextStyles.bodyMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Queue Not Started',
                                style: EcliniqTextStyles.titleXLarge.copyWith(
                                  color: Color(0xff626060),
                                ),
                              ),
                              
                              
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            EcliniqRouter.push(ClinicVisitSlotScreen(
                              doctorId: 'doctor.id',
                              hospitalId: 'widget.hospitalId',
                              doctorName: 'doctor.name',
                              doctorSpecialization: 'doctor.specializations.isNotEmpty',
                                
                           
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2372EC),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                          child: FittedBox(
                            child: Text(
                              'Book Appointment',
                              style: EcliniqTextStyles.headlineMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
