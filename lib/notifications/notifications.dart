import 'package:flutter/material.dart';

class Notifications {
  static void show(BuildContext context, String message,
      {bool isError = false, bool isInfo = false}) {
    Color textColor;

    if (isError) {
      textColor = Colors.red;
    } else if (isInfo) {
      textColor = Colors.blue;
    } else {
      textColor = Colors.green;
    }

    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
