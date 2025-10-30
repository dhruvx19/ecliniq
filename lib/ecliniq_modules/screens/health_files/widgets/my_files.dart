import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class FileCategory {
  final String title;
  final int fileCount;
  final String backgroundImage;
  final String overlayImage;

  final String route;

  FileCategory({
    required this.title,
    required this.fileCount,
    required this.backgroundImage,
    required this.overlayImage,

    required this.route,
  });
}


class MyFilesWidget extends StatelessWidget {
  const MyFilesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      FileCategory(
        title: 'Lab Reports',
        fileCount: 15,
        backgroundImage: EcliniqIcons.blue.assetPath,
        overlayImage: EcliniqIcons.blueGradient.assetPath,

        route: '/lab-reports',
      ),
      FileCategory(
        title: 'Scan / Imaging',
        fileCount: 15,
        backgroundImage: EcliniqIcons.green.assetPath,
        overlayImage: EcliniqIcons.greenframe.assetPath,
        route: '/scan-imaging',
      ),
      FileCategory(
        title: 'Prescriptions',
        fileCount: 20,
        backgroundImage: EcliniqIcons.orange.assetPath,
        overlayImage: EcliniqIcons.orangeframe.assetPath,
        route: '/prescriptions',
      ),
      FileCategory(
        title: 'Invoices',
        fileCount: 8,
        backgroundImage: EcliniqIcons.yellow.assetPath,
        overlayImage: EcliniqIcons.yellowframe.assetPath,
        route: '/medical-records',
      ),
      FileCategory(
        title: 'Vaccinations',
        fileCount: 8,
        backgroundImage: EcliniqIcons.blueDark.assetPath,
        overlayImage: EcliniqIcons.blueDarkframe.assetPath,
        route: '/medical-records',
      ),
      FileCategory(
        title: 'Others',
        fileCount: 8,
        backgroundImage: EcliniqIcons.red.assetPath,
        overlayImage: EcliniqIcons.redframe.assetPath,
        route: '/medical-records',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [



          const Text(
            'My Files',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff424242),
            ),
          ),
          const SizedBox(height: 16),


          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return FileCategoryCard(category: categories[index]);
              },
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}


class FileCategoryCard extends StatelessWidget {
  final FileCategory category;

  const FileCategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, category.route);
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
         
              Positioned.fill(
                child: SvgPicture.asset(
                  category.backgroundImage,
                  fit: BoxFit.cover,
                ),
              ),


              Positioned(
                top: 22,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category.fileCount} Files',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),


              Positioned(
                bottom: 8,
                left: 8,

                child: Stack(
                  children: [

                    SvgPicture.asset(
                      category.overlayImage,
                      width: double.infinity,
                      height: 76,
                      fit: BoxFit.fitHeight,
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


class LabReportsScreen extends StatelessWidget {
  const LabReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Reports'),
        backgroundColor: const Color(0xFF2B7FFF),
      ),
      body: const Center(child: Text('Lab Reports - 15 Files')),
    );
  }
}
