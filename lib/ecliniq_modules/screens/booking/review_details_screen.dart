import 'package:ecliniq/ecliniq_modules/screens/booking/booking_confirmed_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/request_sent.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/appointment_detail_item.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/clinic_location_card.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/widgets/doctor_info_card.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/top_bar_widgets/easy_way_book.dart';
import 'package:flutter/material.dart';

class ReviewDetailsScreen extends StatefulWidget {
  final String selectedSlot;
  final String selectedDate;

  const ReviewDetailsScreen({
    super.key,
    required this.selectedSlot,
    required this.selectedDate,
  });

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  String? selectedReason;
  bool receiveUpdates = true;

  final List<String> reasons = [
    'Fever',
    'Cold & Cough',
    'Body Pain',
    'Skin Issues',
    'Stomach Issues',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Review Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: Colors.black, size: 20),
            label: const Text(
              'Help',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
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
                  const Divider(height: 1),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Appointment Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  AppointmentDetailItem(
                    icon: Icons.person_outline,
                    title: 'Ketan Patni',
                    subtitle: 'Male, 02/02/1996 (29Y)',
                    badge: 'You',
                    showEdit: true,
                  ),
                  AppointmentDetailItem(
                    icon: Icons.calendar_today_outlined,
                    title: _getTimeSlotTime(widget.selectedSlot),
                    subtitle: 'Today, 2 March 2025',
                    showEdit: false,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: ClinicLocationCard(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Reason for Visit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField<String>(
                      value: selectedReason,
                      decoration: InputDecoration(
                        hintText: 'Enter Reason for Visit',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      items: reasons
                          .map(
                            (reason) => DropdownMenuItem(
                              value: reason,
                              child: Text(reason),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Refer By',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter Who Refer you',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(16),
                    
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Consultation Fee',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const Text(
                              '₹700',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Service Fee & Tax',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Colors.grey[500],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹49',
                                  style: TextStyle(
                                    fontSize: 13,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Free',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'We care for you and provide a free booking',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Divider(height: 24),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Payable',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '₹700',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                   EasyWayToBookWidget(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppointmentRequestScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Confirm Visit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  String _getTimeSlotTime(String slot) {
    switch (slot) {
      case 'Morning':
        return '10:00am - 12:00pm';
      case 'Afternoon':
        return '2:00pm - 4:00pm';
      case 'Evening':
        return '6:00pm - 8:00pm';
      case 'Night':
        return '8:30pm - 10:30pm';
      default:
        return '';
    }
  }
}
