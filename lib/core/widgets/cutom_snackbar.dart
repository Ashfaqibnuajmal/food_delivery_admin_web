import 'package:flutter/material.dart';

void customSnackbar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color,
    margin: const EdgeInsets.all(8),
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.all(10),
    duration: const Duration(seconds: 2),
    dismissDirection: DismissDirection.vertical,
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
