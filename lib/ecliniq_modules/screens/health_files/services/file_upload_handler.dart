import 'dart:io';

import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/health_file_model.dart';
import 'local_file_storage_service.dart';

/// Custom exception for permission errors
class PermissionException implements Exception {
  final String message;
  final Permission permission;

  PermissionException(this.message, this.permission);

  @override
  String toString() => message;
}

/// Service for handling file uploads from camera, gallery, or file picker
class FileUploadHandler {
  final ImagePicker _imagePicker = ImagePicker();
  final LocalFileStorageService _storageService = LocalFileStorageService();

  /// Take a photo using camera
  Future<HealthFile?> takePhoto(HealthFileType fileType) async {
    try {
      // Check camera permission
      PermissionStatus cameraStatus = await Permission.camera.status;
      
      // If permission is denied, request it natively first
      if (cameraStatus.isDenied) {
        cameraStatus = await Permission.camera.request();
        if (cameraStatus.isDenied) {
          throw PermissionException(
            'Camera permission is required to take photos.',
            Permission.camera,
          );
        }
      }
      
      // If permission is permanently denied
      if (cameraStatus.isPermanentlyDenied) {
        throw PermissionException(
          'Camera permission is permanently denied. Please enable it in app settings.',
          Permission.camera,
        );
      }
      
      // If permission is not granted and not limited, deny access
      if (!cameraStatus.isGranted && !cameraStatus.isLimited) {
        throw PermissionException(
          'Camera permission is required to take photos.',
          Permission.camera,
        );
      }

      // Pick image from camera
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Compress to reduce file size
        maxWidth: 1920, // Limit width for optimization
        maxHeight: 1920, // Limit height for optimization
      );

      if (image == null) {
        return null;
      }

      // Save file
      final healthFile = await _storageService.saveFile(
        file: File(image.path),
        fileType: fileType,
        fileName: 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      return healthFile;
    } on PermissionException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to take photo: ${e.toString()}');
    }
  }

  /// Pick image from gallery
  Future<HealthFile?> pickImageFromGallery(HealthFileType fileType) async {
    try {
      // Check and request photo library permission
      // For iOS 14+, use photos, for Android use photos (Android 13+)
      Permission permission;
      if (Platform.isIOS) {
        permission = Permission.photos;
      } else {
        // For Android 13+ use photos, for older versions it may still work
        permission = Permission.photos;
      }
      
      PermissionStatus permissionStatus = await permission.status;
      
      // If permission is denied, request it natively first
      if (permissionStatus.isDenied) {
        permissionStatus = await permission.request();
        if (permissionStatus.isDenied) {
          throw PermissionException(
            'Gallery access is required to select photos.',
            permission,
          );
        }
      }
      
      // If permission is permanently denied
      if (permissionStatus.isPermanentlyDenied) {
        throw PermissionException(
          'Gallery access is permanently denied. Please enable it in app settings.',
          permission,
        );
      }
      
      // If permission is not granted and not limited, deny access
      if (!permissionStatus.isGranted && !permissionStatus.isLimited) {
        throw PermissionException(
          'Gallery access is required to select photos.',
          permission,
        );
      }

      // Pick image from gallery
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image == null) {
        return null;
      }

      // Save file
      final healthFile = await _storageService.saveFile(
        file: File(image.path),
        fileType: fileType,
        fileName: image.name.isEmpty 
            ? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg' 
            : image.name,
      );

      return healthFile;
    } on PermissionException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to pick image: ${e.toString()}');
    }
  }

  /// Pick file from device storage
  Future<HealthFile?> pickFile(HealthFileType fileType) async {
    try {
      // For Android 13+, use manageExternalStorage or use file picker directly
      // File picker on modern Android doesn't always need storage permission
      // but we'll check anyway for older versions
      if (Platform.isAndroid) {
        // Try storage permission first (for Android < 13)
        PermissionStatus storageStatus = await Permission.storage.status;
        
        if (storageStatus.isDenied) {
          storageStatus = await Permission.storage.request();
        }
        
        // If storage is permanently denied, try using file picker anyway
        // as it might work with scoped storage
        if (storageStatus.isPermanentlyDenied) {
          // Continue anyway, file picker might work
        } else if (!storageStatus.isGranted) {
          // Try photos permission as fallback for Android 13+
          PermissionStatus photosStatus = await Permission.photos.status;
          if (photosStatus.isDenied) {
            await Permission.photos.request();
          }
        }
      }

      // Pick file - file picker handles its own permissions on modern systems
      final result = await file_picker.FilePicker.platform.pickFiles(
        type: file_picker.FileType.custom,
        allowedExtensions: [
          'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', // Images
          'pdf', // Documents
          'doc', 'docx', // Word documents
        ],
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        return null;
      }

      final pickedFile = File(result.files.single.path!);

      // Save file
      final healthFile = await _storageService.saveFile(
        file: pickedFile,
        fileType: fileType,
        fileName: result.files.single.name,
      );

      return healthFile;
    } catch (e) {
      throw Exception('Failed to pick file: ${e.toString()}');
    }
  }

  /// Handle upload based on source type
  Future<HealthFile?> handleUpload({
    required UploadSource source,
    required HealthFileType fileType,
  }) async {
    switch (source) {
      case UploadSource.camera:
        return await takePhoto(fileType);
      case UploadSource.gallery:
        return await pickImageFromGallery(fileType);
      case UploadSource.files:
        return await pickFile(fileType);
    }
  }
}

/// Upload source types
enum UploadSource {
  camera,
  gallery,
  files,
}

