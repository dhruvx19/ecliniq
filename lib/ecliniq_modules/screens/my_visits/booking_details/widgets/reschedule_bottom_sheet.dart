import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/clinic_visit_slot_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/widgets/common.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/snackbar/error_snackbar.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/text/text.dart';
import 'package:flutter/material.dart';

class RescheduleBottomSheet extends StatefulWidget {
  final AppointmentDetailModel appointment;

  const RescheduleBottomSheet({
    super.key,
    required this.appointment,
  });

  @override
  State<RescheduleBottomSheet> createState() => _RescheduleBottomSheetState();
}

class _RescheduleBottomSheetState extends State<RescheduleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            EcliniqIcons.reschedule.assetPath,
            fit: BoxFit.contain,
            height: 115,
            width: 115,
          ),
          const EcliniqText(
            'Are you sure you want Reschedule the Confirmed Appointment?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      // Check if appointment is already rescheduled
                      final isAlreadyRescheduled = widget.appointment.isRescheduled ?? false;
                      if (isAlreadyRescheduled) {
                        Navigator.pop(context, false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomErrorSnackBar(
                            context: context,
                            title: 'Cannot Reschedule',
                            subtitle: 'This appointment has already been rescheduled. You cannot reschedule it again.',
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        return;
                      }
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF96BFFF),
                          width: 0.5,
                        ),
                        color: Color(0xFFF2F7FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Yes',
                            style: EcliniqTextStyles.headlineMedium.copyWith(
                              color: Color(0xff2372EC),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff8E8E8E),
                          width: 0.5,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No',
                            style: EcliniqTextStyles.headlineMedium.copyWith(
                              color: Color(0xff424242),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
