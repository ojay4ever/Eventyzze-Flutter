import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/views/eventScreens/event_payment_detail.dart';
import 'package:flutter/material.dart';
import '../../constants/enums.dart';
import '../../helper/navigation_helper.dart';

class SubscriptionPrompt extends StatefulWidget {
  const SubscriptionPrompt({super.key});

  @override
  State<SubscriptionPrompt> createState() => _SubscriptionPromptState();
}

class _SubscriptionPromptState extends State<SubscriptionPrompt> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.5.h),
              _buildHeader(context),
              SizedBox(height: 4.5.h),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPlanCard(
                        context,
                        title: "Bronze",
                        price: "\$20",
                        description: "1 show/month",
                        color: const Color(0xFFDCC09B),
                        index: 0,
                      ),
                      SizedBox(height: 2.h),
                      _buildPlanCard(
                        context,
                        title: "Silver",
                        price: "\$40",
                        description: "2 shows/month",
                        color: const Color(0xFFAAAAAA),
                        index: 1,
                      ),
                      SizedBox(height: 2.h),
                      _buildPlanCard(
                        context,
                        title: "Gold",
                        price: "\$80",
                        description: "4 shows/month",
                        color: const Color(0xFFFFD579),
                        index: 2,
                      ),
                      SizedBox(height: 2.h),
                      _buildPlanCard(
                        context,
                        title: "Platinum",
                        price: "\$100",
                        description: "10 shows/month",
                        color: const Color(0xFF959595),
                        index: 3,
                        isRecommended: true,
                      ),
                      SizedBox(height: 4.5.h),
                      Text(
                        "If you choose to purchase a subscription plan, payments will be charged to your preferred payment option, and your account will be charged. You can cancel the automatic renewal of your subscription anytime.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: AppFonts.lato,
                          fontSize: 1.6.h,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      CustomButton(
                        text: "Continue",
                        backgroundColor: const Color(0xFFFF8038),
                        onTap: () {
                          NavigationHelper.goToNavigatorScreen(
                            context,
                            const EventPaymentDetail(),
                          );
                        },
                      ),
                      SizedBox(height: 3.6.h),
                    ],
                  ),
                ),
              ),
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
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 28,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          "Select a plan",
          style: theme.textTheme.displayLarge?.copyWith(
            fontFamily: AppFonts.lato,
            fontWeight: FontWeight.w700,
            fontSize: 2.4.h,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(
      BuildContext context, {
        required String title,
        required String price,
        required String description,
        required Color color,
        required int index,
        bool isRecommended = false,
      }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   _selectedPlanIndex = index;
        // });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.5.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border:
          Border.all(color: Color(0xFF555555).withValues(alpha: 0.5), width: 1),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: AppFonts.lato,
                    fontSize: 2.0.h,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  price,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: AppFonts.lato,
                    fontSize: 2.0.h,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            if (isRecommended) ...[
              SizedBox(height: 2.0.h),
              Text(
                "(Recommended)",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: AppFonts.lato,
                  fontSize: 1.5.h,
                  color: const Color(0xFFFF8038),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            SizedBox(height: isRecommended ? 1.2.h : 2.0.h),

            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 2.0.h,
                ),
                SizedBox(width: 2.w),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: AppFonts.lato,
                    fontSize: 1.4.h,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
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