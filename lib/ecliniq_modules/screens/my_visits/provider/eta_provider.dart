import 'dart:async';
import 'package:ecliniq/ecliniq_api/eta_websocket_service.dart';
import 'package:ecliniq/ecliniq_api/models/eta_update.dart';
import 'package:flutter/foundation.dart';


class ETAProvider extends ChangeNotifier {
  final ETAWebSocketService _websocketService = ETAWebSocketService();

  ETAUpdate? _currentETA;
  SlotDisplayUpdate? _currentSlotDisplay;
  bool _isConnected = false;
  bool _isConnecting = false;
  String? _errorMessage;
  String? _currentAppointmentId;

  
  StreamSubscription<ETAUpdate>? _etaUpdateSubscription;
  StreamSubscription<SlotDisplayUpdate>? _slotDisplaySubscription;
  StreamSubscription<bool>? _connectionStatusSubscription;
  StreamSubscription<String>? _errorSubscription;

  ETAUpdate? get currentETA => _currentETA;
  SlotDisplayUpdate? get currentSlotDisplay => _currentSlotDisplay;
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  String? get errorMessage => _errorMessage;
  String? get currentAppointmentId => _currentAppointmentId;

  ETAProvider() {
    _setupSubscriptions();
  }

  
  void _setupSubscriptions() {
    
    _etaUpdateSubscription = _websocketService.etaUpdateStream.listen(
      (update) {
        _currentETA = update;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        notifyListeners();
      },
    );

    
    _slotDisplaySubscription = _websocketService.slotDisplayUpdateStream.listen(
      (update) {
        _currentSlotDisplay = update;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        notifyListeners();
      },
    );

    
    _connectionStatusSubscription = _websocketService.connectionStatusStream.listen(
      (connected) {
        _isConnected = connected;
        _isConnecting = false;
        notifyListeners();
      },
    );

    
    _errorSubscription = _websocketService.errorStream.listen(
      (error) {
        _errorMessage = error;
        notifyListeners();
      },
    );
  }

  
  Future<void> connectToAppointment({
    required String appointmentId,
    String? patientId,
  }) async {
    try {
      _isConnecting = true;
      _errorMessage = null;
      _currentAppointmentId = appointmentId;
      notifyListeners();

      
      if (!_websocketService.isConnected) {
        await _websocketService.connect();
        
        await Future.delayed(const Duration(milliseconds: 500));
      }

      
      await _websocketService.joinAppointment(
        appointmentId: appointmentId,
        patientId: patientId,
      );

      _isConnecting = false;
      notifyListeners();
    } catch (e) {
      _isConnecting = false;
      _errorMessage = 'Failed to connect: $e';
      notifyListeners();
    }
  }

  
  Future<void> connectToDoctorSession({
    required String doctorId,
    required String slotId,
  }) async {
    try {
      _isConnecting = true;
      _errorMessage = null;
      notifyListeners();

      if (!_websocketService.isConnected) {
        await _websocketService.connect();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      await _websocketService.joinDoctorSession(
        doctorId: doctorId,
        slotId: slotId,
      );

      _isConnecting = false;
      notifyListeners();
    } catch (e) {
      _isConnecting = false;
      _errorMessage = 'Failed to connect: $e';
      notifyListeners();
    }
  }

  
  Future<void> connectToSlotDisplay({
    required String slotId,
  }) async {
    try {
      _isConnecting = true;
      _errorMessage = null;
      notifyListeners();

      if (!_websocketService.isConnected) {
        await _websocketService.connect();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      await _websocketService.joinSlotDisplay(slotId: slotId);

      _isConnecting = false;
      notifyListeners();
    } catch (e) {
      _isConnecting = false;
      _errorMessage = 'Failed to connect: $e';
      notifyListeners();
    }
  }

  
  Future<void> disconnect() async {
    await _websocketService.disconnect();
    _isConnected = false;
    _isConnecting = false;
    _currentETA = null;
    _currentSlotDisplay = null;
    _currentAppointmentId = null;
    _errorMessage = null;
    notifyListeners();
  }

  
  void clearETA() {
    _currentETA = null;
    _currentSlotDisplay = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _etaUpdateSubscription?.cancel();
    _slotDisplaySubscription?.cancel();
    _connectionStatusSubscription?.cancel();
    _errorSubscription?.cancel();
    _websocketService.dispose();
    super.dispose();
  }
}

