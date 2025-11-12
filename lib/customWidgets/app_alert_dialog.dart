import 'package:flutter/material.dart';

import '../config/app_theme.dart';



class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    required this.title,
    required this.message,
    this.cancelText = 'No',
    this.confirmText = 'Yes',
    this.onConfirm,
    this.confirmButtonColor,
    super.key,
  });
  final String title;
  final String message;
  final String? cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;
  final Color? confirmButtonColor;

  /// Two-button confirm dialog
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = 'No',
    String confirmText = 'Yes',
    Color? confirmButtonColor,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AppAlertDialog(
          title: title,
          message: message,
          cancelText: cancelText,
          confirmText: confirmText,
          confirmButtonColor: confirmButtonColor,
          onConfirm: onConfirm,
        );
      },
    );
  }

  /// One-button alert/info dialog
  static Future<void> simple({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    Color? confirmButtonColor,
    VoidCallback? onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AppAlertDialog(
          title: title,
          message: message,
          cancelText: null, // no cancel button
          confirmText: confirmText,
          confirmButtonColor: confirmButtonColor,
          onConfirm: onConfirm,
        );
      },
    );
  }

  /// Fully custom child dialog
  static Future<T?> custom<T>({
    required BuildContext context,
    required Widget child,
    Color backgroundColor = Colors.black,
    double borderRadius = 16,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: <Widget>[
        if (cancelText != null)
          TextButton(
            child: Text(cancelText!, style: TextStyle(color: Colors.grey[300])),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: confirmButtonColor ?? Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
            if (onConfirm != null) onConfirm?.call();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}





























































































































































