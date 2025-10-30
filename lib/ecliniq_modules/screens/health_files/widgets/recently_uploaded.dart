import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/recently_uploaded.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/file_options_bottom_sheet.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/action_bottom_sheet.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UploadedFile {
  final String fileName;
  final String fileType;
  final String uploadDate;
  final String uploadTime;
  final String prescriptionImagePath;

  UploadedFile({
    required this.fileName,
    required this.fileType,
    required this.uploadDate,
    required this.uploadTime,
    required this.prescriptionImagePath,
  });
}

class RecentlyUploadedWidget extends StatelessWidget {
  const RecentlyUploadedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final recentFiles = [
      UploadedFile(
        fileName: 'Prescription.pdf',
        fileType: 'PDF',
        uploadDate: '08/08/2025',
        uploadTime: '9:30pm',
        prescriptionImagePath: 'assets/images/prescription1.png',
      ),
      UploadedFile(
        fileName: 'Prescription.pdf',
        fileType: 'PDF',
        uploadDate: '08/08/2025',
        uploadTime: '9:30pm',
        prescriptionImagePath: 'assets/images/prescription2.png',
      ),
      UploadedFile(
        fileName: 'Lab Report.pdf',
        fileType: 'PDF',
        uploadDate: '07/08/2025',
        uploadTime: '2:15pm',
        prescriptionImagePath: 'assets/images/prescription3.png',
      ),
    ];

    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 2.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text(
              'Recently Uploaded',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                 color: Color(0xff424242),
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16.0),
              itemCount: recentFiles.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return RecentFileCard(file: recentFiles[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecentFileCard extends StatelessWidget {
  final UploadedFile file;

  const RecentFileCard({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    EcliniqIcons.prescription.assetPath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    EcliniqIcons.pdf.assetPath,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.fileName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF424242),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${file.uploadDate} | ${file.uploadTime}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8E8E8E),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // IconButton(
                  //   onPressed: () {
                  //     _showFileOptions(context, file);
                  //   },
                  //   icon: const Icon(Icons.more_vert),
                  //   color: Colors.grey.shade700,
                  //   iconSize: 20,
                  //   padding: EdgeInsets.zero,
                  //   constraints: const BoxConstraints(),
                  // ),
                  GestureDetector(
                    onTap: () => EcliniqBottomSheet.show(
                      context: context,
                      child: ActionBottomSheet(),
                    ),
                    child: SvgPicture.asset(
                      EcliniqIcons.threeDots.assetPath,
                      width: 32,
                      height: 32,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
