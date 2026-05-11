import 'package:flutter/material.dart';
import 'package:user_app/features/expances/data/models/expense_model.dart';
import 'package:user_app/features/expances/data/services/expense_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _service = ExpenseService();

  DateTime? _date;
  String? _category;
  int? _amount;
  String? _status;

  DateTime? get date => _date;
  String? get category => _category;
  int? get amount => _amount;
  String? get status => _status;

  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> get expenses => _expenses;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;
  void listenToExpenses() {
    _isLoading = true;
    notifyListeners();

    _service.fetchExpenses().listen((data) {
      _expenses = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  void setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  void setCategory(String category) {
    _category = category;
    notifyListeners();
  }

  void setAmount(int amount) {
    _amount = amount;
    notifyListeners();
  }

  void setStatus(String status) {
    _status = status;
    notifyListeners();
  }

  // 🔥 NEW METHODS (IMPORTANT)

  Future<void> addExpense() async {
    try {
      _isSubmitting = true;
      notifyListeners();

      if (_date == null ||
          _category == null ||
          _amount == null ||
          _status == null) {
        throw Exception("Please fill all fields");
      }

      await _service.addExpense(
        category: _category!,
        status: _status!,
        amount: _amount!.toDouble(),
        date: _date!,
      );

      clearAll();
    } catch (e) {
      rethrow;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await _service.editExpense(expense);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _service.deleteExpense(id);
    } catch (e) {
      rethrow;
    }
  }

  void clearAmount() {
    _amount = null;
    notifyListeners();
  }

  // ✅ Clean reset
  void clearAll() {
    _date = null;
    _category = null;
    _amount = null;
    _status = null;
    notifyListeners();
  }

  Stream<List<ExpenseModel>> fetchExpenses() {
    return _service.fetchExpenses();
  }
}
