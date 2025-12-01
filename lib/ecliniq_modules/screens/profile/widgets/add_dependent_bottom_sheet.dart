import 'package:ecliniq/ecliniq_ui/lib/tokens/colors.g.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/add_dependent_bottom_sheet_provider.dart';

class AddDependentBottomSheet extends StatelessWidget {
  const AddDependentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FamilySelectionProvider(),
      child: Container(
        decoration: BoxDecoration(
          color: EcliniqColors.light.bgBaseOverlay,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: EcliniqColors.light.strokeNeutralSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15),
              child: Text(
                'Select Family Member',
                style: EcliniqTextStyles.headlineBMedium.copyWith(
                  color: EcliniqColors.light.textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),

            Consumer<FamilySelectionProvider>(
              builder: (context, provider, child) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    itemCount: provider.familyMembers.length,
                    itemBuilder: (context, index) {
                      final member = provider.familyMembers[index];
                      final isSelected = provider.selectedIndex == index;

                      return Container(
                        decoration: isSelected ? BoxDecoration(
                          color: EcliniqColors.light.strokeBrand.withOpacity(0.1),

                            borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: EcliniqColors.light.strokeBrand
                          )
                        ):null,
                        child: ListTile(
                          leading: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? EcliniqColors.light.strokeBrand
                                    : EcliniqColors.light.strokeNeutralSubtle,
                              ),
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? EcliniqColors.light.bgContainerInteractiveBrand
                                  : EcliniqColors.light.bgBaseOverlay,
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: EcliniqColors.light.bgBaseOverlay,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [

                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                  image: DecorationImage(
                                    image: NetworkImage(member.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Name and relation
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.name,
                                      style: EcliniqTextStyles.bodyMedium.copyWith(
                                        color: EcliniqColors.light.textPrimary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      member.relation,
                                      style: EcliniqTextStyles.bodySmall.copyWith(
                                        color: EcliniqColors.light.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            provider.selectMember(index);
                            Future.delayed(
                              const Duration(milliseconds: 300),
                                  () => Navigator.pop(context, member),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            Consumer<FamilySelectionProvider>(
              builder: (context, provider, child) {
                return Container(
                  margin: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color:Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Container(
                          height: 33,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        OutlinedButton.icon(
                          onPressed: () {

                          },
                          icon: Icon(
                            Icons.add,
                            color: EcliniqColors.light.strokeBrand,
                          ),
                          label: Text(
                            'Add Dependents',
                            style: EcliniqTextStyles.bodyMedium.copyWith(
                              color: EcliniqColors.light.strokeBrand,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: EcliniqColors.light.strokeBrand,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: EcliniqColors.light.strokeBrand.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}