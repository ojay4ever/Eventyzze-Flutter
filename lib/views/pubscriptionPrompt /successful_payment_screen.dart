import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/constants/enums.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/customWidgets/home_tab.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:flutter/material.dart';
import '../../config/app_font.dart';

class SuccessfulPaymentScreen extends StatefulWidget {
  const SuccessfulPaymentScreen({super.key});

  @override
  State<SuccessfulPaymentScreen> createState() =>
      _SuccessfulPaymentScreenState();
}

class _SuccessfulPaymentScreenState extends State<SuccessfulPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: AppTheme.greenColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check_outlined,
                    color: AppTheme.white,
                    size: 25.w,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Payment success!',
                style: TextStyle(
                  fontSize: 6.w,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.greenColor,
                ),
              ),
              SizedBox(height: 2.0.h),
              _buildSuccessMessage(context),
              SizedBox(height: 4.0.h),
              CustomButton(
                text: 'Continue',
                onTap: () {
                  NavigationHelper.goToNavigatorScreen(context, HomeTab());
                },
                backgroundColor: AppTheme.kButtonColor,
              ),
              SizedBox(height: 4.0.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 1.7.h,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontFamily: AppFonts.lato,
        ),
        children: [
          const TextSpan(text: 'Thank you, your payment for '),
          TextSpan(
            text: 'SHINE ON MUSIC FESTIVAL',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 1.8.h,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const TextSpan(
            text:
                ' was successful. You will receive email confirmation shortly.',
          ),
        ],
      ),
    );
  }
}
