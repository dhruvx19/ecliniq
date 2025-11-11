import 'dart:io';
import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/edit_doc_details.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/models/health_file_model.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/services/file_upload_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadBottomSheet extends StatefulWidget {
  final Function()? onFileUploaded;

  const UploadBottomSheet({
    super.key,
    this.onFileUploaded,
  });

  @override
  State<UploadBottomSheet> createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<UploadBottomSheet> {
  final FileUploadHandler _uploadHandler = FileUploadHandler();
  bool _isUploading = false;

  Future<void> _handleUpload(UploadSource source) async {
    // Capture the parent context before closing the bottom sheet
    // This ensures we can show dialogs and navigate after the bottom sheet is closed
    final parentContext = Navigator.of(context, rootNavigator: true).context;
    
    // Close upload bottom sheet first
    if (mounted) {
      Navigator.pop(context);
    }

    // Determine which permission is needed
    Permission? requiredPermission;
    String permissionTitle = 'Permission Required';
    String permissionMessage = 'Permission is required to continue.';

    switch (source) {
      case UploadSource.camera:
        requiredPermission = Permission.camera;
        permissionTitle = 'Camera Permission';
        permissionMessage = 'We need access to your camera to take photos of your health documents.';
        break;
      case UploadSource.gallery:
        requiredPermission = Platform.isIOS ? Permission.photos : Permission.photos;
        permissionTitle = 'Photo Library Access';
        permissionMessage = 'We need access to your photo library to select health documents and images.';
        break;
      case UploadSource.files:
        // File picker handles its own permissions on modern systems
        // For older Android, we may need storage permission
        if (Platform.isAndroid) {
          requiredPermission = Permission.storage;
          permissionTitle = 'Storage Access';
          permissionMessage = 'We need access to your device storage to select health documents.';
        }
        break;
    }

    // Request permission natively first (like location permissions)
    if (requiredPermission != null) {
      PermissionStatus permissionStatus = await requiredPermission.status;
      
      // If permission is denied (not permanently), request it natively first
      if (permissionStatus.isDenied) {
        // Request permission natively - this shows the OS permission dialog
        permissionStatus = await requiredPermission.request();
        
        // If still denied after native request, check if permanently denied
        if (permissionStatus.isDenied) {
          // Re-check status to see if it's now permanently denied
          permissionStatus = await requiredPermission.status;
          if (permissionStatus.isPermanentlyDenied) {
            _showPermissionDeniedDialog(parentContext, permissionTitle, permissionMessage);
          } else {
            ScaffoldMessenger.of(parentContext).showSnackBar(
              SnackBar(
                content: Text('$permissionTitle denied. Please enable it to continue.'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
          return;
        }
      }
      
      // If permission is permanently denied, show settings dialog
      if (permissionStatus.isPermanentlyDenied) {
        _showPermissionDeniedDialog(parentContext, permissionTitle, permissionMessage);
        return;
      }
      
      // If permission is limited (iOS 14+), that's acceptable
      if (!permissionStatus.isGranted && !permissionStatus.isLimited) {
        _showPermissionDeniedDialog(parentContext, permissionTitle, permissionMessage);
        return;
      }
    }

    // Show loading indicator using parent context
    BuildContext? loadingDialogContext;
    try {
      showDialog(
        context: parentContext,
        barrierDismissible: false,
        builder: (dialogContext) {
          loadingDialogContext = dialogContext;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    } catch (e) {
      // Context might be invalid, skip showing dialog
      print('Failed to show loading dialog: $e');
    }

    try {
      if (mounted) {
        setState(() => _isUploading = true);
      }

      // Upload file with default type (will be changed in edit screen)
      final healthFile = await _uploadHandler.handleUpload(
        source: source,
        fileType: HealthFileType.others, // Default type, user will change in edit screen
      );

      // Close loading dialog if it was shown
      if (loadingDialogContext != null) {
        try {
          Navigator.of(loadingDialogContext!, rootNavigator: true).pop();
        } catch (e) {
          // Dialog might already be closed, ignore
        }
      }

      if (healthFile != null) {
        // Navigate directly to edit document details page
        final updatedFile = await EcliniqRouter.push<HealthFile>(
          EditDocumentDetailsPage(healthFile: healthFile),
        );
        
        // If file was updated, notify parent to refresh
        if (updatedFile != null) {
          widget.onFileUploaded?.call();
        }
      } else {
        // User cancelled - show message using parent context
        ScaffoldMessenger.of(parentContext).showSnackBar(
          const SnackBar(
            content: Text('Upload cancelled'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } on PermissionException catch (e) {
      // Close loading dialog if it was shown
      if (loadingDialogContext != null) {
        try {
          Navigator.of(loadingDialogContext!, rootNavigator: true).pop();
        } catch (e) {
          // Dialog might already be closed, ignore
        }
      }
      
      // Show permission denied dialog with option to open settings
      _showPermissionDeniedDialog(parentContext, e.message, '');
    } catch (e) {
      // Close loading dialog if it was shown
      if (loadingDialogContext != null) {
        try {
          Navigator.of(loadingDialogContext!, rootNavigator: true).pop();
        } catch (e) {
          // Dialog might already be closed, ignore
        }
      }

      // Show error message
      ScaffoldMessenger.of(parentContext).showSnackBar(
        SnackBar(
          content: Text('Failed to upload file: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }


  void _showPermissionDeniedDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        content: Text(
          message.isEmpty 
              ? 'Permission is permanently denied. Please enable it in app settings to continue.'
              : '$message\n\nPermission is permanently denied. Please enable it in app settings to continue.',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF8E8E8E),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF424242),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2372EC),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Open Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload From',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 24),

          _ActionOption(
            icon: EcliniqIcons.camera,
            backgroundColor: const Color(0xFFE3F2FD),
            title: 'Take a Photo',
            onTap: () => _handleUpload(UploadSource.camera),
            enabled: !_isUploading,
          ),

          const SizedBox(height: 16),

          _ActionOption(
            icon: EcliniqIcons.gallery,
            backgroundColor: const Color(0xFFE3F2FD),
            title: 'Gallery',
            onTap: () => _handleUpload(UploadSource.gallery),
            enabled: !_isUploading,
          ),

          const SizedBox(height: 16),

          _ActionOption(
            icon: EcliniqIcons.fileSend,
            backgroundColor: const Color(0xFFFFEBEE),
            title: 'Files',
            isDestructive: true,
            onTap: () => _handleUpload(UploadSource.files),
            enabled: !_isUploading,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ActionOption extends StatelessWidget {
  final EcliniqIcons icon;
  final Color backgroundColor;
  final String title;
  final bool isDestructive;
  final VoidCallback onTap;
  final bool enabled;

  const _ActionOption({
    required this.icon,
    required this.backgroundColor,
    required this.title,
    this.isDestructive = false,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon.assetPath,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF424242),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
