import 'dart:io';

import 'package:ecliniq/ecliniq_core/media/media_permission_manager.dart';
import 'package:ecliniq/ecliniq_core/router/navigation_helper.dart';
import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/models/health_file_model.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/providers/health_files_provider.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/custom_refresh_indicator.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/my_files.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/prescription_card_list.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/recently_uploaded.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/upload_bottom_sheet.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/upload_timeline.dart';
import 'package:ecliniq/ecliniq_modules/screens/notifications/notification_screen.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_navigation/bottom_navigation.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:ecliniq/ecliniq_utils/widgets/ecliniq_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../ecliniq_icons/assets/home/widgets/top_bar_widgets/search_bar.dart';

class HealthFiles extends StatefulWidget {
  const HealthFiles({super.key});

  @override
  State<HealthFiles> createState() => _HealthFilesState();
}

class _HealthFilesState extends State<HealthFiles> {
  static const int _currentIndex = 2;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load files when page loads
    // NOTE: We don't request permissions upfront on iOS to avoid them becoming permanently denied
    // Permissions will be requested when user actually tries to upload (handled in upload_bottom_sheet.dart)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthFilesProvider>().loadFiles();
    });
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (error) => setState(() => _isListening = false),
      onStatus: (status) {
        if (status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
    );
    if (mounted) {
      setState(() {});
    }
  }

  void _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(onResult: _onSpeechResult);
      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _searchController.text = result.recognizedWords;
      _onSearch(result.recognizedWords);

      if (result.finalResult) {
        _isListening = false;
      }
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    context.read<HealthFilesProvider>().searchFiles(query);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _speechToText.cancel();
    super.dispose();
  }

  void _onTabTapped(int index) {
    // Don't navigate if already on the same tab
    if (index == _currentIndex) {
      return;
    }

    // Navigate using the navigation helper with smooth left-to-right transitions
    NavigationHelper.navigateToTab(context, index, _currentIndex);
  }

  void _showUploadBottomSheet(BuildContext context) {
    EcliniqBottomSheet.show(
      context: context,
      child: UploadBottomSheet(
        onFileUploaded: () async {
          // Refresh files after upload - ensure UI updates immediately
          if (mounted) {
            final provider = context.read<HealthFilesProvider>();
            // Force refresh to reload files from storage
            await provider.refresh();
            // Ensure listeners are notified
            if (mounted) {
              provider.notifyListeners();
            }
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(EcliniqIcons.nofiles.assetPath),
          const SizedBox(height: 12),
          Text(
            'No Documents Uploaded Yet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xff424242),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Click upload button to maintain your health files',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xff8E8E8E),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<HealthFilesProvider>(
      builder: (context, provider, child) {
        final files = provider.searchResults;

        if (files.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  EcliniqIcons.healthfile.assetPath,
                  height: 120,
                  width: 120,
                  colorFilter: ColorFilter.mode(
                    Colors.grey.shade300,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No files found for "$_searchQuery"',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: files.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return PrescriptionCardList(
              file: files[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _FileViewerScreen(file: files[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Consumer<HealthFilesProvider>(
      builder: (context, provider, child) {
        // Show normal content with files directly
        return CustomRefreshIndicator(
          onRefresh: () async {
            await context.read<HealthFilesProvider>().refresh();
          },
          color: const Color(0xFF2372EC),
          backgroundColor: Colors.white,
          displacement: 40,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const MyFilesWidget(),
                if (provider.allFiles.isEmpty) _buildEmptyState(),
                const RecentlyUploadedWidget(),
                const UploadTimeline(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        EcliniqScaffold(
          backgroundColor: EcliniqScaffold.primaryBlue,
          body: SizedBox.expand(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 20,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        EcliniqIcons.nameLogo.assetPath,
                        height: 28,
                        width: 140,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          EcliniqRouter.push(NotificationScreen());
                        },
                        child: SvgPicture.asset(
                          EcliniqIcons.notificationBell.assetPath,
                          height: 32,
                          width: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 18),
                              SearchBarWidget(
                                onSearch: (String value) {},
                                hintText: 'Search File',
                              ),
                              if (_isListening)
                                const LinearProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue,
                                  ),
                                ),
                              Expanded(
                                child: _searchQuery.isNotEmpty
                                    ? _buildSearchResults()
                                    : _buildMainContent(),
                              ),
                            ],
                          ),
                        ),
                        EcliniqBottomNavigationBar(
                          currentIndex: _currentIndex,
                          onTap: _onTabTapped,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          right: 20,
          bottom: 120,
          child: GestureDetector(
            onTap: () => _showUploadBottomSheet(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: EcliniqScaffold.darkBlue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    EcliniqIcons.upload.assetPath,
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 4),

                  Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FileViewerScreen extends StatelessWidget {
  final HealthFile file;

  const _FileViewerScreen({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(file.fileName),
        backgroundColor: EcliniqScaffold.primaryBlue,
      ),
      body: file.isImage && File(file.filePath).existsSync()
          ? Center(
              child: InteractiveViewer(child: Image.file(File(file.filePath))),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.description, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'File: ${file.fileName}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Size: ${_formatFileSize(file.fileSize)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
