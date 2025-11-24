import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/booking_confirmed_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/appointment_detail_item.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/scripts/ecliniq_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentRequestScreen extends StatefulWidget {
  final String? doctorName;
  final String? doctorSpecialization;
  final String selectedSlot;
  final String selectedDate;
  final String? hospitalAddress;
  final String? tokenNumber;

  const AppointmentRequestScreen({
    super.key,
    this.doctorName,
    this.doctorSpecialization,
    required this.selectedSlot,
    required this.selectedDate,
    this.hospitalAddress,
    this.tokenNumber,
  });

  @override
  State<AppointmentRequestScreen> createState() =>
      _AppointmentRequestScreenState();
}

class _AppointmentRequestScreenState extends State<AppointmentRequestScreen> {
  @override
  void initState() {
    super.initState();
    _makeApiCall();
  }

  Future<void> _makeApiCall() async {
    
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmedScreen(
            doctorName: widget.doctorName,
            doctorSpecialization: widget.doctorSpecialization,
            selectedSlot: widget.selectedSlot,
            selectedDate: widget.selectedDate,
            hospitalAddress: widget.hospitalAddress,
            tokenNumber: widget.tokenNumber,
          ),
        ),
      );
    }
  }

  void _handleOkPressed() {

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),


              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  EcliniqIcons.appointment1.assetPath,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),


              Text(
                'Appointment Request',
                style: EcliniqTextStyles.headlineLarge.copyWith(
                  color: Color(0xff424242),
                ),
              ),


              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'sent to ',
                  style: EcliniqTextStyles.headlineLarge.copyWith(
                    color: Color(0xff424242),
                  ),
                  children: [
                    TextSpan(
                      text: widget.doctorName ?? 'Doctor',
                      style: EcliniqTextStyles.headlineLarge.copyWith(
                        color: Color(0xFFF0D47A1),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),


              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFA726), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        EcliniqIcons.verify.assetPath,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Your booking request will be confirmed once the doctor approves it. You will receive your token number details via WhatsApp and SMS.',
                        style: EcliniqTextStyles.titleXLarge.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),


              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    AppointmentDetailItem(
                      iconAssetPath: EcliniqIcons.user.assetPath,
                      title: 'Ketan Patni',
                      subtitle: 'Male, 02/02/1996 (29Y)',
                      badge: 'You',
                      showEdit: false,
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB8B8B8),
                      indent: 15,
                      endIndent: 15,
                    ),
                    AppointmentDetailItem(
                      iconAssetPath: EcliniqIcons.calendar.assetPath,
                      title: widget.selectedSlot,
                      subtitle: widget.selectedDate,
                      showEdit: false,
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB8B8B8),
                      indent: 15,
                      endIndent: 15,
                    ),
                    AppointmentDetailItem(
                      iconAssetPath: EcliniqIcons.hospitalBuilding.assetPath,
                      title: 'In-Clinic Consultation',
                      subtitle: widget.hospitalAddress ?? 'Address not available',
                      showEdit: false,
                    ),
                  ],
                ),
              ),

              const Spacer(),


              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleOkPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Ok',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
