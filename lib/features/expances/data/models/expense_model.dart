import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String? id;
  DateTime date;
  String category;
  String status;
  double amount;
  DateTime? createdAt;
  DateTime? updatedAt;

  ExpenseModel({
    this.id,
    required this.date,
    required this.category,
    required this.status,
    required this.amount,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "date": Timestamp.fromDate(date),
      "category": category,
      "status": status,
      "amount": amount,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map, String docId) {
    return ExpenseModel(
      id: docId,
      date: (map['date'] as Timestamp).toDate(),
      category: map['category'] ?? '',
      status: map['status'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
  double get signedAmount {
    if (status == "Consumed") {
      return -amount;
    }
    return amount;
  }
}
