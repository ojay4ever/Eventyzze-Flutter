import 'package:eventyzze/config/app_font.dart';
import 'package:flutter/material.dart';
import '../../../config/app_images.dart';

class SignUpLastScreen extends StatefulWidget {
  const SignUpLastScreen({super.key});

  @override
  State<SignUpLastScreen> createState() => _SignUpLastScreenState();
}

class _SignUpLastScreenState extends State<SignUpLastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.signup),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(),
            Text(
              'Eventyze',
              style: TextStyle(
                fontFamily: AppFonts.inter,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                Container(
                  width: 20,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                Container(
                  width: 16,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
