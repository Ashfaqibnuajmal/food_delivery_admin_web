import 'package:flutter/material.dart';

class AddFoodDialogProvider extends ChangeNotifier {
  String? selectedCategory;
  bool isCompo = false;
  bool isTodayOffer = false;
  bool isHalfAvailable = false;
  bool isBestSeller = false;

  void toggleCompo(bool val) {
    isCompo = val;
    notifyListeners();
  }

  void toggleTodayOffer(bool val) {
    isTodayOffer = val;
    notifyListeners();
  }

  void toggleHalfAvailable(bool val) {
    isHalfAvailable = val;
    notifyListeners();
  }

  void toggleBestSeller(bool val) {
    isBestSeller = val;
    notifyListeners();
  }

  void selectCategory(String? val) {
    selectedCategory = val;
    notifyListeners();
  }
}
