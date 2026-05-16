import 'package:flutter/material.dart';

class DueUserActionProvider extends ChangeNotifier {
  bool _isSavingUser = false;
  bool _isDeletingUser = false;

  bool get isSavingUser => _isSavingUser;
  bool get isDeletingUser => _isDeletingUser;

  Future<void> runUserAction(Future<void> Function() action) async {
    if (_isSavingUser) return;

    _isSavingUser = true;
    notifyListeners();

    try {
      await action();
    } finally {
      _isSavingUser = false;
      notifyListeners();
    }
  }

  Future<void> runDeleteAction(Future<void> Function() action) async {
    if (_isDeletingUser) return;

    _isDeletingUser = true;
    notifyListeners();

    try {
      await action();
    } finally {
      _isDeletingUser = false;
      notifyListeners();
    }
  }
}
