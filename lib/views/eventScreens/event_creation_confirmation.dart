import 'package:eventyzze/config/app_images.dart';
import 'package:eventyzze/constants/enums.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/customWidgets/home_tab.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:flutter/material.dart';
import '../../config/app_font.dart';

class EventCreationConfirmation extends StatelessWidget {
  const EventCreationConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [_buildTicketCard(),
            const SizedBox(height: 10),
            _buildSuccessText(),
            const SizedBox(height: 20),
            _buildActionButtons(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  Widget _buildTicketCard() {
    return SizedBox(
      height: 94.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 9.h,
            left: 1.8.w,
            right: 1.8.w,
            child: Container(
              height: 80.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCACACA),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          Positioned(
            top: 11.h,
            left: 5.w,
            right: 5.w,
            child: Container(
              height: 33.h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                image: DecorationImage(
                  image: AssetImage(AppImages.confirmation),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 45.h,
            left: 5.w,
            right: 5.w,
            child: Container(
              height: 42.h,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Shine On Music Festival",
                    style: TextStyle(
                      fontSize: 2.3.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "24th Sept. 2024\n8:00pm (prompt)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 1.5.h,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  Row(
                    children: List.generate(
                      150 ~/ 3,
                          (index) => Expanded(
                        child: Container(
                          color: index % 2 == 0
                              ? Colors.transparent
                              : Colors.grey[300],
                          height: 0.2.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Lorem ipsum sit dolor amet, consectur adispiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ut enim ad minim veniam...",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Read More",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF8038),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.8.h),
                  const Text(
                    "5,000 NGN (Early birds)",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: AppFonts.inter,
                    ),
                  ),
                  SizedBox(height: 2.5.h),
                ],
              ),
            ),
          ),
          Positioned(
            top: 76.h,
            left: 1.8.w,
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCACACA),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            top: 76.h,
            right: 1.7.w,
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCACACA),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessText() {
    return const Text(
      "Event created successfully!",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "Continue",
              backgroundColor: const Color(0xFFFF8038),
              textColor: Colors.white,
              onTap: () {
                NavigationHelper.goToNavigatorScreen(context, HomeTab());
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              text: "Share",
              backgroundColor: Colors.white,
              borderColor: const Color(0xFFFF8038),
              textColor: Colors.black,
              onTap: () {
              },
            ),
          ),
        ],
      ),
    );
  }
}