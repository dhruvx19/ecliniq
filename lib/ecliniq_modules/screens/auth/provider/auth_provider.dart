
import 'dart:io';
import 'dart:typed_data';
import 'package:ecliniq/ecliniq_api/auth_service.dart';
import 'package:ecliniq/ecliniq_api/models/upload.dart';
import 'package:ecliniq/ecliniq_api/src/upload_service.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UploadService _uploadService = UploadService();

  bool _isLoading = false;
  bool _isUploadingImage = false;
  bool _isSavingDetails = false;
  String? _errorMessage;
  String? _challengeId;
  String? _phoneNumber;
  String? _authToken;
  String? _userId;
  String? _profilePhotoKey;

  bool get isLoading => _isLoading;
  bool get isUploadingImage => _isUploadingImage;
  bool get isSavingDetails => _isSavingDetails;
  String? get errorMessage => _errorMessage;
  String? get challengeId => _challengeId;
  String? get phoneNumber => _phoneNumber;
  String? get authToken => _authToken;
  String? get userId => _userId;
  String? get profilePhotoKey => _profilePhotoKey;
  bool get isAuthenticated => _authToken != null;


  Future<void> initialize() async {
    await _loadSavedToken();
  }

  Future<bool> loginOrRegisterUser(String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.loginOrRegisterUser(phone);
      _isLoading = false;

      if (result['success']) {
        _challengeId = result['challengeId'];
        _phoneNumber = phone;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOTP(String otp) async {
    if (_challengeId == null || _phoneNumber == null) {
      _errorMessage = 'Session expired. Please try again.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.verifyOTP(
        _challengeId!,
        _phoneNumber!,
        otp,
      );
      _isLoading = false;

      if (result.success) {

        if (result.data != null) {
          print('🔍 Parsing successful OTP response data:');
          print('📥 Full response: ${result.data}');
          
          try {

            if (result.data!['data'] != null && result.data!['data']['token'] != null) {
              _authToken = result.data!['data']['token'];
              print('✅ Token extracted: ${_authToken?.substring(0, 20)}...');
            } else if (result.data!['token'] != null) {
              _authToken = result.data!['token'];
              print('✅ Token extracted from root: ${_authToken?.substring(0, 20)}...');
            }
            

            if (result.data!['userId'] != null) {
              _userId = result.data!['userId'];
              print('✅ User ID extracted: $_userId');
            } else if (result.data!['data'] != null && result.data!['data']['userId'] != null) {
              _userId = result.data!['data']['userId'];
              print('✅ User ID extracted from data: $_userId');
            }


            if (_authToken != null) {
              await _saveToken(_authToken!, _userId);
              print('✅ Token saved to secure storage');
            } else {
              print('⚠️ No token found in response');
            }
          } catch (e) {
            print('❌ Error parsing response data: $e');
            _errorMessage = 'Failed to parse authentication data';
            _isLoading = false;
            notifyListeners();
            return false;
          }
        } else {
          print('⚠️ Response data is null');
          _errorMessage = 'Invalid response from server';
          _isLoading = false;
          notifyListeners();
          return false;
        }

        notifyListeners();
        return true;
      } else {
        _errorMessage = result.message ?? 'Verification failed';
        print('❌ OTP verification failed: $_errorMessage');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }


  Future<bool> resendOTP() async {
    if (_phoneNumber == null) {
      _errorMessage = 'Phone number not found. Please start over.';
      notifyListeners();
      return false;
    }

    return await loginOrRegisterUser(_phoneNumber!);
  }


  Future<String?> uploadProfileImage(File imageFile) async {
    if (_authToken == null) {
      _errorMessage = 'Authentication required';
      notifyListeners();
      return null;
    }

    _isUploadingImage = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('📤 Starting upload in AuthProvider...');
      final imageKey = await _uploadService.uploadImageComplete(
        authToken: _authToken!,
        imageFile: imageFile,
      );

      if (imageKey != null) {
        print('✅ Image key received: $imageKey');
        _profilePhotoKey = imageKey;
        _isUploadingImage = false;
        notifyListeners();
        return imageKey;
      } else {
        print('⚠️ Image key is null');
        _errorMessage = 'Failed to upload image';
        _isUploadingImage = false;
        notifyListeners();
        return null;
      }
    } catch (e, stackTrace) {
      print('❌ Exception in uploadProfileImage: $e');
      print('❌ Stack trace: $stackTrace');
      _errorMessage = 'Image upload failed: ${e.toString()}';
      _isUploadingImage = false;
      notifyListeners();
      return null;
    }
  }


  Future<String?> uploadProfileImageBytes({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    if (_authToken == null) {
      _errorMessage = 'Authentication required';
      notifyListeners();
      return null;
    }

    _isUploadingImage = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final imageKey = await _uploadService.uploadImageBytesComplete(
        authToken: _authToken!,
        imageBytes: imageBytes,
        fileName: fileName,
      );

      if (imageKey != null) {
        _profilePhotoKey = imageKey;
        _isUploadingImage = false;
        notifyListeners();
        return imageKey;
      } else {
        _errorMessage = 'Failed to upload image';
        _isUploadingImage = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Image upload failed: ${e.toString()}';
      _isUploadingImage = false;
      notifyListeners();
      return null;
    }
  }


  Future<bool> savePatientDetails({
    required String firstName,
    required String lastName,
    required String dob,
    required String gender,
  }) async {
    if (_authToken == null) {
      _errorMessage = 'Authentication required';
      notifyListeners();
      return false;
    }

    _isSavingDetails = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('📤 Saving patient details with profilePhotoKey: $_profilePhotoKey');
      
      final request = PatientDetailsRequest(
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        gender: gender,
        profilePhoto: _profilePhotoKey,
      );

      final response = await _uploadService.savePatientDetails(
        authToken: _authToken!,
        request: request,
      );

      _isSavingDetails = false;

      if (response.success) {

        _profilePhotoKey = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isSavingDetails = false;
      _errorMessage = 'Failed to save details: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }


  void clearProfilePhoto() {
    _profilePhotoKey = null;
    notifyListeners();
  }


  bool get hasProfilePhoto => _profilePhotoKey != null;


  Future<void> _saveToken(String token, String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    if (userId != null) {
      await prefs.setString('user_id', userId);
    }
  }


  Future<void> _loadSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
    _userId = prefs.getString('user_id');
    notifyListeners();
  }


  Future<void> clearSession() async {
    _challengeId = null;
    _phoneNumber = null;
    _errorMessage = null;
    _authToken = null;
    _userId = null;
    _profilePhotoKey = null;


    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');

    notifyListeners();
  }


  Future<void> logout() async {
    await clearSession();
  }
}