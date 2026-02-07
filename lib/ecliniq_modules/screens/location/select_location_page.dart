import 'package:ecliniq/ecliniq_core/location/location_permission_manager.dart';
import 'package:ecliniq/ecliniq_core/location/location_service.dart';
import 'package:ecliniq/ecliniq_core/location/location_storage_service.dart';
import 'package:ecliniq/ecliniq_icons/assets/home/provider/doctor_provider.dart';
import 'package:ecliniq/ecliniq_icons/assets/home/provider/hospital_provider.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  final LocationService _locationService = LocationService();
  final LocationPermissionManager _permissionManager = LocationPermissionManager();
  
  List<String> _filteredCities = [];
  bool _isSearching = false;

  final List<String> _popularCities = [
    'Delhi',
    'Bengaluru',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Pune',
    'Mumbai',
  ];

  final List<String> _otherCities = [
    'Akola',
    'Amravati',
    'Akot',
    'Amritsar',
    'Ahmedabad',
    'Agra',
    'Allahabad',
    'Aurangabad',
    'Bhopal',
    'Chandigarh',
    'Coimbatore',
    'Dehradun',
    'Faridabad',
    'Ghaziabad',
    'Goa',
    'Gurgaon',
    'Guwahati',
    'Indore',
    'Jaipur',
    'Kanpur',
    'Kochi',
    'Lucknow',
    'Ludhiana',
    'Madurai',
    'Mangalore',
    'Mysore',
    'Nagpur',
    'Nashik',
    'Noida',
    'Patna',
    'Rajkot',
    'Ranchi',
    'Surat',
    'Thane',
    'Thiruvananthapuram',
    'Vadodara',
    'Varanasi',
    'Vijayawada',
    'Visakhapatnam',
  ];

  @override
  void initState() {
    super.initState();
    _filteredCities = _otherCities;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        _filteredCities = _otherCities
            .where((city) =>
                city.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      } else {
        _filteredCities = _otherCities;
      }
    });
  }

  Future<void> _useCurrentLocation() async {
    try {
      // Check if permission is already granted
      final isGranted = await LocationPermissionManager.isPermissionGranted();
      if (isGranted) {
        final position = await _permissionManager.getCurrentLocationIfGranted();
        if (position != null) {
          await _handleLocationReceived(position);
          return;
        }
      }

      // Check if permission is permanently denied
      final isDeniedForever = await LocationPermissionManager.isPermissionDeniedForever();
      if (isDeniedForever) {
        _showSettingsDialog();
        return;
      }

      // Check if location service is enabled
      bool serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorSnackBar('Location services are disabled. Please enable them in settings.');
        return;
      }

      // Request permission
      final permissionStatus = await LocationPermissionManager.requestPermissionIfNeeded();

      if (permissionStatus == LocationPermissionStatus.granted) {
        final position = await _permissionManager.getCurrentLocationIfGranted();
        if (position != null) {
          await _handleLocationReceived(position);
        } else {
          _showErrorSnackBar('Unable to get your current location. Please try again.');
        }
      } else if (permissionStatus == LocationPermissionStatus.deniedForever) {
        _showSettingsDialog();
      } else {
        _showErrorSnackBar('Location permission denied. Please enable location permission to continue.');
      }
    } catch (e) {
      _showErrorSnackBar('Error getting location: $e');
    }
  }

  Future<void> _handleLocationReceived(Position position) async {
    // Get location name
    String? locationName;
    try {
      locationName = await _locationService.getLocationName(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      locationName = 'Current Location';
    }

    if (!mounted) return;

    // Store location
    await LocationStorageService.storeLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      locationName: locationName,
    );

    // Update providers
    _updateProvidersAndNavigateBack(
      position.latitude,
      position.longitude,
      locationName!,
    );
  }

  Future<void> _selectCity(String cityName) async {
    // For manual city selection, we use approximate coordinates
    // In a real app, you would geocode the city name to get coordinates
    final Map<String, Map<String, double>> cityCoordinates = {
      'Delhi': {'lat': 28.7041, 'lng': 77.1025},
      'Bengaluru': {'lat': 12.9716, 'lng': 77.5946},
      'Chennai': {'lat': 13.0827, 'lng': 80.2707},
      'Kolkata': {'lat': 22.5726, 'lng': 88.3639},
      'Hyderabad': {'lat': 17.3850, 'lng': 78.4867},
      'Pune': {'lat': 18.5204, 'lng': 73.8567},
      'Mumbai': {'lat': 19.0760, 'lng': 72.8777},
      'Ahmedabad': {'lat': 23.0225, 'lng': 72.5714},
      'Jaipur': {'lat': 26.9124, 'lng': 75.7873},
      'Surat': {'lat': 21.1702, 'lng': 72.8311},
    };

    final coords = cityCoordinates[cityName] ?? {'lat': 12.9716, 'lng': 77.5946};

    // Store location
    await LocationStorageService.storeLocation(
      latitude: coords['lat']!,
      longitude: coords['lng']!,
      locationName: cityName,
    );

    if (!mounted) return;

    // Update providers and go back
    _updateProvidersAndNavigateBack(
      coords['lat']!,
      coords['lng']!,
      cityName,
    );
  }

  void _updateProvidersAndNavigateBack(double lat, double lng, String locationName) {
    final hospitalProvider = Provider.of<HospitalProvider>(context, listen: false);
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    // Set location in providers
    hospitalProvider.setLocation(
      latitude: lat,
      longitude: lng,
      locationName: locationName,
    );

    doctorProvider.setLocation(
      latitude: lat,
      longitude: lng,
      locationName: locationName,
    );

    // Refresh data
    Future.wait([
      hospitalProvider.fetchTopHospitals(
        latitude: lat,
        longitude: lng,
        isRefresh: true,
      ),
      doctorProvider.fetchTopDoctors(
        latitude: lat,
        longitude: lng,
        isRefresh: true,
      ),
    ]).catchError((e) {
      // Handle error silently
    });

    // Navigate back
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const EcliniqText('Location Permission Required'),
        content: const EcliniqText(
          'Location permission has been permanently denied. Please enable it in app settings to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const EcliniqText('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _locationService.openAppSettings();
              Navigator.of(context).pop();
            },
            child: const EcliniqText('Open Settings'),
          ),
        ],
      ),
    );
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
            EcliniqIcons.arrowLeft.assetPath,
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Select Location',
          style: EcliniqTextStyles.responsiveHeadlineMedium(context).copyWith(
            color: const Color(0xFF424242),
            fontWeight: FontWeight.w500,
          ),
        ),
        titleSpacing: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Location',
                  hintStyle: EcliniqTextStyles.responsiveBodyMedium(context).copyWith(
                    color: const Color(0xFF8E8E8E),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF8E8E8E),
                    size: 24,
                  ),
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      EcliniqIcons.microphone.assetPath,
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      // Voice search implementation
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          // Use Current Location
          InkWell(
            onTap: _useCurrentLocation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Use my Current Location',
                style: EcliniqTextStyles.responsiveHeadlineBMedium(context).copyWith(
                  color: const Color(0xFF2372EC),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Popular Cities
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Popular Cities',
              style: EcliniqTextStyles.responsiveHeadlineBMedium(context).copyWith(
                color: const Color(0xFF424242),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Popular Cities List
          ..._popularCities.map((city) => InkWell(
                onTap: () => _selectCity(city),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Text(
                    city,
                    style: EcliniqTextStyles.responsiveBodyLarge(context).copyWith(
                      color: const Color(0xFF424242),
                    ),
                  ),
                ),
              )),

          const SizedBox(height: 16),

          // Other Cities
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Other Cities',
              style: EcliniqTextStyles.responsiveHeadlineBMedium(context).copyWith(
                color: const Color(0xFF424242),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Other Cities List (Scrollable)
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCities.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => _selectCity(_filteredCities[index]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Text(
                      _filteredCities[index],
                      style: EcliniqTextStyles.responsiveBodyLarge(context).copyWith(
                        color: const Color(0xFF424242),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
