


enum ETAStatus {
  waiting,
  ready,
  engaged,
  completed,
  cancelled,
}


class ETAUpdate {
  final String? appointmentId;
  final int? token;
  final String? eta;
  final int? waitMinutes;
  final int? positionsAhead;
  final ETAStatus? status;
  final String? message;
  final String timestamp;

  ETAUpdate({
    this.appointmentId,
    this.token,
    this.eta,
    this.waitMinutes,
    this.positionsAhead,
    this.status,
    this.message,
    required this.timestamp,
  });

  factory ETAUpdate.fromJson(Map<String, dynamic> json) {
    ETAStatus? parseStatus(String? statusStr) {
      if (statusStr == null) return null;
      switch (statusStr.toLowerCase()) {
        case 'waiting':
          return ETAStatus.waiting;
        case 'ready':
          return ETAStatus.ready;
        case 'engaged':
          return ETAStatus.engaged;
        case 'completed':
          return ETAStatus.completed;
        case 'cancelled':
          return ETAStatus.cancelled;
        default:
          return null;
      }
    }

    return ETAUpdate(
      appointmentId: json['appointmentId']?.toString(),
      token: json['token'] != null
          ? (json['token'] is int
              ? json['token'] as int
              : int.tryParse(json['token'].toString()))
          : null,
      eta: json['eta']?.toString(),
      waitMinutes: json['waitMinutes'] != null
          ? (json['waitMinutes'] is int
              ? json['waitMinutes'] as int
              : int.tryParse(json['waitMinutes'].toString()))
          : null,
      positionsAhead: json['positionsAhead'] != null
          ? (json['positionsAhead'] is int
              ? json['positionsAhead'] as int
              : int.tryParse(json['positionsAhead'].toString()))
          : null,
      status: parseStatus(json['status']?.toString()),
      message: json['message']?.toString(),
      timestamp: json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    String? statusStr;
    if (status != null) {
      switch (status!) {
        case ETAStatus.waiting:
          statusStr = 'waiting';
          break;
        case ETAStatus.ready:
          statusStr = 'ready';
          break;
        case ETAStatus.engaged:
          statusStr = 'engaged';
          break;
        case ETAStatus.completed:
          statusStr = 'completed';
          break;
        case ETAStatus.cancelled:
          statusStr = 'cancelled';
          break;
      }
    }

    return {
      if (appointmentId != null) 'appointmentId': appointmentId,
      if (token != null) 'token': token,
      if (eta != null) 'eta': eta,
      if (waitMinutes != null) 'waitMinutes': waitMinutes,
      if (positionsAhead != null) 'positionsAhead': positionsAhead,
      if (statusStr != null) 'status': statusStr,
      if (message != null) 'message': message,
      'timestamp': timestamp,
    };
  }
}


class SlotDisplayUpdate {
  final String slotId;
  final int currentToken;
  final String slotStatus;
  final String timestamp;

  SlotDisplayUpdate({
    required this.slotId,
    required this.currentToken,
    required this.slotStatus,
    required this.timestamp,
  });

  factory SlotDisplayUpdate.fromJson(Map<String, dynamic> json) {
    return SlotDisplayUpdate(
      slotId: json['slotId']?.toString() ?? '',
      currentToken: json['currentToken'] != null
          ? (json['currentToken'] is int
              ? json['currentToken'] as int
              : int.tryParse(json['currentToken'].toString()) ?? 0)
          : 0,
      slotStatus: json['slotStatus']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slotId': slotId,
      'currentToken': currentToken,
      'slotStatus': slotStatus,
      'timestamp': timestamp,
    };
  }
}


class JoinResponse {
  final String room;
  final bool success;
  final ETAUpdate? currentETA;
  final SlotDisplayUpdate? currentState;
  final String? error;

  JoinResponse({
    required this.room,
    required this.success,
    this.currentETA,
    this.currentState,
    this.error,
  });

  factory JoinResponse.fromJson(Map<String, dynamic> json) {
    return JoinResponse(
      room: json['room']?.toString() ?? '',
      success: json['success'] == true,
      currentETA: json['currentETA'] != null
          ? ETAUpdate.fromJson(json['currentETA'] as Map<String, dynamic>)
          : null,
      currentState: json['currentState'] != null
          ? SlotDisplayUpdate.fromJson(json['currentState'] as Map<String, dynamic>)
          : null,
      error: json['error']?.toString(),
    );
  }
}

