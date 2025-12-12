import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/config/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onCenterButtonTap;
  final Color selectedColor;
  final Color unselectedColor;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onCenterButtonTap,
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
          final double indicatorLeft =
              currentIndex * slotWidth + (slotWidth - indicatorWidth) / 2;

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
                    Expanded(child: _buildNavItem(AppImages.home, "Home", 0)),
                    Expanded(
                      child: _buildNavItem(AppImages.heart, "Favourite", 1),
                    ),
                    Expanded(
                      child: _buildCenterButton(
                        isSelected: currentIndex == 2,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        AppImages.notification,
                        "Notifications",
                        3,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(AppImages.profile, "Profile", 4),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                top: 0,
                left: indicatorLeft.clamp(
                  0.0,
                  constraints.maxWidth - indicatorWidth,
                ),
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

  Widget _buildCenterButton({required bool isSelected}) {
    return Transform.translate(
      offset: const Offset(0, -6),
      child: GestureDetector(
        onTap: onCenterButtonTap ?? () => onTap(2),
        child: Container(
          width: 33.06,
          height: 33.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: isSelected ? selectedColor : Colors.white,
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : const Color(0xFF808191),
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            size: 20,
            color: isSelected
                ? Colors.black
                : const Color(0xFF808191),
          ),
        ),
      ),
    );
  }
}
