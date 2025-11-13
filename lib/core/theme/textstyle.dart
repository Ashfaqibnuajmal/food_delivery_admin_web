import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class CustomTextStyles {
  static const TextStyle title = TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(color: Colors.white70);

  static const TextStyle loginHeading = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 26,
  );
  static const TextStyle nameStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static const TextStyle snackBar = TextStyle(color: Colors.white);

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // ✅ Add Category text style
  static const TextStyle addCategory = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle deleteTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static const TextStyle categoriesTitle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle deleteMessage = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );
  static const TextStyle text = TextStyle(color: AppColors.pureWhite);
  static const TextStyle yesORno = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle viewStyle = TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle header = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  static TextStyle balance(double balance) {
    return TextStyle(
      color: balance > 0 ? Colors.red : Colors.green,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
  }

  static TextStyle status(String status) {
    return TextStyle(
      color: status == "Paid" ? Colors.green : Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 14, // optional, set your default size
    );
  }

  static TextStyle userStatus(bool isActive) {
    return TextStyle(
      color: isActive ? Colors.green : Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 14, // optional
    );
  }

  static TextStyle bestSeller(bool isBestSeller) {
    return TextStyle(
      color: isBestSeller ? Colors.amberAccent : Colors.white60,
      fontWeight: FontWeight.bold,
    );
  }

  static const TextStyle tableHeader = TextStyle(
    color: Colors.white70,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );
}
