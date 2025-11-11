import 'package:flutter/foundation.dart';
import '../models/health_file_model.dart';
import '../services/local_file_storage_service.dart';

/// Provider for managing health files state
class HealthFilesProvider extends ChangeNotifier {
  final LocalFileStorageService _storageService = LocalFileStorageService();
  
  List<HealthFile> _allFiles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<HealthFile> get allFiles => _allFiles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize and load all files
  Future<void> loadFiles() async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      _allFiles = await _storageService.getAllFiles();
      _allFiles.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load files: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Get files by type
  List<HealthFile> getFilesByType(HealthFileType fileType) {
    return _allFiles
        .where((file) => file.fileType == fileType)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get file count by type
  int getFileCountByType(HealthFileType fileType) {
    return getFilesByType(fileType).length;
  }

  /// Get recently uploaded files
  List<HealthFile> getRecentlyUploadedFiles({int limit = 10}) {
    return _allFiles.take(limit).toList();
  }

  /// Add a new file
  Future<bool> addFile(HealthFile file) async {
    try {
      // Save to storage
      await _storageService.saveFileMetadata(file);
      
      // Reload to get fresh data
      await loadFiles();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add file: $e';
      notifyListeners();
      return false;
    }
  }
  
  /// Update an existing file
  Future<bool> updateFile(HealthFile file) async {
    try {
      // Save updated metadata to storage
      await _storageService.saveFileMetadata(file);
      
      // Reload to get fresh data
      await loadFiles();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update file: $e';
      notifyListeners();
      return false;
    }
  }

  /// Delete a file
  Future<bool> deleteFile(HealthFile file) async {
    try {
      final success = await _storageService.deleteFile(file);
      if (success) {
        _allFiles.removeWhere((f) => f.id == file.id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete file: $e';
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Refresh files from storage
  Future<void> refresh() async {
    await loadFiles();
  }
}

