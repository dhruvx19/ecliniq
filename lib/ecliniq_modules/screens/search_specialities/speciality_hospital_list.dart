import 'dart:async';

import 'package:ecliniq/ecliniq_api/hospital_service.dart';
import 'package:ecliniq/ecliniq_api/models/hospital.dart';
import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/hospital/pages/hospital_details.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SpecialityHospitalList extends StatefulWidget {
  const SpecialityHospitalList({super.key});

  @override
  State<SpecialityHospitalList> createState() => _SpecialityHospitalListState();
}

class _SpecialityHospitalListState extends State<SpecialityHospitalList> {
  final HospitalService _hospitalService = HospitalService();
  final TextEditingController _searchController = TextEditingController();

  List<Hospital> _hospitals = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final String _currentLocation = 'Vishnu Dev Nagar, Wakad';

  // Hardcoded location as per request
  final double _latitude = 28.6139;
  final double _longitude = 77.209;

  @override
  void initState() {
    super.initState();
    _fetchHospitals();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
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
    });
  }

  Future<void> _fetchHospitals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _hospitalService.getAllHospitals(
        latitude: _latitude,
        longitude: _longitude,
      );

      if (response.success && mounted) {
        setState(() {
          _hospitals = response.data;
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
          _errorMessage = 'Failed to load hospitals: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  List<Hospital> get _filteredHospitals {
    if (_searchQuery.isEmpty) {
      return _hospitals;
    }
    return _hospitals.where((hospital) {
      final name = hospital.name.toLowerCase();
      final city = hospital.city.toLowerCase();
      return name.contains(_searchQuery) || city.contains(_searchQuery);
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
            'Hospitals',
            style: EcliniqTextStyles.headlineMedium.copyWith(
              color: const Color(0xff424242),
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
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFB8B8B8), height: 1.0),
        ),
      ),
      body: Container(
        color: const Color(0xffF9F9F9),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildLocationSection(),
            _buildSearchBar(),
            _buildCategoryFilters(),
            Expanded(child: _buildHospitalList()),
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
                color: const Color(0xff424242),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xff424242)),
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
          hintText: 'Search Hospitals',
          hintStyle: const TextStyle(
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
      'Multispeciality',
      'Super Speciality',
      'Eye Care',
      'Dental Care',
    ];

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
                            ? const Color(0xFF2372EC)
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
                      color: isSelected ? const Color(0xFF2372EC) : const Color(0xFF626060),
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

  Widget _buildHospitalList() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    final hospitals = _filteredHospitals;

    if (hospitals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No hospitals found matching your search'
                  : 'No hospitals available',
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: hospitals.length,
      itemBuilder: (context, index) {
        return _buildHospitalCard(hospitals[index]);
      },
    );
  }

  Widget _buildShimmerLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildHospitalCard(Hospital hospital) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover Image
              Container(
                height: 196,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  color: Colors.grey.shade100,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: hospital.image.isNotEmpty && _isValidImageUrl(hospital.image)
                      ? Image.network(
                          hospital.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                        )
                      : _buildImagePlaceholder(),
                ),
              ),

              // Round Avatar on overlap
              Positioned(
                left: 12,
                top: 156, // 196 (image height) - 40 (half avatar height)
                child: Container(
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
                          hospital.name.isNotEmpty
                              ? hospital.name.substring(0, 1)
                              : 'H',
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
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0, top: 48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hospital.name,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${hospital.type} | ${hospital.numberOfDoctors}+ Doctors',
                  style: const TextStyle(fontSize: 16, color: Color(0xff424242)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffFEF9E6),
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
                          const Text(
                            '4.0',
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
                        color: Colors.grey.shade400,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Est in ${hospital.establishmentYear}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff424242),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SvgPicture.asset(
                      EcliniqIcons.mapPoint.assetPath,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${hospital.city}, ${hospital.state}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff424242),
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF9F9F9),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xffB8B8B8)),
                            ),
                            child: Text(
                              hospital.distance > 0
                                  ? '${hospital.distance.toStringAsFixed(1)} Km'
                                  : 'Nearby',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xff424242),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                             EcliniqRouter.push(HospitalDetailScreen(hospitalId: hospital.id));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2372EC), // Brand Primary
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'View All Doctors',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                              ),
                              const SizedBox(width: 2),
                              SvgPicture.asset(
                                EcliniqIcons.arrowRight.assetPath,
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 22),
                    SvgPicture.asset(
                      EcliniqIcons.phone.assetPath,
                      width: 32,
                      height: 32,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidImageUrl(String url) {
    if (url.startsWith('file://') || url.startsWith('/hospitals/')) {
      return false;
    }
    return url.startsWith('http://') || url.startsWith('https://');
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade100, Colors.blue.shade50],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.local_hospital,
          size: 40,
          color: Colors.blue.shade300,
        ),
      ),
    );
  }
}
