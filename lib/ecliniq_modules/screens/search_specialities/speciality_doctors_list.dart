import 'dart:async';

import 'package:ecliniq/ecliniq_api/doctor_service.dart';
import 'package:ecliniq/ecliniq_api/models/doctor.dart' as api_doctor;
import 'package:ecliniq/ecliniq_api/models/hospital_doctor_model.dart';
import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/booking/clinic_visit_slot_screen.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SpecialityDoctorsList extends StatefulWidget {
  final String? initialSpeciality;
  
  const SpecialityDoctorsList({
    super.key,
    this.initialSpeciality,
  });

  @override
  State<SpecialityDoctorsList> createState() => _SpecialityDoctorsListState();
}

class _SpecialityDoctorsListState extends State<SpecialityDoctorsList> {
  final DoctorService _doctorService = DoctorService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Doctor> _doctors = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final String _currentLocation = 'Vishnu Dev Nagar, Wakad'; // UI Display only
  Timer? _debounceTimer;

  // Filter values
  final double _latitude = 28.6139;
  final double _longitude = 77.209;

  @override
  void initState() {
    super.initState();
    if (widget.initialSpeciality != null) {
      _selectedCategory = widget.initialSpeciality!;
    }
    _fetchDoctors();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _isLoading = true;
    });
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<String>? specialityFilter;
      if (_selectedCategory != 'All') {
        specialityFilter = [_selectedCategory];
      }

      final request = api_doctor.FilterDoctorsRequest(
        latitude: _latitude,
        longitude: _longitude,
        speciality: specialityFilter,
      );

      final response = await _doctorService.getFilteredDoctors(request);

      if (response.success && response.data != null && mounted) {
        final convertedDoctors = response.data!.doctors.map((apiDoctor) {
          return Doctor(
            id: apiDoctor.id,
            firstName: apiDoctor.firstName ?? '',
            lastName: apiDoctor.lastName ?? '',
            headline: apiDoctor.headline,
            specialization: apiDoctor.specializations.join(', '),
            qualifications: apiDoctor.degreeTypes.join(', '),
            experience: apiDoctor.yearOfExperience,
            rating: apiDoctor.rating,
            fee: apiDoctor.fee,
            timings: null,
            availability: null, 
            profilePhoto: apiDoctor.profilePhoto,
            hospitals: apiDoctor.hospitals.map((h) {
              return DoctorHospital(
                id: h.id,
                name: h.name,
                city: h.city,
                state: h.state,
                latitude: h.latitude,
                longitude: h.longitude,
                distanceKm: h.distance,
                consultationFee: h.consultationFee?.toString(),
              );
            }).toList(),
            clinics: apiDoctor.clinics.map((c) {
              return {
                'id': c.id,
                'name': c.name,
                'city': c.city,
                'state': c.state,
                'latitude': c.latitude,
                'longitude': c.longitude,
                'distance': c.distance,
                'consultationFee': c.consultationFee,
              };
            }).toList(),
            isFavourite: apiDoctor.isFavourite,
          );
        }).toList();

        setState(() {
          _doctors = convertedDoctors;
          _isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = response.message;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load doctors: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  // Helper to filter locally by search query
  List<Doctor> get _filteredDoctors {
    if (_searchQuery.isEmpty) {
      return _doctors;
    }
    return _doctors.where((doctor) {
      final name = doctor.name.toLowerCase();
      final specializations = doctor.specialization.toLowerCase();
      final qualifications = doctor.qualifications.toLowerCase();
      return name.contains(_searchQuery) ||
          specializations.contains(_searchQuery) ||
          qualifications.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            EcliniqIcons.backArrow.assetPath,
            width: 32,
            height: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Doctors',
            style: EcliniqTextStyles.headlineMedium.copyWith(
              color: Color(0xff424242),
            ),
          ),
        ),
        actions: [
          SvgPicture.asset(EcliniqIcons.sort.assetPath, width: 32, height: 32),
          VerticalDivider(
            color: Colors.grey[400],
            thickness: 1,
            width: 24,
            indent: 12,
            endIndent: 12,
          ),
          SvgPicture.asset(
            EcliniqIcons.filter.assetPath,
            width: 32,
            height: 32,
          ),
          SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Color(0xFFB8B8B8), height: 1.0),
        ),
      ),
      body: Container(
        color: const Color(0xffF9F9F9),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Location Section
            _buildLocationSection(),
            // Search Bar
            _buildSearchBar(),
            // Category Filters
            _buildCategoryFilters(),
            // Doctor List
            Expanded(child: _buildDoctorList()),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location picker coming soon!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            SvgPicture.asset(
              EcliniqIcons.mapPointBlue.assetPath,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _currentLocation,
              style: EcliniqTextStyles.headlineXMedium.copyWith(
                color: Color(0xff424242),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xff424242)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff626060), width: 0.7),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 4),
            child: Image.asset(
              EcliniqIcons.magnifierMyDoctor.assetPath,
              width: 20,
              height: 20,
            ),
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voice search coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: SvgPicture.asset(
                EcliniqIcons.microphone.assetPath,
                width: 16,
                height: 16,
              ),
            ),
          ),
          hintText: 'Search Doctor',
          hintStyle: TextStyle(
            color: Color(0xffD6D6D6),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = [
      'All',
      'General Physician',
      'Paediatrics',
      'Gynaecology',
      'Dermatology',
      'Cardiology',
    ];

    if (widget.initialSpeciality != null && !categories.contains(widget.initialSpeciality) && widget.initialSpeciality != 'All') {
       categories.insert(1, widget.initialSpeciality!);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: categories.map((category) {
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () => _onCategorySelected(category),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 26,
                    top: 12,
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected
                            ? Color(0xFF2372EC)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Color(0xFF2372EC) : Color(0xFF626060),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorList() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
      );
    }

    final doctors = _filteredDoctors;

    if (doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No doctors found matching your search'
                  : 'No doctors available',
              style: EcliniqTextStyles.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return _buildDoctorCard(doctors[index]);
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            _getInitials(doctor.name),
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: SvgPicture.asset(
                            EcliniqIcons.verified.assetPath,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Doctor Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: EcliniqTextStyles.headlineLarge.copyWith(
                            color: const Color(0xFF424242),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                           doctor.specialization.isNotEmpty ? doctor.specialization : 'General',
                          style: EcliniqTextStyles.titleXLarge.copyWith(
                            color: const Color(0xFF424242),
                          ),
                        ),
                        if (doctor.qualifications.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            doctor.qualifications,
                            style: EcliniqTextStyles.titleXLarge.copyWith(
                              color: const Color(0xFF424242),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              // Experience, Rating, Availability Section (below profile)
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Experience and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (doctor.experience != null) ...[
                        Icon(
                          Icons.work_outline,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${doctor.experience}yrs of exp',
                          style: EcliniqTextStyles.titleXLarge.copyWith(
                            color: const Color(0xFF626060),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '●',
                          style: TextStyle(
                            color: Color(0xff8E8E8E),
                            fontSize: 8,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffFEF9E6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              EcliniqIcons.star.assetPath,
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              doctor.rating?.toStringAsFixed(1) ?? '4.0',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffBE8B00),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '●',
                        style: TextStyle(
                          color: Color(0xff8E8E8E),
                          fontSize: 8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        doctor.fee != null ? '₹${doctor.fee}' : 'Fee Unavailable',
                        style: EcliniqTextStyles.titleXLarge.copyWith(
                          color: const Color(0xFF626060),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Availability
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatTimings(doctor.timings),
                          style: EcliniqTextStyles.titleXLarge.copyWith(
                            color: const Color(0xFF626060),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location with distance
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _currentLocation, 
                        style: EcliniqTextStyles.titleXLarge.copyWith(
                          color: const Color(0xFF626060),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getDistanceText(doctor),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Token Availability
                   Text(
                    _getTokenAvailability(doctor),
                    style: EcliniqTextStyles.bodySmallProminent.copyWith(
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Booking Section
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
                          color: _getAvailabilityColor(doctor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                            child:  Text(
                              _getAvailabilityStatus(doctor),
                              textAlign: TextAlign.center,
                              style: EcliniqTextStyles.titleXLarge.copyWith(
                                color: Color(0xff626060),
                              ),
                            ),
                          ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                             EcliniqRouter.push(
                              ClinicVisitSlotScreen(
                                doctorId: doctor.id,
                                hospitalId: doctor.hospitals.isNotEmpty ? doctor.hospitals.first.id : '',
                                doctorName: doctor.name,
                                doctorSpecialization:
                                    doctor.specialization.isNotEmpty
                                    ? doctor.specialization
                                    : null,
                              ),
                            );
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
                        child: Text(
                          'Book Appointment',
                          style: EcliniqTextStyles.headlineMedium.copyWith(
                            color: Colors.white,
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
        Container(height: 1, color: Colors.grey[300]),
      ],
    );
  }
  
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  String _formatTimings(String? timings) {
    if (timings == null || timings.isEmpty) {
      return '10am - 9:30pm (Mon - Sat)';
    }
    return timings;
  }
  
  String _getDistanceText(Doctor doctor) {
      double? minDist;
      
      for (var h in doctor.hospitals) {
        if (h.distanceKm != null) {
          if (minDist == null || h.distanceKm! < minDist) {
            minDist = h.distanceKm;
          }
        }
      }
      
      for (var c in doctor.clinics) {
          final dist = c['distance'];
           if(dist is num) {
               if (minDist == null || dist.toDouble() < minDist) {
                minDist = dist.toDouble();
               }
           }
      }
      
      if (minDist != null) {
          return '${minDist.toStringAsFixed(1)} Km';
      }
      return 'Nearby';
  }

  String _getAvailabilityStatus(Doctor doctor) {
     if (doctor.availability == null) return 'Available';

    switch (doctor.availability!.status) {
      case 'AVAILABLE':
        return 'Available Now';
      case 'NEXT_DAY':
        return doctor.availability!.message;
      case 'BUSY':
        return 'Currently Busy';
      case 'UNAVAILABLE':
        return 'Not Available';
      default:
        return 'Available';
    }
  }

  Color _getAvailabilityColor(Doctor doctor) {
    if (doctor.availability == null) return Colors.green[50]!;

    switch (doctor.availability!.status) {
      case 'AVAILABLE':
        return Colors.green[50]!;
      case 'NEXT_DAY':
        return Colors.blue[50]!;
      case 'BUSY':
        return Colors.orange[50]!;
      case 'UNAVAILABLE':
        return Colors.red[50]!;
      default:
        return Colors.green[50]!;
    }
  }

  String _getTokenAvailability(Doctor doctor) {
    if (doctor.availability?.availableTokens != null) {
      final available = doctor.availability!.availableTokens!;
      return '$available Tokens Available';
    }
    return 'Tokens Available';
  }
}
