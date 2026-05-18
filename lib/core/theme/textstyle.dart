import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class CustomTextStyles {
  // =========================================================
  // MAIN TITLES
  // =========================================================

  static const TextStyle title = TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle loginHeading = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 26,
  );

  static const TextStyle categoriesTitle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle blueBig = TextStyle(
    fontSize: 20,
    color: AppColors.darkBlue,
    fontWeight: FontWeight.bold,
  );

  // =========================================================
  // SUBTITLES & NORMAL TEXT
  // =========================================================

  static const TextStyle subtitle = TextStyle(color: Colors.white70);

  static const TextStyle text = TextStyle(color: AppColors.pureWhite);

  static const TextStyle lightWhite = TextStyle(
    fontSize: 12,
    color: Colors.white60,
    fontWeight: FontWeight.w600,
  );

  // =========================================================
  // USER / NAME TEXT
  // =========================================================

  static const TextStyle nameStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  // =========================================================
  // BUTTON TEXT STYLES
  // =========================================================

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle smallWhiteText = TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mediumWhiteText = TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bigWhiteText = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle smallRedText = TextStyle(
    fontSize: 12,
    color: AppColors.errorRed,
    fontWeight: FontWeight.w600,
  );

  // =========================================================
  // TABLE & HEADER TEXT
  // =========================================================

  static const TextStyle header = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle tableHeader = TextStyle(
    color: Colors.white70,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  // =========================================================
  // CATEGORY / LABEL STYLES
  // =========================================================

  static const TextStyle addCategory = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle viewStyle = TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.bold,
  );

  // =========================================================
  // DELETE DIALOG STYLES
  // =========================================================

  static const TextStyle deleteTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle deleteMessage = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle yesORno = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  // =========================================================
  // SNACKBAR
  // =========================================================

  static const TextStyle snackBar = TextStyle(color: Colors.white);

  // =========================================================
  // DYNAMIC TEXT STYLES
  // =========================================================

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
      fontSize: 14,
    );
  }

  static TextStyle userStatus(bool isActive) {
    return TextStyle(
      color: isActive ? Colors.green : Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
  }

  static TextStyle bestSeller(bool isBestSeller) {
    return TextStyle(
      color: isBestSeller ? Colors.amberAccent : Colors.white60,
      fontWeight: FontWeight.bold,
    );
  }
}
