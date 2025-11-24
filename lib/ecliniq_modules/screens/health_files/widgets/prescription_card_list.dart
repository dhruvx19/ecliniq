import 'dart:io';

import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/models/health_file_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PrescriptionCardList extends StatelessWidget {
  final HealthFile file;
  final bool isOlder;
  final double headingFontSize;
  final double subheadingFontSize;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;

  const PrescriptionCardList({
    super.key,
    required this.file,
    this.isOlder = false,
    this.headingFontSize = 18,
    this.subheadingFontSize = 14,
    this.onTap,
    this.onMenuTap,
  });

  String _formatDay(DateTime date) {
    return date.day.toString().padLeft(2, '0');
  }

  String _formatMonth(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  String _getFileTypeDisplayName() {
    return file.fileType.displayName;
  }

  Widget _buildThumbnail() {
    final fileExists = File(file.filePath).existsSync();

    if (fileExists && file.isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.file(
          File(file.filePath),
          width: 50,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderThumbnail();
          },
        ),
      );
    }

    return _buildPlaceholderThumbnail();
  }

  Widget _buildPlaceholderThumbnail() {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.abc, size: 10), SizedBox(width: 2)],
              ),
            ),
            const SizedBox(height: 4),
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Container(
                  height: 2,
                  width: double.infinity,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = file.fileDate ?? file.createdAt;
    final day = _formatDay(displayDate);
    final month = _formatMonth(displayDate);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xffD6D6D6), width: 0.5),
          // No shadow for list items
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff424242),
                    ),
                  ),
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 14,
                      color: isOlder ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _buildThumbnail(),

            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.fileName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff424242),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getFileTypeDisplayName(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff8E8E8E),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onMenuTap,
              child: RotatedBox(
                quarterTurns: 1,
                child: SvgPicture.asset(
                  EcliniqIcons.threeDots.assetPath,
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
