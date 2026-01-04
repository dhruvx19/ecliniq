import 'package:ecliniq/ecliniq_modules/screens/hospital/widgets/surgery_details.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../ecliniq_icons/icons.dart';

class SurgeryList extends StatefulWidget {
  const SurgeryList({super.key});

  @override
  State<SurgeryList> createState() => _SurgeryListState();
}

class _SurgeryListState extends State<SurgeryList> {
  // List of surgeries data
  final List<Map<String, dynamic>> surgeries = [
    {
      'name': 'Appendectomy',
      'description':
          'Surgical removal of the appendix, usually performed to treat appendicitis.',
      'icon': EcliniqIcons.scissors,
    },
    {
      'name': 'Hernia Repair Surgery',
      'description':
          'Correction of hernias in the abdomen or groin using open or laparoscopic techniques.',
      'icon': EcliniqIcons.scissors,
    },
    {
      'name': 'Gallbladder Removal Surgery',
      'description':
          'Cholecystectomy, the surgical removal of the gallbladder, often performed due to gallstones.',
      'icon': EcliniqIcons.scissors,
    },
    {
      'name': 'Knee Replacement Surgery',
      'description':
          'Total or partial knee arthroplasty to relieve pain and improve function in patients with knee damage..',
      'icon': EcliniqIcons.scissors,
    },
    {
      'name': 'Knee Replacement',
      'description':
          'Surgical procedure to replace a damaged knee joint with an artificial prosthesis.',
      'icon': EcliniqIcons.scissors,
    },
    {
      'name': 'Caesarean Section',
      'description':
          'Surgical delivery of a baby through an incision in the mother\'s abdomen and uterus.',
      'icon': EcliniqIcons.scissors,
    },
    {
      'name': 'Tonsillectomy',
      'description':
          'Surgical removal of the tonsils, often performed to treat chronic tonsillitis or breathing problems.',
      'icon': EcliniqIcons.scissors,
    },
    {
      'name': 'Coronary Bypass',
      'description':
          'Heart surgery to improve blood flow to the heart by creating new routes around blocked arteries.',
      'icon': EcliniqIcons.scissors,
    },
  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
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
            'List of Surgeries',
            style: EcliniqTextStyles.headlineMedium.copyWith(
              color: Color(0xff424242),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.2),
          child: Container(color: Color(0xFFB8B8B8), height: 0.5),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            height: 52,
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xff626060), width: 0.5),
            ),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(
                  EcliniqIcons.magnifierMyDoctor.assetPath,
                  height: 24,
                  width: 24,
                ),
                Expanded(
                  child: TextField(
              
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Search Surgeries',
                      hintStyle: TextStyle(
                        color: Color(0xff8E8E8E),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  EcliniqIcons.microphone.assetPath,
                  height: 32,
                  width: 32,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return SurgeryDetail(surgery: surgeries[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
