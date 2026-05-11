import 'package:flutter/material.dart';

class ChatListProvider extends ChangeNotifier {
  String? selectedUserId;
  String? selectedUserName;

  void selectUser(String userId, String userName) {
    selectedUserId = userId;
    selectedUserName = userName;
    notifyListeners();
  }
}
