import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/text/text.dart';
import 'package:flutter/material.dart';

class ProfilePhotoSelector extends StatelessWidget {
  const ProfilePhotoSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EcliniqText(
                'Add Profile Photo',
                style: EcliniqTextStyles.titleXLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),


          _buildPhotoOption(
            context: context,

            title: 'Take Photo',
            onTap: () => Navigator.pop(context, 'take_photo'),
          ),

          const SizedBox(height: 12),


          _buildPhotoOption(
            context: context,
            title: 'Upload Photo',
            onTap: () => Navigator.pop(context, 'upload_photo'),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPhotoOption({
    required BuildContext context,

    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: EcliniqTextStyles.titleMedium.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
