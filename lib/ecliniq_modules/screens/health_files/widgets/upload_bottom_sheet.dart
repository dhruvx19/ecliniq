import 'dart:io';

import 'package:ecliniq/ecliniq_core/media/media_permission_manager.dart';
import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/edit_doc_details.dart';
import 'package:ecliniq/ecliniq_api/health_file_model.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/services/file_upload_handler.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:ecliniq/ecliniq_utils/widgets/ecliniq_loader.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadBottomSheet extends StatefulWidget {
  final Future<void> Function()? onFileUploaded;

  const UploadBottomSheet({super.key, this.onFileUploaded});

  @override
  State<UploadBottomSheet> createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<UploadBottomSheet> with WidgetsBindingObserver {
  final FileUploadHandler _uploadHandler = FileUploadHandler();
  bool _isUploading = false;
  BuildContext? _storedParentContext;
  UploadSource? _pendingUploadSource;

  Future<void> _handleUpload(UploadSource source) async {
    if (!mounted) return;

    _storedParentContext = context;

    if (mounted) {
      Navigator.pop(context);
    }

    await Future.delayed(const Duration(milliseconds: 300));

    final safeContext = _storedParentContext;
    if (safeContext == null) return;

    
    if (!kIsWeb) {
      Permission? requiredPermission;
      String permissionTitle = 'Permission Required';
      String permissionMessage = '';

      switch (source) {
        case UploadSource.camera:
          requiredPermission = Permission.camera;
          permissionTitle = 'Camera Permission';
          permissionMessage =
              'We need access to your camera to take photos of your health documents';
          break;
        case UploadSource.gallery:
          requiredPermission = Permission.photos;
          permissionTitle = 'Photo Library Access';
          permissionMessage =
              'We need access to your photo library to select health documents and images';
          break;
        case UploadSource.files:
          
          break;
      }

      
      
      if (requiredPermission != null) {
        try {
          
          final permissionResult = await MediaPermissionManager.getPermissionStatus(requiredPermission);
          
          if (permissionResult == MediaPermissionResult.permanentlyDenied) {
            
            _pendingUploadSource = source;
            _showPermissionDeniedDialog(
              safeContext,
              permissionTitle,
              permissionMessage,
              source: source,
            );
            return;
          }
          
          
          
          
        } catch (e) {
          
          
        }
      }
    }

    
    _proceedWithUpload(source);
  }

  
  Future<void> _proceedWithUpload(UploadSource source) async {
    final safeContext = _storedParentContext;
    if (safeContext == null || !mounted) return;
    BuildContext? loadingDialogContext;

    try {
      
      showDialog(
        context: safeContext,
        barrierDismissible: false,
        builder: (dialogContext) {
          loadingDialogContext = dialogContext;
          return PopScope(
            canPop: false,
            child: const Center(
              child: EcliniqLoader(size: 32, color: Color(0xFF2372EC)),
            ),
          );
        },
      );

      if (mounted) {
        setState(() => _isUploading = true);
      }

      
      Map<String, String>? fileData;
      try {
        fileData = await _uploadHandler.handleUpload(
          source: source,
        );
      } catch (e) {
        
        if (!kIsWeb && Platform.isIOS && e.toString().contains('permission')) {
          String iosPermissionTitle = '';
          String iosPermissionMessage = '';

          switch (source) {
            case UploadSource.camera:
              iosPermissionTitle = 'Camera Permission';
              iosPermissionMessage =
                  'We need access to your camera to take photos of your health documents';
              break;
            case UploadSource.gallery:
              iosPermissionTitle = 'Photo Library Access';
              iosPermissionMessage =
                  'We need access to your photo library to select health documents and images';
              break;
            default:
              break;
          }

          
          _closeLoadingDialog(loadingDialogContext, safeContext);
          loadingDialogContext = null;

          
          if (source == UploadSource.camera || source == UploadSource.gallery) {
            Permission permission = source == UploadSource.camera
                ? Permission.camera
                : Permission.photos;

            final permissionResult = await MediaPermissionManager.getPermissionStatus(permission);

            
            
            if (permissionResult == MediaPermissionResult.permanentlyDenied ||
                (Platform.isIOS && permissionResult == MediaPermissionResult.denied)) {
              _pendingUploadSource = source;
              _showPermissionDeniedDialog(
                safeContext,
                iosPermissionTitle,
                iosPermissionMessage,
                source: source,
              );
            } else {
              
              ScaffoldMessenger.of(safeContext).showSnackBar(
                SnackBar(
                  content: Text('$iosPermissionTitle is required to continue'),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () {
                      if (_storedParentContext != null) {
                        _handleUpload(source);
                      }
                    },
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(safeContext).showSnackBar(
              SnackBar(
                content: Text('Failed to access: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          return;
        }
        rethrow;
      }

      
      _closeLoadingDialog(loadingDialogContext, safeContext);
      loadingDialogContext = null;
      await Future.delayed(const Duration(milliseconds: 200));

      if (fileData != null && fileData['path'] != null) {
        if (mounted) {
          setState(() => _isUploading = false);
        }

        await Future.delayed(const Duration(milliseconds: 100));

        
        
        
        try {
          final savedFile = await EcliniqRouter.push<HealthFile>(
            EditDocumentDetailsPage(
              filePath: fileData['path']!,
              fileName: fileData['name'] ?? 'file',
            ),
          );

          
          if (savedFile != null && widget.onFileUploaded != null) {
            await widget.onFileUploaded!();
          }
        } catch (e) {
          
          
          if (safeContext != null && mounted) {
            try {
              final savedFile = await Navigator.of(safeContext, rootNavigator: true)
                  .push<HealthFile>(
                    MaterialPageRoute(
                      builder: (context) => EditDocumentDetailsPage(
                        filePath: fileData?['path']!,
                        fileName: fileData?['name'] ?? 'file',
                      ),
                    ),
                  );

              
              if (savedFile != null && widget.onFileUploaded != null) {
                await widget.onFileUploaded!();
              }
            } catch (e2) {
              
            }
          }
        }
      } else {
        
        if (mounted) {
          setState(() => _isUploading = false);
          ScaffoldMessenger.of(safeContext).showSnackBar(
            const SnackBar(
              content: Text('Upload cancelled'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      _closeLoadingDialog(loadingDialogContext, safeContext);
      loadingDialogContext = null;

      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(safeContext).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }

      _closeLoadingDialog(loadingDialogContext, safeContext);
      loadingDialogContext = null;
      _storedParentContext = null;
    }
  }

  
  void _closeLoadingDialog(
    BuildContext? dialogContext,
    BuildContext fallbackContext,
  ) {
    if (dialogContext == null) return;

    try {
      Navigator.of(dialogContext, rootNavigator: true).pop();
    } catch (_) {
      try {
        if (Navigator.of(fallbackContext, rootNavigator: true).canPop()) {
          Navigator.of(fallbackContext, rootNavigator: true).pop();
        }
      } catch (_) {}
    }
  }

  void _showPermissionDeniedDialog(
    BuildContext context,
    String title,
    String message, {
    UploadSource? source,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style:  EcliniqTextStyles.responsiveHeadlineLarge(context).copyWith(
  
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        content: Text(
          message.isEmpty
              ? Platform.isIOS
                  ? 'Permission is required. Please enable it in Settings > Ecliniq to continue.'
                  : 'Permission is permanently denied. Please enable it in app settings to continue.'
              : Platform.isIOS
                  ? '$message\n\nPlease enable this permission in Settings > Ecliniq to continue.'
                  : '$message\n\nPermission is permanently denied. Please enable it in app settings to continue.',
          style:  EcliniqTextStyles.responsiveTitleXLarge(context).copyWith(
           
            color: Color(0xFF8E8E8E),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child:  Text(
              'Cancel',
              style: EcliniqTextStyles.responsiveTitleXLarge(context).copyWith(
             
                fontWeight: FontWeight.w500,
                color: Color(0xFF424242),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              
              if (source != null) {
                _pendingUploadSource = source;
              }
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
            child:  Text(
              'Open Settings',
              style: EcliniqTextStyles.responsiveTitleXLarge(context).copyWith( fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _storedParentContext = null;
    _pendingUploadSource = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed && _pendingUploadSource != null) {
      _checkPermissionAndProceed(_pendingUploadSource!);
    }
  }

  
  Future<void> _checkPermissionAndProceed(UploadSource source) async {
    if (!mounted || _storedParentContext == null) return;

    final safeContext = _storedParentContext!;
    Permission? requiredPermission;

    if (source == UploadSource.camera) {
      requiredPermission = Permission.camera;
    } else if (source == UploadSource.gallery) {
      requiredPermission = Permission.photos;
    } else {
      
      _pendingUploadSource = null;
      _proceedWithUpload(source);
      return;
    }

    if (requiredPermission != null) {
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      
      final permissionResult = await MediaPermissionManager.getPermissionStatus(requiredPermission);
      if (permissionResult == MediaPermissionResult.granted) {
        
        _pendingUploadSource = null;
        _proceedWithUpload(source);
      } else {
        
        _pendingUploadSource = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            EcliniqTextStyles.getResponsiveBorderRadius(context, 20),
          ),
          bottom: Radius.circular(
            EcliniqTextStyles.getResponsiveBorderRadius(context, 16),
          ),
        ),
      ),
      width: double.infinity,
      padding: EcliniqTextStyles.getResponsiveEdgeInsetsAll(context, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Upload From',
            style: EcliniqTextStyles.responsiveHeadlineBMedium(context).copyWith(
        
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
          ),
          SizedBox(height: EcliniqTextStyles.getResponsiveSpacing(context, 24)),
          _ActionOption(
            icon: EcliniqIcons.camera,
            backgroundColor: const Color(0xFFE3F2FD),
            title: 'Take a Photo',
            onTap: () => _handleUpload(UploadSource.camera),
            enabled: !_isUploading,
          ),
          SizedBox(height: EcliniqTextStyles.getResponsiveSpacing(context, 16)),
          _ActionOption(
            icon: EcliniqIcons.gallery,
            backgroundColor: const Color(0xFFE3F2FD),
            title: 'Gallery',
            onTap: () => _handleUpload(UploadSource.gallery),
            enabled: !_isUploading,
          ),
          SizedBox(height: EcliniqTextStyles.getResponsiveSpacing(context, 16)),
          _ActionOption(
            icon: EcliniqIcons.fileSend,
            backgroundColor: const Color(0xFFFFEBEE),
            title: 'Files',
            isDestructive: true,
            onTap: () => _handleUpload(UploadSource.files),
            enabled: !_isUploading,
          ),
          SizedBox(height: EcliniqTextStyles.getResponsiveSpacing(context, 16)),
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
        borderRadius: BorderRadius.circular(
          EcliniqTextStyles.getResponsiveBorderRadius(context, 12),
        ),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Container(
            padding: EcliniqTextStyles.getResponsiveEdgeInsetsSymmetric(
              context,
              horizontal: 4,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                EcliniqTextStyles.getResponsiveBorderRadius(context, 12),
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon.assetPath,
                  width: EcliniqTextStyles.getResponsiveIconSize(context, 24),
                  height: EcliniqTextStyles.getResponsiveIconSize(context, 24),
                ),
                SizedBox(width: EcliniqTextStyles.getResponsiveSpacing(context, 16)),
                Expanded(
                  child: Text(
                    title,
                    style:  EcliniqTextStyles.responsiveHeadlineBMedium(context).copyWith(
                 
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF424242),
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