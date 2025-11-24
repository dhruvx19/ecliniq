import 'dart:io';
import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/file_type_screen.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/models/health_file_model.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/providers/health_files_provider.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/action_bottom_sheet.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RecentlyUploadedWidget extends StatelessWidget {
  const RecentlyUploadedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthFilesProvider>(
      builder: (context, provider, child) {
        final recentFiles = provider.getRecentlyUploadedFiles(limit: 10);

        if (recentFiles.isEmpty) {
          return const SizedBox.shrink();
        }

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
      },
    );
  }
}

class RecentFileCard extends StatefulWidget {
  final HealthFile file;

  const RecentFileCard({super.key, required this.file});

  @override
  State<RecentFileCard> createState() => _RecentFileCardState();
}

class _RecentFileCardState extends State<RecentFileCard> {
  bool? _fileExists;

  @override
  void initState() {
    super.initState();
    // Check file existence asynchronously to avoid blocking build
    _checkFileExists();
  }

  Future<void> _checkFileExists() async {
    final exists = File(widget.file.filePath).existsSync();
    if (mounted) {
      setState(() {
        _fileExists = exists;
      });
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      // Today
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _getFileIcon() {
    if (widget.file.isImage) {
      return EcliniqIcons.prescription.assetPath;
    } else if (widget.file.extension == 'pdf') {
      return EcliniqIcons.pdf.assetPath;
    }
    return EcliniqIcons.pdf.assetPath;
  }

  @override
  Widget build(BuildContext context) {
    final fileExists = _fileExists ?? false;
    final filePath = widget.file.filePath;
    
    return GestureDetector(
      onTap: () {
        // Navigate to file type screen
        EcliniqRouter.push(
          FileTypeScreen(fileType: widget.file.fileType),
        );
      },
      child: Container(
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
                    child: fileExists && widget.file.isImage
                        ? Image.file(
                            File(filePath),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            cacheWidth: 640,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                EcliniqIcons.prescription.assetPath,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                cacheWidth: 640,
                              );
                            },
                          )
                        : Image.asset(
                            EcliniqIcons.prescription.assetPath,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            cacheWidth: 640,
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
                      _getFileIcon(),
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.file.fileName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF424242),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(widget.file.createdAt),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff8E8E8E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () => EcliniqBottomSheet.show(
                        context: context,
                        child: ActionBottomSheet(healthFile: widget.file),
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
      ),
    );
  }
}
