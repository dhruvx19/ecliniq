import 'dart:convert';


class JwtDecoder {
  static int? getExpirationTimestamp(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      
      final payload = parts[1];
      
      
      final normalizedPayload = _normalizeBase64(payload);
      
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      final payloadMap = jsonDecode(decodedString) as Map<String, dynamic>;
      
      
      final exp = payloadMap['exp'];
      if (exp is int) {
        return exp;
      }
      
      return null;
    } catch (e) {
      
      return null;
    }
  }

  
  static DateTime? getExpirationTime(String token) {
    final timestamp = getExpirationTimestamp(token);
    if (timestamp == null) {
      return null;
    }
    
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  
  
  static int? getSecondsUntilExpiration(String token) {
    final expirationTime = getExpirationTime(token);
    if (expirationTime == null) {
      return null;
    }
    
    final now = DateTime.now();
    final difference = expirationTime.difference(now);
    
    return difference.inSeconds;
  }

  
  static String _normalizeBase64(String base64) {
    final remainder = base64.length % 4;
    if (remainder == 0) {
      return base64;
    }
    
    return base64 + '=' * (4 - remainder);
  }

  
  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      final payload = parts[1];
      final normalizedPayload = _normalizeBase64(payload);
      
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      final payloadMap = jsonDecode(decodedString) as Map<String, dynamic>;
      
      return payloadMap;
    } catch (e) {
      
      return null;
    }
  }
}

