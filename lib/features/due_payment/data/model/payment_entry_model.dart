import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentEntryModel {
  final String entryId;
  final String userId;
  final DateTime date;
  final String status;
  final double amount;
  final String notes;

  const PaymentEntryModel({
    required this.entryId,
    required this.userId,
    required this.date,
    required this.status,
    required this.amount,
    required this.notes,
  });

  PaymentEntryModel copyWith({
    String? entryId,
    String? userId,
    DateTime? date,
    String? status,
    double? amount,
    String? notes,
  }) {
    return PaymentEntryModel(
      entryId: entryId ?? this.entryId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'entryId': entryId,
      'userId': userId,
      'date': date,
      'status': status,
      'amount': amount,
      'notes': notes,
    };
  }

  factory PaymentEntryModel.fromMap(Map<String, dynamic> map) {
    return PaymentEntryModel(
      entryId: map['entryId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      date: _parseDate(map['date']),
      status: map['status']?.toString() ?? '',
      amount: _parseDouble(map['amount']),
      notes: map['notes']?.toString() ?? '',
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }
}
