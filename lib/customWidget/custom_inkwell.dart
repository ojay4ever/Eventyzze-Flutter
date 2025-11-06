import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomInkWell extends StatelessWidget {
  final Widget child;
  final Widget screen;
  final VoidCallback? onTap;

  const CustomInkWell({
    super.key,
    required this.child,
    required this.screen,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            Get.to(
              screen,
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
            );
          },
      child: child,
    );
  }
}
