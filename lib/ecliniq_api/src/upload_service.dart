// lib/services/upload_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:ecliniq/ecliniq_api/models/upload.dart';
import 'package:ecliniq/ecliniq_api/src/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mime/mime.dart';

class UploadService {
  
  Future<UploadUrlResponse> generateUploadUrl({
    required String authToken,
    required String contentType,
  }) async {
    try {
      final url = Uri.parse(Endpoints.getUrl);
      print('🔍 Generating upload URL from: $url');
      print('🔍 Content type: $contentType');
      
      final request = UploadUrlRequest(contentType: contentType);
      
      print('📤 Request body: ${json.encode(request.toJson())}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(request.toJson()),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('✅ Upload URL generated successfully');
        return UploadUrlResponse.fromJson(responseData);
      } else {
        print('❌ Failed to generate upload URL: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        throw Exception('Failed to generate upload URL: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error generating upload URL: $e');
      throw Exception('Error generating upload URL: $e');
    }
  }

  /// Upload image to S3 using presigned URL
  Future<bool> uploadImageToS3({
    required String uploadUrl,
    required File imageFile,
    required String contentType,
  }) async {
    try {
      print('📤 Uploading image to S3...');
      print('📤 Upload URL: $uploadUrl');
      print('📤 Content type: $contentType');
      
      final bytes = await imageFile.readAsBytes();
      print('📤 Image size: ${bytes.length} bytes');
      
      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          'Content-Type': contentType,
        },
        body: bytes,
      );

      print('📥 S3 upload response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        print('✅ Image uploaded to S3 successfully');
        return true;
      } else {
        print('❌ Failed to upload to S3: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error uploading image to S3: $e');
      throw Exception('Error uploading image to S3: $e');
    }
  }

  /// Upload image from bytes to S3 using presigned URL
  Future<bool> uploadImageBytesToS3({
    required String uploadUrl,
    required Uint8List imageBytes,
    required String contentType,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          'Content-Type': contentType,
        },
        body: imageBytes,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error uploading image bytes to S3: $e');
    }
  }

  /// Save patient details with profile photo
  Future<PatientDetailsResponse> savePatientDetails({
    required String authToken,
    required PatientDetailsRequest request,
  }) async {
    try {
      final url = Uri.parse(Endpoints.patientDetails); // Replace with your actual endpoint

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return PatientDetailsResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to save patient details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saving patient details: $e');
    }
  }

  /// Get content type from file
  String getContentTypeFromFile(File file) {
    final mimeType = lookupMimeType(file.path);
    return mimeType ?? 'image/jpeg'; // Default to jpeg if can't determine
  }

  /// Complete image upload flow
  Future<String?> uploadImageComplete({
    required String authToken,
    required File imageFile,
  }) async {
    try {
      print('🚀 Starting complete image upload flow...');
      
      // Step 1: Get content type
      final contentType = getContentTypeFromFile(imageFile);
      print('✅ Content type determined: $contentType');
      
      // Step 2: Generate upload URL
      print('📤 Step 1: Generating upload URL...');
      final uploadUrlResponse = await generateUploadUrl(
        authToken: authToken,
        contentType: contentType,
      );

      if (!uploadUrlResponse.success || uploadUrlResponse.data == null) {
        print('❌ Failed to get upload URL: ${uploadUrlResponse.message}');
        throw Exception('Failed to get upload URL: ${uploadUrlResponse.message}');
      }

      print('✅ Upload URL received: ${uploadUrlResponse.data!.uploadUrl}');
      print('✅ Image key: ${uploadUrlResponse.data!.key}');

      // Step 3: Upload to S3
      print('📤 Step 2: Uploading image to S3...');
      final uploadSuccess = await uploadImageToS3(
        uploadUrl: uploadUrlResponse.data!.uploadUrl,
        imageFile: imageFile,
        contentType: contentType,
      );

      if (!uploadSuccess) {
        print('❌ Failed to upload image to S3');
        throw Exception('Failed to upload image to S3');
      }

      print('✅ Step 3: Image upload completed successfully!');
      print('✅ Returning image key: ${uploadUrlResponse.data!.key}');
      
      // Return the key for use in patient details
      return uploadUrlResponse.data!.key;
    } catch (e) {
      print('❌ Complete upload failed: $e');
      throw Exception('Complete upload failed: $e');
    }
  }

  /// Complete image upload flow from bytes
  Future<String?> uploadImageBytesComplete({
    required String authToken,
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    try {
      // Step 1: Get content type from filename
      final mimeType = lookupMimeType(fileName);
      final contentType = mimeType ?? 'image/jpeg';
      
      // Step 2: Generate upload URL
      final uploadUrlResponse = await generateUploadUrl(
        authToken: authToken,
        contentType: contentType,
      );

      if (!uploadUrlResponse.success || uploadUrlResponse.data == null) {
        throw Exception('Failed to get upload URL: ${uploadUrlResponse.message}');
      }

      // Step 3: Upload to S3
      final uploadSuccess = await uploadImageBytesToS3(
        uploadUrl: uploadUrlResponse.data!.uploadUrl,
        imageBytes: imageBytes,
        contentType: contentType,
      );

      if (!uploadSuccess) {
        throw Exception('Failed to upload image to S3');
      }

      // Return the key for use in patient details
      return uploadUrlResponse.data!.key;
    } catch (e) {
      throw Exception('Complete upload failed: $e');
    }
  }
}