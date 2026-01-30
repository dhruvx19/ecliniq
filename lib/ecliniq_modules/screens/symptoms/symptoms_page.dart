import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/search_bar.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SymptomsPage extends StatefulWidget {
  const SymptomsPage({super.key});

  @override
  State<SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _commonSymptoms = [
    {'title': 'Fever/Chills', 'icon': EcliniqIcons.fever},
    {'title': 'Headache', 'icon': EcliniqIcons.headache},
    {'title': 'Stomach Pain', 'icon': EcliniqIcons.stomachPain},
    {'title': 'Cold & Cough', 'icon': EcliniqIcons.coughCold},
    {'title': 'Body Pain', 'icon': EcliniqIcons.bodyPain},
    {'title': 'Back Pain', 'icon': EcliniqIcons.backPain},
    {'title': 'Breathing Difficulty', 'icon': EcliniqIcons.breathingProblem},
    {'title': 'Skin Rash /Itching', 'icon': EcliniqIcons.itchingOrSkinProblem},
    {'title': 'Periods Problem', 'icon': EcliniqIcons.periodsProblem},
    {'title': 'Sleep Problem', 'icon': EcliniqIcons.sleepProblem},
    // {'title': 'Hair Related Problem', 'icon': EcliniqIcons.hairProblem},
    // {'title': 'Pregnancy Related', 'icon': EcliniqIcons.pregnancyRelated},
    // {'title': 'Dental Care', 'icon': EcliniqIcons.dentalCare},
    // {'title': 'Joint Pain', 'icon': EcliniqIcons.jointPain},
    // {'title': 'Joint Swelling', 'icon': EcliniqIcons.jointSwelling},
  ];

  final Map<String, List<String>> _categorySymptoms = {
    'Child Health': [
      'Vomiting or Diarrhea (Child)',
      'Poor Feeding',
      'Excessive Crying / Irritability',
      'Skin Rash (Child)',
      'Growth or Development Concerns',
      'Vaccination',
    ],
    'Women\'s Health': [
      'Irregular or Painful Periods',
      'Heavy Menstrual Bleeding',
      'Vaginal Discharge / Infection',
      'Pelvic or Lower Abdominal Pain',
      'Pregnancy Card',
      'Menopause Symptoms',
      'Breast Lump or Pain',
      'Fertility Concerns',
    ],
    'Dental Health': [
      'Toothache',
      'Cavities',
      'Bleeding or Swollen Gums',
      'Mouth Ulcers',
      'Bad Breath',
      'Jaw Pain',
      'Tooth Sensitivity',
      'Wisdom Tooth Pain',
    ],
    'Diabetes & Hormones': [
      'High or Low Blood Sugar',
      'Excessive Thirst or Urination',
      'Slow Wound Healing',
      'Numbness in Feet',
      'Thyroid Problems',
      'Weight Gain or Loss',
      'Hormonal Imbalance',
      'PCOS Symptoms',
    ],
    'Cancer Care': [
      'Lump or Swelling',
      'Unexplained Weight Loss',
      'Persistent Pain',
      'Non-Healing Wounds',
      'Cancer Follow up',
      'Chemotherapy Consultation',
    ],
    'Skin & Hair': [],
    'ENT Health': [],
    'Eyes Health': [],
    'Heart & Chest': [],
    'Bones & Movement': [],
    'Lungs & Breathing': [],
    'Kidney & Urinary': [],
    'Stomach & Liver': [],
    'Brain & Mental Health': [],
  };

  List<Map<String, dynamic>> get _filteredCommonSymptoms {
    if (_searchQuery.isEmpty) return _commonSymptoms;
    return _commonSymptoms.where((symptom) {
      final title = (symptom['title'] as String).toLowerCase();
      return title.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Map<String, List<String>> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categorySymptoms;

    final filtered = <String, List<String>>{};
    _categorySymptoms.forEach((category, symptoms) {
      final matchingSymptoms = symptoms.where((symptom) {
        return symptom.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();

      if (matchingSymptoms.isNotEmpty ||
          category.toLowerCase().contains(_searchQuery.toLowerCase())) {
        filtered[category] = matchingSymptoms;
      }
    });
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final hasResults =
        _filteredCommonSymptoms.isNotEmpty || _filteredCategories.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 58,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            EcliniqIcons.arrowLeft.assetPath,
            width: 32,
            height: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Symptoms',
            style: EcliniqTextStyles.responsiveHeadlineMedium(
              context,
            ).copyWith(color: Color(0xff424242)),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.2),
          child: Container(color: Color(0xFFB8B8B8), height: 1.0),
        ),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            hintText: 'Search Symptoms',
            onSearch: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
          Expanded(
            child: !hasResults
                ? Center(
                    child: Text(
                      'No symptoms found',
                      style: EcliniqTextStyles.responsiveBodyMediumProminent(
                        context,
                      ).copyWith(color: Colors.grey),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_filteredCommonSymptoms.isNotEmpty) ...[
                          EcliniqText(
                            'General & Common',
                            style:
                                EcliniqTextStyles.responsiveBodyMediumProminent(
                                  context,
                                ).copyWith(
                                  color: const Color(0xff424242),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16.0,
                                  mainAxisSpacing: 16.0,
                                  childAspectRatio: 0.85,
                                ),
                            itemCount: _filteredCommonSymptoms.length,
                            itemBuilder: (context, index) {
                              final symptom = _filteredCommonSymptoms[index];
                              return _buildSymptomButton(
                                context,
                                symptom['title'] as String,
                                symptom['icon'] as EcliniqIcons,
                                () {},
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Category sections
                        ..._filteredCategories.entries.map((entry) {
                          return _buildCategorySection(
                            context,
                            entry.key,
                            entry.value,
                          );
                        }),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomButton(
    BuildContext context,
    String title,
    EcliniqIcons icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          EcliniqTextStyles.getResponsiveBorderRadius(context, 8.0),
        ),
        child: Container(
          width: EcliniqTextStyles.getResponsiveWidth(context, 120.0),
          height: EcliniqTextStyles.getResponsiveHeight(context, 124.0),
          decoration: BoxDecoration(
            color: Color(0xFfF8FAFF),
            borderRadius: BorderRadius.circular(
              EcliniqTextStyles.getResponsiveBorderRadius(context, 8.0),
            ),
          ),
          child: Padding(
            padding: EcliniqTextStyles.getResponsiveEdgeInsetsAll(
              context,
              10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: EcliniqTextStyles.getResponsiveSpacing(context, 2.0),
                ),
                Container(
                  width: EcliniqTextStyles.getResponsiveSize(context, 48.0),
                  height: EcliniqTextStyles.getResponsiveSize(context, 48.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF2372EC),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      icon.assetPath,
                      width: EcliniqTextStyles.getResponsiveIconSize(
                        context,
                        48.0,
                      ),
                      height: EcliniqTextStyles.getResponsiveIconSize(
                        context,
                        48.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: EcliniqTextStyles.getResponsiveSpacing(context, 8.0),
                ),
                Flexible(
                  child: EcliniqText(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
             
                    style: EcliniqTextStyles.responsiveTitleXLarge(context)
                        .copyWith(
                          color: Color(0xff424242),
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String category,
    List<String> symptoms,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EcliniqText(
          category,
          style: EcliniqTextStyles.responsiveBodyMediumProminent(context)
              .copyWith(
                color: const Color(0xff424242),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 12),
        if (symptoms.isNotEmpty)
          ...symptoms.map((symptom) => _buildSymptomListItem(context, symptom))
        else
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: EcliniqText(
                    category,
                    style:
                        EcliniqTextStyles.responsiveBodyMediumProminent(
                          context,
                        ).copyWith(
                          color: const Color(0xff424242),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSymptomListItem(BuildContext context, String symptom) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: EcliniqText(
                symptom,
                style: EcliniqTextStyles.responsiveBodyMediumProminent(context)
                    .copyWith(
                      color: const Color(0xff424242),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}
