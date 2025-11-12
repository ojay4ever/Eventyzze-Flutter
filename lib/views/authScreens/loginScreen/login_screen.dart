import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/views/authScreens/authController/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text_field.dart';
import '../signUpScreen/sign_up_screen.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                "Welcome Back",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontFamily: AppFonts.inter,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "We missed you, great you weren’t gone for so long",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: AppFonts.lato,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.lightBlacks,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: controller.emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 24),

              Obx(() => controller.isLoading.value
                  ? Center(child: CircularProgressIndicator(color: AppTheme.kPrimaryColor,))
                  : CustomButton(
                text: "Log in",
                onTap: controller.login,
                backgroundColor: const Color(0xFFFF8038),
              )),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontFamily: AppFonts.lato,
                      color: AppTheme.lightBlacks,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey.withValues(alpha: 0.5),
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
                          fontWeight: FontWeight.w400
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
              const SizedBox(height: 10),
              CustomButton(
                text: "Create an Account",
                backgroundColor: Colors.white,
                borderColor: const Color(0xFFFF8038),
                onTap: () {
                  NavigationHelper.goToNavigatorScreen(context, const SignUpScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
