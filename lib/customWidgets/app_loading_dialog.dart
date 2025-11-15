import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_theme.dart';

class AppLoadingDialog {
  static bool _isShowing = false;

  static void show({String? message}) {
    if (_isShowing) return;

    _isShowing = true;
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          _isShowing = false;
          return true;
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.kPrimaryColor,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true, // Allow dismissing by tapping outside
    ).then((_) {
      _isShowing = false;
    });
  }

  static void hide() {
    if (_isShowing && (Get.isDialogOpen ?? false)) {
      try {
        Get.back();
        _isShowing = false;
      } catch (e) {
        // Dialog already closed or disposed
        _isShowing = false;
      }
    }
  }
}
