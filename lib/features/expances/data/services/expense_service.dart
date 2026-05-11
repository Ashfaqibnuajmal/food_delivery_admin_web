import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:user_app/features/expances/data/models/expense_model.dart';

class ExpenseService extends ChangeNotifier {
  final expenseCollection = FirebaseFirestore.instance.collection("Expense");
  Future<void> addExpense({
    required String category,
    required String status,
    required double amount,
    required DateTime date,
  }) async {
    try {
      final docRef = expenseCollection.doc();

      final expense = ExpenseModel(
        date: date,
        category: category,
        status: status,
        amount: amount,
      );

      await docRef.set(expense.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editExpense(ExpenseModel expense) async {
    try {
      await expenseCollection.doc(expense.id).update({
        "date": Timestamp.fromDate(expense.date),
        "category": expense.category,
        "status": expense.status,
        "amount": expense.amount,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpense(String id) async {
    await expenseCollection.doc(id).delete();
  }

  /// 🔄 Fetch All Expenses as Stream
  Stream<List<ExpenseModel>> fetchExpenses() {
    return expenseCollection.orderBy("date", descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return ExpenseModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
