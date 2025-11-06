import 'dart:async';
import 'package:eventyzze/enums/enums.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/views/authScreens/profielSetUp/profile_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../config/app_utils.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  String _otp = "";
  int _seconds = 60;
  late Timer _timer;

  Color greyColor = const Color(0xFF949494);
  Color activeColor = const Color(0xFFFF8038);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  bool get isOtpFilled => _otp.length == 5;
  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.init(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Text(
                "Confirm Email",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                "Kindly enter the 5 digit passcode sent to your email to continue registration",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              OtpTextField(
                numberOfFields: 5,
                borderRadius: BorderRadius.circular(12),
                fieldWidth: 55,
                showFieldAsBox: true,
                keyboardType: TextInputType.number,
                focusedBorderColor: activeColor,
                borderWidth: 2,
                cursorColor: Colors.black,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                enabledBorderColor: Colors.grey.shade400,
                onCodeChanged: (value) {
                  setState(() => _otp = value);
                },
                onSubmit: (value) {
                  setState(() => _otp = value);
                },
              ),

              const SizedBox(height: 12),

              Text(
                "Code expires in 0:${_seconds.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 13,
                  color: _seconds <= 20 ? Colors.red : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildResendCode(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResendCode(BuildContext context) {
   return Column(
     children: [
       SizedBox(height: 20.h,)
       ,
       GestureDetector(
         onTap: isOtpFilled ? () {
           NavigationHelper.goToNavigatorScreen(context, ProfileSetupScreen());
         } : null,
         child: _buildConfirmButton(context),
       ),

       const SizedBox(height: 18),

       Row(
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Text(
             "Didn't get a code? ",
             style: TextStyle(color: Colors.grey[700]),
           ),
           GestureDetector(
             onTap: () {},
             child: Text(
               "Resend Code",
               style: TextStyle(
                 color: activeColor,
                 fontWeight: FontWeight.w600,
               ),
             ),
           ),
         ],
       ),
       const SizedBox(height: 20),
     ],
   );
  }

  Widget _buildConfirmButton(BuildContext context) {
    final theme = Theme.of(context);
    Color buttonColor = isOtpFilled ? const Color(0xFFFF8038) : const Color(
        0xFF949494);
    return
      Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            "Continue",
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

      );
  }
}
