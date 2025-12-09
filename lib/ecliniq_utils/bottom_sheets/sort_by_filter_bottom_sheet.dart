import 'package:flutter/material.dart';

class SortByBottomSheet extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SortByBottomSheet({super.key, required this.onChanged});

  @override
  State<SortByBottomSheet> createState() => _SortByBottomSheetState();
}

class _SortByBottomSheetState extends State<SortByBottomSheet> {
  String? selectedSortOption;

  final List<String> sortOptions = [
    'Relevance',
    'Price: Low - High',
    'Price: High - Low',
    'Experience - Most Experience first',
    'Distance - Nearest First',
    'Order A-Z',
    'Order Z-A',
    'Rating High - low',
    'Rating Low - High',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff424242),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // List of sort options
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sortOptions.length,
              itemBuilder: (context, index) {
                final option = sortOptions[index];
                final isSelected = selectedSortOption == option;
                return _buildSortOption(option, isSelected);
              },
            ),
          ),

          // Apply button
        ],
      ),
    );
  }

  Widget _buildSortOption(String option, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedSortOption = option;
        });
        widget.onChanged(option);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Color(0xff2372EC) : Color(0xff8E8E8E),
                  width: 1,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff2372EC),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff424242),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
