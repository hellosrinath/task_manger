import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String title,
    [bool isErrorMessage = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title),
      backgroundColor: isErrorMessage ? Colors.red : Colors.green,
    ),
  );
}
