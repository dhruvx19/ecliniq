import 'dart:io';

import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:image_picker/image_picker.dart';
import '../models/health_file_model.dart';
import 'local_file_storage_service.dart';

/// Service for handling file uploads from camera, gallery, or file picker
class FileUploadHandler {
  final ImagePicker _imagePicker = ImagePicker();
  final LocalFileStorageService _storageService = LocalFileStorageService();

  /// Take a photo using camera
  /// Note: Permission should be checked before calling this method
  Future<HealthFile?> takePhoto(HealthFileType fileType) async {
    try {
      // Pick image from camera
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
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
        fileName: 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      return healthFile;
    } catch (e) {
      throw Exception('Failed to take photo: ${e.toString()}');
    }
  }

  /// Pick image from gallery
  /// Note: Permission should be checked before calling this method
  Future<HealthFile?> pickImageFromGallery(HealthFileType fileType) async {
    try {
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
    } catch (e) {
      throw Exception('Failed to pick image: ${e.toString()}');
    }
  }

  /// Pick file from device storage
  Future<HealthFile?> pickFile(HealthFileType fileType) async {
    try {
      // File picker handles its own permissions on modern systems
      final result = await file_picker.FilePicker.platform.pickFiles(
        type: file_picker.FileType.custom,
        allowedExtensions: [
          'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic',
          'pdf',
          'doc', 'docx',
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