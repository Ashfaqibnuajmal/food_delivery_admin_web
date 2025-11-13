import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String expanseUid;
  DateTime date; // still use DateTime in app
  String category;
  String status;
  double amount;

  ExpenseModel({
    required this.expanseUid,
    required this.date,
    required this.category,
    required this.status,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      "expanseUid": expanseUid,
      "date": Timestamp.fromDate(date), // 🔑 Store as Firestore Timestamp
      "category": category,
      "status": status,
      "amount": amount,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      expanseUid: map['expanseUid'] ?? '',
      date: (map['date'] as Timestamp).toDate(), // 🔑 Convert back
      category: map['category'] ?? 'Unknown',
      status: map['status'] ?? 'Unknown',
      amount: (map['amount'] as num).toDouble(),
    );
  }
}
