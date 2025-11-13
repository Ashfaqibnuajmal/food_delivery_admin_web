import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:user_app/features/expances/data/models/expance_model.dart';

class ExpanceServices extends ChangeNotifier {
  final expanceCollection = FirebaseFirestore.instance.collection("Expances");
  Future<void> addExpance({
    required String category,
    required String status,
    required double amount,
    required DateTime date,
  }) async {
    try {
      final docRef = expanceCollection.doc();
      final expanse = ExpenseModel(
        expanseUid: docRef.id,
        date: date,
        category: category,
        status: status,
        amount: amount,
      );
      await docRef.set(expanse.toMap());
      log("✅ Expense added: ${expanse.toMap()}");
    } catch (e) {
      log("❌ Error adding expense: $e");
      rethrow;
    }
  }

  Future<void> editExpanse(ExpenseModel expense) async {
    try {
      await expanceCollection.doc(expense.expanseUid).update(expense.toMap());
      log("✅ Expense updated: ${expense.expanseUid}");
    } catch (e) {
      log("❌ Error updating expense: $e");
      rethrow;
    }
  }

  Future<void> deleteExpense(String expanseUid) async {
    try {
      await expanceCollection.doc(expanseUid).delete();
      log("✅ Expense deleted: $expanseUid");
    } catch (e) {
      log("❌ Error deleting expense: $e");
      rethrow;
    }
  }

  /// 🔄 Fetch All Expenses as Stream
  Stream<List<ExpenseModel>> fetchExpenses() {
    return expanceCollection.orderBy("date", descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return ExpenseModel.fromMap(doc.data());
      }).toList();
    });
  }
}
