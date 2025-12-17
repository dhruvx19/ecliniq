import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecliniq/ecliniq_api/src/endpoints.dart';
import 'package:ecliniq/ecliniq_core/auth/session_service.dart';

class NotificationProvider with ChangeNotifier {
  bool _isLoading = false;
  int _unreadCount = 0;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUnreadCount() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authToken = await SessionService.getAuthToken();
      if (authToken == null) {
        debugPrint('No auth token found for notifications');
        _isLoading = false;
        return;
      }

      final response = await http.get(
        Uri.parse(Endpoints.getUnreadNotificationCount),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
          'x-access-token': authToken,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final count = data['data']['unreadCount'];
          _unreadCount = count is int ? count : (int.tryParse(count.toString()) ?? 0);
          debugPrint('Unread notification count: $_unreadCount');
        } else {
          debugPrint('Failed to get unread count: ${data['message']}');
        }
      } else {
        debugPrint('Failed to get unread count: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error fetching unread count: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
