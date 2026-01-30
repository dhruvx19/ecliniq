
class WalletBalanceData {
  final double balance;
  final double totalDeposited;
  final String currency;

  WalletBalanceData({
    required this.balance,
    required this.totalDeposited,
    required this.currency,
  });

  factory WalletBalanceData.fromJson(Map<String, dynamic> json) {
    
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return WalletBalanceData(
      balance: parseDouble(json['balance']),
      totalDeposited: parseDouble(json['totalDeposited']),
      currency: json['currency']?.toString() ?? 'INR',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'totalDeposited': totalDeposited,
      'currency': currency,
    };
  }
}


class WalletBalanceResponse {
  final bool success;
  final String message;
  final WalletBalanceData? data;
  final dynamic errors;
  final dynamic meta;
  final String timestamp;

  WalletBalanceResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.meta,
    required this.timestamp,
  });

  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    return WalletBalanceResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? WalletBalanceData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'],
      meta: json['meta'],
      timestamp: json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
      'errors': errors,
      'meta': meta,
      'timestamp': timestamp,
    };
  }
}


class WalletTransaction {
  final String id;
  final String type; 
  final double amount;
  final String description;
  final DateTime createdAt;
  final double balanceAfter;
  final String status;
  final String referenceType;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.balanceAfter,
    required this.status,
    required this.referenceType,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      try {
        final timeStr = value is String ? value : value.toString();
        return DateTime.parse(timeStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    return WalletTransaction(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: parseDouble(json['amount']),
      description: json['description']?.toString() ?? '',
      createdAt: parseDateTime(json['createdAt']),
      balanceAfter: parseDouble(json['balanceAfter']),
      status: json['status']?.toString() ?? '',
      referenceType: json['referenceType']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'balanceAfter': balanceAfter,
      'status': status,
      'referenceType': referenceType,
    };
  }

  
  bool get isCredit => type.toUpperCase() == 'TOPUP';

  
  bool get isDebit => type.toUpperCase() == 'DEBIT';

  
  bool get isCompleted => status.toUpperCase() == 'COMPLETED';
}


class WalletTransactionsData {
  final double balance;
  final double totalDeposited;
  final String currency;
  final int year;
  final Map<String, List<WalletTransaction>> transactions;

  WalletTransactionsData({
    required this.balance,
    required this.totalDeposited,
    required this.currency,
    required this.year,
    required this.transactions,
  });

  factory WalletTransactionsData.fromJson(Map<String, dynamic> json) {
    
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    
    Map<String, List<WalletTransaction>> parseTransactions(
        Map<String, dynamic>? transactionsJson) {
      if (transactionsJson == null) return {};

      final Map<String, List<WalletTransaction>> result = {};
      transactionsJson.forEach((key, value) {
        if (value is List) {
          result[key] = value
              .map((item) => WalletTransaction.fromJson(
                  item as Map<String, dynamic>))
              .toList();
        }
      });

      return result;
    }

    return WalletTransactionsData(
      balance: parseDouble(json['balance']),
      totalDeposited: parseDouble(json['totalDeposited']),
      currency: json['currency']?.toString() ?? 'INR',
      year: json['year'] is int
          ? json['year']
          : json['year'] != null
              ? int.tryParse(json['year'].toString()) ?? DateTime.now().year
              : DateTime.now().year,
      transactions: parseTransactions(
          json['transactions'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> transactionsJson = {};
    transactions.forEach((key, value) {
      transactionsJson[key] = value.map((tx) => tx.toJson()).toList();
    });

    return {
      'balance': balance,
      'totalDeposited': totalDeposited,
      'currency': currency,
      'year': year,
      'transactions': transactionsJson,
    };
  }

  
  List<WalletTransaction> get allTransactions {
    final List<WalletTransaction> all = [];
    transactions.forEach((month, txList) {
      all.addAll(txList);
    });
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return all;
  }

  
  List<WalletTransaction> getTransactionsForMonth(String month) {
    return transactions[month] ?? [];
  }

  
  List<String> get months {
    final months = transactions.keys.toList();
    
    months.sort((a, b) {
      try {
        final dateA = DateTime.parse(a);
        final dateB = DateTime.parse(b);
        return dateB.compareTo(dateA);
      } catch (e) {
        
        return b.compareTo(a);
      }
    });
    return months;
  }
}


class WalletTransactionsResponse {
  final bool success;
  final String message;
  final WalletTransactionsData? data;
  final dynamic errors;
  final dynamic meta;
  final String timestamp;

  WalletTransactionsResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.meta,
    required this.timestamp,
  });

  factory WalletTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return WalletTransactionsResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? WalletTransactionsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'],
      meta: json['meta'],
      timestamp: json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
      'errors': errors,
      'meta': meta,
      'timestamp': timestamp,
    };
  }
}



