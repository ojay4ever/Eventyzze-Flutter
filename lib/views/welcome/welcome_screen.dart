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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final double sectionHeight = height * 0.55;
    final double imgWidth = width * 0.35;
    final double imgHeight = sectionHeight * 0.40;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFE0E0E0),
              Color(0xFFD8BFD8),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: height * 0.02),
              SizedBox(
                height: sectionHeight,
                width: width,
                child: Stack(
                  children: [
                    Positioned(
                      left: width * 0.08,
                      top: sectionHeight * 0.08,
                      child: Text(
                        "Eventyzze",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: width * 0.08,
                        ),
                      ),
                    ),
                    Positioned(
                      right: width * 0.05,
                      top: sectionHeight * 0.04,
                      child: _responsiveImage(
                          AppImages.first, imgWidth, imgHeight),
                    ),

                    Positioned(
                      left: width * 0.05,
                      top: sectionHeight * 0.33,
                      child: _responsiveImage(
                          AppImages.night, imgWidth, imgHeight),
                    ),
                    Positioned(
                      right: width * 0.05,
                      top: sectionHeight * 0.62,
                      child: _responsiveImage(
                          AppImages.girl, imgWidth, imgHeight),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Experience a world\nof Entertainment!",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.sans,
                        color: Colors.black,
                        fontSize: width * 0.07,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.015),
                    Text(
                      "Stream and replay live\nevents on eventyze",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[800],
                        fontFamily: AppFonts.sans,
                        fontWeight: FontWeight.w400,
                        fontSize: width * 0.04,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),

                    GestureDetector(
                      onTap: () {
                        NavigationHelper.goToNavigatorScreen(
                            context, const SignUpScreen());
                      },
                      child: Container(
                        width: width * 0.5,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: const GradientBoxBorder(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF082EB4),
                                Color(0xFF51468F),
                                Color(0xFFFF8038),
                              ],
                            ),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Sign up",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _responsiveImage(String path, double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}