import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RatingBottomSheet extends StatefulWidget {
  final int initialRating;
  final String doctorName;
  final Function(int rating) onSubmit;

  const RatingBottomSheet({
    super.key,
    this.initialRating = 0,
    required this.doctorName,
    required this.onSubmit,
  });

  /// Static method to show the bottom sheet
  static Future<int?> show({
    required BuildContext context,
    int initialRating = 0,
    required String doctorName,
    required Function(int rating) onSubmit,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => RatingBottomSheet(
        initialRating: initialRating,
        doctorName: doctorName,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  late int _tempRating;

  @override
  void initState() {
    super.initState();
    _tempRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          const SizedBox(height: 16),
          Text(
            'How was your Experience with ${widget.doctorName}?',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
          ),

          const SizedBox(height: 16),
          _buildRatingStars(),
          const SizedBox(height: 24),
          _buildSubmitButton(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildRatingStars() {
    int rating = 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate your Experience :',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xFF2372EC),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 18),
                child: SvgPicture.asset(
                  index < rating
                      ? EcliniqIcons.starRateExp.assetPath
                      : EcliniqIcons.starRateExpUnfilled.assetPath,
                  width: 32,
                  height: 32,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          if (_tempRating > 0) {
            widget.onSubmit(_tempRating);
          }
          Navigator.of(context).pop(_tempRating);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2372EC),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: const Text(
          'Submit Feedback',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
