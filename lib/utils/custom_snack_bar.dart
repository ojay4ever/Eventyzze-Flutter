import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_theme.dart';

class CustomSnackBar {
  static void show({
    required String title,
    required String message,
    Color backgroundColor = Colors.black87,
    Color textColor = AppTheme.white,
    Color iconColor = AppTheme.white,
    IconData? icon,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    int durationInSeconds = 1,
    double borderRadius = 12.0,
    EdgeInsets margin = const EdgeInsets.all(10),
    bool isDismissible = true,
    DismissDirection dismissDirection = DismissDirection.horizontal,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: snackPosition,
      duration: Duration(seconds: durationInSeconds),
      borderRadius: borderRadius,
      margin: margin,
      isDismissible: isDismissible,
      dismissDirection: dismissDirection,
      icon: icon != null ? Icon(icon, color: iconColor) : null,
    );
  }

  static void success({
    required String title,
    required String message,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    show(
      title: title,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
      snackPosition: snackPosition,
    );
  }

  static void error({
    required String title,
    required String message,
    int durationInSeconds = 2,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    show(
      title: title,
      message: message,
      backgroundColor: Colors.red,
      durationInSeconds: durationInSeconds,
      snackPosition: snackPosition,
      icon: Icons.error,
    );
  }

  static void warning({required String title, required String message}) {
    show(
      title: title,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
    );
  }

  static void info(String title, String message) {
    show(
      title: title,
      message: message,
      backgroundColor: Colors.blue,
      icon: Icons.info,
    );
  }
}