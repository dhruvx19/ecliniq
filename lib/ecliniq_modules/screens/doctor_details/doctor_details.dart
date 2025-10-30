import 'package:ecliniq/ecliniq_modules/screens/doctor_details/widgets/about_doctor.dart';
import 'package:ecliniq/ecliniq_modules/screens/doctor_details/widgets/address_doctor.dart';
import 'package:ecliniq/ecliniq_modules/screens/doctor_details/widgets/common_widget.dart';
import 'package:ecliniq/ecliniq_modules/screens/home/widgets/easy_to_book.dart';
import 'package:ecliniq/ecliniq_modules/screens/hospital/widgets/appointment_timing.dart';
import 'package:ecliniq/ecliniq_modules/screens/hospital/widgets/specialities.dart';
import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderImage(),
                    const SizedBox(height: 16),
                    _buildHospitalInfo(),
                    const SizedBox(height: 16),

                    _buildStatsCards(),
                    const SizedBox(height: 16),

                    AppointmentTimingWidget(),
                    const SizedBox(height: 16),

                    AddressWidget(),
                    const SizedBox(height: 16),

                    AboutHospital(),
                    const SizedBox(height: 16),

                    ClinicalDetailsWidget(),
                    const SizedBox(height: 16),

                    ProfessionalInformationWidget(),
                    const SizedBox(height: 16),
                    DoctorContactDetailsWidget(),

                    const SizedBox(height: 16),
                    EducationalInformationWidget(),

                    const SizedBox(height: 16),
                    DoctorCertificatesWidget(),
                    const SizedBox(height: 16),
                    ClinicPhotosWidget(),
                    const SizedBox(height: 16),
                    EasyWayToBookWidget(),

                    const SizedBox(height: 100),
                  ],
                ),

                Positioned(
                  top: 220,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.people,
                              size: 60,
                              color: Colors.orange[700],
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 120,
            child: _buildFloatingTabSection(),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(Icons.arrow_back),
                Row(
                  children: [
                    _buildCircleButton(Icons.favorite_border),
                    const SizedBox(width: 8),
                    _buildCircleButton(Icons.share),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 20),
    );
  }

  Widget _buildHospitalInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 24),
      child: Column(
        children: [
          const Text(
            'Dr. Milind Chauhan',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'General Physician',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'MBBS, MD - General Medicine',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 20, color: Colors.blue[400]),
              const SizedBox(width: 6),
              Text(
                'Baner, Pune',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Text(
                      '4 KM',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.navigation, size: 14, color: Colors.grey[600]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildStatCard(Icons.people, 'Patients Served', '50,000'),
            Container(
              width: 1,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.grey[200],
            ),
            _buildStatCard(
              Icons.medical_services_outlined,
              'Experience',
              '22 Yrs',
            ),
            Container(
              width: 1,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.grey[200],
            ),
            _buildStatCard(Icons.rate_review_outlined, 'Rating', '4 Star'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          Icon(icon, color: Colors.blue[600], size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingTabSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0x80000000),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTab('Details', true),
          _buildTab('Reviews', false),
          _buildTab('Branches', false),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Color(0xff2372EC) : Colors.white,
          fontWeight: isActive ? FontWeight.w400 : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff2372EC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Book Appointment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
