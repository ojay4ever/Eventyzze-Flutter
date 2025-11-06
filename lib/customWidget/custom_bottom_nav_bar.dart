import 'package:eventyzze/config/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/app_images.dart';
import '../config/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color selectedColor;
  final Color unselectedColor;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor = AppTheme.kPrimaryColor,
    this.unselectedColor = const Color(0xFF808191),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slotWidth = constraints.maxWidth / 5;
          const double indicatorWidth = 50;

          final visualIndex = currentIndex >= 2 ? currentIndex + 1 : currentIndex;

          final double indicatorLeft =
              visualIndex * slotWidth + (slotWidth - indicatorWidth) / 2;

          return Stack(
            children: [
              Container(
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildNavItem(AppImages.home, "Home", 0),
                    ),
                    Expanded(
                      child: _buildNavItem(AppImages.heart, "Favourite", 1),
                    ),
                    Expanded(
                      child: _buildCenterButton(),
                    ),
                    Expanded(
                      child: _buildNavItem(AppImages.notification, "Notifications", 2),
                    ),
                    Expanded(
                      child: _buildNavItem(AppImages.profile, "Profile", 3),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                top: 0,
                left: indicatorLeft.clamp(0.0, constraints.maxWidth - indicatorWidth),
                child: Container(
                  width: indicatorWidth,
                  height: 5,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isSelected ? selectedColor : unselectedColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.raleway,
              fontWeight: FontWeight.w600,
              fontSize: 10,
              height: 1.0,
              color: isSelected ? selectedColor : unselectedColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton() {
    return Transform.translate(
      offset: const Offset(0, -6),
      child: Container(
        width: 33.06,
        height: 33.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFF808191), width: 1.2),
          color: Colors.transparent,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.add,
          size: 20,
          color: Color(0xFF808191),
        ),
      ),
    );
  }
}
