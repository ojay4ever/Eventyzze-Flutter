import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/config/app_images.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/enums.dart';
import '../pubscriptionPrompt/successful_payment_screen.dart';

class EventPaymentDetail extends StatefulWidget {
  const EventPaymentDetail({super.key});

  @override
  State<EventPaymentDetail> createState() => _EventPaymentDetailState();
}

class _EventPaymentDetailState extends State<EventPaymentDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.4.w),
          child: Column(
            children: [
              SizedBox(height: 2.5.h),
              _buildHeader(context),
              SizedBox(height: 4.5.h),
              _buildPaymentOptions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
        ),
        SizedBox(width: 2.w),
        Text(
          "Choose payment option",
          style: theme.textTheme.displayLarge?.copyWith(
            fontFamily: AppFonts.lato,
            fontWeight: FontWeight.w700,
            fontSize: 2.4.h,
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptions(BuildContext context) {
    return Column(
      children: [
        _buildOptionCard(
          context: context,
          image: AppImages.wallet,
          label: "My Wallet",
          onTap: () {
            NavigationHelper.goToNavigatorScreen(
              context,
              SuccessfulPaymentScreen(),
            );
          },
        ),
        SizedBox(height: 2.4.h),
        _buildOptionCard(
          context: context,
          image: AppImages.cash_Out,
          label: "Bank Transfer",
          onTap: () {},
        ),
        SizedBox(height: 2.4.h),
        _buildOptionCard(
          context: context,
          image: AppImages.payStack,
          label: "Paystack",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String image,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 7.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7E8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              height: 3.h,
              width: 3.h,
              child: SvgPicture.asset(image, fit: BoxFit.contain),
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontFamily: AppFonts.lato,
                fontWeight: FontWeight.w500,
                fontSize: 2.h,
                color: Colors.black,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
