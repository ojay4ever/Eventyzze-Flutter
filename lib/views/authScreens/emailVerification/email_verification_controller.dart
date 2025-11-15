import 'package:eventyzze/cache/shared_preferences_helper.dart';
import 'package:eventyzze/config/get_it.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/repositories/authRepository/auth_repository.dart';
import 'package:eventyzze/services/auth_services.dart';
import 'package:eventyzze/utils/custom_snack_bar.dart';
import 'package:eventyzze/views/authScreens/profielSetUp/profile_setup_screen.dart';
import 'package:eventyzze/views/welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final SharedPrefsHelper _sharedPrefsHelper = getIt<SharedPrefsHelper>();

  final RxBool isResending = false.obs;
  final RxBool isChecking = false.obs;

  Future<void> resendVerificationEmail() async {
    try {
      isResending.value = true;
      final user = _auth.currentUser;

      if (user == null) {
        CustomSnackBar.error(
          title: 'Error',
          message: 'No user found. Please sign up again.',
        );
        isResending.value = false;
        return;
      }

      await user.sendEmailVerification();

      CustomSnackBar.success(
        title: 'Success',
        message: 'Verification email sent! Please check your inbox.',
      );
    } catch (e) {
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to send verification email: ${e.toString()}',
      );
    } finally {
      isResending.value = false;
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      isChecking.value = true;
      final user = _auth.currentUser;

      if (user == null) {
        CustomSnackBar.error(
          title: 'Error',
          message: 'No user found. Please sign up again.',
        );
        isChecking.value = false;
        return;
      }

      // Reload user to get latest email verification status
      await user.reload();

      // Wait a moment for Firebase to propagate email verification status
      await Future.delayed(const Duration(milliseconds: 500));

      // Reload again to ensure we have the latest status
      await user.reload();

      final updatedUser = _auth.currentUser;

      if (updatedUser?.emailVerified ?? false) {
        // Check if user is already registered in database
        final dbId = await _sharedPrefsHelper.getDatabaseId();

        if (dbId.isEmpty) {
          // User not registered yet, register them FIRST (before getting token)
          final registerData = {
            'uid': updatedUser!.uid,
            'name':
                updatedUser.displayName ??
                updatedUser.email?.split('@')[0] ??
                'User',
            'email': updatedUser.email ?? '',
          };

          final registeredUser = await _authRepository.register(registerData);

          if (registeredUser != null && registeredUser.dbId.isNotEmpty) {
            await _sharedPrefsHelper.setDatabaseId(registeredUser.dbId);
          } else {
            CustomSnackBar.error(
              title: 'Error',
              message: 'Failed to register user. Please try again.',
            );
            isChecking.value = false;
            return;
          }
        }

        // After user is registered in database, get a fresh token
        // Force refresh to ensure email verification is reflected in token
        try {
          // Clear any cached token first
          await AuthService().clearToken();

          // Wait a bit more for Firebase to fully propagate
          await Future.delayed(const Duration(milliseconds: 500));

          // Force a fresh token refresh after email verification
          final freshToken = await updatedUser!.getIdToken(true);
          if (freshToken == null || freshToken.isEmpty) {
            CustomSnackBar.error(
              title: 'Error',
              message: 'Failed to get authentication token. Please try again.',
            );
            isChecking.value = false;
            return;
          }

          // Store the fresh token using AuthService
          final storedToken = await AuthService().getBearerToken();
          if (storedToken == null || storedToken.isEmpty) {
            CustomSnackBar.error(
              title: 'Error',
              message:
                  'Failed to store authentication token. Please try again.',
            );
            isChecking.value = false;
            return;
          }
        } catch (e) {
          CustomSnackBar.error(
            title: 'Error',
            message: 'Failed to refresh authentication token: ${e.toString()}',
          );
          isChecking.value = false;
          return;
        }

        CustomSnackBar.success(
          title: 'Success',
          message: 'Email verified successfully!',
        );

        // Navigate to profile setup screen after email verification
        final context = Get.context;
        if (context != null) {
          NavigationHelper.goToNavigatorScreen(
            context,
            const ProfileSetupScreen(),
            finish: true,
            back: false,
          );
        }
      } else {
        CustomSnackBar.warning(
          title: 'Not Verified',
          message:
              'Please verify your email by clicking the link in the email we sent.',
        );
      }
    } catch (e) {
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to check verification status: ${e.toString()}',
      );
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _sharedPrefsHelper.clearAll();
      Get.offAll(() => const WelcomeScreen());
      CustomSnackBar.success(
        title: 'Success',
        message: 'Logged out successfully!',
      );
    } catch (e) {
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to logout: ${e.toString()}',
      );
    }
  }
}
