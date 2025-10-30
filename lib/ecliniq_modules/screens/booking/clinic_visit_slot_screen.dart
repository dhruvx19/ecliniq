import 'package:ecliniq/ecliniq_modules/screens/booking/review_details_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/date_selector.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/doctor_info_card.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/time_slot_card.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';

class ClinicVisitSlotScreen extends StatefulWidget {
  const ClinicVisitSlotScreen({super.key});

  @override
  State<ClinicVisitSlotScreen> createState() => _ClinicVisitSlotScreenState();
}

class _ClinicVisitSlotScreenState extends State<ClinicVisitSlotScreen> {
  String? selectedSlot;
  String selectedDate = 'Today, 2 Mar';

  final List<Map<String, dynamic>> timeSlots = [
    {
      'title': 'Morning',
      'time': '10:00am - 12:00pm',
      'available': 2,
      'icon': Icons.wb_sunny_outlined,
    },
    {
      'title': 'Afternoon',
      'time': '2:00pm-4:00pm',
      'available': 3,
      'icon': Icons.wb_sunny,
    },
    {
      'title': 'Evening',
      'time': '6:00pm-8:00pm',
      'available': 5,
      'icon': Icons.wb_twilight,
    },
    {
      'title': 'Night',
      'time': '8:30pm-10:30pm',
      'available': 20,
      'icon': Icons.nightlight_round,
    },
  ];

  void _onSlotSelected(String slot) {
    setState(() {
      selectedSlot = slot;
    });
  }

  void _onReviewVisit() {
    if (selectedSlot != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewDetailsScreen(
            selectedSlot: selectedSlot!,
            selectedDate: selectedDate,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Clinic Visit Slot',
            style: EcliniqTextStyles.headlineMedium.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.2),
          child: Container(color: Color(0xFFB8B8B8), height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: DoctorInfoCard(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DateSelector(
                      selectedDate: selectedDate,
                      onDateChanged: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Select Below Slots',
                      style: EcliniqTextStyles.headlineLarge.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) {
                      final slot = timeSlots[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TimeSlotCard(
                          title: slot['title'],
                          time: slot['time'],
                          available: slot['available'],
                          icon: slot['icon'],
                          isSelected: selectedSlot == slot['title'],
                          onTap: () => _onSlotSelected(slot['title']),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          if (selectedSlot != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onReviewVisit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2372EC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Review Visit',
                      style: EcliniqTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
