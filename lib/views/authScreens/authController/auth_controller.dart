import 'package:eventyzze/utils/custom_snack_bar.dart';
import 'package:eventyzze/views/authScreens/emailConfirm/email_confirm_screen.dart';
import 'package:eventyzze/views/homeScreens/home_page_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
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
        CustomSnackBar.error(title: 'Verification Needed', message: 'Please verify your email before logging in.');
        return;
      }

      CustomSnackBar.success(title: 'Success', message: 'Login successful!');
      Get.offAll(() => HomePageViewer());

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomSnackBar.error(title: 'Error', message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        CustomSnackBar.error(title: 'Error', message: 'Wrong password provided.');
      } else if (e.code == 'invalid-email') {
        CustomSnackBar.error(title: 'Error', message: 'The email address is not valid.');
      } else {
        CustomSnackBar.error(title: 'Error', message: e.message ?? 'An unknown error occurred.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
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

      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user!.sendEmailVerification();

      Get.off(() => ConfirmEmailScreen());

      CustomSnackBar.success(title: 'Success', message: 'Account created! A verification email has been sent to your email.');

    } on FirebaseAuthException catch (e) {
      CustomSnackBar.error(title: 'Error', message: e.message ?? 'An unknown error occurred.');
    } finally {
      isLoading.value = false;
    }
  }
}
