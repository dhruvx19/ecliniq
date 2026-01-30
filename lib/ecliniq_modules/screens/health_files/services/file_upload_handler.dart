import 'dart:io';

import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:image_picker/image_picker.dart';
import '../../../../ecliniq_api/health_file_model.dart';
import 'local_file_storage_service.dart';


class FileUploadHandler {
  final ImagePicker _imagePicker = ImagePicker();
  final LocalFileStorageService _storageService = LocalFileStorageService();

  
  
  
  Future<String?> takePhoto() async {
    try {
      
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image == null) {
        return null;
      }

      
      return image.path;
    } catch (e) {
      throw Exception('Failed to take photo: ${e.toString()}');
    }
  }

  
  
  
  Future<String?> pickImageFromGallery() async {
    try {
      
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image == null) {
        return null;
      }

      
      return image.path;
    } catch (e) {
      throw Exception('Failed to pick image: ${e.toString()}');
    }
  }

  
  
  Future<Map<String, String>?> pickFile() async {
    try {
      
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

      
      return {
        'path': result.files.single.path!,
        'name': result.files.single.name,
      };
    } catch (e) {
      throw Exception('Failed to pick file: ${e.toString()}');
    }
  }

  
  
  Future<Map<String, String>?> handleUpload({
    required UploadSource source,
  }) async {
    switch (source) {
      case UploadSource.camera:
        final path = await takePhoto();
        if (path == null) return null;
        return {
          'path': path,
          'name': 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
        };
      case UploadSource.gallery:
        final path = await pickImageFromGallery();
        if (path == null) return null;
        final fileName = path.split('/').last;
        return {
          'path': path,
          'name': fileName.isEmpty 
              ? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg' 
              : fileName,
        };
      case UploadSource.files:
        return await pickFile();
    }
  }
}


enum UploadSource {
  camera,
  gallery,
  files,
}