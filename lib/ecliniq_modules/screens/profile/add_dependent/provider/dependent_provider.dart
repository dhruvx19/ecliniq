import 'dart:io';

import 'package:ecliniq/ecliniq_api/models/patient.dart';
import 'package:ecliniq/ecliniq_api/patient_service.dart';
import 'package:ecliniq/ecliniq_api/src/upload_service.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDependentProvider extends ChangeNotifier {
  // blood group provider
  String _selectedBloodGroup = '';
  String? get selectedBloodGroup => _selectedBloodGroup;
  void selectBloodGroup(String value){
    _selectedBloodGroup = value;
    notifyListeners();
  }
  void clearSection(){
    _selectedBloodGroup = '';
    notifyListeners();
  }

  // gender selection provider
  String? _selectedGender;
  String? get selectedGender => _selectedGender ?? _gender;
  void selectGender(String value){
    _selectedGender = value;
    _gender = value; // Also set the main gender field
    notifyListeners();
  }
  void clearGender(){
    _selectedGender = null;
    _gender = null;
    notifyListeners();
  }

  // relation selection provider
  String? _selectedRelation;
  String? get selectedRelation => _selectedRelation ?? _relation;
  void selectRelation(String value){
    _selectedRelation = value;
    _relation = value; // Also set the main relation field
    notifyListeners();
  }
  void clearRelation(){
    _selectedRelation = null;
    _relation = null;
    notifyListeners();
  }

  String? _photoUrl;
  String _firstName = '';
  String _lastName = '';
  String? _gender;
  DateTime? _dateOfBirth;
  String? _relation;
  String _contactNumber = '';
  String _email = '';
  String? _bloodGroup;
  int? _height;
  int? _weight;
  String? _profilePhotoKey;
  File? _selectedProfilePhoto;

  bool _isLoading = false;
  bool _isUploadingPhoto = false;
  String? _errorMessage;

  final PatientService _patientService = PatientService();
  final UploadService _uploadService = UploadService();

  String? get photoUrl => _photoUrl;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String? get gender => _gender;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get relation => _relation;
  String get contactNumber => _contactNumber;
  String get email => _email;
  String? get bloodGroup => _bloodGroup;
  int? get height => _height;
  int? get weight => _weight;
  File? get selectedProfilePhoto => _selectedProfilePhoto;
  bool get isLoading => _isLoading;
  bool get isUploadingPhoto => _isUploadingPhoto;
  String? get errorMessage => _errorMessage;

  // Add getter to check if all mandatory fields are filled
  bool get isFormValid {
    final isValid = _firstName.trim().isNotEmpty &&
        _lastName.trim().isNotEmpty &&
        _gender != null &&
        _dateOfBirth != null &&
        _relation != null &&
        _contactNumber.trim().isNotEmpty;
    
    // Debug logging
    if (!isValid) {
      print('🔍 Form Validation Details:');
      print('   First Name: "${_firstName.trim()}" (empty: ${_firstName.trim().isEmpty})');
      print('   Last Name: "${_lastName.trim()}" (empty: ${_lastName.trim().isEmpty})');
      print('   Gender: $_gender (selectedGender: $_selectedGender)');
      print('   Date of Birth: $_dateOfBirth');
      print('   Relation: $_relation (selectedRelation: $_selectedRelation)');
      print('   Contact Number: "${_contactNumber.trim()}" (empty: ${_contactNumber.trim().isEmpty})');
    }
    
    return isValid;
  }
  
  // Get detailed validation error message
  String getValidationErrorMessage() {
    final errors = <String>[];
    
    if (_firstName.trim().isEmpty) {
      errors.add('First name is required');
    }
    if (_lastName.trim().isEmpty) {
      errors.add('Last name is required');
    }
    if (_gender == null) {
      errors.add('Gender is required');
    }
    if (_dateOfBirth == null) {
      errors.add('Date of birth is required');
    }
    if (_relation == null) {
      errors.add('Relation is required');
    }
    if (_contactNumber.trim().isEmpty) {
      errors.add('Contact number is required');
    }
    
    return errors.isEmpty ? 'Please fill all required fields' : errors.join(', ');
  }

  void setPhotoUrl(String? url) {
    _photoUrl = url;
    notifyListeners();
  }

  void setFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void setGender(String value) {
    _gender = value;
    notifyListeners();
  }

  void setDateOfBirth(DateTime value) {
    _dateOfBirth = value;
    notifyListeners();
  }

  void setRelation(String value) {
    _relation = value;
    notifyListeners();
  }

  void setContactNumber(String value) {
    _contactNumber = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setBloodGroup(String value) {
    _bloodGroup = value;
    notifyListeners();
  }

  void setHeight(int? value) {
    _height = value;
    notifyListeners();
  }

  void setWeight(int? value) {
    _weight = value;
    notifyListeners();
  }

  void setSelectedProfilePhoto(File? file) {
    _selectedProfilePhoto = file;
    notifyListeners();
  }

  bool validate() {
    if (_firstName.trim().isEmpty) {
      _errorMessage = 'First name is required';
      notifyListeners();
      return false;
    }
    if (_lastName.trim().isEmpty) {
      _errorMessage = 'Last name is required';
      notifyListeners();
      return false;
    }
    if (_gender == null) {
      _errorMessage = 'Gender is required';
      notifyListeners();
      return false;
    }
    if (_dateOfBirth == null) {
      _errorMessage = 'Date of birth is required';
      notifyListeners();
      return false;
    }
    if (_relation == null) {
      _errorMessage = 'Relation is required';
      notifyListeners();
      return false;
    }
    if (_contactNumber.trim().isEmpty) {
      _errorMessage = 'Contact number is required';
      notifyListeners();
      return false;
    }
    _errorMessage = null;
    return true;
  }

  Future<bool> saveDependent(BuildContext context) async {
    print('🔍 Validating dependent data...');
    if (!validate()) {
      print('❌ Validation failed: $_errorMessage');
      return false;
    }
    print('✅ Validation passed');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authToken = authProvider.authToken;

      if (authToken == null) {
        print('❌ No auth token found');
        _errorMessage = 'Authentication required';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      print('✅ Auth token found');

      // Upload profile photo if selected
      // Step 1: Get upload URL from /api/storage/upload-url
      // Step 2: Upload image to S3 using the upload URL
      // Step 3: Get the key and use it in add dependent API
      if (_selectedProfilePhoto != null) {
        _isUploadingPhoto = true;
        notifyListeners();

        try {
          print('📤 Uploading profile photo for dependent...');
          // Use UploadService to upload image and get the key
          _profilePhotoKey = await _uploadService.uploadImageComplete(
            authToken: authToken,
            imageFile: _selectedProfilePhoto!,
          );

          if (_profilePhotoKey == null) {
            print('❌ Failed to upload profile photo - key is null');
            _errorMessage = 'Failed to upload profile photo';
            _isLoading = false;
            _isUploadingPhoto = false;
            notifyListeners();
            return false;
          }

          print('✅ Profile photo uploaded successfully: $_profilePhotoKey');
          _isUploadingPhoto = false;
          notifyListeners();
        } catch (e) {
          print('❌ Error uploading profile photo: $e');
          _errorMessage = 'Failed to upload profile photo: $e';
          _isLoading = false;
          _isUploadingPhoto = false;
          notifyListeners();
          return false;
        }
      }

      // Format DOB as YYYY-MM-DD
      final formattedDob = '${_dateOfBirth!.year}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.day.toString().padLeft(2, '0')}';

      // Create request
      print('📝 Creating add dependent request...');
      print('   First Name: ${_firstName.trim()}');
      print('   Last Name: ${_lastName.trim()}');
      print('   DOB: $formattedDob');
      print('   Gender: ${_gender!.toLowerCase()}');
      print('   Relation: ${_relation!.toLowerCase()}');
      print('   Phone: ${_contactNumber.trim()}');
      print('   Email: ${_email.trim()}');
      print('   Blood Group: $_bloodGroup');
      print('   Height: $_height');
      print('   Weight: $_weight');
      print('   Profile Photo Key: $_profilePhotoKey');
      
      final request = AddDependentRequest(
        firstName: _firstName.trim(),
        lastName: _lastName.trim(),
        dob: formattedDob,
        gender: _gender!.toLowerCase(),
        relation: _relation!.toLowerCase(),
        phone: _contactNumber.trim().isNotEmpty ? _contactNumber.trim() : null,
        emailId: _email.trim().isNotEmpty ? _email.trim() : null,
        bloodGroup: _bloodGroup,
        height: _height,
        weight: _weight,
        profilePhoto: _profilePhotoKey,
      );

      // Call API
      print('📤 Calling add-dependent API...');
      final response = await _patientService.addDependent(
        authToken: authToken,
        request: request,
      );
      print('📥 API response received: success=${response.success}, message=${response.message}');

      if (response.success) {
      _isLoading = false;
        reset();
      notifyListeners();
      return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to save dependent: $e';
      _isLoading = false;
      _isUploadingPhoto = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _photoUrl = null;
    _selectedProfilePhoto = null;
    _profilePhotoKey = null;
    _firstName = '';
    _lastName = '';
    _gender = null;
    _dateOfBirth = null;
    _relation = null;
    _contactNumber = '';
    _email = '';
    _bloodGroup = null;
    _height = null;
    _weight = null;
    _isLoading = false;
    _isUploadingPhoto = false;
    _errorMessage = null;
    notifyListeners();
  }
}