import 'package:flutter/material.dart';

class DueEntryActionProvider extends ChangeNotifier {
  bool _isSavingEntry = false;
  bool _isDeletingEntry = false;

  bool get isSavingEntry => _isSavingEntry;
  bool get isDeletingEntry => _isDeletingEntry;

  Future<void> runSaveEntryAction(Future<void> Function() action) async {
    if (_isSavingEntry) return;

    _isSavingEntry = true;
    notifyListeners();

    try {
      await action();
    } finally {
      _isSavingEntry = false;
      notifyListeners();
    }
  }

  Future<void> runDeleteEntryAction(Future<void> Function() action) async {
    if (_isDeletingEntry) return;

    _isDeletingEntry = true;
    notifyListeners();

    try {
      await action();
    } finally {
      _isDeletingEntry = false;
      notifyListeners();
    }
  }
}
