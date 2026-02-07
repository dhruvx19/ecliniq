import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/file_type_screen.dart';
import 'package:ecliniq/ecliniq_api/health_file_model.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/providers/health_files_provider.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FileCategory {
  final HealthFileType fileType;
  final String backgroundImage;
  final String overlayImage;

  FileCategory({
    required this.fileType,
    required this.backgroundImage,
    required this.overlayImage,
  });

  String get title => fileType.displayName;
}

class MyFilesWidget extends StatelessWidget {
  const MyFilesWidget({super.key});

  static final List<FileCategory> _categories = [
    FileCategory(
      fileType: HealthFileType.labReports,
      backgroundImage: EcliniqIcons.blue.assetPath,
      overlayImage: EcliniqIcons.blueGradient.assetPath,
    ),
    FileCategory(
      fileType: HealthFileType.scanImaging,
      backgroundImage: EcliniqIcons.green.assetPath,
      overlayImage: EcliniqIcons.greenframe.assetPath,
    ),
    FileCategory(
      fileType: HealthFileType.prescriptions,
      backgroundImage: EcliniqIcons.orange.assetPath,
      overlayImage: EcliniqIcons.orangeframe.assetPath,
    ),
    FileCategory(
      fileType: HealthFileType.invoices,
      backgroundImage: EcliniqIcons.yellow.assetPath,
      overlayImage: EcliniqIcons.yellowframe.assetPath,
    ),
    FileCategory(
      fileType: HealthFileType.vaccinations,
      backgroundImage: EcliniqIcons.blueDark.assetPath,
      overlayImage: EcliniqIcons.blueDarkframe.assetPath,
    ),
    FileCategory(
      fileType: HealthFileType.others,
      backgroundImage: EcliniqIcons.red.assetPath,
      overlayImage: EcliniqIcons.redframe.assetPath,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EcliniqTextStyles.getResponsiveEdgeInsetsSymmetric(
            context,
            horizontal: 16,
            vertical: 12,
          ),
          child: Text(
            'My Files',
            style: EcliniqTextStyles.responsiveHeadlineLarge(
              context,
            ).copyWith(fontWeight: FontWeight.w600, color: Color(0xff424242)),
          ),
        ),

        SizedBox(
          height: 140,
          child: Consumer<HealthFilesProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final fileCount = provider.getFileCountByType(
                    category.fileType,
                  );
                  final isFirst = index == 0;
                  final isLast = index == _categories.length - 1;

                  return Padding(
                    padding: EdgeInsets.only(
                      left: isFirst
                          ? EcliniqTextStyles.getResponsiveSize(context, 16)
                          : EcliniqTextStyles.getResponsiveSize(context, 8),
                      right: isLast
                          ? EcliniqTextStyles.getResponsiveSize(context, 16)
                          : EcliniqTextStyles.getResponsiveSize(context, 8),
                    ),
                    child: FileCategoryCard(
                      category: category,
                      fileCount: fileCount,
                    ),
                  );
                },
              );
            },
          ),
        ),

        SizedBox(height: EcliniqTextStyles.getResponsiveSpacing(context, 32)),
      ],
    );
  }
}

class FileCategoryCard extends StatelessWidget {
  final FileCategory category;
  final int fileCount;

  const FileCategoryCard({
    super.key,
    required this.category,
    required this.fileCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        EcliniqRouter.push(FileTypeScreen(fileType: category.fileType));
      },
      child: Container(
        width: 168,
        height: 140,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset(category.backgroundImage, fit: BoxFit.cover),

              Positioned(
                top: 18,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style:
                          EcliniqTextStyles.responsiveHeadlineXMedium(
                            context,
                          ).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      '$fileCount ${fileCount == 1 ? 'File' : 'Files'}',
                      style: EcliniqTextStyles.responsiveBodySmall(context)
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 6,
                left: 6,
                right: 6,
                child: SizedBox(
                  width: 156,
                  height: 64,

                  child: SvgPicture.asset(
                    category.overlayImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
