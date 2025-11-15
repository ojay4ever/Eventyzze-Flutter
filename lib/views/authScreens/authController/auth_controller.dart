import 'dart:developer';
import 'dart:io';
import 'package:eventyzze/cache/shared_preferences_helper.dart';
import 'package:eventyzze/config/get_it.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/repositories/profileRepository/profile_repository.dart';
import 'package:eventyzze/utils/custom_snack_bar.dart';
import 'package:eventyzze/views/authScreens/emailConfirm/email_confirm_screen.dart';
import 'package:eventyzze/views/homeScreens/home_page_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../repositories/authRepository/auth_repository.dart';
import '../../../services/socket_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ProfileRepository _profileRepository = getIt<ProfileRepository>();
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final SharedPrefsHelper _sharedPrefsHelper = getIt<SharedPrefsHelper>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString nameError = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    emailError.value = '';
    passwordError.value = '';

    if (emailController.text.isEmpty) {
      emailError.value = 'Please enter your email.';
    }
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Please enter your password.';
    }

    if (emailError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      return;
    }

    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!userCredential.user!.emailVerified) {
        CustomSnackBar.error(
          title: 'Verification Needed',
          message: 'Please verify your email before logging in.',
        );
        return;
      }

      CustomSnackBar.success(title: 'Success', message: 'Login successful!');
      Get.offAll(() => HomePageViewer());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomSnackBar.error(
          title: 'Error',
          message: 'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        CustomSnackBar.error(
          title: 'Error',
          message: 'Wrong password provided.',
        );
      } else if (e.code == 'invalid-email') {
        CustomSnackBar.error(
          title: 'Error',
          message: 'The email address is not valid.',
        );
      } else {
        CustomSnackBar.error(
          title: 'Error',
          message: e.message ?? 'An unknown error occurred.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    emailError.value = '';
    passwordError.value = '';
    nameError.value = '';

    // Validation
    if (nameController.text.isEmpty) {
      nameError.value = 'Please enter your name.';
    }
    if (emailController.text.isEmpty) {
      emailError.value = 'Please enter your email.';
    }
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Please enter your password.';
    }

    if (emailError.value.isNotEmpty ||
        passwordError.value.isNotEmpty ||
        nameError.value.isNotEmpty) {
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Please enter a valid email.';
      return;
    }
    if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters.';
      return;
    }

    try {
      isLoading.value = true;

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      await userCredential.user!.updateDisplayName(nameController.text.trim());

      final idToken = await userCredential.user!.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      await userCredential.user!.sendEmailVerification();

      NavigationHelper.goToNavigatorScreen(Get.context!, ConfirmEmailScreen());

      CustomSnackBar.success(
        title: 'Success',
        message:
            'Account created! A verification email has been sent to your email.',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        CustomSnackBar.error(
          title: 'Error',
          message: 'An account already exists with this email.',
        );
      } else if (e.code == 'weak-password') {
        passwordError.value = 'Password is too weak.';
      } else {
        CustomSnackBar.error(
          title: 'Error',
          message: e.message ?? 'An unknown error occurred.',
        );
      }
    } catch (e) {
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to create account. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> signInWithGoogle() async {
    User? user;

    try {
      isLoading.value = true;
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
          .signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );

        if (userCredential.user!.email != null &&
            userCredential.user!.uid.isNotEmpty) {
          user = userCredential.user;

          await _sharedPrefsHelper.setUserId(user!.uid);

          final deviceId = await _getDeviceId();

          final userData = {
            "uid": user.uid,
            "name": user.displayName ?? "Anonymous",
            "email": user.email ?? "",
            "deviceId": deviceId,
          };

          try {
            final savedUser = await _authRepository.register(userData);

            if (savedUser == null) {
              CustomSnackBar.error(
                title: "Limit Reached",
                message:
                    "You already created 3 accounts on this device. Please login with one of them.",
              );
              isLoading.value = false;
              return null;
            }
            final fcmToken = await FirebaseMessaging.instance.getToken();
            if (fcmToken != null && fcmToken.isNotEmpty) {
              Map<String, dynamic> req = {
                'fcmToken': fcmToken,
                'dbId': savedUser.dbId,
              };
              await _profileRepository.updateFcmToken(req);
            }

            await _sharedPrefsHelper.setDatabaseId(savedUser.dbId);

            final fetchedUser = await _profileRepository.getProfile(
              savedUser.dbId,
            );

            if (fetchedUser == null) {
              CustomSnackBar.error(
                title: "Error",
                message: "Failed to fetch user profile",
              );
              isLoading.value = false;
              return null;
            }

            SocketService().connect(fetchedUser.dbId);

            CustomSnackBar.success(
              title: 'Success',
              message: 'Signed in with Google successfully!',
            );

            Get.offAll(() => HomePageViewer());
          } on Exception catch (e) {
            final errorMsg = e.toString();
            if (errorMsg.contains("Maximum 3 accounts")) {
              CustomSnackBar.error(
                title: "Limit Reached",
                message:
                    "Already created 3 accounts on this device. Please login with one of them.",
              );
            } else {
              CustomSnackBar.error(
                title: "Error",
                message: "Something went wrong. Try again.",
              );
            }
            isLoading.value = false;
            return null;
          }
        }
      }

      isLoading.value = false;
      return user;
    } catch (e) {
      log("signInWithGoogle error: $e");
      CustomSnackBar.error(
        title: "Error",
        message: "Google Sign-In failed. Try again.",
      );
      isLoading.value = false;
      return null;
    }
  }

  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('device_id', deviceId);
    }
    return deviceId;
  }

  Future<User?> signInWithApple() async {
    User? user;

    try {
      if (!Platform.isIOS && !Platform.isMacOS) {
        CustomSnackBar.error(
          title: 'Not Available',
          message: 'Apple Sign In is only available on iOS and macOS devices.',
        );
        return null;
      }

      isLoading.value = true;

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final authResult = await _auth.signInWithCredential(oauthCredential);

      user = authResult.user;

      if (user != null) {
        String? email = credential.email;
        if (email == null || email.trim().isEmpty) {
          email = user.email;
          if (email == null || email.trim().isEmpty) {
            CustomSnackBar.error(
              title: 'Error',
              message:
                  'Unable to get email from Apple account. Please try again.',
            );
            isLoading.value = false;
            return null;
          }
        }

        final displayName =
            credential.givenName != null && credential.familyName != null
            ? '${credential.givenName} ${credential.familyName}'
            : user.displayName ?? 'User';

        await _sharedPrefsHelper.setUserId(user.uid);

        final deviceId = await _getDeviceId();

        final userData = {
          "uid": user.uid,
          "name": displayName,
          "email": email,
          "deviceId": deviceId,
        };

        try {
          final savedUser = await _authRepository.register(userData);

          if (savedUser == null) {
            CustomSnackBar.error(
              title: "Limit Reached",
              message:
                  "You already created 3 accounts on this device. Please login with one of them.",
            );
            isLoading.value = false;
            return null;
          }

          // Update FCM token
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null && fcmToken.isNotEmpty) {
            Map<String, dynamic> req = {
              'fcmToken': fcmToken,
              'dbId': savedUser.dbId,
            };
            await _profileRepository.updateFcmToken(req);
          }

          await _sharedPrefsHelper.setDatabaseId(savedUser.dbId);

          final fetchedUser = await _profileRepository.getProfile(
            savedUser.dbId,
          );

          if (fetchedUser == null) {
            CustomSnackBar.error(
              title: "Error",
              message: "Failed to fetch user profile",
            );
            isLoading.value = false;
            return null;
          }

          // Connect socket
          SocketService().connect(fetchedUser.dbId);

          CustomSnackBar.success(
            title: 'Success',
            message: 'Signed in with Apple successfully!',
          );

          Get.offAll(() => HomePageViewer());
        } on Exception catch (e) {
          final errorMsg = e.toString();
          if (errorMsg.contains("Maximum 3 accounts")) {
            CustomSnackBar.error(
              title: "Limit Reached",
              message:
                  "Already created 3 accounts on this device. Please login with one of them.",
            );
          } else {
            CustomSnackBar.error(
              title: "Error",
              message: "Something went wrong. Try again.",
            );
          }
          isLoading.value = false;
          return null;
        }
      }

      isLoading.value = false;
      return user;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code != AuthorizationErrorCode.canceled) {
        CustomSnackBar.error(
          title: 'Error',
          message: 'Failed to sign in with Apple: ${e.message}',
        );
      }
      // User canceled - no need to show error
      isLoading.value = false;
      return null;
    } catch (e) {
      log("❌ signInWithApple error: $e");
      CustomSnackBar.error(
        title: "Error",
        message: "Apple Sign-In failed. Try again.",
      );
      isLoading.value = false;
      return null;
    }
  }
}
