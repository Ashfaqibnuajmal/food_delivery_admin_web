import 'package:flutter/material.dart';

class ExpenseProvider extends ChangeNotifier {
  DateTime? _date;
  String? _category;
  int? _amount;
  String? _status;

  DateTime? get date => _date;
  String? get category => _category;
  int? get amount => _amount;
  String? get status => _status;

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

  void clearDate() {
    _date = null;
    notifyListeners();
  }

  void clearCategory() {
    _category = null;
    notifyListeners();
  }

  void clearAmount() {
    _amount = null;
    notifyListeners();
  }

  void clearStatus() {
    _status = null;
    notifyListeners();
  }
}
