import 'dart:io';
import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/models/health_file_model.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/providers/health_files_provider.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/services/file_upload_handler.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/file_type_picker_dialog.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/widgets/upload_bottom_sheet.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:ecliniq/ecliniq_ui/scripts/ecliniq_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

/// Screen displaying files by category/type
class FileTypeScreen extends StatefulWidget {
  final HealthFileType fileType;

  const FileTypeScreen({
    super.key,
    required this.fileType,
  });

  @override
  State<FileTypeScreen> createState() => _FileTypeScreenState();
}

class _FileTypeScreenState extends State<FileTypeScreen> {
  final FileUploadHandler _uploadHandler = FileUploadHandler();

  @override
  void initState() {
    super.initState();
    // Load files when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthFilesProvider>().loadFiles();
    });
  }

  void _showUploadBottomSheet() {
    EcliniqBottomSheet.show(
      context: context,
      child: UploadBottomSheet(
        onFileUploaded: () {
          // Refresh files after upload
          context.read<HealthFilesProvider>().refresh();
        },
      ),
    );
  }

  Future<void> _handleFileDelete(HealthFile file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Are you sure you want to delete "${file.fileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final provider = context.read<HealthFilesProvider>();
      final success = await provider.deleteFile(file);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'File deleted' : 'Failed to delete file'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  String _getBackgroundImage() {
    switch (widget.fileType) {
      case HealthFileType.labReports:
        return EcliniqIcons.blue.assetPath;
      case HealthFileType.scanImaging:
        return EcliniqIcons.green.assetPath;
      case HealthFileType.prescriptions:
        return EcliniqIcons.orange.assetPath;
      case HealthFileType.invoices:
        return EcliniqIcons.yellow.assetPath;
      case HealthFileType.vaccinations:
        return EcliniqIcons.blueDark.assetPath;
      case HealthFileType.others:
        return EcliniqIcons.red.assetPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return EcliniqScaffold(
      backgroundColor: EcliniqScaffold.primaryBlue,
      body: SizedBox.expand(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // App bar
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.fileType.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 28),
                    onPressed: _showUploadBottomSheet,
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Consumer<HealthFilesProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final files = provider.getFilesByType(widget.fileType);

                    if (files.isEmpty) {
                      return _buildEmptyState();
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        return _FileCard(
                          file: files[index],
                          backgroundImage: _getBackgroundImage(),
                          onDelete: () => _handleFileDelete(files[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            _getBackgroundImage(),
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 24),
          Text(
            'No ${widget.fileType.displayName} yet',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload your first file to get started',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showUploadBottomSheet,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: EcliniqScaffold.darkBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _FileCard extends StatelessWidget {
  final HealthFile file;
  final String backgroundImage;
  final VoidCallback onDelete;

  const _FileCard({
    required this.file,
    required this.backgroundImage,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Open file viewer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _FileViewerScreen(file: file),
          ),
        );
      },
      onLongPress: () {
        // Show delete option
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('File Options'),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image preview
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey.shade100,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: file.isImage && File(file.filePath).existsSync()
                      ? Image.file(
                          File(file.filePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                        )
                      : _buildPlaceholder(),
                ),
              ),
            ),
            // File info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(file.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8E8E8E),
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

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: SvgPicture.asset(
          backgroundImage,
          width: 60,
          height: 60,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
              child: InteractiveViewer(
                child: Image.file(File(file.filePath)),
              ),
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

