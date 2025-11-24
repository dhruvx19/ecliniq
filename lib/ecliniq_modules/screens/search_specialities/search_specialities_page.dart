import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/search_specialities/speciality_doctors_list.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Speciality {
  final String id;
  final String title;
  final String? subtitle;
  final String iconPath;

  Speciality({
    required this.id,
    required this.title,
    this.subtitle,
    required this.iconPath,
  });
}

class SearchSpecialities extends StatefulWidget {
  const SearchSpecialities({super.key});

  @override
  State<SearchSpecialities> createState() => _SearchSpecialitiesState();
}

class _SearchSpecialitiesState extends State<SearchSpecialities> {
  final TextEditingController _searchController = TextEditingController();
  List<Speciality> _allSpecialities = [];
  List<Speciality> _filteredSpecialities = [];

  @override
  void initState() {
    super.initState();
    _initializeSpecialities();
    _searchController.addListener(_filterSpecialities);
  }

  void _initializeSpecialities() {
    _allSpecialities = [
      Speciality(
        id: 'general_physician',
        title: 'General Physician',
        subtitle: 'Family Doctor',
        iconPath: EcliniqIcons.generalMedicine.assetPath,
      ),
      Speciality(
        id: 'pediatrician',
        title: 'Pediatrician',
        subtitle: 'Child Specialist',
        iconPath: EcliniqIcons.childSpe.assetPath,
      ),
      Speciality(
        id: 'pediatrician',
        title: 'Pediatrician',
        subtitle: 'Child Specialist',
        iconPath: EcliniqIcons.cancer.assetPath,
      ),
      Speciality(
        id: 'gynaecologist',
        title: 'Gynaecologist',
        subtitle: "Women's Health",
        iconPath: EcliniqIcons.gynecologist.assetPath,
      ),
      Speciality(
        id: 'dentist',
        title: 'Dentist',
        iconPath: EcliniqIcons.dentist.assetPath,
      ),
      Speciality(
        id: 'dermatologist',
        title: 'Dermatologist',
        subtitle: 'Skin & Hair Specialist',
        iconPath: EcliniqIcons.skinCare.assetPath,
      ),
      Speciality(
        id: 'ent',
        title: 'ENT',
        subtitle: 'Ear, Nose, Throat Specialist',
        iconPath: EcliniqIcons.ent.assetPath,
      ),
      Speciality(
        id: 'ophthalmologist',
        title: 'Ophthalmologist',
        subtitle: 'Eye Specialist',
        iconPath: EcliniqIcons.eyeCare.assetPath,
      ),
      Speciality(
        id: 'cardiologist',
        title: 'Cardiologist',
        subtitle: 'Heart Specialist',
        iconPath: EcliniqIcons.cardiologist.assetPath,
      ),
      Speciality(
        id: 'cardiologist',
        title: 'Cardiologist',
        subtitle: 'Heart Specialist',
        iconPath: EcliniqIcons.bone.assetPath,
      ),
    ];
    _filteredSpecialities = List.from(_allSpecialities);
  }

  void _filterSpecialities() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredSpecialities = List.from(_allSpecialities);
      } else {
        _filteredSpecialities = _allSpecialities.where((speciality) {
          final titleMatch = speciality.title.toLowerCase().contains(query);
          final subtitleMatch =
              speciality.subtitle?.toLowerCase().contains(query) ?? false;
          return titleMatch || subtitleMatch;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

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
            'Specialities',
            style: EcliniqTextStyles.headlineMedium.copyWith(
              color: Color(0xff424242),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Color(0xFFB8B8B8), height: 1.0),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _filteredSpecialities.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: _filteredSpecialities.length,
                    itemBuilder: (context, index) {
                      return _buildSpecialityItem(_filteredSpecialities[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final outlinedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Color(0xFFE0E0E0), width: 1.0),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          enabledBorder: outlinedBorder,
          focusedBorder: outlinedBorder,
          border: outlinedBorder,
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 16.0, right: 8.0),
            child: Image.asset(
              EcliniqIcons.magnifierMyDoctor.assetPath,
              width: 20,
              height: 20,
            ),
          ),
          hintText: 'Search Speciality',
          hintStyle: TextStyle(
            color: Color(0xFF8E8E8E),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
        ),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        textInputAction: TextInputAction.search,
        cursorColor: Colors.blue,
      ),
    );
  }

  Widget _buildSpecialityItem(Speciality speciality) {
    return Column(
      children: [
        Material(
          child: InkWell(
            onTap: () {
              EcliniqRouter.push(SpecialityDoctorsList());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(color: Color(0xFFD6D6D6), width: 0.5),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
              child: Row(
                children: [
                  Image.asset(speciality.iconPath),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          speciality.title,
                          style: EcliniqTextStyles.headlineXMedium.copyWith(
                            color: Color(0xff424242),
                          ),
                        ),
                        if (speciality.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            speciality.subtitle!,
                            style: EcliniqTextStyles.bodySmall.copyWith(
                              color: Color(0xff626060),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    EcliniqIcons.arrowRight.assetPath,
                    width: 24,
                    height: 24,
                    color: Color(0xFF424242),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Color(0xFF8E8E8E)),
          const SizedBox(height: 16),
          Text(
            'No specialities found',
            style: EcliniqTextStyles.headlineMedium.copyWith(
              color: Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with a different term',
            style: EcliniqTextStyles.titleXLarge.copyWith(
              color: Color(0xFF8E8E8E),
            ),
          ),
        ],
      ),
    );
  }
}
