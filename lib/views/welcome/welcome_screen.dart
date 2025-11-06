import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/config/app_images.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import '../authScreens/signUpScreen/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF2F2F2), Color(0xFFA0A0A0)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildStack(context),
                    const SizedBox(height: 80),
                    _buildDottedArc(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStack(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 420,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Eventyze",
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 34,
                ),
              ),
            ],
          ),
          Positioned(top: 0, right: 0, child: _roundedImage(AppImages.first)),
          Positioned(top: 130, left: 0, child: _roundedImage(AppImages.night)),
          Positioned(top: 250, right: 0, child: _roundedImage(AppImages.girl)),
        ],
      ),
    );
  }

  Widget _roundedImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        imagePath,
        width: 150,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildDottedArc(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Center(
          child: Text(
            "Experience a world\nof Entertainment!",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.sans,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            "Stream and replay live\nevents on eventyze",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.black,
              fontFamily: AppFonts.sans,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 50),
        Center(
          child: GestureDetector(
            onTap: (){
              NavigationHelper.goToNavigatorScreen(context, const SignUpScreen());
            },
            child: Container(
              width: 160,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30),
                border: GradientBoxBorder(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF082EB4),
                      Color(0xFF51468F),
                      Color(0xFFFF8038),
                    ],
                  ),
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  "Sign up",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
