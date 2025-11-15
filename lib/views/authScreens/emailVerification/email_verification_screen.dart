import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/customWidgets/app_loading_indicator.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/customWidgets/custom_logout_dialog.dart';
import 'package:eventyzze/views/authScreens/emailVerification/email_verification_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailVerificationController());
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.error),
            onPressed: () async {
              final result = await CustomLogoutDialog.show(context);
              if (result == true) {
                await controller.logout();
              }
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Verify Your Email',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We\'ve sent a verification email to:',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              if (user?.email != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.kPrimaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.kPrimaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: AppTheme.kPrimaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          user!.email!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              Text(
                'Please check your email and click the verification link to activate your account.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => controller.isResending.value
                    ? const AppLoadingIndicator(
                        message: 'Sending verification email...',
                      )
                    : CustomButton(
                        text: 'Resend Verification Email',
                        onTap: controller.resendVerificationEmail,
                        backgroundColor: AppTheme.kPrimaryColor,
                      ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => controller.isChecking.value
                    ? const AppLoadingIndicator(
                        message: 'Checking verification status...',
                      )
                    : CustomButton(
                        text: 'I\'ve Verified My Email',
                        onTap: controller.checkEmailVerification,
                        backgroundColor: Colors.white,
                        borderColor: AppTheme.kPrimaryColor,
                      ),
              ),
              const Spacer(),
              Text(
                'Didn\'t receive the email?',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Check your spam/junk folder\n• Make sure the email address is correct\n• Wait a few minutes and try resending',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
