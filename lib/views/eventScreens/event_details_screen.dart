import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/config/app_images.dart';
import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/constants/enums.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:flutter/material.dart';

import 'event_payment_detail.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int _selectedTabIndex = 0;
  bool _showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 0.h,
            left: 0.w,
            right: 0.w,
            child: Container(
              height: 65.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.man),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 5.h,
            left: 2.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: AppTheme.white, size: 3.h),
              ),
            ),
          ),
          Positioned(
            bottom: 0.h,
            left: 0.w,
            right: 0.w,
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dan the creator',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppFonts.inter,
                                  color: AppTheme.lightBlacks,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                '14th Nov. 2024',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.greyColor2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '25% discount',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.kPrimaryColor,
                              ),
                            ),
                            Text(
                              '(Early birds)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: AppFonts.lato,
                                color: AppTheme.grey,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTab('About event', 0, theme),
                          SizedBox(width: 4.w),
                          _buildTab('About creator', 1, theme),
                          SizedBox(width: 4.w),
                          _buildTab('Booking inform', 2, theme),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    _buildDescription(theme),
                    SizedBox(height: 2.8.h),
                    CustomButton(
                      text: 'Book Ticket',
                      onTap: () {
                        NavigationHelper.goToNavigatorScreen(context, const EventPaymentDetail());
                      },
                      backgroundColor: AppTheme.kPrimaryColor,
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index, ThemeData theme) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.kPrimaryColor.withValues(alpha: 0.15)
              : AppTheme.greyLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w400 : FontWeight.w500,
            color: isSelected ? AppTheme.kPrimaryColor : AppTheme.greyColor2,
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    const fullDescription =
        'Lorem ipsum sit dolor amet, consectur adispiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat';
    const shortDescription =
        'Lorem ipsum sit dolor amet, consectur adispiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ut enim ad minim veniam...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _showFullDescription ? fullDescription : shortDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.greyColor2,
            height: 1.5,
          ),
        ),
         SizedBox(height: 0.8.h),
        GestureDetector(
          onTap: () {
            setState(() {
              _showFullDescription = !_showFullDescription;
            });
          },
          child: Text(
            _showFullDescription ? 'Read Less' : 'Read More',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
