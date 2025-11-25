import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectMemberBottomSheet extends StatefulWidget {
  const SelectMemberBottomSheet({super.key});

  @override
  State<SelectMemberBottomSheet> createState() =>
      _SelectMemberBottomSheetState();
}

class _SelectMemberBottomSheetState extends State<SelectMemberBottomSheet> {
  int selectedIndex = 0;

  final List<FamilyMember> familyMembers = [
    FamilyMember(
      name: 'Ketan Patni',
      relation: 'Self',
      avatar: '👨‍💼',
      color: Color(0xFFFF6B35),
    ),
    FamilyMember(
      name: 'Archana Patni',
      relation: 'Mother',
      avatar: '👩',
      color: Color(0xFF4F46E5),
    ),
    FamilyMember(
      name: 'Devendra Patni',
      relation: 'Father',
      avatar: '👨',
      color: Color(0xFF4F46E5),
    ),
  ];

  final List<String> dependentAvatars = [
    '👶',
    '👧',
    '👦',
    '👨',
    '👴',
    '👵',
    '👶🏽',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select Family Member',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF424242),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Family Members List
          ...familyMembers.asMap().entries.map((entry) {
            int index = entry.key;
            FamilyMember member = entry.value;
            bool isSelected = selectedIndex == index;

            return InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFF8F9FF) : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected ? Color(0xFF96BFFF) : Colors.white,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Radio button
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Color(0xFF4F46E5)
                              : Color(0xFFD1D5DB),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF4F46E5),
                                ),
                              ),
                            )
                          : null,
                    ),

                    SizedBox(width: 16),

                    // Avatar
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Color(0xffF2F7FF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF96BFFF),
                          width: 0.6,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          member.avatar,
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Name and Relation
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF424242),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            member.relation,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF626060),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          SizedBox(height: 12),

          // Add Dependents Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFD6D6D6), width: 0.5),
            ),
            child: Column(
              children: [
                SizedBox(height: 16),

                InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F7FF),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Color(0xFF96BFFF), width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          EcliniqIcons.add.assetPath,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF2372EC),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Add Dependents',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2372EC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class FamilyMember {
  final String name;
  final String relation;
  final String avatar;
  final Color color;

  FamilyMember({
    required this.name,
    required this.relation,
    required this.avatar,
    required this.color,
  });
}
