import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DeleteFileBottomSheet extends StatefulWidget {
  const DeleteFileBottomSheet({super.key});

  @override
  State<DeleteFileBottomSheet> createState() => _DeleteFileBottomSheetState();
}

class _DeleteFileBottomSheetState extends State<DeleteFileBottomSheet> {
  late int _tempRating;

  @override
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
          SizedBox(
            width: 142,
            height: 110,
            child: SvgPicture.asset(EcliniqIcons.deleteFile.assetPath),
          ),

          const SizedBox(height: 16),
          Text(
            'Are you sure you want delete Selected files?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
          ),
          Text(
            'Once file is deleted can’t be restore',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF626060),
            ),
          ),

          const SizedBox(height: 16),

          _buildSubmitButton(),
          const SizedBox(height: 8),
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
          Navigator.of(context).pop(_tempRating);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2372EC),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: const Text(
          'Ok',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
