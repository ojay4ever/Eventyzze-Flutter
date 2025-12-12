import 'package:eventyzze/config/app_images.dart';
import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../constants/enums.dart';

class UpgradePrompt extends StatefulWidget {
  const UpgradePrompt({super.key});

  @override
  State<UpgradePrompt> createState() => _UpgradePromptState();
}

class _UpgradePromptState extends State<UpgradePrompt> {
  final List<String> features = [
    'Lorem ipsum sit dolor amet consectetur',
    'Lorem ipsum sit dolor amet consectetur',
    'Lorem ipsum sit dolor amet consectetur',
    'Lorem ipsum sit dolor amet consectetur',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1D1D),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: BottomCurveClipper(),
                  child: Container(
                    height: 50.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.man1),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: BottomCurveClipper(),
                    child: Container(
                      height: 2.0.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF191919).withValues(alpha: 0.8),
                            const Color(0xFF191919),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.4.w),
              child: Column(
                children: [
                  Text(
                    'Lights, Camera, Action',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 2.8.h,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Upgrade your Eventyzze plan to host shows',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 1.6.h,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Column(
                    children: features.map((feature) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(0.5.h),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.white, width: 1.5),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 1.5.h,
                                color: AppTheme.white,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                feature,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 1.6.h,
                                  color: AppTheme.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 5.h),

                  CustomButton(
                    text: 'Upgrade',
                    onTap: () {
                    },
                    backgroundColor: const Color(0xFFFF8038),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 60);

    path.quadraticBezierTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        firstEndPoint.dx,
        firstEndPoint.dy
    );

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}