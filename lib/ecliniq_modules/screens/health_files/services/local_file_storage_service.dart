import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../ecliniq_api/health_file_model.dart';


class LocalFileStorageService {
  static const String _filesKey = 'health_files_list';
  static const String _filesDirectoryName = 'health_files';

  
  Future<Directory> getFilesDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final filesDir = Directory(path.join(appDir.path, _filesDirectoryName));
    
    if (!await filesDir.exists()) {
      await filesDir.create(recursive: true);
    }
    
    return filesDir;
  }

  
  
  
  
  
  
  
  Future<HealthFile> saveFile({
    required File file,
    required HealthFileType fileType,
    String? fileName,
  }) async {
    try {
      
      final fileId = DateTime.now().millisecondsSinceEpoch.toString();
      
      
      final originalName = fileName ?? path.basename(file.path);
      final fileExtension = path.extension(originalName);
      final mimeType = _getMimeType(fileExtension);
      
      
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final newFileName = '${fileType.name}_$timestamp$fileExtension';
      
      
      final filesDir = await getFilesDirectory();
      final targetFile = File(path.join(filesDir.path, newFileName));
      
      
      await file.copy(targetFile.path);
      
      
      final fileSize = await targetFile.length();
      
      
      final healthFile = HealthFile(
        id: fileId,
        fileName: originalName,
        filePath: targetFile.path,
        fileType: fileType,
        createdAt: DateTime.now(),
        fileSize: fileSize,
        mimeType: mimeType,
      );
      
      
      await _saveFileMetadata(healthFile);
      
      return healthFile;
    } catch (e) {
      throw Exception('Failed to save file: $e');
    }
  }

  
  Future<HealthFile> saveFileFromBytes({
    required List<int> bytes,
    required HealthFileType fileType,
    required String fileName,
    String? mimeType,
  }) async {
    try {
      final fileId = DateTime.now().millisecondsSinceEpoch.toString();
      
      
      final filesDir = await getFilesDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final fileExtension = path.extension(fileName);
      final newFileName = '${fileType.name}_$timestamp$fileExtension';
      final targetFile = File(path.join(filesDir.path, newFileName));
      
      
      await targetFile.writeAsBytes(bytes);
      
      
      final healthFile = HealthFile(
        id: fileId,
        fileName: fileName,
        filePath: targetFile.path,
        fileType: fileType,
        createdAt: DateTime.now(),
        fileSize: bytes.length,
        mimeType: mimeType ?? 'image/jpeg',
      );
      
      
      await _saveFileMetadata(healthFile);
      
      return healthFile;
    } catch (e) {
      throw Exception('Failed to save file from bytes: $e');
    }
  }

  
  Future<List<HealthFile>> getAllFiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filesJson = prefs.getString(_filesKey);
      
      if (filesJson == null || filesJson.isEmpty) {
        return [];
      }
      
      final List<dynamic> filesList = jsonDecode(filesJson);
      final files = filesList
          .map((json) => HealthFile.fromJson(json as Map<String, dynamic>))
          .toList();
      
      
      final existingFiles = <HealthFile>[];
      for (final file in files) {
        if (file.exists()) {
          existingFiles.add(file);
        } else {
          
          await _removeFileMetadata(file.id);
        }
      }
      
      
      if (existingFiles.length != files.length) {
        await _saveAllFilesMetadata(existingFiles);
      }
      
      return existingFiles;
    } catch (e) {
      return [];
    }
  }

  
  Future<List<HealthFile>> getFilesByType(HealthFileType fileType) async {
    final allFiles = await getAllFiles();
    return allFiles.where((file) => file.fileType == fileType).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); 
  }

  
  Future<int> getFileCountByType(HealthFileType fileType) async {
    final files = await getFilesByType(fileType);
    return files.length;
  }

  
  Future<bool> deleteFile(HealthFile healthFile) async {
    try {
      bool physicalFileDeleted = false;
      
      
      final file = File(healthFile.filePath);
      if (await file.exists()) {
        try {
          await file.delete();
          physicalFileDeleted = true;
        } catch (e) {
          
          
          
        }
      } else {
        
        physicalFileDeleted = true;
      }
      
      
      
      await _removeFileMetadata(healthFile.id);
      
      return true; 
    } catch (e) {
      
      return false;
    }
  }

  
  Future<List<HealthFile>> getRecentlyUploadedFiles({int limit = 10}) async {
    final allFiles = await getAllFiles();
    allFiles.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allFiles.take(limit).toList();
  }

  
  Future<void> saveFileMetadata(HealthFile healthFile) async {
    final allFiles = await getAllFiles();
    
    
    final existingIndex = allFiles.indexWhere((f) => f.id == healthFile.id);
    if (existingIndex != -1) {
      allFiles[existingIndex] = healthFile;
    } else {
      allFiles.add(healthFile);
    }
    
    await _saveAllFilesMetadata(allFiles);
  }
  
  
  @Deprecated('Use saveFileMetadata instead')
  Future<void> _saveFileMetadata(HealthFile healthFile) async {
    return saveFileMetadata(healthFile);
  }

  
  Future<void> _saveAllFilesMetadata(List<HealthFile> files) async {
    final prefs = await SharedPreferences.getInstance();
    final filesJson = jsonEncode(files.map((f) => f.toJson()).toList());
    await prefs.setString(_filesKey, filesJson);
  }

  
  Future<void> _removeFileMetadata(String fileId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filesJson = prefs.getString(_filesKey);
      
      if (filesJson == null || filesJson.isEmpty) {
        return;
      }
      
      final List<dynamic> filesList = jsonDecode(filesJson);
      final files = filesList
          .map((json) => HealthFile.fromJson(json as Map<String, dynamic>))
          .toList();
      
      
      files.removeWhere((f) => f.id == fileId);
      
      
      await _saveAllFilesMetadata(files);
    } catch (e) {
      
      rethrow;
    }
  }

  
  String? _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return null;
    }
  }

  
  Future<void> clearAllFiles() async {
    try {
      final filesDir = await getFilesDirectory();
      if (await filesDir.exists()) {
        await filesDir.delete(recursive: true);
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_filesKey);
    } catch (e) {
      
    }
  }
}

