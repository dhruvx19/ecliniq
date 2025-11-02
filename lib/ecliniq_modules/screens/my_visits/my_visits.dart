import 'package:ecliniq/ecliniq_core/router/navigation_helper.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/provider/auth_provider.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/cancelled.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/completed.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/confirmed.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/requested.dart';
import 'package:ecliniq/ecliniq_modules/screens/my_visits/booking_details/widgets/common.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_navigation/bottom_navigation.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:ecliniq/ecliniq_ui/scripts/ecliniq_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AppointmentData {
  final String id;
  final String doctorName;
  final String specialization;
  final String qualification;
  final String date;
  final String time;
  final String patientName;
  final AppointmentStatus status;
  final String? tokenNumber;

  AppointmentData({
    required this.id,
    required this.doctorName,
    required this.specialization,
    required this.qualification,
    required this.date,
    required this.time,
    required this.patientName,
    required this.status,
    this.tokenNumber,
  });
}

enum AppointmentStatus { confirmed, requested, cancelled, completed }

class MyVisits extends StatefulWidget {
  const MyVisits({super.key});

  @override
  State<MyVisits> createState() => _MyVisitsState();
}

class _MyVisitsState extends State<MyVisits>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _currentIndex = 1;
  int _selectedTabIndex = 0;
  int _selectedFilterIndex = 0;
  final _apiService = AppointmentApiService();
  bool _isLoading = false;

  final List<AppointmentData> _scheduledAppointments = [
    AppointmentData(
      id: '1',
      doctorName: 'Dr. Milind Chauhan',
      specialization: 'General Physician',
      qualification: 'MBBS, MD - General Medicine',
      date: '04 Apr, 2025',
      time: '12:30 PM',
      patientName: 'Ketan Patni (You)',
      status: AppointmentStatus.confirmed,
      tokenNumber: '76',
    ),
    AppointmentData(
      id: '2',
      doctorName: 'Dr. Milind Chauhan',
      specialization: 'General Physician',
      qualification: 'MBBS, MD - General Medicine',
      date: '04 Apr, 2025',
      time: '12:30 PM',
      patientName: 'Ketan Patni (You)',
      status: AppointmentStatus.requested,
    ),
  ];

  final List<AppointmentData> _historyAppointments = [
    AppointmentData(
      id: '3',
      doctorName: 'Dr. Milind Chauhan',
      specialization: 'General Physician',
      qualification: 'MBBS, MD - General Medicine',
      date: '04 Apr, 2025',
      time: '12:30 PM',
      patientName: 'Ketan Patni (You)',
      status: AppointmentStatus.cancelled,
    ),
    AppointmentData(
      id: '4',
      doctorName: 'Dr. Milind Chauhan',
      specialization: 'General Physician',
      qualification: 'MBBS, MD - General Medicine',
      date: '04 Apr, 2025',
      time: '12:30 PM',
      patientName: 'Ketan Patni (You)',
      status: AppointmentStatus.completed,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onTabTapped(int index) {
    // Don't navigate if already on the same tab
    if (index == _currentIndex) {
      return;
    }

    // Navigate using the navigation helper with smooth left-to-right transitions
    NavigationHelper.navigateToTab(context, index, _currentIndex);
  }


  Future<void> _navigateToDetailPage(AppointmentData appointment) async {
    setState(() => _isLoading = true);

    try {

      final appointmentDetail = await _apiService.fetchAppointmentDetail(
        appointment.id,
      );

      if (!mounted) return;


      Widget detailPage;
      switch (appointmentDetail.status) {
        case 'confirmed':
          detailPage = BookingConfirmedDetail(appointment: appointmentDetail);
          break;
        case 'requested':
          detailPage = BookingRequestedDetail(appointment: appointmentDetail);
          break;
        case 'cancelled':
          detailPage = BookingCancelledDetail(appointment: appointmentDetail);
          break;
        case 'completed':
          detailPage = BookingCompletedDetail(appointment: appointmentDetail);
          break;
        default:
          _showErrorSnackBar('Unknown appointment status');
          return;
      }

      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => detailPage),
      );


      if (result == true) {
        _refreshAppointments();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to load appointment details: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _refreshAppointments() async {

    setState(() {

    });
  }


  Widget _buildTopTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(child: _buildTabButton('Scheduled', 0)),
          Expanded(child: _buildTabButton('History', 1)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Color(0xFF4A90E2) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Color(0xFF4A90E2) : Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['Doctor', 'Hospital'];
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth * 0.13,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.02,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: screenWidth * 0.03),
              padding: EdgeInsets.all(screenWidth * 0.02),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xffF8FAFF) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Color(0xFF2372EC) : Colors.white,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  filters[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected ? Color(0xff2372EC) : Color(0xFF757575),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentData appointment) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth * 0.04;
    final cardPadding = screenWidth * 0.04;

    return GestureDetector(
      onTap: () => _navigateToDetailPage(appointment),
      child: Container(
        width: screenWidth - (horizontalMargin * 2),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(appointment),
            Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                children: [
                  _buildDoctorInfo(appointment),
                  const SizedBox(height: 12),
                  _buildAppointmentDetails(appointment),
                  const SizedBox(height: 12),
                  _buildPatientInfo(appointment),
                  const SizedBox(height: 16),
                  _buildActionButtons(appointment),
                ],
              ),
            ),
            if (appointment.status == AppointmentStatus.completed)
              _buildRatingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(AppointmentData appointment) {
    Color statusColor;
    String statusText;

    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        statusColor = Color(0xFF3EAF3F);
        statusText = 'Booking Confirmed';
        break;
      case AppointmentStatus.requested:
        statusColor = Color(0xFFF57C00);
        statusText = 'Requested';
        break;
      case AppointmentStatus.cancelled:
        statusColor = Color(0xFFF44336);
        statusText = 'Cancelled';
        break;
      case AppointmentStatus.completed:
        statusColor = Color(0xFF4CAF50);
        statusText = 'Completed';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: appointment.status == AppointmentStatus.confirmed
          ? Row(
              children: [
                Text(
                  statusText,
                  style: EcliniqTextStyles.headlineMedium.copyWith(
                    color: statusColor,
                  ),
                ),
                const Spacer(),
                if (appointment.tokenNumber != null)
                  Text(
                    'Token Number ${appointment.tokenNumber}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            )
          : Center(
              child: Text(
                statusText,
                style: EcliniqTextStyles.headlineMedium.copyWith(
                  color: statusColor,
                ),
              ),
            ),
    );
  }

  Widget _buildDoctorInfo(AppointmentData appointment) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              appointment.doctorName.split(' ')[1][0],
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.doctorName,
                style: EcliniqTextStyles.headlineLarge.copyWith(
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                appointment.specialization,
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
              Text(
                appointment.qualification,
                style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentDetails(AppointmentData appointment) {
    return Row(
      children: [
        Icon(Icons.calendar_today_outlined, size: 24, color: Color(0xFF666666)),
        const SizedBox(width: 8),
        Text(
          '${appointment.date} | ${appointment.time}',
          style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _buildPatientInfo(AppointmentData appointment) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Color(0xFFFF9800),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'KP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          appointment.patientName,
          style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _buildActionButtons(AppointmentData appointment) {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
      case AppointmentStatus.requested:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _navigateToDetailPage(appointment),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Color(0xFF8E8E8E)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    color: Color(0xFF424242),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18, color: Color(0xFF626060)),
              ],
            ),
          ),
        );

      case AppointmentStatus.cancelled:
      case AppointmentStatus.completed:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _navigateToDetailPage(appointment),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'View Details',
                  style: EcliniqTextStyles.headlineXMedium.copyWith(
                    color: Color(0xFF2372EC),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2372EC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Book Again',
                  style: EcliniqTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildRatingSection() {
    if (_selectedTabIndex != 1) return SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Color(0xFFF9F9F9)),
      child: Row(
        children: [
          Text(
            'Rate Doctor :',
            style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
          ),
          const Spacer(),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star_border,
                size: screenWidth * 0.063,
                color: Color(0xFFE0E0E0),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentAppointments = _selectedTabIndex == 0
        ? _scheduledAppointments
        : _historyAppointments;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Stack(
          children: [
            EcliniqScaffold(
              backgroundColor: EcliniqScaffold.primaryBlue,
              body: SizedBox.expand(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            EcliniqIcons.nameLogo.assetPath,
                            height: 28,
                            width: 140,
                          ),
                          const Spacer(),
                          Image.asset(
                            EcliniqIcons.bell.assetPath,
                            height: 32,
                            width: 32,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            _buildTopTabs(),
                            _buildFilterTabs(),
                            Expanded(
                              child: currentAppointments.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No appointments found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: currentAppointments.length,
                                      itemBuilder: (context, index) {
                                        final appointment =
                                            currentAppointments[index];
                                        return _buildAppointmentCard(
                                          appointment,
                                        );
                                      },
                                    ),
                            ),
                            EcliniqBottomNavigationBar(
                              currentIndex: _currentIndex,
                              onTap: _onTabTapped,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
