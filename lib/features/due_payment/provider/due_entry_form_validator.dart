import 'package:flutter/material.dart';

class DueEntryFormProvider extends ChangeNotifier {
  DateTime? _selectedDate;
  String? _status;
  double? _amount;
  String _notes = '';
  bool _showDateError = false;

  DateTime? get selectedDate => _selectedDate;
  String? get status => _status;
  double? get amount => _amount;
  String get notes => _notes;
  bool get showDateError => _showDateError;

  void setInitialValues({
    DateTime? selectedDate,
    String? status,
    double? amount,
    String? notes,
  }) {
    _selectedDate = selectedDate;
    _status = status;
    _amount = amount;
    _notes = notes ?? '';
    _showDateError = false;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _showDateError = false;
    notifyListeners();
  }

  void setStatus(String? status) {
    _status = status;
    notifyListeners();
  }

  void setAmount(String value) {
    _amount = double.tryParse(value.trim());
    notifyListeners();
  }

  void setNotes(String value) {
    _notes = value.trim();
    notifyListeners();
  }

  void setShowDateError(bool value) {
    _showDateError = value;
    notifyListeners();
  }
}
