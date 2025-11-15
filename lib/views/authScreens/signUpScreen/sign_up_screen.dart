import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/config/app_images.dart';
import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/customWidgets/custom_text_field.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/views/authScreens/loginScreen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authController/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create an Account',
                  style: TextStyle(
                    fontFamily: AppFonts.inter,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Create an account with Eventyze and explore a world of endless entertainment',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.inter,
                    fontSize: 16,
                    color: const Color(0xFF000000).withAlpha(128),
                  ),
                ),
                SizedBox(height: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: 'Full Name',
                      controller: controller.nameController,
                    ),
                    Obx(() {
                      if (controller.nameError.value.isEmpty) {
                        return SizedBox.shrink();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                          child: Text(
                            controller.nameError.value,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        );
                      }
                    }),
                  ],
                ),
                SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: 'Email',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Obx(() {
                      if (controller.emailError.value.isEmpty) {
                        return SizedBox.shrink();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                          child: Text(
                            controller.emailError.value,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        );
                      }
                    }),
                  ],
                ),
                SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: 'Password',
                      controller: controller.passwordController,
                      obscureText: true,
                    ),
                    Obx(() {
                      if (controller.passwordError.value.isEmpty) {
                        return SizedBox.shrink();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                          child: Text(
                            controller.passwordError.value,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        );
                      }
                    }),
                  ],
                ),
                SizedBox(height: 24),
                Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.kPrimaryColor,
                          ),
                        )
                      : CustomButton(
                          text: 'Create an account',
                          onTap: controller.signUp,
                        ),
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey.withAlpha(128),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Text(
                        "or",
                        style: TextStyle(
                          color: Colors.grey.withAlpha(179),
                          fontSize: 16,
                          fontFamily: AppFonts.lato,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey.withAlpha(128),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.kPrimaryColor,
                          ),
                        )
                      : CustomButton(
                          text: "Continue with Google",
                          onTap: () async {
                            await controller.signInWithGoogle();
                          },
                          backgroundColor: Colors.white,
                          borderColor: Color(0xFFFF8038),
                          imagePath: AppImages.google,
                        ),
                ),
                SizedBox(height: 14),
                Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.kPrimaryColor,
                          ),
                        )
                      : CustomButton(
                          text: "Continue with Apple",
                          onTap: () async {
                            await controller.signInWithApple();
                          },
                          backgroundColor: Colors.white,
                          borderColor: Color(0xFFFF8038),
                          imagePath: AppImages.apple,
                        ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigationHelper.goToNavigatorScreen(
                          context,
                          LoginScreen(),
                        );
                      },
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF8038),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
